# ============================================================
# INITIAL SETUP AND IMPORTS
# ============================================================
# Import library yang dibutuhkan untuk membuat aplikasi web dengan Streamlit
# Import library yang dibutuhkan untuk membuat aplikasi web dengan Streamlit
import streamlit as st            # Framework web utama
import time                       # Untuk manajemen waktu
import plotly.graph_objects as go # Untuk membuat grafik dan visualisasi
import plotly                     # Library grafik interaktif
import mysql.connector            # Koneksi ke database MySQL
import pandas as pd              # Untuk manipulasi data
import requests                  # Untuk HTTP requests
from streamlit_lottie import st_lottie  # Animasi Lottie
from datetime import datetime    # Manajemen tanggal dan waktu
import hashlib                   # Untuk enkripsi password
import base64                    # Encoding/decoding data
from fpdf import FPDF           # Membuat file PDF
import io                       # Input/output operasi

# ============================================================
# DATABASE CONFIGURATION
# ============================================================
# Konfigurasi koneksi database MySQL
# Menyimpan informasi koneksi seperti username, password, host, dll.
config = {
    'user': 'root',            # Username database
    'password': '1234',        # Password database
    'host': 'localhost',       # Alamat host database
    'port': 3308,             # Port MySQL
    'database': 'db_agen_perjalanan'  # Nama database
}

# ============================================================
# AUTHENTICATION AND SECURITY FUNCTIONS
# ============================================================
# Mengenkripsi password dengan SHA-256
def encrypt_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Membuat koneksi ke database
def create_connection():
    return mysql.connector.connect(**config)

# Verifikasi login user atau admin
def authenticate_user(db, username, password, is_admin=False):
    cursor = db.cursor()
    encrypted_pass = encrypt_password(password)
    # Gunakan query berbeda untuk admin dan user biasa
    if is_admin:
        query = "SELECT * FROM admin WHERE username = %s AND password = %s"
    else:
        query = "SELECT * FROM pelanggan WHERE username_pelanggan = %s AND password_pelanggan = %s"
    cursor.execute(query, (username, encrypted_pass))
    return cursor.fetchone()

# Mendaftarkan user baru
def register_user(db, nama, hp, email, username, password, alamat):
    cursor = db.cursor()
    try:
        encrypted_pass = encrypt_password(password)
        # Query untuk menyimpan data user baru
        query = """
        INSERT INTO pelanggan (nama_pelanggan, no_hp_pelanggan, email_pelanggan, 
                             username_pelanggan, password_pelanggan, alamat_pelanggan)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (nama, hp, email, username, encrypted_pass, alamat))
        db.commit()
        return True, "Registrasi berhasil!"
    except mysql.connector.Error as err:
        return False, f"Error: {err}"

def load_lottie(url):
    r = requests.get(url)
    if r.status_code != 200:
        return None
    return r.json()

# Validasi format nama (min 3 karakter, hanya huruf)
def validate_name(name):
    """Validasi nama minimal 3 karakter dan hanya huruf"""
    if len(name) < 3:
        return False, "Nama harus minimal 3 karakter"
    if not name.replace(" ", "").isalpha():
        return False, "Nama hanya boleh berisi huruf"
    return True, "Valid"

# Validasi kekuatan password
def validate_password(password):
    """
    Validasi password:
    - Minimal 8 karakter
    - Harus mengandung huruf besar
    - Harus mengandung huruf kecil
    - Harus mengandung angka
    - Harus mengandung karakter spesial
    """
    if len(password) < 8:
        return False, "Password harus minimal 8 karakter"
    if not any(c.isupper() for c in password):
        return False, "Password harus mengandung minimal 1 huruf besar"
    if not any(c.islower() for c in password):
        return False, "Password harus mengandung minimal 1 huruf kecil"
    if not any(c.isdigit() for c in password):
        return False, "Password harus mengandung minimal 1 angka"
    if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
        return False, "Password harus mengandung minimal 1 karakter spesial"
    return True, "Valid"

# Validasi nomor telepon untuk ID/MY/SG
def validate_phone(phone):
    """
    Validasi nomor telepon:
    - Indonesia: +62 atau 08, 10-13 digit
    - Malaysia: +60 atau 0, 9-10 digit
    - Singapore: +65, 8 digit
    """
    # Remove all spaces and dashes
    phone = phone.replace(" ", "").replace("-", "")

    # Indonesia
    if phone.startswith("+62") or phone.startswith("08"):
        if phone.startswith("+62"):
            phone = phone[3:]  # Remove +62
        elif phone.startswith("0"):
            phone = phone[1:]  # Remove 0
        if not (9 <= len(phone) <= 12) or not phone.isdigit():
            return False, "Nomor Indonesia harus 10-13 digit setelah kode negara"
        return True, "Valid"

    # Malaysia
    elif phone.startswith("+60"):
        phone = phone[3:]  # Remove +60
        if not (8 <= len(phone) <= 9) or not phone.isdigit():
            return False, "Nomor Malaysia harus 9-10 digit setelah kode negara"
        return True, "Valid"

    # Singapore
    elif phone.startswith("+65"):
        phone = phone[3:]  # Remove +65
        if len(phone) != 8 or not phone.isdigit():
            return False, "Nomor Singapore harus 8 digit setelah kode negara"
        return True, "Valid"

    return False, "Format nomor tidak valid. Gunakan format: +62xxx, +60xxx, atau +65xxx"

# Validasi format email dan domain
def validate_email(email):
    """
    Validasi email:
    - Harus mengandung @
    - Harus mengandung domain yang valid
    - Harus sesuai format email standar
    """
    import re

    # Basic email pattern
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    if not re.match(pattern, email):
        return False, "Format email tidak valid"

    # Validasi domain umum
    valid_domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com']
    domain = email.split('@')[1].lower()

    # Jika menggunakan domain perusahaan/institusi, minimal panjang domain 4 karakter
    if domain not in valid_domains and len(domain.split('.')[0]) < 4:
        return False, "Gunakan email dengan domain yang valid"

    return True, "Valid"

# Mengambil data destinasi wisata
def get_destinations(db):
    cursor = db.cursor()
    cursor.execute("SELECT * FROM tujuan")  # Updated table name
    return cursor.fetchall()

# Menambah destinasi baru (admin only)
def add_destination(db, nama, deskripsi):
    cursor = db.cursor()
    try:
        query = "INSERT INTO tujuan (nama_tujuan, deskripsi) VALUES (%s, %s)"  # Updated column names
        cursor.execute(query, (nama, deskripsi))
        db.commit()
        return True, "Tujuan berhasil ditambahkan!"
    except mysql.connector.Error as err:
        return False, f"Error: {err}"

# Mengambil data hotel, opsional filter by destinasi
def get_hotels(db, destination_id=None):
    cursor = db.cursor()
    if destination_id:
        cursor.execute("SELECT * FROM hotel WHERE id_tujuan = %s", (destination_id,))
    else:
        cursor.execute("SELECT * FROM hotel")
    return cursor.fetchall()

# Menambah hotel baru (admin only)
def add_hotel(db, nama, tipe, biaya, destinasi_id, alamat, deskripsi):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO hotel (nama_hotel, jenis_hotel, biaya_hotel, id_tujuan, 
                         alamat_hotel, deskripsi_hotel)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (nama, tipe, biaya, destinasi_id, alamat, deskripsi))
        db.commit()
        return True, "Hotel berhasil ditambahkan!"
    except mysql.connector.Error as err:
        return False, f"Error: {err}"

# Mengambil data transportasi
def get_transport(db):
    cursor = db.cursor()
    cursor.execute("SELECT * FROM taksi")
    return cursor.fetchall()

# Mengambil biaya transport
def get_transport_cost(db, transport_id):
    cursor = db.cursor()
    cursor.execute("SELECT harga_taksi FROM taksi WHERE id_taksi = %s", (transport_id,))
    result = cursor.fetchone()
    return float(result[0]) if result else 0.0

# Menambah transport baru (admin only)
def add_transport(db, nama, tipe, deskripsi):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO taksi (nama_taksi, jenis_taksi, deskripsi_taksi)
        VALUES (%s, %s, %s)
        """
        cursor.execute(query, (nama, tipe, deskripsi))
        db.commit()
        return True, "Transport berhasil ditambahkan!"
    except mysql.connector.Error as err:
        return False, f"Error: {err}"

