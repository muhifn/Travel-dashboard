-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: db_agen_perjalanan
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(256) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','2024-12-29 02:22:03');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel` (
  `id_hotel` int NOT NULL AUTO_INCREMENT,
  `nama_hotel` varchar(100) NOT NULL,
  `jenis_hotel` enum('Budget','Business','Luxury') NOT NULL,
  `biaya_hotel` decimal(10,2) NOT NULL,
  `deskripsi_hotel` text,
  `alamat_hotel` text NOT NULL,
  `id_tujuan` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_hotel`),
  KEY `id_tujuan` (`id_tujuan`),
  CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`id_tujuan`) REFERENCES `tujuan` (`id_tujuan`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel` VALUES (1,'The St. Regis Bali Resort','Luxury',5500000.00,'Resort mewah dengan pantai pribadi dan laguna air asin','Kawasan Pariwisata Nusa Dua Lot S6, Bali',1,'2024-12-28 13:48:44'),(2,'Four Seasons Resort Bali at Jimbaran Bay','Luxury',4800000.00,'Vila bergaya Bali dengan pemandangan teluk','Jimbaran, Kuta Selatan, Bali',1,'2024-12-28 13:48:44'),(3,'W Bali - Seminyak','Luxury',3800000.00,'Hotel modern dengan desain kontemporer','Jl. Petitenget, Seminyak, Bali',1,'2024-12-28 13:48:44'),(4,'Padma Resort Ubud','Luxury',2800000.00,'Resort di tengah hutan dengan infinity pool','Payangan, Gianyar, Bali',1,'2024-12-28 13:48:44'),(5,'Alila Seminyak','Luxury',3200000.00,'Hotel pantai dengan arsitektur modern','Seminyak, Bali',1,'2024-12-28 13:48:44'),(6,'The Phoenix Hotel Yogyakarta','Luxury',1800000.00,'Hotel bersejarah dengan arsitektur kolonial','Jl. Jenderal Sudirman 9, Yogyakarta',3,'2024-12-28 13:48:44'),(7,'Hyatt Regency Yogyakarta','Luxury',1500000.00,'Resort dengan lapangan golf dan pemandangan Gunung Merapi','Jl. Palagan Tentara Pelajar, Yogyakarta',3,'2024-12-28 13:48:44'),(8,'Hotel Tentrem Yogyakarta','Luxury',2000000.00,'Hotel mewah dengan sentuhan budaya Jawa','Jl. P. Mangkubumi 72A, Yogyakarta',3,'2024-12-28 13:48:44'),(9,'Royal Ambarrukmo Yogyakarta','Luxury',1600000.00,'Hotel mewah dengan sejarah kerajaan','Jl. Laksda Adisucipto 81, Yogyakarta',3,'2024-12-28 13:48:44'),(10,'Grand Aston Yogyakarta','Business',900000.00,'Hotel bisnis modern di pusat kota','Jl. Urip Sumoharjo 37, Yogyakarta',3,'2024-12-28 13:48:44'),(11,'The Oberoi Beach Resort, Lombok','Luxury',4200000.00,'Resort mewah dengan pantai pribadi','Medana Beach, Tanjung, Lombok',2,'2024-12-28 13:48:44'),(12,'Hotel Tugu Lombok','Luxury',3500000.00,'Hotel butik dengan sentuhan seni dan sejarah','Sire Beach, Tanjung, Lombok',2,'2024-12-28 13:48:44'),(13,'Katamaran Hotel & Resort','Business',1800000.00,'Resort modern dengan pemandangan pantai','Mangsit, Senggigi, Lombok',2,'2024-12-28 13:48:44'),(14,'Qunci Villas Hotel','Business',1500000.00,'Vila pribadi dengan suasana romantis','Mangsit Beach, Senggigi, Lombok',2,'2024-12-28 13:48:44'),(15,'Living Asia Resort','Budget',1200000.00,'Resort tepi pantai dengan suasana tropis','Senggigi Beach, Lombok',2,'2024-12-28 13:48:44'),(16,'Papua Paradise Eco Resort','Luxury',8500000.00,'Resort eksklusif dengan cottage di atas air','Pulau Birie, Raja Ampat',4,'2024-12-29 16:28:00'),(17,'Waiwo Dive Resort','Business',4500000.00,'Resort diving dengan akses langsung ke spot diving','Waiwo, Raja Ampat',4,'2024-12-29 16:28:00'),(18,'Meridian Adventure Marina','Luxury',7500000.00,'Marina resort modern dengan fasilitas diving lengkap','Waisai, Raja Ampat',4,'2024-12-29 16:28:00'),(19,'AYANA Komodo Resort','Luxury',6500000.00,'Resort mewah dengan pemandangan laut','Waecicu Beach, Labuan Bajo',5,'2024-12-29 16:28:00'),(20,'La Cecile Hotel','Business',2500000.00,'Hotel modern dengan infinity pool','Jl. Soekarno Hatta, Labuan Bajo',5,'2024-12-29 16:28:00'),(21,'Komodo Resort','Luxury',5500000.00,'Resort eksklusif dengan beach club','Sebayur Island, Labuan Bajo',5,'2024-12-29 16:28:00'),(22,'Toba Village Inn','Business',1200000.00,'Hotel dengan arsitektur Batak','Tuktuk Siadong, Samosir',6,'2024-12-29 16:28:00'),(23,'Samosir Villa Resort','Luxury',2800000.00,'Villa resort dengan pemandangan danau','Tuktuk, Samosir',6,'2024-12-29 16:28:00'),(24,'Toledo Inn','Budget',800000.00,'Penginapan nyaman dengan suasana lokal','Parapat, Danau Toba',6,'2024-12-29 16:28:00');
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pelanggan`
--

DROP TABLE IF EXISTS `pelanggan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelanggan` (
  `id_pelanggan` int NOT NULL AUTO_INCREMENT,
  `nama_pelanggan` varchar(100) NOT NULL,
  `no_hp_pelanggan` varchar(15) NOT NULL,
  `email_pelanggan` varchar(100) NOT NULL,
  `username_pelanggan` varchar(50) NOT NULL,
  `password_pelanggan` varchar(256) NOT NULL,
  `alamat_pelanggan` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pelanggan`),
  UNIQUE KEY `email_pelanggan` (`email_pelanggan`),
  UNIQUE KEY `username_pelanggan` (`username_pelanggan`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pelanggan`
--

LOCK TABLES `pelanggan` WRITE;
/*!40000 ALTER TABLE `pelanggan` DISABLE KEYS */;
INSERT INTO `pelanggan` VALUES (1,'Aditya Pratama','+6281234567890','aditya.pratama@gmail.com','adipra123','d08b7915ba1080bf9c83976a0dbc35bd59677ca600199149c8f6e978e5944a09','Jl. Sudirman No. 45, Jakarta','2024-12-29 16:37:40'),(2,'Budi Santoso','+6281298765432','budi.santoso@gmail.com','budsan456','1794a02f26bce8bc2f2ad950844d474bbde4648c4e691bd93370f75fb5381c65','Jl. Malioboro No. 12, Yogyakarta','2024-12-29 16:37:40'),(3,'Citra Dewi','+6285678901234','citra.dewi@gmail.com','citdew789','c9f246898e2e0f0c4ffe4300b7ed48b3420c02efbd84437a9631e13654ac7528','Jl. Asia Afrika No. 78, Bandung','2024-12-29 16:37:40'),(4,'Dimas Wijaya','+6287654321098','dimas.wijaya@gmail.com','dimwij321','54020a7b438d27f525a0e2990ff9726bf8bc241bdc37b76808ad74fab864db1d','Jl. Pemuda No. 56, Surabaya','2024-12-29 16:37:40'),(5,'Eka Putri','+6282345678901','eka.putri@gmail.com','ekaput654','33331d93f2d7f6fcca7d2e6dd06dd7330ea83d97161374194c3e5a95064a2f72','Jl. Gajah Mada No. 23, Medan','2024-12-29 16:37:40'),(6,'Fajar Ramadhan','+6289012345678','fajar.ramadhan@gmail.com','fajram987','7b49f6cc580dba90a4f1b0ad0f933b6fbe45ac2ea894c76ae44542269a3de146','Jl. Diponegoro No. 34, Semarang','2024-12-29 16:37:40'),(7,'Gita Safitri','+6283456789012','gita.safitri@gmail.com','gitsaf147','02bc1fd1d613ea67edc183455535b9855ed9096f15ec55d48bfeeebe25fcca1f','Jl. Ahmad Yani No. 89, Makassar','2024-12-29 16:37:40'),(8,'Hendra Gunawan','+6286789012345','hendra.gunawan@gmail.com','hengun258','e702bc8adf12f121da62dcc6487e2145d3705505d54faa950e63f6c1998732a4','Jl. Veteran No. 67, Palembang','2024-12-29 16:37:40'),(9,'Indah Permata','+6284567890123','indah.permata@gmail.com','indper369','9eba825e177b67fa4aead5b060fa1a61843d232239e26622bd63fb67943af010','Jl. Thamrin No. 90, Jakarta','2024-12-29 16:37:40'),(10,'Joko Widodo','+6288901234567','joko.widodo@gmail.com','jokwid741','f41ec76cfff446b572d948abe0db5776a209875c31c4ccf1f2625eda9b621e58','Jl. Pahlawan No. 12, Solo','2024-12-29 16:37:40'),(11,'Kartika Sari','+6281234567891','kartika.sari@gmail.com','karsar852','4f1fd03f13a258021d4322c5d813466b2ba2b7ad6782b4c63cb75ad642921600','Jl. Gatot Subroto No. 45, Denpasar','2024-12-29 16:37:40'),(12,'Lukman Hakim','+6281298765433','lukman.hakim@gmail.com','lukhak963','42eb893252462e47799b024975b6f480bc2f0fd8bb6e616989358e4acd7b9b80','Jl. Merdeka No. 78, Bandung','2024-12-29 16:37:40'),(13,'Maya Anggraini','+6285678901235','maya.anggraini@gmail.com','mayang159','60ac88039580f41cd9a1228f7d7653dfaf1942531e2e4c73204b7d18bcc2fb46','Jl. Imam Bonjol No. 34, Jakarta','2024-12-29 16:37:40'),(14,'Nanda Prasetyo','+6287654321099','nanda.prasetyo@gmail.com','nanpra753','b6336fb1f9c2b37d7925bdd676093b85188022b1512f28b21d9f2c3c4d17810d','Jl. Asia No. 56, Surabaya','2024-12-29 16:37:40'),(15,'Oscar Pratama','+6282345678902','oscar.pratama@gmail.com','oscpra951','44cd9165bca5f7d3411913d2dd2735e27523a69823e15a833bc902645622b76f','Jl. Sudirman No. 23, Medan','2024-12-29 16:37:40'),(16,'Putri Handayani','+6289012345679','putri.handayani@gmail.com','puthan357','48e4080587d8aa5e8272dc39d1674200fbc1719bdd75337887159309397737d5','Jl. Pemuda No. 89, Semarang','2024-12-29 16:37:40'),(17,'Rizal Fadillah','+6283456789013','rizal.fadillah@gmail.com','rizfad852','b6ded233c84b039caf2649f518655413344a63973bc86581122d803f5dbc9d94','Jl. Ahmad Yani No. 67, Makassar','2024-12-29 16:37:40'),(18,'Sinta Dewi','+6286789012346','sinta.dewi@gmail.com','sindew741','90d98db920aefb65887ba25ff7a5ff3b9e37ed09a5fb98680668053b17c77449','Jl. Asia Afrika No. 90, Palembang','2024-12-29 16:37:40'),(19,'Taufik Hidayat','+6284567890124','taufik.hidayat@gmail.com','tauhid159','279604664365be1abc06f01c2644dc2b5d90750dde712f7fb06f077fe6673aa7','Jl. Malioboro No. 12, Yogyakarta','2024-12-29 16:37:40'),(20,'Untung Setiawan','+6288901234568','untung.setiawan@gmail.com','untset753','c236e727eeddd83c0bc3809115594c99d16e991788c2a6b06f4d10608bb2b9b9','Jl. Gajah Mada No. 45, Jakarta','2024-12-29 16:37:40'),(21,'Vina Oktaviani','+6281234567892','vina.oktaviani@gmail.com','vinokt951','2fdbcaa16b00a1e59b0c655254631b0f386246df84889c0140fa9cd6ed8784e0','Jl. Diponegoro No. 78, Bandung','2024-12-29 16:37:40'),(22,'Wahyu Kurniawan','+6281298765434','wahyu.kurniawan@gmail.com','wahkur357','992498da01f4b94e15dd8da302d000722846c6090639ab27cd636ae68bd08762','Jl. Veteran No. 34, Surabaya','2024-12-29 16:37:40'),(23,'Yanti Susanti','+6285678901236','yanti.susanti@gmail.com','yansus852','a75f9d96ec0819637b3fb8dad63ecd9183968670a534a360597d4e7cbe70b8e7','Jl. Pahlawan No. 56, Medan','2024-12-29 16:37:40'),(24,'Bagus Prayogo','+6285234567890','bagus.prayogo@gmail.com','bagpra147','194363cd1134fada5ac680b2715fd95f58cba5d19c71cd031bd04fd8fdee0568','Jl. Merdeka No. 34, Malang','2024-12-29 16:37:40'),(25,'Lina Mariana','+6285345678901','lina.mariana@gmail.com','linmar258','1f3e164faf09f1ce30c9325b6288f859f26e43eaceaf1f7235bb46673e93797b','Jl. Pahlawan No. 67, Bandung','2024-12-29 16:37:40'),(26,'Rudi Hermawan','+6285456789012','rudi.hermawan@gmail.com','rudher369','32ccb74ceab055f8bbb3003961e69604b92a616216fc93f403aa680c67cc66aa','Jl. Sudirman No. 89, Jakarta','2024-12-29 16:37:40'),(27,'Nina Septiani','+6285567890123','nina.septiani@gmail.com','ninsep741','742ad2d72bf28b2ce01537f729bb9d16f1d71fa008548de73403cd0e504d5239','Jl. Gatot Subroto No. 12, Surabaya','2024-12-29 16:37:40'),(28,'Adi Nugroho','+6285678901234','adi.nugroho@gmail.com','adinug852','436fcd3b52f59a18a394798b21197872c7d3f35972de1592921a7bcbf56bf9b8','Jl. Asia Afrika No. 45, Bandung','2024-12-29 16:37:40'),(29,'Dewi Lestari','+6285789012345','dewi.lestari@gmail.com','dewles963','e3d2ae03f196693fbda963ea9dc7c6e75542ec7e73f21f7211bd8271461f01b3','Jl. Malioboro No. 78, Yogyakarta','2024-12-29 16:37:40'),(30,'Eko Prasetyo','+6285890123456','eko.prasetyo@gmail.com','ekopra159','47550a91abaa44c8037405ed5179091451884fc0d8fabae95ff229ccee97b100','Jl. Pemuda No. 34, Semarang','2024-12-29 16:37:40'),(31,'Ratna Sari','+6286234567890','ratna.sari@gmail.com','ratsar753','0a069cf56b2359e7459f9a6a99cc2369d4f06acbb8e98b1f86ad20e55a0187a8','Jl. Ahmad Yani No. 56, Malang','2024-12-29 16:37:40'),(32,'Yoga Pratama','+6286345678901','yoga.pratama@gmail.com','yogpra951','85f10bcd79602e9588b9866084a1861c3f01a0233b430c42450750f0d36cee62','Jl. Diponegoro No. 89, Jakarta','2024-12-29 16:37:40'),(33,'Wulan Sari','+6286456789012','wulan.sari@gmail.com','wulsar357','9fc6af0af62f6c859b4334ccb4002d6bae9fc5ea9db7d16ed975bc0583c6269a','Jl. Veteran No. 12, Surabaya','2024-12-29 16:37:40'),(34,'Sari Indah','+6286567890123','sari.indah@gmail.com','sarind852','a0abd9afca70798aadb5f9785e8b8c2ddaf7b0d6935cf8a021c0f72e56bb1fa1','Jl. Merdeka No. 45, Bandung','2024-12-29 16:37:40'),(35,'Tri Wahyuni','+6286678901234','tri.wahyuni@gmail.com','triwah741','cd897178f6b9c0c2b4d72b1ddbac34e1bf00540531e8bebf98d20f6be9112ce2','Jl. Asia No. 78, Jakarta','2024-12-29 16:37:40'),(36,'Dedi Kusnadi','+6286789012345','dedi.kusnadi@gmail.com','dedkus159','0584df7819ab17aec1f0752249179fabd02209da5761f17dde2ad1c0cbbb2aad','Jl. Sudirman No. 34, Yogyakarta','2024-12-29 16:37:40'),(37,'Rina Wati','+6286890123456','rina.wati@gmail.com','rinwat753','33ec77624e2f45f93cd93ca1eff42e6683b51170957800e8c96254299049ab1c','Jl. Pahlawan No. 56, Surabaya','2024-12-29 16:37:40');
/*!40000 ALTER TABLE `pelanggan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pembayaran`
--

DROP TABLE IF EXISTS `pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pembayaran` (
  `id_pembayaran` int NOT NULL AUTO_INCREMENT,
  `id_pemesanan_pembayaran` int NOT NULL,
  `id_pelanggan_pembayaran` int NOT NULL,
  `jumlah_pembayaran` decimal(10,2) NOT NULL,
  `metode_pembayaran` enum('Transfer Bank','Kartu Kredit','E-Wallet') NOT NULL,
  `status_pembayaran` enum('Pending','Success','Failed') NOT NULL DEFAULT 'Pending',
  `deskripsi_pembayaran` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pembayaran`),
  KEY `id_pemesanan_pembayaran` (`id_pemesanan_pembayaran`),
  KEY `id_pelanggan_pembayaran` (`id_pelanggan_pembayaran`),
  CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_pemesanan_pembayaran`) REFERENCES `pemesanan` (`id_pemesanan`),
  CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`id_pelanggan_pembayaran`) REFERENCES `pelanggan` (`id_pelanggan`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pembayaran`
