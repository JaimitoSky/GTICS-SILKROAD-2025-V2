DROP DATABASE IF EXISTS plataforma_reservas;

CREATE DATABASE  IF NOT EXISTS `plataforma_reservas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `plataforma_reservas`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: plataforma_reservas
-- ------------------------------------------------------
-- Server version	8.0.39

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
INSERT INTO `estado` VALUES (1,'pendiente','Reserva pendiente de validación','reserva'),(2,'aprobada','Reserva aprobada por el administrador','reserva'),(3,'rechazada','Reserva rechazada por el administrador','reserva'),(4,'disponible','Servicio disponible para reservas','servicio'),(5,'reservado','Servicio reservado por un vecino en este horario','servicio'),(6,'en_mantenimiento','Servicio inhabilitado temporalmente por mantenimiento','servicio'),(7,'bloqueado','Bloqueo especial por evento o actividad programada','servicio'),(8,'inactivo','Servicio fuera de operación de forma indefinida','servicio'),(9,'reportado','Incidencia registrada por un coordinador','incidencia'),(10,'en_progreso','Acción en curso para resolver la incidencia','incidencia'),(11,'solucionado','Incidencia resuelta satisfactoriamente','incidencia'),(12,'no_corresponde','Incidencia invalidada tras revisión','incidencia'),(13,'crítico','Incidencia urgente con prioridad alta','incidencia'),(14,'pendiente','Pago pendiente de validación','pago'),(15,'confirmado','Pago validado y confirmado','pago'),(16,'rechazado','Pago rechazado por el administrador','pago'),(17,'reembolsado','Monto devuelto al usuario','pago'),(18,'no_pagado','Reserva sin pago registrado','pago');
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
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
INSERT INTO `horario_atencion` VALUES (1,1,'Lunes','08:00:00','20:00:00',1),(2,1,'Martes','08:00:00','20:00:00',1),(3,1,'Miércoles','08:00:00','20:00:00',1),(4,1,'Jueves','08:00:00','20:00:00',1),(5,1,'Viernes','08:00:00','20:00:00',1),(6,1,'Sábado','08:00:00','15:00:00',1),(7,1,'Domingo','00:00:00','00:00:00',0),(8,2,'Lunes','08:00:00','20:00:00',1),(9,2,'Martes','08:00:00','20:00:00',1),(10,2,'Miércoles','08:00:00','20:00:00',1),(11,2,'Jueves','08:00:00','20:00:00',1),(12,2,'Viernes','08:00:00','20:00:00',1),(13,2,'Sábado','08:00:00','15:00:00',1),(14,2,'Domingo','00:00:00','00:00:00',0),(15,3,'Lunes','08:00:00','20:00:00',1),(16,3,'Martes','08:00:00','20:00:00',1),(17,3,'Miércoles','08:00:00','20:00:00',1),(18,3,'Jueves','08:00:00','20:00:00',1),(19,3,'Viernes','08:00:00','20:00:00',1),(20,3,'Sábado','08:00:00','15:00:00',1),(21,3,'Domingo','00:00:00','00:00:00',0),(22,4,'Lunes','08:00:00','20:00:00',1),(23,4,'Martes','08:00:00','20:00:00',1),(24,4,'Miércoles','08:00:00','20:00:00',1),(25,4,'Jueves','08:00:00','20:00:00',1),(26,4,'Viernes','08:00:00','20:00:00',1),(27,4,'Sábado','08:00:00','15:00:00',1),(28,4,'Domingo','00:00:00','00:00:00',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (1,4,'Nueva reserva pendiente','Tienes una nueva reserva que aún no ha sido confirmada, revísala en Mis Reservas',0,'2025-05-17 22:41:46');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (1,3,60.00,'online',NULL,15,'2025-05-13 04:40:00',NULL),(2,4,50.00,'banco',NULL,18,'2025-05-13 04:40:00',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva`
--