# Membuat pemesanan baru
def create_booking(db, hotel_id, user_id, transport_id, checkin, checkout, total_cost, title):
    cursor = db.cursor()
    try:
        # Buat pemesanan baru
        query = """
        INSERT INTO pemesanan (
            id_hotel_pemesanan, 
            id_pelanggan_pemesanan,
            id_taksi_pemesanan, 
            tanggal_checkin, 
            tanggal_checkout,
            total_biaya, 
            judul_pemesanan, 
            status_pemesanan
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, 'Pending')
        """
        cursor.execute(query, (
            hotel_id,
            user_id,
            transport_id,
            checkin,
            checkout,
            total_cost,
            title
        ))

        booking_id = cursor.lastrowid
        db.commit()
        return True, booking_id, "Pemesanan berhasil dibuat!"
    except mysql.connector.Error as err:
        return False, None, f"Error: {err}"

# Memproses pembayaran
def create_payment(db, booking_id, user_id, amount, payment_method, description):
    cursor = db.cursor()
    try:
        # Create payment record
        payment_query = """
        INSERT INTO pembayaran (
            id_pemesanan_pembayaran, 
            id_pelanggan_pembayaran,
            jumlah_pembayaran, 
            metode_pembayaran, 
            deskripsi_pembayaran, 
            status_pembayaran
        ) VALUES (%s, %s, %s, %s, %s, 'Success')
        """
        cursor.execute(payment_query, (booking_id, user_id, amount, payment_method, description))

        # Update booking status to Confirmed
        update_query = """
        UPDATE pemesanan 
        SET status_pemesanan = 'Confirmed'
        WHERE id_pemesanan = %s AND id_pelanggan_pemesanan = %s
        """
        cursor.execute(update_query, (booking_id, user_id))

        db.commit()
        return True, "Pembayaran berhasil diproses!"
    except mysql.connector.Error as err:
        db.rollback()  # Rollback jika terjadi error
        return False, f"Error: {err}"

