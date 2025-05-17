CREATE DATABASE  IF NOT EXISTS `plataforma_reservas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `plataforma_reservas`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: plataforma_reservas
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `asignacion_sede`
--

DROP TABLE IF EXISTS `asignacion_sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignacion_sede` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `idusuario` int NOT NULL,
  `idsede` int NOT NULL,
  `entrada` tinyint(1) DEFAULT '0',
  `salida` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idusuario` (`idusuario`),
  KEY `idsede` (`idsede`),
  CONSTRAINT `asignacion_sede_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `asignacion_sede_ibfk_2` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignacion_sede`
--

LOCK TABLES `asignacion_sede` WRITE;
/*!40000 ALTER TABLE `asignacion_sede` DISABLE KEYS */;
INSERT INTO `asignacion_sede` VALUES (4,'2025-05-12',5,2,0,0);
/*!40000 ALTER TABLE `asignacion_sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia`
--

DROP TABLE IF EXISTS `asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia` (
  `idasistencia` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `fecha` date NOT NULL,
  `hora_entrada` time DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`idasistencia`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia`
--

LOCK TABLES `asistencia` WRITE;
/*!40000 ALTER TABLE `asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_log`
--

DROP TABLE IF EXISTS `chatbot_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_log` (
  `idchatbot` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `pregunta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idchatbot`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `chatbot_log_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_log`
--

LOCK TABLES `chatbot_log` WRITE;
/*!40000 ALTER TABLE `chatbot_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `idestado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_aplicacion` enum('reserva','servicio','incidencia','pago','reembolso','taller','usuario') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idestado`),
  KEY `idx_estado_tipo` (`tipo_aplicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,'pendiente','Reserva pendiente de validaciÃ³n','reserva'),(2,'aprobada','Reserva aprobada por el administrador','reserva'),(3,'rechazada','Reserva rechazada por el administrador','reserva'),(4,'disponible','Servicio disponible para reservas','servicio'),(5,'reservado','Servicio reservado por un vecino en este horario','servicio'),(6,'en_mantenimiento','Servicio inhabilitado temporalmente por mantenimiento','servicio'),(7,'bloqueado','Bloqueo especial por evento o actividad programada','servicio'),(8,'inactivo','Servicio fuera de operaciÃ³n de forma indefinida','servicio'),(9,'reportado','Incidencia registrada por un coordinador','incidencia'),(10,'en_progreso','AcciÃ³n en curso para resolver la incidencia','incidencia'),(11,'solucionado','Incidencia resuelta satisfactoriamente','incidencia'),(12,'no_corresponde','Incidencia invalidada tras revisiÃ³n','incidencia'),(13,'crÃ­tico','Incidencia urgente con prioridad alta','incidencia'),(14,'pendiente','Pago pendiente de validaciÃ³n','pago'),(15,'confirmado','Pago validado y confirmado','pago'),(16,'rechazado','Pago rechazado por el administrador','pago'),(17,'reembolsado','Monto devuelto al usuario','pago'),(18,'no_pagado','Reserva sin pago registrado','pago');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_perfil`
--

DROP TABLE IF EXISTS `historial_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_perfil` (
  `idhistorial` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `campo_modificado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idhistorial`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `historial_perfil_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_perfil`
--

LOCK TABLES `historial_perfil` WRITE;
/*!40000 ALTER TABLE `historial_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario_atencion`
--

DROP TABLE IF EXISTS `horario_atencion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario_atencion` (
  `idhorario_atencion` int NOT NULL AUTO_INCREMENT,
  `idsede` int NOT NULL,
  `dia_semana` enum('Lunes','Martes','MiÃ©rcoles','Jueves','Viernes','SÃ¡bado','Domingo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idhorario_atencion`),
  KEY `idsede` (`idsede`),
  CONSTRAINT `horario_atencion_ibfk_1` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario_atencion`
--

LOCK TABLES `horario_atencion` WRITE;
/*!40000 ALTER TABLE `horario_atencion` DISABLE KEYS */;
INSERT INTO `horario_atencion` VALUES (1,1,'Lunes','08:00:00','20:00:00',1),(2,1,'Martes','08:00:00','20:00:00',1),(3,1,'MiÃ©rcoles','08:00:00','20:00:00',1),(4,1,'Jueves','08:00:00','20:00:00',1),(5,1,'Viernes','08:00:00','20:00:00',1),(6,1,'SÃ¡bado','08:00:00','15:00:00',1),(7,1,'Domingo','00:00:00','00:00:00',0),(8,2,'Lunes','08:00:00','20:00:00',1),(9,2,'Martes','08:00:00','20:00:00',1),(10,2,'MiÃ©rcoles','08:00:00','20:00:00',1),(11,2,'Jueves','08:00:00','20:00:00',1),(12,2,'Viernes','08:00:00','20:00:00',1),(13,2,'SÃ¡bado','08:00:00','15:00:00',1),(14,2,'Domingo','00:00:00','00:00:00',0),(15,3,'Lunes','08:00:00','20:00:00',1),(16,3,'Martes','08:00:00','20:00:00',1),(17,3,'MiÃ©rcoles','08:00:00','20:00:00',1),(18,3,'Jueves','08:00:00','20:00:00',1),(19,3,'Viernes','08:00:00','20:00:00',1),(20,3,'SÃ¡bado','08:00:00','15:00:00',1),(21,3,'Domingo','00:00:00','00:00:00',0),(22,4,'Lunes','08:00:00','20:00:00',1),(23,4,'Martes','08:00:00','20:00:00',1),(24,4,'MiÃ©rcoles','08:00:00','20:00:00',1),(25,4,'Jueves','08:00:00','20:00:00',1),(26,4,'Viernes','08:00:00','20:00:00',1),(27,4,'SÃ¡bado','08:00:00','15:00:00',1),(28,4,'Domingo','00:00:00','00:00:00',0);
/*!40000 ALTER TABLE `horario_atencion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario_disponible`
--

DROP TABLE IF EXISTS `horario_disponible`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario_disponible` (
  `idhorario` int NOT NULL AUTO_INCREMENT,
  `idhorario_atencion` int NOT NULL,
  `idservicio` int NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idhorario`),
  KEY `idhorario_atencion` (`idhorario_atencion`),
  KEY `idservicio` (`idservicio`),
  CONSTRAINT `horario_disponible_ibfk_1` FOREIGN KEY (`idhorario_atencion`) REFERENCES `horario_atencion` (`idhorario_atencion`),
  CONSTRAINT `horario_disponible_ibfk_2` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario_disponible`
--

LOCK TABLES `horario_disponible` WRITE;
/*!40000 ALTER TABLE `horario_disponible` DISABLE KEYS */;
INSERT INTO `horario_disponible` VALUES (1,1,1,'08:00:00','09:00:00',1),(2,1,1,'09:00:00','10:00:00',1),(3,2,1,'10:00:00','11:00:00',1),(4,2,1,'11:00:00','12:00:00',1),(5,3,1,'08:00:00','10:00:00',1);
/*!40000 ALTER TABLE `horario_disponible` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `idlog` int NOT NULL AUTO_INCREMENT,
  `idusuario` int DEFAULT NULL,
  `accion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tabla_afectada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idlog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_servicio`
--

DROP TABLE IF EXISTS `media_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_servicio` (
  `idmedia` int NOT NULL AUTO_INCREMENT,
  `idservicio` int NOT NULL,
  `tipo` enum('imagen','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idmedia`),
  KEY `idservicio` (`idservicio`),
  CONSTRAINT `media_servicio_ibfk_1` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_servicio`
--

LOCK TABLES `media_servicio` WRITE;
/*!40000 ALTER TABLE `media_servicio` DISABLE KEYS */;
INSERT INTO `media_servicio` VALUES (1,1,'imagen','https://ejemplo.com/piscina1.jpg'),(2,1,'imagen','https://ejemplo.com/piscina2.jpg'),(3,2,'imagen','https://ejemplo.com/gimnasio1.jpg'),(4,3,'imagen','https://ejemplo.com/cancha-futbol1.jpg'),(5,4,'imagen','https://ejemplo.com/cancha-voley1.jpg'),(6,5,'imagen','https://ejemplo.com/salon-eventos1.jpg'),(7,6,'imagen','https://ejemplo.com/taller-artesanal1.jpg');
/*!40000 ALTER TABLE `media_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacion`
--

DROP TABLE IF EXISTS `notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacion` (
  `idnotificacion` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idnotificacion`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (2,4,'Nueva reserva pendiente','Tienes una nueva reserva que aÃºn no ha sido confirmada, revÃ­sala en Mis Reservas',0,'2025-05-17 20:30:20');
/*!40000 ALTER TABLE `notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `idpago` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `monto` decimal(38,2) DEFAULT NULL,
  `metodo` enum('online','banco') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comprobante` longblob,
  `idestado` int NOT NULL,
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idreserva` int DEFAULT NULL,
  PRIMARY KEY (`idpago`),
  UNIQUE KEY `UKt51rgbdjlpfbmmkbd0scxapv4` (`idreserva`),
  KEY `idx_pago_idusuario` (`idusuario`),
  KEY `idx_pago_estado` (`idestado`),
  CONSTRAINT `FKg26xbgqq86wkv7finesrxwrft` FOREIGN KEY (`idreserva`) REFERENCES `reserva` (`idreserva`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (1,3,60.00,'online',NULL,15,'2025-05-13 04:40:00',NULL),(2,4,50.00,'banco',NULL,18,'2025-05-13 04:40:00',NULL),(3,4,15.00,'banco',_binary 'ÿ\Øÿ\à\0JFIF\0\0\0\0\0\0ÿ\Û\0„\0\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||§\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||§ÿ\Â\0@ \"\0ÿ\Ä\00\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ\Ú\0\0\0\0ôgÏ»p^¹\Æ\ÌRP,±2\Ô35%Šš±ó²	@,(\0‹e\ZÎ†v©q¢k#{\ç\ÓSZ—¦d¹®^~²YÏ¢1­…¶¢ÔŠ%¹ÇŠ^œ÷Û³Ñ¨‹Fu’,\"–(•L¶L…‰£sPgR3¼\Õ\0°¹²-\ÈÔš&¦‹¬\İg9%€\0\0%\0\Z\Å.±£\\úB\\R\Ø5Ó—mMS®s.jgR1m$\İ9·Ù \Ï3§—Æ±\ÛzÅ–‹D–Qe\0’ÀRP\0A¬\ÒÜŠ”!wK	Imn\Îy\é\ÍIbÊ¥šL¶1­dgY\"ˆ²€€T(\0ÒˆC@œûef¹ô5Û‡}gy\Öz\ç2\äD—W:³X¹5—^wnz\ÇU”²EZ²\Ä(€ÀŠD°@¨)“Y\"‰ \ÔZ\çm‰$4\Í*h¶,Ä–Q\0\0KB\r%¢U\0  X/~\çX\éÏ¦s,\\¬&ubnJq\ç\æÆµ½\ë\ZÎˆ¶Rºš¬‚¡\0\0°YD°Y¡,$U‹\0\n4–\0k:.uš\ÏN}:`À…Î‹e5\Ï\\Å€\0	D\0P-•	K-3wuƒKH\ÈĞ­wòú5¼õÏ®Y¹–\æ\ÒYÀ\ë\à\çÓK\é—((¢Q\0º–²Ae-”²Ä€¬\ì’\ä\"[`¢´ ”\Ö5›˜79\Ş%j\r0*\n…\0\n•\0»\Å6\É.if±£(H5Û‡}\Íå¸¥Ïƒ:\é\çŞ¸u»\å\Ó7¶Mâ‚¥²Ü…€`\Ò[$Ğ†eÖ³l@„–¥”·:.l-Í³\\õƒ¦1\Ñk5.ne3£|\î\r2]I\r3J\Ó#L24\Í4‰*CW#²fµ3¹\ê,µgn]5\\º\ç|ù\ç7„¯?h\Ş#Lô­\Ù7%-‚ ¨«²J\Ó#R\r25qS¥\åK”[¬TÔ‚ ¨-\ÍCW»s\Ï=#\Ìõ/?r¼=}#\Èõ.}ƒÇ¯Pñ\ã\Ş</pğ=\ãÁ}\Ã\Â÷\Ü</pñOxğ½\Ã\Äö\Ã\Æöö??`ùºú\Æö#\Èõ\Ø<{ô¬óóöJò\ç\Ø\Íù\×\è%ğ\ç\è—¯¤</t¯õ#\ÖO#\Ô_+\Ô<¯Hò½C\Ç}c\Èõ£\Èõ4õ4õC\Ìô5ô=\î<\î\ã…\ì8».\Ğõ¹N\Üû8\î»„;¸\î»€\î\à;^»€\ì\â®\Î#³‚;¸\î»€\ï8×Œ;8\Î#»€\íx\î»€\î\à;¸\î»€\íxC»€\ï8\î¼\â^\Î³ˆ\ì\â\Î#³ˆ\ì\â®\î»‚;¸+»€ô<\ã\ĞóÓ»€\î\àN\î»ˆ\íxS¤…°ƒV\ÌN…\Ãc\r\ÄÂ‰4\"ˆ¢5´\Ì\Ùqi\"ˆ¢4Œ´\\´2\Ğ\ËC-[L´2\Ğ\ËD\ËE\ËJÊ“-%Êˆ\n‚¡lR(Š%¢)\"„\Ô\"ˆ¢*¢ˆ¢ZH´\ÓiqØ^µv5‘MM9ï“ƒ¤—3c\rŒ60\Ø\Ãc\rŒ60\Ø\Ãc\rŒ60\Ø\Ãc\rŒ60\Ø\Ãc\rŒ60\Ü2\Ç\nô\Ïs¯v|#»˜\Û\Û\Ò+IJ,‹ˆ¢(”\"‰BPŠE–»O\n\Ïv|^3\×\ìóze›\á»:¹\Ó\Ñs«\Öc\Å\0\0\0\0\0\"Â€\0\0 \0I@\Ío\ä\Ñ\æ\Ï6z\ï‡8ôr\á–>§\ãı]½•\Æú\ŞZ®·³­\ç­M\Ü\Ô\ÕÍ«b¨J”\0\0\0\0\n”`ùÈ¹\Òz\ÓÓ™x^\È\ã\âú*_£\ß\Ë\êÜ°³œIjCL\Ãl\r°4\È\Ó4·#H*\n‚ ¨*\n€\n‚¶Z¼;ø\îü\ŞOG‡	5ÀMz\åğwúÿ\0+—£×®=8÷Ş±k¥Æ¬\é®z³zÆµ5s«-‚Ø²‚¥\0\0Ie€ù¥¹z¼ŞƒßfP‡\Ìú~	}~Œö\éœ6®m\Ã\rH“P€…\\¨ÊŒ´Œ´¬µL]-S\rŒ69¶2\Ø\Ãp\ËV±uN>o\ÊNÿ\03¯“¾Ş¾³\êv\å\è\á\è—\'ƒ\ÑW\á{<ıów©¬\îÕ²\êoQ¦µ\ê\Ì\İ[1v1v¬:nƒ›¨\ä\êNn£“¨\ä\ê9NÃ‹¨ùa/~£fP‹óş‡Ïšú=¸öé€®z”’Á,„°)`\0YP\0\0¢\Ï?ƒ\ßów\å|ß¿ñ\rşƒóÿ\0[—nœ½;—£·‡ºúüƒ\è|\ï©òó};\å¼ë¦±£ZÆ«¦¹\ïYŞ±­Mk\Z²\Ùj¥E”\nY@\0 @ùid½¸ö>w‰B/\Ïú>k\èö\ãÛ¦¤°„\ÈK¢`*PPB\ÌE\è\Í(@ œüÏ©\æ\ß7)\×^›ß†ñ\×ô>iÛ‡³\æx>¦\×\Å\îDß›¶³¯\êòzNºÆ±\Ów57¬kS¦±­M\Ü\Û5e²ØªŠY@\0X(H±A>Z#]¸õ>–:s–ˆ¿?\èx&¾‡n=úa.i J$²Á(€”\0¢¯œec\İ\ä–\ï‡C«:²‹\0\É*\ç\æ\ï\Ó\ãß—‡—\ßó³}_S\âı\\wßŸ\Ñ\åV¸tN³7Ÿo?‹\ë|Œ\ë×¾z\çÓ¦±£ZÆ«¦¹\ëY\é¬kSW:«e±eTYi,(\0X\0,>X’õ\å\Ôú|úc4\à÷ø&¾‡~ºb\Ë*K	*$°K¥€\0\0AE–¼÷—|\ë}9j\Ï6}\Ş9u¾¬\ê\æŠ¬Ï‹\İ\Ë\\ü_oy¼^\Ï\\ôûw|z¸ºÆ±½yû¸÷ù^\Ï°\ë¬k7sSzÆµ:kõ7slÖ³l¶*\ÙPR\n \0\0,–$½9ô>¦7Œ\Ğ/ƒ\ß\àšú¸÷é„ªÌ°B$°J  P\0YBò<ş=¦¨³[\å¤óg\İ\ãš\Öø\í:\ÜkR¥@ ¹“R\Ï—~oŸ\Ã\éü¸ú¿—ô\æøğõñš\Æñ¬\ïC—?ƒ\ì|f~†¸v\å\ÛzÆ—ZÆ¬\Şù\ïSzÆ¬\ÕÎµ-–\Ê\n\Ë)@\0\0°>X’ô\ç\Ğú˜\Ş%¾w†k\İ\èóú:a*³,!!,À\0/—\Õ\â^Û–,Z\Şùj\Ï6}¾<\ë{\á\Õ:3­J–À@\Ös\åõó¸ñxıy¼~w»Á\Ök\ëò\égO&:ò—®£^oV¹tø~ÿ\0¡=Z\ç¬uŞ³SzÆµ7¼kSw:³V]KeDª(@\'‰/‹\èü\Ì\ßH²ô\ç³\ës\é\ÎQa\á÷ø%÷z<ş™.j‚$°K\0\0¶ZÏ“¿<ë°°Q(–\rë¬ò\Ïg:\ë¾¢]J–\ä,’\Ë<œ}\ŞMù¾?gÎ¥\ïøÿ\0[=yy½¼&¹ô\å\×4——o‹\ì|cÙ®[\å×¦±¥Ö³l\Şùô\ÔŞ³­gV[-–¬T\0\0¨¢r\íón1ğ½>ÀÎ®ñ³\ës\é\ÎZ–/ƒ\ß\á—\Û\èóú:f\Ë+2Á,ˆ\0\0TYk\ÉÓ‡§:¢Å”\0\r\Ş},ñ\ß_7®¸ô®‰nhÔ\'›\Õ\Ï\\ü?;\éù5\çóû¾g¯~Ÿ=1ÛŒuq¾ÿ\0.ò¹¾¯›\ïÎ»k\Z\Î÷¬\î\Ë\Ó=5›¼\ëR\ê]J\n”\0*,Lñ\ïgó=zó™ú#=.³£\ìr\ë\ÊU–/‡\İ\á—\Û\éòúºe,¬\Ë²!\0 VT\ç\\^]f…²\0Q,\0YM±»<w\Õ\ä\Í\ë¾=,\Ú]@¹K,ğò÷üıù|:ôø¹õöû>O¿Ÿn\Ş_˜\íÁ7\Ïz\ç¬ôÏ£q\×\Ó\Ó=¹ôtoQ©­K¥°¶\ÅÀ\0¨¢.¬ù\ß#õŸ“g\é,Íº™_·Ë—YVX¾/oŠ__«\Ë\ê\é\Ë&u	,‰,R’²Z¾?g†^ú!e¨°X\0‹ƒ¤\ÏK<zôùe\é®{M%\ÖB\É\á÷s\×?ƒÙ›\Ã\æÎ¼ñ\ÖK“\Z½q\è]\\ô½z%&®’[lZ¥\0@\"ˆ(–\Îÿ\0›ı\ÍO92×§\Í\ì_\Ôùÿ\0C:¡/‹\Û\ã—\Õ\êòzúD²\É,$\"€J\"€Eš®~~Œ\İÒ€\0¢(Š ®}lò_G7q«4–Ä²\ç\Å\Ã\èüÎlyı^.>.º\Ï^zõzW\É\ê\é³\Ö\Ì\ëT–\ÒZ\n²\0¨€\0*,oG=Op¾\Ï²\ß?\Ğùÿ\0C\Z¡/\Ù\ã_O¯\É\ë\ÜK,’\ÂK\"€¶+\É\ß\Ï\éÎ‚À\0\0\0”\ïŒv³\Ç{ğ\Ş{³IlOd¹ø\Ü~\Şs\×\æú}4\á®\Ä\çzU\ÅÕŒ\İ¢P(\0R,€€€™\ÓYù£\íñzkŸ»\Ç\í\Æ\ê[/“\×\ä—\Ñ\ëñû7¬Ì¹È€bˆ\0.:yŒ÷\Æ\å\n\0³\Ö\Î|›——^Iz–À\0@k#¿\'[<z\ë\Â^—\ì\Ô£+\Ì\èRPB\0\0\n°\0 (°>`Ì¾oLW\Ö\é\ÎP/—\Õå—·³\Ç\ìÜ°³2\äK\"J X°\0•/‹\×\ä—\ÑJ\0\0.\æ,\ãÓŸYzù}³\É×•ÎºX²À\0sN\Üo[<w§Şš\çª\ÒZ“b(\0 \0\0(€K\0\0\0,ùƒ2\Ê_³\Ïx”\åõy¥\ë\íñ{w\"\æÉH\Ê\Â€F\r€T\åÉ¹­–\ÄÁe:y½>A×ŸYus­g^OV\'N:Îº\0\0ƒ¿Ÿ},ñk\\³®×\ì\ÒR€\0\0\0‚\Ê \0K\0\0\0˜&h>\Ç>˜”ù½>yz{|>\í\ÄK&l ‰)`\0\Ù\É\èóúf–[‰`¶l^\Üc}3±e²\Ü\Ú×\×O/NÎº\0\0²;xı\Z<[\Î3¯F¹n\Í\Ü\Û(\0\0\0\0²À\0\0\0(ùbf\ÙO­›%¾G	u\îğ{÷\ÖlÌ°‚!,*QÇ¿’/|h¤£Í¹{%²õ\å\Ñ<²jk¦³«\ËsMx½£Í¿?\\\ëbÀ\0d<ü9q_o>±¯N¹oY\İÍ²¥\0\0\0\0\0\0	I`\0\0>]&VS\ê\ÂP[Ã¿¾ÿ\0ôvgY³2\Â’\Å ¡g–k\ÓeG›u\å\èòû1\Û\êt\çÓ§“S~j\ÏN}eÕ–\Ê\0,º\Í/‡\İ#Ï¿\'®h,\0~O|<ø\ë\ÎWo>³¯N¹ô\Öm–À\0\0\0\0\0\0\0@\0˜¶j>’YAo\Üc?G\çı\r™Ô³9°‚$±@@YASÏœöÎ´­O?\Éû?^\ß/\×Î»ô^¾^_’]õ\çÔ¥°\0\Ë\Îp•Ü”,x=Ÿ8×¿\Ã\î]q\×\ËMg¬ô\\ús«µ±K\0\0\0\0\0\0\0(€\æ†Vj>Î¥¼ºòŒıôvgY³2\Â`\"Áe`òzüŞœ\ÚMO\Ê÷x9úû}\'¾ñº\Ï]ò\á\Ås®›\Î\îVZ\0–œ\ŞxwU¯ \é^O\Ì\'+\é›\ÚYÑª”@\0\0\0\0\0\0\0(K\0>hee£¬nP[Ï§8\çô¾o\Ò\ÚgY³3Yˆ°`\0ù½>zõÎ†u\æ>g9ßŸ¯\Ñ\ï:y]0¹ò\ïs­\ê[š(†a\è–P°\Îú<\ëi}<5ó\Ó8\Ìúµ\İuº@\0\0\0\0\0\0\0\0\0ˆ\0>hee¡¼t–¼ús_O\æ}=¦u›&l\É` \0\àöy¥ô\ØO7ƒ\Óòó\é\ß\Óù^=Eß›\\»øí¹õ\Ê\Õ\ÔA‡˜z	K,¹ğò_«9ôG„\Ïv§¥f­EÎˆ° €\0\0\0\0\0\0\0\0Àš¦e”ú9uÍn7ˆ\ãôş_\Ô\ÚgY²gY –J \0YO3—£:\Ñu™Ë´—\Í\ßTJ³§\Õ\æ–õ\Æ\Ëe°Q‡˜zX²Àú™~I<şE\×,úªzGIP°•\rYH°\0\0\0\0\0\0\0\0\0ù´fYc\ß×—U–YX\Şc\Ïõ>_\Ô\ÒK53d„”\0\Èò{<Ş¬\è5%ñ\Ô\ã\ÇY—¦ó¤¥¦aŞ¥X² x\Ş%ú=ü^È¼ñ\à³\\]•\êÏ¬j‘@B\æ\ÃID°, \0\0\0\0\0\0\0°>hee^]VYegY<\ßW\å}Z’\ÍL\çYY,€ _W†^½³ ,\0^z<¶n]Ù«y‡¢Yh±,[=#É¾Ÿ4\×\Ùg¡\ê‡E°\n€	e\0\0\0\0\0\0\0\0\0\0Pù•”ú9ô–	l°ò}o“õªMgS9±d²\0€YI\àõp\Íô\Ùl\n\0\ró\ï\ä3\Óe²y\ìz&¥\0w\Î<\ßO\Í\ê^¼:|ô\Ï7Uz\'ª/E²P\0\0 Â€\0\0\0\0\0\0\0\0\0\0>`ee¡×—UÍ–T£\Çõ¾OÖµgY\Ä\Öe’À	PPòo‡«:Ğ¹\n\0¾OG”\ÖùbW¥IK=\Ìhyºø9\ÖWg¬kK*h€\0\0ƒ:\0\0\0\0\0\0\0\0\0\0\æ†e”úxö—6Y@ñıo‘õ\íK5œgY–Pg\\7³\Ï\éÎƒY\0\0:ùz?j€ oL>7£Û“xÇŒœ¯evz\á\ÑP*k4,\0\0@\03¨(\0\0\0\0©@\0\0\0>pfYOn‰qbZ\×ù^Ô³Y\Æu•’\È\0\Ùó\åôuÎ€°\0\0@\0—~C\Û\Ó\É\ê[\Ï>$œ]–õ\ç\ìô[ \ä\Ğ\0,\0B¥\0\0\0\0E%‚¥%\0\0\ç}Ş7ª^vY@ñ}‘õ\íK5œgYY* \0Ï‡\Ó\Ë:ô‹’\Ê\0\0\03WofSÏ·€\×	\èWI\í‡Y¤R’À¢\\\èJ\0\0\03¬Ò€\0ˆ\0\0,@\0Kœ%_g³\Åí—•–QO\×ùZ\Û,\Öqed²\0\Å\Û\Í\ìÎ©n` \0\0	ó~\Ë9}?\'²^œ:|\ë\É\Õ\ì–õTR€J \0Î¤4	@\0\0’Â‚,\0\0\0\0\0\0\0\ç%\Õ\îğ}	x\ÙeYO\Øøÿ\0^\Û,\Öqea 7\ç8{<şŒ\Õ,K\0„,òEöL\é\'“¿€œ‹«\ìštµ(°\0„\0$¢¥\0\0\0 ”X\0\0\0\0\0\0\0\0œ–S\Ñô~wÒš\áe•e<_\ä}{l³Y\Î7…’\È\âöüù}=sJ,€(„/›\Ğ>O^œ±\ä\')\éV\Ş\É]ZfR¥”\0\0 \0K	¬\Ò\Ë\0\0\0K	@\0\0\0\0\0\0\0\0\ç{ı?—õeóØ–\Ü\èğ}‘õ\í²\Íg\ÖVK xûLë¸¹¢’„rø|«~‡£\Ã\ís\ç\ã³^mv&\ŞÙ§KP«\"Á,Z\0\0J$°Ô¢\0\0\0d \0\0\0\0\0\0\0\0>pbP\ëõ¾G×—\Î&–hğ}‘õ\í³Y\Öq\á`ˆ£\Ë\ìÎ­–\ä)~túQ<}/\Ï:qÏ¡t¾\É]\ZeJ,\Å\\\è\0°(—:!\n\0\0(Í”P%%‚ ©A\n\0\0\ç\0\ß\Ùø\ßf_0šk:<?W\å}[wgY\Î7…‚\'>S®=³h°p\ï\â¬ú¹u:ğ¾<zu1\Ñ\ë\Í\×F¬Yl€K±e\n\Ê\"À\0\"\ä²Á` \0\0\"\ä \0\0\0°*P\0\0ùÁ€]}¿‡÷#\Ê&šÎ\Õù_V\İ\çY\Ös\á`‡ƒ\İó\åõ\îPf\Êój^\ì‹\ä\ë\á³8w–×²V\ê\ÍÀ(ÁJ*T°\0\0l,”‚\Å \0KQ\0\0\0\0‚€\0>p`÷>Ü—\Ê&–hğı_—ô\í\égY\Î7‚	xq»Îº\Ò\Çò¼õs7\Ë1Œú\"\í\ìY\ÒÔŠ²k4  @€b‰¬\èX@\0@6\n` J \0\Í@°\0\0‰@e	k\ç%˜ıÏ…÷eò‰¦³O\ÓùŸNŞ™\Öuœ\ãx!™|>¿\'³:c\Ï\Ê\Ïv¹\ì¼gŠ\Ì\ã]e\ÏI\íWF’*\ÈC`©D°€`)\r°\0€@gY4PP\0\0“Y,R\0\0(\0\0\0>u&Ÿw\á}\Ù|¢ie<K\ç}\ëgy\Æw‚yı\İz9u\\c¼³\Í5\âV]Š{%tiÀ †±ºX\0€„VT\\\è\0@¢kP\0\0€–\0\0€€\0ç‰€¶}ÿ\0ƒ÷£\È&–S\Éô~½{gY\Şs\àŸ\ì|Œ\ë\Ñ\ì\ç\Ğß—^\Z¬õŠ¾µ½-–Ä°š’¶\0$¢K\0ƒ@\0	PÕ”K\0\0,\nH\n‚¥\0\0}\ïƒ÷¥ò‰VUòûü\å\ïgy\Î7ƒÍŒõÎºy7\â¥\ÏHiì•º²\Ü\êÅ”–\0  —W\Z²‚K\0\0°-\Í,°K°\Ê-Î„(—:\0K\0\"Á@\0\0ùá€‡\Üø_u|\Âie<¾\ßµ}\Öwœ\ã\\_%Î°\İ\íV\Õ¦²%°°	fò³p\ÂK”\0	¬, \0¥&³A\0\0YD£:‚(€¥\0ç¡ŠE}Ï‡öã€šYO7¯\É\ê_Nu\ç?;\èüIyun[^µtT, $²4–ªBÀ@K l\ê\É,!%©RŠ@„]\ØA’ ¶e\ÂÀ ©J@¢¥\0€K@\0\æ¹&z¹¿sóÿ\0aNlŞ—•9ú|}\í÷NWy¿\ê|\ì\ëG®V\ÖÅ‚ °&²5r*\n,.ù\é,¹¢%·4\Ò,D– ºÆ¬±\0 …ƒW6µ—\Z‹r­ D6*±ª¤\0@X*\n‚ ùm¤\æ\Ø\Ç\Ôù\ßV<\í\Ésm_7£¢·:MN;\ëx\åóOg3†½88\ß@ó»n<·¶\Ï+\ÑW\Êõ`\ã=|\Ï>½9³ƒÒ-\í»|¸ô\é<“\ÓO3\Õ\Ì\äô\à\áŸ_#½|÷®\Ó\Ï:\í|\î»O=\ï“ù8\Şù9\ÏD<·§C\Ïzl\äé³†}88\Îø9^\Ø3®š8N\Ğ\âŞWt\Å\Ğ\İ\Ä:I\r06\çM¸\ìÛœ:¹\ÂD™¨/\Õù?Qq[sN>7 \íS<·\Íz\æ¢ó\ŞKs¥–}xõ/=ó:À¼÷\Ì\İÎ=¹uÁÇ¯#´°¼÷‘¹@8v\ã\ØPœúr³¸/>˜3Ó—bP\ã\×\Z5Br\ë\ç;\ËG>œ\Ç_?rP\å¾T\éhq\í\å=2lc|‹¿\'°Îƒ\Å:M.3šfM±M}O•í³‚^÷\Î5\ß\Å\Ö\ßlóf\ÏV|\Ã\Ò\á»€\î\à;\Î=`\ìóC\ÏL\â;<ñ}/0ô8T\ìó\å}SÍ£»„==;\Î#»ˆ\ì\â;8¬\ìå“»ˆ\î\â;^\î\â;8“³ˆ\ì\â;8Ó«ˆ\ì\ä:¸\ÎC¬\æ:¹®C£˜\è\æ:^4\ê\ä:9®P\í9‘4\È×·\çıq*^]x÷­¬³3Y[š‰(Š9İ‹%0\Ğ\ËA(\Ä\è^Z\Ü\"ÓzZ\Ø\ÃC-¢5	hS7v³”\çz,\æ\ê9^£“¨\â\ì9:N£“­8».´\â\ì8».\Ğ\ä\ê9:Nƒ\Ø\æ\è9Îƒ“ ø\Î,Î·:ı—\è_[Ê—\Õ|£·_}ñZõ\Ï$=“\É%ö<ƒ\Öñhõ¼pö_=¯=oö<™=¯ö<c\Øñc\Æ=“\Édó\Ù{\Ş»9\ÓwlSW55skz–Å•(ª\n\0 Š”Š¡\"‚€\0\0@\0\0„>¶qyºC=3¸ŠYBK¡*³u’-‰(–\Ã:h\ÎuH°Î”\ÎuD\ĞÍ¢,\Ìrœ¥õtónk\Ñ|\Åõ\ë\Ë\Ş7qM\Ü[7®{­o\Z³{Æ¬·6\ËeE–ª€\0\0°\0©J‚¥,¢\0\0\0(\Æ}2\ãËŸd<<~Ÿš_²^.\Å\â\íN£\êNK\Íwyh\Ñ¸\å}0ô¼\Ã\Ó<\ã\ÒòK\Ì=/0ôq\Ç§.8š»»´©a\ïğ{±w¬\ØÖ¦Ñ«­I¥³V[)l¶QJ¥@\0\0\0\0\0‚ÜŠ\0\0‹£\\\à\'—\Óæ—€””‹\0úr_\ç;\Ïn]®zWM<¾©ó\çNmu87ºó$\íƒ+\Ô\â½N-d®¼WNœ\Ì\æ\æNššŒûü?C5¹\Û)½kR]]L\İZ±JjR\Ê!P\0\0\0\0\0\0\0 *\r%A \0\ëe\×9>oOš^X\0(\'>¼—\çgY\ÇIÛ[\İ9t\Ó;\èüû¼z<şˆ\ãd\ï\çôp;ñ\í\ÄÏ£\Ï\è<ş? \ã\äôyıs¿.¼ŒMf:t\çÔŸSºN{\İL\İZ\Í\Ñ3m3j¢ \0\0,\0\0\0\0\0°\0\0-\Í*\0\0\ê5\Îy½>i|ò¥€\ns\é\Í~v5œtyj\Î\İ|½lõü\ï¡\à»\ç\è\ã£9\Ğ\ë\Ãp\ë\ÇPÇ£1\è\ãI\Ş}Ã¯+MnRû\î1­Z%¥ŠH¢,\n*\0\0,	@\n‚ \0\n”©@:\Ï\r\×?kÉ£\Ñ\æ\Öeó´\\6Œ7+-Óœ\é#\Ç\Ëè¦¾mú$ù\Ó\è\Úù“\ê+å¾˜ù“\ê–ú°ùo¨>[\êC\æ>˜ù˜ú\Ü%ù\ŞÎ¿Ef\Íe¬\È\Û#L—H24\ÍZ‚²*\n‚ ¨*\n‚¢*   ¨*\n‚ \0\n–´\È\Ó#\çµ/<´\ß\'¡z\\\îYh\ä°ö´\Ô\áË¾\Ã-\Õ!LU\Ü°š”E1©¥€\ÅÔƒY\ÜUj&ñ¡d\ç¥+Y$\ŞJ°¸\ÜYT…N{Î”B5’¬\ÜQÆ¥‚RMdÑ“Y\ÖM\"Œ\ë4ó\r`C\Ñ\éòúe\ÏN=ŠK“\è\rLq\Çõ\Ø.5\å;\ï\Ï\èŒo\Ë\è:B™\Æc\Ğ	/”\ï¾\é/Ş¼°\ß\'C¸\ã_k:„¾c\Ñ|~² —\Ë\Ğ\ì#Ü”c\Ñ|Şòt;3\ç=põ¼Ş•<\İ¡…}\ÉA“N\Ğ@óu<ªf»ú¼¹yö\á\Ö]k3\Ï|—\é$\Şo›¿Ï—\Ù\Ï\ÍO^<\Ã\×|;_Fü\Ñ;tòN¼£×ô\ãW×0õ\ß(\í\Ó\ÉF¼°\ï\Ó\Çc\×Ï„=|ü£\İ\Ï\ÍW\ØñC×¿õtğS×¿ö\ã\É?%=\Üü£İŸõ\ïÀ=]<4ôôğ\Ã\ÚñS\İ\Ë\Ïw/0ö\ã\ÍeñÓ¾ütôo\ÅON¼ƒ\Ù\Ï\Ïo?4=\Øò\Èö¼ôôğ\Úô\ï\ÅOGO4/8¾¯/Eô\ïy–-^W•~ºŞ˜\å\ÇÓ‰|Ó¼^.\È\â\ì8»Ö¸;#‹°\â\ì8;ğ\ã;\ã\Îô;\Ñãƒ¸\à\î^ãƒ¸ó½\Îô3Ğ\Ğ<ó\Ò<\ÏHó=#\Êõ+\Ô<³\Ô<\ÏHò½Pó=#\Êõ+\Ò<\Ó\Ô<¯Pò=pò½C\Ë=pò½C\Êõ+\Ô>z[ˆ¾¿\'¬õs\é\ÎP—>O_‘~Í—¦3\â\\\Ë\0\0\0€\0\0\0,\0\0\0\0€\0\0P\0K\0\0@\0°\0\0\0K\0@>z¯¯\Ç\ë=œºò”%Ï\Û\â_³¬\ë¦3\â\\\Ë\0\0\0€\0 \0\0ŠÀ\0\0\0\0\0–\0\0\0BÀ\0\0,\0À\0À\0BJ:zü£\ÛË¯)BY\âöø—\ì\ÙzfcxŒ\Ë\0\0\0‹\0€ \0\0B\Ê\"À\0\0J\0\0\0\0JT°\0\0\0\0\0 \0\0 \ë\êòúO\Ü&­ˆ/o†_³¬\ë¦f7ƒ2\Å,\0\0\0\0\0€\0\0\0\0\0 \0B€±@\0@\0\0\0\0\0>|±‘Mú|Ş“\èp\ï\ÂZ%w†_³¬\ë¦f7ÌP\0B\0\0\0\0\0\0\0\0°¨\0\0\n€\0P\0•\0\0\0\0@Ñœµ¸w>ŸŸ\Ñ\çÍ¡g‡\İ\á—\ì\ë7¦\\÷ƒ!D\0\nK\0\0\0\0 \0\0\0\"À\0\0,\0\0@°\0\0À,\0°\0 ñA5\ß\Ï\İ~·›\Ó\æÊ¥Y\á÷x¥ûN™™¹\0,P\0\0@\0€ \0‹\0\0\0!(‹\0\0,\0\0°\0„A\0\0X/n=W\ìy½^\\…Y\á÷x%û8å™\ìå²²]04\È\Ó(\Ó\Ó#L\r°4\È\Ó#L06À\Ü\È\ÕÀ\Ü\È\Ól\r°4\È\Ó0\Ûl\r3\r°724\Ét\Â724\È\ÓLH+#LŠ‚¤5 ¨+*¨*`×—Eû^_W–[ó~—Ê—\ês\ï\Î\ÌN¹8:Ó‹¦.š8ºh\ä\ëN\Ù^n\Ğ\ç;D\ä\é¥\â\éNN”\å:N\Ğ\ç;d\æ\ë“¨\å:Wt\ç:S“ \æ\ës¶Nn¹2\Ø\æ\İ^mÓ›Z9·#™2\é“3¤1uLMŒ.Œ4¬µ#-\Ê\ËyH\Ô#C*2´\â7€Æ—\îù=~Lo\Åû_û|ús\ÖF³¢P\Æ\å%7“@cy4”\ç°jRó:J\Ã:•B1¾]H°c|Î’†u¬l\ZÎ€2d\é,†7ƒIi,‰®}	`\Í\ÈØ©r;f†u	¬h\å\Ğó°\Ş7 \Öùr_\Óxş~c\é¾i~—\É\é\â\Ñr\á\Â\Ï/\"_W_ŸO}ùô÷¼\Şğ“\ÜğsÂ¯s\Â=\Ï\n_s\Â=\Ó\Ä=¯ö¼C\ÚñC\Üğ\Ó\Úğtñc\Ä=¯ö\Ïö<C\Úñk\Ä=³\Æ=ö<höO öO!}oõ¼ƒ\Öò\\ò\Ã\Öò[\Æ=o õ¼ö<jöO!=o õ¼eõ¼ƒ\Öñ“\Øñ¬\ÖH\0K“W:úsU\ç\Ñ	\r ¨*\n‚ ¨*\n‚ ¨+#LŠ‚ ¨*\nÔ‚ ¨ZÈ¨*\nˆ¨\" ©\rH* ¨*\n‚À ¨*\n€B ö\Ë`Kñ²c|\Î]øö\'Ÿ\Ñó\ëİY-‚¡s©j¥2\r!úf]ÀJ9ô”%9ôÎ‚7“h\ÔQ\ç\Ó:	L(\Ò!Ë®\rYFu	@YJ\çy4>™\Z‚\æ}3 \0\0\0+\Ù.Q@AÓ\Ç=\á|ş¯­\'ò¹·”(Ê—6Œ\éI5t\"¡(K	ABT%±l\n‚ Y	©·4±#Y\rH4€r\Z\ÅB\Ä5X¡ Ş³K€\0°X=L<\ï@ó\Ï@ó\Ï@\á{9ôC\æ{]W‹²\Î.£“¨\ãzNƒ› \æ\èN£“¨\æ\è9:W \ä\è9º› \ç:£“¨\ä\ê®.\È\â\ê9:S°\â\ì8».\Ğ\ä\ê9:—Œ\îNãƒµ^¹8;\å\á=ó½ó½\Ï=$ó=%ó=#\Ìô3\Ò<\ÏHó=#\ë¬\ÔB\0J\"ˆ¢(Š¨¢,\0\0Š\"ˆ¨Š\"ˆ°(‹\0P„°\0\0\0\0\0,\n‚¤*\n‚²*\n\ÉtÈ¨*CL|\â\Öz¹#«ˆ\ì\â;8S³ˆ\ì\â;8\Ê\î\à;¸\î»€\î\à;¸\î¼\â;8\Î(\ì\ã\î»€\ì\â;8E\î\áN\Î#´\ä:¹³\ê\ä:¸®C«”:¹Ã«’:9p\ë9c¤\Ä:9“\è\Ä:9“˜\è\æ:Lnu7$4À\Ûô\ÏA<\ï@ó=%ó=#\Ìô“\Ìô«\Ìô3\Ò<\Ó\Ô<\Ó\Ô<¯Pò½C\Êõ+\Õ3\Ò<\ÓÔ+\Ô<¯Pò½#\Ìô3\Ò<\Ó\Õ3\Ò_3Ò+\Ò<\ÏHó=0ó½\Ìô3\Ó3\Ò<\ÏHó=#\Ìô3\Ò<\ÏHó=0ó½\Îô3\Ò<\Ï@ó½\Ìô3\Ò<\ÏL_;\Ğ<\ÏI<\Ï@ó½\ÎôE\Û\ç\\\ë\Şùø>®¾CÙ\Ë\Ş>\ìü\ì\ŞFü\çSôˆıó‘Hü\Ú?Hü\Øı+ócôÍ«ôÍ\Ò?5\Ó?2O\Ó?2?LüÁO?2?LüÁ?O/¥ıLù7ş´ù#\ë>@úûøş¤÷Oö¼C\Ù<Y=ÏŸ£>pú3\çlø\\·Ÿ\Ñ?<?C?>?@üøı\àS\ï>ûoˆ>\Üøƒ\í¾ ûO‰O³>1~\Ëâµ>0û3ã°ø\Ö>\Ã\ån_¤ù¶_£<}\Ï=\Ï\r_¥Z™\Şk³—\Î\Ş5\Ü\æ\ïdÊ«3H\å7™¨²K	DD\0\n ²À£\ß\è\ãÛ@–×·\Ã\ëM±RÉ’\ædD$y\ëÉƒ®¥e(Š\Ğ\Ì\Ü2´Å£-©b\Â,Kr^ı<»Î»Yq¤°(ú¯\\\Ã\É\Ë\Ûñw|n½±\Ò\ÄÕ”\0š3¸\\M\\\ŞN™–JX°‹P„,£*¤ g³\Ã\íåºŒ\ÔE×«\Í\ê@²gC\é˜\ÃY35|\Ï_‡¤J\Ş@U\0 \Õ\ÍBÂ¥b¢(”\"–,\"\Â*2\Ğwó\Ù},\ë¿‹ñ§<ùu}<\È%š5r)s#s\"Ü˜¹\\µœ\ØE, H°,\"Ê–RÅW\Øù?CûIr“p\ÃP\\\ÓR*\Ä&wƒ9\é“\åò\íÇ®`±Ae\0YR\ÙV– L´3T\Í\Él	5	5	e /n=s­\Îú\Æ\ç\\ı{@¨%Yd5j ‚\Ü\ÓX£55 \0),%šo¯†ùo\ÖH©¬\rE²¤\Ğ\ç:dÄ¸>-g®%(B\Ø*R¦ŠX”I`°,¥2Q(4”ôtózùtòMg\Ñ\Âk:$±Jˆ%“P\0”EU@)@’\äJH\0¨¡Ó\ã\êr\ï\æ\ã\Óè³¤Š©P\Ô\Í‘\'>œ\ë\å\Ë:\â€©E”k:†¥-\Í5›L[(!`¹\Şe\ÊÀ°J%”¾¿\'\\\é;qÈ–dH©™u!i\rH-–ˆ,²*))2¹¨@°»\Æ\ã\êùºgN×†«µ\ã\î»…;NX=\Ì=9ó\Ù\ã6w¼\à¨\n–(-\Í4Š\ÒR\Ù`ƒRl\ËPÍ”J$²R\ÅK\0\ZÆ³X\ë\ÊÕ—™s,Î \0°P‚*b	i(HJ°\0‹\ëò}¸ğwñ}[òú|Şš¦\å\ç«CYE¬ÑM\äóqöy:s\ç,\Ğ”¢­–-ƒW#D¦ˆk!-2‚\Ä	seK\0ÿ\Ä\0ÿ\Ú\0\0\0\0\0\0!nŒ.ò\ï\îayğ÷ùß”L–\È\ä5ød`€\0¤û\ÏùS\ÊkG\Óm¸\'n\å\î‚<1û”“ûN»Ò¯C…e\Íj\Üi4“Ÿ¤m¦>\è{Z—\Òş	ğB£¯œEü@\á%¤%\'G7Ñœ}ş}O¬\×<pU5ÿ\0*|¶\ë~\Ïÿ\0³ÿ\0—M¸j«\\ˆW¶p,#ı4A_\écO0\èêˆ“.\ë\nk}¤—|\áWÙ¬\ĞVk–\ËóG\ÒL€Ti\äS¸\0j\èõI^v“4\Ó1\ÃCú`ğØœ³µpõš\ç\ß\çNx\ÕdlYØ‰\ê©*YSŸ\Ì8‘p5\ãLÿ\0JMr%\ê, h\Ã—´\å\ÛM.sK0Bò\×=ı\0”0‚K,÷’\ÍK1\ã,‡7Š[˜ \à$ÄGş¨‚ˆ/88\ãzo>>ñ$óÁ›\îi@\Î2O<Uÿ\0\ß \0IÆ§\Z¥(\röyÖ”=7\Ğ\Â ‚« ƒz\èM1Œ4³\î\ËZ¦€I\Û\Ä?µ\çjvh,²\Ë,²ƒğ\Ã1\Ã,³—\åhŒµZZVs\İ\î®ú\ë‚\ß\×)\æI]_IAPA}÷˜\Ç:¡\Äp\ÚœË‘RQû\ï¾ø ¦¸\Ø\"_\ÜsAÇ›A4\ÓM4ß\Z\0sc\ÖDç™¥Õ¼¾ûª€. !jó\êO\×>‚\É\Î%g8\\ro¬yØ®\Õö_Y†yû\r\Ã<ôÿ\0\0J6ú¢qw×§¥ø\Ã \Û9\Ä\å×·JPz$\Zñf¿hCÀ\Â\0åŸ©K]8xğ€[}L³ó\Ï;›2·Y¼T@[17€°=0]?\ã5¤\ãuÑ¤\0UX\0¤|ô7&·£öIA\èRx‚ª\èP\r,ó@±K\Ò\'IN—}\0\0\ŞÜ£(mOói\â®~€õ!hä¿\0C\ÏÒµ¹<¼)ü\áğ\0¯q\0/\r\É\ê`EN«gAº\ã¿\0\0A\0°£ú«\ë\Ë\ßT(S\İø½%c¶ÚœJ\ãD\íc7W´AÁ«š\ÊÀ;y¬­ÿ\0(ò\Ç?e8B\É\\\"²‘yM‡„\rp=z02\ÎKº ´\×A\Ë<ò·<ò<ò™\Ü^§4Õ„^„»\áP£\ï79gû\ä+\\±½ói÷\ÊW=N<\áO(—üø÷\Ë\æş\î@ ^œŠÈ–ÿ\0ÿ\0r\râ² \æ!\ß6„|M£K<\ãK1“/js¾‡\å\èMuNˆpóö„@\í‚\Ì\ï>¸8Cø®C0ò\ë;D¡\î+,ÿ\0o6\âYŸs¼°t-NüeVğ\é£À]H<ò\0M(YÛ»¸\nÕ†ó6\İM´\Ï\Z™Ôˆ•nš0 Gõ\Ï<µ¤8\0.\ÒV«\"\í` Áty÷ûAY\ŞJ< Pû«K<¯õ<ó\áq%óÂ¤NOÀC÷\ß@F•]6\Ğ-\r\"„\à	ªó\ì\Ä\á\Í*û&bcO<óÁqG\áû\ï}µ)W\ß}£\à\×\ÍN9\Úú\Ï>mJ°-ó­\ë=÷\ßu¹ev…<ó\Ïôm÷\Ğrüò\Ô\áÅ½¬jP¨\ç_0ˆ½\êU\är\Ò	…\'W<ó\ßA›}\àÿ\0­O\ì[\Ú\ÔƒÀµ¥ÁL[\ëb<˜E[ƒºU÷\Ï<\äA\ß\0ô2\Ô=Ä­J¡¼ğ|üGa¾\èZ–´\È\çœ—\ß<\Õ\ßM\0Qò -I\Ü[\ÊÊ£J®œIŠ¨®\èó\ê=\ã\İA÷tn\âR|ó9Ä€A<ó\Ü,§\0	g;/]Z½¶\ç}D\ÈeR|µ\Ï<…\ØQ\0\0ó\Ç>\Ï\Ï\èYĞ ğµ<R\"<ŠYµ\åGA@\Ğ=÷šuö\Ø\0„=\Ã\Òü,—•©¹\îVlT„³ b×œQr\Ë-\Ñ\Ğ(\Ó\ßy·\×PÀ\0A\Ø*\ã©[ ó\é*Dº¶©Z\ÓDkV\r]xw\Ş0\00\0ó\àhöz”ú8j\0P-x\ä\àQõXz\Õ}÷\ÏD\0@\0\Å\0<wÁk˜‡€ò§\ë!Ò’1ò¨`ğ\0<\'\ß|\áTA \0ó\êhD%¢X	&€0AR\İb„\Zm5o\åb\Ï\0\Ê]\ç\Ë@\0\00\0 <6J!ˆ‰…$L\ÚUWÁ4P<\ç’m¤@€\0€\0Æ®V \È[Àˆ³\ÛA\ßyL|$}\È\0S\Şq%\Z\0-\"\0\0ÀTj¥`\Î(	gõöE\ç‰\Çb\Û\áS\ÄQÀ=A|s\ß\à\0Ê¨DJ\èr¤¢\ï\ßiVœ\Õo€\Ä8\Ğ \ØAg\ĞU÷\ß<ó\Ï<óÀp\ê l¿É¼ôø\×ÿ\0\Ñ@\å9ô	B=aÀi,u·\ß}÷\ß}óÏ¢œªŠ”[¬®\ÜEwŸh³»}¶\Ğ<%[Uw\ĞAUmFAT<  TJ\Â(ûÅ¶kğQlÄ¹u±Õu4^\åq\ĞU”AA\0‚†Qôâ´«©«\Ş\Ô\Ö\ÕT³\ßiR˜H4<A„›M$P UŸ\ÊY\n­|0¬pGh\Ş<UL=GP|!EmS\Ê\0”‘}÷\İ]  ‚¥GÖ …„¨X…\Ú\îBdTRX\×}£À\r7Uòƒw\ßyG[B ML$[Z®ˆFú±\0\r¦Œ8·\Ú](‚M}\ÄAò\êˆW\ÖÀ±…µ¹k––\á:ÆŸE(\nhğO\\¢†W\0\Â$g\ÒA44û\àùœ6:^\İ5ƒ\é\ØI¾›¸¦\ß)\ç\Ê(³”i 8#Áò\ÔADO>Àòe•\éÿ\0C\àU¦\åB\ßT’\Z\ã<-\Ò\0û\íiüŸYTH\á\é&\Ûi¦£ Ğ}&EDDÁ‚(!@4-¾F6\èã ‰¶f2\æqTXb•À5‡EÀB}õ‚,\Ã\ÊB‹\àO\Û\ãD¼\Û\áD\ËH>À\ßAux\æo\Ñf\É,–\Ùl¡ƒ\0\Í8úª\àO¾>ñ3ÍB\Ë	®h¿\îºc²û½J‚{\Ü	LU(\æ6Á\0z\ê<¿û5\Ãuô\âH)C£A·\Ù5`I\Ö\Şe[/,‹o0\Æ ¥¾^°”±ÿ\0\Ìüğ®	AAÁ¢X¥š\É%‚qCO\â\Ëƒ\Å(Aƒ$q©\r½\Ôß±=\ï¿¶¾\ì¦)à²…]Rø ÷Ş³Ã¼4\Ã/<\ë0\Ó\Ğ\Z¿j‹\Ü\rú\ã/<ABŒê¤\ÒD‹À¡U€O0€\0\0\Ê0c\Ë\ë—\\kŠV¶«é†‹i¸\åWµ\Z\ÌI;W`\ßó\â°eÓŒ7\ï}8Rş¸\æº6\êJ J!ƒŸù\Z$²Œø44ÿ\0ıÿ\0C‘Q÷\ßi\r1§Ì°†zú&‚\È\ï¾ö\ĞQ‚)cE\ßY„	}Gy†]< uö…ƒ/~ô×µYT\Ñ\é-d7\Ö\Ë\ä}wA}u÷ØŠX?ÿ\0\r7…\×mv\ël;\áò¥Ü¹=\Äó\ß\×\ße÷˜AW\ß}¤\ßK\n “ÿ\0œÀu‚\Ò\rºÛ¿û\ß\Îwg|\Ç=ÿ\0qM4\\0„Y\äyjñ2«t“]\ÇM4›`7?M\Í\ãƒ8C,0\à\Ëû\ß<²û\Ã\0—?<\Ó\ãg—I¤\Î0´\ÔH²-øƒb“¦9}qlL1¾\Êa€¸®Y+\È\È\Â!œ8+´û¸\Å÷À‚\ìò\ëû\ë\Û~°€“(±ó\ÊD†oV/²3\ßğt’‹ù¯òA\n\İYEœ\0a\È }ˆRˆ®\ÂÆ¯5¿.>ø¬¦z<u5\Ú\03€>y\ì³\Ï?Ãœ8\ÏN=\Ë\\şÂ¨d\É[n€\0\Ï(3Ë‚o¿„mg\ß} €°‡J\0ğ€\äº,µ§\ê, \0<ñ(,–òAFmö\Ğ@\È\0\áO(S\ÊM¹#Iy\Z\Ë\0O‚û †C_}a\ÚAAO<\Ê\0sÀ<€O8\Ú„K/ú \0Ò¡¾\è/º#½ö\ĞA}T\â8€O\0s€^aW}ô†$‡\0z ¾ø Š	\ï†MöM7\0r‰\Êòq—¼4d°?8.ÀO€	o¾¨ ¾û\ê‚\Û\ï\Ãi\Ê\à Sy•\Ü\Ïs\Â#¹·7Tò€ó\ïO< $¶ø Ö¸AWˆ…\Ê\r\á\ŞA7®ò>?t’\Ã.²8¬²\Ëï­+/=\É[Q\Ã\ç²;¤¾»!šˆ\Ï û\ê)ğ#õÇšY&L\"ÁÁC2Zg\ËM1E\Ò\ÛlªH¥\ÃEúB?û\È ‚\Î-\ä’mw‘IEU\n‹n²V]v\Ñó—°\ï~‘]Dw\ç\×7A®Vê£ƒb‰,²£’ø\ä¾ğ\×q\r4\È%¢;\áŒf0¤<Q…QPN¤’\Ën²‰,‚8\ï±\ÆQ]\Æ4\Â ®\Êv\áf?\Ë\r?û=ÿ\0\Å[q\ÆXô\Şñ¼\0\Â~k­ª€\ÛIÖ—\ãÂ¶\ê%²:5şŒ`»½¿\Ìu—\Ú\\¿a1Nc(–\ïa±‹,“O	\r\'¢\èº\ï\ßv\Ë|\æ\ëO=ïœ²\ß<ú€p0\ì»/}0Ä®#\ÏO8\Çt„\ã!\ÛLw\ÂûÀ†0\É\Z<²\Ë\0\Ã0\Ã,¢\Öu°%¯ø\Ç\î6\ã#ô‘m\ÜL;-®w>ó\ï¼õó\Ï,0\Ã-\ï68À\Şöü†h%³Op\ß=®÷ÿ\0§Ï¸\çı0\Æ\Ã1\ì²ş\ĞU /º˜\ì\Çú(\Î\Ë)+#I\Çˆ\ÇøD\"\Í,G\ä\ë\à€\ÃAC	CPQ-R„%gŠ\ÂJc\Ã\Íûiò»3\Ú<ˆ¸ÿ\0(\ĞùHL‘\Çú*S\åj†\Ú:\Â\r \á¦JºmMLõÓ›m{\ŞR\ì;¤4¸ø\ÇO-†÷¶ñÅ§L\rÄ›2?3\ïH†õ\ÙM$+Ìª\È¼yå¡»#œv\Ô\ÃUd2\ÊµÀ™m\Øf°\í˜#\ÏF–\n&4¤À“ºÀ?Lq\î»\ÆaöX$°„Ê˜wÊ¸eÿ\0eù¹”\0\Ç\0\î°|\Â\Ğ?…s\é+\Â,«<ŠjK£}gı—6˜«\ë\Ìš3ù\Å;@\çEh»ú<)*„¢kºWˆùMa–—y—,U0œ\Âg&\Öp\Ò\å\à\ÕT!	#ñ\n6P-\Ò(\á%\ØhW¡¦ÿ\Ä\0ÿ\Ú\0\0\0\0\0\0\Å\Õ\èªZu\ÛS½\æ\0õ\'9i	\â\ß	+qˆO?÷¿CIi©WÒ£³©}&N\È¡¶öh\ça/:z›}Z\é\Ë\ëe±/®sLn¶Å„g\é\è‹qC\'O.ğ\Ğ\Ş€\çBØ”qv5n˜­Ÿ\'qşû‡\ÍTû\ÎH:\È#),¡¶MuW—Li\å\î4¼®úƒ\çaº®Lõÿ\0u­zBcSqG\ZDPK]úwv+¶ú\Ú\'€<xû•#09]\Ø\0\Øe<a,Uÿ\0¼‰›\ß÷C ÷:£\á+\Ôğ\Ìş¬÷tYtU\Â\îóE·=\Ù7º=5 [\àšø\è\Å	TcU\'ñ\ÏI\è\Z¹\n)\íUGŒ‰\Âu²Æ™$³²\Ì Iú\ä\Ã\î(\Æ10$´	\r$\ãÈ¨\ß\ÇN³ÚƒI0®Qh\ã>r•\ß~ÀÁWoœık÷\ËoñF\n”Õ—¢­O‹/(\ë\Ï}ZUÃƒ\íü\ç]´?ü\Ø\â\Ï<€\è$³f3ñ‹9­º‹\Éu\ryıñ¬Fª\rgªûW•I´0ÁLt0\ÒOœDtdM5\Z¹ˆck\ÆyN„¼«^\Ñ ÷ö±Ğƒ`~û©ŸÁk<i®\\A\ä—\ç\×}÷¿\Ès\æ\æn\à\Ä3\Æmÿ\0˜D£8oM`…º\ÆK›•­,\Ã\×ÿ\0º€õ~+Ö¶y\Ã…4¨-.;Z\á\Î4;;sxÔ‘Šy\ï\"w\ëc3-A–QIOS\"œ™\"\Õ$²¾ÿ\0»±\ËqTŒYlF§ø\Şj\ê`4)m¿\Z‚“—r\"Ò¡z“úp…ğ¾\Ş\àıGŒ´,MA¤·:i—Ğ˜f\Û=8\íTµ\å7û~(†¬\ÅMe\r2˜İŒ\É0‰5\ÙNgOÁU\Ş\"ûamy†n\ß\Ç(®)<g\æ\Ş0\Î\Î›¨™-\0\Ûvy§$QOY\ê\Şcr?vK+o±Ÿ­Qœ°@¤…÷¢\ÃCB\Ìú\ÏVx\ĞÇ%\ê—e{µş³©ù“I[‡\ì,Rô\ÊV\åòó/®OÔ­%\0\Ä\Ä|2wZİ¹«U‚‰(½\ÏzJ\í+G\Üş/.¶:?\èˆF£™~\ãb]¤pğ\ãœ¡¬ €\Úü\Üò‘¿û\ÌğÉ™ˆ\ß\ëLı²8óš¬\Ó\Ãx\ã\è“.¼\Ş\\\\Y\Óşj\ÂH.ş\éo\Â!j|ÿ\09\Ût2\î[\Óùüò Zmpz¿\ØYõŸ\æ\ŞG,g£k¾¯/°$0„\ÜÓ®$XM¨™¥¹³óõz}nW\èï’®K!S\××‚9\ï¾8\ÉI_\ç\ÉX\àHJSN0\'\În\Ôm;)Şˆ\ë:¢R”ùbº\ß\í‹ú½._/¤Ot<bXóöÁ‰<\İp¬U·¢Y­\ÇR\îŠ\çy6¤|J\Z‰µ\'\àw>\Ø5­¥4|vo\äÇ‘V*A\Ñf‚9ª,¸OXb™_7\ÔS¸¿H„\é/“ÁQaÁ\n\É_‚8v¹’\Ü‰HŠA\í¨„Æ‰—\İi%#\Å\ÔaS†9?\ĞVP\0L£‰B„‡5ŠP\éï¼\ÚR¸j\êÿ\0›\äC\0£,:t÷Lÿ\0\×ú\ÙlğË°R(ªù<¾Å†XŒ…\æ_F\Ùt(\Ï°dmz­×­H(\0‹8»\ë\"\ás\ã\Ê~©£‘¤!/e0;+kaOgx\ÂG\âH\ë	°Á\Ã\0Àÿ\01<ø\Óv¦ä«4ñp\ä\0½»\nIş\ÆG\Ö <±§\ä\äÁj`²ô-SrZ†›\àj|8u\â_	‹\ZarAJ\Ä\Ûm·\Üğ\Ä3ª	$\ã\å& ’\ß2„¦ŠP\í¹`Š­\Èó2\0«C+dûp!¿\ëCz\'®ß\Óô9ÁAµ€\n¬£=¸\â2~X˜¡5r\Ã\Ü;À\0E\n:¥\ÚNƒ”NQ£¹ûZ\'ˆ¾/Ï€\ÖP÷2\Ç.\ß`\ë\Ş\à„@-7ÿ\0º\è¿P4ƒ$\Ù¬ør/\Öõ\Ú\ÒP?¶Xy\Î-=»ˆK\ëÏ¼»\ßò¿C@Q»ò\Æo-\ÅN›Š\àQ¦µ\Êot÷>­º\Ûü¹ö\0Ÿÿ\0:×¾?9¹~=…\ÍcúŠ\ß÷\Ê\Ön‰†8e\á1/0óB¥«‹\0s\Í\ã\ßø\íóù£C\á^¶¹ğy\ï<ü¦÷øI¶1Í°\ë¿õ\nü\ÌP\0wÿ\0\Ï‘9H<\'\ëg„l¹\Ò	/,…\"uH2ó®ñûI²[\à”}ü\ç—EÛ´ô5wm|ó\Ïl/°*Z¦Û¶\ï^¡¦dA\0l&0\ã\rµDôŸ“9\×ö\éõ…SEôOk˜\Î_°®mqxô“°=w\Ï_\ì0\Ó	\Ëk\Èuœ\İSıO\ÛUÖ”¾\ÑôG_4Í u¤†!\ç\ÈóI\Æÿ\0ó\ßud\0”¡\ê‚cKx×¼\\6Xˆı\âE\Û(€9yò“M¶\ŞA\0\04\Ğ	YWÀ¤[d\Ü}6VşòüµE\Z}\ĞF`!ŸQµ\×uô«\Ã_\Z@ff¯KùğQo\Ë’\ÇI\Î\Ãx£\ã\nE\ãœiD|ıÿ\0I7^\êˆø,m+Ÿ=„9¡d\à\ÔUJ\Ó\ËÃ±)„›M@Eı\ŞM5nJùğ\ÖM2!¦\ë\\ABJ-\Ô,‡÷\ï}§—/B^	¨Eøh&a»\êsü”Œ\'\Í\Å×¤v›\\\å\ÏÚ½\å\Èv\ĞE¶\ëN¯1¹n,Ğ—¦˜\Ç \Ş_iñÚµ`³\Å\Ù\Ë4<$l97t\ŞZˆ$ºIbtŸ\Ö\êZf\Ùr%~ ôHŸ_ód£®(·B\Ï}5\ß÷\ì\åt§ºÃ›ğWm~÷]\ïÁk€P);5³\Ö@¯\'Š±Ş´@I0\Òü\Èşr.a%CT\Â\ÖW›õŸd\áö^¢\\‘|Ãœœ{¿¯6ø\ÂW#U\ËvN…(pyù\Ñ\Çk\Êm”P0ñ»ò9y©¿ìš˜ZwŒR‚”òV\åm\"öKÀ\ãMV\ÒZ\Çl\ÑdVf6±SQ–¬*ŠKg·”_\Ûp%dw¦\\CM‰”PQf<¯\Ø&\Ì\'I\çR*ğOY\ïûSÎ·\í5\"@\ØN6z,?\Ï\r\'\Ë*•txa¸Ñ‡\Õ\Èc?A\Ä\è\Ëõ{ü\å\É_<HW¢7A5ğşº`O‘“E\Æ\Ş=1‚hŠeWÃƒE\ã\rÿ\0˜\É\"\Z\Ç÷u6²z\ë{¢h1[)%¢óLtü\ß41úüø–•[ş\Øyû\èX`ÁpÁ•Ÿ4Í†©d‚]e\à$K\ì1ów^İ‡\ri9!“¢›ûs\Åa‡’óAf¥V=‡O\átœ¬8 û‰÷™ñ4\ç(½mÿ\0WŠx»\ÃO¥²O5Ş³Äˆ<j\Ù\Åb\Õ2ù\Z2(r† \n\çeĞ€\Å%¸U\ï£Ì²¢®s\Ô\Î\Ûªb\"\â+­?Y5Õ˜O•Q÷œ×µ\\øp¤2€^Uq\ì‚t9š¾şº|·*]òÃ¾ø÷¼˜S\Òó»ò»/s\Şx?x!_]&TT€y>Œ p]V@mşÃŒÿ\0\Ïö0ûN•ş²Ù›/\ÓNV\ÎÑˆ%¦›\Â\Şk`x&gd?=$ò\ÛWQ^ÿ\0\Ó8ğşğºüC¥rO«$\Ğa6\Ö%n©\Ş\âIaJ1Ì½l2ÿ\0t\ß.O>\Ó\'5ŠIÌ¬\ïã‡¸Â“w›\Æ–“4YD€\Ä„0\×\Î\ç\âˆ\ì÷(–mP²Ù¤ÿ\0<›<×™\ê\Ú}:²d]C÷[h\êz\0¤\Ç5\Û\İ\Ì34…µ/,\ã\àŒü;\Ô<\ÆÜ‡\ç<\Ó/OF<¨0qv“\Úòû\Ù8­Â¤ ı—÷U\âzi¬T$˜…†XX€\n&\Ñ\ÄaV—Iw\îÁ‚|>J\à&C;>\Î|\×gŒ·şB>);Ş¸$Š\Ç\ìivD\Ó\Ë)&›)¹\àS©N\0€\ãÄº\ÎpD{?ûoş\ã\Ûk–Kbû\æWAöB3\0´¥q’SÁy–ûŞ¼Q-ãƒx\ï\í?\Âç©–™õXS\0No\èá‚„%û\Ä=¦\ëŒÿ\0\ï\Ïh‚)µ\ßıû\Éj²\è”1w\Z\'rNœ¸\à¼ÀÇ™•€q\ã¼\Å÷\Óz\É/¢3ó¾0Ö‘‘\0xx`Xk9òØ¾\É\Ê;©t(iğÿ\0{g\Òy:%\ír\Ï>ú 	‰ñ$\à\Ï_\\—O\à†¡²\Âı‰r\ËX²\ê5M\×\Ò4£J×—„“\nC\Üu]2l(3–)£°¾|Ô‘G2\à0³KS¤“Ÿ°±Æ³ÿ\0ôFg\Ì-“ù\ëtòA°<ª¦°(s.Óş\ãDòÑ‘r\r7Œp]€\äA6\Ô!­\ïz\Ì\çùX!­nIu\Ç%\áÀ	ÜŸ>¢	Ã?ıÿ\0‹©*b}û•‰ø­µ¤7\í—Tú\Å,\ç\Úq¶\×«o¯¡4ö\ëWıÏœ]ß¾Ê–™,¡µJúe³\ì^ho\Ïß³\Ã6—}< 	rº«-œônˆU|ĞŠ0®ó’¢{­BÃ°ü\ÜNy›[¬£¹ô(\ë=A\Z™d \Z„(=\ë¸\ã«\Ëô‘Ì¹´€\Â~kh\ã\Ç\å	3Ñ¿-4\Ã\í¹B²\Â\è\æ\Â?\ãı“–¹	Yk„fw\ÇQa‡[j©\Ö\ÕxÙ¹\ã\Î#†sc€v¶¸\'.ù&(“\ØY¿ô¸Ï²—ó?‚|U¾oq\è÷úL	›À¿y¼üK\ïû\Ì0\0 <\â\â“Ô¥-`¥š.§¤°\â\Ø;!’\îúş#Á§·ûÿ\0,´4\Ã\Î\Â\\òóğ<q”y¦‰d€(\ã´\ìR‚M„BSÿ\0\ä\çk\ëŒ4•\ßú¨´s?\ë1\"\Å0&‡³¦\Å6ƒôUq4Ÿ¦\è<&\ï\ÆxÜ•uü \ïù#/\ì\é\ï¦t‹Z«µ³O¿ ³\ÙpóÁ=.Ø‡\ï\Ç\ËC,ÁdRtüú]÷&\ä2}õ\ÙZ \àüßµˆù\è&\Ü#\ã6³•@ğQr1\0Ã˜.+œ\\úw¢³\Ã\ÂL\æ	r@&PÀ¤–ş\Ü\"ÿ\0lCm òU\n¹á¥ õ«\í\î—2\È8\×MfšŠE\0ó¿¼w‚™r\Ğ4ªA‡\ÍD~`3o5\ÔF&\å\ëM\Ü °/<1†\Î\'ö„Ë‹$2	\â\Ñ*\Ì7p5LT¯!\Äq^;œQ\Ê1\Îy.$\Ê*NÄ³m\rmOJ\rPÅ’,>˜NO\Ö\Ï\ŞÛ›ğ\â^ó\Å\â¬\Êö\Ì\ÛN(\éA‹\Ù`Ï *08\É\åº7|\Å<õ\ÒR\Î;¦1ivkPhoµYeÿ\Ä\02\0\0\0\0\0 !102Q3@APRa\"qBb#Cÿ\Ú\0?\0s3hs½\ïw´W–\Ë\Ù:4]ÈMš\àB-\Zš\Ê+©=YM\ïe\ì\ß\r=˜¶e–6ö]D?%\Ìe–vP¶{QB%4^\ÑÊ\Ûnß˜\Ïg²\æI¢ŒLx\ß\×i\"\'gõp­µ5Q©¬\ä\Ë\â\\\äP¹Q\\7\çQÙ—ò\Ù\íB5µ\Ôy\"z®^ká½–\Ñò’({^İ™ÿ\0\Ù\\”b­§·sq\Ú\ç²\Ùy(|ºCÙ±\íôò\Ó,b‘e•ÿ\0\Ø^\Úı¦\Z1¶\Î\Ñ\Û55m]\"DùpYe—µğ\'ÄŠ÷{>òø4=b•#_µb&«¤\Û|\ÌÌN;,±2\Ë/…±vV—SÂ¿\Èğ¯ò<#ü	şÇ„‘\àÿ\0\Øğ\ì\Ï¿&x%\î\Ïvx(û³ÁGİ\n>\ìğq÷g‚»<}\Ù\à£\î\ÏÉ	{±vT>È½\Ï½\Ù\à×¹\à×»#\ÙT]\Û%¤\äª\Év;ÿ\0&/ø\èşLñ\Ñü™ÿ\0Î\æ\Ï_\ä\Ïş\Ìğ_\ìx7ù\rşGƒ‘\à\ß\äx?\Ù\à\ß\äx9~G„—¹\á\'\îxMOs\Â\Ï\Üğ³<.¡\áµ©\ìxm_bŠ)QEQEQE½QEQEQEµ”bQE•ú1F(Á£b…`ŒŒ\Å\"\ËfFFFFL\ÌÉ™3&dÌ™‘™™™™“22fFfL\ÈÍ™\á\Ş\áŞ\ê;\Ã33333333¼33Ffh\Í5\È\Òv·¡Ä¢Š(¢Š(¢Š(¦QL¢Š(£`\É*ŒŒ‹\Ùm[QEVÕº)\r†%¢\Ö\Ï\ä\èJ\Å¡è¹³\Â\Ã\êv¨wrµ\ĞS\Å1=—œ\É=¥&š!m!¢Ÿ\ÈĞ•Ö‹–)ó0¢s„UÉšÚ×¸$5M¡2,‹¸+\Écë¶§TAR)(¢Š(¢ŒQEQH£bŠE£9©Q\Ù;4\ã©³SR\Zq¹3SşE¶Öš¤\ç\ÕØ“‹R;LVJK\ê\"$H‰	$QF&&&&&,­\ŞÚŸB•»ù#B7§#[£·\é9%!i¢0D\ÒIŠ=\ëq\Zqm	‘dY/9\í©ô!\é^vHL[¡#BU\ÈÔ…«5 ¥ŸÔœdĞ”½‰i\Èi\ÂjH\íPô\Ít{&E‘bb˜öŸ\Ğ\Óô¡ùh”–Iƒ\\\Ñ	‹d\".ˆ¼¢j\ÂWD´v-$KMQ¯¥\Ô\Ójp–“út\Zqm12,‹\"\Äü\ÆKiı\r?J–³dY=:vˆ\ÈOd!\ZR¦IZ\Z(h×©	©#µi*SB\"\È11yl{jtFŸ¥yh“¨²\"p®k¡		ˆLL‹!+T=™«\Í\Zğt\Í\Z\ÕÒ–›\ê‘(¸É¦\",‹\"È¿-mO¡§\é[¿!\Z•	r\İ5Ñ“ƒ‹µĞŒ„!„©š‘~¤IH\íŒ»½U#¶ióS_]¢È‘dX…\ÅF¼§\n¥³%\×mN†Ÿ¥yh›¹ğ¦Ÿ&N.\×B2„&i\Ê\Õ6†H\Ö\èMY	)è¸¾¨’©1	 .$(“V¶d¶\Ô\èizüµ\ÎM‹…;T\ÉEÅ‘˜˜9S5U\ÅI\"dµ’5u\Ó?œúE²:s‡6¨\í:mTıöŠd.\"$–Ì–Ú\r/Bò‘7Qd:q§|™(¸²2§,£F´¥§qjİš\ÚZ’i¥Ô‡búÌ¨AR‰(Ç¬\ÒÔ \Ò\\ˆi¶FP—\Z¢\ïyu\ÛS¡¥\è[?!\Z½‘v©.,‹\"&iO§M\ÉFq}:¡MH“IÔ¾ƒM“Šˆ‘\\Ke·Ñ‰\İÿ\0{O¡§è”‰»˜¼•Lj™	‰š2¸\Ñ\Ú ´µ›ŒºõCr—VbbbbQEy†\ßGıÿ\0/\ïmN†—¢;?#¢#Õ¿.\í‘\nGy$,î¾­ÙE\ryˆ‹\İE«şö\Ô\èiz#³\ãD\İDN‡T\'(\Ëu\â\\\Ğ\î,Œ‹,¿[6=µ}&¢;>4j}D)s\'©\ßÑ‘r‹\Æ]xl\å$4\â\Å\"÷~rÙmOK4~|§\Î|›\åDH³SMjGöFM<e×…2”\î.…\"şN[jz£ğ\ã\ä·I\àD\ß2\"54Ö¢ödd\Ó\Æ]W\nd’šı–\âé‘•üœ¶\Ôô3G\á\Ä|h\ÔuAr\Û8\İ^\È|Ø¶LL\Õ\ÓSV¹22úK¯\nf®J\×QI\Å\Ó#+/\äe¶§¥š?#5]\É!\Z³\Åw2	:ˆ¸™«§šµ\êD®\Í]55k©8ºb\"ö\Ôô³C\á\Äc\ã\ë¨\Şİ¢¨ÒÈŠ5)Oè„©qY(\å+¯c\Ú~–h|8Œ|M\Òd6×•º³B\"%Í‘á”¾ˆK=\Úù=§\éggøQ\İğ\ê:‰H“¤?\å#N4‘ô>¢\à”«’ù¶KizYÙ¾øµ\É!\Zò’ti+‘.Q\"-\å*ä„¸\ÌKiúYÙ¾ø“½Föi1E.ˆDÈˆH”«’ù\Æ=¥Ñ›\á-Ÿ&i®WÀ‰sbBD¥\\—\Ï=¥\Ğ\ì¿gÃª\éT¸F}D‰Jº	y\åå´½,\ì\ßc\á\Ôw8¡n‰tØ—\í_.\Ét[K¡\Ù~ÿ\0¼k£|\Ép^\Ïd¾f]6}\Íğ\ß÷³òu\Í5\Êø]2¸PÎ¢_4ú-ŸC²ú÷³\à\ÖÆˆt^[gQ/›}6}\Ë\è—÷³\à\Ôw4…\ä\Ğ\Ëm‰|\ã\é³;/¦_\ŞÏ‚<\æß‘LCt6\äÄ¾uôß³t—÷³\Òt™¦¹q­›¡·&%óÏ¦ı—ü¿½ú¯’Dzy\r\ÑnLJ¾}ôß³\Ïy»šB\ãn†òb_`}7\ì\İg³\İs›|wE\Ûû\è÷\ì\İg³\Ún¢\È*\\MØ¾\Âú=û?ª{=µ_D.œ-\ÑvÄ¾UùÏ£ß³z§³\Ú\\\ç\Â\İØ—\ÙıŸ\×1Œd9¶ø¢\í‰}•ôß³ú\æ1š¢C’İºGQ.ö£ß³ú\æ1š”ùf\è\æÄ…Àş\ÅôcÛ³üIc\ç=›:‰}£\Ü{v‰-¥Ğˆ\İØ—’¾\Âö\ìÿ\0_\Ö\Ó|„\ÒGQ/´Ye–hº\ÔfD\Ş\Ëk,²\Ë,²\Ë,L²\Ë\Úö²ö¾+Ù–X™e\í|L{iu{?Ÿ\\v-—,\Ò\É\ïe—½\ïe–^\ÖYe–X¾^\Ë\ßO«,²\Ë\Ú\Ë,²\Ë\Ú\Ë,\ÈÈ²\Ë,¶Y{_\íe–Ye—µ–Y{µ¼6~Rò\Ò(Ä¢Š11111111111111112,ox™\rù®tw¨\ïµ\Å3#\",²\Ë\á¾+\á²\Ë)”ö­–\Ï\Ìlqlqf£!112?-‚;¸û\ÓFÁÙ‚;´wGv`wgv``ì–›#¥\î8£4e´U‘ˆˆ¢¾^\\2t™22.¼4QE1š\Ê\ÈÁ²0¡DÄŠù‰p\êzY,ƒ\à\áb…\n%QE|´¸g\édD\È1ù48²0(¢¾f\Ë1\Ä\îQÜŠS(¦S1f,Ä”eô!	İ¾\Ç|W½–Ye—Áe–6^\Ğ\êW\ÊQ‰EQEQEQEQEQF;Ï¦ğËŠ\Ë,²\Ë,²\Ë,±²\Ë,²\Ëòoø/yô\Ú\Èz\Ö\ÏÍ²\Ë,²\Ë\Ş\Ë,½\ïÏ­¤­\rV\Ë\âGf‘H¢Š(¢‘H¤R1E#bŒQŠö1±Œ}Œc\ìccû\Ç\Ø\Æ>\Æö0‰„LQ„L„L\"`ŒQŠ0FÁ#`Œ\"`—\Ù|X\ìş\Üú\íÿ\0¤vj[±\íÿ\0¤|—öw\×oı#÷	mÿ\0¤~\á-Ÿ®p–\Ï\×¸Kgë‰’-#$d‹E£$Z2E¢Ñ’2E£$dŒ‘’2FH\É#$dŒ‘’2FH\É#$dŒ‘’2FH\É#$Y’2FKvKn³ˆú\í\ÏÊ·\Ç\Ï\É\ç\ÅEq®Ke\ëöK«û|•˜Š?\É1Ç™‰‰‰ƒ0f&&&,\ÄÀÀ\Ä\ÄÀÀÀ\Ä\ÄÁ˜3`\Ìƒ0fÀÀÁ˜3``\Ì‡‘^Ey¼¸\ë\äŸ\İW\Û,²\Ë,r§\é\â;\Äw‹Ù\âögxfğ\ï³;\Å\ì\Îñ{3¼^\Ì\ï\Ş/fw¨\ïW³;\Õ\ì\Îõ\â;\Õû;\Õû;\Ôwˆ\ï\Ş#½G{\Ù\Ş#½^\Ì\ïŞ¯\ÙŞ¯\Ù\Ş#¼GzwŸ¦w¿¦wŸ\Ù\Ş~™\Ş~Œ\Îğ\ï\ŞQEQEQE\"Š(¢Š(¤QH¢‘H¤R(¤bbQEbQH£ŠE	QE”dYe–‹,´Z-##$Z2E–Ye¢\Ë-Ye–_–Z-Y{Ye–Yh´Yh´;9”\Êe2™L¦S)”\Êe2™‹)”\ÊeH¦S9œ\Îg2™\Ì\æs9œ\Ï\ä#™R9œ\Îg3™\Ì\æs9”\Î{s9œ\Ï©\ì…\Û\'\ì‡\Û5\åGfzÚ‹)¤¢R)\rYfH\Ïôeú2ı~‹^Å¯c‘\ÈuL}©¦\Ö\'ŠŠ<KöC\í/ñG‰—²<L½ış§ˆı#\Ä~±i:)Š‰H¤R)ŠE\"‘H¤Q.Fffgy´N\Ë\Ù¤³—¤ª¤‘E$—\nò5~$¼˜G)$%I/\"Š+…¤\É\é>±¢\Ë-³KZY>QBI*H¢·q×‘\ÚıŒ¢·®Í§K/*ö®\ÛSMI\r4öì–ZóöŠ\ê\È\Æ0ŠŒU%µ™#349\"\Ó%²ò5\Íğ\ßŸ¡^E\ï{Y|\Z±\ä\Ù\Ş„4 £\ÉX\äX\ä&6Yc~Kt›²¹{ù©IyTVÏ‰£´G	~˜\Ö\Ìc{¿2|\á/\è\ìÍ½&ŸT\Ú(¢¸a\êBò+†¶ke¿h†Zo\İ[2^Z\á}\r4á¯¯İ=Qô^E\ïe—\äKi\Ë\\3–)giº\é(\Ñ5Ï\èĞ–zW\í\Ä\Ëİ•»\Ù\ì·ÿ\Ä\02\0\0\0\0 !1Q02@Aq\"3aPRB#‘¡±ÿ\Ú\0?\0\Úm6\é\\‹I1{HkJ$2ˆ²\Ë\å†6\ÅóŞTXµEVŒ|«•Ÿa¤ùl½[!‹\É\Ø~\İ¢Œ–6n±{k¶‘c¢}µ\\‘ƒlŒkW\î­lnÎ¨½^‰{ùBõ½1\âur)-\Ù^\Ë†1/ow.U\ÒÅ¬c):H\Å\é”zË¹\'×šŠ(@˜ıÇ¢z-2üD´Ã†y_N\ŞLXat]Iô\\–Š\Z\Õó>J\ÑKZ+J\å­\äÈ­Cµdc¤™\'\Ğ}ùh¢Š(h\Úm\Z(¢´¡\ÍDq\Å^/ôqQ\ÅG2ğq×ƒq\Ïò?£ı\äG\ãœsŒq\Ñ\Å8\Ç\ã#Œ<¶)%öd¾\ÇùĞ½Mu£ü»_<\ëÁ\ÆGe\à\â¯TqQ\ÅGU\àâ£‹\å‰Ä‰Ä‰Ä‰¾&ø–Y~İ—\Ïz\Ùe\ë|·¥–YzYe²\Ùl¶[73s6›J(\ÚR6£i´Ú¦\Ój6›M¨ÚˆÚ¨\ÚlF\ÓiµQµM¨\Øl6Œ\á›\r†\Ãi°\Øm6›´\ØÍ¬\Øl6\èŸS$RzYb—-\ée–Ye–Ye–^¨D`Ÿ\Üx\Ú6›Jæ±²\Ë/K\\»È¶Ú¢s\ÜûiZ/~\Ë\äŠl—AMÙ“\×cÂº»~ú¦i¿\Û\Ñ+\Ë\İÕ(q(k\è\"Ú¶¼	¿%³^\äú6.j+\ÜDDõ\ÙMöDı|\äÚŠ¡¶İ¶aÇ–m(E³\Ó\â\Ë\éö\É\Êü¡4\ÒkF†1û\ŞE\ÛL=\Ù7û–\Ë,¶Ye\ée–Ye–YeŠF\Ô1úibŒ\å\Öo¢=w¬\ÅÂ”n\Û]‡\\²¨E³\épI<ß‚\áQI#£‹‹=3•8?¶ŒÇ­–Ye–Ye›´_r=´\Ãò\'òH\Ùú\Ä\ÚõX¥\â=™\ä\Û+\îÒ³$\Ş7÷\êµD¦±¤Èµ$šÑ¡¡¯y¶˜{“ù?{i\\²g\ê^\æ\Åiu‰ƒ3W	}û3YBq’}S0\åS„d»4K,P³Åº)dƒ‰\èò5x\äú­$1\Ü_Á0ü‰üŸ¸\È\Æ\â\Ù	©t}\ÉDz²DÕ«°e“Š\é#lrJn?”zoUûv\'ø%–VFmHô\ÙY•8eX¢2RŠc\Z$4?q\í¦‘?“÷{A!¢Ü©÷%¡Œc=n—òˆ^<´\ßÿ\0\ÓG&)\ÚL³\Óe¦ˆVH85¹c—tõ’\Z\Z·:aù>OÜŠ¹\"z5÷D\'¹S\îN#\Ñ$I¨z}¹/\ìÄºEùF)Z…S=4Sx3\Ã*\ìû’”SZ1¡¡­²ˆ\é‡\ädù?m˜•\Êü}uk\îˆMIS\îN#C$HõXV\\mQ‚]^):ğaH¯º!\Øô’3Af\Ã(Ÿ§\ån.\ïš´1Œ|Ò•k\"¶\ëDGL?3\'\Éè½–c\é\Ç\È\Õ;Dd¦‰F††††\Ô0ğò\ïK!=ÑŒ\Ò\ï\ßò`•Æˆ˜-It‘’\Ç\ê”\â¿l—R.\Òz2CùY6\ÌRjU¢\îGL?4dù¿mTR\æi§hŒ”\Ñ(CG«\Ã\Å\Å(\Ñ\é¥Y%ŠN¯·\åT\Ì8Ü˜p4\Ó„\ÊI6<Ÿg¥Ì¤\å\Z2Lc\æd\Ñ{d‹¹\Úbù£\'\ÍûqW$Mõ\çvº¢2RD\â2H’=~‡\Ô,‘\í/ÿ\0ŒôÑ†d³Å¨Æ¿rğ\ÏK\ê=<!$\æº¿V\î±Gÿ\0¢–\\\ÒRœÙSuq=\'¦œe¾r\ë\àr¡\Èl“\çcFHè»¢=´\ÃóF_›ö™‰ul}ı‡i\Ú-ID‘$z\ßN³aq®¿c\ĞfPy0\äÿ\0\ÛTü2xrc\ïbƒ“I+0z¨§?ÿ\0Da*I!I!\Ê\Æ\Æı–d\í¤{“\íÆ˜~h\Ëó~\Ü:AûMWT\'d¢IG\êX8y\ã¹Ÿ¦d\É\ê½*Y1ôJ·y1`Å‰%Y¸\ÜY~\Ó2h»™>0üi‹æŒ¿9{r\è’ö\Úi\Ú;¢Q%^›G$n)\İ\É\Å(Æ’7›™eû³W¤~Dİ¨\é‹æŒ¿9{PW$I\Û\älNšd”d·G™ªv…RC‰E}ZG¹w¦/š3$½–b]\Øù;±®„&ñ\Ëú\ZMnnn±b©!¢¾wB\Ó\Í¿’^\Ò\éX.¬\Ñş¾\èqMnnZpb©.ƒ‰^\ë\åOª˜¾h\Íü’öR¶O‘]£F<ò‰E5º.\×4[ƒşŠRV‰G\è—tGL_4fşI{8\ÕÈ“¶ô–±\ë(5£D=Z1\äx\İwLœmnnVŒr\Ú\èi48•\ï=>è˜şh\Íü’öqtŒƒÑ¬\ït›«\è‘\ë\"\ã\é\Úvÿ\0$şLŠ¹\"\\­²ltş,œióc\È\ã\Ñö\Zµh@»‹L4gşY{5XÖŸ¤q\\]G¢}ÿ\0\'\ê^§l%»$\íÙt²C\åŒ-\Û\ìI\ß5{cV7ô+H|‘Ÿù%¢\æJä‘‘\Õ-?N\Å\Â\Ã,RM«\İ}ú†i\ä\É\ÔbU>X\Æú¾\ÃzÖ‹[ú.\ïHü‘Ÿù‹›\n¹“\ë&`\Æòe„R»fJÁ\é\íE\Ãú»=Nie\É):\êÄ­¢]‡\É\ßW\Øo’Ç­ıw¤>H\ÏüŒ\\ø•A²\Ï\Ó0b–J£*mµ÷?Tj)F\ßn\Ã1ü¬›±õ}†\ïT5ô\èû½#\İÿ\0‘‹•\èÿ\0n8\é\Î\ã&‰\åÉ‘·96\Æ@–±õ}†ù/\ê´\É£ù\ÊÈ«’FWö\äd{dc}_a½V«Gô¨]ôs\Ô|ÿ\0ø…Í‰\\¿\Éò}\Ñ\ÙŒo«\ì7­r·ô\È]ÿ\0ø´]\Ñ\ê>üB\æÆª|±V\É1Fú¾\Ã|Õ¥ı:#\ßDz’ü!sIm\Ç\Ë¯¸ß°\ß\Ô!w\Ñw=GuøæŠ¹$e\î—#¢\Û\ä½\Øo\êQú#\Ôw\ãEÉ…\\¬›¹?aj…\Ğo\ê\ã\İ~4Fü~4\\˜úA¿bµH¤ß²¾‰ºükŸ´?\Z-Xÿ\0l\çE­:E\rıbuø\×?l±W$d}yôI\"†\ï\ëP»­süqş-p¯\İ~	w\æC³¤Q\'^»\Ç\\\ß\\·~yPôJÎ‘DŸú\Ş:\åø@B\Ö]#\ÉZ¤tˆ\ßú/ü\ë—\áH+š2;—2GH¡¿}ıü\ë“ø±‹\\?v>\ïW¢GH\ßú5ö\×\'ñCE¤V\ÜoDŠö_Õ®\Ñ\×/ñ@B\Òn’\\‰3¤Fı…£úwª<~u\ÉüP\Ñ\Õ\Í\êõJÎ‘Cwşó.\Ëó®O\â\çDb\élnôJÎ‘C~\ëú¥\Ù~u\ÉüQüè„«\Z\Ñ+:E\rûı\Ù~uŸğ¯ÎˆŸ\Ù\n\'d_²ô_[G\Ù~uŸğ¯Î_¹[:!¿mınÒŠ\è¿%2‰/ÿ\0ü”c‰\ÛJ+J(¢´¢Š\ZÒŠ(¡¢´¢†ŠÒŠ\Ñ\"´¢ŠÖ¹Ql²_\r\"\Ë~\Ûö%—ô5H¢´—\Å-h¢½š\ä­\Ó\ÑEPş(¡\"Š(­h¢Š(¢Š(¢Š(¢ŠEiEQEQEQEQEXµ}…ô¶6Y¸\Ün7\Æóy¸\Ün7\Æ\ãz7#r7#y´\Ú$QHe	rô:s¥f\Æl63`\âP\Ğ\ÑZW%{µ¥­e\ée—¥–Ye–YbDD\ÕkE\rcú^$,¼\Ë#ˆ\Î#8¬â³ˆ\Í\Ó7\É$\î†òxf\éøf\éø7OÁº~\r\Ù<²x!)_T]öb\Ğ\ä66?§‡~Xü\âM¿‘	¦“¢£\à¨ø*>\n‚£\à¥\àı¾š2È±\Í!\Ìr7\r\éMü°ù\Äd\Ì_2öÿ\0¡Œ]´c\ÉFóqe—õ\î.H|£ù$A~\â Ö©s9%÷2e¾ˆ²\Ëú*\ç\Ú\ÊdE\Éb\Ï44+8ù<œ|N>O\'\'““ş<üœiù!™\ßVO2ªL·\çÙ¢Š(®J(H­+JÒŠ+Z\"¬­+§5iZQE\Ïe–Y¸²\Ë,\ÜYe–Ye–^¶Ye\ë‰u%òzW\ì|õ¥QZQZP–´QEiZ\ÑEsQ^\ÇCÈ—É”%û‰QEQZQBEP‘´£i´\ÚQEm6”QE\íW&7V\Í\Íõ,\Â_-–\Ëe²\Ùl¶Yl¶[72\å\ä\Üü›¥\ä\İ/&ùy7KÉº^Móòn—“t¼›\å\ä\ß?&ùù7\ËÉ¾^Mòòo—“|ò7\È\ß#|ò7³s7\È\Ş\Í\ì\ß!\É\ëÌm!ğŸ\ãEş¶=¤G¶˜şüh¿Õ½!÷m1ü\'ø\Ñ­Üm1ügø\Ñ­Üm1|gø\Ñ­‡\ßğG¶˜»Oñ¢ÿ\0[¿\àm1vŸ\ãı|;‘\í¦/ı~\r¬§\à¦QE2™L¦S)”\Êe2™L¢™L\ÚÍ¬\ÚÍ¬¦me3k)”Í¬¦S)”Í¬¦S6²™L¦me2°ûşv\Òq>…–Ye²\Ùl¶n-–Ye²\Ë,³s72Ù¹›™l²\Ùbe›™l\ÜYe–Ye²\Ë-‰½aÜm#Ù‹\â¿\ÖQDz1*]\Ñ\Ó\ÊT\Å*TZ-y-y7#rònF\än7#r7#r7#rònF\änF\änF\ãq¸\ÜnÑ¸\Ün7#q¸Ş\ÈÜ\Æ\ãr7\Í\Æ\ãy»™¾–Ye\ëeı%ó?yù1ız\'òeû\Ë\ëv›M¦\Öl	\â·jH\à¿(\à¿(\à¿(\à¿úGÿ\0\Ò8/ş‘Áôÿ\0¤p_ı#„ÿ\0\éÿ\0H\à¿úGÿ\0\Ò8ş¢pı#‚ü£‚ü£ƒ/(\àK\ÊyG^QÁ~Q\Â~QÁ—”pe\å\å\å\å/\í\'\å\'\å\å\'\å\'\å\í\'\å\å\å/\í/\í/\ì\ágû\ç²ù/K/[,²\Ë,²\Ë/K\Ò\Ë/K,²\Ë\Òùl²\ËÒ¦\Ók(£i´\ÚÍ¬\Úmf\Ömf\Ömf\ÖmfÒ¬\Úl6²Š)”S(\Ú\Êe2™F\Öme	¥S)”ô¢™hÜÈ´nF\änF\änF\änF\änF\änF\änF\änF\änE£r7\"Ñ¹‹E¢\ÑhÜ‹E­E­mrZ-´é¥£ü\\_\Ùş./ÿ\0ög(=««:i\Ú\Å›±²&\Èÿ\0f\ÄlölömF\ÔmBŠµ\Ü^š\î\Ïñ!\åŸ\ãC\Ë/»81òp¢p‘\ÂG\n#\Å/–ù/E­–ˆ¨\ÈX×ƒ‡\Ç5õ¡CöÇ¬‹û±\ËDÈ¿qş+Yêµ“¤>ü·­–\'Ê›F<İ“4m(\Ü\ÌŞ£b¥İ»lo[…1K\Û\Äÿ\0j7\nDô¾L¯\èhÅ‘Áõ\ì&š½3fPö9[mê‘·©°\ÚÍ¬H^\Ô\í\\µ¢\Òn\ß2Ö´¥\ìa:l¦I¹»eiBE$Q\\™wEm¥\ìË¿2´OE\ìa\è	­\Ñ\"´Z×³’2.¾\Ã\ì?bù,LL\\¸\'¶jû2/DÈ‹‘r¾yu„_ôE*)¨Ú¨\ÚPûµ\í!.Dôz§DK\"G\ßC0½\Ø?e–\'¥–Y•m\Éùöh]ô®\ìE\éX\×\'ÿ\Ä\0F\0\0\0!1 AQ\"02@Ra3BPqr4b‘¡±#`Ás‚CSƒÑ¢\áD$€’²ñÿ\Ú\0\0?W+•\ÊB>\0j>˜@\ÏfSòM\ÍP€QØ’Ÿ^pg\êš\Ä\ã\ÇokˆSº\Ü)\ÒU°¡BÄ§\Ô§9õ>I¬@v\'´…\Z\Û\'ñ\àIğmG=dF*gtoB…\noÊ©[ƒUÙ \Õ>\'!¨\ê\Üog\ë”ç€ŸQ\ÏÀdš\ÄÁc°q\â’nZÎ¦m\í3\ÔUJ‘óP\çfƒ~5{5Ÿ\İ\Â\Ô\nofuJ©Zpo\êš\Õ\ç\à#Q\×\Z¥J\Â|t&\ê=€NO¨\ÖQs\êg—$\Z£\àğ£w%;\äüšôk¯¤\Õn%5…\Æ\ç ;ğ3¸{Ÿˆ=ƒ\ŞJs€Ìª•\Ü\ã\r\É2˜\å\Ù»P\Ôw\Éñ.M\ËS\×*™Á\ØRª\Ök?ôõL”	™#ğÂ‡b|QCrTê¥’;¤ª•ø3>h7šjŸ‡\Å\Ş,o³-q©\Ï\r•R£ªa“Pl(\Ô<DkP\ÖwIñs¾\Í\Ç>>iò]¹V ¸xYS½>•()\Ş\'\ÄJ\\T\êÁªQ|÷U€G4\"ƒ.|©S¨C\\\î™X¬V+Šƒ\ÉA\ä òPy(<”J\ÉC¹(<”J\ÉC¹(w%’ƒ\ÉA\ä¡Ü”KğaMA€aA=\éPy(<”Š‚±XòBu\ÃòXòD\ä òXòDJ\Ó\É6G%k*{	R§\\\îNõª\ÕjµZ­V«Uª\ÕjµZ­V«Uªª\ÕjµZ­V¨P­P­P¡B…\n(P¡B…\n(P¡B…\n(P¡B…\n(P¡B…\n(P¡BµZ­VJ\Ñ\ÉZZX9+%`VKfÕ³f\Ì-˜[0¶al\ÂÙ…³f\Ì-˜[ ¤)\nB¤)\nB®\næ«‚¸+‚¸+š®j¸+š®\næ«š®\nğ®\nğ¯j½ªğ¯\nğ¯\nğ¯\nğ¯j¼+Â¼+Â¼+Â¼+Â¼+Â¼+Â¼+Â¼+Â¼+Â¸+‚¼+‚¸+Â¸+Ú¯\n\à®\n\à®\n\à®\n\à®\n\à®\nB¤)\nB¤)\nBÁ`°Õ‡k\n¥APTAPTAPU¥ZT(P¡Z­V«T(V¨P¡B…\n(P¡B…\nª(P¡B…\n(P¡B…\n(P¡B…\n(P­P­V•iPTAPTŠ\Åb±X¬V+Š\Åb¤©*J’¤«Š¸«Š¸«÷M¡Z¬V+ª\Åj…\n(P¡BP¡B…ñ\ØÆ¨Q¹\Z\ãTk…\n<(P¡BP¡B…\nj…\Z\áB\Ç*nß„B‡Nôü(On	‡¬‡`B…\n(V¨V«T(P¡B…\n(P¡B…\n(P¡B…\n(P¡B…\n59\è\ÔõEŞªG5µpMª\n•*{xP¡B…\n<Š\\šŸ’\ZÆ³ğ’SŞŸQ\Z…©\Õ\0\â¶şŠ–“s ©W)R¥JŸ·«\è¶õ=Ş¯¢©¦¹®µ\áP¯I\í\ä¯o4j0ñ[Fó[Fy‚\Í\rg\á§÷§P¦{¶fš\é£¢Ò­¤ü`dº5“\0[\n~U°§\åcO\ÊÉPª\0\×*Gª5Ÿƒ\ì\'*E4\"òw¨?‡\Â4?nÿ\0’v{…i9­¸5r¥J•*\år¹J•*T©SáŠªU®r¬mu£z–…QùõBn‰Iœ\'\Õi4öu%1\Ò>¡ûw})Û…i\r¸€¨Ò†ŒUªÀ­\n\ÆòV7’µ¼”J%’€ (\n\É@\ä rVJĞ­j´+B´+BµZ¡Zª\ÕhV«}Uª\Õgª±Z­V«}U¾«\ÑiN´\Õ\ÉW¶s\Çr–…QØ»ª-•<‡ç¨­*•\ìT](P¡B…APTAPV+Š\Åb±X¬{YS¹¢}\àı)Û…T\ï…O/…T\Ã¤›\ÅÜ‘¬\à\0ôG:©h5\Ş\ê\İ2…:]\Öş{\Ò½hı?T\rì•¤S\ÙÕ”>\r¢}\äı)Û…U\ï…O-Àö™ƒğm$\Å5N\'¤Ñ:´g\ÙT\Şf	T\Ü\è7ù§i\r÷qõ\áú§\Ôs±s°õÁ¿ı£¤OV›K\Ï0ıŠ÷µñZ ¸û«K`põLt:>\r¢}\çòN\Ü9*½ğ©\ä7-h\áğm K5{Z_%U¶¼…‰`…¡Õ¾œq§2£\Î9x7ô\âªT~\Ò\Úl.w3ş,m\ÓZ¡{ü\Åh‡I¾V÷Š¢Oı\Zq\ë\Å	²®\ÓJ¤¦™\Ñ>óù\'nW¾<‡ÂŠ¨\Û\\©T‚—KŠa…£¿gTr:J©Ÿ\ê~P´ŠvS\ëTtq)›W\áB\çÿ\0Ú¥¡1¸¼\ÜP\0\rZU;\éz…AüÁt_½\Å;pª½\à©d<\\¢õ*{ZÌ‘ª\\E¥Tm®NÅ²‰Vú~¡Tqj²\ç\ç\ÏY”\'Uvl«J~	£}\ëòO\Ü*·x*]\Ñ\â\Ù\ÖOan {R\Ë^ƒÀƒ\ÅiLL\Î\íXç¨„\år\ZôªwÓ!Pw‚hÿ\0z$ı\Ú\İ\à©wFå¾¥@¡†ª+ö@öµ![œ©œ\Ä8¯v\î*‹\ï`ETA:\ë7eY†øñš?\Ş[òNİ­\Ş\n—txª\ç ™’`\à\ËN {Z­„yª\í\â˜x-ğ\ëQNE\r\Í&\ìJ‹ñC\ïLù\'\î\Ö\ïKº<SÌ½\r@¢‚{J\Ú=²fœ\ÙT«Lu\Í§„\Ö\ì¡Ui§Q1\×	ø¼³äŸ»_0©wG‰8\Ì]¸\n <\'°´ \í*6\npU\Ù\Å7%PtuQNŠ”5\éT\îeÜ•\Úc\àT~óM?v¾aQ\îøš\Æ\Z©\ĞQ\á9¤=›\Ä\ê¨Û‚\"\×&¸)¹¨„F\îrVXò\'\Üß€\Òû\Í4ü÷k\æ¨÷G‰¬q„Á†ğ)À<\'4ƒ¨Î£U\İb!i÷“!Pt:„Vk\Ò\é\Ü\Û\Õ\'Z\ä<]m:<;\Ç\Ñ}¡]Ç«Or—\Ş)\'\î\×\ÍQ\îqz\à§4<\'R\ìœ\Ùf\äqS…¤„0ƒ*›¯d¢Æ¡®$ªÌ±\ä*NŸWk]\Ö3ñr~F	h“Ì§¹­\Ì\îSû\Å$ı\İ#5Gº<CŒ4¦gØ‚œ\Ğğˆ„\n²ªÁš ]¸Ê§\ÉhÏ‡\Û9¢Á5\é´\äª­\âa:¥:#®aTÿ\0Pu{˜\Ñkr;Œöô“÷t…Gº<Es\ÕT\Çd\n{C\Â\"*{™<•F\ÈY\rt„\Ç\\ÀQN@¡®.ij¶\ÂP3¼ğZ{e ¦›^’\Ø\ÏqÚ—\Í?vº¡\İ\"±—Bn]˜)\ìDB\Ø\Ô	Ê¨\Å0ğZ;\à–\êpV\î\é_‚cº\Èn„<f\Ü\Â\ÄW¯D;–\ã}µ/š~î¨wGˆ\Íı¨)\ì¸\"!‡`\á!H\n¨†\ÆS]-D\â±]^j¦•M¨\é\è§Bc¤n<ZS-¨U,Z\æ\îkKæŸ»¤*\Ñ\á\êiTó\íOeØ@ {\n\í\âŒ9ª­;N`ª\'0¨?Ti\ä©^›=ë¢}w¿\Ğzj	\î,Ê¡8\ê\Ø\Ïl¯õ\r†ªx<niK\êO\İ\Ò\èğõ\Î\0*c\ÜQ—b5\ß{n	½Wb«4–ú.\ê.ˆt£¦\ÑcDby*ºMZ¹˜†\ä \Äd;¥4 xVæ«‹è¹¨ˆ?-aÔ¥õ\'\î\é\n‡pxz¸½7/\0ÒªSœB„ß®\Ìe8*Ì·#*w\n\r@a€@s\ÕNšTxaˆZe;+»\×XF£Vœ2™¢¹á­ª7t…£÷†\à†/ğM)ô\ç¨o½²\Í9£R¿-ÏA¼J”\Ö9É”ƒP\n<E2¿Õ˜!¯\ÖÆ—T$pH¥LUa\r\î\éG\î\rP\Ã1\à\Ú\åRœ\â;\Z\ìâº³ˆR$´ˆU\è†\0AA¬”8\ä:<\\ƒP\n<<­$_L\ëEÎ¯\È-+¾ßî´~\àğ\Õ\ÎA0a\á\Z\åQ“ˆ\ì$#!Ê il§IPƒI\È&\è\ãŠV¨P¡G‰:\ÂÑ³©òK\ï7ç»¤d´n\àğ\Õ½¼+\\ª3ˆ\ì*\Ó\ÆUW1\î\à™£s\Å\nj\Õj…\n<pZ7yÿ\0 ´¾ówtŒ–\Üä›‹¼;\\ª3ˆ\Õ;¤¬o%`V«T(P£Ç…¢÷Ÿô­/0†CsH\Éh\İÁ\áj˜b¦;\ÂqU9µ1ó\Ú*Œ\â>£=»W6q-ZV.pšFKF\î\\\âf]ˆî“©ª¥8\ë\Çö*£#P\ß5Z\Ç\àšM\'sN!3D\Óz®s\Æî‘’\Ñ{ƒÂ»¡\ØSM\ÕV½`˜ş\Ì UFF©\İ-0ƒZ2u\ë~[µòZ/pxG`Ò™‰\ì[š¬q\Ô5Ô§n#$\ÇOf\nS\Ù\Z§\á/\î¯q¿-\İ#%¢÷<%c\ÕT\Çb\Îi\ÇÜ©N\Ã#$\ÇOf\nUFF ~\î\é_ô\Ûò\İ\Ò2Z/sµ7ë´&e\Ø\åOPŞ©L°\È\É5\ÓÙ‚°!=‘ª~\î\éCÙ·\å»_%¢w<!\Å\èv5\0jÙª”\ËŒ“]=˜+öÚ¥ğgwJÉŸ-\Úù-¹\à\Şa¥SÏ±fj©—jù„ö\Zg\Ñ5\ÓÙ‚ˆ	\í-(ÁOt¦{|·k\ä´Nïƒ®p…Hv,Àhv$\ØiŸD\×Og+I\Ò\èS6ºn\ä^×‰\n\àgº~JŸ°g\Ëv¿uh\ßX\Ë\á3-Á¥PvOB«Nã°§©½‘\Â\nsM3\èš\é\ì\ë—Q¯´‰k³F)\Ôia\ê¼\ä²@ ~{¥Söş[µû«D\îø<ß¹Zµ&{³\à\ÚlyüÖŒ:ŠŸwPU\ÎCP\ì\ËC„\æše5\Ó\Ù=\Â\nnƒE®¹£	¸õ\ŞDBğ#\İ*—°§òİ¯\İZ	–~~\n¡†Lc®½M\';’©ı 25‰%m.ÁÁhÎ‘•<µ0bªº\\‚£\ÚÒ©œ{	Ü«m¸«\ïÀ\çü¬“J\àU»\Óùn\Ö\î­ø- \à¤0×¤²ú/\n³v =¹\ÄšÃ™À¢·y¦5«\ïMMC´«V\ÑU6o\ég¹$\Ù8Â¦ò\×\Ùtƒ\İL(˜N¬ÀÙ•R©$ó\â\\¸z#\İ\Ç4Ğ‡Àx-\î\Ìùn\Ö\î­/[¦e®£\ìc\È\'Õ¦ót;\ÑS™q•E¸k¬b˜õ7´©P3\æš\ÒL÷´8AO5C\ÛH‰÷•:T©\Õ\î\âx¡‚{\ÃB{³\Ã\æqû\ÆGÏ’§N8¦\è\ßvf\ín\ê\Ğò>7\îiuöMLª¤ü©\ÚU\nnœ\Ó\Z†kH=x\ä5Î¥@Á\êš\ÒL\Æ\ØĞ¶Z\ìøz§\Õ.™ÿ\0üX’9ğ*1™ıj\àš7İ›»[º´>>¡†Hni\ZSEG0\Ó#³sÅ‚8”5S§q>¨!\ÙT¨=SZ\\d\ïô±\ä6\Îh?[\ŞÏ’«R\ï—ğ±Ÿ_\åS§úr@ >¢}Ù»µ{«C\ã\àtƒT†\Z\Ü`¥6§~LkÚ´Z.\r2SDj›i8\ê•Jƒ\Õ5¥\ÆNıw×½§ºË£\æœ×µ\î\rOº¨1Í¦\ĞuUs›\ÉT©q™ùK}•İ€“T\à:\Æ\\€ø6‰÷aù\î\Õ\î­ªf¢nZôª¦)ª•\ÛS:by­½UL@\×_4jocR `õMiq“\ØU§{a3G\"\â\çË\ÙgUß‘N¨1Uj\\sùŒœ>a\Ú\îªt£‹ŠŒ~¢}\ßó;µrZnğ$\Ü_¯K}”]œ­]\ì\r¦9b¯eB%ŠŒe\ZÛš®©ò\Ô;\n•ªkKŒùÜ«m¸§™Œ~Esı\Âh¶8ŸuS§œ\Ğ\nø6‡÷\Ì\î\Õ\Éhy»ÀU0Â©\rzs*9­·F«½áŠ¥Öª*#]>h\âIA\r÷\Ô©­.2w‰…^¨©N[% \ã\ê˜ø{mwU\Ü9&F³-%=\äŸ_\å\Â\r´\'‚§N19 >¡ûõÚ™-¼\ï¤‚¤0\Ü}&?¼\ÙLÑ©²`fƒcY\ê\Ò:†ıJƒ\Õ4ıF\Ü\Â\Şi\îªÎ«º\Øu` \Æ\Óp%˜+$÷†‰)\ï\ë\Êş?„±=\ï\åS§œ\Ğ‡\à\Ú±wÔ\åL–‰\ßw€ªf¢n]lš5\r\ç¼0z¦´¸Ë»\"\ĞF*M3»Á:£¤ş\ágò\àP\ãò\æ©ÓŒOy¼> ûıH\îT\Éh÷v\ç$\Ü_Ø´b«¶¡º÷†q¹\Û\î\Òs\á˜7>i•C„oxj}Bg÷óù\0fcÁS§\Ä\æ€\ß\ãğ]\ÙTú‘Ü©’\Ñ}£»z\Æ¨ÆŸšn=\á\0^n;úMj”\â\Ö\çÇ’£º\Ít>«G¤Z\ÌN$ «d!\Ğx\'¾\é?¨Y\Ç\ìPğ\Ï\İT©A¸\æ€\ìÁt\å_©Ê™-Ú»·\ÒASv9S\Ô7ğÀ€/2To‘*\Ó%cHşû#P7ü\'Ô¿\å\ÄrPIõ\ày FYûª>.\Íğ\í*¿4w’Ñ½«»z†j&\å\Ø\Ö=P5\rox`@™(n\ÊX\î\ë@\ëyı\'ÿ\0\ác?‹ù@MT\éó³@vg\àšv¿\Í\Ç\ä´ol{c€)˜¿±`\ÅV=mCS\Ş\æJz¥M«M¾e´X\ê¾b9¦\ê5±pŒxz§Ôºg/\ábO\âşVl\Äò\n“yÙ ;Qğ ¿\Óò®\ãòZ?¶=µcTGbÌ‰N\Í\Ş\æJ~µa\ë8·\È§Q´\Û\"\\\\‹À\n¥I\Ì\áÀòX\É\ç\ÄsP(\â©\Ó3s³M·ÿ\0§ÿ\0\×Gq\Ù*\Üö\ÚA\ÄLaØœ)\ê	\Ï\ró%\Ù<Xno\æ\İ&g\äy,\É\Ã#š´\Ú8ùyªt\Ì\Ü\ì\Ğ¹øúz·\É÷’¡\íûg›ª&\å\ØÕ˜\Z¯µ\0^d 7«\Ô~Ñ­´Ÿª¥Y\Î%®\ïÒ‰„÷†…R¥Ñ\ÒåŒœ1\â\Ô!€—š§L\Í\Î\Ïø@k°øúw~·\É;=\Çd¨û}\ÃØ¸\ÃJ§‹».óa\Zn[,q@oi-.d8\â9§S7ikpi\ÍP¢\Zó\Ö$\Â\n­¶œr\Ç\ér\ç‡\Ô\Õ\Ü\0œ|ª•37;?\á¹Ç¶?\Ğ=³ş”\ì÷’¥÷\Ã\Ø\×0\ÅDvS\Ùl™}öõ¹§ÓœFmz¦F#0P’1\Ç\İwø\\ğúš€‚q>\ê§L\Í\Î\Ïø@n\Ü|@ö\ïúS³\Ü9*x\Ü=zÀ*cÒ™\É\Ñ\æ\àƒµ½á ”÷’sú]ş\Æpúš„2	Ï‚¦\Ìnvh\rñ\Ûqø\í\İô\'\ç¸rLû\Â\Z\Ïb\îµB†^«\Ë-<8§±\ì˜m\ÌwE®Ù¡’¨\ç7S\ÜK¦q÷O?Eœá‡¼9.\à’dğ)”î³Še0<1ø÷ø§÷\á\É3\ï\rg°y†’©\â\ïö\Ü\Ò:/\0—¾\\d\ÂY\Ôw\äSªS\ŞK³\Ç\İ<¢\ç†óy,\Ö9ğõT\é’nvi£²°øƒ÷‘ôª\ã¸rMûÀC-g°\ÒQQ½\ÊuÖ¶\ÃpÁ=\ÆF8û®æ³‘qşŸY\İ\îª2M\Î\Í5½Ÿ\ØüBû\ĞúJ©\Ş;œûÀCY\ì4ƒ.…La\ÛV®Ú¬-lúH€\äÚ­m˜`³’nz¶Íµ\Ç3	\Õ	v}n†XqU\ì€s±wUN™&\çfš\Ş\Ğö\ã\Ç\è_zoÈª\ã¹ÁùµÀõª2\íH«Q{mQ\Í«oa`c\Ü\É>ñB P5²S\Şn\áwºx„:¼G•§\Ö9ğ<\Õ:d›šc{a\ÛqñúŞ™ò*¯x\îp_õÚ†Z\Îû\Ì4ªXŸf‰‘\Ü\â9\'9\×f\'\İ<\nÀƒ†G•@¦‹½8¦S$\Ü\ì\Ó[\ãO\Ñ~õOóU{\Çs‚w¶jnZ\Îşz°¨Ò­J›KZ\à0\Ã\ÕS­|\ÎfJ%> h’ò]˜»\İ<Yƒ‡Wˆò¯g\Öq\ëpõT\Ø\\nvi­ğ#¶;Eû\Õ%[¾w]íš›–³¿\\\Ë\áSvzH&S#šq\Ú\n}\Û]µQ¦/¹\ÜPÁV¶\ÃpÁ=\ÆF=ou\Ş`¸:¼G•{1q\ïs\æ™L“s³Mo‚\ãğ\Í\ï4•nù\İ¶jnZ\Îÿ\0z¡C´\ÙS¸0O4úg¼\Ì¶\Â\Â`\È\Ì\'¼—z\Ş\é\à}p\êñU>³±w8ªl$\Ü\ì\Ó[\à\Ï\Ã4¼\Ñùªıó»SÚµ7-gz¡†HcØºaQÒ‹‰§S\İ2°9@Î§<4J¨z\Ó=otğ>‹8u}\æùPşœ\Ş\àyªt\É7;4\ÖøQ\Ûqñ´>óG\æ«÷\Î\í_j\ÔÜµ\í \à¢0\ì+9Í¤ò\ÜÀÁ[[dÚ´«¹\ç\Ş³J¤0pZ-2\Ú\rk³	¹*s\rÙ·ˆ\äœ\ç]>\ë¸E38a\ï7’öx“\×\æ©\Ó$\Ü\ì\Ó[ğC\ãi}\âÔ«÷·k{Fü\Ó;£YŞ¬e\éƒ\Å\Ú5Zo/\Ñ\ã\ØrTtW€ò\ãqœ8*r\Ãcÿ\0#\Í>¦\ÌsNy»<}\×p>‹8a\ï7—ªÂ$\Ëø\Êd›šk|@øU?mG\êUûÛµ»\íù¦wF³¼:\ÏC³­e†\á?,Óœdcº\ï7¡\\_y¼ş$Ë¸D\Êd›šk|O…3\Ú\Òú•~ö\í~û~iÑ¬\î\Õ0Â¨Œw\İıVN¤z…OIsªl\Ü\Èp¦Î£XZp8fœ\éõ½\×óôY\ÏWy¼½B1HI\Å\Ü\n§L“s“[\âÂ™\íi}Ai\í\Úığ™\İ\Z\Î\îr\n\Ã~½\â\êF	\ïj ¶lóæNª\Z9ú\'T7q÷]\ÏĞ¨™\ê\á\ï7—¨GúpN/\à})N.L°ø¸\ï\Óú‚\Ò3\İ\Ò;ÁS\îgv¡º¢n]‹¿¤Iow\Şo/T\ânl}\×óô+ŸWy¼½B˜\Î]Àú*t\É7;4\Z¸ø\Ã\Û\ï3\êH\Ìn\é…Oº5\Â`\Ì_¸HI€ªW°‰C\ï!P;™@\Ê$Ê«VÁ\Í=\ä‘\Öú_ş\n‰¯\Ô\Î^¡{>2\îj2M\Ç4±\Û\Ø|#‹~ «ğ\İ\Ò3\n—pk;•\Ì1Q•©6£z\Â}j1Â1[ˆ\ä¨5Œş›x)Uœ\ËH\"\îa8÷z\ßCùú\ÏW\ëgùÿ\0N8¸dU:x\É\Í\îqñœ~}ß˜U¸|·t•K¸5\Í \â¤:»¶0©Nq8dQ­\Õ=^°\Ì\"\ìº\Øû¯ÿ\0Iõ3ü…\ìÀ\â\îS§\ï;4ğğƒ\Ã\æ«dß–î’©w³¸\ãuDÜµ6£]\İ*\íu*\Û<y§¸’:\Øûÿ\0\0Lõ~¶½—ªTı\çfš\İñ\Û\Ø|\Ü>j¯u¿-À´•G¸5o0Ò©b\í[Qµ!\Õ\ÇóU)\Ëåƒ=muZd\æŒ‘\Öú_ş\n’a¿S?\ÈNş˜‰—s\â©R\âsA¿=±ñ.\ÉT\î3å»¤ª>\Ìk:ô‡CUª¥0öÁŸ\É6ƒCKq3™9¦“L\Ø\ï\É\Éõl˜Ç˜N|‘\×úş\ng«õ3ü„\\)ˆ\ÌóT\é\ã\'4\ÖöC¶°ø3»ª§³g\ËwIT=›uzA—\Âf\rÜ¬\æ\ÚD]\Ì\'\î?Cÿ\0ÁMaq=_­Ÿ\ä\'LD\Éóqù*Tø»4\Öül|C»ª§²§ò\ÜIT=›uu*\n\ÕHiùB­G:Ç·!Ÿ4\Ü5:¹´õq„_—[\éø(\âa¿S\ÈU³1<øü•\Z~ñ\Í5½¨ñe‚»ºSı?–\àZNJ‡³n³ª©\ê9Q\Ñ\Ü+4·¹\É8ÁŒ8©‘!>´L	Œù§-\ë}ÿ\0’OW\ëgù	\Î \É\ç\ÅS¥\Ä\æš#\áC?‚»ºS½?–\àZNKGöM\Öuiª¢5<\Ø\çYÿ\0&ÿ\0\ée\Öú_ş\nkn$[õ·ü„\ç5‚\Ñ\Ö9O’¥K‰\Íğ³ğWwJ>ÂŸ\ËwI\Éh\ŞÉºÎª\æ^šC@•V­³\ÆcŠs¦:\ßCÿ\0ÁMi$õ~¶œ\àÁkqõ\ãòT©q9 \İc¶°\í‡l<3»¥øô¾[ºNKFöM\ÖQY½Usm\".\æw­ô?ü\Æ-ú\ÙşB{šÀ\Z1\á<U*\\Nh‡qø#»¥»Sùn\é-\Ù7YUŒS*›ó\Ã\æ\Ùu¾—ÿ\0‚šË‰ıMÿ\0!=\á‚\Ğg×Š¥K‰\Í¼;a\â\Ïn<)\î”ßº\Òùn\é-\Ù7sM©\r€›\Ã¥ÿ\0\à¦4¸¯\Ö\Ïò\ê´5¸úñT©q9 >?\ÇÂ\éLû­?–î‘’\Ñ}\Ü\Ò\Ì\Õ\à<¥Sa2#\ëgù	\ï\r­3\ë\ÅR¥\Ä\æ€\ìGl<ö¶(x	R§Q=R™÷J_-\İ#%¢û!­ø4 \Ë\ê¯\Ô?Ê¨ğ\Ğ\Z\Ü•N—š²\ã\Ûq\í‡l<t©R¥NR©ÿ\0\éi…r¹\\®U\ÎGwôÂ½\\ª»©	\ÕE­\ÅSgš :ç±@\îÊ•*uJR¥N\ì©R¥J•(•*T\ê•*T\êÂ§·µZ­V¢\Ü3Lk…‹¿eó(>eó(>eZc5D˜\ë~\Ê\æı”2{	õ³eŒğA™e\İ\'%`;“’Œò\î\ÎIÍ‹²ÀÓ›e¸œ»ñ’¶N~ü \Î\î9“Ã’h\î\ã˜(7øJ·¹)\Í\"ür9½\ìr#÷Vg¿7ù\Â»\êO\ì€$7t•iŒı\ÉE‘w[ ?tYc‘\n\Ìs÷\áIûğƒ;˜\ç?²ƒ†>\é*g\îJ\".\Ç N<@Pg?~Ûdş\È6m\ëf	Q\ë\îJ8Mc”.T!8c\ïBm\ëgöX\Çx÷e\Çİ”\ébp\İ\Ç0º\Ü\ÏzK°Ç‰B\ì:\ÇJ\ëy\ÏvW_¹\È~\èß\\\æ¡ó\ß=\è]|:\ç½\á\Ö<P.Ã¬r\æ®˜÷eMLz\Ç%5q\ë¯\êùı\è_\Õ>ÿ\0SW\êf¦¶~\n\ê¾~®«\ç9+\ëc\×W\Öó+«ù¸Âº¿›Š¿H\Ã¶•ù­­~|%m«óà¶µù£V¶)•j÷5¶<–\ØùV\ØùV\ØùJ\Û)[oB¶Ş…mı\n\Ûú·ô+o\èV\ß\æ¶Ş…m½\éÈ¦û\î\Ö\ÉQöc[²LeÁ¦y­]n¶}{\'\Ü[ñ\á\n«!¯3\É\Z38\æel½}\éLlşO(R‹q\Êul=ü%l½}\ØOd1\Çğ\Â4¦q\Î¤:\Ø\æS[qwÖ¶cœ«mu1óB\ÃÀ\ï¦\Ì}@F˜3\êS[%Ş•³|\å[¦>kd?hO¦\Z\Ç\Ãdù€ g\ç).ôz\Ù\äOî­‡±¿„­\ç\îÂªÀó\éd\ãœ-ˆÿ\0\å*›gòy[!†9O\î¬\ëş²\ã\ÂFC\\y\Â\Ù|elG>2©2@<‰[,±\á\nŞµ¿\ZY\ã\É=±7³õ÷¥lòÇŒªló[±\ág×·ğ#G<S\Ùy¶ÿ\0i[<±\ã)\ÍlğVu­ü\Ñ8\ãÁ>™hq\'’\Ù\İl\Ïÿ\0)Mlÿ\0üŠÙ»\ÍXC€ô[\'ñN¦@?%²qŸXF“Œü\Ği3d)»š´‚\ÑóV;’- \ÅZ\â\'\Ñ\Zn\ÅZM\Ã\Õl\İû¢\Ò#\æ¶nÁl\Ü\äƒG\ä¶n\ä­2F\éÈ¦û\î\Ö\ÉQ\î\ro!­$ªe±€P&uT-\r%\Ù&™\0\ê\0\rE\Âñ\ÔôGlt—cr£šÖ’P2¨\Ô\ê`O9İ¥Q¯˜õ\Ü~\r8Ja¹ \Än\Z­\Ú\Û\ê DÀ%R{NMP&u9Í¸4„Ú\Ç-@–­¥9q\å\Å4\ÜD¢@•{\0+5h™\ÕP³\0\î(Tm\Ö\ê\r\r\Õ\Ô53\Ä&¹®È§48BUÔš	»	C[ˆ:\âa\\Á\r»Ply\êpl‰(=À8\"$&¶j\ê‚\ãp\İ9&Ÿ\é7vª¥\Ü\Z\ê›\n›fw$š ¹c¶—Hôô\İkH$“¹R›jSD\07\Â\ã\Ş\Ãp\â!S¥gÇ¶\æ\Æ\î\Çú—N\á\ÉR¥dú\î9²G¢e2ÓŸ\Ër\Ü\\y¦Z²œÊ–µ¢#\ã\Ût|Õ¯5†\á¦eğbU6\áa³¸N9	’\Z\']F\È\ÉXı¯ñ¸[ı@a0fO\Ç\Ó6ÀT©R¥‚i&\î\ÕT»£ûd¸rR§\ÑH\ä¤rV¸4u”j\æP\ï2‡y“\çš`|w\Ô?Îºşu\×ó©w™c\Íc\æ]o2\ëy—[Ìº\Şeó•ó”\Â\Ñ\Şşh\Ï5\Öó\Öó•\Öó•\Öó55\ÌT;\Î\åk¿\î9Aó•\ÌuAóc¿\î9X\ïûP|\ÅAó\ÌT1P|\Åc\ÍcÌ¬y¬y¬y¬|\Ë2ÇšÇšÇš“\Íc\æ]o2\ëy—_Ìºşe\×ó.¿™SÌ¿©\æúœ\Âş§0¦¯6¯\êsúŠjz)©è¦§\áSS\ÑMNAMNA]SWT\ä\Õ<¡]S\Ê?UuO\'î®©\åı\Õ\ïòş\ê\çù?u{üŸº½şO\İ^ÿ\0\"½şE{¼Š÷y\îò+\İ\äW»Ê¯w‘^\ï\"¼ùV\Óğ•µü%m	F\Îk«\Íuy¬9¬9 \çZ0WJ\çrW;’¹Ü“\ÉLs\ã$\î!\\|ª\ã\åWz+%q\ä®<•Ç’¹Ü•\Îä¯«ÿ\0l~ªúO\İ5\Ã\Ş\"\îJ\çrW?\Ñ\\ÿ\0Es½«Š¹ü‚¾¯”~ªú¾Vşª\çò\n\çz+Š/«É¿ª¾¿•¿ª¾¯•¿ª¹şŠ\çz+Ÿ\è®w¢¹ŞŠ\ç+œ®r¹\Ê\â®w%s¹+\ÉIRTú)ôWa\İR\ï*—y\Îò+\äW;È®w«««Ï‘\Êÿ\0À\å\àr¿ğ;ôWş~Šÿ\0\Â\ï\Ñm•ß¢\ÚNı\Ğr?¢\Ú7‘ıÑ¾¿¢\Ú7\Õm¶Œ[Fs[Fs[Fs[Fs[Fs[J|\ÖÑœ\Õ\ìæ¯§\Í^\ÎjösW³š¹œ\Õ\ì\æ¯g5sy¬\Ö÷0DˆA\ÒÁ»QR=]\Ì5` (\nÁ@P\n€ (\n€ (\n€ (\n€°P\nÁ`°X(‚Á`°P\n…\n(P¡B…\n(P¡BQ»\n\n…\n(P­V«}ª\ßEo¢·\Ñ[\è­ôVJÁ\È+”+•\ÊT©Á1\ß\Ó\nT©Rª#\ÕR¥J•*T©R¥J•*T\ê•*T©R¥J•*T©øœö0\åP\åP\ä\×:Ğ®*÷+Ê¼¢\âSjBÚ•µ+l¶¥m¶\ËhVĞ­·ª½\ËhV\Ù^\å´!\n³\Å^\äj…RU\îF©P¨O{•\îW¹^\åyW¹^\å´+jV\Ñ^®W+”©R§x|27FôJV\ê*Ñ¬7X\Z\â5\å\ØBD¢\äÒ¥Of>³*Â­*v€\Ö°5¨ 5¢€ß”Js” U\ÊõµM­*{ğİˆ[¶`¶	Ô¡X¬V+Š\ÅbµX¬V«Š\Õb±Z¬V+UŠ\Åj±X­V+Uª\Õjr”÷«‰BwFhnÆ±ñ*›ª±¹•Ò©~%Ò©rr\éÿ\0\Û3\Õ\Z\Ì\×L¥\É\ë§Rò¹t\ê^W.K\Ê\åÓ©y\\ºu/#—N¥\är\éô¼]:—•Ë§Rò¹t\ê^G.K\È\åÓ©y\\ºu?#—N§\ärv”Ó“J5\\x(\'4\Z£wŠƒ\â\Õ;\'˜iGWVÊ©D·0¬V+Š\Å`V…j´+¡Z¡Z¡Fğ\Õ\Å\r@ |Z§eW¸uñA\ÎğZW\rD \Ùa<µŠ¨\Û]¦‰c-@\âª6\×B)–;\ÓP\ÍTm®E0K\é¨\ên®!B (ø­NÊ¯p\ë\â‚	à´®\Zœ™ìŸ©™ªıô\åO\Ù\Ô\Ô3Uûÿ\0’r¥\ì\ê|µ\Õ~ÿ\0äŠ¥Ü©¨\êf :ÁZƒT(QñRªvU{‡_L\ï¥p\Ô\ä\ÏdıL\ï*ıôU?fıC5[¾Š§\ì\êjª\İÿ\0\ÉK¹S\å¨\êfª=\ç~H\n>1S²©\Ü;²©°ZW\rNLöO\Ô\Şò­\ßESöu5\Õnÿ\0äœ©{:š†j·òERöu5T\Õ\r\Şw\ä|n§eSºQ\×*\åM\à8-%À\ÄD.ª1”qP†5B8¨Y\Õ=\\5\Ê5_\İa+F\Ğ\ì\ë?>J>9S³~9.Œÿ\0EÑŸ\Ì.Œ\ïEÑ\èº3ù…Ñ«y—F­\ç¢\Öó\Ñky\Âèµ¼\átZ¾pº-o8]¯œ.‰W\ÎD«\ç¢Uó…\Ñ*y\×D©\ç]§t7ù\Ñ\Ñ\Ü=õ³õTh¹ù\Ê4\Ú\"Ğ¬g”~Š\ÖùGÆ¶\åt…\Ò\é\r[f§”(P «O-VKf\ï)VJ§’´òVEZGj°òV;‘VJ\n…i\äU§‘VJ§’´òVJ+O%:›\Í\Zqs\Ä&\Ø\ÖÀW·š½¼\Õ\í\æ¯o0®\nğ¯\Õãš¸+‚¸+‡5p\æ®\nT©\nT©R¥J•*T©\Õ:\åJ•>T£¬j hšC®.\â%[¹P¨µ®\ÍD\"\n7+$\ÇQh9«D\Î\å¡¹cwAV7sf\Ş[c]˜V5B…f\ŞJ…±®\Ì-›G\rfU¸ \Ø\ÖD\àVÍ¼”(\Õ`™A€(\Õl\ÄfT\nl«Gª…\nŸˆ \Õ\n+÷\á¨68\Î\ä\ÏtO5;€(\Æ¢Ÿ\0€¸L¨P¡?E…ø‡BcKc\à\âf\äZy¢\Ã\æQ„J-<Õª\n\r<\Ô+J…i\æ­V«}T+\æ­Vj\Õi\æƒ]\ÍZ­<Õ¥Z\îj\ÔZy«U¥j¦sP‹]\ÍAæ  \Ó\ÍA\æ­t÷”j#ó+jy•µ<Ë¯lJ‡sPT?š‚ˆv¬P»®´új7ğ…Š\Åu¸¬W_\Ñbº\Ën\à+.X©|÷V(\İÀ,V(ñj\Åu§%Š7rX¬y,y)<”»ÊºÜ—Á(&wÂ¯‘T{»•2Z/f©L/\Ëp½€\Å\ÂSjSwu\à\îm©\Üoêƒš\á \È\×!\Z”Á‚ñ<·š‰B¥2`<N¼i\É\Ãq\Ïks )’9\îeH\Ü.l\Äü3‚!\Å\Ó{ÁWÈª\×nT\Éh¼u\é4\Üğ\Ûy \Ç\n‚ZLe¹l\î¤Ê£8’\Ã<N²€}‡ªd\æô™ƒGV=5\ÕŒ\âŒ\í¶yr\Ü{^z¹\Æ*•\×\æ\ã\Ïÿ\0Z\ë4º™Ôµ½_{\æÇ¹Í´|\ÓC…Ga„\rd\àº\î¤ş£¤¦\Ì	×¤4 &2£M<8c¸Z\í¶g<+±‘\Ç[»¥2AKµ\é¹‚´l7w¾-\Ë,\ëH9\ët©tR\ê»r¿{øTË¯ \Î[šItT»ƒq\å\Ûh\Üq€J¤\ë„\Î\æHS›D¯uâ¸¦÷‚¯‘Z>N\ÖL–™\Ük¤¾x!9\Æö\nS\İ$;ø)	®\ïÏ™HE\İvTi\î†#š‘\Í1\ÓtóR\İv‰\Âj£¡¦\n¤&:fy©\n\î¸„)\ÕW\Ãp*B©º[‰\â¤sWÿ\0R\'Tj£\àa\Ì)\nB¦\én*Uÿ\0\Ô#„)Ot[Ô¢pT\İsA:ƒ¥\î\Z\âc‰\Ô\ã\0¦:Z¦º\\ñ\ËSœCš9\êyµ¤¦™Sqw¡\Ô]\Öh\ç©îµ¤ p\Ô\Ç]?=Eıp\İOt4”51÷N«ºá±©\î´Nºn¸eªş½º\ëFZ€Á\0€\ÅqC0«d¨d\íÊ™-¼u\Êvnÿ\0p!˜ÿ\0p¦{ŸòC&ıpÿ\0ÄŸ\ï}\rG\ßùµ{\ßùPÍ¿YM÷?\ä†Mÿ\0l¯tÿ\0¶Ÿÿ\0S\ä\Ôs\Öü‰¾\ç\Ô\ä=Ï¥Ë‡ş4rw\Ğ½ÿ\0›Q\Ìÿ\0º†mú\Êo¹ÿ\0$2\í”\ìûa?ş§üQ\Í\ß\î3\î&ÿ\0\Óù¹7\Üú¸\âNÊ§\Ò\Ô\ì\ßõµqÿ\0È‡»õ97\İù9pÿ\0Æ“ş€\ïüÚ¸ÿ\0\äC\İúŠ\ç\É\Èd>„r?@N÷ÿ\0\âgıÀ†mÿ\0q7\Üÿ\0’\à>‚Gı´\ï\ä›\êüĞ§\Í\È\ÕùŒÁ‡}!:z\ßP\\\æ8c\ï	\êüŠ“ûˆ\Ì¤\"O[J]9û\ÈHW\î®<Ğœ\áW:3÷S§­\0‰v8ñR\îg¼šHš¹\ØcÀ©9Ïº‹İ<\'x…s¹û\Ê\ça	5s¹ğR\ìO¢.~8¢I\ÌñW»ŸÑ”Ñœ :ÈŒuT«£{Fşª…Z¡@Oh…£{RhVi·’4)yVÂ—•tz^U°¥\å[\n^U°¥\å[\n|–Â—%°§\Él)ò[\n|–ÂŸ%°§\Él)ò[\n|–ÂŸ%°§\Él)ò[\n|–Âš\ØS[\nkaO\Õl)­…?U\Ñ\Ù\êº;=VÁ‹`\Å\Ñé®Mtv-ƒÁ‹£±tv.\Å\ÑØº;Gb\Ø1lº;Gb\è\ì]‹£µtv.\Õ\ÑÚº;WGj\è\í]«£5tf®9®9®9®9®9®\êº?ª\èş«a\êº?ª\èş«£úğ]\Õl=V\Ã\Õl=WGõ]×‚\èş«£®\ê¶«a\êº:\èş«a\ê¶`VÀ¦\äSs(w‘\ÏWúvM\Õ*5\íE’\ãòZ7¶(l7Ss(w¡õ¦ı\â¯\ÉT\ïn?%£ûb‡ö\Ãq”\Ü\Ê\å‘\Õş›÷šŸ%W¼w’¡\íŠ\Û\r\â›\ŞC4N:¿Ó¾òÿ\0¥U\ï\Ç\ä¨{d?¶\Zs„\Şò÷‘\ÏWúwŞŸôª½\ã¸ü•n†³ıª\Ş(w–#‰\Õş÷§}*¯x\î?%GÛ¡¬ÿ\0j·	M\ïJ÷G¸/ôÿ\0½Ÿ¥V\ï\Ç\ä©{t5Ÿ\íV\àJ\å\ï\'f¸/ôÿ\0¾\ÅV\ï\Çd©ût5Ÿ\íV\æ‡y{\ÉÙ¡’\Ğ>ùÿ\0[¼w’§\í\ÓuŸ\íV÷Šô{\É\Ø2Z\ß?\â«w\ã²Tıºoö\Ãs„;ğy;†KAû\àúU~ù\ÜvI\İ7ûa¸˜C¼i\Ø2Z\ßòUûû\É3\ïk?Ú£Y\\‡÷\Æ|•~ö\á\É7Û„2\Ö¶´O¾Sù-#½¸\ì“~ğş\İ\Ñ~ùMi\íÃ’x#ı¹£}\î’\Ò;Û‡$>ğ5ı¹£ı\î’\Ò;Û‡%1\\+\ÂÚ³\ÌÖŸ˜-£<Á\\\Şj\æóW7š½¼\Õ\Í\æ¯o5{y«\Û\Í^\ŞjöóW·š½¼\Õ\í\æ¯o5{y«\Û\Í^\ŞjöóW·š½¼\Õ\í\æ¯o5{y«\Û\Í^\ŞjöóW·š½¼\Õ\í\æ¯o5{y«\Û\Í^\ŞjöóW·š½¼\Õ\í\æ¯o5{y«\Ç5{y«\Û\Í^\ŞjöóW·š½¼\Õ\í\æ¯o5{y«\Û\Í^\Şjñ\Í^\ŞjöóW·š½¼\Õ\í\æ®\Õ\Í\æ¯o5sy«‡5p\æ®\ÕÃš¹¼\Õ\Í\æ®\ÕÃš¸sWj\á\Í\\9«‡5p\æ®Ôj\á\Í\\9©Ôj\á\Í\\9«‡=\êz¢´ö\á\É?\Ú*´\Ú\ØŠ\ÆòVH°B·øQŸ\ä£?š\å\ä­ş\n3Vÿ\0*\ß\å[’\á[ü+sVÿ\0*Ü•ª\ß\á[Ÿ\ä­º·ùV\ä­ş¿\Â-\Í[ü«rV\ä£øV\æ­şU¿Ê·%oğ£øV\æ­şU¿Ê…Â·5\n?•\n?…†*3Qü¨P£øP¡B…Â\ßıvûğ”~óGæ´Œ÷J»­{~j¿x|µœ~JÕ™rµF!Zœ0*\ÕjùV¨\Æ=©ÁBµ4`­Q‰V¢2ù«Taù+pü•¨şj\Õ€­ş†Z­M+TcŠ\ÔGò­V«d~J\Õ«Tb©\ÍÀü•ª\Ô\ÜUª1Ej#ùV¨@aù+Tf­Q’µ­V ?•jŒaZˆşUª+Tf­Q’µ­V ª»\Ôı½/š\Ò3\Ü+L\ï³\êUó-n0L\É\ëF\ë]<#q\î ‹ˆ\Ü{ƒF(n\\Û£\ëH<7Z\"wC›8nÜp9n\\\ÜL\îh–¨\ÕsE3¬ù\î\Şy gY )l\êDŒ•\Ã-Qª\æ\ç;\ìö´¾¥¤n¦w›óU³o\Ë[„„\Ğ#r1Ö¶\Ş;lñ\İ\r3¸D  nlúÓº\rÇ²\è\İk!Ó¸D¦¶7-\Ïp‰A®¸“q„\Ñ5‘!lú\×N\ál\Êcm\Z\Î!lúÓ¹B\ÃNFû=µ/©i9\î–“š­\îüµ\Õe\ì-¸¶y*Töm¶ò~Ú’şAKù)w%.\ä¥Ü•AQÅ±„Ò´\ÈÄ´®‘¥~\Ò4¯ÀºN“É‹¤i\'\İbª+{£túlpä¶¯ó-£ü\Ëhÿ\02\ÚTó-­_0[Z¾`¶µy…µ«\æmS˜[Zœ\Â\Ú\Ô\æÖ§0¶\Õ9­µNkmS˜[jœ\Â\ÛT\æ\Ùü\ÖÚ§0¶\Ï\æÚ§5¶0¶\Ï\æ\Ùü\Â\Û?š\Û?š\Û?˜[gó[gó[gólşklşklşklõ¶5¶5¶5¶z\Û=mŸ\Ì-³\Ö\Ù\ëlşklõ·¢\Û?\Ñm\ß\è¶\Ïô[gú-»ı\İş‹nÿ\0E·rÛ»\Ñm\è¶\î[gz-³½\İŞ‹n\å·w¢Û¹mÜ¶\Î[w-»½\İŞ‹n\å·w¢Û¹m\ÊÛ•·w¢Û¹m\İ\è¶\î[w-»–Ø­³–Ø­³–\Ù\Ël\å¶r\Û9m\ÚU\îDFŒ\Ï\ÏvT©R¥JR¥J•*T©S®uJ•*wg´•:¥Om>{q®§q\ËF3£\È\ëŸ\íÑ®§p­ÿ\0Düõœ\ærC\è\İ\É\Üq€›1¸\\n„\Âc\î\Üsˆ#–\ëv\ãŒ\rÖ¾\\F\ãŒ\×\\7/<25“w.\Í4\È\ÖL+Ñ¸_šdkq…qŸşã–‰\'su\ËÜšdŒkuN;†S«	\Õ:\Än8\î€8n\Ğ;†8¡¹kOb@+-\È\îa»Ä¿¸V‡ÿ\0S[µ\ß5K¸œ\ãÀ)RP*\ãû)\Í\\Tÿ\0*\å?Â¸¢â\Õ\\TñôW\"U\Ç÷W‚¸©\Í\\§%r.Á\\®@\Ç\ê®R®D«•\È9\\§5wò§\"¯E\Ò\Ê\ä¯WqW«¿•r¹\\®Sª½]Š¹8Ê¹\\ƒ•\êU\ÊqW”\\®W!\â_\İ+Bÿ\0¨  B\r‰V•jµZ¬V+ª\ÕjµZ­?ºµZUªÒ­V•iV•iV«U¥Z­*\ÕiV•iPT\nZTiVŸ\ÙZU¥Aı\ÔiV•APTAPuiPT\n¥APT(V•iV•iV”<Kû¥h\ë¸s\Û-ƒ–Á\Ë`\å°r\Ø9l¶[-‹–\Å\È\ĞqCB…\Ñ\ß\æ]§5\Ñ\ês]§™tze\Ñ\êy—G©\æ]§™tze\Ñ\êy—G©\Ítzœ\×G©\Ítzœ\×G©\æ]§5\Ñ\êy—G©\Ítzœ\×G©\æ]§™tzœ\×G©\Ítzœ\×G©\Íl*s]§5°©\Íl*s[\nœ\ÖÂ§5°©\Ítzœ\ÖÂ§5°©\Íl*s[\nœ\ÖÂ§5°©\Íl\Íl\Íl*s[ó[\nœ\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁü\ÖÁ\Ü\ÖÁü\ÖÁ\Ü\×Gw5°w5°w5°w5\Ñ\İ\Íl\Ítws]ó]\Ü\×Gw5\Ñ\Ï5\Ñ\Ï5\Ñ\Ï5\Ñ\Ï5\Ñ\Ï5\Ñ\Ï5\ÑıWGõ]\ÕtU\ÑıWGõ]\ÕtU\ÑıWGõ]\×ÿ\0\Ùl©RT•%IR¥IRU\Å\\T•%\\U\ÅIW%\\U\Å\\U\Å\\U\Å\\U\Å\\T•qWqWqWqWqWqWqWqWIA\Å\\U\Å\\U\Ê\år¹\\U\Å\\U\Ê\år¹\\®W+•\Ê\år¹\\®W+•\Ê\år•*\år•*\å*\år•*T©R¥JR¥Oe¬u\ã«\Ì~¼|6=¤\n¨P ¨*B…\n@P@PB€ (\n€ (\n€­\n€­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\nĞ­\n´(\nĞ­\nĞ­\n€­\n€ (\n€ (\n€ (\n€ (\n€ (\n€ ,‚Á`°XkÃ³\éL\äWJg\"º]?U\Ó)ú¡¤°ó[v­»S´ºL\ÎW\ÚZ?\â_ihß‹ô_ihß‹ô_ihß‹ô_hh\ç\Íú/´4~gô_ih\Ü\Ï\è¾\ÒÑ¹Ÿ\Ñ}££s?¢ûGE\æEö\æ?¢ûGFó\Ñ}££y\è¾\ĞÑ¼\Çô_h\è\Şcú/´4o1ı\Ú\Z7˜ş‹\í\r\Íû/´4o7\ì¾\ĞÑ¼ß²ûCFóşË§\è\Ş\Ù}¡£yÿ\0eö†\çı—\Ú\Z/Ÿö_hh¾\Ù}¡¢ùÿ\0eö†\çı—\Ú\Z7Ÿö_hh¾\Ù}¡£yÿ\0d4\íû\ë¥Qó.•Kš\éT¹®•Kš\éT¹®•Kš\é4¹­³VÙ«jÕ¶j\Û5mØ¶\ì]\"š\éù®‘Oš\éù®‘Oš\é4ù®£ù¿e\Óôo7\ìº~\æı—O\ÑüË§\èşcú.Ÿ£ù\èº~\æ?¢\éú?˜ş‹§\Ğ\æEÓ¨s?¢\é\Ô9•Ó¨ó+§P\æEÓ¨zş‹§\ĞõıN£\êºuU\Ó\èú®ŸGñ.ŸGñ.ŸGñ/´(ş%ö…Ä¾Ğ£\ÉË§\Ò\ä\åö….N_hSò¹}¡O\Ê\åö…?)]=Rº{|…t\á\ä+§!]7ğ.›ø?u\Ó?\îºg\àı\×L>O\İt\Ã\äı\×L>O\İBN\ÉSPª\Ô\n¥B\ì÷y©ñ`ÁM%ZTŠ‚º\ÈH\íª`|p:¡Gd\ì•%V¨`•Q\å\ÆN¸A #«‡‹\ÑÉµN\ës\nÁ@P‚€ˆ\n(Qª£®q>>P*(V\ê…\Ém%Tyq’Q\Ô\ÖJÀxı‹7›š\Åb±X¬V+\É\Õ]ğ\Øñ\Ù5\å;\Û-“\Ö\ÉÊ«mn)\ï¸\ê\0”\0P£QF8\æ\æ \ë\ÅcªwI\0\'º\ã\ã¡B`\Âu\Æ\ã\Ş\Ö6\â«\Ö/:ƒV.À#®<68«*rV?’µü•¯\ä¡É³*T\ê\ÈXk\Ò„|@\Î\ë\Ü\ÒJ¯\\\Ô>œ–h\Í¨#¯\á\×G\Ã#~P\Ş:¡V2ó\ãc²\0•k•®EÀ	+I\Ò\rGz(+,»)\Õ:‚\'Yğt{‰˜µ:¡Fì«•\ÊF\åQ?¦qzN‘yµ½\Ô9•=„ø\êx5Q8n\Î\äk„F©RªyøC]!75\İù£ğf\æ„Dõ”j\Çzw¡;$søE7C¾\ÎğU†J™‡©ßÁıÒ‚\ÍG†¤dv‘\ã˜O\ëS\ĞË±\ç÷J>øZ.‡Gm>)ª—ZŠ\âƒ\È[B¶…m\Ñ^¯W­¢\Ú- [P¯\nğ¯¼.>?\ë¸uŸ€…¢;°q@\ë‡(r‡(r\Åb±Ün\Í5G‰\'\àM¥:;Ÿ\ê´S:É™¨Q»*T\êÁ@P¡B¨\ß\n¾Š/\Ğ\Ü\ÔÎ­AóUñh)ˆj…\n\Õj…ƒÄ„|<\êÿ\Ä\0+\0\0\0\0\0\0\0!1AQa 0q@‘¡±ğPñ`Á\Ñ\áÿ\Ú\0\0?!°\Ñ\æ2:#¢5\Ñ<w¦â¢«ª’D\Ä%at2Sa\ÜUˆ#¢±	6\Ü!\Ù\É¼‹BDu!õE#­\ŞÔ–@ú=p@ú¡!\Ù\r\Ïz\\F8h\ÖBV@ú¡)­ŠÔ”–’e°öö\ÙB!u%qŒ‘UX\"©ŠŒºeDA(û%I&ŒTB&~ğ‚ k@]0X\Ğ\è. la+Qü2ZY \":\Ğ\ëCB\èD“HTo¡\Òl*º\ÏLQ*</Ih¶“\Z0\ìnD\Ìh\ÇÒ©¼K‘,À\Â9n¸?*iUF†½úØ¨j’d¡QQ„-\Æ\ï\è\Ò \Êb¦”H¨Œ(\è\èè¨˜\Ü\\¸À\ÂmW\ØH—#\"©\ÔO[tÀ¢8D\nK\Ñ(r\Ë4µ ·M‹v$e…!Ğ¹Q®‰ˆF\"cU2\Æ?\Ë@‚]+×¢)ôNƒŠ’\ë¥Û‚:R½qF¨’D±::A `H\ß\ÂÕf\Í!\"Ò„>òô)(²£\"\åƒ\é*!/J©QtHŒCBY\Zÿ\0\ÅC¥\Æ\ÈH#´¨·aö§¥W\"¹gÔ=-T‘\n+*‘\"10\Ù5\Ôc	\ÛBKS\n·\êÉ’\Ä$ˆ\ì=ôT#\Ğê¨ŸA)Ib\ä\"‹4l™31\Ò\ì‚A{±|m¢\ØYL†¿e§Òº»¨\ÈA¸Clc\èTO}t\ê,\rÑ‰a\áM\ï\\†\ìX\Ã‰6YP¾\ï|cr\Ò\ÄBÌ±Z‹²İ»!ô£O@¨ò Üº1\ÑQ\rY\íº.”\'\ÒÄ¡\rp\Ù\"¡\ÑÀ‹~\Æ+Yrn<®\ãušOD\Ò0H\Ä÷B&\Âw\Z@’\Æ\é€\èŒ2z\'ªk4]2&*HØ®ušI#Y‰FIj¾\ÂôóB&’‡\é\'¦DnÃ¢döST2I$šœF$‘\Ñ2\Ñ$’I$’I$’I$’H™$’I4À‰6))&¤—UAi#\r°2n^\Â\Üj\ÅKR‚`\ì„ôI$’I*’I$’I$’H\Ì\Öz$’i$\Ñ2z\Ñl¹“bI\Ç;%œƒ<Y\Ê9G(\å\ã”rA\Ê9\ç0äœƒ”rQ\Ì\èğd“|Å‹—±„C¬[£€¬\ádm#x³†KJZf©’ı\\IÅ˜·¢^¢7†\ŞC•\Ş>°–\ÔF\ÆCÙ—Ø¹}‹—/[’H\ã‘H’I£$2MI4I$’Iˆ\ìGb;\'‰\âx\'…\'‡ò¯ÿ\0ÿ\0ÿ\0üiñ<iñ<O\Äñ#±\âGbØ†\Ã\ÚRq\'ÁU¸\é¸Œ\á8N\Ë\àG)\Êrœ\ç9\Îsœ\ç)\Èrœ§)\Êr‡9\Ìsÿ\0	[ ª¨ªªªª¿?[\î&\ëO«\Êsœ§)\Êrœ\ç=>c”\ä9j¸ò¢\ÔX±bÅˆD\"„B!!\Ğ\ß=kšµ\Ìs‡!=\É\îOr{’Ü–\ä·%¹\æyG™\æyg™\æyg™\æyg™\æyG™\æyg™\æyg™\æyg™\æy“Ü\ä÷<É“Ş™\îKr[’\'¹2D\ÉvB  À§\äÉ\İ~F}úm\Õb\\–,Z–¥‹,&‹,X·U‹RÅ‹-K,X±j[¢Å‹\è±‰_¦ıpE\à^ ‚™©¡Ó @„@D\"„B B!ˆD\"„@„@„B B!!!ˆ B!‹uÁA\Öu\"(‘†J‰tbi‰ô¥aÒ¿\ãR@’I$š$’I\'øt17‘ú¨\Õ\é>Ÿş=>‡ÿ\0ı¤µ°:Bu¢nd°\áôI$šªÁA\æg¤$H‚d\Èd2HdEb&=¯‘!bİ˜ª\á\Ğ\ÄGGybfG\Øg`\ç\":* ‚d“Iõ—=§I§˜\ãŒ\æ6\Ìş\à\Ø\Ì+‡ñdh\ÍqŒJH\ë1–CT²rE²D\Ä\Ä\Ä\Ä\Ä\Äÿ\0€J-5P;\Ü#ˆLTF‚\ÜDõ°ş´„8“g1–\èhv.\ÈLLLLLLLLBõ«ªlG€\ß‰\ZÄ’ˆ\"D‰‘\"D…$’IôLš%˜X\Ï,ª¥$÷™Zm\Ã#alLLLBbbbbb\'Õª&]r.E¶‹™\È\Ï=7\àœoƒŒqp#\ãcŒpˆ\ã¯yˆòs3™œÌ\ì\ì\ædwdwló!¸†\ì\ìógkq’Ù»Œ‹²\Ä)•\Õ I·	\\ÿ\0\ß¾\ë±!lNn†I	‰	„*\ÂF\Â6°„l#a\àxØ¾\Åö=‹\ì_bûÁ<I=\"§gÑ…&1v\Óõ\×vŒ\Ä`tR\ádd.\ÔİšÈ¬RYE“\ÈR¬s¶\Â\Ã\ÈLL‘111	‰‹\Ó\Â-µU+>Œ°c\èbˆqŸ\á§wbÃ¸™M/\íD¥¶ÿ\0x_b\Ïr¦_ñ(”[ö¹~ZA</ûaÉ¯ŒJ°˜”ˆB„\Ä!Õ¡¯9ôŸc§\'%\"ñü4ÿ\0Z©n\äÙ\á`¸p\à\Ö}KO\ì\'\ÔJÊ”¾„^\0\ä|\è4Ù¹¼\ÂoW»û\èJš„˜Ù²ˆBb˜„!2}J2œ\êŒ¹ÕŸ¨\í\èZY\àÌ‹’COË‚\ÍJ/(§„°—†/÷~¿vÿ\0E\Â}\"b„‹1.…°d$!\n‰ˆBªT™ô`}\ïX  E	\í²ÿ\0©\r\á\rf€÷¨?ı„ÁbiN\è\Ş\Ó…¥…WsXxc +7\"\Ñ1\nˆB˜½R-C—F\ÚõAÉ±´4 ™=´”¨\',,\Æ\Êi\Z\Ã(°wb†‚\ä†$w,d\Z±B„!^¡Rò\èx>\Ç@i¼893\ßşzY’\Ç&¤ ™=ÀS½\n\É\'‹\Éøb‹¨j¢\éá›Grdbª¨LBõ\n‹ŸCÁ÷©\êU`@5\rŒ€N(\'\ÛhK9p›,F¤ş´óŠ#9\Øyq+‰\åö„*!B½+\îº¸}N\Û\ï*Z\ÂT€²PO´\Å2\ÃÁ\í\ê\èG\á0+út„Œj\\Û†¿2„%!B½2§e\Ğğ}¯Sò³#ˆˆ j	ö™)’òkÁ\0\Ö4h§¹F‚’\r5\Ò\"Q\\p&!TB…E\éQô™—CÁöŒ¡\âZ˜ˆ\Ë“\Z‚b\ì¥.cAÀ\âK|\äB\ß4ö®’7Q\Ûc°…n„&*!11\n«\Ğ\ÍQõ_Lğ`ó\ê„\Ê ^¨NR9&\'A1v\Z9P+C8WfŠEg\rlªs\Ğri1i\É\ZŠ\ë#bÑ\"„!1\n‹\ĞIe~‚Rª?(Ï£CšF:¥Ï¢y\Ì\\G \Zğ\Å@Ÿa“HGz\ØM¨{M\î‰Y\"#\åK •Æµ\"\ÃQ›c#!B„\Ä!¾[ı\îMJóPª£óú40t\ç\é&\Ìû1œ\à{C¨\'\Ød¡‡¾D»\0C9r ““’X\É(„*!B}8Jhµ~‚d¤òQ÷\Ìú42]úDB‹r\×j3”h „õ²` 5\è¸7E=•Š‘˜jh5dy´\é“„*ˆB\ïIÅ¤È¸Ô¨\Ùôhfºôˆ\Ø,\'sC+#\Z ŸC«#s\ä†pL®¼\Úh„=IÄˆC°¥‘\é¬CLB¨„.ó<5‹f%\ÊùUu_CGF~“\Ìù·wT\Ë#\Z(0_D\à\Øi4/q¡dQ—a*\àdJ†Y ”w¸±§/‚{E±ˆ\â‹b„BL®Ë¢I\åBO\ÕRó\èÓ¥Ÿ£T2L»ªš\×Pi§PO©N(Œ¶¤—\ZzÉª\ÛCB[\á«*.i¶Ø´{K°JIxDF]\Ø*\äˆ…cµXYt\È\ŞUª¨\Ùôi\Ò\ÏÑªb@ÒšƒP\êÔ¦¡¦^FIO\Ë#E«!%œ	\ÅA&÷8y·‘Z\ç»F\ŞFºh$$*/A€\\FPÇ­[ñ\Ğ]3§FHı\ZÀ‚¨6La…\Ò\Èc\rql\Ü5›\rX\×\î\ìˆ>\Õ¬$2‹BB				z“\0}µ®\è%\â‰ÿ\0Æ¡\×Cúy¸f]>E\è(5a>©4+PLÕµ\Òè’œŒŠJ¶\åû/z$$$$A…\ZK*¹ò\Ü„\á‹Uô\Ç\è¦9/O¢T„\ÓBb},t\Å\nÒš4ƒ“q\àÌ‹AX÷ÿ\0\è’ÀY;d©ØŠ¨‚	G¤’›\ÑvHdc\Ó¡T½PJ@˜ŸL¨—d\Èñ‡©\Í÷r\Åa­Å£¿4EHLÅ”\×SL°¼UuAúCXOHdr&\'Ò¾Kq]gda-İˆ\æú´ARB L\ÇÒ·\ØŠ¯O‡|‹³\Ä\Í\ã\Â\Â	ô,†8¡*ö¥¦AR;W\ìt>ˆ_œú^™ˆ÷ƒ[³!\r«˜Û¸“¥Á12kGğhQ\ÄH\Â\ŞY‘(ğUS•‡\è ;(\";ºöQ%»i‰vfRÁ‰\'¡\Â\Ë-¶Eü,9\ì\nmWw.	š®‘1ú<\âB]Œ‡…R\Z\Ú:¢Kv\Úµ\ÊX¢	ôZ\Ğ\Åğµ\ãø4~D}\'B3ô?@\Ò»\ÙYBX\íZ2=\Í·\0„†g,LŸá‘—\Ø[¡L]}‰]qGs[²±;3P„eşŒ%;‚\Ç\àš	ÿ\0©¿¡LUcìµ\İH‘6	›½\È\İ\éB¢e™ıB»lD\ÂcŸ‚`A2„T_OĞŒ\æ\n±úòX»	\\ƒ…EB\ZI‚»pÁaP&Oğhú\ç\Ôô#?Lûò.™öRT™5©1¤\Ä\É\Â»p&B4\Éş	\\úş„g\è\Øûğ®\â\ÄôOO€!åŒ…Ö™j\Ä\Å§mDP\Ê`˜\\ˆ/•Ğ¢ÀªW\Ñô#\'F\ÇG\ÜG€	V\àœ‚vv59U~¥\ØLpÀ~z¦5´O°\ÈÅ€iµu?\àQõO­\èFCóô>öfwÈ¬ªı¦pYŠ4Q\×\î\ì%”Yh‹ÁE\í&8\ĞBvXÈ‰L›kÇƒÄ°÷ğ\ëÉ‹×£\êŸ[ĞŒƒú¾	¥]\ÃKy;	2\Ñ&ˆs©s†šf2~{¢b	ŒQ\ìG¡\ÖOlÄ¿\ÃMª\×ğ\è\é\Ôf_5}ø: jœµa©Ò›’‚\íz‰\'Uˆ©n\Z„¿p„F\ËB+¾¦;©@š\Ğ\ÒÚŒhB6ô\â¾gú-p`O&\á›Xÿ\0\İ5¯F¯\'Tf2ù«y¬l$-T\Ãp„5\r»N\Â\â$#›ß.\ÚHW|#]lJ:ñ1òÍ¶4ñY~ñ©x[’\Ûúò„›$ş\ØT6ao#\ì\Ş\ì„H_ÀhÏ¡ĞŒ‡Ü«w\ÍÈ«Œ\Ùğöü;„Z,¢$]|ˆQv·a\Z\ËbQ\Øk8!\ä²+†Ii\åA?, Îµ©54¿‚G\æ¨\Èc\å\ĞûÑ‘\ÍX¸\Ï&8&\èWF:j’L\åş\ØF\àl#\\lJ:ds9E…¼™\'½P\ï£q!¶\å¾\\‡O\ÚJZº\éò˜÷Nü‡å¨\Ì~z±¹d «‡Šö\ë#‡gˆğ]JpF£ğ1R»;°A±(\éd\re9;\×À·	œ±#A¾¼¬&w—%\\G5°²û—“\Z/\îœQ÷ÿ\0!\ÕŒ¼\ê\êûv-…„«2\æHUmµb\Ö\ÙrBÕ¹7\"B\ë\Ü\r„jLI.¼ú\ZrŸ#6™ğˆğ;f!—^™™~Ì°”\ÎÅŸq\Ò~¡ÿ\0¤(#ş\É\æ¨\Ê}Š::>\ÓC2^\à±F´\ß\ì\Ôm+wq%%>5\ÛTIBhl\Ø\Ü\r„j‰%\Õ\Äæ®ğ9µ>~¯…¾HM\è\Ô\Èeòÿ\0Ò \ì0şSQ”ûTt}\Ï*&sWú\Í\æû·¹\Ä2\âG1\\›h;\İ™öP#R\âQÒ„m¸K,·\0»\Z€«\Ñö\Ô6-7	ü­» ¯6{K>\Ë_$¬\ï®\Ş(%EgÂªQ\æ«&s\ïQŒ}/©Q ©¡ ;b+\n!¤\ïcQEÕ¸o£«†H«GPù±Zh°(\àfµ­³^\"\ä’öP2	|ÿ\0\ÅM*\îşneTg¬t}´{°„<{ú(ºy\Ó\Ôğ”v pIc^\Û-‡f»öZ\à›/øb\í¶\ê\Û<pº‡ƒoğˆû*£-S£û-öFW\"\ìL¤Î¶\ê¢øÎˆ\×\à’K¥ŠA7EÁM\Öbr¨’\íKÀíš¾?\æDÆ‹‚ù¡k–1<\ïõÂ¢—V?„,ŸbeTe¯ci<—\'²Àò\ìË¥<y\ÑSªPºŸª\ß\èlšU.Aj\ÎCŒ\"\Ô;Lºx1\ì\Éü~µ\×ù¸—»cRR\ëıSK­,+¯\àÑ„2ª\éCûyf\ÜüŒQQ‡;¤]kFš“²FÃºË®\'3?\"ñ¹m\ä7ı%n\ì9O3ıQ]•gÁª~UUö”c\í\Í		\ØJYŠ*HtT\î‘\Ò\Ñ&Û²J—T”;\Î7Z\İ\î\ä?Õ²“ö§P°\É\ë±ß£Cş\r@gÑ–…`ci\åp%\îEØ‘IŠ\"Hó¢§t%\Õˆ4›¶\É\n2£9T—†\èÍ»Î®~Å”\Ü›)k?\Õ4»n\ã\Ûø7\à™ôe\ÖGÚœ\ä\Ô\ìÛ°CKQ!~Ê•\à]Lj÷YH»~GĞº\É\Å\å\Æ	3#>gØ½‘õLO+\è®/ôGa.\î?‚#5\áôg¥X\Ç\Û\Ä]Ÿ\Ï27\ì©ı	uJ¤3|÷H\Ì-\í\ËfCÿ\0@ù!€\î\Ê\è5\íş©µû\ä\å¯3t¹Š1ö¦|‰	\ØY<P\Ø\Ñ%Óº\élI-†; \ä\ç’d!%¸œO$\ÆÁ\İ\Z=™wı”%À~ˆs_Â£DX{w²\àQô¦N—8±G\ÚH8\è»iP!.©xH4h\ØÂ’\à\è‘÷¶ˆŠ&I\×\ïl\Å\Ü\å	&Ik\×Áğ–*\ãË½cOø=‘“©–(ûKf\æ·i2\ì\è XYpÆ’³L&EÔ¼yŸ\ì\Õ\nš\ÜkF1ìª.’s\İj\Ã[øI\Ï\Õ\ËÄ»/C¿‚P™\\\Éj\ÂKK\å%\â\Ã\ä%œ\'Á\Ê-\Ê\æ²\Ó\Üc\Ô0¶§VJ\ïcø¦e\é±Q\Ğû\rî…„ô¥9Ç¼x¼\Ótø\åŠ\åˆ5Y\ék\äXEø)¸²:\Ë\ån„’¢*Ö©\î4°\á¡}–\Ş\ìK­Ù§\ŞAzôeó>\çP0£\ì¼<-\ÏB¦Ú¢Z%a6C\Üû£“”p.[­x72•ÜºJl\ë­sÚ™mE.\Ã\ZW{Rõ\èûS\ìue7-\ÏzF›‰\é—›vbI$_\Îû¡\'Jd´=\Ïc\å±\0—k}\ì§×ªS\ït:}”\Âî¶®ï¼„ˆ¿’NaĞ“\àºšE¦öE›9Mó¶\èmr\0´=\Ì\Ûl-ˆ»„\í\İx\ZŞ¹P\ß{¡\ËYöO#‘a;ªbxhg6PE,E„*¥(M5‘\Òh[\\q¦‡Ì»r\çmĞˆWc\Ğ÷G²²Ø@—wZ\ïc\×aŸk¤ş\Ãa3\àK½\ÙT¤L*[ÿ\0B!2p\áÙ‰ •ü­º$’Âƒ\Üö¾[	C\ï;4û\å\ëU+\ít¾Ñ‚§\Ó\nn,Om¹\ŞJg°\ÈD‚£–†`T|\Ùº]\ÎÛ¡()fZ9=™–\Ô ]Ö¤{wµ/Z\È>\ÇF‡\Ş0Qö·eF‘ì–ƒ¯¦E‹,]¢ö 3\Ó\á•\È\Âcg\Ã;Û¹\Ût(C§Bh\äö\Ø[	UY÷±\Ş<ú\Ô}·\Ó4>á†‡\ÒÌD„»2M/²\ã\Í2¾\Ú\Ê<ºÿ\0Á±\rÅ‹—s¶\èP,hÏ‹j	t>ör»¬^·\í:F‡\Ş1\Ñ\Ğúg<Ë²\èñ˜´ˆm|nHT\ì%©ğDš84\Ûa®$\Ø\á\ÜB/\Éò6\è‚7)d<9G°²Ú‚]K½ckø¢ê°°}ƒZ2A.Â²—XnvŠ[”ül2ò“\ØT\n\ä‰kNC\ëj|w.\ß\Èû¢\Ù\ÈY5Os9t-ˆºğû\Î\Î{\È/V©Yz\è}k^\ÄK\ØjKMvùn„f’,CJ®ÿ\0w\"X\Ú{£NG\Ò\Ù\ãÁ¸V3¿‘öÒ‘B6\ç“ú¢ —a‹×ƒòõh\Î\âg\èTÏ¨>³p›.&m\Å\"«–°r8\Ø\ÛÆ	\İ\İ\Ìû¡”TM“«n{\\-ˆ»JÏ½>óõhúŞP>§f‰e\Ô\Ç\ÕmÅ¸\Å}\r£ğ\\¤\Ö\ãr.F­~\î!e]\Î\à\Ë[Õœ\Ãß“T\Z-ˆ»l]\Ô·u‹\Õ*ğt#\îŸZ—\Ó\Ñu\ä\ØÎ‚Oú2$K=CL§†<¸l®\Ó1¸ó\Z\Ë’»\×r¸AH²3\å\È\æ\Ö\Ûb5]İ\åf\×{\Õ\å[\ã¡dúC£\ÚE…\ìA;\ç$g€B~$§5\Ü\ì[iWË“\ØlD%±¡÷°«O¡Ğ´}n¼Ë/r*½$Œ¶1ş£\äUh˜’!œ¤²“º[–E/\Şc8’Ej\ì¯N6|Ÿ\Ò\ĞÒ»\Í\İj\Æ1\Ş^­3ğ\èG\Ü>ˆú²¼š\İ¶	6´I+^¡S\Õ\İm\"ƒƒÀ\Ø\Ê[@\'ÀY<(/G\È÷ğ\Û	U[¼×½ñ÷{!c\Ñ#$}\Z:g,=$\Ó$\Şad±\ê2m£\år‡·¨÷Áü<¸Ú°ôò=¿±—C\î±;wR\Âr»¬^§ñúQ#\ê\Ñô¦|‰HÜ‡]¨H),º[’¿\æA®û\èB\Økp\Å½#.õ;\Ø~§ô\İG\ÓúN¸h5¿6GdÜš·	³[1$\î\'a¦.u\ÊÊ»\æ+*o\ÄU\Ëko#ş—B]|ú\Í¾NŞ•Wò£\êUG\Õú+v[šH¤\Ù\Ø\Ñ\'5‚\æ$>S÷¸|›À°;¥¸\ÍIˆ­[®B’;p£x\Ø\ë*	1\í\å˜õ\è¥:£\é}… œÕ–\â\ÒwKqw\ä\nÍÃ²†³ıB.\Ö{^ö<»Û=>j\èb}*:˜ù32œ±FÃ˜±÷»¥º\Ük,X†]xì¶ƒ\'şH…\Úf\Ö\'+º’†•\İbõ\Ú\Ö\êB›h0\"™\Ø1L“\ÜA”ğE¸aNÅº¨ü µE \åYG\à:­L—uY÷–{\Ö2\ïaúsø¤?À1\Õ\à³4¹²œ©\ÔN\ßY\rDQIº(\à9ÿ\02\ë·u÷´1wXœúo®}x\ê¨}«.Ä”JlˆIs	Ø·\Ù\ÄB©ˆ°\é«-`ôÿ\0®D%M\æ\Ó\Ö1öO\Ó}3>(\ê¨ıA†„ÉòYš-k¥¸\Æk¤\ÍYø†OõˆÄ½µû\Ú÷°”}Ç¿¦úgÑªŸ\Ö\è{«:\rrœ¯\"\å\r™D1Fw\Üœÿ\0‰½ô\î±;wRP¿ƒ}s\èUO\éQŒ‚¹º›Á8va®\Ù=S³Ÿñ#\ê×½0û\Ë=\ì>ö=+\ëŸL:ª\åŒcÔ®hş\Zy\"N.\à\çü|ˆ]Lkw\Õ}µ†1={\Í;/¡,4¯F$ø¾\0\Ù$‰\Ñaš4ó\ßø†”ô\'«‚\'şˆÄ»8\ï»Í\ÖluYú.D‡ğ„qB2˜¨\")´&rŒ¢c’=wú\á	¤’ODÑ’¢I I$’I#d–†\É$’$Q	!D¢Q(”@…!D\Zd%\Z\rĞ™$¨„’I$’I$’I$“^{’\ÜbaŒXú‡\îG\ìBş°ˆ\Óô-\İ4G\îFT^\Ât·OÀT<]\ìlu\Ö#Z¾\á\0€–y\Ø¢(]±&v,0\r|\Ç+oV#Í“–}AX\Ä\Õ`pO	l°H—\Ëa¢\İş3\ÂZ?db\\º\Â\È\Öv&Kÿ\0\Ö@gvøj\î¨QM¯ñM\ä\ß\È_#\ÑX|\á)–;c\É=˜vG\à	\Ä\ÌU³/\Ê\Ë\ßõ/7<J\Êõ\ß\áL°õ&Î‰r\Ü\áf \Ê\ïYr\ÜMœ{\ÃŒîŒ½	—œA¨ı›6Œ\Ë»dYz˜öÄš\' \Ë\×n\Øor\ï-?p5-<\î=b\Í/’g˜`S»ü«eôo7g¦…¼ı¯øG:ù\Z²Z6\ÔÏµ¥ ¦\Ç\Ú›4hMº´›.¤\Ão-Õ„A3„hµ6m¾E\r\à-\îcC\ßF±Áğ¡ğ \ÙI8\É}¢\äl\"\ê7\ÖQœúµ\É\àÆˆ_aEl>ŸA‘«[«\Æ\æ£ğ+>\Î–\çsÎœ0Œ/’¢kOÀEö¶^\ÃN\å‡ğ*K\Äş§v\ä5Nÿ\0¸šIYşC]‰ÜÁûÃ°şMCivs\Z­z}\Ë)K³ü\É \ìrÍ·ş Ù¥\İ~\àò±e*Œ¥Œ†v<~ñ¶O‚\îX-\'p$f° ¦\ÚJF\ÈJ\ëğ4ÿ\0\à77u\×\à$5q*Cş\"\à\æó\Ù\"\"O‚32\Ø\ÛC|?¸½‹á¹’[$—%ˆ2\ÄJr	—ü‹½\È\Ø,\ë\ä–{\Ù#)b„@s‚yr®\àKi\ÊE­‹o\ÈÀs2Öš{ŒQ”X4\å\Õü\rSA—†l”2+:ù[VPQe`w‰ª\Ì\î\Û\Æ\ÓYqi·\Ö\ZD‘\ËÁÂ½º~±ô\ê¨}:\ã\0zƒ\Å4û\ÄMD¦‘\"Vj¦˜JF\Ì<ö¢$†­F\Ì\á¬\İ<\ï…3\nh–em¹2ˆ”­DŠaS\Z†PŠBj\êh\ÚI¶Nğæ¦bû\Ñ\ä5MSp5\åŠ$–Q\ãLŞˆ!©¢a\"Ëƒ1\æšE÷¤”6\ï‹\"8›X{\Å\ÂB¦®¶?\ÒMÄ°“G!	+Šn\Ö_‘4‰£\É\Å ±•–\ã0OÅ¨¢ˆ’\ïÄˆ™L\r‚QnYfü@\ÉBÒ—\Ö\Ò&aLcZ.j‡-±x6lH!\n¡Ny¯œ…ƒ„2h™ˆÿ\0\Ö#R ‘6\Ü\ÛˆQÑ“rˆH}lkE	ñ\r¯Á\è¢ı\Z \ÙQEDLmQ#]¡Z!tKNÈ­\Ğ\åÈœ^\Üô$²\àK½§bŠM$ò[V’p\\ôNûEĞ˜D’\\˜Ç¸v§cJ¾\ÌXN(Z§=\à,“Af\ÑW\r\\„V\Ğ\n«:\Å\ä\æ\ÂT’¹\çB\è·tİMhmVH²–\Õ\Ó÷\'²F\ÉD¡Aˆ\è¬{\Ò\È\Ù$’&O¥ŠAE ‚#¢)˜ \Ó‰\rˆ\0\Ê\Ø9g0\å£u\Ùrö\ZO\íÿ\0Xµ\\Nû\É\Ş<‡ò7\êÂ…ıfvd¶ Pa<”w\ÑM£}\ØöşÃ¿€ Fù\Ò7\Ï)\Äo!\ä%u\Ñ\É)ÿ\0\äı\àı`ı ı ğ|ƒô#õ\"ó\Ñ2ºNÿ\0¹\É÷?\\Ÿ¢N/¹ı\éı\éı¹ı‘ı\Å!\ÄZ›?R©\Ğ\Ñû\Z9ÿ\0(\çü£òa\Í9‡0\ç“	4?\Å\Ö\ÚD;f´\ÜJ\ÖRX˜\äÆ½Ç¼ù÷\å_s‡òpşN\É\Åù8ÿ\0#\Ò\íQ\éö\æ˜É²Üœ/“ƒ\äq|\ÛtxM¿’‚º\ïh¬\éòh)\rº!\Æ8¾G\ã\àG8‘Â\ÉÀù\Ã\äS`{Ba \Ú\Õw“÷³÷3•òs>NgEÿ\0DOÿ\02ùÖª=0P¸\Ãõ&y¾7Áû—N\ÉğN\Ç8§\ãœŠq\Îö\çŸ\Ù\àù?i%Ü¶\ä\î%	›Ø”J%	‘‚E,Xi!\Ğ*\ï\Ğ\0( p @Š @Š‚(‘\"@‰=¬‘r[÷!\îCÜ‡¹-\ÎbDÉ“\'O\à\â\â<GˆÃ‹Nş°™\å]\Ü>£ªE— À+°H’I$’I$’i5Bş\r¢\Ç\"9Î…¸\0š:1Ti‹…¡[pOˆ¥-\Ñ>\Ôüš\Ë\á&¨<\æ1¬9Œ£0\æ2‡!\Ìs\Ç9\Ìr´“2U\×J$’h¿ ‚0¬2:¤$0•ä„¬¨N»Tb3w¯‰bT¤I	)È…H Š”QE1:I$‰’!P…é—¦x\Î\"{C\"D8Plnƒ:*C¨e«bPÖª\èĞ‚ÔŠ\äSCP#$’H˜…Bş1‹&ƒ´­:eVu\'V}DIv²­\"R»\'\Û’\èÙ€{	\Õ!…Bõ’O¢÷‹rp|ıJ$\Ó\à&hP\ËE¯??§G\í£ö\Ñûhı”~\Ê?E¶\ÛG\ì£öQûhı\Ô~ª?8ÙŒˆŸšE†\è°1„„ ‚.„½T“\èn÷‘s‘¡T<#\Ì @…J4¡\ÕP@Š{²],X	aTH‚ K¡z\É\ï¾\ì1t…2#yÚq\ÒI¿£\n¡l†„!÷”£2¨V\ÈxB\İyN–¾j\ê\n„A=\ç\Ú\ÅºP™ ûêŸ”\Ë\ì`¬©ù\Ï\Â0\áS!ø\Æ\'\ÒC\é$òÀ\"‚AGğs\ÜN\ä1‹\n\Zºfƒñ\éù¾Š?ŸœüH\ÄúŠ™\Ä1>“«ÂŸ\n(!Aü,ö\ßsØ²&*+\Í\ã\Óóü#~53ˆ`}SñFøâ¬ˆ\á`ŠDE`D†/\\ûÜ“ÀcD‚mG‚\0vò\Ø\ä†p°@‘9´·Bm‰­!26\ÚY´m\Èn=÷¨±.\ËÓ²ˆ#¡zT\Æı{\íÚ’D¿±\ËDrZ!\è/oYC#˜«öqN\rD(<†	y\Â\\‡«hş¬%a\İ\É$’I$’I$’i$’I$’M$’I¬“I$©\è’iV²\Ó8·	uB\ÔOb{3‰œ‚ü;ö\Z\àrş(LR˜\ç\×1‘-„\İôG;\à½É¼#ú\Ãú\ãŸğN&,ra\Ëø¬§G {L\Æ4,u£IC€q\Ï\ïtr£„pJ\Ç\ãP‰\nQ @ @”@”J @Q(”J%‰D¢Q(”J%J%‰E‹MID\Ã/fP;\'e\ÅF\æ$ °¶obTI!®¹b D¯Šˆ\ì“L¸\Ñ\ÛÕ–{\ã¾L\Æs\Ü÷3‚S”©\î5*\nˆ	$AUxHsT@e ”¡\" šQ†\Zz„n‹šB-E¬#IYlB\Øo\Í#&÷!±\àe\äJIØ†\Â!v¼	M¹ 5§e¿$*+‹{AZ„\Èr]\Ä@\ï±\Ú ¾\ãHf]ûP\ŞƒBAZ\Ê\\û˜~\\Ü\ä÷,\\¸ôµÑ½\Æ¹\Ñ‹™,\ÍH\Â\Ü\æ™™\"\æIûD\ÑvKq:\ÜOq\İc±-\Æí„·˜K3%¹y³\Èb2N &ŒEˆ\ÌÌ˜\î°Ø\ãJÑ¤\æW˜ôÂ¾vm\É\Ãa¿ÿ\0(ı©S\êŒ8\Ö­3˜¼¬ƒf¤†5¦\Ô^\Ä25†$\Ö\rdE\Ûh˜Ou\Ô(w(ˆÖ‘û‹}\å%CE’^O·\à1£\ïDÍ£z\ZÈÁµVœe\Ü:?;E¢…\n$P„\Ê>\Ê@\Ï}h†Œ[‡ûc¦Y–\İ~„—Ci7\Z´Ë‡5m\"\Ûv\\‚\ÜUhËMkaú„\ØSv9½Ø[Cm¤–X‰6\Öz ¯˜—H\âWCT\Ê[\"sT²„·btC\èA%\áM\ÉO¢WE‘+£®Í½%¢‹\\´ •R}Ê£1—˜†+Q\Ï(&•´[}²I±\äIª>O\Ââ²‡g”ñ,*IC£f¨·‘°2‰aƒ\İôELı¢$™7¦#ET\éI”5¤\Êc‰#º†şğm–L\Öq<	J©\ÍÃ·ÁHu‘†Ó´)\')]-ºÕ’\Ïqa\ÍRraŒ\íš»6%	P\ë$®I\İDşP\ßÁ\Ñ&v\ÂË–\Ë0W\æº}…½OŒ\Î>DÁ\ã¡	P¦ì“±è“ùÿ\0B\ÅPñ\Ù#Y%ôC\Ú`\ç,\'&cxC\îªµ\Ğ\Ì9¦1”\ÑG2Q©L‘\İ‘*HDe&\æs!\ÍÉˆ#‘ˆ\ÖG±\Ä2¤…\Ó8ƒ\ZM¨\äYÄ¸\Ó\ìq	Z&g\"\Èô—ZDš¡\ïÃ³‰¸ÇµM¾\ÎDr,ÀÙ•-—Á\Ä$\í3Ë’˜>Nd8\Ğ\Õ6»’‰œõd7x®¨†\â“9\ĞfX\ÉCôHµ†I*\Ù}–¨ı1¨±j£Sh†6õTbq¡G®jŒÁ2=\Õ4\\Bn•-D):AhˆqGaL\Ó‘1\àºA^E¤\Í‡u\Ä{’Ó’\à¸_˜\ÍIr\â’R¡†6\Ğ\ÔtÊ†r†½DM°3\Ä#&mKÀ…\Ä\Ì\Â\àˆ)¨\\°Ä“qY\é)7Q\â5e¿\0t3\ë \à)úˆ\nb÷3Z¹NB€{¥¾XÚ \ËV£piø9·\n]\Ò\Ñ=0¼\ÜI¸\\\ëXD½\ç\'T²\\vš\Ë\ÂKM\É\ÔÁx–6WjÉ™l‘„´“5ø¡™òG\î)Ì™qqgHÙ†ªÁ\É	Mİ…©\æ.©\'XŠ»€\í\Ì\Âşz\ì·qt+…¿X\Ô\Ğ\Ü\Æ\âYô¹\n•_‘È´/|°,`P¡ˆCÈ—½t.T¦iP³Bù	?{!ög\îlı\ÌıŸ­³ö¶Cÿ\0¶Cÿ\0³õ³õ³õ³õ³\ìnA«\ä\çüœï“òq?“‰\ærq?“¾G\Ädd\Ëş\ÇÚœs\Îp<AÀğe³¾O>dó\æL6<¸ƒğÁ\Â~Y?$\ÒüEœis)ù\'Ü†)~8ö3øƒ??\è\ç\Ö}\ÎMd\Åq!D\é&6\Î\ïô?‘\'ÜŸr(\ÙşÏ¡>wùIù¤…¶9,‹ƒW\Êl¹\âÌ,\ÉlB\Øğh˜b9º¼o¡ª\Ì\É9˜fI­­uˆ?\r\ïgôJ÷Y“‘fLWBgö&	[¡4°<!”¥{—\\·Fz1üQ\\	5pJK\Şh¡3u{\Z1üR^\ÛW8!¿”\ÑG\Ö\Çş(\Ój\ÆF–I^¶\× ½jh®>\ÕU\æ4cø§û!®…x³}Y\îhª>õU†4t?ñGJJò:¹f	\êE>E…Fû\İAø±\Ó6\è‚+=€ °¥ıªª–*‡ş)xe³\Zµü‰6‹!û]WüQoœ	\í\Z²1\"8F\æóO½\ÕQÿ\0‹Pñ8-i#NÁ„ü\î­a0£øªK¶Ä¡¡’H¹\'h\Â}\çP0˜*1ÿ\0ŠÉ¼	X4*İ“¹z?jf\é0Ñ™Š\Ø\çR\ÉÎ¦\\—;‰‡ù†~Å¦ÿ\0\ÃÏ¶¼2õ1±¿ñ\ì#\ê™ú©‚lŸñ•×»\î‰Â£‘¯òPlqKqD_ûBh=±\Å8¿\'\âœ„q\Ç8g\áœc€p	\Ä8\áC€qÀ8\0\à€pÀ8\0\à€pÀ8\0\à€pÀ8\à€p\Æ8‡\0\âcŒq1\Ä8‡\ác„p\Â8G\ã#„q1\Â8G\n®¿{ª±ù5\ZÌ‹hq„\Z\Ú|\Ço€\ÏÀ%’°’\ŞCX~ñş#/ˆ–W“\ì\Üyx\r>H„üD“\äÄ–ğ\È_\Ş4ø#ğD%{DŸb÷\r!øúŸ€“\ä\Ågƒ?\î?¡\r/\àEµ\í}„¼˜\×\èÆŸB3ñJò>\æ!§Á\ro\å…¹†52!Á!¯\Ğk#Eµ[\Ã#\å\á¿’\î$µ·!a\ÛA¬\Ûbû‰+[VBµ´tFHü­mKX4\ZÍ´¾HR#ƒş\ÚSş\×şÚ\Ú\Ó\ÛCÛ¯?H©Z©õ\Å2k\ì!q/tC\îH$ù!\Î JgAûÁ¹ï³·	ø S»Dg\ŞH!\r_’?P\\ŸKù’\ÈCò5^.òA\Êo’FEÏ€g–\ÂNÇ–²yk$ˆö“} ½ƒ]ö k’°¾­ü–,\á1j6+\ì)?3\ËY-G“\ÏHzö¾\æ˜õN²$OVy\é@\×rt2Î²Z³‰\'G\àK}&³¬–?6O}Ss¤Z\É\'³µ\ÍÆ„¯rt<µ-YÁ*_B_E\Ì±cB{\èB›\à»S\ËRO“\È\Î\'B]Y\çŒ¨>œÒ‰š\'¢‘F°ƒ\ÆzP\ÍM–¦h…–\ÏıV(\ÚY¤\'I\r\Å\ÉQ$º,\Òy£8eZB™¥\ÑñH\"(\ã*!L\Òd\İŞ†}D’\Å<b\Ôi:G&\É.H›tºÜ„‰(jh‚[4”\ß\nB™¥\Â|‚V(’J‚[„A•\İ\ZL\ÒLD\Ö\Ñ\İp\è‘S\ßõ¶k\ÇFÔŸR,Q5\èÁ³¦$Iù\èƒ	BK¡õ&üô=,\à€]Ï¬ô\Ä.‰ø[~™IûtNC\Ş[F7g¢Ó†(Á¶\ã¡\æ2GÊ¶ƒ¾:6‹¡\Û\ÛYÙ¤ö\èsÖ­ú…*\ÂP’\éB¦‘ƒ\ÇCÀšQø\â£k\".%a\åş)ı±Áù8ÿ\0\'\äı,~>t\Í\Ë«GÅœ_/\íF¥ş\Òbp,A_ğôŞÖ?ÁıııQıAı1ıqıqıQÁø8?ô\ÇôGôG\àşˆş\àü\Ó\Ó\ÓoƒğXq>Áıa\Äø8Ÿ\à\æ_\à\â|Oƒ™|\Ë\àş \æ_2ø8Ÿ2ø9>7À\äø\ß›\àr|O\Éğ9WÁú‘\Ïğ9Á\Íğ?r?R<\èGƒ\àğ|/ƒÁğrüĞÁú\àø<\'„ıHğ|¡Àx\â<g‹\àñ|#\Åğs/ƒ™t\Í$¢)½Ø’I\'°{@	&‰\é	$’h’I$’I$’I©5$’I$’I$’I&‰$’I$’I$’I$’h’I$’hó\ÔÆ¯\Ö\Z\ÃV­KñY\í¾‰2vz»o\Z\Ú<c(bv]!\ïn‰—)\Ò}+GĞ„–Eo‹I\Éô7	”¨\èc\ZÂœô6#\ä‹\ÏCŠ\×I\0\êû£Q­\Ôt6Ñ‚\Õğ„dEÑ¬z±%­[¼\É\éuN\Ã> ñ\ÒÜ«On\êö°±-RHD’Tm(¢²¾±D‘¦¦k¨©7£-BØ‘Š\Ì)4†½)3Y¤ŞŠ\È\"J£°hV&\'‘%šM,\ÌIX‰Š4E<:\Z•õK¨\Ö\åù‹÷\İ]±Oª7\ÑbØ…-‡±l\Úµ„\î\ÉıŸ˜jIy-‰¦\ËdfòM´XnĞ?\äh+^\ä\å£\ØsùGú†/q\É#cñNûŸ‘8C.	¥\â	ı÷1;\Ï\ïbO’_dŸ\Ùö<t¦Ü™Ç{ò\é$Á5òOm`‰+fIm¡“\àj°\åE\É{,h<\Å3\äKcSŠ!G$öÔ›\"J„ò\ènÑ–1 Æ‰¥‚d\ã¼û*ŸLH~*†¥ˆ*Ö¬z8’d­\ä\Ór_Ck\ßbR\ï©?²v÷%ôO\èo\'û‚{{˜¼¿ƒ!/±Z÷1x?\á/²J<˜<ú\Şö%ö`òağ\Ï\Âf3y\'o$\ì~*_¼¼˜=\Ë=‡±©\Ä1ûœ:-¡šÚœz‹hüCú†W°8-\ÄLo>\æ‹JS\'÷CñT¿ °½O\Ò fÀÿ\0Ã£³ÈÌdr#•\Æx\Å\ÍX\Ñ?ğ\ÔLH	·\Ê\r·L¶\Ó=’5ÿ\0¯·\Û\ï~\ÓK%¾I‘‘‘òS\ÊyHn#¸†ò»X ŠAAE\"°E ‚)AE ŠE\"GLtE ¨şƒ¹¤ôI$’M&’I$’I$\ÒI$’I$’I$’I$’I$’I$–I$’I$’OøÔ“I&’M$‘±.Š¹‰\îOs\æ¡\Ès\Ç!\Ès‡5C\ä9(r‡!\Í\ÔrrR\ä¥\È1İˆ\ë=H‘\"]\0H‘2Dªc\ë iŞƒ|\Ñ-\ÉnO$2¹†C!!!\È \\†C¢r†\\¹r\åËË—.\\¹rr\å\ÈeË—.\\¹rô\\½.\\¹r\åËË—.\\¹†\\†C!\è†C!\Èd2†C!Ğ•d‰T%C€‘68€\â8#Š—\ÄGcˆ\â8#ˆ\â8#ˆ\à83€\á8N„\à8„\à8€\á8€\à8€\ã8N#€\à8\n\\G\ÆqG\ÄqG\ÄqœG\ÄqT8\n8(FÃ€l X¶\ÔX±bÅ‹%%TS€´\å|LZsŠ\'\âG\êT®`\äˆÁ¯¸œ\ï[ZFr\Ç?\ärşG+\äs¾G+\är¾G7\är>G#\ä~¦?[¥\Ö\Ãh_F~\Ä~ôrşÖÖ™\Ëø\'\Õğr³”\ç9Y\ÊşFs3™üÏƒ‘ğs>gÀ\Ñÿ\0\ï~G7\äsşG+\áŸ\Ø\îöˆ3Ÿ\Ô\ÒR\Å\È\\ÿ\0÷£ô¡ÿ\0@ı\âøƒ\à@\ê‘úHıD~‚ şú?µGöˆşÈ\ïši”\ëpÄ‰\rRW\\\Ù\Ñ\rbI¯`\ÛEaôMf’É£d’I$’I$’I$‘Œ†–…\á›[¨\ÅX’I$ln–\èwB7\"I$šH‰\\’\'ÙšM¦¤\"Or9£’\ä´/bNÎˆle\Ø\İ¼\"òò4@‚+@ê†½\ã2‡uDm8*\r@@‰„›Ò‹¦A¹h-\ÄÔ…O‘qy=\éK{\nML‡Al\Éj\ã\"Ş˜=‹Fa¡Pa†$Kd²D\ä÷#¦¬R ŠGB¢”}r°\\­Cøt‘¥E[B¤¨‹!\Ñôª–¡M24©u$2\ã \Û\ØhJ’U\âŞƒ\ZûK³\èZ‘\Ò \ì(AE^°¢^ñ¢£Úœ\"QD4X\Ğq4„\\wjˆ‚;\èd\Ü±£Y¼\çV\ÂbD\Ñ# h4W^¥Öº\æ\Ät¢5\Z\éŠ1ˆ\ÅË“F\Ç	<&–É°×¨Ø’X<*h\Ù#cYI©¨\Ñ\rI÷,7qArc\ä\r: c\Æ·uQ\Z\Òº ‚\æGT¡	À¢N„bd$@•—‘q¹oö\ÙdD&M\'rIdHÅ‰“B\Æ/@„,{†E‡!†ˆ\é 0m2Eº®µÓ‚GMz$d\ÓA\Ò:£‘–ÜG³\ìHüv]˜&DI4¸™\én“F1G\İB]¢\Ä	\Ì\îJd‘ƒ4³ ÷€úWB¢\èhTUW®:f°\àfr¡»\"\ÕFKM„\É¤ˆFI½Ê¹,<ƒ,%’¨ŒdcV¤$1›\È\ÅÑ§\\UAY\è\Út±n.;\Ó}2:I5b\ì@\éo¡~r	ğ@PÈ’.\\HBcE\é#\Z>‰»¥UU=)\"TÔ±h_Mº0&2\0c°\ë­ˆ¤\Ñ\Ø}²ğ\êSé¬šZ¶D’‹¾²6J.G¤*!‹¢d°D\Å/\"c4F…Á¨ğ4%\È\ÑbÔ™A**7GI\ê}•¸\Ö8M\n¹=º?‰\àA4\İ”\ì5q¨û×¡;\Ó4˜&:9\éLc\Ågªa \íH¼	\Ğ}‹!u\éV>Ô’&:ŠW¤Ø¤¨´‡}‰{x\Æ\Ë(>¥Ô]CBTÚ˜1W~¤Å»\â\"£B\ìOeö_°À¶\îA#\0¯<ÆˆbF\Ä-H\ršcRŒö\×TQ”\ÆY\"hmQª\éÙ‰\\\ì\àx\"ŒŠˆuñö¿,3\ãÁ\ì&‰\Å2¡¦C/\ĞÉ“\Õ4UUN¨s% f\è³W$Œf:?ÿ\Ä\0*\0\0\0\0\0!1 AQaq0‘¡±ñ\Ñ\áğÁ@Pÿ\Ú\0\0?P\\CEÀ95/vB\r\èMT¨“Œ\Ôe`%2·Œ60–—x¬Ô­Ê•¬¸±H\'h“¼62Šª…h&˜\â\Ã\r \ÕE€u†*\Ôt¾ \ç\ÍNU—q\ĞHk\Ä8J@õ+´\Şe°\ÒjğG\Ğ\î8)\ë\Äf\íw\Ş\0+\í#P!\ÌNs[‰P¬$(G\r\Ä\â&\áw-—h\Î(¢B\ÄQ‡1\ê*Ñ€¹AÀG‰Ä¸³‰’¹WC‚<\à‹M\á…CI&\î\ä\"»Æ…³”¨Eƒ\ã‹\Ã¨\×1!\é‡V\Z!Vi¡©H\Æ\Ïkƒ\ËšÀ\ÔH7r¥0 rÁjÁ2u;`p\ÈVû°\Â|•åŠ¨˜mi	ÁYw\Ún.§|.\Ø\Ë+q`sÕ±:kk5€›qL©L1\ÚwA°\Ä$£ˆ0ó+L\"\Ü\ß+!\àv\ÇL´\Ó!M¸@½\Ëw;ü¾0EˆÚ°\Ç”Ñ…T`d(_\áq\\9\Â%0p@¹\Î%b\Øüñ\0±¢z%vD\ÔÓ¦p¦\áGIÔ´V6À•…b\á	¤\"J•‡Ä®š•\Ô\áE\Ç\Æ%Rˆ9„·C\Ô\Ù\r¹Y¢\Å[†j\ÄT\Ê)-¢\0O8œŒ%>ÿ\0)MY\âvÁ\Ş­\ÊÁSISœƒˆ@cñ‘—R\åÅ®&\ì\ĞMa/\æ#r\Ô\Ã	“jp\Î!i{Ùˆ¯ˆ\È|c1I)¼Y*T©R«t\Zæ®§e\ã\0¡\å‰t \í7‚B5\ŞR\âeÆŠ ±f\Éqÿ\0ùŠW\Ä%\Ä2P\Å,\İ	S¾.[H›ŒLF¥JÃ‚Y–Ù«\æl\"$E©\Ø!o†sux+œ§†\Z\0\ÔUW,Ij$b\â\â‘I®€z¨ˆ›XÁDğ\Æz…q7š‰p\æ\Êb§¢w §”\í\Â\0Z­EÇ“\â/<¼¬j•b\á„‹€Á\Õ\Æ\r1b^\r‘2\ÊÉ„\Å\Ä*õS¾0\"n\Â€šÁ9†\æª,f \Æ\r§lº—\Ñp§ \æ10;¸\ìejr\Í\Ş¸qŠ.$\á‚!°\ËQ(w;Ó’W†\0\ìº\Ãÿ\0a«PEt\0Š\Üv\Ã]@ç¢»ô*\Øhc\Î¸\ä\Ç1\ï¼T©zV\ÙI\nx‚\Év;q\ÚT\ÒS(ë·ˆ¶\Â8IyXôw„#+\ß˜Ñµ‹dR°\\°\Ôsg×€Œp\Î\Ş\"Œª\ï¼\Åb{\Æ5\nL¨8•CÁ\Üeqól¬¨ó	p0aV+\Ä%Ô´¹m\àœ§0SÌ¸•Ä¸%½™gh™.Ù…CòÊ——\'1\ÔaJ‹.UjjUL6s&\âw”\ÚhÅ´pğrŒYw‚s•³\'QP½\èo\ï\\\ÒB*T¨e`±w\n†,À@\ÔI¨$a\Ì1yb\àœG§\Äñ8À\á´GA\ß9A¶)®§l\nHo$zZ†l0\0\Ã`\Ãq>\Ğ0	B=J\\F‚ n]KN\Ôv{\Â\ã—+A[¶VM­o– œ<E&­œµ@\ÈMapA¾p5^™paNøb¢<±\Ş>•\Â\âã¹‚Q\r\Ä_‡Ê‡\Ìa\ç/7y0ô.\Ü2,ƒ\ÛY*ˆªˆU˜»%¸\Ú`¾ò\ĞYx.Â‰WŒ¸Ÿ\àyb#j\íc›ñš$-½x \ãŒ\"o	\á\npËƒ©t\ã\Än\ãq‡P\Æw\Èhˆ\\¢\Øó¶‰\Ù)NC¸`¸2ÈŒy—Ä¸\Ëa“˜£\Ìp&u²ğºœ‘\Òn\Â-â¬¯\Ê;b\êˆ]ƒ»|«·È ¢h{¥‹\\ ¶p\rB[Jq5¹\Æ\\d,\Ëo)•Ğ¢\ê\\R,\\\ßhK\ÜX\Ås´\ç\Z1–5†–…Rõg8 \Ë\Å\áz—,‹œrğV,*K‚böM¢)s²M4\ä\æ$crĞ„%d\r¹Fu\ÕÆòø\"\Ş\áA\Û\á@ù˜–_\ÛÒŠ‹Š\\½Á„ Ë‹..-¹/\0ƒ‡\Z%,Ø”u.\\»a\rË†‹/Pe#*h@¸Ö a\Õ\ØWQ—/x—I\Ë\Z\âŸ2±\Ç\ÊS{ğ©C\0Â°vM o8 …£V!;s6Jš©ÁS\r‹z\Â\0S|•\åÁ\Ê\Í=\âi!—c\0ñQ„\áP\ë²ÊŒ\"+\"˜¢YŒ\Za.^° \à2›0³Xº–^!„#¬´uºà«³’\ì\Ê4K»ñŠ’hÿ\0\Êp/ÿ\0\ÊC?¡Ÿ\Ó\Ï\êgô\Óú\ÉWø\à\ß\ãŸ\ÓCı,şŠø•õSú\ÌwõòˆU9Kø’m\Ç\0ı‘(•5@\ï¹GµV^\î2¥rXB»°©ù|¦Añ\n2]Õ©\æ/‰ıL\ÍCøeş8„\Ñö‡úH[ÿ\0”õS\â\ËóO‹/\Â]8Š\Ë\Üb\Ş\'\'?…Àw\ÊÈ¬\á\ÌV‹œb¡Ix@«—Œ ´¹¢hVú3Õ®< #\Û\n8¾8=c\ã>3—\á/\âZ|\'\Â_\Äø\Ëx–ñ\ÆZ^m\Ú^^|e|Kø———\Æş%\å\åüKç¼´ø\Ã\Ò|!\ë/\âo\Ú|eˆß´øÏŒø\Ä\Ç\Â#\ÂW\Â>²ˆ§„LS\Ã\êOJzS×‹\å!\ãO^z3×‡zSÑ|`¾<ôú:7r3\Ğ\ÏS**U|Œô&\ÇI\êOB>ô\ç­=i\éOFzoVyº/t÷O|\Ó\Ì÷\áöOd§¡olö\ã÷cfùózù\èôó\Ï~gÙ‡\Û=±ò\ç\Ş\Ù\ïù\í\Øù!\Ñ\í\Â|\Ó\İô`’	=\ÓÒ¤\×\Âz“\Û=„õ%ø%ùü\É~Dù˜\ï\âW¤¨öôôT(Â¾\ä|„³²>R{\É\êG\É\í\'©\ZzĞ¶7¯‡\èt\n/\ã/6•“fo0¸Z/\Âq„¯“ß­uö\Î/\ã‹d\è\\H÷ g@\Ûİ„ù\ç¶\'\Ë=³\Ù=“\ß)\ï=\è¢1­2rZ—óÏ|\Ó\æ”y‡›ğv{ÜªöÏ¼k\Ì×”k\Ì×™÷š•\å\Z”MMJ0±¨CNSY*\Z±¼\Ä..ššš”d¢VEJÁLH¥+ZU&¥F¥€\Å	¢ˆ\"Rˆ‡™©[\æW¹G™©R½\Ä÷+Ü¯s\ï>ñ<³eDI¿8\r\Êf\æ\åJa€ƒP˜W—œC–${™ó\åWó+\î(bJ]`e#Á=3\Ñ,\í=8½P–\î\'ªz§¢z§«ªzñz£\ã\'¢z\ç¦z\'ªz§®z\'«1\êŒ=X½ğ\ÇÁ‚EG:”JJ@\Êù•••”Ÿ)Yò‰{\Í^b\Şó\å>r\×\Ìo\Ş_\ÌTöK\Ëd‰²\Â*TT\ê\")\á–\Ø4—O	\Z$¬$a\Ò\Çÿ\0‘\ë:V ‹p‘—X–0¾‹†.\\¸®LÜ¹no7B^|¥b5$\îC!ƒqœˆu+\Ô™O2·\ÌO˜3\ç>S‡0÷•ó+\æ\Ë+\æWÌ¯™I_2¾eqVWÌ¦*\Êù”ó+\æRVù”””ó)+\æSÌ¯™YL\İ&Ÿx‘ñ¨ˆ\'\Æ\ß3W\á›ó\èˆ\Ö\â|Ï”¯˜{\Âı\à`\à5†òú—…\×oˆ(©yl…\åñ\ì^¬cÁ/-r™XT\'<T5Z(\Ã¥\â9\"\Ó\'Y2£õ}3ª¡–T3¦U+Y\ĞZª\á×øm‚.º÷š—{\Âu($4Ch9¼@ê¡š†5ƒ\Çù3\Ëü\çû\ë¥\Ñi\Ò0R#\ì¼\Êÿ\0\Ï+%]Ã‡ó\Ï\è(–!xÿ\0øµ=T7$¢!Š\Â{b\Ô_2\İ\Æ*µ\'\í-\ï\r~‚Š£¢t˜©üË„?fKóS_g¦\0<D±_Šp`X\ß†/xóôW®«ú•\Õe\å‘G6°Yñ6#³\Ú\\\Û~Z´M»b\ÔmšX]ˆ\Ã~xú(\n+ƒ.	^	pê¿¢gˆseg“\Z€A¼®}\Í\Û\ã¤+\Ä\\|Ñƒt|³\Ù=ó\Ù=“\Û=\Ó\İ<öBAó$¬§™IH²\å\Ë%Ë—\\¹sR\Ï0jjÁŠR%¨¼}ı¥™S^ÿ\0\02\åN0Zğ@\ÅgslôC4ü«;¢.	oD@\n0pV/]\Ëë¾—\ny\æğNx\âHZ‡i\åp†±M¾ó\Óü±#Wøcş½?©\'ô“{üDşª]õ\Ñÿ\0Aô~bzø?ôa\à1ğ¿˜y)\ïüº +1\âƒ9\íB’œ`8*¬¶ï‡º]9E l\n4\å<\äğ>ğ¶h«\İB0!\nh\Ö[\âvş\ĞHO|P€\éM\æ#4ó	\æC\Í4ô±}	\é\ÏGñ·ˆ@t|Öš¼ö`yg\Ë>y~H¾Io”¿$¿$¿$”·”½p\Ëøc¯~“„\à\Ë\Í\n|9<a¸Ç˜\á\Â7¨Ç¡Aô\ÌyŒ5p–zqµ€œ[‡\Ä[Ãµû›\èD@Zkøk\Ë\í5\Ã\Ïd„\0\ÂÄ¹T/İ¢kyµ¾“Ü ›n>\îhœR\ÈtOœÂƒ†²B^ô5sS^%\"%‰^\Ú\\/1£†g>9ş2\í\ÜÖ”ó\Æ8rñ\ÑSœgK†80AšO !\ÃJ•³\Å\íJŠ ¥¥ñ\Ò\Çw(\á ¯“œ\éGJoß¯\à€„=\ÓöÉœ\â•ÿ\0Ns0^O›\Â¶l=K\Ù\ï\æ8\âŠ*Ä¢Š¢ƒ. \à\ê\'~›\êaQfı\à\æsO\ÒO\Ö!„ra|*8eFñ\Ú9zƒ&C\è=%Á‹\ÊmpQ\áA°*ü\éÁ)£•ü6nŠZ•\Ë\ØaE­_ı¶T\Zü¢°\ÉL!C/š]¾+;x/´A¼kNûZ_¶l‡\n^ òFEG³lŠ,!2ğ`0bú/§s\\o,1\ÊrÁ¶üP\Ã‘Œp±—‹N’X²\à\Íu\Ü‰c±³d&·i€œ~©á†‚·\Ä~ù\n|	dm…À:kj\Ç\Ş\Í:6Ápwò\Ô[1¶®¿É‚ ‚ ‰\É\Ù£,Š.0%\Â„prD00œ\Î\İ{\ÎXs\Î\Ø9œ¸\ÏÒ†$c‰Q\Ã\×]ò@‰‹s´`½\àC*S%&H\"¼\ÍWZ\åŠm.\Ïd*p\ì°\ß\è¦P^:9OP	‚­–®\Ã´\0P|Ö–#©qTK-üµÜ(hŠ(\ãÄ \Â\Z†`‡E\êG\í7Ÿss–g,\çÅ¾\Ä0\Æ1\Ã9¬sp3\ÂLò\Êk\Çf \Ïv-°tóŠ˜(1+\r-\ÒP±>b\ìôX\'5;\à÷*R5;²Z©\àMû—Q/\Å\Ò\ÎH,glP\âH\ãŠ,qà¢„!}GMôó\Õu\îR—\ÅBVøÿ\0\Ô2U|Š¹O\æiÿ\0ˆEP\\ccŠ^“ ¨N´¨˜ÿ\0mŠ\×fV\ã&9\ï\Ğ\Çq5	P\ØM˜…\"W ªó\r\ÓÏ™P+\ÕM\ĞH6\0\ÇB\ËØ‰5\âW*\Å\r \Z	\á#‹ƒP\"Š%\Í\àÁ°0C¢µ\Õ\Î[\ï§>\0£\Äc‡c½fw‹\îR\ÄDu5ˆøe\ìğ\âŞ¤¸‘#{«jo\ì÷Q¤\'r\àN	mn\Ğ\ÑZ©q¤´\Õ	ÈŠ[¬1\Ë¡GPc\'Q\ÄE/7‡œ^¡\Ä2\åó\Ê:öK—!9g2?I0\Æ1\â^\n£›\É\ÏEl\ÅMb/¦}…	j.ûlB†Q=\Ò\è0Hu2™´c}	£šŒ\Z\Î\êZ\Ö÷\ÃÛ—iu\ÎmMHÁB\ã¶z`\Üb\ì¶rlˆ(¢?xB!‡rº\Í\Ë\Ï0g)¯Î‡|\å\Â~†X\Æ1\æ2\ã\Ê\è¬rt‡\Ã^ˆ5•Rº\ï³Q/80zN#*†›÷R\'ß“\Ûû“9hTZK‰9 ˜\éƒ.\çº\"5·tqbˆ1\ÇdPb„0B³ß¨\é\'y\Îi\',+øò\Æ1—\ã¶W œ9 a¥9Sr^Nô;0\ÜRhÄ õ¤SH‰@-·\âT]›DtúŒ$T\Úı\Ø#y†oP¤„5#L‰L«d1_i‹ƒi‘Á†\Ã–\í\Ò1:0\ä†;\åd}¢[¸Ç¡Ã‡\è=aˆjJCğ`¡I+v\Î¤\ÂK‰R\Ñ\ï Rü7\ŞRm›\ìF\ê^O\Zø‹^g‰ir\ë²\0Ğ¢\r¸\r=£Wvfâ†£yTX\ÅQG³P„2u[8‹0Ê¨òp}\ã¸ S„0Î¿\Zoñt\n1\ï\å2£\å•\ÖB\r·û‚¤¦°a\\¤¼M1hR1ŒC C\nj°eW°\ÎZ(€p­z>\á‡\Ïiu8\Ä8\ZŒÃ‡\"¥5­‡\ÄBzŠ¢\è\èW\ÑX±\n\áxC\èt%©Â¯µ\î^+5ù`oyOØŸ B<G1cxzG¨„/Q>üÁ]W…q\áÂ’!	¬VL¤0\Z´»ˆSó®\ŞYX½Z\ËnƒGeñÁ\îpR\n\ì\Ü\í&ˆ/\Ä	#\ä0wE\â\\\ÈBº\Ô\ÚU)\Ñm<!N/ó/bZJY\Şkò!\Şoy\ÏÚœÎƒ\Ìc\Æş™‚	Eò¥v•\ÖK–\r\ËÁ¢i‰\ÑL£‹‡e °še\Èhm\îú%O,,óQ\ä`\ê\ÑE§bP€¥H„-\Z•r\ê“s0Gt°ø\Ã\Æ\'‘E\Ò\Äu#‚mÇ²\Ò\ÓğÁ«À¼V.¾wBNù_½\á…N\ĞG˜\Æ1\éztyİºy\Å\ÆvÙ„D”\Ë0!9„‡I#<YCoQFùT €>X«pº–r„\'C%\î\Ş\àS¦£(;\Å‰‚0!*v†*\Üj\Ã¸lj(ùcñûÿ\0‡¢©ı¡\Ü÷C¿”ı(dó<\Æ9cô¬F[ï°€C“7‹¨\ã\Ì\á\Ùı\Ä¤er\ÚÀ0\è%\0\Ç¦W¤_]™|ƒ\È\ä\×Ûˆjy‡”Mö†\Ùie\á\\O„°¯œCa^\ÜÁ¥ñP­·[8W*`‚\Å\ë%F_C‚JIÙˆZ\Ö\ä9V}ú\Z\Ïhº>g\é\ÎÓ´µG˜Å#¸IXa\Ğ%«\ÉD¼ƒ\è÷­ô(Ÿ˜\èJ¨\Ã,À1²`½K(¡\à@\í…\ÊKğ/™l6\å\ë\0ksi‚]¤üBöÁi{\Ô}\Ùua¹\Õ/,@F°÷\ÅÁjGN¹KÀ½²\\\î(š:ù„\\©\Û.X‘ŠD\á¡\Å\Æ\èVû\Ç?\ÖCP`‡)\Ç\ï?^°c/\Ö•\å¶5\Ø\Z•ô\Éu¢S\Ïq\êr2\Å?r \ë7HØ»l>\Ù{c\ÍhŒ)gL.!‹\Â,¢ôó{ó\n!¿\ZüM\Ê%™ø–°\Ú\×`B%8\rAÁx®Ù¬0G\ÌZØ‡\ÒG\åb°o\Ù\Æ_A\ZşNUX<\Äc\Çzj¨@Kp\èÔ­q¤\âğ5/D8ó^Ut$3U\é\æšÓ§x,\ÑL@,¢·ƒXc–\Òl.ùû²\ÙßŠÀ%è¢—\Ñ×‚¬¿@¡ü¡ &º=„o*Ì ö¶j,L\Ë\'‹-\ßIúƒ˜v\"|„\r}:\éUc\ßr,¶\á8cÉ‘r63kaC\Ì\\\\2\à¾x…\n¯w\Ä{û\ç ‹\r\å\Äx§½5«Â¸H %u½HM3š¦Ÿ†0&\ĞD9t6¤\æˆÁ\ÊıG1ú0Œpc<E\Ã\Òd?K\Ô¬T©Q3Y®”Œr†\"÷\"¹\â`•–»$)e\×–oD\ê^0z\\Ä”W\ËA/WËƒ\à†ş\Ì;\î<\Âg0”¸\ÅO@$ C)\âº\\Ü½¦.–¥gœ\äGFôœ‡Á‚p›O?\Ô0\àá‹‡¢±RÁÉ\ZÊ—\Î\nÃ–=\0tVU2½1Àü‘jW„r’§\ê-4\Ür±Z_À¨wm4©\íÁ¢ÿ\0d¢„\ã\Ô25Ñ‰	Û§·Y\Õ?<&F\Éÿ\0{\Ëö’–ú`œ\'òD³\'h\àËŒc—\è\\P‡¥\ê¸eœ#	\×r\0\çK%›ºlB‹$\èU§;\Ğ@o\âq€\n8%Gƒ\Ä+\Û	 ÀŠ\Ü	P\Åeú<§ıo,ı<¯\Ûg‹~™#ÇŒ8¦1¢z©@ºöšV5Ó¼Z(A–2\ÍA\ìı+0,0Œ\ìak¯BQÀ@ a †iŠ°	R±Xr)i¡É\ÙF7ğ¢*ÿ\0›e‘şš\à\Îi\ÂôB1#\Çr\á\êj\Å\È<7©\Ì-$‡+˜\Z<Á¼Ô¬¹q„”\ÏhDVpÁcT¨®—(\ëet˜LF\ãCMl:ƒ°¨\àğ3Åœ;\æºŒj=¤n¯¬ÁÑ¬>i\à\ÇQk†D\îI`„°\ïqµ„Še\"\0÷\ço¸<©¶Cÿ\0\Åõ9\ï‡+6\Ñ³~È¡Ğ“:‡<\Ú\\£\Üw\Òôœ+½Ê—U\àX%2ó´—5ŒJbİ°\í‰ƒ}fmX‘]v\ã§29“\á.V†¶\Ğ.MJ\ê:»\Ç7\ÑQ0ôÿ\0GòJ¯ÿ\0U\Ñ\Ân\ØDpµ\Æ1‹§§\áXÊ¼À\×UeWV³Bw&„p¡O©ù\'ˆ .\ç2úN„\İ\Ò3\äSk„\"óGEu\×Aô^¥\èRŸwùJ©ÿ\0U\Ñß”\Î#\Ë&.n\åğä„§)©ƒ¤\ÉxI.\Ş\à¼\ÅR†LªMİ ]\Ë3Q\êAš>ŒV›\\2\ÆH~/Y\Òıns\ÆñúZ!Ç„r&<t~<N\İ‡¥’›P\é¬¨®u.L;¼ÃƒJ<‘U«`€`ı zgŸ®%Ÿ z\ÉWy®†^\\v†~¼\İğ>\Î#1O&‚\âN\n½7Q¯b\æÂ‰HD›¸·ñ\ß\Ğ\ÖU@“‹G\ÌA\ç>@\ËÀı;ú­\Ö^si™ÿ\0]\Ã;F<`\Çpõ J;(J\ëû\æi<\r@°b!ƒ€³±)\'7Û§\Ä.hVu‡¥aˆF™j®2,z/}w\Ğô\ŞXõs‡òâ´®±Óˆ\ËNQ\á\ê!7Qªc¶+s’^!¸:„:Q^R\Ş+t\ÎE¼_\Ğ\ï\Í.·\ä‹Ã²¤…`\éqPú©\Îù“hğNx¿\Ï#\Ô\Îñ\ê0¬\È\ÆW€Ü¤)Êœia’0„\Ğwqn\Ø`u\"\Ñ;\Í\\A­\âñ}]ó@\×]\Ë\ï\ë\Ü%qˆB{\Â`Ë†.D\å\èr\Ëúe_&o9Á9Áøc\Û\å;F81Œgl1\ËE;\0A|ÄšE%\ØÇ’×¢Y‰\ns}-‹\Éo‹P¼²É¼(MP5±¬Å‰+®Û´$Œ:\ÜÙ©¬ 6TopÁU«“—¡L¢[C8®«MtWĞ¬¶ù±\ÛI2÷‚©D6F81½!-÷Ú±x)C\å\ÄxU;\ë\ì\\Iø†ƒ´—+O©kD³œZl\èCˆñ½)+>- \Ù/¦\â\r2\Æ!!E¬\á…T\ÓÀ›„K¨\ï=°uñ\ÑQ„ ¿¦ÿ\09\ç\áŠÍ„pyŒp\ÇFs‚R]\ÛeV\ÇiŞŒüˆò€iP\ÜZ~%:M\ã\Ôr¾ğ)4¥|À\\¬¢8\Ûa\Ğ;{bùPn*g	K‡o…NÄ¹¸İº˜ c•¡l\Òq\Õ\Úß†RÔ¥Y~T\ZÙ»\íğ0\æ»\ÕöbiŠ\ZW[7\ÒÃ¦°ô\Ö9F¾\ê+‹–yÀı˜*F,Á†8L0Á\ãõ¤¦d»±©\æZ|6vÈ¯§\é|±\è\Ê”7¿>0N&ƒ\Û½¥°´y\Ë\Ä\"†%\r\Ñ.„X•\áqµO‹µi´¬u\Û ¢o\éö‹†$KÛ´l\æJ\àú\ÏWht\ŞıW\ëQ\å\Ï)ú±E\Ú9±»¼¯\å\0õ8ò<4O.PXs4\ï\Ë\Ô\'¾\ç¥»f&¬´zR\ÃşB\Å\î­lF;e—\âl‹8bóø\î#¾—®¨%©ùg‰\ã\Ï\Ô|1Ÿ³\à\äei¹L¦¥tDz;Nÿ\0EŒÓšÈ±›ü¿\Îra˜ü8nÑŒŒ¢<\Æ3¿A	~¥õC\ne»¶ì¬°) €*…4\İS\È(	]B\ÚGv%u€\0\'|±“µ˜Ô¤5tpC\æc\Ì.4‚ÙºFf`0yõ4ö‘2…?Àˆ[¶R]CX1SLú}\ãô\Äı¯\ç9gœıX§Q\Ék\ã$xÃ’!~m2Kğ\ë\í^ø\Ö!t·\Ü\ÇqNÁ\Ú=k„s¡ò\ê£\Ä6Ã¨uT	\âkıŒx\ë\0t­1ô!§=ñ\àC\Í\Ê\à·t—F\ËvS‚Z\Ì¡\İ\"ª[\ÔR¼0Q\n|~b=Ì‡•\èœıé†²§‡Iô™M•“\á±\"ğQ\Ê¼\å?F8ûG˜\ÎF \à:\ÒR½ašU %‘K\åÏ²W³mhb¨-!w´h°\ïƒS7´À(\êf»Yñ„­\"\ëpo\0y{úa°«±\Ìƒj–«\ÚmIh{\Ë@7\ç\àFu+\Ö=ñ§`7\Ñ_A\ë\\³·\Ğ:ÿ\0\áÜµ³\Ê\ÅÑ§\'¨„@¥\ÅÜ¼›y\êö^µzEÊ”* *W½\ËnÑ“€ t†\àe \ß=ÀJ%BwŒ°\ï\à7D‰Px\ä{\É]\n\\;ü\ë\Â\é•n\Ã\ç\Ôd\Ôş ş	\\Gg\ß\ĞÜ¸K\íõ.9a‡Ç\çœ\ÜòŸ¡†\í6\Æ,©X`@\é¡,`Â)\ÌM\Æ\r%˜¨hi]â®¨jW\0:9o\Ê„\Í\åM“ª†(\é\n\àT\à\Z!\ã… \íğ_i§iD\0:°V\ÆZ n\ç\ÚÀ\"k¾¼‘sk\ÅñH²@Ôˆõà©º¸x†*\á\Çÿ\0\rtT:^–\Íır\æ\Ë`ş)Åƒˆk#\Ç\èTûf\Ç6E ½’z]·iXµ³ÈµyV˜W0Nğ–v\rAU†@\è¼M\n˜z‚\ïb ÷A¦7˜\êJ§¼;@Z\Ú65ş®\n­ò4ª)ª\Ì{Ö»vQº”JÁ¤ğ†Á\Åô\Ôa\Ñ_F¾ƒ\Õ\Î1ƒÉsõ§\ìÃ‚V£‹»‰\Ğ\äK \áT§t¤­B@Ÿ{\í5`B©}w÷8­?ˆbƒª\âD\İ\ÔŠ\äc\ìá¼¼>£‰\\D\0\Ù÷?R):šS³k\äG@´E¥v\Ê0\Ó\íô5\Öt3œ\àø/Sõ£Á¨Ã¼‰ñ—øFœ\n	Û¨•j†G`OPj!\åÿ\0g÷\ã\äµ…\É\ÈÕ¨x–¾‘ƒ­`V­Q¥··˜\r<œ¼¯(\æ\ãpƒ´\ÇJr\Â`:[³³\Ğt\ßÑ½õk\Îÿ\0J\âø\Ú\'(¹\ì¨q“¾8c‡=°Z\í:KWJº³=´Áp4B@œˆv=[Xdt°%/tı]ˆ#\åo°›0\Ö\Î\Ä\0+\Ø.\Ï½‘\Ârüú@-ıhò€ãµ¾dÓ¾\ï±ğJ0 \èzFW\Ğ\í/¥\è¸ôwŒ£.:z‡õ9¡Se5‡b3LiøL\æ\ß\î?D\ßX\íe\Ì8®õ÷\í]ˆHaX%#/\Ò\í\Ü[±ö÷•y…RK†a})Ü‰€~0ò–¶\â\ÓÌš\íøCÁ\nˆ*¥fò\ãrG\é\íë¦ºk«œ½~ñ9ó\Êr|DŸ\rÃ•ŒyI\nˆctÔ¯Wi\ŞT!\Ğ\ÂB\ï[1š°\'?\×È±?·b	\0\é\r@*­\0FgO$\Îój7\ÇñœŠ®P€\n\É\Ã\Ó\rsô-Ø€V T8Ã‡¥ax\éz\\v‹‡¥o®ˆ_Gñ\Î\\œ\Ï\Ö\Ã\àÀb\Æ=ó\é\ÄO;C@t9\í(ò¿\á¯\Ä\î‚	\Èuò1;ßƒ°Jz£­$0u\Ø\æ£n\ĞP8²&\éQeü/QN˜\\\'+•`ÿ\0‡™¨Ğ’6…ü°½ˆ£#;õ\n$²1{—\ĞıjúÍ‡\ßE9ƒñ@\ÖC9\Æ1\ã;\ÇöM%«:Õ¾Y\ìS’k÷¿¿Á\Ø ©\ß&\ÆÂ®¬º;‚\Ê%\Øğ=Ø–\Ù\ß\Èøe`¡!\å¯½B¼„5KO\æD\å¤g…>2G!{\åÖ¾\Èñ\ß\è~£™X¬¹¹Û¦ñy\×Xtwó#Ë“™·Á5ø )“”X±IbW\à—\ÒD?gX¶³œ\æ\ÚüŒCöNÁƒ,I\æ1„\ÍWv\ßU;\ç›X@;\Ô=vóbÇ³Ó²9\Ø÷\0–`l\Ë\Ñ}GW\âP1Œ:\Ïş0õ8±\×\ä\É9¦¿\àŒ\î=\ãxpâ± úJG®Š\è\ÜJkãƒ¹NÇ™øÀx• •\ÑAl}H‚\á¯\Î8\àxG\ß\Ú$òµé…•X–^‚¥[›ı‘“~\\\'`¾\è³w¸\Û\æPADl‰b<e\ëï”–C¿ªıF9z	†6Ÿ¥/H™ãŸQ9d¼\Î\ĞT\Æi‡¾\"!.P‚z\03R<Á”,\åUº;-\Ø\ì\ç%\0ºó$®İ£\íÌ¢¾“\ë¦R\nU\î;\ÅU·t\äş\Ê*T5øÁŒ\ï½`\ç\ç$¼w—\Ñ]w\Ğ\ßA“-á¥Ÿ½‚“\âh¾Á#—\0½Î§uÔš\ècLW¡\ÍÄŠ\ìthz›KşxÁ•ğ+~OQ	 ¤07\r?3dAMÛ°wœ\í_\0õ\îUZÁR°T³’w\ê¹Û¢\åÉ“Œ?ı{f&¾W9\"¯µœQŒ\åõ\Ô’½\êzûa\"\îZÅ·[3T1\Ğö`\ÙxÀ\ÚHÈ¨ˆM\ŞÃ˜ƒh;\Ã{\æ«ÿ\0²¾Ğ¤f\ì\Òaö\à\Ã£Û£¶o¦ğJ\Ç8¬¼©û/E¯5‡w\Ğ\Z\ë¸]\É\0ñ \Îør\Åş\àÃ€Ã™y\Ô+ºa¼C£u\ê\â¡piUĞšzB“b†™ØÁU;ÿ\0\Å\Ã´–ñ‚s©xÿ\0µy~Ù¨\ê\ï>!\Î+¥»\ë³\í——ÿ\0\'~šÇ…\æ¸\è\åš7\ÌZ\Ç+=¤QmyP\Å\Ç\è=1¼@^!ø\å–~«\îlsKB9£¿&û\'uÿ\0‚ª\Ò){ƒİœ~\Óı\à†\ép,I©y5\Ñ\ævú,Tø:Ş§ÿ\0…œ¦¾È\Î\è\Ù\Í>\î#•\Ë¨ò\å	}n\è@\Ù\Ô\ßR‰B-§²\r!ò=\Ï\Éj?\ê†Hÿ\0J`½œ»wÿ\0\Ø\0ÔªS“\íC†~†‚»\Ï=w“Gˆ\ç\îº9\æŸ$\Ü\Æ,^ù\í\ÑKv}k\Zª\0Z±\Ô´yUO>Q(%¢h\î«\Ä\Ş?}±ŞŠ¿\ÖHjTSï²¬\Î\Âlÿ\0x4”„C\è\r_ˆHLŸH\Ú%”ñÿ\0\Êô¸¬V:÷K÷]°‹‚0A\áÊ€¬ö$ˆ2u=\ëø`ğ	¼\â\rhØ«sÜK,ae‘u—#”Zÿ\0ò²¦÷“\Ö÷J\ÑkŸeÿ\0ö‡¸:^†*|<tz»Cg‡:Î£\è¾¢ù\åt<¦²~¤r1Ã“š[^`}+\Íw(%Cjº\Öö<KABº-\æÚŠ¯h\å5|\Æ{W\Ûÿ\0˜@\Ô1k˜±xz\Óñ†¿ ,³´V0\á\è\ïô®p\ÎSõò£\ÓF¾(\årsR<¥}SÒ¨X5£\Âş\Çivn¯\äô\Æ;€\Ú\rÔ»„Ú‹C\Êx”’¢\é;¿\Ü7jÿ\0\ãÊ€pK=)ª\Ã Û—÷‚¡‘±ŸN±Q\";vÉÿ\0A\â4~°ı¦²uóÿ\0+¡w\Ía cxs^qƒŒ¦^ŠÚœ\ís \íj-]Àmº\ï¨‡Cd—¸]µ¿ô#ıWpq‹ş×©L.Sùx¯˜X\ÖÖ›ş\ĞiŒ%Ei\ç\í\Ö\ßG\î—}/Q \Ë\ê%\åÁô5\Õf9EO\ä¿S_Ÿ \ç5Y\'ØA‘P¾\"ûY©C©#@$I\Î?(E8/cš\0¯ŸqPzş—`µÿ\0_T&\0X.\Ş+\ær…o±şğŠ\Ô b¡ªz¤n\Ş!‡\é‹\'\ZŒ>•\Êú½ğsÿ\078\å4øsõ\ã\Ğ‚¼\î&\Í<C©b«®5}®xõö(‚5b¶¨\äC\ÍC€½\ë.6ª\ãV ›•)¯t?³\ìù†V¥p b\ã\Ä|N\\a ²¾b¢\×ËªÌ‹‘—\ĞÀ}\"¯úñ\Ó9&Ÿ~¬p\åôP=Ù´t=\Î\Â\0l[OpE¹œ\Ì	c\\7vÀ |!kä¡µ\Ô_f£šÿ\0W\â^¦¯e^\ìÙ¤m<¿ö5S¥—\ÔÇ¥š“\Ìa \ãEøŠÁUõ÷É\İN9GI\ë\Óø3Fô\é\0ñ¨\á<=>‰\È#E¹\ny˜¿î»³°\Ã\Ï~ø`’\ÅRª<u\\®\Ü&Ÿğ½\âø¶¾+\Ş79|ÿ\0´0•À‡Cƒdc‡~‡¥š‚\Ñ\Õ\äŒy\Ïi\Úv\Ë;&ªG	\ĞñÑ¯¥S´\ÖS\r<H	w\ÏÀŸ¤Á„Œc‚s±q*w@\ëPDˆˆ…¢C\Æve_\ÚH.\ÇõVvMW»9†¿#ÿ\0`R¨\ëf\é\ç\'SšÁ^¨H\á†w†9\Õ\Ék§x\ß\Ñ:^c9K·\ÇG~’~’1œ0\ÄÁ¿Î§\0+¡\0¬4P=w`1»\'İ‡«ª\ê,\'@_\Äñ=‹@;Ã™\\DJ¤¢\âx$Jö¿óp©\\u¸1X=N{\Ç7\âX#ôj1\ëQ›úÕ‚¤‘¿±\Ñ\Æiğ\ç\ê\"\áÀ\èTû\Î\æó§UQV-\Øm<EW\èÜ`\Õ5‡rQ;Š‰ô1<öS´D³¥ ct‰pğˆmñÈ·w\ËÑ²	:\á\ÂEK‘‡\è1\Ø}£s¿\Ğy•®_\Ò\í‘\×ü‹€Q\Ğ\â\Ï\Ò\Ï\×u“\r…Dô,±\Ê*\nvgf(ü\àz\ìùq@Š]À;\ÆÕ©´\ßö„8„O™P„2ô9t\Ü0F1Ë—Œjø:CšÈ¸V\é^“\ê\ÛPƒM\ãù§#\ÏG‹öóôÑŒ\á‡d\ÆE\Ş¼ÀµPCv€YwqO¡±Hqdk\ÏVj\ßPõ“¾)ŒJ^Ÿ\ÂB¤ªÊš>ƒ¥±\à;ÀUÀ\ïûCICKåª–¼w\Ë›³´r}3E#\Ó\Ş/\'\ÓÇŸş.-\çŒXf~ƒpŒp\î«\É\n]›j\éN\é%€°šd–;\ç\Ñ\êp#\ê\0Ÿk\ëF]Z<¦\"¹¹lG’§/\í*\Zƒ*3p\ìô˜c\Ôkª\á\éX´øc’\ëf¨\Îc\Ğ\æğºœa—7.2‚xşh?w†³6ø±0\ã\Ğ »m”]¬‚\ÜS˜ı÷|Ÿ\È2\ç\á\È\ÑûˆòI\Â{×¸mDE;ÁpU\Çgû\ÂJeJÀ\á%„09c\Ô5.†=e\ÑPÊ† Ád}¼G£],¡õ™9&‚ñü³dò#\Ì3\ÓäŸ¥‹‡\á—?„§z#8\Üò#²Cƒ’).\êº5\ß	X\Ïi˜\0¥À7¦œ»\Ş\ì\npr\0jQ+5\éL†°\ác‡¡R0s\Ğ\Æ.Xñ„¯gl®§)÷cƒ\Õ25]wü\Ü\İ_ú\"\ï¡\Ùó9~¹8\Æw—R\İyBqÁV_h\Ö!6û`v\í(Ú”¥R¨+}-°@¹Li®\Û\Ğ?\Ş\n©°\î¬!\Ä(t8t82Ç¿[\ÈÁ¹ß«¾n^!Ù†ö@ƒô\\\rKE}‹š\Â\á\Ìzÿ\0\Ö\á\ß\æ\\°Np\ĞM¾<\ÓdBñBó-\ÈH¿eZ;Œ\ä\ì6ª\î±i7ÃP\ÕH¿\ØK\â\Ö>K˜Aªù\Ö]°Ò¿v/–¸;HB¨\åŒA#\Òw!\Ğ\ÇS\Òx\éc1Á\ÙË’‡–s5q\Ş9yú\Õx\Ü8„\æ¯?\Êr½‰\Êœ\çı^1Œ\Ú\\%e§2`\Ãö\êk\×g®\ÑO\"\ÈN\×Ö…\å»bÁ[\à\ì`b£\Ô4¾a\ĞıEÁ–1Œ¾•¥\í‘\Ò\âº4\Òk\è¯\'\Ñ0¶{\'\ê?‰\Ë\ÎS†;ø1\Ê\Ä¬¢4»˜ğ÷„e•ö/$\ÛF­M.şµ¿SFù\Õ_4n#hxn\'µ %Å a[·\'©\0\Z”Aô…Œv\'he\Ë\ÑpY(\'~†1ŒrO°J˜eC\Ğl¨õ_ü/I\r\ËeõşóSxwñr>c8/ò•IbW¿\Â\Î\Øh;<?Áh\ï\0ISL¾\Çyl_—¹§ZU¾cO,´{g¯ƒ±ğAU\æ@‡K\Ç/Oœ£ÅŒ¾Q\Ò\áÃ“ \ì†S©\Çxı´rı\rtoñ\Ç\í¿‚r\Ï,_€\ä\á@r¥N‘€ªrÒŠ-ß´\Í\çLÕ¾cL‚é¬»\rü!\ÄtˆÁ\Ò\å¨\âÜœ’ğ\Ã+\ä\è\Ór\ì%\áp\Æ1\Ã\nC³\Óô˜\à\Ù(B2º¤\æñ¤›Ù©\Ë<ğ\Û\ìb`œ#¯­!%¨³V½¡\Öh\È\'1á¿´¡òI\n\rh\à\ÍQGƒ\à€\rJ%EWôLsr¥\è1Má’s\ÛHš¨ö\\“·\Ñc\n\é¬s8\Ç|’˜\àŒg\ì%\Øÿ\0Šœ±Sœ¥¢ˆOb\ám‹©^ß°\ê¾<³\æ\ÕO¾&q4K)¬³\ì|Á¬‡HÁ½\æ\åô1\Ë-A\é\Ëô\\ï•¢Á\Ş\\_I-\îÎ•\Ë\éq¸Q o©\Íô\\2B8ı¼ÿ\0¹\ârs\Î¥p\Ê.e Ø«q\0¼\ãš/\ØG(Ub· ¡\Æo¼Æ„P\"œ„‹~=H`‚ˆc\Õ=oE\áñ4>\Ã\à\éf\Ã.ş‘”»\Ú8_¤\ìc\Òx•†1\ë:x†.w‡~5\É\Ï9\Í\ZÀ®bÖŸ\'Bµa8®¯06iš67¯\í®…z>`\ÖŒ±—A‹¨bñqe\âğ\ãAüÁ\Ã,¼÷Œrª˜ectC-N\Î²÷­O˜0{c¼a;\à\è¹rğôû\Å;“s~¾N,W6)^55C¦†‡\æŒc¨}­\Ín,ü\0\Ô\\f\Ò\Ê<’ğa—\Ğ\å\Ù\É\Ìbà»—a\â\\c\î\Ò\âÅŠ	ª,¸Bp\Z§$†\\\\‰…’lB¥\Å\á!\Ó\Î€•¸_wƒ‚\Ø	IºsÁ\Ö\nJN¬Up~•­\àW•ˆ™¡O±\Ú=1\İv	K.9X\ÎH4xqr\å\ÅÃ‹\Ã;\áüL¸±c\Ô!†^ò‘ƒ¼p\ÍDÀCH¾8!w‹3¾vxƒ©\ï,z·c…Kbdÿ\0q—t¦\ÙYYº\Z¥OÔ§W1²N¶V ×¤\ĞEú|ş‚m\ì!\ãk†©ğ…¸&İ™~˜¾˜¾¢w°f\Äş	”\ÉH\Åg\Â0Ÿ¼ñ‚;;\Ü:\Üˆ™X@ä–\'›–{\'º ƒc\æ\ìZ¹’HHóJ$`@}\â‡1³œ&\äDH12³Œv„„¬L¬L¤¬¤¬«+++*\ÊKy—ó‹ÿ\0R ¼´\n\Z)-qüg§ø\Íß\Æ)\é.`ô\Ñş¾<\×?\\\Çm€ó Sì–¬\ÅRi;D“\Õıª\rzk¶*Gk¿6*\"(t8\ï`)+ÀD‡»/`Z\ëñ	¼•F›c¬ \ä¥­—º:”£\åW;Xöu£§\áU‡¨ˆ…\é\Ü\â\ZŠYd>ÁŒ[G€\Ş\ì>quq£²\\8IİŠ8\á‚º \å\ĞB\ãe\rƒ–^£™ã‘š>l «§w\0¶—G\ZF\ÛÔ´R·û\îªn\Øû\È°\r÷š%\Ä\r¼<±%¯›xŠ-\r\Ú]¨/œöx€§º\Ûb‹\\µ,\r^Œª;¥?R¯\Ì\Ğ\ßÀ|W¤\àñ\æô\é\ì=¹\èù\Â\Ë\ç—1^Ÿú9‰Ux#‡÷B\Ò\ÓZvB­7óy\ë}Àz\å‡Sˆs^\ê?\Â&¦\Ñ6\æ\r\Û|[\ì$ş\ÒÕ¾?ñ|”¿„ONÔ®O\Ú%\0:h\ÙüE¤½G]ø€4½P¥\Ï^)G°\à”–\Ğh\èh’!µ`B“‰9{\Ès×¾Ptr­o²	b•&ø`J÷	\êŠò\à\ËC¨ñ6\êK\ã¼@§;s;O\Ú9€\×q`\ÕL7\Û\Ä4ø¯ˆ}²ø#»°¨\Ë\Í>\Ô\Û\áŸ@ˆ0\Ñ\à±~t­4@«€ı´š¨zıÁ\×t1Z+„a¥Ápñ‡.\ë\ÇhEl­+–$‹ˆ\×,QÉ \Òª½v{\ÂZ#\ãº…J‡˜\îı\Z\í%¬¯zGËµ¿0ô]«} 3Mq\Ç6\nSL|°8¹\Ø=¥—˜øø\Å\ÅVhK\İ%\Å!µò\'‹i\Ç,¢ |€k±(Kš\ã1\Í\n\ÚòqŠƒ\Ç0k­\Î\â\èÿ\0\æ\rQk<TW3tª‘.\îN\ÑsR«\İ\ê\Z\r\0\ãp;y®a\Z°ÁÕ–i\à5‹ˆX\ÂGzşRª+Ã¨(U¯\ÎvC]^\Èó´pHnªª¸©O\â_©ø“¹c‹U*®ì’³Á\É³ù‰Diñ\âm\Ëğkˆ°µøf\Ğ7^\é\Äq}~I*¥¿±\\t¸q\Ì\Úf¾\İ\Ø\'*€$po\í\äŠŸ\naLn³Qm±i®¾[@\ë\İ\ïöp{¤·U¡¿\Ä-öŠÈ«•{¨Ğ±¾\Ì¥Šùqo½ \"°·\Ş9\Z`šil&üs+\rˆn©¾\çh6bÀ»\Ô)¯W[ó4¢B¹rsNNcI\ï#d¤¬7	qe‘b™\×À–,¹¬y1—‡Rƒ€µ¾\ÄFò8«G\ï‡gYBK\ÛD <ƒP‚«\íe\Ï3£}ƒ˜±)•\Èğ\âi¹16/ğqp\Ğ5³^N\ÛSÀ‡¡G…œAš²[m±c‰•©n\ìi¼/„FPhœL¬7•A¿†\\¼±BŠn°\"¨°\r\Õö+7mCĞ‚­Yq¹gZ\\·£š\Åi<MKa´µYA°uİ¨3€:W•b÷œ¨\î±X#µTU)e6øJ«\ßbo×”\Z€l0\å\0{%é¨§°Gs¤\Ø\Ñ\æ\ÜEÄ²\'j\ï¶<L\ï©\Ïa\'ap\ĞZUo\Ë*Æ€\r\ÏpPIä–—nj¦ª\\3g¹\áF\å¥RYb?†#V\ïD©©>P‡>.k\Ó{§¹\Ì2%VÊˆ\æ¬,[9\È ®¦ğ«*•ñGÁv@z,¹r\å±~9÷5ğ¼O|Z\â‡Ia‹#c\İoOE\Å\Ã¶¯/\æl+¢\ß‹-–±{‡z\İ[\æ\\X2\Ê\Ì1¬8z\îùspOÔ¨¥^\Ä\'ŠU­KŠE¹N4Úª\Ó\Ù\í4yœb ı\åó\ÂL 0¸$\r;\0K\Å\Õ`”ü=%\ç‡ö–K*\èJ ÁAœ&ü\ÙPXV»V\\¼_C <Qû\0¼š>\è\ÔY\ÙZnèƒ¯3@P£ƒˆ;–D)*ø!b\Ì¨{¹qIK@Š\Å\îm¢µ’Àò<0\É@”$P.».\ë\Õ\â\åT\"[v‹™-n@$¼{I#¾\Zı	r\à±\ìO2B\"\"S\Äˆ?f<;†\n»\É\ì\ÊRû‡5\íwŒ¹›ó76Kf\Ü^—._2órñrÈ‰DdÀD¹qeËƒ,–y\è²\ê\È|\ãp†\Ó”\Ë\Å\ËKK@”\Êe 2Ò™L´©L¦S--,@››Œ8gıóÍŒ¹¶.Şª\åA¢”£„C½/}¡%LÖ\à?$_<,s’r>\Ñ\"\ÔzŒøG\Ä\'ô3ú8»x•±\ï\r\ëøŒ[ş¹\'\Ş(ñ\Ï\ë\Ì;\ŞüR£aó‘Sµ\ÚüB\èƒ\ÊÀHi¼MÔŠª¿\â€rŸxÿ\0µ\Ï\Ù0\Íõø\'Y\â&\å\ï\âjKı\Ï\â{ß‰µÀ=\"aı9CıR¼q\ßR\ÆMÎ£ü¬\æü0«Šb{L½”?\ícû”{Ÿ?¶\Ã?º‡ınTŸ\áğü#Ø“Ù\ßRö¤öp[\Ï[÷\'ödşÄŸØ“\Ìr$\É\Âƒ\Ü\'ô\Êş\Ä;\×\í\Ïuû€§“}ÿ\0æ‡…ù‡\é@¡V¥°@\ÕYX]	öwR„\åŸx‘A\ÇxSµ„u\ìù–\É\æ¤\×uv\Õ_¶^\î\íQ¨\Ş\Ô\×bj¸\Ìÿ\0ƒ\ãù¬{/ò Ü‡\İ\æ\Ä\íMñ\0»\ß*nÿ\0\ß@^\Ä\Ï7\çcû4ş\ÒQşH¿Ÿ\Ş\ÇıŒş\Îx>u\î\æ\nE?˜‡ü\çöP^rqmØŸôó?	ıR\é“û2\ÒOú	WøIıZO\Äo\'¶‹7ùqOò!ş\İ+ôO\ìS\×»ó\Ïo\ä\ç\å4\ßñgü†\Ôc\ã~4­\Ñ\Ô\Æc£fiD?+ıDO\ã,µ$ªD–©¸‹¬``-°\îø—ñ\Ğ\èfÜ“\Ã=PñO\\m\â8ø¡â¹ë¹ë¹ë¹ë¸øc\ãŒz\áâ¹gi_i\ë›ø†x F”\"D‰#\ì€ó)\æW\Ìù\Êy•ó>r\Ş`·¹h÷!½¸ckğù\åg\Ã>(øˆ¿ö¿\ê\"?\ÒJ¨‰ÿ\0A\åû<~’Tÿ\0	\çñ‘\î/ØŸ\Õú\Ä[¼»\Ì|\å<À\ä\í—¶>\Ó\ål\İ)—¾po))\æ\'Ì¬§™YY_2—Ì¯˜‡¼$\í÷”•ó\ë‰e|\â™I_2b\"|\çqƒ\å.2\æÓŒ!`\è:¾¡„1x¹y¼ó8W‹\Å\á\è\ê °´K•M4Tø\çÁ>9\é\Ã)¨‹cù)\é ”RüÀ7a=DI¤ı\\	e‰«´{ig\Å9$©\ÜW\í›9›ÀüA¬`¦şs¿\í4J´¼XG®\"4ˆr\án\ØG0€\Ø@`	$!5ôH}5\Ô\á\èw„\reD\ÈX¦Òˆ‰FfÜ‰*\0\Ú.\Ä\Ò6!7h\ØFn©\å\Ì1\\lH‡\n\Û<$²\ÖRR0…* Ä¢{ Onƒ‚†(¢rƒÁ\ÖdA€ËWôh\è\ïÒ‡h„#\ÌWv†‰©D©@ƒŠ…‡¹n\Ø‰W\ÆØ	¡CnQhxZ›­\ì;\Ìbó8cóiT¢Ê¤*\å’ü¢s´asr\ËZ\ÍD	\ßGd0\ã$a,ğKƒ\Ôg´0\å€ó‹—.^}@–z°ü\áZ\åğZvx—Š¸\ÓWpd\×Rğ†ŠÄ…UFIx.3¤÷dUT\å\Ó\Ëü˜Á ñ\æ6:x@˜ˆn)Ë‘·û–Œ‚\å…\Â!*:®%\Ô›—U\ÅD\Ô\á¡\Û+\é „>£ÿ\0-üÍ€\Å\îo\Åÿ\03„/ÿ\01\íG€/ù—\Çü¯q\ì\Ë\î[şsú¿óŸ\Õÿ\0&?óùŠºÿ\0Ÿ\Î/ı^1`ÿ\0£ÿ\0<%”ô‚\\\ÕûK\0¯¹T\0€Gx<%ş\á8§.Ë’V\Â!5õ+\èqŠUDŒgwÑ¼²ğ\Çnµ«•Û€´‡pGa\å\âSl0¯‚z§¨¹\ë%‰ê¹\ê\'§\à\'¢<P({\Ê|\Ä`\ã\æ›\Û?””\è\ì‚I0TR\åJŠœÊ…}\İP\àT¼9\çX\Æ>zGW\êFR!\Ü¹ó+q‰\\¬\'4ó„\×`¨N5¤Šu\Ë\r\çJ>ğ¸\Ê<_ò)gä¢]µ$Â¾\ã5g\æ&™\ÃPH\æn1ø„\Z‚6µ\íM! B\\ä•¼\×B}j\Ã\Ğ\é1Œ\ã—£R£ğ\å\ã‹qOOœ¢™\ÃñŸ§ü\'\ì@c9\"Ê¢C\Ìı\éÉ–wt8\æÄ•\Zí—…\Ã§@’{0 Š•*V¥J\Å8:L==²Ã \è 1}DX\Æ\'™j\ë¹qŸ¯‘Á—(…;\Ù¾œşI·Í\Çùˆf~\äuñ\á\Í\Z¿ú\Ô\â†s?z\ZƒŠ/·ˆ^+¥,Q\ŞUø}½I€À¥`1RºN£Œ\'~£¨pG¡¬q\á–\\¼?\Ã8¸½’\ÂöC_<>QŸr;²´ø\Ïú\'\îDXøÁ\Õ\\\Ürğ>ğ\äœÿ\08“¤\n|\ÉĞ«¾øJ\r\Ï)\Û\Û	$%0©R¥J•\Ğô™\ÛR\Û:×‹úl=p\Ç¬8\ã.E™\ârc¥\\\Â	t¢ne*côm¶Zb\Û\Ë†$f\Îğ,,,lSr•\0=ñ‚[”\ÅsPó¹i\áŠ\0ğ_´bªqlö\\¤©Z‚Š\è\ï‹\Å\Å\Í\ËË„%¸²\\¼v\Å\â\å\æ\åËƒ‹—ƒ.^.\\st1\Ï|\0Dä„´oº]\Ú\è\Î\å8	B†x¶1<˜\ãt{x«\Ïøÿ\0c\î£\ßüq\çıóş&=\ÃûŒR1Š\ß\ï54\îñòª\á\Äşô*€¸;\ÅË—‹dbÙ­\Ğm.úÀ\å¸`p\\—U.\\\\.\\dX0~Û„T¢…±òEÿ\0¤8²°oñ|Ocñ_\Õ\ãñDyüW‰úúL\n\Óû¢?\åKo\\KaO\è\Ø>„øP¡ñTt\ï¹\Ã~TKo\äGıšT/A\èsDş\Ù<Ÿ‘5¿Ê9ö­O\ë\Ù\ÙılKü©EJø²r\n\ç‰ı$­ÿ\0”U³\ï¨LKS­h¿\Û?°Ÿ\ÜD¹” \Ü\'Šm’@º¾ğ\íşR\êìƒ–{	\é~g”~\ä…øI\ì œ1–\îH$dÎ¼zó§L³ÁÁ²{s~\Ì>\éîš§º>H\È\Å{%\'²a¢”\"²e ;ÀF“\Ã6m)\ZD6,²\ÃR\Ğ\ï\É_Äºª0%–c¿Ì¦—±-\Ôu\"ı ¶\ë˜\îÛ°j-eœ\Ã@²G]ö8/‘¶M#ql\n\"\ÒT¨%-~Œ6\ÅE\Zn¸•\"4lõ\Ü\Ü%‰IO0@(	òˆƒ\0GC’‰I\ê\"\åQ\âEXh\0G\Ã=R¸„i1NĞ‹A\n^«·¶Q¡û—\Z\Î;Eö¾\Ğ©X¶D(©J\ÓD\nò¶ğ=Qa;»’ø\\ˆl<¶\å\'¸gº®^\Êû.‰è¦ y Ë´û\Â!¯ß”ù¥}\Äù`›o\Ã+)¡{’¬\åò•+ƒ*\ï-\æ4#MX|\Ô.¼i¥A{üJ¶Œ\ßA\êw&ˆÌ¨”‹ù`t_|HÃ€\êRD@\ïv‚!;.C©{¥\ÅT¥­Tc\Î!A\×yE!;Š—\ŞÑ¾W[ŠªÄ¡oGhù!z…¥¯˜Àu*\ZµŒJŠ{Oz#³ö¹ÿ\0ˆª1„\ìV,Õ”\ÛG3\Û¬<> @µ®b8Hó\İl\ÕTö\Ê]5\ì\åŒT÷\Í\\\å\Z\çl×š©şX\\²³N\ŞöCm9›Eş?üdôC\×\×ø Qa)@\ï\â[kğ*hò}\ÅsbÉ…e»\å÷Mû/\Ê{`\í\áh\ï=²„·l›¯PwT6rv¾!£\ävDnªnzŠw*+­\îD–\r×ºş\0\Êôˆ—y@3\á\n\İh0iz0¡B¾.¡®\áÕ«3H\ÔI}„š\ÓV—\áò\Ü\îª,µ‘\Ãc±)÷†“6RÏ¼n*K\éû\ÆÅ»b;:`\Ø}¡8I	G#]«ğ\Â\Ş\â†©ñ­\Â\Ö<(_ğ¹_¨7…„¬dGš€Sr\Z?ğ\"­;ñ”ƒ\ç	cóbB\ëmJ:u¯\ÔjR‰\Îp|\ìªT¢!°*4\İX\n€)p\à=óT¬õp¨2Wºp\ãDD\×\Ìc/\rMù@ h[\ã|\Ë\Ş5™ø!\ÆFj¥©u\ì–9PU\0\å`€ˆj)³£#fò\Í.5Š#Ì³¹¨’¦£SXk\Z…B­\æP/+	c\ÂjrN%M&\Ïõ=Zª8\à\ÃÇ˜\ÈNZHM.¬÷7/‚v—sK¢h«ˆuK®\àN\Ét\ái†\Ê\ì \Ê!SÀqiò\ê÷Ö©j\á\îÆ³\ãp\'—yN\Ñ\Ü\í\ĞË¥.\ÛX:\Æ@]/eá¬²¸\çM\ê\àjD4cÍ“±†=\"\Ò\Òñ|XõB±òNÁ/!AA\Ë\ê±€,¼\0\n\Â,¸÷w\Ç-+ˆ@\èº@»ğ`I\èËŒ\ìó\íRñQ\î\â\ÓÄ°\Ü\nE§\Ş »¬5\êwgõ\î„!.ûûÆ°\î\ËNa\Şn t:_\Ä\Ö\Z=¬uP\ë³e7\Ç/ˆq•WO»ø\Äuc\ØÊŒ¸\n*®PıD‹»\Ûÿ\0r\ÊE\Å)µˆ(3^$+/™h\Ğ\İ±¾$ü–e@\r\î\ê\à\Ú\áZ–\Ü\â(üQŸm˜1|ª,L\0µ?%\\÷ñ>Pf´œ5»øƒq$º…ˆrsw«ù†\ÃMÚ›\ër\×=üA·“p%VÁMö%Ex³÷„46Nñ\Û\ØA\ß)?Lôh8—P5Óò¦iLZYÁf\Î<Å­’œ:^`B‘÷\æUÎªs\Ş5ø\íR·(l\í¸ñtQ\æ\çw±\İ\ÛÌ¡\âø´(•\Åû±ºŸ˜9ñ5ˆ7(=R\İ\Ö\Í\Ô4<<\ß7?|öŒ›\É\ÃB€s\âw\Ş\Z‹·ß¹õ”\í\Ã\Ø1¡S>ğğ=\îs\à\Ï}0ğ¥oi$rŠW\Ä\ïY\éü\ä¡{%·\r‡Š”•*Z\'\Úq×´»”T¤a<S’‰|CVAîªØ¯Üƒ *Gˆ\n±~ \ê-NÏ”‚\ÇqUÁx¯R\ãÍ¯‰q\rªfƒ/Q¨G\Ú\\Ô‹Uİ©ró¸\0º\æ2*«ğÀRQ\0q©q4ù\Ø(\ËH]jûÍ–o\İühÈ·A\0bxE½!\âU§\Â;D¾)t D\äNe,’Şƒı‹Óšk\Ú16)¨¿óG°‘fÓ–B®RÍœ\Ú1´ÿ\0lJ\Çû\â,¥\É>(\íÃŸ\ì…{o´3q¯ı%\0/óºÿ\0rü¨¢\ÏôDiNo\Ô\Ò,\Ü\Ùü‘ô¾5I*#z%Aÿ\02sV¡‹½N\Ï\ÌEüIA\Z©\äˆ=õT\Ø\Ü–Ewñÿ\0²2Ü´ß°£·½¥ø!;y/Á>ù¿™ğ÷~\ÉO\n£R½ƒ,ùÒ³S\Ïé„¶{ \í\íµß¸’\ÃTı\ê\İ\Ğó\æ\\n\ãc÷9÷\ìD¬·r÷\á„\îûºÇ\İ^{¬©J€_™Ä—pğÀP¥#^1j‹»ğD.ˆÖ²ºu¿‘b €\æ{²¾\ç\röb‘\ç<x„ 4]÷r·\à1JÑ¼»\æ#I\Ğy\î¼À0·\Ì*ó¸ ôh¹\Ï`\âQ\Z\Úš…*7\n\r6\Ş\à!¯¿\Â\Ã\É\0\ÇD¥o\"\Ü;\ìC\ÖA»¥­òÏºeÛŠS]Mù\0\ÚPt½\î\Ä\'\Ìo\íª	ßµ¹Ga?!rÖ\"›x©Ø¸\Z‚q•)\âE…\Şa&ÿ\0x\åSÿ\0¤n<rÀ\0\Ô(€Tv•\èI\ã\\¸Š\ß\Æı\ß}\ãg›÷C\ß~\ÈV¦Uğ»\Ãñ\ë—óø®SŸË»KW~o—3y¿uÛ™­Z®¶\ï\nr‹\Z\â®\\x‹\ßp?\ïy\Ñ|’\Æ/Ì¥(\ê\Ó\å§HŠ²¶ßˆ®\ÆÈ¿	¶ÿ\0\Èy†¿M÷gµº\ß;O\Èx‹	\È\à—–M;7Qº\Ûi÷\á\âû|ÀZ-]}\åuF‹³‡´\å)ßƒˆ¥\Ún‡„±TmG$¡\ïö9óªZzYÅ§H8\Ğ\Î\'\Âõ\âY±\È°—)¢ûIÁ\Ïı®‚\éS\ÒòÀ‚—B\Z\ày…4(ÿ\0\â^\ä-v8\"\í\ÖĞº\ç²XÚ¾?\ÊWH\ÊC]\Şò€¡­q|Áƒ‹?x_´\í\â|4½}‘j÷®\ä‡oò†·kV¾\æT\Å\rvb¥V¦\0 :\ìEKai\ä€»o0%`±\åÑ COxÜ¯´¼G‚»]»ó\Ú%»\ß~`\ÄMo»–\r\\÷„yáŠ£Z{ø&\é\ãøB•;\n\ç’\06G\ß\Ë\n•¦û½\àV50[\Ş-;óñKD!µª¡m\íÿ\0m€S\Óo/\Ú\\6²4\Ğ\Ô;WrP­V“sòM@EQ,\Ğ; \í;Ëƒ¼P\â\êg¬x\Ë\Ô\Æ\ã›ú¦\êk¬8\ã©¼§Et‘ˆ«|`B\è´\ß=\ã?q¤\ç\ãš\Ë5ò¹%­C†3\\\îªõ\Ö;u?Fğt°\\\ÔrUô;J\Ë\ĞË„©°9¡¢Z\âšs\ÃD¥\áQÿ\0z\'7\Æ\'c ‚9qP\é\ï\ĞÊ¿¦½/Se\Ã\ÑÁ	{N£/3¶^—\è½\rEPJs4\î\Î@\\´\'jqaûˆc”;\áğÇ„\ïô™sWşĞ‡ÿ\0\ne\Ã\Õ}+\Òõ³¼\ïUÅ½\ìÙ£ñ\nú«\éQ‹\Â\âb#§4ı(ôŒxô°\è\ï}­\Ãô\Ó>‹Ó¿¤ıøKŠn•¢¡vhpGaª´\Û\\\Ôü\Ïï¡ƒ™\Ë+xµF1¨\ãC¶_şC¨\çUG/K‡$w‡./\è¸e\íE\İhu9&•\Â:{\ÜG\æ4˜€`6šc˜‰\Ê,WK\Öô¹\íz+¦¾±\Ğô9z\Ì=o@õ˜‰D%¾*X*¡X¦|®Y†£‡\'4u¬qLY>›\Ğ\âß ôï ú‡£¶;`\ëz¯¦\â\å\Êô\\OMJ\Ë\â\ÜÙ¯\'Š—®tªŠ¤\êM&0s9\åk8p\ë¡\"ğz/ÿ\0ŠºŞ¦^—¥\Ê\â\ãŠz\r]>e\Ãw7\0Cj×¨9H®\Ï2‘~ô9—¨;œ³O¹8c\ç¥\Ã\Ó}|ô»\ë~«\Ö\áó\Ú,\×]õ¿M\è´)o‘ñ+\×McE¬°\Üı‰ªù†¿$9Á\Ì\çšü\î‡8ô\î7\Ğ\Ã,2ôvé¿¦Ç¬Œ9\Çn«f\ã‹\Í\Ç7.k£´gl²\Ésx¹½©-q\Òû÷ˆ¦ôj)´P\ë\ÛOÙ‡X\Å9#ô—/K†W\ÖY\Úv\êz\ßK\Ñr\Ì\\bô3u;to&\Ğ\Õ9…\×x€.n\ÈNò	G¶Z\È\ç\æ\Æ\â‹X9bóoJC/.u\ÖÇ¡\Í}G©‹\Òó}.u‡eaz;|bğ\â¯dt\Ï\Şrb\ë&d—ñ{—ô«¨ï¢£Ö¹¾ùebşƒ\Äz\ê³q„\Ö\\2\å\Å\Å\â\æğjñq\ÅJg8«\çAP2g÷Xóirú¯=Ÿ¡}n5š¦²ÁúÑ—¤\ègh\âğ\Æ,¼w{\â±y*û\Ä\ä•K\Úp\ê\0w\Ú\\Ñ‚ŸBº¯¡è¬¹aôŞ·N‡¥wÒ±\ès\Î+©z	û\Ì;ü!9%Œğ\ÊĞmJyü\ÓJóOö¹ı¬şµ?µŸ\Ş\Ï\ïg÷sûiı\Ìş\Æsÿ\0$\Ü\Ï\ì\çöóûøöÿ\0$·ü\Óûùı\Ìş\êm÷\Ğÿ\0g5\ëóO\î\'öSûi·ÿ\0Iıôşúq÷\Óû)ı\Äş\Âs$ş\Òa?´_úCı\Ôşú?\î\'÷Sû\éı„\ÛF¯ı\'÷\Ñÿ\0q?¶Ÿ\ÙO\ì\ç÷Sû)ı”{šq?²Ÿ\İOK÷šuù§öñóCı„\î~\èÿ\0¶Ÿ\ŞO\í%\ä\'÷\Óû\ÈU¿\É?´Ÿ\Úb?°Ÿ\ØB¯ı\'÷“Áù%\ä\'wöD\è\Òû\Ï\â2NI¯ÂŠR\ì/“¼pHŠ\"\ïÌ°ô1÷\æ\'ƒ€û1DNQ¹\Ê\ßu*_\É÷‚\îaœ&&\ÅjŸdHúş\ÄGFı¡¨\×t\0k\Ç\äe­83\ï,\"Pş)\Å9»\í*46\ÑQ¡÷C\ZñGß˜@R_a9\ç\ë\nlrş\è\îÀ>©&\é&>\Å\Ï,ı¢kş.Q\ãöA> @OŸÁòş8¤½\É4\Ú6\Ã\ìˆö‡\â\n?MûJƒ\ïûÀ\Zqû`\ê©Jñ€ğ7ü#@¶\ìò\ä©ùaM>ò\ÛEP]g\â?`\Úq\âr(\îû\ÜÀ\Ôt\ì \ÃGkzoo´;“\Z8¤¨\Ônv\ÅR›Ø¶Ÿˆ…*\Ñ‚&\İH3a¶q±\Èş§ğF„À\Ğ\'\È,me\Z\Ñ\İ§MR•qU(\ì°\ä+»£F\ÅüKƒ¾%p5_¹f\ÊvK?D¦g‡|SÃ‚7Á\É<ñü\'|š%* Exqğ±]•»ñÁe(Û¯\Íó_û% \ì`s\Ç\ì%;WK}£\Ïo¸„;ZHv}\åB\Í\\ŠİûAAÊ¿™l¨ğ©÷½\Ë\Zû`6=¿X¥[³ø@)\å`¾?”t\ß$\0›Jˆ<‡ñÖ¼–Ò¿™ \İ\ÆI\Ü\â6W¼ş‚/#uVı\á@8¸G¦—¾e~#l\İ,¡]~\ßÈŒ	K‚µ\ï%:ø,\çq;_0 ‹ü¥ğ\ZwbŠ s\Ä\Úğø¼M2!P@x3ó»x\ÜUh\Øˆ\Û\İÁÀùae\àı¢Xs„¦ÁÇˆ·\Ü1}¢i—””M\"3˜U\ä\"–ü0\ÕlØ€phe\ï\É+i\È\Äm\Öİ£º,#ùŒ\ÃÁ\ZÍ‚\Ş\Ék»ó‹´\åg\r†‘\ä\àK9µ¯\r¢¾½**\çjÆ§~\"D•;Ã˜©Ş“‘\äd\æsÀ\Û\â“ü0\á\å>\Ğr¯Ì´\Z\ZO	Š\n‡8\Ù2§M„¥N	©`Z;ù¬<ü\àpN\éUò´‡\Ò@\0\Z1´r\Û\ã\r6lŒ¥P¢¶¿5°¡8Å¢\Æ£–´Na´,”GB\ÓK¡¥o”\Û\ß	\è«z/ñ\r‘Œ\014V\Ûi¼a`˜¥DkÈŸ‹•\r¨YN…+>üKÔ¤³‡\Z€½™¾¶zœ\09yÂ›•\ÓB\ÒüB¯c\Ó\Ä\0\0\â?ò\Ê&,Gwõ\ß… ^\Ã\Ä>ê»¢1F\r\ÙÃ»\n\Ó\\kn\' ğ;±±÷\n?i‚hŠ²”®µ·‚t\ï+?OĞœ³ON+­0 I[³’¥\ÍSkyV2ğ—¼}úFšŠ»VÖ–¯vº9\0zù€GD0Ç¾\ãb“;•+^ha“t±r\n4[µµù\èF ›Û¡WC\İ(¼\\e™k(Ú‹\Õ\î$\Z­Q\Ğ\Ø{°Ñª\Î60\Æ\n\à5\æ+¯¸\ZĞ¦…T¼¯\n¤Ô°;®…D·Ğ„c .\ïGl$ñ6 G[–R\ÉÍ±{º›²\è!Š²wœ£3\ì.[	aqiZgşúœ%~‚©i\àXü3h\Ğû`Àb\åı7\è_Q›\ê¸G®‡¢º;\å›\Ë!}w/\Íb\Ér\çhi±…¼“yä«¶{¢9%\í!F\Ü/\ßØ‚R\Ï\â‡@É›‘¨\ÚóÈ‹uR=8ğÌ‡\Ó\rZı¸³\àoCk^ÿ\0ñÿ\0\Ìòf—?óÿ\0\Îcİ‘1>|ùz8\Ê÷µ‡5J\Ó®\É×\ï$k\"t#6\n9ª\Zw0\íü˜§–.ùº\È>Y=–\É{dù\åî–şOù\Øy™{ \Â;ß¬{¬÷~H\Ó/ø(ÿ\0M\ã?\âOø\Ç\ÍøÆ¿ñ\è{¡\ïüg¶\\·şƒ´–T`wdn7¿\Î÷£<Yy¬´´µ\Ç\ÚZ8H³/--‘X\ŞY\ÌÅ™l\ï\ÆZ_Å²ùxô{epw\Ë\Å\â\ã¼\\\ç;ñ¾*—\Æõ/-/.\Ë\Ë\Ë2şeé–¸©x¸(\Í\å³>0Š\Ö*K„\Ö	p\ÙmòcA`\È\áj\ï„\Öo/¤¹½\çR\åË—€‹qÍ²û\Æ2ñ¨¯]Å‹./MÅ—\ÑEsy&£/s—1Üº¨¶Å„x‹9B\ê7üùå©—}yY¤\ÒËÀq–yI\ÎI^8<CSX_‰p_/E\éª‚E\Ã 6\ÍLiEí‹ƒGš¨6¹W\Ä=€Bˆ·ƒ@Sˆ\Ó\nFò\èe…©\Ën?4Jz\Ê\Ñ8Ca·±=ÀdZÁl®\Ù,Ô\ìFJ¹¨Â¶-IN\Ç‚>¨^\ÙIç‹D_p§B¿u—\ĞÅ-sr½\à\Â\ÍeE\Ü\Æp~ök7\Í\ÅX£€¼\ì\ÇbÄ”4\Â4€Œ \\œ\á@¼ñ†£\àÀ‡`b\æ·Ma¬º¼Ô¢lV\Z¦\ã¥%1€PaüõsA\0³\0‚w%u]¸§¼\n”9\ï+<`\Ã<™¨\\Bpƒ\Ä	p—ùu\0\0\àš`š\n\r½ñEAÀHs\É\æ¢\ÜSˆ\Æ½ñc\Ş;š\à\\@´Qµ—|@H±\í–3¿BG‰eC‰q¨!“]\ÎX[‹ò!ÑŸ)¨\ÜY¶×¿‰°sø†Zj½ø’\ê”@óª†\Æ\Ë\ß\ïs0\ÛÄ¢~b­\äA±Ù•ö·i¡VŠE\àD\î\ã›wşN\â\ÌMz,‰Pö‚‡Š\Ä\Ï\â\r\ã‹.|˜\Û\Çie9C‘Ÿ60H¡¥>óz¢M0Y\0ü\rŠı¥\İü\0E\í\àñ¤H\ÉiF‹ß¡ü\Ãa\É\"ø»¿¿\éñEğ ª\ĞÊ‰\\ókºM­\\.\Ì[uŠ84‡\æ\\(â°k›ıG_iƒ#°1DWû£zÁä¿¨$û\êv¸‰N¡£Á\Z…sqH–Y\í\Ú\àŸµ‘Vš\æ¢\áf‚\è\Ø\à¢X\0\Õ~C²4¾a•Æ³}aS†1H±\âj3™~™\ÂÀ¾H2\Ú%\á.\æ\å\äe¬\ßh\ì§\ÊnÛ¹—¡M\îj\ç\Æ/A³ô\çqx\ß{64~Ğ¬,½b·³`üDvpap\ÙP>õ¯\å\0´\ÈÕ· ‹vm?S\ç\rµiı¡_\Ê@\Í\Õ\Ö>\è’÷ò‚¸´˜W\ÃJ[&ÿ\0\Âo~,	·`G§ìš«\ã\ÓÄµÓ’\Ãz»˜§û‰x\Çv¹(ºä²´Nö\ëÁûN3Â‘¬\×h²\×e…\ãî›µ\ãùB‚ü3\á(F\ï ›¾\ìÑ¨\Ô(u\ØE]y?R«{!§\å+l\Ô\ët\"÷®\ä\ÛWœ;#»\n\Î\ëŸ]‚_z\îA^<§\ãM|#ZVĞ–ö9 H\ÑÍ‹Z\î\åãƒ§xo¡&°ÇŒTHc·\Ê\àı„Ä”\â T¨\Ê*¬eJ\åJ•*¥@Œ¶+†Tr˜pÜ®Š•Š‰+5TH’¥J•*T©Q%JõÄ©X¬W‰R°\ÊIiX¨’£*BM\Ç8Œ*Áó¸Ï¶}Ø›:DŠ„5)#Õ¯\à„<Á<ÿ\0¡”	¿rõöÇ—\ßúQ2^Wø\Öü\Ïúñ§—ô\'¯øŸô	\ê~	\è\ÏV\Ô\'­ø»¶>\0,=\Ñø¿\à—öOZ,¤uD¬d¿˜j¨ó\à=_\Æ3œõû\è)}\èù³Ùg=\Ù\î\Êû§½=\É|’¸+Éš:¥jVjTb¢z\è\Ğ)“–’°©D¤`#‘]—HT¦\ë\nÂ²T©^¥’¢JÂŒ•*T©QŠ•T¬T«•Š‰*8NÙ¬Xz0²\å\Ë\ÅË—/™r\Ü[.^¸¹r\Ük‹—.\\YrğYr\Ér\å\ËK\Â\â\Ë\èŒ^Kaé…°¼----…ñT¼¶6—Œ\ÛE\ãih\à^.^[*¢¢¢\Ë\Ã/}ZšÆ¾\àq¬_C/\èÜ¾†1glÜ³\Z—/¼\Ù/7‹‹.5…—^¹Â’\â—.\\¸²\å%%’e%’’Œ½\Ê‘l<ó\Ù6s\'DKt’w.6t$Vs”Lœ\Ü\'S\ß	\ÂAn\Ó\ß=\Óg1ó\Ïv2Q\î\Éîš£g8\Ì/\"/†|B¶°}\ß@\İ-\èjñ~X[\ÑQ”\Ù\æpr1h¹x§Í›¹Â¢\ã·Cot\ÇIh\Ë\ï\ït*[\É=	\èKøÇ‡så¶W¼}³\å\ÇòÏ“\É>YóÏ’W¼ù\"y³\åÂ–Œk\ŞSM{\ã^ò¦¥EM^0‡Ì©P•­\Ş|³\ïŸ~!\ï\ŞUû\Ä÷•\ï<¸×¼pü\ÜÏ¾W¼©Iô\â‘QR™f¾‡\n|½˜\×\Â\Ï[=s\Ö\Ï[=\Ó\Ã\í=mG\Æ\ÏK9´\Ç\ß5r¶zHxI\ébz“\ÔÀô!\áOBz\'©=I\ëGÄ´õ§­=loZz“Ö”õ¥Q\àĞ„ô§˜OJzS\ĞÀô§¥=/B4Ç¥=)\éOJ=±=,Á\ë^”ô§¥=f7¥z\ÓÖ´õ£¥=I\éOBzSÒ”ô§¨šø\'¥=iYÁ\nzHøQN\Ä|I\èOQ\í=D|I\è%x’¼R¼	^$ø’«Á\ÆY\íR7’\é	WøIıq¿²•ûĞŸ\Æ\éa\åÀPb‡?¢Y\ÄF\'C\ÎtÅ¯w?\Úgöı\ŞŸ\Û\çö\È\'ùû–\\º³\r‡Ÿ¦8B‚.ü=\È{P.¥—üÔ¶\ËşSûlö(;C•Ÿ\æÁ”~|¿Á=\ï\Ã3ñ? Œ‚\â”ÿ\0û$\Ú#ş\Ñ?¸O\ì+PW”\n\ŞPÁq!\ì~Dşõ÷,?û\Üş\Å\Ñ\ÃO\Ä\Î\Ùöduñø\Ìñş<{??£ÿ\0˜ÿ\0\Ó3\Çÿ\0Wkôa\Ïû\É\âüğ\'\çƒğcş¯^ß„ş\çú\Ëøÿ\0¿´|_ûñş|G\Í÷\Äz%,Rƒ\Ú1¿…—z±qJn&0mô•\Ännn¥ ²\Ù{Š\Ç\Éw–Ä©jŠx¸¹iiz\æ^\n¢\â¼\Ë\ÇªeM\Î\0M\Ë<\Ê|!\ä#\ç?0e^\á`j{\Ü÷b\â\ê\n¦\â”\î-\"\Å÷.ûÂ¡=––	x9r\Ñ7s•\Üv\âÜ¯{ƒdµN¢\\³¸2\ÙnL˜/3F@¤ ®6MöEñ‡šöF;;~\ìujb%9c)6<\äXK\ÛQ\ÒZQ(”‰…kE—m\Æ\âÊ°\Ä\È\ï\'S”P<òB\î$jVõ\Æ ½\ÈQ\Äõ\"ı‘ñÓ–\Ä.¥\î#\áŒ34.(¬n\Ñt¡©x\ï	L1¤z6q(\îZğ¶13X%\ÔD\Ô<*e|\Êù–Dy‰†\Ü\Í8;‘½\Úwm\ËoF(B¿€ñ\ry•q\èõü\à¡\Ñ\ß\ÜÜ®Q@n¿ˆVHqU5c»¨\î$\İ\Æ\Ì.\åô1\ép¬m‹\ì R\Ø\Ñ\Æ\Z­w‚2‡˜\éRˆ”D‰F\Ş\'ƒ-\'¢/z”•?‰\Ìfğ@\Ô\í	\Ã+P$\ï(\â6¸Á¹W*@\æV¦­bÔ”\Å\\IK*ğ\Ù\ÄT6%¤a\\Ä’¯we>bœşğ-\Îv\Ãó³[\æ\"oMu*Bm\ĞıV¢\Ë)ó,¹¡]\ØQ,H56ú•\ìïš¢8a;\Æ^:›(”ûq÷1Ñ²\0y%¼\Í@7p\0!\å{\Å\åJ{\"\Ğ\Ñ\Zñ(vŒ½c\ritNÀav—,©Uƒ\ÄB\á²;wzJ‰\â!jÀ´CÒ˜¢5\ïz~\Ğ}e)+\æ.¢1%¯\Ìú\'\Zøxˆ\î\ã†ù5F^\ì¢\Û\Ä\Ñwl\Øãˆ”‚ˆ\"¢+\0‹\à*Q\ÓğF9\â9;\ËK^*w‰†V;\Æ&¸À	\Û9P\Ùj}áš²4ET-šn\"¡°¨\è\\hñ\â.u*öÀ$B\"]Í­\Îc€•Pw\0\Ğ\Ü7¹Clin#‚©Ø… #ñó83ˆÆ’«0¥\ÍF5\âF5TPA@ F\ßü\"ö«O\ïÜ«¢ü›\ßş74<<l >`BZ¥\ÜP\×r*\Ø\áø[4\Ñ)m³A}\ám\Ã\ç\Ìnˆ•ƒ¤Ú£\ã*U±\â2¢1²J¸ÀøxòK[#SPzeˆ&¶!j\"\"j00n\Ä./¡4\È7*£\áÌ®!¦	²$)z‰®`\Ê›±#\É&‹œ8…¢\åS\ÄB=µ!€\ï;Cx\ä\Æ\ØXñ<\â¼	\"µbÀS\Íûa\ÅW%GH\é\ï\nvÇ²\æU‰A;TE[l\İ,\0\ÜP\İó\Úù\Ü\èE‚\Ë[\ÍÄ¦D,œ°Q¾\r\Ë.\Ø\é‚$e\ï‰r\å\ÅÁ1\Âa]Á¶¹ƒ\î\Õ)¸¢Û¹sZÁÁ)\æS)b2Y·ˆšœaXóqŞ±PE„·+\0/po´¹I\Ì\àEU\Äjq\Ä\Ô\à¨	J\ã.X*+‚%¡\Ìk‘\à,t›\Zg1‰l ­!\âJ0\rÀ\'\ç\ßf7­z!\Zª²Î¥K¾!M÷š«g\à¹eo\\6BŠH\ëP]K0U\"n\ì–.ˆˆ\Ö\Üyˆf\ãöÀ\Üe¼Kü7¥\ÜA•¬®‚\Z\ÄHKº#Git¦ \î0&\Âp•e†\ìr F{ÁÔ»1Dš \rE5¸¼0CQKû1º” \Õ\Æ\å\Ç$®%\ÓDV\n/MO’>¡\æ\å¸ò\é{„n\Òõ\ŞkG\ÄK\Ï0K©H¬¡\Ê\î$\å‡\á¢x„|˜\\\ï67Q\\E»Š1ŒIxs\Ú2w‚‡qC>p%y\ÅNf\ËI¶\Ù\ìœö±®» ñÛ˜še@–J\Şr»Å—\raÆ±\Ã4‚ó¨“‰ªg\íŸ\Ì/ˆ=®\"l‹¡º \Ên<\\\ìà¨²\ÊeaYp‘q¤ª\\sû\Ëh\Ñ\Ğj\æ–Z¥\Â{¨o™¾‡Qj/~ò\É\Ì4Š\Ô-\Üc¨\'vv—Q*#İ‡BÀ›A\ên0ú\á00s\Èù2Àñ¤¸{”b…«q!c,²‚\Å\ìe-\Çh‹Ø…e\ê\å˜	D¾\èwÁ„\ïpYl¦)¨l‚ YGxEFWh·–j~IKñ\Z4tl(–˜y+r¹²×’pN~\Ğ0Ã–Sl\å,HkpÜ»4Â¬¯\×(u6YU¸,P\æ-\è€ø}¡xĞ®Ò…ƒ¼,Y-\Â\\{Ë¼^±n.9k]a\Çxì¸|\ÒEU\à\0—€\Úz\"\ÂVÔ¤¨Q.â„°ó\æ(Fó„MD\Ô0q\ä9Ÿ8\\•\Ş%%¦…^\å5\Ä\à\Ü\â$³\ÜÔ–,÷4jr\ÑòÀø\'&m8)Š‹Š\â\ân5q\ÔR·ù€1º(t\îa4¿–;\İj;Qšm–ğ\ë\0IxWW\\4\ÜQ\Üx¼-\Ä{\Ê@ K<:†‰¡\Ä*£\Z\å\Í!\Ñ\Ş88–Í·:D\Ö\Ñ£P6[y!~&\àR(q’\\\æ=\ç\í»‰B+l•¸Æ¤8\ÍÀš•r†\î\ä!\ŞQD…@\ê6µ(\ÉZ’%Û‰º&‚Ñ²(\ãlNXÀ\âz¡g„K\ÂWxódÑ› \Öv`#\ÙVÁ¿²¡ñ»OŠ \í6Q.¡=G\ÆPO”^Y\Ş\àQ®%|‘…/™¬4g=³\Şv›É¨‘Rú”d\á‡\",—\ê*^\r¶\ên-„O)W,¬\í/ºQ³†?†Z\ï\r$§yL00`Ô¸A—½³´\Ô	;\ÇØ¨ß˜lÑ¸*‰Cºy†\ÊepJŞ˜‘VÔµÔ¥D\Ûw\nsa\Ø\Ë!\æ\n);7{\Â*‡\à©V÷¹¢‰È±-º%ó;Ä©m\Îó–s6BÚš8õ*ˆ|\îÊµÇ„bË7œ`”\Õi{Â¦˜rF¥\æ_\rCL§¼dq\Ó¹ \Óu\é])ØŠx•\ì•c{`\ÅÀ@\Ö\å\ê^\à\Ñˆ\î(Œ¢E£™wR‘±¡`\Ó\Z%8	c¼°Œ\'`\î5+¦÷Dxb\ÜW¸S44J\Ô\Ñ\\Æ±o\0\ÛiÁ/^Yª\ßÁ£\æ&®5q~X+b¾˜g(\r\Í]B¨\\t2\Ø4\Ü\Ø\ÔÜº&Ö¸\ØNIÍ¸\ï.,X1ª\Æ\Ñşn\Ù^h†*X\Ë|JX0|‘S\Â`\'e»Ab\Ç\ÍEl­@š¡q¸9r„`\Ü\ãG¸º\"\î;\Ø÷€‰K„\à‚‰\İ÷2‘JŠ9œª•/Ø‚e\î:e>cR\é\â\ê3ÿ\Ù',14,'2025-05-17 20:41:48',NULL);
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reembolso`
--

DROP TABLE IF EXISTS `reembolso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reembolso` (
  `idreembolso` int NOT NULL AUTO_INCREMENT,
  `idreserva` int NOT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idestado` int NOT NULL,
  PRIMARY KEY (`idreembolso`),
  KEY `idreserva` (`idreserva`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `reembolso_ibfk_1` FOREIGN KEY (`idreserva`) REFERENCES `reserva` (`idreserva`),
  CONSTRAINT `reembolso_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reembolso`
--

LOCK TABLES `reembolso` WRITE;
/*!40000 ALTER TABLE `reembolso` DISABLE KEYS */;
/*!40000 ALTER TABLE `reembolso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reporte`
--

DROP TABLE IF EXISTS `reporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporte` (
  `idreporte` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `tipo` enum('PDF','Excel') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filtro_aplicado` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ruta_archivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_generacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idreporte`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `reporte_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reporte`
--

LOCK TABLES `reporte` WRITE;
/*!40000 ALTER TABLE `reporte` DISABLE KEYS */;
/*!40000 ALTER TABLE `reporte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva`
--

DROP TABLE IF EXISTS `reserva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva` (
  `idreserva` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `idsede_servicio` int NOT NULL,
  `fecha_reserva` date NOT NULL,
  `idhorario` int NOT NULL,
  `idestado` int NOT NULL,
  `idpago` int DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_limite_pago` datetime DEFAULT NULL,
  PRIMARY KEY (`idreserva`),
  KEY `idhorario` (`idhorario`),
  KEY `idestado` (`idestado`),
  KEY `idpago` (`idpago`),
  KEY `idx_usuario_reserva` (`idusuario`),
  KEY `idx_reserva_sede_servicio` (`idsede_servicio`),
  KEY `idx_reserva_fecha_limite` (`fecha_limite_pago`),
  CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`idsede_servicio`) REFERENCES `sede_servicio` (`idsede_servicio`),
  CONSTRAINT `reserva_ibfk_3` FOREIGN KEY (`idhorario`) REFERENCES `horario_disponible` (`idhorario`),
  CONSTRAINT `reserva_ibfk_4` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`),
  CONSTRAINT `reserva_ibfk_5` FOREIGN KEY (`idpago`) REFERENCES `pago` (`idpago`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva`
--

LOCK TABLES `reserva` WRITE;
/*!40000 ALTER TABLE `reserva` DISABLE KEYS */;
INSERT INTO `reserva` VALUES (1,3,1,'2025-06-10',1,2,1,'2025-05-13 04:40:00','2025-05-13 03:40:00'),(2,4,2,'2025-06-15',4,3,2,'2025-05-13 04:40:00','2025-05-13 03:40:00'),(3,4,1,'2025-06-03',4,1,3,'2025-05-17 20:41:40','2025-05-17 19:41:40');
/*!40000 ALTER TABLE `reserva` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `idrol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nivel_acceso` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Superadmin','Acceso completo a toda la plataforma',3),(2,'Administrador','Gestiona usuarios, reservas y servicios',2),(3,'Coordinador','Asiste en campo, marca asistencia y reporta incidencias',2),(4,'Vecino','Usuario final que reserva servicios',1);
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede`
--

DROP TABLE IF EXISTS `sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede` (
  `idsede` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitud` double DEFAULT NULL,
  `longitud` double DEFAULT NULL,
  `activo` bit(1) DEFAULT NULL,
  PRIMARY KEY (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede`
--

LOCK TABLES `sede` WRITE;
/*!40000 ALTER TABLE `sede` DISABLE KEYS */;
INSERT INTO `sede` VALUES (1,'Complejo Deportivo Maranga','Av. La Marina 1350','San Miguel','Frente a la Universidad San Marcos',-12.0795,-77.0873,NULL),(2,'Polideportivo San Miguel','Av. Costanera 1535','San Miguel','Cerca al Parque de las Leyendas',-12.0758,-77.0902,NULL),(3,'Centro Cultural San Miguel','Av. Federico Gallese 750','San Miguel','Junto a la Municipalidad',-12.0774,-77.084,NULL),(4,'Complejo Deportivo San Miguel','Av. Universitaria 456','San Miguel','Frente al parque central',-12.0689,-77.0795,NULL);
/*!40000 ALTER TABLE `sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede_servicio`
--

DROP TABLE IF EXISTS `sede_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede_servicio` (
  `idsede_servicio` int NOT NULL AUTO_INCREMENT,
  `idsede` int NOT NULL,
  `idservicio` int NOT NULL,
  `idtarifa` int NOT NULL,
  PRIMARY KEY (`idsede_servicio`),
  KEY `idservicio` (`idservicio`),
  KEY `idtarifa` (`idtarifa`),
  KEY `idx_sede_servicio` (`idsede`,`idservicio`),
  CONSTRAINT `sede_servicio_ibfk_1` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`),
  CONSTRAINT `sede_servicio_ibfk_2` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`),
  CONSTRAINT `sede_servicio_ibfk_3` FOREIGN KEY (`idtarifa`) REFERENCES `tarifa` (`idtarifa`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede_servicio`
--

LOCK TABLES `sede_servicio` WRITE;
/*!40000 ALTER TABLE `sede_servicio` DISABLE KEYS */;
INSERT INTO `sede_servicio` VALUES (1,1,1,1),(2,2,2,2),(3,1,3,3),(4,1,4,4),(5,3,5,5),(6,3,6,6);
/*!40000 ALTER TABLE `sede_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `idservicio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idtipo` int NOT NULL,
  `idestado` int NOT NULL,
  `contacto_soporte` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_inicio` time DEFAULT NULL,
  `horario_fin` time DEFAULT NULL,
  `imagen_complejo` tinyblob,
  PRIMARY KEY (`idservicio`),
  KEY `idtipo` (`idtipo`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`idtipo`) REFERENCES `tipo_servicio` (`idtipo`),
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (1,'Piscina Principal','Piscina olÃ­mpica con 6 carriles',1,4,'987654321','08:00:00','18:00:00',NULL),(2,'Gimnasio Municipal','Gimnasio equipado con mÃ¡quinas de Ãºltima generaciÃ³n',2,4,'987654321','06:00:00','22:00:00',NULL),(3,'Cancha FÃºtbol 1','Cancha de fÃºtbol 7 con cÃ©sped sintÃ©tico',3,4,'987654321','07:00:00','21:00:00',NULL),(4,'Cancha VÃ³ley','Cancha reglamentaria para vÃ³ley',4,4,'987654321','08:00:00','18:00:00',NULL),(5,'SalÃ³n de Eventos','SalÃ³n para reuniones o eventos sociales',5,4,'987654321','10:00:00','22:00:00',NULL),(6,'Taller Artesanal','Espacio para talleres municipales',6,4,'987654321','09:00:00','13:00:00',NULL);
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitud_eliminacion`
--

DROP TABLE IF EXISTS `solicitud_eliminacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitud_eliminacion` (
  `idsolicitud` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `confirmado` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idsolicitud`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `solicitud_eliminacion_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitud_eliminacion`
--

LOCK TABLES `solicitud_eliminacion` WRITE;
/*!40000 ALTER TABLE `solicitud_eliminacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitud_eliminacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spring_session`
--

DROP TABLE IF EXISTS `spring_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spring_session` (
  `PRIMARY_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SESSION_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CREATION_TIME` bigint NOT NULL,
  `LAST_ACCESS_TIME` bigint NOT NULL,
  `MAX_INACTIVE_INTERVAL` int NOT NULL,
  `EXPIRY_TIME` bigint NOT NULL,
  `PRINCIPAL_NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`PRIMARY_ID`),
  UNIQUE KEY `SPRING_SESSION_IX1` (`SESSION_ID`),
  KEY `SPRING_SESSION_IX2` (`EXPIRY_TIME`),
  KEY `SPRING_SESSION_IX3` (`PRINCIPAL_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spring_session`
--

LOCK TABLES `spring_session` WRITE;
/*!40000 ALTER TABLE `spring_session` DISABLE KEYS */;
INSERT INTO `spring_session` VALUES ('dfeeaf76-879d-4262-857b-8a946d0c05fc','112cc21b-3c66-4c2f-9d8b-e3bd379293bf',1747516230277,1747516230383,1800,1747518030383,NULL);
/*!40000 ALTER TABLE `spring_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spring_session_attributes`
--

DROP TABLE IF EXISTS `spring_session_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spring_session_attributes` (
  `SESSION_PRIMARY_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ATTRIBUTE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ATTRIBUTE_BYTES` blob NOT NULL,
  PRIMARY KEY (`SESSION_PRIMARY_ID`,`ATTRIBUTE_NAME`),
  CONSTRAINT `SPRING_SESSION_ATTRIBUTES_FK` FOREIGN KEY (`SESSION_PRIMARY_ID`) REFERENCES `spring_session` (`PRIMARY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spring_session_attributes`
--

LOCK TABLES `spring_session_attributes` WRITE;
/*!40000 ALTER TABLE `spring_session_attributes` DISABLE KEYS */;
INSERT INTO `spring_session_attributes` VALUES ('dfeeaf76-879d-4262-857b-8a946d0c05fc','org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository.CSRF_TOKEN',_binary '¬\í\0sr\06org.springframework.security.web.csrf.DefaultCsrfTokenZ\ï·\È/¢û\Õ\0L\0\nheaderNamet\0Ljava/lang/String;L\0\rparameterNameq\0~\0L\0tokenq\0~\0xpt\0X-CSRF-TOKENt\0_csrft\0$3965a0e3-1619-4ac8-a583-2859e6fa5c41');
/*!40000 ALTER TABLE `spring_session_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taller`
--

DROP TABLE IF EXISTS `taller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taller` (
  `idtaller` int NOT NULL AUTO_INCREMENT,
  `idservicio` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `cupos_maximos` int NOT NULL,
  `instructor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idestado` int NOT NULL,
  PRIMARY KEY (`idtaller`),
  KEY `idservicio` (`idservicio`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `taller_ibfk_1` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`),
  CONSTRAINT `taller_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taller`
--

LOCK TABLES `taller` WRITE;
/*!40000 ALTER TABLE `taller` DISABLE KEYS */;
INSERT INTO `taller` VALUES (1,6,'Taller de CerÃ¡mica','Aprende tÃ©cnicas bÃ¡sicas de cerÃ¡mica','2025-06-01','2025-06-30','10:00:00','12:00:00',15,'Prof. Ana SÃ¡nchez',18),(2,6,'Taller de Pintura','IntroducciÃ³n a la pintura al Ã³leo','2025-06-15','2025-07-15','15:00:00','17:00:00',12,'Prof. Carlos LÃ³pez',18);
/*!40000 ALTER TABLE `taller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taller_inscripcion`
--

DROP TABLE IF EXISTS `taller_inscripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taller_inscripcion` (
  `idinscripcion` int NOT NULL AUTO_INCREMENT,
  `idtaller` int NOT NULL,
  `idusuario` int NOT NULL,
  `fecha_inscripcion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idinscripcion`),
  KEY `idtaller` (`idtaller`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `taller_inscripcion_ibfk_1` FOREIGN KEY (`idtaller`) REFERENCES `taller` (`idtaller`),
  CONSTRAINT `taller_inscripcion_ibfk_2` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taller_inscripcion`
--

LOCK TABLES `taller_inscripcion` WRITE;
/*!40000 ALTER TABLE `taller_inscripcion` DISABLE KEYS */;
INSERT INTO `taller_inscripcion` VALUES (1,1,3,'2025-05-13 04:40:00'),(2,1,4,'2025-05-13 04:40:00'),(3,2,3,'2025-05-13 04:40:00');
/*!40000 ALTER TABLE `taller_inscripcion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifa`
--

DROP TABLE IF EXISTS `tarifa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifa` (
  `idtarifa` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto` double DEFAULT NULL,
  `fecha_actualizacion` date DEFAULT (curdate()),
  PRIMARY KEY (`idtarifa`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifa`
--

LOCK TABLES `tarifa` WRITE;
/*!40000 ALTER TABLE `tarifa` DISABLE KEYS */;
INSERT INTO `tarifa` VALUES (1,'Tarifa estÃ¡ndar piscina',15,'2025-05-08'),(2,'Tarifa gimnasio maÃ±ana',10,'2025-05-08'),(3,'Tarifa cancha fÃºtbol',50,'2025-05-08'),(4,'Tarifa cancha vÃ³ley',25,'2025-05-08'),(5,'Tarifa evento social',100,'2025-05-08'),(6,'Tarifa taller',60,'2025-05-08');
/*!40000 ALTER TABLE `tarifa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_servicio`
--

DROP TABLE IF EXISTS `tipo_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_servicio` (
  `idtipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idtipo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_servicio`
--

LOCK TABLES `tipo_servicio` WRITE;
/*!40000 ALTER TABLE `tipo_servicio` DISABLE KEYS */;
INSERT INTO `tipo_servicio` VALUES (1,'Piscina'),(2,'Gimnasio'),(3,'Cancha de FÃºtbol'),(4,'Cancha de VÃ³ley'),(5,'SalÃ³n de Eventos'),(6,'Taller');
/*!40000 ALTER TABLE `tipo_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idrol` int NOT NULL,
  `estado` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notificar_recordatorio` tinyint(1) DEFAULT '1',
  `notificar_disponibilidad` tinyint(1) DEFAULT '1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  KEY `idrol` (`idrol`),
  KEY `idx_usuario_email` (`email`),
  KEY `idx_usuario_dni` (`dni`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idrol`) REFERENCES `rol` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'87654321','Admin','San Miguel','admin@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. La Marina 123',1,'activo',1,1,'2025-05-13 04:40:00'),(2,'75234109','SofÃ­a','Delgado','sdelgado@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654322','Av. Costanera 456',2,'activo',1,1,'2025-05-13 04:40:00'),(3,'12345678','Luis','FernÃ¡ndez','lfernandez@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654323','Calle Los Cedros 102',4,'activo',1,1,'2025-05-13 04:40:00'),(4,'23456789','Carla','Mendoza','carla.mendoza@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654322','Pasaje 3 Mz. B Lt. 4',4,'activo',1,1,'2025-05-13 04:40:00'),(5,'12345677','Carlos','Lopez','carlos.lopez@pucp.edu.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. Ejemplo 123',3,'activo',1,1,'2025-05-13 04:43:48');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validacion_usuario`
--

DROP TABLE IF EXISTS `validacion_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validacion_usuario` (
  `idvalidacion` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `codigo_validacion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_temporal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_expiracion` datetime DEFAULT NULL,
  `estado` enum('pendiente','aceptado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  PRIMARY KEY (`idvalidacion`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `validacion_usuario_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validacion_usuario`
--

LOCK TABLES `validacion_usuario` WRITE;
/*!40000 ALTER TABLE `validacion_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `validacion_usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-17 16:14:53