--

LOCK TABLES `pembayaran` WRITE;
/*!40000 ALTER TABLE `pembayaran` DISABLE KEYS */;
INSERT INTO `pembayaran` VALUES (74,148,28,3875109.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(75,149,1,3056604.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(76,150,24,4713932.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(77,151,2,2136198.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(78,152,3,2537543.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(79,153,36,2772266.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(80,154,29,2128310.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(81,155,4,4585937.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(82,156,5,4416069.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(83,157,30,2337131.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(84,158,6,2433859.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(85,159,7,2221845.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(86,160,8,4657132.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(87,161,9,3841015.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(88,162,10,2772483.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(89,163,11,4355665.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(90,164,25,3020361.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(91,165,12,4129143.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(92,166,13,4726076.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(93,167,14,4098130.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(94,168,27,2531598.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(95,169,15,4683620.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(96,170,16,4655576.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(97,171,31,4441383.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(98,172,37,4243133.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(99,173,17,3456291.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(100,174,26,3315600.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(101,175,34,3569954.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(102,176,18,2401666.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(103,177,19,3017665.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(104,178,35,3917608.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(105,179,20,3664801.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(106,180,21,3602759.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(107,181,22,2438629.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(108,182,33,4539461.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(109,183,23,3729082.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(110,184,32,2797807.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(111,211,28,4619195.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(112,212,1,3342448.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(113,213,24,2385930.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(114,214,2,4886749.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(115,215,3,4657773.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(116,216,36,4187223.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(117,217,29,4597843.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(118,218,4,2663951.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(119,219,5,2712495.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(120,220,30,4629269.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(121,221,6,2968606.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(122,222,7,2578318.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(123,223,8,3653334.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(124,224,9,3513340.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(125,225,10,3916186.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(126,226,11,2810139.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(127,227,25,4170845.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(128,228,12,4150033.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(129,229,13,3019542.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(130,230,14,2489430.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(131,231,27,3169090.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(132,232,15,4640466.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(133,233,16,3137914.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(134,234,31,2051515.00,'E-Wallet','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(135,235,37,3001956.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(136,236,17,4762023.00,'Kartu Kredit','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(137,237,26,3775046.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(138,238,34,3110127.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(139,239,18,2005902.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(140,240,19,3325767.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(141,241,35,3186007.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(142,242,20,2475404.00,'E-Wallet','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(143,243,21,3129543.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(144,244,22,2485032.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(145,245,33,2514959.00,'Transfer Bank','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(146,246,23,3196826.00,'Kartu Kredit','Success','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14'),(147,247,32,4147709.00,'Transfer Bank','Failed','Pembayaran untuk pemesanan paket wisata','2024-12-29 16:51:14');
/*!40000 ALTER TABLE `pembayaran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pemesanan`
--

DROP TABLE IF EXISTS `pemesanan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pemesanan` (
  `id_pemesanan` int NOT NULL AUTO_INCREMENT,
  `id_hotel_pemesanan` int NOT NULL,
  `id_pelanggan_pemesanan` int NOT NULL,
  `id_taksi_pemesanan` int NOT NULL,
  `tanggal_checkin` date NOT NULL,
  `tanggal_checkout` date NOT NULL,
  `total_biaya` decimal(10,2) NOT NULL,
  `status_pemesanan` enum('Pending','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending',
  `judul_pemesanan` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pemesanan`),
  KEY `id_hotel_pemesanan` (`id_hotel_pemesanan`),
  KEY `id_pelanggan_pemesanan` (`id_pelanggan_pemesanan`),
  KEY `id_taksi_pemesanan` (`id_taksi_pemesanan`),
  CONSTRAINT `pemesanan_ibfk_1` FOREIGN KEY (`id_hotel_pemesanan`) REFERENCES `hotel` (`id_hotel`),
  CONSTRAINT `pemesanan_ibfk_2` FOREIGN KEY (`id_pelanggan_pemesanan`) REFERENCES `pelanggan` (`id_pelanggan`),
  CONSTRAINT `pemesanan_ibfk_3` FOREIGN KEY (`id_taksi_pemesanan`) REFERENCES `taksi` (`id_taksi`)
) ENGINE=InnoDB AUTO_INCREMENT=274 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pemesanan`
--

LOCK TABLES `pemesanan` WRITE;
/*!40000 ALTER TABLE `pemesanan` DISABLE KEYS */;
INSERT INTO `pemesanan` VALUES (148,4,28,32,'2025-01-24','2025-01-01',3875109.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(149,10,1,37,'2025-01-02','2025-01-16',3056604.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(150,6,24,42,'2025-01-20','2025-01-12',4713932.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(151,3,2,31,'2025-01-17','2025-01-06',2136198.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(152,14,3,42,'2025-01-02','2025-01-09',2537543.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(153,2,36,45,'2025-01-15','2024-12-31',2772266.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(154,1,29,36,'2025-01-18','2025-01-12',2128310.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:50:55'),(155,4,4,35,'2025-01-21','2025-01-01',4585937.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(156,1,5,34,'2024-12-30','2025-01-17',4416069.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(157,2,30,35,'2025-01-06','2025-01-11',2337131.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(158,1,6,35,'2025-01-06','2025-01-18',2433859.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(159,13,7,44,'2024-12-30','2025-01-13',2221845.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(160,1,8,33,'2025-01-17','2025-01-23',4657132.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(161,6,9,45,'2025-01-21','2025-01-29',3841015.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(162,13,10,34,'2025-01-17','2025-01-19',2772483.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(163,10,11,35,'2025-01-15','2025-01-03',4355665.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:50:55'),(164,2,25,40,'2024-12-30','2025-01-08',3020361.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(165,10,12,32,'2025-01-15','2025-01-20',4129143.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(166,4,13,44,'2025-01-23','2025-01-14',4726076.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(167,11,14,42,'2025-01-20','2025-01-11',4098130.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(168,4,27,35,'2025-01-16','2025-01-05',2531598.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(169,13,15,37,'2025-01-17','2025-01-29',4683620.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(170,7,16,34,'2025-01-18','2025-01-23',4655576.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(171,4,31,34,'2025-01-09','2025-01-05',4441383.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(172,12,37,42,'2025-01-13','2025-01-07',4243133.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:50:55'),(173,13,17,37,'2025-01-21','2025-01-16',3456291.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(174,14,26,45,'2025-01-26','2025-01-25',3315600.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(175,10,34,39,'2025-01-19','2025-01-27',3569954.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:50:55'),(176,6,18,32,'2025-01-06','2025-01-05',2401666.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(177,13,19,34,'2025-01-17','2025-01-13',3017665.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(178,8,35,37,'2025-01-15','2025-01-20',3917608.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:50:55'),(179,11,20,44,'2025-01-11','2025-01-17',3664801.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(180,4,21,43,'2025-01-10','2025-01-16',3602759.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:50:55'),(181,6,22,38,'2025-01-03','2025-01-16',2438629.00,'Confirmed','Wisata ke Bali','2024-12-29 16:50:55'),(182,15,33,42,'2025-01-27','2025-01-16',4539461.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(183,5,23,43,'2025-01-09','2025-01-10',3729082.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:50:55'),(184,7,32,34,'2025-01-24','2025-01-23',2797807.00,'Cancelled','Wisata ke Bali','2024-12-29 16:50:55'),(211,5,28,37,'2025-01-08','2025-01-11',4619195.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(212,6,1,39,'2025-01-22','2025-01-11',3342448.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(213,5,24,33,'2025-01-27','2025-01-12',2385930.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(214,6,2,35,'2025-01-12','2025-01-14',4886749.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(215,8,3,41,'2025-01-03','2025-01-20',4657773.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(216,2,36,41,'2025-01-06','2025-01-09',4187223.00,'Cancelled','Wisata ke Bali','2024-12-29 16:51:01'),(217,2,29,42,'2025-01-11','2025-01-01',4597843.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(218,4,4,34,'2025-01-05','2025-01-17',2663951.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(219,3,5,41,'2025-01-25','2025-01-18',2712495.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(220,10,30,41,'2025-01-19','2025-01-12',4629269.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(221,9,6,33,'2025-01-01','2025-01-04',2968606.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(222,8,7,36,'2025-01-11','2025-01-03',2578318.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(223,2,8,43,'2025-01-18','2025-01-27',3653334.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(224,4,9,42,'2025-01-05','2025-01-25',3513340.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(225,1,10,31,'2025-01-02','2025-01-18',3916186.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(226,6,11,42,'2025-01-23','2025-01-29',2810139.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(227,7,25,31,'2024-12-29','2025-01-28',4170845.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(228,7,12,39,'2025-01-09','2025-01-11',4150033.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(229,14,13,38,'2025-01-16','2025-01-19',3019542.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(230,5,14,40,'2025-01-10','2025-01-02',2489430.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(231,5,27,37,'2024-12-31','2025-01-03',3169090.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(232,1,15,43,'2024-12-29','2025-01-17',4640466.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(233,9,16,42,'2025-01-02','2025-01-10',3137914.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(234,4,31,36,'2025-01-04','2025-01-28',2051515.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(235,14,37,38,'2025-01-17','2025-01-25',3001956.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(236,14,17,35,'2025-01-23','2025-01-08',4762023.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(237,12,26,39,'2025-01-09','2025-01-10',3775046.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(238,9,34,45,'2024-12-29','2025-01-08',3110127.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(239,14,18,32,'2025-01-21','2025-01-20',2005902.00,'Confirmed','Wisata ke Bali','2024-12-29 16:51:01'),(240,1,19,33,'2025-01-16','2025-01-19',3325767.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(241,7,35,43,'2025-01-21','2025-01-10',3186007.00,'Cancelled','Wisata ke Lombok','2024-12-29 16:51:01'),(242,2,20,43,'2025-01-25','2025-01-29',2475404.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(243,6,21,39,'2025-01-18','2025-01-20',3129543.00,'Cancelled','Wisata ke Bali','2024-12-29 16:51:01'),(244,12,22,42,'2025-01-15','2025-01-17',2485032.00,'Confirmed','Wisata ke Yogyakarta','2024-12-29 16:51:01'),(245,7,33,44,'2025-01-07','2025-01-24',2514959.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(246,6,23,35,'2025-01-08','2025-01-26',3196826.00,'Confirmed','Wisata ke Lombok','2024-12-29 16:51:01'),(247,1,32,45,'2025-01-16','2025-01-09',4147709.00,'Cancelled','Wisata ke Yogyakarta','2024-12-29 16:51:01');
/*!40000 ALTER TABLE `pemesanan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taksi`
--

DROP TABLE IF EXISTS `taksi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taksi` (
  `id_taksi` int NOT NULL AUTO_INCREMENT,
  `nama_taksi` varchar(100) NOT NULL,
  `jenis_taksi` varchar(50) DEFAULT NULL,
  `deskripsi_taksi` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `harga_taksi` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id_taksi`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taksi`
--

LOCK TABLES `taksi` WRITE;
/*!40000 ALTER TABLE `taksi` DISABLE KEYS */;
INSERT INTO `taksi` VALUES (31,'Bali Taxi Blue Bird','Economy','Taksi resmi dengan argometer','2024-12-28 13:50:30',250000.00),(32,'Bali Private Car','Business','Rental mobil dengan sopir berpengalaman','2024-12-28 13:50:30',850000.00),(33,'Bali VIP Transport','Luxury','Layanan transportasi mewah dengan mobil high-end','2024-12-28 13:50:30',1500000.00),(34,'Bali Scooter Rental','Economy','Rental motor untuk menjelajahi Bali','2024-12-28 13:50:30',150000.00),(35,'Bali Airport Transfer','Shuttle','Layanan antar jemput bandara','2024-12-28 13:50:30',350000.00),(36,'Yogya Taxi','Economy','Taksi lokal Yogyakarta dengan argometer','2024-12-28 13:50:30',200000.00),(37,'Royal Transport Yogya','Luxury','Transportasi wisata dengan guide','2024-12-28 13:50:30',1200000.00),(38,'Malioboro Transport','Business','Rental mobil untuk wisata kota','2024-12-28 13:50:30',750000.00),(39,'Yogya Heritage Tour','Tour','Transportasi untuk tur candi dan heritage','2024-12-28 13:50:30',900000.00),(40,'Airport Prambanan Shuttle','Shuttle','Shuttle ke objek wisata Prambanan','2024-12-28 13:50:30',300000.00),(41,'Lombok Taxi','Economy','Taksi resmi di Lombok','2024-12-28 13:50:30',250000.00),(42,'Gili Fast Boat','Boat','Transport boat ke pulau Gili','2024-12-28 13:50:30',500000.00),(43,'Lombok Private Driver','Business','Rental mobil dengan sopir lokal','2024-12-28 13:50:30',800000.00),(44,'Senggigi Transport','Luxury','Transportasi wisata area Senggigi','2024-12-28 13:50:30',1300000.00),(45,'Kuta Lombok Shuttle','Shuttle','Shuttle untuk area Kuta Lombok','2024-12-28 13:50:30',350000.00),(46,'Raja Ampat Speed Boat','Luxury','Speed boat pribadi untuk island hopping','2024-12-29 16:28:16',2000000.00),(47,'Raja Ampat Ferry','Economy','Ferry reguler antar pulau','2024-12-29 16:28:16',500000.00),(48,'Paradise Dive Transport','Business','Boat untuk diving trip','2024-12-29 16:28:16',1500000.00),(49,'Komodo Speed Boat','Luxury','Speed boat untuk trip Komodo','2024-12-29 16:28:16',1800000.00),(50,'Bajo Local Transport','Economy','Transport darat dalam kota','2024-12-29 16:28:16',300000.00),(51,'Island Hopping Boat','Business','Boat untuk mengunjungi pulau-pulau','2024-12-29 16:28:16',1200000.00),(52,'Toba Ferry Service','Economy','Ferry reguler ke Samosir','2024-12-29 16:28:16',100000.00),(53,'Parapat Private Car','Business','Mobil pribadi dengan sopir','2024-12-29 16:28:16',800000.00),(54,'Samosir Tour Bus','Economy','Bus wisata keliling Samosir','2024-12-29 16:28:16',400000.00);
/*!40000 ALTER TABLE `taksi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tujuan`
--

DROP TABLE IF EXISTS `tujuan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tujuan` (
  `id_tujuan` int NOT NULL AUTO_INCREMENT,
  `nama_tujuan` varchar(100) NOT NULL,
  `deskripsi` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tujuan`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tujuan`
--

LOCK TABLES `tujuan` WRITE;
/*!40000 ALTER TABLE `tujuan` DISABLE KEYS */;
INSERT INTO `tujuan` VALUES (1,'Bali','Pulau dewata dengan keindahan alam dan budaya yang menakjubkan','2024-12-28 13:43:16'),(2,'Lombok','Destinasi eksotis dengan pantai-pantai yang memukau','2024-12-28 13:43:16'),(3,'Yogyakarta','Kota budaya dengan warisan sejarah yang kaya','2024-12-28 13:43:16'),(4,'Raja Ampat','Surga diving dengan keindahan bawah laut yang menakjubkan','2024-12-29 16:27:29'),(5,'Labuan Bajo','Rumah dari Komodo dan pemandangan laut yang eksotis','2024-12-29 16:27:29'),(6,'Danau Toba','Danau vulkanik terbesar di Asia Tenggara dengan budaya Batak yang kental','2024-12-29 16:27:29'),(7,'Bandung','Kota kreatif dengan kuliner dan fashion yang terkenal','2024-12-29 16:27:29'),(8,'Malang','Kota sejuk dengan berbagai destinasi alam dan sejarah','2024-12-29 16:27:29'),(9,'Toraja','Destinasi budaya dengan ritual adat yang unik','2024-12-29 16:27:29'),(10,'Dieng','Dataran tinggi dengan candi dan pemandangan alam yang indah','2024-12-29 16:27:29'),(11,'Wakatobi','Surga snorkeling dengan terumbu karang terbaik','2024-12-29 16:27:29'),(12,'Bromo','Gunung berapi ikonik dengan pemandangan matahari terbit yang memukau','2024-12-29 16:27:29'),(13,'Belitung','Pulau dengan pantai berbatu granite dan air yang jernih','2024-12-29 16:27:29');
/*!40000 ALTER TABLE `tujuan` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-29 23:53:06