# Mengambil riwayat pemesanan user
def get_booking_history(db, user_id):
    cursor = db.cursor()
    try:
        # Query untuk mengambil detail pemesanan
        query = """
        SELECT 
            p.id_pemesanan,
            h.nama_hotel,
            t.nama_taksi,
            p.tanggal_checkin,
            p.tanggal_checkout,
            p.total_biaya,
            p.created_at,
            p.status_pemesanan,
            pb.status_pembayaran,
            p.judul_pemesanan,
            tj.nama_tujuan
        FROM pemesanan p
        JOIN hotel h ON p.id_hotel_pemesanan = h.id_hotel
        JOIN taksi t ON p.id_taksi_pemesanan = t.id_taksi
        JOIN tujuan tj ON h.id_tujuan = tj.id_tujuan
        LEFT JOIN pembayaran pb ON p.id_pemesanan = pb.id_pemesanan_pembayaran
        WHERE p.id_pelanggan_pemesanan = %s
        ORDER BY p.created_at DESC
        """
        cursor.execute(query, (user_id,))
        bookings = cursor.fetchall()
        return bookings
    except mysql.connector.Error as err:
        st.error(f"Error mengambil riwayat pemesanan: {err}")
        return []

# Menampilkan riwayat pemesanan di UI
def show_booking_history(db, user_id):
    st.header("Riwayat Pemesanan")
    bookings = get_booking_history(db, user_id)

    if bookings:
        for booking in bookings:
            with st.container():
                col1, col2 = st.columns([2, 1])

                with col1:
                    st.subheader(f"{booking[9] or 'Pemesanan #' + str(booking[0])}")
                    st.write(f"📍 Tujuan: {booking[10]}")
                    st.write(f"🏨 Hotel: {booking[1]}")
                    st.write(f"🚗 Transport: {booking[2]}")

                with col2:
                    st.write(f"Check-in: {booking[3].strftime('%Y-%m-%d')}")
                    st.write(f"Check-out: {booking[4].strftime('%Y-%m-%d')}")
                    st.write(f"Total: Rp {float(booking[5]):,.2f}")
                    st.write(f"Tanggal Pesan: {booking[6].strftime('%Y-%m-%d %H:%M')}")

                col3, col4 = st.columns(2)
                with col3:
                    status_color = "green" if booking[7] == "Confirmed" else (
                        "red" if booking[7] == "Cancelled" else "orange")
                    st.markdown(f"Status Pemesanan: :{status_color}[{booking[7]}]")

                with col4:
                    payment_status = booking[8] or "Pending"
                    status_color = "green" if payment_status == "Success" else (
                        "red" if payment_status == "Failed" else "orange")
                    st.markdown(f"Status Pembayaran: :{status_color}[{payment_status}]")

                # Tampilkan opsi untuk pemesanan yang belum dibatalkan dan belum dibayar
                if booking[7] != "Cancelled" and (payment_status == "Pending" or payment_status is None):
                    st.write("---")
                    col5, col6 = st.columns(2)

                    with col5:
                        if st.button("💳 Bayar Sekarang", key=f"pay_{booking[0]}"):
                            payment_method = st.selectbox(
                                "Metode Pembayaran",
                                ["Transfer Bank", "Kartu Kredit", "E-Wallet"],
                                key=f"method_{booking[0]}"
                            )
                            if st.button("Konfirmasi Pembayaran", key=f"confirm_pay_{booking[0]}"):
                                success, message = retry_payment(
                                    db,
                                    booking[0],
                                    user_id,
                                    float(booking[5]),
                                    payment_method,
                                    f"Pembayaran untuk {booking[9]}"
                                )
                                if success:
                                    st.success(message)
                                    time.sleep(1)  # Berikan waktu untuk menampilkan pesan sukses
                                    st.rerun()
                                else:
                                    st.error(message)

                    with col6:
                        if st.button("❌ Batalkan Pesanan", key=f"cancel_{booking[0]}"):
                            if st.button("Konfirmasi Pembatalan", key=f"confirm_cancel_{booking[0]}"):
                                success, message = cancel_booking(db, booking[0])
                                if success:
                                    st.success(message)
                                    time.sleep(1)  # Berikan waktu untuk menampilkan pesan sukses
                                    st.rerun()
                                else:
                                    st.error(message)

                st.divider()
    else:
        st.info("Belum ada riwayat pemesanan")

def cancel_booking(db, booking_id):
    cursor = db.cursor()
    try:
        query = """
        UPDATE pemesanan 
        SET status_pemesanan = 'Cancelled'
        WHERE id_pemesanan = %s
        """
        cursor.execute(query, (booking_id,))
        db.commit()
        return True, "Pemesanan berhasil dibatalkan"
    except mysql.connector.Error as err:
        return False, f"Error: {err}"


def retry_payment(db, booking_id, user_id, amount, payment_method, description):
    cursor = db.cursor()
    try:
        # Update status pembayaran menjadi Success
        payment_query = """
        INSERT INTO pembayaran (
            id_pemesanan_pembayaran, 
            id_pelanggan_pembayaran,
            jumlah_pembayaran, 
            metode_pembayaran, 
            deskripsi_pembayaran, 
            status_pembayaran
        ) VALUES (%s, %s, %s, %s, %s, 'Success')
        """
        cursor.execute(payment_query, (booking_id, user_id, amount, payment_method, description))

        # Update status pemesanan menjadi Confirmed
        update_query = """
        UPDATE pemesanan 
        SET status_pemesanan = 'Confirmed'
        WHERE id_pemesanan = %s
        """
        cursor.execute(update_query, (booking_id,))

        db.commit()
        return True, "Pembayaran berhasil diproses!"
    except mysql.connector.Error as err:
        db.rollback()
        return False, f"Error: {err}"