LOCK TABLES `reserva` WRITE;
/*!40000 ALTER TABLE `reserva` DISABLE KEYS */;
INSERT INTO `reserva` VALUES (1,3,1,'2025-06-10',1,2,1,'2025-05-13 04:40:00','2025-05-13 03:40:00'),(2,4,2,'2025-06-15',4,3,2,'2025-05-13 04:40:00','2025-05-13 03:40:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede_servicio`
--

LOCK TABLES `sede_servicio` WRITE;
/*!40000 ALTER TABLE `sede_servicio` DISABLE KEYS */;
INSERT INTO `sede_servicio` VALUES (1,1,1,1),(2,2,2,2),(3,1,3,3),(4,1,4,4),(5,3,5,5),(6,3,6,6),(7,2,7,7);
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
  `imagen_complejo` longblob,
  PRIMARY KEY (`idservicio`),
  KEY `idtipo` (`idtipo`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`idtipo`) REFERENCES `tipo_servicio` (`idtipo`),
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;

INSERT INTO `servicio` (`idservicio`, `nombre`, `descripcion`, `idtipo`, `idestado`, `contacto_soporte`, `horario_inicio`, `horario_fin`, `imagen_complejo`) VALUES
(1, 'Piscina Principal', 'Piscina olímpica con 6 carriles', 1, 4, '987654321', '08:00:00', '18:00:00', NULL),
(2, 'Gimnasio Municipal', 'Gimnasio equipado con máquinas de última generación', 2, 4, '987654321', '06:00:00', '22:00:00', NULL),
(3, 'Cancha Fútbol 1', 'Cancha de fútbol 7 con césped sintético', 3, 4, '987654321', '07:00:00', '21:00:00', NULL),
(4, 'Cancha Vóley', 'Cancha reglamentaria para vóley', 4, 4, '987654321', '08:00:00', '18:00:00', NULL),
(5, 'Salón de Eventos', 'Salón para reuniones o eventos sociales', 5, 4, '987654321', '10:00:00', '22:00:00', NULL),
(6, 'Taller Artesanal', 'Espacio para talleres municipales', 6, 4, '987654321', '09:00:00', '13:00:00', NULL),
(7, 'Campo de Atletismo Principal', 'Campo de Atletismo de 5 carriles', 7, 4, '987654321', '09:00:00', '18:00:00', NULL);

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
INSERT INTO `spring_session` VALUES ('5b4adedc-6b80-4549-bb25-aa775b4cf50d','0c39054e-f605-4c7c-a442-87be7b353199',1747521938897,1747521950324,1800,1747523750324,'carla.mendoza@gmail.com');
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
INSERT INTO `spring_session_attributes` VALUES ('5b4adedc-6b80-4549-bb25-aa775b4cf50d','idusuario',_binary ' \ \0sr\0java.lang.Integer⠤   8\0I\0valuexr\0java.lang.Number   
 \ \0\0xp\0\0\0'),('5b4adedc-6b80-4549-bb25-aa775b4cf50d','SPRING_SECURITY_CONTEXT',_binary ' \ \0sr\0=org.springframework.security.core.context.SecurityContextImpl\0\0\0\0\0\0l\0L\0authenticationt\02Lorg/springframework/security/core/Authentication;xpsr\0Oorg.springframework.security.authentication.UsernamePasswordAuthenticationToken\0\0\0\0\0\0l\0L\0
credentialst\0Ljava/lang/Object;L\0	principalq\0~\0xr\0Gorg.springframework.security.authentication.AbstractAuthenticationTokenӪ(~nGd\0Z\0\rauthenticatedL\0
authoritiest\0Ljava/util/Collection;L\0 detailsq\0~\0xpsr\0&java.util.Collections$UnmodifiableList %1 \ \0L\0listt\0Ljava/util/List;xr\0,java.util.Collections$UnmodifiableCollectionB\0 \ ^ \0L\0cq\0~\0xpsr\0java.util.ArrayListx \  \ a \0I\0sizexp\0\0\0w\0\0\0sr\0Borg.springframework.security.core.authority.SimpleGrantedAuthority\0\0\0\0\0\0l\0L\0rolet\0Ljava/lang/String;xpt\0Vecinoxq\0~\0\rsr\0Horg.springframework.security.web.authentication.WebAuthenticationDetails\0\0\0\0\0\0l\0L\0\rremoteAddressq\0~\0L\0	sessionIdq\0~\0xpt\00:0:0:0:0:0:0:1t\0$c85facf7-8859-42f1-bba4-474556a82c93psr\02org.springframework.security.core.userdetails.User\0\0\0\0\0\0l\0 Z\0accountNonExpiredZ\0accountNonLockedZ\0credentialsNonExpiredZ\0 enabledL\0
authoritiest\0Ljava/util/Set;L\0passwordq\0~\0L\0usernameq\0~\0xpsr\0%java.util.Collections$UnmodifiableSet  я  U\0\0xq\0~\0\nsr\0java.util.TreeSetݘP  \ [\0\0xpsr\0Forg.springframework.security.core.userdetails.User$AuthorityComparator\0\0\0\0\0\0l\0\0xpw\0\0\0q\0~\0xpt\0carla.mendoza@gmail.com'),('5b4adedc-6b80-4549-bb25-aa775b4cf50d','usuario',_binary ' \ \0sr\0\"com.example.grupo_6.Entity.UsuarioӐ!k  \ \0L\0	apellidost\0Ljava/lang/String;L\0\ncreateTimet\0Ljava/sql/Timestamp;L\0	direccionq\0~\0L\0dniq\0~\0L\0emailq\0~\0L\0estadoq\0~\0L\0idrolt\0Ljava/lang/Integer;L\0	idusuarioq\0~\0L\0 nombresq\0~\0L\0notificar_disponibilidadt\0Ljava/lang/Boolean;L\0notificar_recordatorioq\0~\0L\0passwordHashq\0~\0L\0rolt\0 Lcom/example/grupo_6/Entity/Rol;L\0telefonoq\0~\0xpt\0 Mendozasr\0java.sql.Timestamp&\ \ S e\0I\0nanosxr\0java.util.Datehj KYt\0\0xpw\0\0 \  E\0x\0\0\0\0t\0Pasaje 3 Mz. B Lt. 4t\023456789t\0carla.mendoza@gmail.comt\0activosr\0java.lang.Integer⠤   8\0I\0valuexr\0java.lang.Number   
 \ \0\0xp\0\0\0q\0~\0t\0Carlasr\0java.lang.Boolean\  r ՜ \ \0Z\0valuexpq\0~\0t\0<$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1emsr\04org.hibernate.proxy.pojo.bytebuddy.SerializableProxy 	K x \0L\0componentIdTypet\0\"Lorg/hibernate/type/CompositeType;L\0identifierGetterMethodClasst\0Ljava/lang/Class;L\0\ZidentifierGetterMethodNameq\0~\0L\0identifierSetterMethodClassq\0~\0L\0\ZidentifierSetterMethodNameq\0~\0[\0identifierSetterMethodParamst\0[Ljava/lang/Class;[\0\ninterfacesq\0~\0L\0persistentClassq\0~\0xr\0-org.hibernate.proxy.AbstractSerializableProxy   (Cc \0Z\0allowLoadOutsideTransactionL\0\nentityNameq\0~\0L\0idt\0Ljava/lang/Object;L\0readOnlyq\0~\0L\0sessionFactoryNameq\0~\0L\0sessionFactoryUuidq\0~\0xp\0t\0com.example.grupo_6.Entity.Rolq\0~\0ppt\0$cc2c08d2-f67b-4491-b128-0afb59b5f385pvr\0com.example.grupo_6.Entity.Rol\0\0\0\0\0\0\0\0\0\0\0xpt\0getIdrolq\0~\0 t\0setIdrolur\0[Ljava.lang.Class; ׮\ \ Z \0\0xp\0\0\0vq\0~\0uq\0~\0#\0\0\0vr\0\"org.hibernate.proxy.HibernateProxy \ \   N\0\0xpq\0~\0 t\0	987654324');
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
INSERT INTO `taller` VALUES (1,6,'Taller de Cerámica','Aprende técnicas básicas de cerámica','2025-06-01','2025-06-30','10:00:00','12:00:00',15,'Prof. Ana Sánchez',18),(2,6,'Taller de Pintura','Introducción a la pintura al óleo','2025-06-15','2025-07-15','15:00:00','17:00:00',12,'Prof. Carlos López',18);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifa`
--

LOCK TABLES `tarifa` WRITE;
/*!40000 ALTER TABLE `tarifa` DISABLE KEYS */;
INSERT INTO `tarifa` VALUES (1,'Tarifa estándar piscina',15,'2025-05-08'),(2,'Tarifa gimnasio mañana',10,'2025-05-08'),(3,'Tarifa cancha fútbol',50,'2025-05-08'),(4,'Tarifa cancha vóley',25,'2025-05-08'),(5,'Tarifa evento social',100,'2025-05-08'),(6,'Tarifa taller',60,'2025-05-08'),(7,'Tarifa campo Atletismo',30,'2025-05-08');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_servicio`
--

LOCK TABLES `tipo_servicio` WRITE;
/*!40000 ALTER TABLE `tipo_servicio` DISABLE KEYS */;
INSERT INTO `tipo_servicio` VALUES (1,'Piscina'),(2,'Gimnasio'),(3,'Cancha de Fútbol'),(4,'Cancha de Vóley'),(5,'Salón de Eventos'),(6,'Taller'),(7,'Atletismo');
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
INSERT INTO `usuario` VALUES (1,'87654321','Admin','San Miguel','admin@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. La Marina 123',1,'activo',1,1,'2025-05-13 04:40:00'),(2,'75234109','Sofía','Delgado','sdelgado@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654322','Av. Costanera 456',2,'activo',1,1,'2025-05-13 04:40:00'),(3,'12345678','Luis','Fernández','lfernandez@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654323','Calle Los Cedros 102',4,'activo',1,1,'2025-05-13 04:40:00'),(4,'23456789','Carla','Mendoza','carla.mendoza@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654324','Pasaje 3 Mz. B Lt. 4',4,'activo',1,1,'2025-05-13 04:40:00'),(5,'12345677','Carlos','Lopez','carlos.lopez@pucp.edu.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. Ejemplo 123',3,'activo',1,1,'2025-05-13 04:43:48');
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

--
-- Dumping routines for database 'plataforma_reservas'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

SET SQL_SAFE_UPDATES = 0;

UPDATE sede
SET activo = 1
WHERE activo IS NULL;
ALTER TABLE sede_servicio ADD COLUMN activo BOOLEAN DEFAULT TRUE;

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 1;
CREATE TABLE coordinador_sede (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idusuario INT NOT NULL,
  idsede INT NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (idusuario) REFERENCES usuario(idusuario),
  FOREIGN KEY (idsede) REFERENCES sede(idsede),
  UNIQUE (idusuario, idsede)
);

INSERT INTO coordinador_sede (idusuario, idsede, activo)
VALUES (5, 1, 1);

CREATE TABLE incidencia (
    idincidencia INT AUTO_INCREMENT PRIMARY KEY,
    idreserva INT NOT NULL,
    idusuario INT NOT NULL, -- coordinador que reporta
    descripcion TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idreserva) REFERENCES reserva(idreserva),
    FOREIGN KEY (idusuario) REFERENCES usuario(idusuario)
);

ALTER TABLE asistencia
ADD COLUMN idreserva INT;

ALTER TABLE asistencia
ADD CONSTRAINT asistencia_fk_reserva
FOREIGN KEY (idreserva) REFERENCES reserva(idreserva)
ON UPDATE RESTRICT
ON DELETE RESTRICT;

RENAME TABLE spring_session TO spring_session_temp;
RENAME TABLE spring_session_temp TO SPRING_SESSION;

RENAME TABLE spring_session_attributes TO spring_session_attributes_temp;
RENAME TABLE spring_session_attributes_temp TO SPRING_SESSION_ATTRIBUTES;

ALTER TABLE horario_disponible ADD COLUMN aforo_maximo INT DEFAULT 30; 

ALTER TABLE sede_servicio 
ADD COLUMN nombre_personalizado VARCHAR(255) NOT NULL;

UPDATE sede_servicio 
SET nombre_personalizado = 'Piscina Principal - Complejo Deportivo Maranga'
WHERE idsede_servicio = 1;

UPDATE sede_servicio 
SET nombre_personalizado = 'Gimnasio Municipal - Polideportivo San Miguel'
WHERE idsede_servicio = 2;

UPDATE sede_servicio 
SET nombre_personalizado = 'Cancha Fútbol 1 - Polideportivo San Miguel'
WHERE idsede_servicio = 3;

UPDATE sede_servicio 
SET nombre_personalizado = 'Cancha Vóley - Complejo Deportivo Maranga'
WHERE idsede_servicio = 4;

UPDATE sede_servicio 
SET nombre_personalizado = 'Salón de Eventos - Centro Cultural San Miguel'
WHERE idsede_servicio = 5;

UPDATE sede_servicio 
SET nombre_personalizado = 'Taller Artesanal - Centro Cultural San Miguel'
WHERE idsede_servicio = 6;

UPDATE sede_servicio 
SET nombre_personalizado = 'Campo de Atletismo Principal - Polideportivo San Miguel'
WHERE idsede_servicio = 7;

UPDATE sede_servicio 
SET nombre_personalizado = 'Piscina Principal - Complejo Deportivo San Miguel'
WHERE idsede_servicio = 8;

-- Cambiar el nombre de "Cancha Fútbol 1" a "Cancha Fútbol"
UPDATE servicio
SET nombre = 'Cancha Fútbol'
WHERE idservicio = 3;

-- Cambiar el nombre y la descripción de "Taller Artesanal" a algo más general
UPDATE servicio
SET nombre = 'Taller',
    descripcion = 'Espacio para actividades y talleres comunitarios'
WHERE idservicio = 6;


-- Cambiar el nombre y la descripción de "Taller Artesanal" a algo más general
UPDATE servicio
SET nombre = 'Campo de Atletismo'
WHERE idservicio = 7;

DROP TABLE asistencia;


-- Asegura que no existan restricciones activas
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS asistencia_coordinador;

CREATE TABLE asistencia_coordinador (
    idasistencia INT AUTO_INCREMENT PRIMARY KEY,
    idusuario INT NOT NULL,
    fecha DATE NOT NULL,
    hora_entrada TIME,
    latitud DECIMAL(10, 8),					
    longitud DECIMAL(11, 8),
    idsede INT NOT NULL,

    FOREIGN KEY (idusuario) REFERENCES usuario(idusuario),
    FOREIGN KEY (idsede) REFERENCES sede(idsede),
    UNIQUE KEY uk_asistencia_por_sede_usuario (idusuario, idsede, fecha)
);


-- 1.  Salida de coordinador
ALTER TABLE asistencia_coordinador
  ADD COLUMN hora_salida      TIME                 NULL AFTER hora_entrada,
  ADD COLUMN latitud_salida   DECIMAL(10,8)        NULL AFTER longitud,
  ADD COLUMN longitud_salida  DECIMAL(11,8)        NULL AFTER latitud_salida;

-- 2. Horario de atención que aplica
ALTER TABLE asistencia_coordinador
  ADD COLUMN idhorario_atencion INT               NULL AFTER idsede,
  ADD INDEX idx_asist_horario (idhorario_atencion),
  ADD CONSTRAINT fk_asist_horario
    FOREIGN KEY (idhorario_atencion)
    REFERENCES horario_atencion(idhorario_atencion)
    ON UPDATE CASCADE
    ON DELETE SET NULL;

-- 3. Estado de la marcación de entrada
ALTER TABLE asistencia_coordinador
  ADD COLUMN estado ENUM('presente','tarde','falta') 
    NOT NULL DEFAULT 'falta' 
    AFTER idhorario_atencion;


SET FOREIGN_KEY_CHECKS=1;

-- Para limpiar los datos de servicios + reservas  (opcional)
SET SQL_SAFE_UPDATES = 0;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM reembolso;
DELETE FROM pago;
DELETE FROM reserva;

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM horario_disponible;
DELETE FROM taller_inscripcion;
DELETE FROM taller;
DELETE FROM media_servicio;
DELETE FROM sede_servicio;

SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE reserva AUTO_INCREMENT = 1;
ALTER TABLE pago AUTO_INCREMENT = 1;
ALTER TABLE reembolso AUTO_INCREMENT = 1;
ALTER TABLE sede_servicio AUTO_INCREMENT = 1;

SET SQL_SAFE_UPDATES = 1;