def cancel_booking(db, booking_id):
    cursor = db.cursor()
    try:
        # Update status pemesanan menjadi Cancelled
        query = """
        UPDATE pemesanan 
        SET status_pemesanan = 'Cancelled'
        WHERE id_pemesanan = %s
        """
        cursor.execute(query, (booking_id,))

        # Update status pembayaran jika ada
        payment_query = """
        UPDATE pembayaran 
        SET status_pembayaran = 'Cancelled'
        WHERE id_pemesanan_pembayaran = %s
        """
        cursor.execute(payment_query, (booking_id,))

        db.commit()
        return True, "Pemesanan berhasil dibatalkan"
    except mysql.connector.Error as err:
        db.rollback()
        return False, f"Error: {err}"

# Fungsi Generate Struk PDF
def generate_receipt_pdf(booking_data, payment_data, user_data):
    pdf = FPDF()
    pdf.add_page()

    # Header
    pdf.set_font('Arial', 'B', 16)
    pdf.cell(0, 10, 'STRUK PEMESANAN TRAVEL', 0, 1, 'C')
    pdf.line(10, 30, 200, 30)

    # Info Pelanggan
    pdf.set_font('Arial', '', 12)
    pdf.cell(0, 10, f'Nama Pelanggan: {user_data["nama"]}', 0, 1)
    pdf.cell(0, 10, f'No. Booking: #{booking_data["id"]}', 0, 1)
    pdf.cell(0, 10, f'Tanggal: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}', 0, 1)

    # Detail Pemesanan
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, 'Detail Pemesanan:', 0, 1)
    pdf.set_font('Arial', '', 12)
    pdf.cell(0, 10, f'Hotel: {booking_data["hotel"]}', 0, 1)
    pdf.cell(0, 10, f'Transport: {booking_data["transport"]}', 0, 1)
    pdf.cell(0, 10, f'Check-in: {booking_data["checkin"]}', 0, 1)
    pdf.cell(0, 10, f'Check-out: {booking_data["checkout"]}', 0, 1)

    # Rincian Biaya
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, 'Rincian Biaya:', 0, 1)
    pdf.set_font('Arial', '', 12)
    pdf.cell(0, 10, f'Biaya Hotel: Rp {booking_data["hotel_cost"]:,.2f}', 0, 1)
    pdf.cell(0, 10, f'Biaya Transport: Rp {booking_data["transport_cost"]:,.2f}', 0, 1)
    pdf.line(10, pdf.get_y(), 200, pdf.get_y())
    pdf.set_font('Arial', 'B', 12)
    pdf.cell(0, 10, f'Total Pembayaran: Rp {payment_data["amount"]:,.2f}', 0, 1)

    # Status
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, f'Status Pembayaran: {payment_data["status"]}', 0, 1)
    pdf.cell(0, 10, f'Metode Pembayaran: {payment_data["method"]}', 0, 1)

    return pdf


def admin_dashboard():
    st.title("Admin Dashboard")

    tab1, tab2, tab3, tab4 = st.tabs(["Visualisasi", "Tambah Tujuan", "Tambah Hotel", "Tambah Transport"])

    db = create_connection()

    with tab1:
        st.header("Visualisasi Data")
        cursor = db.cursor()

        # Simple Metrics Display
        cursor.execute("""
            SELECT COALESCE(SUM(total_biaya), 0) as total_pendapatan
            FROM pemesanan
            WHERE status_pemesanan = 'Confirmed'
        """)
        total_revenue = cursor.fetchone()[0]
        st.subheader("Total Pendapatan")
        st.write(f"Rp {float(total_revenue):,.2f}")

        st.markdown("---")  # Divider

        # Total Pesanan
        cursor.execute("SELECT COUNT(*) FROM pemesanan")
        total_orders = cursor.fetchone()[0]
        st.subheader("Total Pesanan")
        st.write(total_orders)

        st.markdown("---")  # Divider

        # Pesanan Bulan Ini
        cursor.execute("""
            SELECT COUNT(*) 
            FROM pemesanan 
            WHERE MONTH(created_at) = MONTH(CURRENT_DATE())
            AND YEAR(created_at) = YEAR(CURRENT_DATE())
        """)
        monthly_orders = cursor.fetchone()[0]
        st.subheader("Pesanan Bulan Ini")
        st.write(monthly_orders)

        st.markdown("---")  # Divider

        # Rata-rata Nilai Pesanan
        cursor.execute("""
            SELECT COALESCE(AVG(total_biaya), 0) 
            FROM pemesanan 
            WHERE status_pemesanan = 'Confirmed'
        """)
        avg_order_value = cursor.fetchone()[0]
        st.subheader("Rata-rata Nilai Pesanan")
        st.write(f"Rp {float(avg_order_value):,.2f}")

        st.markdown("---")  # Divider

        # Row 2 - Charts
        col1, col2 = st.columns(2)

        with col1:
            # Pie chart untuk pemesanan per tujuan
            cursor.execute("""
                SELECT t.nama_tujuan, COUNT(p.id_pemesanan) as jumlah_pemesanan
                FROM tujuan t
                JOIN hotel h ON t.id_tujuan = h.id_tujuan
                JOIN pemesanan p ON h.id_hotel = p.id_hotel_pemesanan
                GROUP BY t.id_tujuan, t.nama_tujuan
                ORDER BY jumlah_pemesanan DESC
            """)
            dest_data = cursor.fetchall()

            if dest_data:
                labels = [row[0] for row in dest_data]
                values = [row[1] for row in dest_data]

                fig1 = {
                    'data': [{
                        'labels': labels,
                        'values': values,
                        'type': 'pie',
                        'hole': 0.4,
                        'textfont': {'color': 'white'},
                        'hoverinfo': 'label+percent+value'
                    }],
                    'layout': {
                        'title': {
                            'text': 'Pemesanan per Tujuan',
                            'font': {'color': 'white'}
                        },
                        'showlegend': True,
                        'legend': {'font': {'color': 'white'}},
                        'paper_bgcolor': 'black',
                        'plot_bgcolor': 'black',
                        'height': 400,
                        'margin': {'t': 50, 'b': 40, 'l': 40, 'r': 40}
                    }
                }
                st.plotly_chart(fig1, use_container_width=True)

        with col2:
            # Pie chart untuk status pemesanan
            cursor.execute("""
                SELECT status_pemesanan, COUNT(*) as jumlah
                FROM pemesanan
                GROUP BY status_pemesanan
            """)
            status_data = cursor.fetchall()

            if status_data:
                labels = [row[0] for row in status_data]
                values = [row[1] for row in status_data]

                fig2 = {
                    'data': [{
                        'labels': labels,
                        'values': values,
                        'type': 'pie',
                        'hole': 0.4,
                        'textfont': {'color': 'white'},
                        'hoverinfo': 'label+percent+value'
                    }],
                    'layout': {
                        'title': {
                            'text': 'Status Pemesanan',
                            'font': {'color': 'white'}
                        },
                        'showlegend': True,
                        'legend': {'font': {'color': 'white'}},
                        'paper_bgcolor': 'black',
                        'plot_bgcolor': 'black',
                        'height': 400,
                        'margin': {'t': 50, 'b': 40, 'l': 40, 'r': 40}
                    }
                }
                st.plotly_chart(fig2, use_container_width=True)

        # Trend Chart
        st.subheader("Trend Pesanan & Pendapatan 6 Bulan Terakhir")
        cursor.execute("""
            SELECT 
                DATE_FORMAT(created_at, '%Y-%m') as bulan,
                COUNT(*) as jumlah_pesanan,
                SUM(total_biaya) as total_pendapatan
            FROM pemesanan
            WHERE created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
            GROUP BY DATE_FORMAT(created_at, '%Y-%m')
            ORDER BY bulan
        """)
        monthly_data = cursor.fetchall()

        if monthly_data:
            months = [row[0] for row in monthly_data]
            orders = [row[1] for row in monthly_data]
            revenue = [float(row[2]) for row in monthly_data]

            fig3 = {
                'data': [
                    {
                        'x': months,
                        'y': orders,
                        'type': 'scatter',
                        'mode': 'lines+markers',
                        'name': 'Jumlah Pesanan',
                        'line': {'color': '#6C63FF'},
                        'marker': {'size': 8}
                    },
                    {
                        'x': months,
                        'y': revenue,
                        'type': 'scatter',
                        'mode': 'lines+markers',
                        'name': 'Pendapatan',
                        'line': {'color': '#4CAF50'},
                        'marker': {'size': 8}
                    }
                ],
                'layout': {
                    'showlegend': True,
                    'xaxis': {
                        'gridcolor': '#333333',
                        'showgrid': True,
                        'color': 'white',
                        'title': {'text': 'Bulan', 'font': {'color': 'white'}}
                    },
                    'yaxis': {
                        'gridcolor': '#333333',
                        'showgrid': True,
                        'color': 'white',
                        'title': {'text': 'Jumlah Pesanan', 'font': {'color': 'white'}}
                    },
                    'paper_bgcolor': 'black',
                    'plot_bgcolor': 'black',
                    'height': 400,
                    'margin': {'t': 30, 'b': 40, 'l': 40, 'r': 40},
                    'font': {'color': 'white'},
                    'legend': {'font': {'color': 'white'}}
                }
            }
            st.plotly_chart(fig3, use_container_width=True)

        # Row 4 - Tabel Pemesanan Terbaru
        st.markdown("### Pemesanan Terbaru")
        cursor.execute("""
            SELECT 
                p.id_pemesanan,
                t.nama_tujuan,
                h.nama_hotel,
                tk.nama_taksi,
                p.total_biaya,
                p.status_pemesanan,
                p.created_at
            FROM pemesanan p
            JOIN hotel h ON p.id_hotel_pemesanan = h.id_hotel
            JOIN taksi tk ON p.id_taksi_pemesanan = tk.id_taksi
            JOIN tujuan t ON h.id_tujuan = t.id_tujuan
            ORDER BY p.created_at DESC
            LIMIT 10
        """)
        recent_bookings = cursor.fetchall()

        if recent_bookings:
            df = pd.DataFrame(
                recent_bookings,
                columns=['ID', 'Tujuan', 'Hotel', 'Transport', 'Total Biaya', 'Status', 'Tanggal Pesan']
            )
            df['Total Biaya'] = df['Total Biaya'].apply(lambda x: f"Rp {float(x):,.2f}")
            df['Tanggal Pesan'] = df['Tanggal Pesan'].apply(lambda x: x.strftime('%Y-%m-%d %H:%M'))
            st.dataframe(df, use_container_width=True)

    with tab2:
        st.header("Tambah Tujuan Baru")
        with st.form("add_destination"):
            nama_dest = st.text_input("Nama Tujuan")
            desc_dest = st.text_area("Deskripsi")
            if st.form_submit_button("Tambah Tujuan"):
                success, message = add_destination(db, nama_dest, desc_dest)
                if success:
                    st.success(message)
                else:
                    st.error(message)

    with tab3:
        st.header("Tambah Hotel Baru")
        with st.form("add_hotel"):
            destinations = get_destinations(db)
            dest_options = {dest[1]: dest[0] for dest in destinations}

            nama_hotel = st.text_input("Nama Hotel")
            tipe_hotel = st.selectbox("Tipe Hotel", ["Budget", "Business", "Luxury"])
            biaya_hotel = st.number_input("Biaya per Malam", min_value=0)
            destinasi = st.selectbox("Tujuan", list(dest_options.keys()))
            alamat_hotel = st.text_area("Alamat Hotel")
            deskripsi_hotel = st.text_area("Deskripsi Hotel")

            if st.form_submit_button("Tambah Hotel"):
                success, message = add_hotel(
                    db, nama_hotel, tipe_hotel, biaya_hotel,
                    dest_options[destinasi], alamat_hotel, deskripsi_hotel
                )
                if success:
                    st.success(message)
                else:
                    st.error(message)

    with tab4:
        st.header("Tambah Transport Baru")
        with st.form("add_transport"):
            nama_transport = st.text_input("Nama Transport")
            tipe_transport = st.selectbox("Tipe Transport", ["Economy", "VIP", "Luxury"])
            desc_transport = st.text_area("Deskripsi")

            if st.form_submit_button("Tambah Transport"):
                success, message = add_transport(
                    db, nama_transport, tipe_transport, desc_transport
                )
                if success:
                    st.success(message)
                else:
                    st.error(message)

    # Add logout button for admin
    if st.sidebar.button("Admin Logout"):
        st.session_state.logged_in = False
        st.session_state.is_admin = False
        st.rerun()

    db.close()

# Fungsi utama aplikasi
def main():
    # Setup halaman
    st.set_page_config(page_title="Travel Booking System", layout="wide")
    # Inisialisasi state
    if 'logged_in' not in st.session_state:
        st.session_state.logged_in = False
        st.session_state.is_admin = False

    # Inisialisasi state pemesanan
    if 'booking_complete' not in st.session_state:
        st.session_state.booking_complete = False

    # Sidebar untuk Login/Register
    with st.sidebar:
        st.title("🌟 Travel Booking")
        tab1, tab2, tab3 = st.tabs(["Login", "Admin Login", "Register"])

        with tab1:
            if not st.session_state.logged_in:
                username = st.text_input("Username", key="user_login")
                password = st.text_input("Password", type="password", key="user_pass")
                if st.button("Login"):
                    db = create_connection()
                    user = authenticate_user(db, username, password)
                    if user:
                        st.session_state.logged_in = True
                        st.session_state.is_admin = False
                        st.session_state.user_id = user[0]
                        st.session_state.user_name = user[1]
                        st.success("Login berhasil!")
                        st.rerun()
                    else:
                        st.error("Username atau password salah!")
                    db.close()

        with tab2:
            if not st.session_state.logged_in:
                username = st.text_input("Admin Username", key="admin_login")
                password = st.text_input("Admin Password", type="password", key="admin_pass")
                if st.button("Login as Admin"):
                    db = create_connection()
                    admin = authenticate_user(db, username, password, is_admin=True)
                    if admin:
                        st.session_state.logged_in = True
                        st.session_state.is_admin = True
                        st.session_state.user_id = admin[0]
                        st.session_state.user_name = admin[1]
                        st.success("Admin login berhasil!")
                        st.rerun()
                    else:
                        st.error("Username atau password admin salah!")
                    db.close()

        with tab3:
            if not st.session_state.logged_in:
                with st.form("register_form"):
                    st.markdown("""
                    ### Petunjuk Registrasi
                    - Nama: Minimal 3 karakter, hanya huruf
                    - Password: Minimal 8 karakter, harus mengandung huruf besar, kecil, angka, dan karakter spesial
                    - Nomor HP: Gunakan format +62xxx (Indonesia), +60xxx (Malaysia), atau +65xxx (Singapore)
                    - Email: Gunakan email yang valid (gmail.com, yahoo.com, dll)
                    """)

                    nama = st.text_input("Nama Lengkap")
                    hp = st.text_input("Nomor HP (contoh: +62812xxxxx)")
                    email = st.text_input("Email")
                    username = st.text_input("Username")
                    password = st.text_input("Password", type="password",
                                             help="Min. 8 karakter, kombinasi huruf besar, kecil, angka, dan karakter spesial")
                    alamat = st.text_area("Alamat")

                    if st.form_submit_button("Register"):
                        # Validasi input
                        is_valid = True
                        messages = []

                        # Validasi nama
                        name_valid, name_msg = validate_name(nama)
                        if not name_valid:
                            is_valid = False
                            messages.append(f"Nama: {name_msg}")

                        # Validasi nomor HP
                        phone_valid, phone_msg = validate_phone(hp)
                        if not phone_valid:
                            is_valid = False
                            messages.append(f"Nomor HP: {phone_msg}")

                        # Validasi email
                        email_valid, email_msg = validate_email(email)
                        if not email_valid:
                            is_valid = False
                            messages.append(f"Email: {email_msg}")

                        # Validasi password
                        pass_valid, pass_msg = validate_password(password)
                        if not pass_valid:
                            is_valid = False
                            messages.append(f"Password: {pass_msg}")

                        if not alamat.strip():
                            is_valid = False
                            messages.append("Alamat tidak boleh kosong")

                        # Jika semua validasi berhasil
                        if is_valid:
                            db = create_connection()
                            success, message = register_user(
                                db, nama, hp, email, username, password, alamat
                            )
                            if success:
                                st.success(message)
                            else:
                                st.error(message)
                            db.close()
                        else:
                            # Tampilkan semua pesan error
                            st.error("Registrasi gagal:")
                            for msg in messages:
                                st.warning(msg)

    # Main Content
    if st.session_state.logged_in:
        if st.session_state.is_admin:
            admin_dashboard()
        else:
            db = create_connection()

            # Handle completed booking state
            if st.session_state.booking_complete:
                st.success("Pemesanan berhasil!")
                if st.button("Kembali ke Halaman Utama"):
                    # Reset all booking-related states
                    st.session_state.booking_complete = False
                    if 'selected_destination' in st.session_state:
                        del st.session_state.selected_destination
                    if 'selected_hotel' in st.session_state:
                        del st.session_state.selected_hotel
                    if 'selected_transport' in st.session_state:
                        del st.session_state.selected_transport
                    st.rerun()
            else:
                bookings_tab1, bookings_tab2 = st.tabs(["Pemesanan Baru", "Riwayat Pemesanan"])

                with bookings_tab1:
                    st.title(f"Selamat Datang, {st.session_state.user_name}! 🌍")

                    # Pilih Tujuan
                    if 'selected_destination' not in st.session_state:
                        st.header("Pilih Tujuan Wisata")
                        destinations = get_destinations(db)
                        cols = st.columns(3)
                        for idx, dest in enumerate(destinations):
                            with cols[idx % 3]:
                                with st.container():
                                    st.subheader(dest[1])  # nama_tujuan
                                    st.write(dest[2])  # deskripsi
                                    if st.button(f"Pilih {dest[1]}", key=f"dest_{dest[0]}"):
                                        st.session_state.selected_destination = dest
                                        st.rerun()

                    # Tab untuk Pemesanan setelah memilih tujuan
                    elif 'selected_destination' in st.session_state:
                        st.header(f"Tujuan: {st.session_state.selected_destination[1]}")
                        book_tab1, book_tab2, book_tab3 = st.tabs(["Pilih Hotel", "Pilih Transport", "Pembayaran"])

                        with book_tab1:
                            st.header("Pilih Hotel")
                            hotels = get_hotels(db, st.session_state.selected_destination[0])
                            if hotels:
                                cols = st.columns(3)
                                for idx, hotel in enumerate(hotels):
                                    with cols[idx % 3]:
                                        with st.container():
                                            st.subheader(hotel[1])  # nama_hotel
                                            st.write(f"Tipe: {hotel[2]}")  # jenis_hotel
                                            st.write(f"Harga: Rp {hotel[3]:,.2f}/malam")  # biaya_hotel
                                            st.write(f"Deskripsi: {hotel[4]}")  # deskripsi_hotel
                                            st.write(f"Lokasi: {hotel[5]}")  # alamat_hotel
                                            if st.button(f"Pilih {hotel[1]}", key=f"hotel_{hotel[0]}"):
                                                st.session_state.selected_hotel = hotel
                                                st.rerun()

                        # Update bagian perhitungan biaya di book_tab3:
                        with book_tab2:
                            if 'selected_hotel' in st.session_state:
                                st.header("Pilih Transport")
                                transports = get_transport(db)
                                if transports:
                                    for transport in transports:
                                        col1, col2, col3 = st.columns([3, 2, 1])
                                        with col1:
                                            st.subheader(transport[1])  # nama_taksi
                                            st.write(transport[3])  # deskripsi
                                        with col2:
                                            st.write(f"Tipe: {transport[2]}")
                                            # Tambahkan tampilan harga transport
                                            transport_cost = get_transport_cost(db, transport[0])
                                            st.write(f"Harga: Rp {transport_cost:,.2f}")
                                        with col3:
                                            if st.button("Pilih", key=f"transport_{transport[0]}"):
                                                st.session_state.selected_transport = transport
                                                st.session_state.transport_cost = transport_cost  # Simpan biaya transport
                                                st.rerun()
                            else:
                                st.info("Silakan pilih hotel terlebih dahulu")

                        with book_tab3:
                            if 'selected_hotel' in st.session_state and 'selected_transport' in st.session_state:
                                st.header("Pembayaran")

                                col1, col2 = st.columns(2)
                                with col1:
                                    st.subheader("Detail Pemesanan")
                                    judul_pemesanan = st.text_input("Judul Pemesanan",
                                                                    value=f"Wisata ke {st.session_state.selected_destination[1]}")
                                    st.write(f"Tujuan: {st.session_state.selected_destination[1]}")
                                    st.write(f"Hotel: {st.session_state.selected_hotel[1]}")
                                    st.write(f"Transport: {st.session_state.selected_transport[1]}")

                                    checkin = st.date_input("Tanggal Check-in")
                                    checkout = st.date_input("Tanggal Check-out")

                                    metode_pembayaran = st.selectbox(
                                        "Metode Pembayaran",
                                        ["Transfer Bank", "Kartu Kredit", "E-Wallet"]
                                    )

                                    deskripsi_pembayaran = st.text_area(
                                        "Catatan Pembayaran",
                                        value="Pembayaran untuk pemesanan paket wisata"
                                    )

                                    # Update bagian perhitungan total di book_tab3:
                                    if checkin and checkout:
                                        if checkout <= checkin:
                                            st.error("Tanggal check-out harus setelah tanggal check-in!")
                                        else:
                                            nights = (checkout - checkin).days
                                            hotel_cost = float(st.session_state.selected_hotel[3]) * float(nights)
                                            transport_cost = get_transport_cost(db,
                                                                                st.session_state.selected_transport[0])
                                            total_cost = hotel_cost + transport_cost

                                            st.write("---")
                                            st.write(f"Biaya Hotel ({nights} malam): Rp {hotel_cost:,.2f}")
                                            st.write(f"Biaya Transport: Rp {transport_cost:,.2f}")
                                            st.write(f"Total: Rp {total_cost:,.2f}")

                                            if st.button("Konfirmasi Pemesanan"):
                                                # Create booking
                                                success, booking_id, message = create_booking(
                                                    db,
                                                    st.session_state.selected_hotel[0],
                                                    st.session_state.user_id,
                                                    st.session_state.selected_transport[0],
                                                    checkin,
                                                    checkout,
                                                    total_cost,
                                                    judul_pemesanan
                                                )

                                                if success and booking_id:
                                                    # Create payment
                                                    payment_success, payment_message = create_payment(
                                                        db,
                                                        booking_id,
                                                        st.session_state.user_id,
                                                        total_cost,
                                                        metode_pembayaran,
                                                        deskripsi_pembayaran
                                                    )

                                                    # Update bagian pembuatan PDF receipt:
                                                    if payment_success:
                                                        transport_cost = get_transport_cost(db, st.session_state.selected_transport[0])
                                                        booking_data = {
                                                            "id": booking_id,
                                                            "hotel": st.session_state.selected_hotel[1],
                                                            "transport": st.session_state.selected_transport[1],
                                                            "checkin": checkin,
                                                            "checkout": checkout,
                                                            "hotel_cost": hotel_cost,
                                                            "transport_cost": transport_cost
                                                        }

                                                        payment_data = {
                                                            "amount": total_cost,
                                                            "status": "Success",
                                                            "method": metode_pembayaran
                                                        }

                                                        user_data = {
                                                            "nama": st.session_state.user_name
                                                        }

                                                        # Generate PDF
                                                        pdf = generate_receipt_pdf(booking_data, payment_data,
                                                                                   user_data)
                                                        pdf_bytes = pdf.output(dest='S').encode('latin-1')

                                                        # Tampilkan pesan sukses dan struk
                                                        st.success("Pemesanan dan pembayaran berhasil diproses!")

                                                        # Tombol download struk
                                                        st.download_button(
                                                            label="📥 Download Struk",
                                                            data=pdf_bytes,
                                                            file_name=f"struk_booking_{booking_id}.pdf",
                                                            mime="application/pdf"
                                                        )

                                                        # Tombol kembali ke pemesanan baru
                                                        if st.button("Pesan Lagi"):
                                                            if 'selected_destination' in st.session_state:
                                                                del st.session_state.selected_destination
                                                            if 'selected_hotel' in st.session_state:
                                                                del st.session_state.selected_hotel
                                                            if 'selected_transport' in st.session_state:
                                                                del st.session_state.selected_transport
                                                            st.rerun()
                                                    else:
                                                        st.error(f"Error pada pembayaran: {payment_message}")
                                                else:
                                                    st.error(message)

                                with col2:
                                    st.subheader("Informasi Tambahan")
                                    st.info("""
                                    📌 Informasi Penting:
                                    - Check-in mulai pukul 14:00
                                    - Check-out maksimal pukul 12:00
                                    - Pembayaran harus dilakukan segera
                                    - Batalkan minimal 24 jam sebelum check-in
                                    """)
                            else:
                                st.info("Silakan pilih hotel dan transport terlebih dahulu")

                with bookings_tab2:
                    show_booking_history(db, st.session_state.user_id)

            # Tombol Logout dengan reset state
            if st.sidebar.button("Logout"):
                # Reset semua state saat logout
                st.session_state.logged_in = False
                st.session_state.is_admin = False
                st.session_state.user_id = None
                st.session_state.user_name = None


                # Reset state pemesanan
                if 'selected_destination' in st.session_state:
                    del st.session_state.selected_destination
                if 'selected_hotel' in st.session_state:
                    del st.session_state.selected_hotel
                if 'selected_transport' in st.session_state:
                    del st.session_state.selected_transport
                if 'transport_cost' in st.session_state:
                    del st.session_state.transport_cost
                if 'booking_complete' in st.session_state:
                    st.session_state.booking_complete = False
                st.rerun()
            db.close()
    else:
        # Welcome Screen
        st.title("Selamat Datang di Travel Booking🌍")
        lottie_hello = load_lottie("https://lottie.host/bb6b6503-d50f-4953-80f5-753c23851089/6JC7wa8pJb.json")
        st_lottie(lottie_hello, height=300)
        st.write("Silakan login atau register untuk melakukan pemesanan.")


if __name__ == "__main__":
    main()