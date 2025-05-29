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
INSERT INTO `servicio` VALUES (1,'Piscina Principal','Piscina olímpica con 6 carriles',1,4,'987654321','08:00:00','18:00:00',_binary ' \  \ \0JFIF\0\0\0\0\0\0 \ \0C\0
		 		 				
						
	




\r\r%\Z%))%756\Z*2>-)0;! \ \0C 
	


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  \0\0 U\"\0 \ \0\0\0\0\0\0\0\0\0\0\0\0\0\0  \ \0H\0  \0\0\0!1A\"Qaq2   #B $3Rbr  4C    \  DSc \ %s\ \  \  \ \0\Z\0\0\0\0\0\0\0\0\0\0\0\0 \ \03\0\0\0\0\0\0\0!1AQ  BRaq \" \ \ 2   #3b \ \0\0\0?\0\ R X\" d\ *\ \ \ :   u:\ s }|	<Ǯ-,3    \0y3#*G7C \ z &[	  K 6 Y  E %    w b \ \  ˁ\ uW  Dkh \ 5  ~ _k\ !]\\G  O\ \ \ c\ \0\ , \ o\ EJ%  \ # \ <j v      ^}p \ \ ;Eڬ 8\ \Z ֈ{ \ H\Z
\r  \0 \ 	\ iEۼ \ \ i\ Vq)w  \ P 6   \  \0 \ G;u+\ \ K9fc`K +  Id \ X Yk #  Hۯ \":\ & >\ _f EK5*TRWA( \ \ \ {l{ 5 ,eU :\ 6_[4\ 	 5   !  I(\"P D  \ ˙AƍB } 6ឲE l  \ [= \ 6\\\0  \ E 5Î  f<Q |Z D\ 5* = e\ \n 4 \ S \ \  \ \ #E>=\ U j Lie9pYe׉ \  O :jn\ \ , eE,L )   & \ \ m       \ F Uw  5`y\ L  \  . \ 8 \r3I l +\   B2 \ *  R  B a} \  =1  9\ YI^      Yf\ \ ܆^ \ ,u } \"\ CW~gV7 \ \ \  \ \ZL 8ʋ xc\  \ zv \ 7  \  |2[h\ u uX\  C\ [G duA \ z01   \ f,\ \ \ ]1Ou5Z t\ å }?I\ \ Ҍ\ AT ĸg  \ \ \'ߕ4@|:  \ ψ& fj \Z^ \ PDf\ N  \ \ } ;\ l:HkpyVF\ OA[ * Ԕ :(шF  J\  ܮ ]  \ 58 \ eA )̊\ H\ \ f]Lԃ\ 5f  p   y W͢U   Q\ Fn E겛č W 5*yg c   \ 8q w>\ \ \ \ Ȇ2t:E vRE»\ YSGI\   \   >\\*Ŕ\nw ay  . K Q 5$C\ Q\ 	> V  z\ Q\ \ J\ x \ . Lzu\ Qk\ F     3\  4G   А>ɎڢdU z c> \  C(%,\ b\ F\ \ Mj p\ r  UO\  (\ $3\ ÙK\   Y  \  \ t\ & #ң)V *\n  ~ #\ \ JH ե{\ \ \ c H\    2OS  \  0QŤ\095\r4 k ҈ Y\ B \ \ \ XI Ϡ    \ :B :H[X
0\ \ \ 	 \ Y (\" \0 Q \ n4 G Rq VG   j\'   > bY I \ \ \ is B\   8  9o 
\ V\\ I\  z\ xb \ rMN \ \"  , W ҈  p     M   8 ok 
 !\ q \ Ȩ \ \  :I )    K[! \ Hu Ȟx͞  hke 2 \ S*  ͟\"\ a \     uy ,9  \ w\ V&   +\  \ K <\  J\\ƮjӖ $p&e  FI Du&\ Y Ā =ܼ\ \ \ z w9 DZ   \0H\ M0Qjܹ  V ȋo \ \Z \ Tdt Ꚋ\  \0d n  N y\ @^  \ d  *ߔ2)\ Y \ n \0
V \ |I o,1,\ y\ L[ \0N\ -+W\ \ _a9\Z\   \0\ 8 ji$  ͊iʻO\ \ B 0\0 f 7 \ \ W  e\ t7 o\ \n WD \0zzC
y[  \ \0\ U   \ f]  	\"u# \ 8ђ :n\ \ Y\ G L   ry	HP     8  g\ \ ]   z  R N \Z\ zh c8\ \ &K \ \ [\  7X\ t   \0 \ _  >  n\  \\ 5  4w   \"  \ V\"潝\ \ \ c \ \ \ !
v-N\ k_V _\ \ \ ,ժ  c H \  V   Y\ f \' Xj (\  94 8P\ s\ne \0 W ` \  \ \0\n\ \  \ c3B\ \ S\ m!C   \     u   \ |Q\ \ #  Q  r\ W\ \ \ _\ \ ̄x v6?\ O \ f_\ = \ \ \ +# \'=-!\ )~ C)\ شU \ -?  x  \ }F\ \ \ \ \ G \0)\ o SɍJ\  o \ v  {x    - ̉\n\ }  \  \   %_ 0 \ VՑe \0 j \ Q&& \ \ \r \ 9説_   \  #   a   T  \ A \ \ RL  1     \ %)C :[ C\ |pP\   3 |\    *uFՔ\ m J   #    /\  @ Z* \ R\ )  Z | \ \ 4>\ X >\ \"6\ 12\ \ @>#c \ b RG ?  SLm\ H  z\0 6\ zZh     K :dX mv\  8$/Q\")e a U\  \ \ K񩩤\' *$>z ʋ  \ `&  ʲ:   ?^\ -\" E$ 
(C\ @Fll    \ ׷ e# nb     L  w4= \r   \ J \ qx\ A)X\ $\ 
X\ \   eH \ \ M\ $<  ǆ c N\ \\n FCL?y \  | j  \ I) ^M  #sp 
+\ \ ! ,25 m \'  o \ = \ \   X   i\ AXZx AT \ m`w   6\  >\ E~gA,2/vG % a \r q\ rq\ =֞ee\"j  J ؼm \'\ \n  \0\Z\   06O\ \  s\ \ Q\ \  \ \ a#\' 9f   !   9ĺ  \ \ \ n  <eEUMd\ TUJ M! <   \   @$   \ N 0 _    % 6     6\    ˖\rBHb: \ B @b\ \ L [\ K\ >8v ╁\ \ cS,  HQʔ\ N    Y   &_\ \ \ g@\0E \ (\ \ UQ ޘ   E\ X  :i 0y\ ^ [  P< \ p     \ pR\ 1 jN \  * m}X׋- J ȕ    F \ ~d \ *\ D)\ Kԓp< \ q \r\n. )\ V\ H\ x\ -Dq\ V\ G  ~V %   N\ k {\r [
y\ nG H \    鄘 $ \ \ z  \ \ P\ :G\    x  D } 䓋QH 1  \ \ \ ⺯\ K RDt\ id\ #\ /\ B A\Z \ZʝH  \0t\ ;c>\\\ r5@)\ *\ \ y h˔4\ 6  P  ƙ|Q6\ \ ` Y\ QB  \ \ J\ |v c: 9\ \ AyV4  i} T  Yq B\r \ /  -  $  Y$\ :\"e  U@ SΈ\ ^j;  \ s  D $Q,bz\ f   4\ !)-}\r\ 4 \ \  E\ ;\ t ѯ]]Sp\ ҽ=) %    TR+\  I([꧓q! `F\ ǫ  e   \ sv\ v   H\ \ _   ~\ \ p\ $\ K # :E\ \ # ` 5    7\rC=\ M\ v7M  R*H .   X Z   S^\  \ &б\ m\ B   \ چ  z  \ \ w |\  ͩ \ \'\ U pYX fsfqu .\ 4<    \ 0\ #JyA Z*x0\ RSCV˪  d1\ dՀؙ\"\ FǞ\ y\ Y  j\ /4 \0 \rG<\ +Ҳ*\ _\ E   `\  t\ 4҅ \ r:u \ @a vrm  @زx ʉ J  { 7  D\ \ h\    C &  ̯O ݖ [ޮ k\ *I \ \ \  - TH\ JJ| \ G< g=   4  ݪ    \  \ AX D   v\ 2 _aA G\ O $b   ! g  \ 4\ \"\ $V\ JRt,\ : ?L{   Z% \ /\ 3     *\ %9 Fz d7Ǣ Hs:\  \ \\f Yr  ~\ *    | \ }\ \ ؖ   \0  )71    \ Z\ of G`) h?#fà w   <\r ]%<ln  b\ \ 9\ U LvoKb Q ,\ \ II R   \ \0kdO< 4/ ;   73e5  \ ͌\' \n / \ : ^\ S\ \ lލ z  EB0 u|C &`ݒ\ r \r g \ / 
 w = Zz.\ d\ ~>KYw o 	 -   \ xiG\ /i   |ƒ  /\ eҪG\ b\ J\  ɪ yr  Dd+5  &6 [杞\ b 	\ *l ד\\ P\0 P.O  3! \ K \ 2B/\  u:\ \ 
\ -\ ~x\0Э c\ of\ Wܮ \   I@ \0\ ʗFwۺ26 \'u!\ \  \   V[ \  ;\ OS, \ \ ѡ\  - ƌ# \ \\\ > yrI S 
  \0\ L ry \ \     q1 \ y\   $ئc8 G\  #F( 2 ĖX. ב\   p}A\  ( 2 F\  >)    \0\\\\Dֺه\    <E\" ۡ \ ~xB(   Ź`  \ \ 7ٿ 0E O#c\ \  \ \0 \Z1h\ A\ \ I ^_Lxѫ\ \ OߙT0  \ \ >jp\ \r 0G / =	 \ BWYjb YUE\ :O\ ⷌ v \    \ \ {\  Yo\ rH 2\ !  \ 0&*5 *j  \ d @򻤊 &g\n51 {\   o\ E	E\Z4 l\Z x L )\ \ ꩩ^4
 0$ e6\0w\0\  \0   h    er5   A\0R>   %eP %%\\  q	\  ž\ q ]K\0; mL.\ DvQ} _ l\ B\ i 1 VP ؛1     \  
O+ \ \ \ w,\ \ ዊmٱ-]8     \ [p o \ g \ \0    y \ & 0^W\n\0 =	 >8RL\   aF    /  m} b\ HͶ\ F F\ \  _! KUWJ TO\ \ л < 25a\ ]X\ \ & 6 (  \ |\ ᰭ  G  ޵ e  H\ \ 9Db\ \ ̋\ \0 ܕ;\ /oAL$jje\ I\ X  T]\n Op 	BZ\ [5\ Aqx1U  Q  eU\ ,!V\ @·  K\ ;  <310 I\'   i/ 3 p\ C{ DV@G*  - i0\ GS  1  FF;\  \ Tf)  \ ^   ?H  7ؙ \ (MG\ .\  \0G2 \ \ \ J8Fe\0\ \     $16\  [ wFW $&Dv\n i4 r}CZ\  \ \ Ōj l   k)aJs\"  \ 8\ D )A\ <s\ \ F ٱ\ 
{  q f 4ٌ \ \ TU\n V ҲISb j}GB\ l{  : M ol 0 ˍJ\ AP\ S\n2\ !   F̊UI  {\ . ]мk ^\  6ji tf% &ⷴ dILE	! m`+݅   !\\\0d E@\ i # i n q\ L &aw\   Q\ @  ÐJ %˪ F    \ Q. B    e6-n ׳   (     ̐ʎ F ]ʒ  i wQ\  n U\ / Z  )\ ;9 h  ɥ }_h)
x \ \ \ 8\0w 9y   \ 3\ !\ U \ F ET+Ҳ  eۼ 6Rb\ \ j S 3CY[QB{\ \"    A\ ^\ P F e%!  j \' j \ +⬧]ad+   o   \  \rJ \ R M {t 	f  j  \ T#m \ \ *}\ : o e$\ \ ֩֗UU<     W   \\\ \     ۜy \ {RUZ ګ  1\ 2nѥ   L n6\ \ ON \ ,(\ D \ L\ h幟! q [v o`qA$E#( VBhf 8帛4\ #?mE7_k ; R\ Y\nO\ b } <Υ2  o\ ]   =rx$  \ Ƒ]  2M	ZGg{[   { ـ m    & %Y^  d)A  <۳ XA \ o\ ̓ \ I\"\ gj *\nhr   q] O 5 \ \ 6\ | \0AQ5!   u\ d rѡ\ \ r   \ [  \ 2 E\ 1z\ \ U i 5 \ 9=A\ UH\ \0?\  \ Ji \ _i_. rN\ [qY T SW s\ qs  &\ \ R\ x    }q\ \ f\ \ \ \0#\   \n  ̲=  TK d\ 6U @ | X+ \ vO< ܯ  \ XL   z\ iVZ*`      6\  򊓩 \  j  o  - ?c SE\ <  m2 \ T  Y \ 0\ >G6gI \ \ \ \rlX  H c\ 򇦘sX\ I\ K  \ ꣨     A  H  \ 6Upo ʒ>K0 d \ +\ \ \ Y Da  Қ    ۺ\0ec\ <ڙ  \'\ 	  V\ h\ bi  \ \ z {  f A\ \ s \ \n\   u@ r  s B\ K >\'\n\ \  \ \ \ ) B# \ \   Z \  @3  	\ a\  V x{ꭉ \ ` 9`j9`ˉ,\" F( \ \ 0 ]U\ P`\ ( B\ \00UC=K [  \ ˖H\ X   \ \ \ \\ \ \ \ 9w \ j##,\ 0R2S \ [ Í\'\ 1 \ ß  \ [Z \ {7  ,   K_TԴ0S P\ \ eҺ\" \  \ \Zߒ\ \"H ]\ \ J.  \ š$SB \ Q
( P7# :  AO\ \ b \0 \ s FZ@ H\ էC
x .>Xǩ \ d  K\ cc \0p\  \ k e   C4i+ց \  U \ 9\ ] т L ]̋-  :ώ\ 4 q 5\rk  x 1\ D h E\ ;\ nH t\ Ş   E\   \ \ \ 9Z  r \ \  m xɋ   \"Z\   \\P  ]\rf`   M \ \ {\ ةB v\ \0\ ֹ  \ \ ܼp 4\ *  $ 5\ \ D\  |
Z\  \ đ   # 7     :\   1\ \ ɚ F]fh  A$u\ZM  $  \  \ \ _n \"\ \ -\    = 2 ձ\0\0\ bM \ \    ]M \ \"  mЁ   0 +ҠE # c[ \ 5{˷# \ /\ ; #     Ī\Z\ \ 0 \   \ 4 b T\ 
 *\ \ \\\ 㕘 \  * $d6\ \ A\'c\ \nB $_}  \ \n \ \    ]X@`ApO-\0 \  \   \0c/z{  c,. X\ ,   \0 A]6   Z\ lN X\ \ \ L® \ Q n\ ; kZ\ D j  {ڵ M|g\ \  k\"\ P\ n\" A \ #3\ ֲWV~#~n $    g\08)B \ ( \ <l C*\n ږ\ m `A\  \ N\"׿\"b\ ؃t\ \ 2[ mD   4\ 0  ![  D  [\ )t 	\   \ z  ͮ  LKO, L& \ g   AIҦ m{ Qr k^\ \ s\ ׽\ X1k߼TBM\ \  ] <9. &Ǜ   p \n\ ^1š\ \ )BJ\ ͺb \ \   \ 97p\ \ W.4pܱ A\ 1Їo  
\ \ \ q\ \r@` K] U\ UĤ8x\ \n,\ 8  C U\  72 \n \ j 4\ N$ M.  I  x\ [ ` 
 ;\ ױ*   IQe *b m3H \ 	8 U  =  \ :   @\ \n) e i\r=Duli㾪z,\ u\ %!< -j  < 8n#\ K
 \ [\ \  \ \\\ 7#0\ \ ߋv xW `#0 S BW\     \Z w\ \ _t B  ػ ]   K$ \ Nmri\ \ { X2 3   =\ \ \ MLtd  l˳F̄̧< - \ &   BeQ\n\Z\     uߡ  1\ \ \   ]0  \ &  F    Za e\ ?7BYo\ E;`b3\ \ IW\ DT\   &&?rSoԗ   
\'\Z JP\  ϒT.SP   \ r\\ \ \ (% $r1  d yS \ \ ̯ U\ gm\\V  , 2 u   c* x\ \ gU. \ Ԑ$U\ 4ZЁ2\ Y \ 2Q\ s\ = \ E, Դzc 	\ Ih\ k\'a\  \ XHk{ Dʮ7   g8 5T  \'\ \ \  \0(o\ |  \ 	\ `Z  Ʀna  1  @\ ׭H  F
 ɨfH\ G= `\ 9ㄍ2\ ȣ d = 4\n* 7Z̴\ T \  \ Z\ a \ `    j  \ R բR <   /\ \r&\ \ |0  [  u\ O f )\n 6E  ١ \ \r  8NE  -   5`  [_ Nͬ0 \ Y d \ \ g   c   L\ >\   E ^:   Aq{\ R  O    8\  5F\Z@ p N$  <m ?) u\  \\ 9\ kR 
 u \  \0s+   11  \ dԔ\ \ IUYQ R   !.X(\n /  Q\' G\ Շ[|pea\ >x\ < > b\ 8[ Q T_ \ 1     ZzS\  ߆\n t   z3\ \0& * 0\ \ \  2G?\ JO)$\ ? \ u\ \ 8\ \ ݜ \ @  _\'  Ϫ0 \'\ B\ 0@ ir   П\ 0 W5  ! u 8VU2 J O 6ޒ \ \ [ B  8ʫ  j a\ D \\Pz-  ~\  \ #  \0  F8 ?\ \'\ {@\ o \ \ \ ( \0\ 0\ L\ \ \ V  3++2  _
 v\ $ 4R\ ʈ\ \ \"  \    \Z ?\ \ r    \'YN  : \ .\  \  _t|* d\ H\ D    N\ 2v  \   \Z\  ~8f, f f `n D\0 F  8\ H\ \ \ 1    bӢ93Z\n@\n ʠ\0\0 \0m ʜ )
2 O\ /,t-  0  I \ \ KY,rD\ \ \ \ v \n        \ \ y  \ \  * ȎѤ w\ \ ~` Fl )W,\"1  :E  V `)n   	  :  H}}p\ WY[O \ E \ \ X \  \ \ \ 6[ o\ c &P  [  T \ \Z \ +(
 \ 67?\ CI< Ɠ\ F # \ 	e,  1*\r \  p\ ,p\ FNt\ \ * Q \ \ C+b; ?  X  \ H J]\\݉\ \ F\  ̀ _m\ \ a P l\0\ZT \ \0\ 5  ya\ \ cIdzzi B-a\ ?|k\ ۻm Î\\V +!  C Ep\ $ =DoҮG\r NȤ_\ -m  \ l\ C  kn    4 f   ߙ%   ,d!r ԩ<)mpd\ qngm  5 ZV^ U\ 4\ZE \ \Z\ r\ S \ %\ \ &S< pcy  # N@2  `	 ܶ \ !ͤ \\    \ \ ( r< X 54 D    h  /abo\ p\    \ _\    \ r~\ т  0f,Yڔɽ ͥ \ ~    \ \ \Zj       @\ Hdr  GH\ ۟S\ \ Q  * `C bu	3   \ \ 5ah\ 2\ \ 4jCjR\ |\  N\ e  ^z u\ C\ \ P]:V  \ \ \ (E]\Z	 N\  +X\ q   ±m]m \ XZ     \ \ {\ \ Hy -D\ \ ֽ \ <+r\ \  D4yu`K\ + Yt1\ \ {\ =np \ mjӳ p\ ) X\ \ o
 d \ \ D   *\ \ y {o U \0U Gl  (  *,`Gh&\ H\ :b\ # \ \ $! B  
;\ B\" f\ 
OSMN  J  ,P ݉ Ce[  y\ u     ^d \ 	 w   }C\ }   V  [ꩧ   \0\\  \ {\ S
\    V tJb  W29  U@ \0 \ \r   \ J0 \ A q   N  \ \ c dm\ 3 \ gβe\ R\  a  \0\ 0_Q\ |  \ Xo   @    n\ d\ l\Z \  #  \  lZQɨ*\ S\ \\! Lp צ d \  \ \ /L4 \ \ Q0\ t± 6 \  V\ \ p\ \ (  ЇS ض  \Z p \ \ \  \ u  \0   } ? \ _\ \ j -MP a E8\ [S\  \0\ \  A .  <u O\ \ 0űR  @\ \ ӂ[\0  \0X Q ʁ\ qi\ \ Y  #\ \ \n 3  $ҪF   \n   0\  u     R =\ [\ ? 9照 ˲\ c  hKOP ɮe[\ \";+HN A\01\ { ߐ \ T @\ GQ?I  |X\ b z \ 0 M [\ ʵ \  O44   JZmQ  \ P  ya뭐U > _ \  \ \ \ ̭ \ $ 7 dU[ 0\ n 1  gh  ZDp  r\Z0 cʵ  ;^\ c\ ,&T  ,R{51\ \'\ K   \ }  \   J 8\ U   \ I  * Ivm[b\  \ . V̞\ \ gmI\ P, \ C\Z\ eYY\ \ WI.\ Ǖ   gl2 k  ,2\nE E $pK   \ N\  \ 5]mDUT\ng\ RQ\ V N  \ B\  \ z  $  Z9  L # \ \ mZ@sA6  = [  ܨ ϥ j a-IV 
 + ;   V\ o  \ \   Ytk
;\ \ D\ Z  Gb\ \ +_  \ @c\ a    Vi \Z   Jd\ \ K k}   \ ǖ6e\\ *\\ y
2\ YR*  \ X  E u c ,0\ \ & Ĵ dݴʤE-\nIp\\;5\ ﶛ\ =  *xg XѪ	  8d $  _ 1פ \0:㋖R Q*     ;\  -\ l1l e \ \  I\n\  9  D  skX\rω\ ڽ   \ WO \ \ 䪬  h㆖X T\ \"%\  Fc  ;  / b\ w<  \ \n4\ ]VD   
Q  \ s &\ \ S \ \ H%   \  ; hc`5 Z\ \ \ x_W\ \ \ u 5!] h c& tb \ < \  x $\ \ qu pw \ ?\ +) f    X    _M U\ \ \ Uz ΤY H&fI  T J  >b\ \ \ )  &    : 9)   \ 9˵\ \ \ \ }\ W£-z   8&y& 0 )Q \ P#Qb4 $  ya  T  (\ \ \ \\\ \ f \ \ \ >a%\re.  \ :D   ] \ }\ l\ j B\rߴ \ sa\ ᤕ      2* ,J #vBG&\0 t i%U#Q\  1P Q\ \\\ G  \ Mͬ - \ d\ %cUՇ >\ j   >22  *x^g1 \ K b4\ \\ `\r U-B  른Y#ᓤܮ s`~~XϦ \ :\ F\ \\U Dr> gB @7  Ł i\ D vk k o \\	\ \ \ wZ\\%v  A f  B\\ \ @[     9 HZ V{ p 6@\ X  \   o \ G\ P\0\ a \ s<\ \Z ʨ# 8   p\ j[\  \' \  > \ \ *s +\ R  M2ԕf\"  \ \ \0 9  R\ C\r]LU\ ҕ$n\ h\   \ \  8\ 5  +\ d5* fwr HX ٵj \0 \ q      HiE\ r\ \ y  Y!jh\ @\ T\"\0} \ |j\ RU\ r  \ g%MusOQ2 o3\ .9 %\ N m뉇 [\ \    !:LJ 2\r* ; \  $O[    \  *y` ESc    L \0TR> Y4\  B\  8r PD\ Y\ }K\ t, V 840\ !ՄC{s   \rc    i  Ԡ,HEX PzĜzd A\ _p-\0 [ah  w  \Z\0bo`	6 \r |\Z\'\ \ %\0s2&  3 R * TFZ wV\Zd  \'- \ A 8\ j V@  4BC^\" Iߛ  \r 
 t `\  6 m  1 Nm\ E\ \ D V%b\ \ `	 # 1ᪧ\ \ .XY u&@wò\' E, 4\ far   s ׸\ ͆P\ \'\ c}\ M2 N -;Yo\ x x   h  \ \ ̌ԃ   I#b\'!Bpc\ yj\   FT   \ 6\n      
\ \ \ [- nw  \0<VΠ} b\ \ B k x\ ]\    Y  RW)\ ~ \ Uy(\'T6\ S\ ?C_\  L\ ^$ 4!r   < ?5\ Ai4 :   \ 6\Z \Z\ Х K Me\r,Ѫ  \   N E (\ <y#*+1\"ʥ 6x \ >\ V   QnZ\   \ \   0 ֭[\ 6     a\ bԖ\ \ #  \ *̺ . \  \   J\ I A) %[ I5\ \ 
  \0 d\ 9%\\ \ : \  V\ \ 	\\\  ˓    [\ \ \ = z ̌\ z FsL1 I$   ʃv\0u\ \' Ƶ4\ \ {q  x  \n    [\  ߕ \ \ k1  ء(	  \ 0  \ N3x #kZ \  \ \ \r Mϴ\ C\ \ T4Fff\Z˝2\  \0  ?<*z Q\ -  n FI8 \0z  <4\ C28x\ ٶ;\ ~  M QP>\ } \" ~\ 6]   \ s \ \\ߡ \ Z\ \   
\ <    Ө(\ r\ \  ef\  u    \ z\ }   В,  5 4Y~ \ i/ % ^ m  ` o   \ \ \ ߑ DD 8Jj .P\ f] \\Iu #\ ؋)DH\ B_y$   - \ \ \ YA 9`PFk c\ K      A}\ \  w	   \ +\  G\ ʚ  TG\rqSJ H \ q\ ᆊ+К  Y    \ \ okwGL}\"ɢ\n 	 `\  lOK psKٗ P ?~8 \0 db% =` \ 9\ I #\ \ \ Te{\\ \ Q ;\  \ 9y)2kI$ u 2W] U   H\ ԎQٙ5s    \"\ ؘ \0 ݞ\ \  h  [
F8  \  +   ח |\ H  ާ \  \ Ll -a    S\ Zl   n| \"L} )\  ,VHE Ƙ  \    \ H\ \ E\  g@\'\ \   \ \ { 憧7\ y3\ be&\ \ %B E 1d[ `Cy 7O {;Ѻ+ޒi\ Mt\  \ ȱ rot m \ q\ ?b H<,҄  - o\ ˁ a\ EgT̪5\ \ \ 	1Ib~>  5\ ` P ,- N C  v\'\ t\ \ k\ Tl m\ |v_   MP \ \ \ g o\ \r \0 G  p\ :\    v j \ R \0   8Ti `/ \ \ [H  \ @\0 Öߩ   \ \ ڪC\r͍;(>W@q\ d_v \    ?\ # a}_  Ϣ^g=\ g . \ \  c\ WHn=  \     Q \ \ 3 Ð  \r \ !\ \ \ \ 򷳒M   =\ %\ ?\" \  }LW   (.:  \ l\n(\ *f \ ( \0TM  ?<tC ݤ  _)    m \   \ 3 N \   I  Y6}6   \ q \  ~ ד\ 3\ *\ =\ \ H\ _ x Ik\\۞&	 =\ 1   \0 \ a p אk  h \ \'炠#\ \ O  \ ־\n ͱ| =   I=\ & lFV  Ϟ*  m  C-\  & (,`. T c\ \r\ k m\ Ǘ,- \ f =p\ X\   \ -mrCxX\0\ \ \ iC    \ \ \ \ \ V׿ ( \ \\  \  6 \ \\\nR 	 X i    \  ,&  \ }ֵ\  \  \ / \"\ \ 
F n \ ~G
KKa\ H`7<4۪ q\ EQ\ $n/   \ , \nH ʣ  F z  \0\\z \ 6   - V*  W ? \ \r\ UC \nw\'  o0\ \ \ f t ;Yl X t h\  a$ F`Rx\ \' R8   1  H \ \ 7\'\ \ \r B  i*  O_  k_ 2    Jc    X\\  \ \ 	?L4 N\ E\ H\ \   ob9 t\ F  Ɋq2mL ፬	&  2~ f8 p5 c \nƐ[o K =  w \ E\ \ u أEH۽<W  \  \0 [\Z   &\ Dzbq{TN\ L>zo  J\ s U+ 7  P  9&K \ i  P  G ݁ I,\ \ \   U\ h\ \ \ Q\rr \ 4wffnH       -ǮS\ *I?{Cr\ \  Ղ8>\ A[2̵\nŷ\ := [\ \ w    JͿ =hq~^\ 꿎3s t\ n ; Ԥ     \ e3Ψ   `.\Z\ \ \ - \ \  \'  :T @U \ X[ o 13Z /\ y fTu Ȫ 2 \ \ \ Ѥ  &\ z_ \  <   \ \ JY R S 5\\  FAKtF\ L2\ ɪ  a  d K  F ͔\ h 4ڮU \ *\  p\ ŗɨ Ik\ cx  F\r=E \ J  Hh\ ]\ ks\ [/ .G ӃqrѪ6 . \ 7.bģ m$\ \ 4    F/k 9\  n (\'Ǧ+X  )\ \ U!P@ R  ]h) n\ B@\ \rMJ E  d_ J\ c}p ۼa A\ v\  \ \ \ 4ox<S   1\Z  <t\ K\ 4\ *ci\  OP^ .Lq   f\  T\ U n= -\ P[\r4Y \   \       ,6 c\ \ JX Y| \ \ <  @\"\ ]O \'T m  x\    \ EږS\Z U2\0/\"K ,ؠ  } \ * \ ~V\ 55  y]U \ n\ H   p \ 4 #	\ #;  Q+\    ~MR|W ?\ \ ވ Ei\ -\ N >$\ 
 #- @\  \0\ m 67   Ȉ  : \ b;s   M CR\ `P ck\ ۖ )o    5   E   e\  2=Fأ4\  \ A g 4 \ 8 \ ֫h YR.\ BzT / jN\ N  \ È h\ \ D;t35\ \ F\ y \0=L )n  \0> !ƫ \ [} \n  c~V[   ˻QU  \' &\"\ Vh  \  \  c      <H㔅uK\ ߤ{ \ \r O&\ Xuf\ < 8 \ 9Z~β٫ \ sm\ 5 ? n\ 鍪\\ 8F jh S\   > n\ \ \'Zju\r) }\ k eq WWS8dSÈ\ UOy +;g   %Еt  	 \ \ c ٩ \ 5e\\\ n 3 0E\0* &\ \00s ߦ)?Ш \ | &	 牂׀ 7 q \ r\ Wϟ  \ x\ \ S \  q <T% 3< \ R\" \r   ۝      [u   `\ ַ.W\ ~  7   d\r   jI;| \ \ p [ M n\r 6 , .\ \ }\  ˂\ 2 +\ [\ A \ j&V ?u[  a  +  ;lG  \ (?C\ A\ ]\ Ķ\ \  ?L=ѵ  Qe T^  \ \n \ \  mB    \ \ M\ ޛ ^\ T \ &  =\ Fރ 0UpFқ\ +  ` j\  yK  K\"  \ \ m. fe
k݁ \" \0,  b\0T\ ׍ G  O 
u69 ,[QR#  u  A  FME\ wZ\ t\  6% \\    \   vx1\0\ 5ZE\ \ X 0 Bʾ  \ \ \ 0(ᆗ  ! \ m  @G ,D \\XJ  Xe : \ <\ u  `l<v\ E \ ~sMP }q r<\   \ ~	\ i  j^E\rgN Q x  \ ;  y\ ˮ\'Bf\ \ \ $\ \ / x   \ mZ)$	)jc  \nC \0   4\ * \ \"W\ \ \ \   4\ lH S\ V\ yH&\ \      \ )\ p\ 7 P  -\ qZd ew  \  i   \0A\ M   *\ \ w\\*р  mb\\\\ۘ l! \Z(\ = Tzw\" Y8cǸħ\ ? \ \ \ h\  -LF)O \   |N7\ RÎ_ e  U\ -Sp\ s \Z :ݶǴ\ v M#;\\ ]\0*\ rN L\"ٴ  j   0   \ j#\' \ \   * rc  Y\ ݖ \  T   I  n  .\ \ q\    \0k  :\ UrD`@ SFх  \ \ \ 翞 \  -!    ai5\ q
  \ #=  9c\ \ f B\n \\ h m    }q\ n  5\ \" ! \   ;\ ml^,\ zQɗ d J   .\ ݘ (u     ?glT\  (qncM~F: $   V@~8 \ F\ ـ\03 7`y鋬 \ v  [\\ S   b\ (>  mζ\ \ \   g oiO* \0{M*  E\ \ ~ q\ \ ч/ \ Oe$\ZZ ae< \  a \r3*(İ6;\ n^c\ \  [ PI\    \ \  # LC\ \ \ \ ko   \  9\ FSU f0(  q  íԃ  b\  6g R\ KU  \  \ ]  Y \0 f ^ D]n  \r\ #\' \ \ Ԃ*))#  C\ \Z ǩ\0  \ ؖ z  b  _F \0[ \ Ԫ<C1)   2t  KyxolD    p ) \ \ oչz\ \Z  } ID\ A\ `&  M \ >`\ mUQUUE PU\0\r  F Xᶖ\  ) \ ]T3_J ؎]\ \ \   ð\  D %9 F\ \ \Z<   E  \ Ǫ  /Ϧ! 个\  \ \ \ \ |O,0\"Eݍ\ \ \ I2&\ \ \  \ ltx ƛ  \ eRZ m1\ C\ ay$v7c  X
= <     33f\ [r~8] F<  \0\ l] Ǟ  2 \ 剁\   7\ \ $\  \ <&&$ y!h Ҿ\ \ZԖ;)\ a  \ \ l7  y\  \  \ #\ ɴ \ \ q  i jSe  t V 1& \ m\ 6\ \ \ Xt 3\\\  a\ \ \   \"Yu \ az\ p111  a \ t  [\ X ox y; 0K3fw[ {B X \ \ bb 2\  Ig\ \  .5 $ \ qy  C  N׊\ y_ 7 bb`%  \ ( j\  y \rk< \    0E&G;  q} 112. N \ ! #K{ ُS }p en\ 86m  ؏   k I\ <1 \ ˤ #  \ 4  6\ k\ ㊤\ c &W \r\ &0mr bb`\Zܺ\ $@B  @ 
 ^\ |_ V1#\0 \   G \ \ Ů $*nA]E\  \ @\0 as\  . pL\  \ +\ PZ\ p  \ \ \ \ \'\ *g  Fy\ \  EM6\ ܐ | U\    ~\ S\"Zj Mذh\ \ H\  \ \ \ <1 [ ;nY\ G-M|\   s w%g q ;Hbt# \\\ 5   \ \ *z &   \"  ~,
A# \  \ bc  \ F\ &z  ~\  vX  j a\ hk  (i)# 
F\ \ H\ ^\  \ o \ 2%V\ Q3\ mCDd  \\\ ǼO \ \ N  \ %lІ \ne\ Oq \ X  g\ pM-\ 111 \ Ipy  & \ a     V  鋐@\ m\ \r 10 ĥ g \ ,*[ \ : ~8    eH,  LLY\"\ [\ mX  \0-\   X  \ N  LLL2O \ '),(2,'Gimnasio Municipal','Gimnasio equipado con máquinas de última generación',2,4,'987654321','06:00:00','22:00:00',_binary ' \  \ \0JFIF\0\0\0\0\0\0 \ \0C\0  \n\n\n		\n\Z%\Z# , #&\')*)-0-(0%()( \ \0C   \n\n\n\n(\Z\Z(((((((((((((((((((((((((((((((((((((((((((((((((( \ \0\ \0\"\0 \ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0  \ \0\0\0\0\0\0\0\0\0\0\0\0 \ \0\0\0\0\ O(\ \"#/@t0  N#	4\ \ 58 
 \ \ 0  @*\ \ 5\ \r$ NC\\ Z\ A Qn 3 \ 4܊ Oh \Z   \ bC\ d  J  J\"\  \0 @% @	\ $kPB $ .p\ =\ 5\   \ *H!	!)*sHR\"D B
vn   f  AH# $P m\'  (\nJ B! D    i \ I  j!\ r\ nHc| E\ 0 \ \  1=SRl\ ţ )  \ &OC F F\'  \ X  \' jxV   \ ar\Z\\  !  0 1<C 5  -  z@ȋS BI\n8 $$  (E\0959\0 \ ǒ  $  Br (      * H    \ QIJ \  8   \"D  $@AI\0   ( \"IZB\"\ H   \"x *=ɮe ^ ^X   !\ |\ h\ \ \ .[\ O4E#\rj´\  h\ 鴸\ \ $T\  0 ODe\ ` OP \"  \ F   F  \  F 	F) \ k^\n   BD  H\n4 4  
 4  K 	BE8\0  J* HR* Hp B(  	 hK\r aD   5F Q\'    	 r\'MZrB RB($ RBH )Z B)@I \"RHQ\' R \ n\ \ =8\ \ \ \0 < \ o rz N \ (\ X(\ t A \ \ ^_F\ 1їjy#.C\ \   \ H\'  @59Di\ H\"5(X      J،H*  $F\\  $i%Z   az\Z\\ \" \ RD	B(D  HI\nIRH$\  n\ t&t Ed BJ f D+ \"v+\ \  BE\"H  N U\Z61ɴ    a\     $  HE!\ QW\  \ u P\ nq\ \ ly \ \ q \ [R\ \ X  \   5  rV\ \ \   #/C bz 5 \Z  \'  \ bz ː\  C\ \Zz#ODi\ J 0XD Jx]\ \\  ! \ jzF  \'\0 \n  @ PR PH\0  qi\nHH!ɤqc \ -       ,\ L˯ 5    ۳h q      m K%.\Z\\\ az\Z\\Q \ t   f\ & ̔  \ O)H҈\nA\"Q Y  N㡹٣Nig\ \ q     ]< \ ;\ jKV c%\ 7Zk   L\ VS`|   NC\ \ \ 59OC \    `z$ b   bzF	    J\"&N+?     bx\Z F\' bs ̎HT\ `m   V\ TQQ]QI $\ }  I˗&   4 o   V  :$ ^H )  u PZfmUd,-  M   \ Ȥ]  P\ \ ^Br3u\  Y\Z   1=S
 4 SK 	H !{\n\ %Se\ I\  0Զ 4ړV <\ ;{\n  $  \rf z $N\ ϟ8 w   LH#S  ;23   cS \  48 NCC\ \  OH\  OS \  F    5\" \ \ \  0H Ġ     Q \ \"g:   T GUcY
Y+TFR\ &R\ Y\ K t o  n      \ 5\   pr   B)\ (\ H G Q L\rצRl  \ \ P\ zT aH\"@ 8PN# \"t !t \ zK3\ %Q ʪ  i\ 6 j   c = |rܿ]\ \ 9 \ I\" \ Uu}w\ \ =\"  $P\  ǖ\ \ & Ӝ ZI@ i)B( 	\ \Z   %j%\\  茹\rC\ \Zy#R\"5\" \ 8Z  \ ڮ  J\ 	A  DD&D\r å|  }
=  c =4K\   -hFRV#\"+  \0 JFي  \ \  Ҙ Ȉ̈ ȑ DFdR\ %U\ W)2f dJDF$C  J #) L\  3  |\ + i* \  )i  N!g\  GI yG    8˝\  \ R)   %Nk ( S\ |\ \ ls \ \nH% 8 ~\ ^7v\ 3 \ u R \" $ \" I\" ( \"   %B(	\ 	\ \ZI\Z$\n * T #s\ \  1<+S \0\0Xb5r9\ d E\ =\" 
 _C\ \ \ ޻si\ H\ g\'Z; *\'I\ Z[h J\ \ \"\ \ 1 ض 8     x\ 0L \Z  \\\ \  \ bz$V0  23# \'=\ F\ (E*NrrD\"  /  L=\ * \ dr\ W \ \ r{\ L LH\  C \ >\ \ >]\  A \   $g3\ \ K  >\ RHI(I\"  T HH   @Q( i$	\ Z F\'  H āX$DQYI [m \ E X\ ݆\ \\  l  C+ \ m r\ \ E֣ ]7-R y }J\  \ R 4*n  \ ;\n ~\  Cd I	 b8嚷5 \ <Ý:\n5,\ Ta:	 u3k \ c$ Yu\ ,q\  K!ƚ  \ \"# \n0 S b Q4  5% d\ 5FVm  2e#^\\Rt y+  \ \ \  &/L \ 1#\\) \  =\ 	\ [\ 9 \ \ N	Mk1 k  .վs ] #rBD   	@ (EP\n(\ J     (  \"T$J H0  1<+S \ \ 6  $ Z\ <\ r\ { XbK ɮ/\ y>  4\  C#V\ \ (\ ǵ\ ɂ2horZ  G \ 3x\  렖x#%K       \ \ 9\ 5|  \ 54r -9w /.\ \ \ \ \ \ H[\ \ \ ѳ IўiKюq\'A&^ \ \ [ F n *\ ^n \ \ M  \ b \ \ \ \ \r\ ,2  KR  K\ \ h\ 9  W \ dc d\ `s^  ZҜ  \ O@p6R\"I\ j\ K   D )R\"\nF *D     Q$9DQF)ADj(jr  !  X > \ \ \ O  tP  Y/& F\ ` \ qv-W  V  \ y\ u  I \ \ ӳ3 \ \ \ t  \ +\ dٷ   e  \   \   ]\ I\ tŧ&\ ]e d	 [ \ iy % \0	\0/ \ .   u X\ \ gQ \ \ ְ7[7 )cu\ u   %eZ F\ 	 B\ \ PAn ɪ]ͱ    ˲H 8X \  \ b.P(Jr 5    $ .3( \  e\ 2  \ \ bH  \"  P 0\nBH    (  P \"( \"\"  \"H\ @)6  q\r[4 ` 6  [ %-n[ \  6O\r\ E\ q_Vz JU R\ ( \' :5y \ 9 n> =I4 \ ϝ)\ \ ڱfm\ T\'\ ڣ\ 
\ \ \ c  ^\ ,\ =9  \ 9r s/ \ rvr  4\ b l\ q\ C   S\  }.nV}\ sS T  ܏gc  # - sV 6Vk,NZ \ N D u 6s   bC4; e=|u\ 1˼4(sM(\ =:\ V   \  )\"YՃ O^{=q%aI	\"\"\n P \"I	#	\"  $P\nB( \"$   (    \"H *@)] Q    ,F\ [PEp    \ N{ 㢮\ ձΚ\ W%d ٱJ\ 9ftN s^n \ \ /k  \ \\ћ \ &   \\}\  \ }\n  ҽ jہɡ\ v\\\ w g7O <  V [ 츌n  \'\ \ \ \ ʈ \ \ e\ .nsU  \ ȩ\ Co  \ =_+\ e\  ܯ] %VE=\ y6 #u#I%  \ \ d\ Sg+[\Zւ\ <  O_y\ \  \ EoY syc^\"  TG+# \    P\ 3c\ \Z &  Cf \  w%I \"$  @ p\nBH IA  \"P B) \"  B)$\"  BH $T  \  m
qg xr  j    vsu (a  vı\ ZP \ Xd  F   \   m _5q:\ U\ {^7[\ {.7 ;_ \ 4 \ r] :1_\ b  \ \ wk\ @Ó
[Yۡ H  \ x\ }3  $ 9Z     \ [&%t.\ nӛ\ 0  u A\ ~ [9v е\r \ ~ \ x 5N \ K ͹  EU   k7O:  \ \ [^\ {+ = \0\0 h\ \ o-l   H* \ ݾ\ \  .\ \ O \ \ \ \\
  ,\ 5: #Q#H  \"$  J B)	$\"  $@H(R* B) \"  B( $$  BI@Ic ,W\ \ Ո7:ܧ_ \ {<x+K <| u8Y E w GC }\ ܇M ZC7N[5\" k \ f\ o  ڞ \ t\ Y\ {sp ~_  \ \  \0Smc赛 \ k\ ;   7o Y \ \ E   - \r\Z гRt J\ δ 4   \ }3e Z6\  Wsii Vl\ };  \  ޖ    \\oS ;\ ͎j:s  \ _  \ \ \ \ L\ ,8 \ J\ mۯb Y G  W\'Sq \ $ F \ Wz   +\ \ C Q E$  	HE     B\nD)ID8  Q   J DE\"X    H\\/u \ 9\  =Nl\ ī \ y Gt = =\ ÷^\r   \ \ \       ;  ; 溌\ \ \ \ b\ 6@ S2ϟ\  \ \ \ &\ \ x  6; { \ \ k= jo\Z ]s\ \ ̎]\ t\"Ϲ.RtVX F\ : Ȭ  \ w    b8>h\ F\ qx~ =\ \    s{ \Z:s:gz`\ \ .\ ׫[S\ /g*L\ \ d     .\ \ qQn   %\  \ #K3GR\ _   %CS ,^ \ \ \ \ >ǹ 
 \n% qaZG  P \ \ \  \ K\ \ \   \  \0\ S HBJH(PT\\\    V \ + &o;\ p \ K Se  e➧[	\0  \   \ \ \   [P\ T s\ \ : } \ \ \ \ \ 4j F \' ɽ jן\ \  \   &?Y\ u  \  , \'  X_. R5;\ /f̼ K, \ w> \ z6P  m  {  \\ϗ  \  AX -0 \\  o  *X\  lhc| HYh[ Y k b;ۜ];~6 u  ɯO   GS Q\ t\  ՘\  \ =   \ z\ Z\   \   ق\ ~  \  \ q\ ݥsK \  R &\ \ Ǒ賮\ \ v  5\ \  j	!,0\  1 {@9\  ,XLC\  K \ yc \\%\ \ 5 Q 5 j \r      r\ i    \ i   \ %  t8͚Y\ Z\  \ \ \ [\ r׮\  F\r\  1O \  s 1v\ W \ ѐVfoK͛O\ b3-se A  
4{
 <\ \'\ )\  T\'<\ \     \ қ\ 鸭 o  \ r 8 5Z 7 \ K2 \ mA *̑ 4 \  \ I\ j ڙZ\  U  J\ [QĎ  r}Y	Xt $Y\ ϚY\' 裙է?L\ Wa竐׹}T s 3R\ > ֯n$\ wi kX  nfiT   	+j7 |\ N\r5   U }!\ :\ \ !  \  Ƭ #8w \ U\n\  կA\rx\n\ |+ \ gҌ [ jl\ \ tmh g4\ \ :\ Z@\ }µ\r  \   Eaǔ\  O \   \ ds:= e;  ͣ  \ \ \ G   >  \  Z 7~\ \r\ q\ f\ m | \ K\ ɼ -\ R\ .ڷRN ׫ \ \  v\'o3RC  T\ <   \ \ tu /\       \ Az K,       [  \  N u ,O \ 3Z  ׾׀\ \ [\ =  \r\ %\   cf\ 3C <7 c q E   ,܉\ S\ ΡߏOC&\ 5zMwR \" ٹ \'=\ m\ \ l\ \ W;Q1 d  PO_ . \ |\ OZ6 3 \   R\ 1   z  m\     \\\ >7    @Y \ \  \    ncʺ Wv^ǡ \r^\ { \ r\ \ P˥˷j\ 9 \'  φ \ Cë;(y1gQ4    6  \ gEeO\  \ZYz x   ߣ P ,\ g\ g\ \ _VoEZ\ \  r 2\ E    1ϻNy %   7
z u \ chKrE\ \ \ y\ | l \\\ ]X   zL   o][\ \ ͖ . (n
z=2 ʙ+ w  v:ܦ  oC  \\  J\ % =B\ \  
% \   J- & OWU8  H\ \   \ e l\ jom ;\ h 5q  \ \ Z\ \ 3q \"  \ 9   2\ ^Z \ ͬ\ \ \ \ \ \  \0+\ r  \ \ e\ nx\ \ \ ͜ \ \ f>}{\rL Y8\ īv \Zݹ G	 c\ ^  \ اw \ZײDȊ \ \ \ _k  \    s x܋! :\ \  ʭ\'P\"f5 \" \ \ Pcq2ٮxw  G-׳F\ \   זΗ1\  o \ G   ~PEu\ \ $P\ SMl  ,ږi \ }}\ ,oFjҜf ,    e\ \ \ \ o\     \ 9v+2\ NY.v \   \ &\ ы  \ KFXݩ\ Ǳ  \ _	\'  ݩO   W\ J\ \ ䷣/7C    ~u L l   \\ 6z*[둝o  =-< 
̮Gu[ ͯO \   n\ jcZ:x.\ r\ s\ \ \rc?r \  1S9\ B \ C]  {    S \ ˺  1  \   [ n  \ ϵ 7  z| B;\ !\ {< = i [   [ @\ k\ \ \ \ eiI\ M~  s= YZ\  \        bs  \n   ҹ \ \ I.ܐr   c by Ġ \ Q\Zx\ZlkgX\ \ 9\      )  L8\  \ \ 0m|  \  =}\ @-  (    jK:A_.   \  \ \ ʷ \ \\\ \ ͯ\ g\  \  s <\ \ \ ݯ˧y\ \r{    odku\ Cx J  <\ \ U \ \ <  du<?_     k  \r \ \\_  zw޷\ \ \ b\   \ e˙\ ;\ \ ٻk 곩 \ 7\ \Z  \ ̰ (o3 n ; \ wϺ\ \ z\rL\ Y:x(qKw 緍=\ 2\ ˴  ̾ .\'mǧz<\r\ ald{ ; gg\  }{   \0= >\  3 oz   w\   T -f -*3Jz ]\ #\ \ ߵ\ \ t\\ \ R\ _ |ϥ V<  g\  \ B e+ <  \ \ \ \  Y#\ xC@  ,\ 4  }^PR  \ HD \0(D B(hsew]\  ;\ Z\ \ \ \ v\ %\ s\ ~? \ =^R  \ kY \  o\  \ \ \'\ f\ \  = \0;-&v\ z }O7  kz<\ P L j\\\ >  \  }\n \ ؚ̜SM\ \ \ mhg\Zܯ   h\ ׫\ + 97 og g>  \ y \ \ \  + v B\ 9\ \ \ =o3\  \ 9 {? .  庯/  \ \ \ - i\ \ ; ŷQ\ j\ L V\ \ \ 2+ z n\ 9~ \ \ 0y    \ f6;  ܖ!b 7 f  \ \ ?ms \   z\' i7  輪  \  \ \ \ c\  q\  $ O  ]\ K G:OO  \ :\n|{\ \ s{|  \ osҼ\ I ~ δ /C \": \ \Z\ n KV  X  [?R k )hJ\ {X\ \ Lp X\ e ?fE   K    \"kl  \ !   ֆ%\ ş =U w\ \ %ۃ 4)9 IJ\Z\ +w0 \ =     < [˭<-\ /G
u  c\ >QJ\ ? \ \ \ \ v ^\   )  \ \ A # \ t1 \ \ coK \ yv \ { ]\ :n; )\ 㺷 \ ZX$s q \ boԼ\  ~<ڻ oP N̵ }\ vp \ w\ \"\'\   \r s  ]  = E\ t?;\ 񚜮 \ u/ms\ P\ \ }>](\ \ \  . K l \  o\    \  = \n   \Z   .  \ K w+ \ s     츉.yߠy\ }c\ } + \ {\ {|a ގz7 v _Gk澋\  \ Ǡ~ \ . RB  < :7\ \ 9 \ n%;   ^\ \ tm\ \ \ ]\ L:ݯ+ Gz  \ Nw \ 2  G\  \ ЊO?i vrsc  <   
-  \ (% n Ԝ kx\ !}/ HV @HAi@  M.  \ w\  %\    < Y ߆so  <ŷ Sɩ_\ \ M  z  gY   H $d0    ܎ i^  o\ \ \ j\ V1\ m \ a  Yۏ( <ڴ뻇 	nhgX\' \ 8M\ 7 <[ :_o  \ < z!   \ \ T Ƿ5\  5\ \ =+ͺ\ \ l   \ M\ u=  %\   \ vu \ sG\   t+  @p s J  $ ٹġ\ K-\ NƷ n .0 ~ޭr  \ \ EO \ \ V\ .  J 3{ ]x u    Qҳ 4Q\ 1 } @ \  \ \ ,\ \ \ i\ \ N  \ \ # MU\  ^*w  fp v  \ 9|о   \ WV  \ 7j\ 	I VHe    &\ \ 8  	әAQA!@  j     \ xwǩr ͞    W \ cr~iK    G\ G_ H \ r\ \ \ pZ  j    DPO K \ sR 䄑\n  \ j  k:}V\ U q :\ Rk   Ϟ\  \ \  x \0C    s\ \ 9 K\  :\ o \ \    \ ~\ \ \ \     \ ^1ˋ \ \ .\ \ q g   ga\ Q2ٳ/[\ u8\ [WH\ H\r f\ WQZVjѷ/\ q  !  4l`4ݏ- ]Y  \ z>u\ \ / \ \ ,: +  5 2k,\ \ s    3{fi   8t   \00 ۣ i \  \ \'<\ 6N\ C f 8Gb ޮ  -6#-[\ \ \ \ UfY Vt \Z\ v\   	 \ `\ X \ S\ $ \"\r\"   AJ lt\ zw p\ \ \   \0yîg\ pY\  d \    \ M\ G s  \ &\'G d+\ Zr\ ^[ \ # ïl K`    &(| \ \ ߎ\'{|Z kɼ b \ \ \ \ 꼖j i3}~k \r\  }     ].\   \ \Z \  >  p\ \ [\  z  \   %\ - \ =GG FƧE o[?!\ mr]a\ \ \  \ \ ct 1  \   \ ;gK\  \\\  >F< it Z[\ Ӟ\ \ \ 9 v   v܉ o  n%  k  $  HU\ #\ZMUt\ $  gg\  ^+  { \ y\ \ \r 	ᐎX\ W\n:\ qK  _N= \ \ ̠ R $   
Y)+  ; ڱ\ wU \ j   \ !\ 7w  ^?N vO5\ g \"^ ? \ \ d\  U Ռ9 Mt  \ * 8#2  s   ެe
u \ \ \ ZEwJ  -G  \ u\ \ \   z w  ߓs 7 fӱ ndu\ \    
1,Y \ |\  70  G ²    \     [x    a \ O4  ҵ U厇   $Y  r7   \"T\ ԓI\ \  \\\  м  *i \"GVaq\ \Zj \ K   \ )HI!$  \nHH
r -\ ~4  ? 9>kO.<\ % Hxf )B   \ d 2\  ׭ \ s ó.\ . ٮ\ \ \ +dh8\  \ 7\ 4	\ N\ r2o\"\ g  )\ $[\  \ |~ n\' \ l\ )v\ $ \  O1\ \  <Ws\ \ Y Ϟ  8:㰇 ~ \ eW m\  ܶl2\  \ b&]!  \ x ~uc  ^_U Z   u\ ޣ+ \  3z/,\ \ t\ tFd2\ \   U\  \ IQc m꺱\ < \ ?/\ \ T36`\ \ r}  9J   \ ;x{KŲ\ ԂQ\nD{ D .-2 \" l \ Z /5 g\ iH R \ZYQ\  QC+ G1/EZ2  *+f   \ \ 2 z W  \ \ /c \ ne  n  \Z4VQ  sV  I, 樚\ \ R]V \ ֽ\ \ \  =\ O9\  # \ λmɩ u_ ygR,o   ;y\ ߧ \\\ @\  \ \  ,\ CO    z0 \ Ӑ\ j  V9,\ ݷ\ b\ y     5\r\ Iq\  q \ e \ \'=  ]\ s\ W\ c *I> m  \ o3 \  <߶\ {  ^ \ \  {\  \ |\ HiYIM | n߆\ \ \ t  Vm \ m   } \ 9X\ \ q\ Oo\  @\ { )c$ ώ]] KP\ l  8EJ\ \ \'4\ \ #%  nC \ \ z*   )\ ɿZ2L \r\r^^ ҳ  kY  A  {3 \ \ M \ ¬mh t  Y\ F  6 \ @\ UL\ \ B ]\ y    \ \nh ײ  S     \    Y\  \\7] K  _: y K\  $ c\ \  Z   \  PW\   k\ 4Ԗt\ \ +S \ x:\     qyN  VG#e <\ C \  Yu \ \ < ^  m	y\ ;: sso_^fn   z  k  gGc =9  Y\ MF  ^\'{:R *k_\ L WL ,qX  \ gK    @t `ƻ  ֍ x3\ \ r E\ \ d8v  <\ \ y\ r Ǚ.  q0 饗CZS6 D\ \ z&iō   H\ X #D9   @\ йl\ \ <\ 6|\ Ǫ ϺS\'fH\ ,tU;Oͭ .n w\ \ \ 7ݝ  \07\ \ M  iǇ u \r֚X[ z\ dag^Ƭ B  ( lNi MW! E0u*\ :\ \ : \\\ {N\'Y\ \ | \0Җ \ \\>rp   !F v׏\ \ a\  | ˵    ֳ G(\ :9 X\ gEѾY   \ ~_  x { Gc  f\ \    t 
y\Z  7݃b] / ˋyV i\ eh^\ ϗ{$\ \ w<a GQ\ K   ֮w \ dk-q6<\ \ O\ $2 \ gE:   E  Y ̼\'uP բ  [   4 \ q^  c r{ %2 \ 8   x\  \'	o sj eAf2  D    \'0   W \   ǧ7 \ #G3N  cKٹ\ \Z \ \ q(   \ \ \   qy0\ \\ \ =T
]I\0 \ 7)\ ! 9jܑ= \Z\ \ i`\ \ 8\ l\     i \     \ zxYl
:  \ {7  \ ^0ӛ\ ( *I\ T \"l \ I 9  \'\ zH qU   ʸ۩  j\ A1 {Z5\ c&E9 Q-\ x\ \  7 pg\ g7Z
*u\ v  s\ \  \   : I\  *(\ N k \Z \'\"O  V    \ Q 7   +\ Fb@\ 4\ < 5 
\\H\ P \ H$sƱ\ s\ #2 	\ Q \Z  b3b\ \ 1ĄNJ\ \ H   D 礢 )   T 29\Z   \ W7:tq\ i͜ p  j\ 2\r\ ( H\ V Mɡ  \ OfEk .Wq\  t \ ̳ @t̂ \ v \' my \0\ IL \r\Z%D9\\5   ǙD HN\ \ \  J p 9\rODr9 H( 	k 3     {<Κ \ Vb GK\ bZZ  { X | :\ \ Ǜ  \ \ W:݅+\\]\r \ 13  L}*4  z\ D  [)ȂG\ NM \nB1\ $jQ :  \ `|F \ \ \ b86t \ Hj fd`|E k \ T  ЏQ \\\ \  &  Tկ MtkU \ \ C7     .1   |\ % \ jk O 9 g  M   J\ &,t iO zV!VL\ \rJ nWƯz_ z|?\ =άb.ԍ\ B IVLP    )J B  \Z  Q\ZJF	\r0  .#
\ \ \ F^GQ  P    Z|u K.{G;k  g1s  0 \ k v\ \"H\n@)|m]\ \Z I^\   :Ҹ= x$$!\' \ Z! D	 \\0EՈX\ {> 2 kQ%q3 +H \ 1(\0\  \0) \\\ U H\ տ N\   \ \ &ʤf\  \0!y.^u-cC\"  c6CV 5 d\\\ Y\ \ 
V`\ R @i\ ҍ }Kg\ |\ \ \ \  \    \n!T\"P9\ TT \ \ G9   r\"  \"J	(\ \ 4 $ $ 5\ p\ $ \ : \'?o  .  \ ,\  p p\0  s\0 D\   	\ OXԑ t A\ z  \ \ \ \ I\  VW}Ԭ	,&8s\ $  F #%cIc  a  \ J9  \ H@ j`\  v 2v\ V L  dd \0 = kXj\   AYz \ `\ \ \ \   \\\ \ \ \ 2\ \ \ b\ \\\ f}W   \ ׎  \ 8\ H ;\ /B\ \ \ 4\  %\ \ g  \ \ \ Q$ H\Z  1 䊧 J\'  \"ru$\ 9\ L T۷W \ \ \ ۴\ k F(D    \ \ N1 %lL$c@\ \   :NC  F    @   Z\ Jk\ 䵗m\ \ -;=性1,uh*Ъ_ J4  ! 5  \ ar\Z  	 ֮ s \ %<޿   ̲\ u\\Lȍ9,bAgۮ b  L\  %)s\ \ a  s\ V @  f4ɡRY  i} \ 3u 3gB\ l \ |U汘 B\ ~ \ /U4X\ \ \   I \ p* p  %\")\ ! \  {     ^\ Sb9Z] y\ \ f    \ Ok   z\n	   \ x  \ Ĭ NV  4F\"   _\ V
mզ$@  `E4P  y        X\ Ճ1: \ ]*  a ,  A\0X怯M(RAA e\"~ \ `\ \ I-y&$BR 
ry \ S r\  fd 2f6\ ex/2Z ʢ. ;5\  9 Z   b\ z  \ {\ \ vfu #x\ W @ t  Ga Q $H D! & ɪ c ATQ \ NR \ ͹r4u    \\D\ \ \ 3L  ̳  z J\ H\ \ ) Ă Y\ ɥ\r \ Y bLI*E@p@R\n@  E\ WO 8\r GL  \ \ P\ S \ T ![- \ Q^( :T *  H \ rji  \n(I\ ,G@%= d   N:sZ\ \ \ \rEP  >)q   O \ [Y\ VL\ `l\ V6A  b .Pr\ \ 6P  \ R. s]}\ JԒX%jIS\r>2 QD\ h$        N\nWi8%  K   \ ]   /B\ !\ 4 ֑eH d L \  \ q q\ \n /x$ R\ \ @\  # \ \ D  )\ 	   ,  \ \\\ \ I r ^\ s Q ! EQoWάhT \ $  ǀ \ \ qc \ $!B  T\  ;1\ \ lN Ũ  \ Y\ \ \ 27\ \  aE \ \ T*P92H`   o7\ B w ꙑ\ 1   Qm \ %\"X\ \ & \ ̤F D1ĨE X\ 8 \ \\ THAE \ \ 	\" P\ \"  @ A,4 \ Kn   W \ \ \ e җE\ ^ > \'cd! \ {+   \ \  \Z\ A	)     \  \  S\\!#FЦ < F  m\ XN\ i G1+\ \ m_  %k 5 &$H  H $@J #&Y #\ ͒\ 2>  cLC-;T\ \ZH \    \ \Z\\  \  ENPJ&Ȣ!+e  \ r\ > \  H}W 8ť .r\ ͯj \ *E RZ \ :    \\ZG&   qJ@qD  ZT   driW \ %5 - T    , ^ #  \ I ul 7 dȯ_A \ \ \ \ 7  Β[ĴycI[  V3] \ |F \ ]  z\   :5 j$\r \ #   \ 皴h\ SD   \ \ =5\0 9\" AE\ 	  Ύ\ o<zhג   j\\\ \  ^ dJ \ \ 8쪊BDA $\rr  9rk \ A\ 9Z\ :֫     (  9 \ p  RBA\nHE \n  BBBR  ɤri	i	r	I#   q EK G  I,Tq  \ _κ \\ޜ   \ DY[ .  W{ חS. \ \ ^  YOVe냐 \ ѳO78\ s3-\   \ 2\ Y . L\ i N l  \Zi$ \ $  + C C H \n \ \ \"   .f  3D C J\ \ bg\ t* \rL ױ\ k ֚$s\    	S\\ 8  $\0Kd  F	% 8   ׂ^]!   T A!\0d\ ָ$ 	W \ !\ *ri G&  \ bF )I҇#H    -# r \n=4 |d   , ~  /L\ ې\ \ a?  Ys(5  K \ 3 K* ĪH#i%) 1 wr5#  K \ D   F   \ H \ % D  I(\0   \  t\ 襩 ji =6	k\ Z  \ kI\ ddvI  \ Gg\'  + < \ h (s $ 9 \\Α\ 0y  @ 5     j s \ \  r  \0 \ \03\0\0\0\0\0 !\"013#24$@PAB%5CD` \ \0\0  h\\  H\\  nX+++=  Ӟ9YYY[ \ nY\ \ \ \  c  1   \  1     (  X+++<3\ ++++++++++rܷ,   _  ph\  \0ѐ m+    N\ [ \ n[ V  2\ \  \ Ѯk\n\ 1 4 \ xY
{V )\ 6&~   \ \ q٣w 2  \   @ \ Y8BV s ; +.[   h_   7Tzn  v)H  9S  @\ \ Yd \  ^Յ   \0 y %  \ S.\ \ ; [Ɨ\  \ 6 \ \r \"$ \"G&BV \  \ [ \ PvWe[\ ]-Ɔ>\'\ A\ 6  XRV K \ xY @ H# L ً \ K  |p\   85>B}\   3Pp?\ x  
\\ \0\ `sFj:< \ M \ 2L~ \ \  W Zi*Ϛ \ ^ rI#> \ \ Q ҄\n\ K,  \ $ B  B  ҇  } ֱ  Q   g\ !	    \ \ \ P % \ \ +(   \ \ # y [ V 55  \ \ \ \ \\ 4\Z\ bk   ,\     :\ 0I3  \n\ F}P\   +Pp?\ \ - +\ \ \ 3WaLԠr  ؄ \ +Qcރ    \ XqS\ \"?M\n lQǶFI\0  \ \   o    Kc  - ܕ  ѹnFV5s   o[ }0\   0A\  \0FJ\   J\ \"܌@ Q-cTx!  ya>H \ Gj	 V\ F W \ \Z   \0\ \  \0 \ Y\ I o~\ # !W( \  B\ FV  lE  @\ !	   \\ \  \ \ 1   7 Bmv\   i \Z \   \Z \\H\ A\ cl  F\"\ \ eȧ*^  Sh\ 6 \ )  O|  \0Mc\  n8`  # W( Q\\ \ B  hj܃ 9\ .X[D#!J\ ^ ^B hǅ\ [V




 qA\ 8q=  &K 7    \\\ \ :4\    8  98\n 4X \ tg\ ]\ Č\ Sg0 @Mh\ \ U\ \ \ ٍ; \\)\ \  0      [ -˔\ \ + W)r\ -r\ ,- l
h[B\ =, ˖\ \ z\  \\   P\\ a+ \ :;,.\ .OR	V\ 1GnD-٢) \\ \ \ \ E   Dj˝  ⹎	 \ 5 &- \ \"   Q 2 r  ) \   n  4 \ \ \ .J共 kV֭ aac 

i[ n\\ .S )˒W$ J\ J\ .X\\  alj\ ж  \ `\"ƣ\\ bpDc e$mxa^\Z\ \ B\ ]\ u\  [V\ #B\"\nQ } A3 ?¹xR \" \ S+v\ m\ \  Z<   \ 7uM.p* \0N\ XXX[ !j\ lj\ ж    zxX Q\ ЋVа           5  5c    u)\ +  Lj\ \ # 7: \ uc B> \ ˷VM  \0LB\ \ \ \ N A  \Z +5 E xXXXXXXXX[V? \ K
1\ 






jڶ   er >~\ ;O \ ; 
?0\ \ #5\  Wbϡ~ 92s  fj \  \ ,,,,,zXG\ 1  F(\ 5\ (ԍ\Z ¹xi&@  ,   յm[V8c : ;,,,q\ N=~\ C  h\ M̒\ ݑ🼰  ᖔ\ tö\  d  \'i fUT \ aaaac\ wۨ__ \  d 5 \ \ r \ zz  \ \ +   \\ƭ\ ^\  ( \  a   \ \ V8\ , XXXXX\ XR\  :G\\\ -lle 9  M \ \ \ \\    ޥ F  \ \ ܏ Z \ o  \ ݆\\ Ҹ   O\ أ\Z PY2\ \ \ \ x U\ ٱ  Q  2\ \\ܿr. Ab)  \ %or\ \ \\й A\ ] %  tR\ @\ \ \' A\ \\   \ x\ \ zN t\ \ o\  q	\ \ ?;@[\Z\   䉜 \ l ~ \n   }#e¤\  v   -0 4+ \'\ \ !e\ Yp>-x \  ^\  Z d> \ e \ \ c y\  ɕ\ hЕ\ E \ fVp ߹ \ ;\ 2H  /(M b9 8&r   - lrÖ \ \ Yr\ \ \  .d  \"\ ȹ .l   Α   .d  H\ \ eBĊ[1 \  3  ϑ6g/\ .Ɇj(܍\ U8j#  T]   }   V  \ am[\ \   \ ~\ h\ 0\ p} f\ F \ \ {\ \ \ き MCe \ 4\ O5 &\ \ ; \n՘ jی (\  \ a i\ * B ? 3 ,\ 2;.d   H*ʤlPEY ` 	^  D
iV Χ \ T g( O$Oc  4 \  Z  \ q\\ׅ\ $^*D.9x  Tk\ D \ 
\\  X\ ±  \ È   Tz ٫Td\ KHvjuؔA\  \ ^T\ Y \ZA  }   \ = \ E h~5;r\ M  u k7    U3 : ; \ nT \ \ >  \ ݲio  L i ͕\ N\ \ .  ,_S   a\ \ \ j\ ڭ V{S \  ߲ ?e#C\ \ H[VՅp 79YYE\ A\ @  2B\ \  \ ^  ax  sW8a  ;
\n\ \ \'\ {\ ѵ P   \  \ M 3\ 둍  \ \ # Zi\ @\ F4\       ~ j\ \   ; c   N \ FSֻ\ j \ ?   7,Ԛ@ ^{ rcc\ G  ?L      CF \  f}j : H> ڏ  [ I  C     \ j`\ -D-[ { !|g  \ z\ =s޹\ \\\ \n\ =x * \ < \ `a  J9#|\ \ dP \ *\ l sX0 nV\ ;r q ^  5r\ \ rڌamP2=    ڦ Z!   \   \0  \ D\n ~ j\ \ \ \ ` \ ,  \  LQM C  7  6  \  \ fV ! \ k,! \0  \ s  ph \'\ \ \ KP  C  O \ 5+P\ {$n}\   b2\0liD-` W  \ \ (  ;k\ 
˦ \ D\ 9   :*\ {X\ # \ \ 6V \n  b\ \ i,  es\ -\ XXXXXN\ \ o elf  oץ] \   \0  \ _l G\ ĭ    ;  :(̉ \  p  \ \ g     5\\s Z  FmA c \ x\  \ ?  \0 P ;M\ 8xj\ s    F\ t\ XL] o\   {yCا-X \ ǿSFxT   y S  \ Q A $ 1/ c \ @3q \ < \'\ y 2x  ?   ݭ\ *R \ >\ P \ 	M_\ Цv\   4\  O r +_^\ ~O \\^; \ o     \  \0T t `A  b\ ä \ \ \r ät\ +~` f     \ P K^՘
\ :  \ ?\ J~ F%` \ \ #\ $ ֩   \ J%j\'6\ K%\ ֵ\  t\ 2  4 ɨ ,= * n\   \  \0 y\   -6(\   9LSOz c>\ P\ \  øC\  ;<w굫 8ꖐ\ -dj B~ +\ B\ [_ 9 
_l*\ \  \0ϋ\ mV=\ U  : {\ \  齂,m2  ݖŘ{\ [ 2\ \ ͊_uS3+>\ %7  ֎ 2\ nx k \  ޛ\ ̅ ͘ \ \ j
 { E\ \ \ 7  6Ix  \ R>i{ Z	^Z 7* \ 
;\ \ j \' \ Oi D< \ \ \ \ \ 5\"  =OR Q  Q    \ v\ =\ \ \ : c  D  M  _\ 3 g?     \ ?c 2\ K\ \ \ \ \ \ \  nf 6    W\ 勻 O \ U  w \ G\ SN -vNn\ \  ~۷\  [A \ K\ S ^ \   \ \  c* <  \ \ \ xi\ \ N\ ?Ps U \   \ ,|\ \ \      w \ \" 7 #\ z \ @f֩\ \    q:  \  \0}1۩tO pi\ \ \   \ r  R   Q\ \ 8 KTi Gj2\  wr     \0\ k AH6 7\n t m}     \ \ S \  & q$iϕD\ ϳ  \ ge Gv dmZi\rV b F\  ]\  \0v   \ a\ \ \ \ QAPA \ {i\ \ A\ \\    p   \ \ X\ )\ N 4 ɺ ւ    |\ . t=h \ >   \  \ ǿ  ݉ \0#  = 2\ O \ ڄM    ^ \ >[^ B  f \ hP0 b  5>Z     |\ [ \  \ ֯*   Q \ Y\'1   *i \n \ r\ _i;\ w\n s  Fծ       B\ s v\ Ǻ 3b\ \  ς 2\ \ 6  \  _\ S    E\ ` \ ci >B     J/E\ @>^    \ /@a\ +w  ;?p*o # K  !> |Lay \0k}\ \  L\ \ \ Ȩ k_w    \ \ \ ˖+ 8_v%  T 8\ \ \ NF \ \ SJk\ f,rm AjY   z  H} Q\  \ lEM \ ?\ \ i \ J &=F  U \ Ft \ w]ջS-;\ \ \n >   \ - \ \ 3w7 \ \ a\ :\n \ .tC  61\\  < ڬ > 3UE\  n \ ;:gn\ Gd~\Zs7\  \ \ ȟ 9\ 6   \ = \ \ \ \ \"2@ \ \\b*\    _\  qt ƪ \ ׷M êD\ .  2\n  \ UT   b Vb   \ l1\ ]   \  lͽ:-  Ʃs\ ϕ[  ɥx   \ F^ L 7wZ\\  \ \ D-> 0eB\ լҴ  \ n\  d-1_9  {[ sj      ɾ 8pr =G + \ \ PV~
cur  ކ \  l\ O\'\ /\ \"CE \r\Z  F\n\  \ Y% ĽV%\ Y\ ˇ\ \ [er\ rD    O& l  \ \ 揓;Hٻ\ ]\ \ \ &1\n 6 `Ga #(Z Mi   9\ {UkR\ >l5o8A$   iO\0;\0 \0 o  9 R\ \ ׳CP ׏1PC\ \ ۢ󐛾\  $< E  \ e  W \ jsh|$ ]\ \ \ lr_   \ F JǇv lZ\n   \"&>b\ F \ i   \ kF\ \ `e C x\ \ ج\ d\rv !L ^    B\ \ .U  \ !\ \ M }\n m \  y f+ \  *  M u  \ \ \  H
 \ EG-a I 
UO V=\ |\ \   \ eݙ\ 8 c򲌼ȵ6 l\ \   lʮ \ g 1 \ g3 ;i^ #~Xe \ k r :ӊ 쏬 k\ @ 7+\ C  }~LW^gx\ /Nq$ 2      g Q8nl\ sQ c\ B*\ j;ϙ\ +>\"sa u\  L~ *g+\ \ d ³ x  \ \ 9o    8C^\ 7ndm\ j v \ \ r ep    \   *96I,m  ݉ T  ?  ͬX\ s\ =.)  ;j\'  i l  E̬x & W  \ O\ Iq  ՖH\      x @ܵ  \  Uf 7Ks\ \ {9\ ^\ N| AN\ xW \ \ \ 8\ %  \ \ {ԯ
m\ eeL2\"w.g 9@\ \ \  \ \ Q\ lU \ \n\ m>g\ \ µ\ \   @ \ v\ \ õj:\ :\ \ mZ)+ D\ r E3\ \ \ \  d !T$\ \ \ 5B1X ; \\\ Z 5\ Z\ \ *    ɫ) |o   9\ 8\     ( Z= 1 \ngtz {  ]`  \0\ n˜r \ VNd7ɜcj -\ Yb ȩEfß.\ \ s  \ dh\ u   \ \ \ \ x   \'\ (=<a} \ \ eh  έ g\nIa- \ lw\ o\Zv փ \  (3׈ ˷s= \0.t\ \ ڎ\ \  \ 5c\ Z  \ z   )٧ )\ lY  %zZm\ a ~    { \0 |\ %\ \  y  =oʙ    >& N 	 Ѡ aW֭ \ \'  ir t Yv7e w0 a K\ ɬ~3ZK  1 ?  M[ \ZQ\ \ \ Js \ `  qʎNJV\     w ]   \ YMk \ V҄d ^    ?\ Md|˲\ wwAH  \ \ \Z]> ?(2 \  R6jN\ 
  XD s\ \"s y  \ W \ Uݘ  \0      \ +\Z\ \ uG  AZ#  7H1  @\ 86\    \ \ nDd\ n\ \ \ bI\ \ \   \ @/   Go\ _C  \ \ \ ]E<R \Z   kX|~ Z%   \0 ͣ\ g \ պ͒: y \ `  D\\\ U٭ ^ ;\ t \ I \ \ Nˆ\n \Zp}\ N il Xg.M  Q e \ \ \  ?\ { \ = w\ ܷ-\ / v\ VmD UjN  o&yeM+ qi\ 어\ (k\ \'W  ذ \"/o,   q{ -\ ~  \\\ iCy5. L Y\  j\ 0 zHC   7y \0 i۵\'J#h =Jߩ\ \  4\ S\ \ #n  ~ \   \ \ >$l\   x ׈j\ yF\ 
\ 9x /\ ✼Y^/*̂h嘱\ \ \  Fc j     d    <  w 8  i\ npա| ׁ / Q |\ >]i  ;)c{  C  F n> #l\    ґ)1\ !Q \ j \ [  \ s?N ] ,,w\  \ #ZT\ \ W  ;ʉEE  Y  \ ָ    L  \0\ }  ѻts \ $1] S4    \ \ Ydmh7Yӻ  J s  < \ \ \ \ \ \ 
\ Z\ \ 11շX & \ ä \ \ 9V  w \ \Z  -Df   \ b Q ѝ   ۮ \ V ~ eJ\ :   \ E=\ .vT  \ \ i \ : 3\ \ *ؕ Mb8S\ \ \ \ \ %\ \ \ vY\\ + axyW +  x(   x8  xh \n\ Ķ1M
& P -B\n d \ #4 l. I\\\ zd\\ \  k Ǻ\ M \ d &\  \ ֹ\  [\ \ 4 r    ݉s \\\ \'?s\ \ 	 q\ \ v \  e \ 돯P\ 6\  \ \ R f\ %    O*BUzq  3  h&b\   ۑ* \ 姺ښС8d\ ?\ tam[T t /k k bv 2 .	 \ y! \ Z \ Wb \ \ i\  a R YlS  XZ^6D59 I bW\ `>  + \ { \r? R~& l7
cud\ v a  \ \ NVx\ ee_ 꺻ׄ P l \ -4 \nz  y!-mvy ? \     .   [ T V     v\ 5 \ 8s  $\ pX JM ste\ . 4y , Rr: \ \ r  ̝zw\' wF׳ X\ |  ֙  ͎w> $ qg\ F B\ \'2\ F aV;  V- \n \ Й\ 
V̩    \ \ b ZTu۶ZFF \ xz4\  K1u|ō \ \  ݞJj FT\ \ ,g{    O \ ! 4\ ڤsS   =\ $ 3+\ ^    \ i>F \ \ vB .au7 a:eJv  6
s o H\ &x ^OrɊ D ;R \ c\  
_x a e ,   \ ̥ j.\ \ \ 7 p\ O =\ { (N\  SӭG  p \ =  ! \nS < \ \ \ 7k\ \ G!oj\ ļL!x\ \  GR M  5   ԤGP x闋  !BRV2  2VcZ\ O \"?Nx  ݖ15 ȫB 0֮^T ,<$ 8 ]    F±#\ \ .W 6W/\  \ \ nNd  :sr  ;۸ $\ \ [ 7  X\n ԉ +| M vm\ 6ىG|8x r\ <K.SB 嫟  eV , и\ 6 cF^*2 A  &r  \ z \"yZ\ #  _ jh)D|s \ -6H\ \ Lm;-    J  Z\"=\Z\ \ \ \ e| s\ Ͳƒ\   \ \ W\ qL \ U2K {    f}ʏ   c%  Yn\ Ǽ^ށ\ av }2\   #j \\+\   |*͸f 9yi k j m Vg _:6 [ >b\ v \ ++++++++<2   (\ bta쮵F b \0 ֵF JN\ {\ \   8  !d\\1\ \    hى \     u x  H0v\ j \  \ d   ]\ o?Nc u= ֍\   Mc(4 CS \ u>\   æƎ    Li   \ mP \ \ \ pis $d >zn \ WM <Փ, \   n+22ƔO& ΢ \0 Q     \ \Z     R ʂ\ 
f 8#e\r\ \ \ Ypܭ) ֘#ڲB91\ s  \  u/\ r)  Z lVk  \0 \ V    h \   ԟ/\rDbډ9\ ^  N \   GR(\ 2 2 Z  | \   eeeg \ \ @* y\   \   ڤ l \ Ǵ ޡ ʌ =1\ =\ o6    X \ a?\ 92 \ ҧnx	 \ s\  o  < ~|  a 5Eu] f   F3e\ [  \ \ Z \\\ \ HMI\ ۦKʍ \Z\ bh$k,C#y\ \ q\ \ \ \ DC] nٚ*@ \ ;5 \ \ 	\ \ j 2٠\\Ќ E\ ^r  \ P   I Z  \ \ u  \ \ c0\ a \rk  2ܝ  \ b  \ +F ћR р	! \ 5\ ۝b	4  J	k     \\ \ry[& \n_~ \ 7\"  \  \  -w6\  mA \ ~Z{rX; \ \'\ O { \  (}       \ >\  8w\ Y\ ]ȹ[\  \0  \  Mv\ j  \" jhS$NAɎ^\ F\ s  Y%g\ w  \ +1nL 0  \  \ r\ \ \ \ \ \ \ H) -b`l\ ̹Mݵ 	
\ BD \ 2 -E\ D 2C%v8  W7C \ C*\ Lf  \ Z  \r V+\ U23k67\ Q x\ \ \ d\ Z  \    Z \ \ F\ W .U(W\ kM G?M \ jX (X! q >@\ \\  \ C\ m   \ c  Y} 8Ƙx   eY  b   N  t\ iL\ ^\'1 \ +% \ rd    >d \ }\  E\ \   M\ @  ? \ \ \ $N  \"   \ \ \ \ \ }w =ĭ\  \0NO  aLr \ \ Jͥ{    \0h 0  Ҍ aR  W ^<     ț   F   \ (  c59 \ .  2   r  \ \"1 \ \ ]:Λ H4\ ޤ  SQd  
` v=  Q  \ G\ x^\ \ \ 3[  5 eW\ 6 \ Q\n{2\\54J\ t \ \ S ,| \ Z \ ,\ ;J9 %lsUQ 57Q  ܬT| T c|Z &\ u/ V  \ _\ E \    \  \ 蠴 b\ _  3m\ \ ^\ L,L 2mǨe\ /L ]\ : cMm?\ V P\ \ ^  /_ \ _e\n\ \ S\ \'\ \ \ tB\ c\ Oe]4    \'  j - M\ 1\ Aګ\ n\ q  R,\"ܯb\    \ آ\ S{I 	 F{2L٢ 6\   l ed1\ vKO  xD \0   ط-\r 3 \r \ \ +n \n P  ˤU\"\ \ V۶m \ \ q ̩ XQI\ hE\ ` ]\ #\  j \ jg\Z6{\ \ ߹  \ 
t  U  Z\  E H\ i~E\ \ \'/En `&j\ Q܌ǫ7n  ! \    c\ _Wf T\ \ Տ\ \  \ m.75  OIal: m(   \ \ u  \r \ \ 9+ \ ʻ Q A @ P~֐ÕߋUoҠ3: \0  TG\ rgi? Â7H   dMkn       \   \ ߔ{  -\ \ \   \ \ \ \ \ 4|   \  \ =\ \ Y ݧ) Qȳ  i a=K ?\ (gh߂ת3O \0( \ ]S\ a\ _ ×\ M   `  G   \   ]\ s )|ӷ.\ #\ ?\ m \ = 8G\ J7\'D c  A\  ~]C\ տ f.\ \0/r\ \ +m C\ Q ֿ6 \ [\ \ gn   r\ \  P\ Y\ ͋5}\ 7}\n iZ {p}\   \ h    6 br\ \ W bmuM\ }R= `n#  c̲  \ g9쉎ݵ`   7j  jm\ ]4~\ ~ T~\ {  \0\ ӧh ]@\']  t Zo\ k --\ q  PM  \nxi0S]  \ -9\ DƗ x;)  \ v\ g h\\   \ bMzd zlS\ [@\ \ ̖*  \ \"my $cԶ6 M#\ r   3 \ n  vs%#
P~ h \ ?\  4 V  KWsjֆZQ\ A8 )ff\ cQvT\  \ >  Y[ _sǑ Q   K\ տ  w\ \'}C\\\  7ޏj\ } q \ ugy  \ \ 0S\\ fWB  \ c\ % h k \ ! *N< ۼM),n @텅     1 \ \  ܴ\ \ 4ߕ99\ (8 g {t\ e\ q\  \Z \ |m \0\\ \ .\ \ 鿍 |  戫   \ \ o/\ ޫ  6   Җ$) \ \ \ E\  \ d5 \ l\ db\n\  \ eLzެ\ v \ @\ N \  r49wi{ [ v/\n |\ N\ 玑_3 G   A\ O \ \ R 7\ \ ՙ\ \ ̅ W M_    {\ \ {TxX[P   }     ޛ  \  P
  >  A |Z ?5 \ ma / aa\0Wt	PO\ Q\ Q\'  \ ,  l[űmP %A G\ Ԯ4 := =   \nv    핕  \  .i[\ 9\ N   \0   4 :h ~^  n\ Y i(\ Ԓ2\ \  \ m{E*p  T\ * \0s\ q\ \' \ \ \Z \ te \ q  S\\Bl _v} \   ̎7< ˕\ t ,{}\   \ < ,\ \ o\n1 \ j b4   @v %8f +㽥\ g2 \ \ ;{5 bWJ֯\  \  )   \'Vp  <- %#{gnƻ*\   7\ \   w\ 4\ x;  s\ LQ{ \0 ;ϐ .\  ;\ {\  Fϭ\ q ,- 4 W  U .C ^ L -02z \0% Ff \  0  Yg\ >R\ =  \ \ -\ \ \ \ \  3    \ \ b  9 { 7 u   -[ \   &\ ] :F-v   \ ; x  \0 \ Q   q }  4 J\0 B t   F  Ĺ  \ \ -c\ K\ %\ s +߄/\ Z>l\   \ \    I\ V Ʋǖ  \ O\ \n ei n    _  \ \ \ O\  [ ݖ \ Qk\n}(N \ \ r0ORW Ӑ*#\ Hs \ dUߏ  \  V0!    \  &%\ \\  Eh\ H \ k \ G+-] Ұ \    L  CX\ \ ck  R\0[\ \ _ \0  3D ;t\  \  lN 9   ݳ\ 4 \ \0\  !\ G @ɭ(j \ \ ; u  Oc\\   \ Sll %g.y \ w \ \ L )\ \ \ 2 )\n k     \Z\ n<r # 1   L х  U \ M\ &hV g   4B\ \ ֨գ\ \ \'* \ ؟\    \ \  ; \   = _-\ 2 }P \ \ \n \ K\  \ \ ,ys \  ^\"` w	  Sf  咚 \ \\t \0\ \ m   3@\ j~F 淅  mU| T=쳙D !rJ\   y VBP
iXMMQ@J  \ : x 3\ \ Zy \ J \ \ ]  \ p>\ [J含؎&  \ \'s@h \ ;X \'i[\ /M ]s\ WD \ ٜp+  G f\ [5  3)   >\ \ y\\{ m\'\ S  D\ \  \ZqY-\  \" A &\ ڣ Y 1 Y<_,lO\ j1^   \ M  KX   ]F\ w: \ \\~\ w\ S \ \ G& h%Vۉ\ NdmL   \ M{\ վ|,pڹhŹB9  t F쪽    \ \ L ) \ L  \ ,  S, \   \ \0oy\ &յl\\  K  : \ W%\ 1 Gܠ jW `- jin\  Xn\ pXu\'~\ Wf۝\ 
 M쇷KF=\ \ \  5ق 0 qMqqӿ]        \ dp28  x\ \ x\r \ \ k\ ^0\ v\  Lܳ\ d;ك  꼚 :xX  Tj  \'| ,d   dԭ  fs#   ޷ z\  \ P  aO\ ̑ )ëE>\"+ \" \ n] \ ͱ\r \ N\ \ n-ѽ \ TT `5\Z WM   \ {z {8XXX\   Q \  \ mN  B\ ͜\'[!KaΗI g\  1 R> \ \ \ \ \ ښ̦\ %6   Z\ 8[Vŕpx9  ]є>N#VԒ   \  \ \  S

\0Zl \ ` %#6H \  \0  9 \ |s \ F   \ \ s kLSh\ St\ \n\ZR\Z[W\ ф >%5 ,E 2S^\ \  M  ,1\ \ \ [豅ɍ\ \ \ \ ck \ &    P `׬m H  \ \ \0U  H [  _9Af Hg   \ n {r  \rn \  * ̬  6 (L\ ҂  Vx ^cы\  \ G ta4 F\'* Dda !2\'92  k  \0 ^\ S\ \ \ ]  ]h \ 4}?a \ R? \ \ +)\ )  T\ 8XMZ[ w d Π\ \\( \  V (֗   l\ \ j 7 ᑓ\ ?P )5 \ \ \ 
\ N \ 8\\ Z} 8 \ {s l <*F \ ̙\ 5 \'6\'q\ ^Jk\ QXq  \ u@U#\ V֤򒲻  _ VUl   4  D\  \ \ y \ ?mwl h   5	f\n \ \ ڵ\  * t\ \ 8C\ !? t8+	 9ɔ ) \ `\   \ S  \ I F\ \ ^ g&{\   \0 3\ \ x  = 0 K\ /  \ Tg \ ZW\ \ ##\ k5?W \'\ I \ \ ?Q \ lH\ C\ \ \  .c\\ q : ZG   c Q\ \ \ m( p\ \ ypv B2 \ 6b  X   n \ ra(\ B  -o \ \  \0\ \ \ a>\ \ , \ \ \ s= w4~&v \ \ r \ q 3ѕ\ mأ\      + 4\ U  \0  ADer ^p    \ \ g {-x\ \ ]\  a3\    U \ <rue^\ \ Ք^\ fj3\ [܃   -\' \ \  0 欠 |  =%6	  B×\ & b| \ Zhl\ 9: t/o   W-ʄj |\ r\0 9 eaac     \ P!4 6\ L  Q;.´> R  \ aM(97\  \ \0w \ O\ q\ z p\ YM>Kߏ (  \ ] \0: n\\  s \ W pF\ w& \" ޹ 5 ޱ8Z  US  \ \ M Mͽ_\ \ 	 N  j(  ݶʒ\ P  \ ƮsW=s \  \ +i[VՀ , ɿoL~ p\ m{ؕ \ @\rsJtLr5 \ \ <\ \ ҥM\ Z  P 
P\rj3F\ mğt\'I վ
 8e9 r5ZT \ Z  )ir  _b [8 62 {\"\ \ r  \ ?  \ \ \ iTcť)\  f=\  h\ j\ \ \ Ӽ  J   ,,q \  P\ !ac <p\n w Z [   X\ 4 ݖ # pO\" ) ෎ \ KR \   +\ #BԍM 	M 7q \ 1 \ a7Rz  er%\'?+Q9 =ą _)} O\ } Z2Sv { \nܳ\ 2 \ 1  /} X[VՀ ,  |\ # \\` \ V oB\" ]p \  m\ =\r  6eC\ q\rc 8Bm\ ` nV bW, \ =\ |\ \ [ xG\ Z\   {G;U \ ĥ |\ N<  |\ }  9 g 
L M\\\ ,qi \0  \'  \n5 Sj  nƅ    ~:k o =< .>&\ jI\ 9 )     \Z   Zd+0 u Tw\ ) k\    &  \ | 앋  }9C\ \ \  j !<9 r\ \ |ֲ3~lڂw r  6G 9 \ @ ԛ   g\  \0l%?\ t d\ c \ \ L _ \ #[\ \ ܠǕ \ qP L\Z\ }8 \ ~6  H \  {_  Ř5\ NY[ U ]\ !ŭ\ \  t\ ,jQf =\ _\ \ \ (D݌ \    U    \ U 0  \ I  \ s\    \ \ p\ \0T=   K
Y\ C    	   + ?M{ \ u⠕xV=n  Pb h\ NhrُF\ W \ \' _ ڄ\ ( \ :uDئ FM D   Soԇ\ ۦi\  m\ n\ \ \r3\ \ bw 0\ (4*0 6J7B 櫵jc0> \0B& \ 8 \ \  o   mq C}  \0 \ \ އ\ j  \ j \ \ lO) ^  ъ   m< W>Y[̊Eٯ 3mʬ\ \ g2@05	 E ;.\  \0VV i wf8 _\ S4e !\ G   /\"\ #T ]+}a  ^  Q\  n*H! :   %  צ   aL\  x\ \ q\ lj24\ fYP\ +T Z5\  s\ ߔ\ \ Qc  iaT X\ +8 \ n{ ݼՕ  5~     {\ n -N6 N  ^\ Ͷv\  1тV   \ \ zZ;\  \0=\ Ë  a  \ y\ \ 9 \\P \ @\ Ir C#\"60\ t fF\ j0b \ \ S  \ ˹A\ XoՉ  ǆj  kta p 9}  \ \\\Z 
\ W      u.   a1\   W  \'B  3  rLXᅄ\ \ S*  P/
%    z ܷ,   Pߞ5  \r %[p    zͪ j\rzs =0\ jf Z r p\'
 \ \ [. 3y G   S\ @4 | _;`Pvd\ mB ɀ\ }  ;߷}    \   + 6T u~  \ Z \ N    \ i \0  }\ 
[\ |  Ԃ0+ GZD\ \ )\ \ \ \0&r  D\ \ B4\  l\ 帔W ʪ Ӛ  vj4݉ 08D\ c\ 6 J~}  \'F QE]̐Z  ax\     ~ \ -  \ Q9 kO \ lj
W n ϑSg5   Y \0 \ B  oRё    㕕\ c VVVxn!Avh : QM˔B\ Z  ZE& \ \ ٮ  \ _\ L \ 7P  ;u\ M\   \ \0 l  <\' kD \n f1\   w:75{7P8aWE Q\ \ )c-\ \ \ sY \ O Kvێv}\ \ \ tm4f\ \ \ + eeg  Lυ\   ,!
܅I\ne   W|o,\ h\ \r\rN8V <\ \ \ rܽ\ ꂍrՌp\ cN\ @       \ I $\ \  ><\rJ~Mlp\ QnPn8\ \'vN˕+- Y  ͶwrX @\ e s^Q\ q_u \ > :L/ aaaac  \ Ї h$1},    ܠ ,JU F $\\ 1 J\ %Si \ -\ ,\ 7	< {\ . !FL \  R\ k \ 9U\ ]
lM{\\  %-O - *\  z,\ i!4  b\ Z \  \ 3l\ }c |0   \ Om ~\ k.  n+ XM쨐\ \ `罚ze<&\ hBڇn 6\'\ ڟ \'߰\ $ =r\ ؄  6\ J (8  XקUN \ U; \ ,({?Jv,k \ h \ n\ 1 [ MγŻV\  \', x  \ 2Sk  Y66 \0\ \  x\  \ ]ܟZ7)i  ӱ- i r \ 8  bQ걽2h\ ׶  Tq\ ++=;B5عnj/ \n\ p *\  E  p  )   Wv  \ b; Z k\\rr Q V s?V8c  5\ o+L? A\  \ \  F\0   \ \\  ^ \ \   ^\ Ε  \ \nk\ BP \n s\ csV{\Z.\ gSf PE \ZQ \ \'\ \ \ \ XO  MӚ\   6& 05D 7   ˺ڀ\ 7 \ |mz  J   X# VB򭠡\Z\ ZV:2 \ r=sI[  \  SdkԽ U  8 \ b U \n \ r\n  T \ g , 
EU w  ÿNj   ҫۖ8  N.z\    ϣ  \  ojm  Ga @   Qڶ 	\ w 7  3 \ h 8sOPA  bqL J  D\ \ !F滤p%n\ \ E\ %a\0  V:   ǩ鹩\ sV֭  ;  \ y[\      ++=\ 8J\ \ 9\ \ Aok   3  \ =  q2w\ da5in  \  \ x8 Ah   C\ oh\  Xㅱ \ _p \ |a:0PF  &c [ 5  W; 5 T -N  q  ֐\ C FJmrS*&WhM    :5%l \ \ b  \ \ \0    \ c e  

q\ rk \ ѵ\ j\r*X$  A\ {Qڶ [\ g x 	Ũ\ u \ \ S\ 닔.O=   W 5 \  vxVGֶ1V  kj& c \ \    t\ \ V dr:   :\ ^\ Z Bb\ $U\ \ !\ q  ( j\ \ ~ y\ 
4 \ \ U2 M  c 	\ KYy\ 1\ қ   ^ ׺\ F\  8g eۆ:J*\ `\   \0(      \ \ a\ Q \ \    ;\ z  \ Y;!wb\ \ fZ  S=ҳiAa\ \ Tm \ \ .\ J  }lp*G  sa   Y& O +   @* &ń؜S* \  &\ ж\ \ w\   ) \ [+\ 1\ ܇\0 ˓sӎ /+ лq XXNG z k\ ُT \ eg   \ hN\ \ rY\   >\ s   *v   t#\ \ X\ \ ^ \rc\Z   \ \      q\'	 \ \"\   b  8c 8\ \ 1  \ )  Q\ 	   a)  U6 Fڰ  ,ug r޲\ \'\   jdŊ)    .黲  q
JqOڜ \'L    B   \ irh˜\  \ [\\T  * 4 /ӾvP 6 L \r  t\ Z|O { || r\   `\ \ \ \ \ q 32\ *c\ ( 
   
 ed\ \ &\ \  :
 \ 9(5c  I] >0\ a\ Q\ נ  ˷NQYC Q~ \ N >d S   8\ c\ %e>0S \ 2S \ \ \ Fܦ<   P    \ \0N   g)Ҹ  \nl *\ O  R   +`[ OU   o׎  N A 6\"S+ T&       r   \ xc r\ P\ \ -R\ 9  \ d \  \ \0M\ Ӆ   rt \ \'L \"\'  \ ac   \ @Glpo[CAZ` \ c  S] \ #r if \ B  \\ \ *  E<  R[ \ [v \0(q\ @	   \\ ʩ  \0 .Z =B\ D \ XC\ \ z   ʎ@\ 9YC \ 8 n N  }l, ̦\ .^B$ џE \ r\ - ` \ \ VA\\ \\ \ \ \  A\ (\ ʏ\  Vۋ \ Kc^ L[]\ %\ 5\  4, x\ g\ \   \ ed\ \ &F\ \Z=L\ +r.[  8 ,,p+       k \ Fa x   sW5oO 	 J \ w^\n\ \rʎ *: L`j&\ \ Z{  V:\ \    ťC z\0 VUgbe Nr \ \ mV I\ .[ \'  8 \0 \  \ \ P  \   \ [ VQ,z9YY\ \'
.Cvz\ 9Ijd b  r ^ȼ\'N  eg > ZJd W\ k\0XXXX\ =h\ Vt\  \ G Z V8 \ L%\ gu!ûmC\ >
*\n\ \ \ \ < ܫ 2i-^\ e\ \ 62S+8 TL ЛPhD)bʖ,(   \ t +p\ % ^\   ;r w\ <2 E\   +]\ \ \\ ps
SesW \ t D   aD4 rTU A \ \ \ F   X $H Ĭt   bعI Ǡ\ 9Tci Ĝ) \ \ - Pi(D  ތzY IL \ Q2 	   p  \ 8   \"Vm0Ʌ = \ \Z \ F杋jǭ .\ \ :|!d/W:B  \\ \n \ \n 6 ;q\ \ \ \ t >L z \   Q\ \ \ ±B)U >XӚ  ? z(\ \ \ u \ OԊu ܈s Ņ [>  (    \ B ,  \ )L$ \ 9\ e\ \ rl` \ % \n؃q\ \ \ #  \ J 0 \ \Z`XE \\ŔJ/N :T] 0ܦ\ $> ڈ\ 6G5Eq\ E. \ Jܛ\ t\ ^9T [H Y \ G8ac   1 o e5 0첳х  \  G\"k \" e<l0J       @,prq\ a #ގ &\ \ u@ U\ ^f(\ 9   \ I  D \  N 4 \ IQ\ (0 `c  B  ذB \ = 
r        t ܦ   b\ \ ,q

 N8\ \ ( QJ     JeY #\ 0\ Ja\ \ \ \ \ \ SI> \ \ e9   \ dk  k  Z \ \ \ \  (\ \ r܌  J  \ c\ k2   \0& \ \ \ 1ɵ\ S{\"   =8@c   V    m:V FZv q\ VW\ Bd QL *k  A\ H[ \ NfT ב7 \  z; \ \ \ s \ / \ \ $+kޅrS\ a &L\   [  Q\ T  \ P\ \rK<q\ ,L M 0 \ \ \Zsp  .=f \n) s&H  [ \ r   \ )0T\ Mqi 6P\ \ edp\ | M =7 xg\ (  8N \nW\ \ \ \ ;	XSp \ \ \   xez A t\ amXSU U>   $(  \ \ C  wan) \ G: L   em\ 1 #\ <XLv\ ^\\ ~ {X \ ^!\ es]\"d9M &  Y\ d r\ K J.(\"S  \ \ \ N~V c% \"\ \ \ b v enA\ r%mL\ \ \ \  Y(wZ     \ \ [  	 \n9Tr =5\ uL̉    %\ \ \ `>\   \ \ C tNj-1[v v) \   ;أ 9eeeee  )&N , \0\Z8K 5Tq 1 -N %e 0\ e E3^ \  ri\ 長*Vf;  \\\ 3 zGH   d   ~r \ Lz   OT   ] rܞ   t\ @A 9  j   欖 \ 9  O ߽@Ӗ pq\ t  \"   8 @M  u@ :0 S\ \n  \  52p帠}`=<\ n
߄ mɹΞ\0\ \ \ G  fQ> vr \ QȚ\ 7*\ I\ v g  .1\ JdxC x \n  \\  Bp-YQ<( V e\ t\  \'?(     \ e\ *\ \0 \ YX[\ K\\ 2\  \  \ 9mC  @\ ۲eq)\  I ]\  L~S(\ Lz<\ nro    Ɗ \  C( \"k \ mG !	 2\"}Q &D\\    5 @ \0p\ -R\ RB\ (\ \   \n  r @` 8\ \ j  \ % \\\ 8 \ \ eg  \ Qʢ 5 L\ @R̈́  D蜇e^d\ \   eee#\" E&8\ \ ڀ\  Ã_aMX\ J ]\ \ ᅵ9 ST>\'1E; P\ k\ \ :G^z2 -\ \\\ \ ns# E + $/ \ \0.\0\0\0\0\0\01 !0@P\"2AQ`3aBpq \ \0? \0\ +  \ Ө  V   EiEkZW\ /鏡| c \ ,  _ K     \ o Mj\ \ ^ |̸ K .RN} \ |j     \ . \ ^ \ }
\ T G:7TF{ f \"\ E P\  Y[?c(X  m  (   ֓]ȍ َN2\ ?\  , ) \ ݧ Ŗ%~ ޵ \ }~  UΛUX O\ H\\	P   \ %֟G\ INIГ  N m   ~ \ ҳk iz 5B._ J;]il\ \ \ ++ $\ 3on w\ Xc\ .\ /\ ^ _ k  \ y> < \ ǣ9n$\ \ k\ N>L  \"r  \ r  \ \ b\ N y\ 2M HR \ r l ܯ\ ^ \ nF\  \ yT]2  \ kll   }C  g #Ι\ \ s  a\ \ \ ݢK \ \ ;D<N\ \ F48 ٞ+  \ pa  tb  $\' \ ܟQ;  ԜwQ   0q  /\ ~  -  ,܎GЉ\ i\ \ \ \ #| ̶-S \ !-\ ȃ\ \ \  \ ʺQ B\ \ \ 7   \ \\ \ H\ fmnF8  F4W\ ŷ \"ک{ye ]\r֙ \  \ ܬ  ;  lqev\ WB\   -l \ , E \ ߶\ j  ZxY\ \  \  \0X{\ Z-<O \  @\ \r ۢk %\ZwѺ:9  & \ZH  Ą       O\" 	n \ [b\ ᛚvN)!+\ \ \'R\ \ | } \ L  cUg\ g\ \ \   \ G C bB[ <G姆\ \ ˿ &
]\ b   \"^?GӘ 8\ ť\ 	K\ s\"\ q Wٙ淵\ 3J\ ` ~OV Qd ]نJP\ IҲY\\\ \ \ ( \0  TO+   Ϲ < o\ \ = Œ  , c R _RD }eǼ E_Z1+f\ d \0\ l\\   ?} Ive E\ 6)  mr\ \   \ \ F ˗b\   $\  \ 4F4\  ݣ$  8\ \ \ /Ƚ<\ d ]\n\ <6J \ ڜ 
\ M   \0   3   [I/ؼD\  r  P TE \" |t\ Vn\ ZQ]\ y\" \0L 8܇ <  -\ \ \ {D  >     X \ 8  6\ ] g \0Ҫg    cl  p =i\"m\ < C\ d  	F҇  #% \rY? T +\' ˟C#]\ |  Ȼ E$ ty  T iU 3 \ \ ]    QK P z(x ǂ, d}/ < \  \0F\nm \ \ v eD\ \   uԴD{w<\ A\ \ l ѱQ\   \  yy\"\  Oم: e D\ \ E-\ \ T  1n  \ \"\ \ \ ]T  ˗ ,< V   R  +YKo\" |ud \ %bI|  a   \ rG h\  .D\" n 59 L\   DVE B M ]3Ή < zJM E   %Ψd  \ < B	 %\ ]  3 \0: u\  \ я m %t\ E \  m(» X ŉ   QB oUz!h M V - \ \" i^  _E
ү \  \0\"x  }*E} \ 诂 eF.(~ \  C\   鯅ƌ  \ O R >  WħC  z N ],]쨢 ah ~ W\ W  /䟱O\ _ /  {e 5 6_ \   e  ُۤ¹rC\ $ \ \0.\0\0\0\0\0\0 !01AP\"2@Q`a#3Bpq \ \0? \0\ [  \0 \ Ҋ \ \ e \0mW\ Ye Ye   ٿ\ _\ QE  _ \Z\ >k\ ۭk zYz.}4٥  O\ \  \"  +Z(  \ \ E}c V\" C\ H\\+ vkG +G * #\ |ިZ     \\_\ 1h  G\  \  2>I !\ $  =X >+  - T!\  h\  %\  \0 $ x\ ش| Z + _\ \ \n\ B  \   ~\r P ɵ Y\\]IF  \r / F  \ \ vYzǃ\ X mQ&$\ \ \ / J O 3 K% \ B  u(  ▻ B \\\    \ 7b7;  l OǮ v|v+  \ \ \ \ iE %% cj  H \  q_\ tZ\ z[\ !  \ \ \"  \ \ ;E U]u M\ w\ \  QEv)蕋  ؙ   k  3 cc\"  %B\\( -\\Of^LPRVǎ/    I\ k  tͬ\ םa \ Z\' \ Y  T{  { \"{1=  L z\ Oy\ 2/   \Zd 5u LRk =6oqS e   ,| ԍ  \" \ \ \ -  C*J MJ   ҝ {  \ ͌ bMY\ \  \ l   \ \ \ `\ \r    $ Q\ r{  R臢=: [=fJ[uǑ\ [  \"\ ̒\ \ n\ }P\ \ d  ࿎8 %b }tÍK\  \"Kk %{}y \nh \ \ | ?apf\ Z(  \ \ .  \0ʌ \ \ \ n  0\ 3\ \ l  n z==7   fI\ \ ]/H˥p\ -# /m H4\ H  mD \ \ \ \ J;]i ; G J\ \ \ pf)y2\ PV ^  ~ OO  ew!\ mQH  e G =7 \ X   8\  zo\ OQ |z  Lɟo > h^ 3\ 2\ R q  ( j  \ tc  \ \   1   r \ 7vK~O   \  Ԋ Dq(>  ^\ cv\ Y\Z  D3\ \  % Iu2\ \   \ \ <s۴ f  HV cEpd| \ cv.\r rl! I\ c+ mmY%F? b : .
[  \ \ ֑C   pt \ \ ʵÏs   \ 6   % VJV 5\ 3q\ M \  \0R  _   GFg   i\ =OW x\   \ \ WK=; \ E#bc   a v  qkI Fޖ\" \   c7 K\ 1:   E ?  \ A>{\ .  \ rsv \ & \ \ *  u 4 \ \ \  ]   9 g   iE ܑ  \ =\ O&\ D;h h /YdQ%6     ^	~   TC\Z  \ o||  \0Cch k \ ҾԆb  +wLª&UR\ \ ˣs~Yhz_v\ \ \ !g  I/Qf\ \ J  n 	R\ \ ~5 i  %}i 3$h M  u \ 73 6    \  1\ S#v   7#$\ P؝!~r\ ZF] ֿ \ z.\ r+\ y\ { \ \ {   p \ \ 1r 85\ 9l !-  o\ \   9\ T{\ \  K\ E  b  -sy  \0 =   \ \  \0\ <J1=?\ n - \ ~xH\\W\ ,nJаH^  ̘\ 4 R\\h\ \ ƿ\ \">: \ \ \'6\ \ 7~8_M\ .\  Z   >u  \   !̾Yz\ B /  , \ \ x\ 륙\ S\ \ ʇ y   \" [ h ]  \ \ \" { \ 7l^t  \ *\ c\ _\ 11vSe  _\ Evl   !vR(Z1
  [ h ] , \   \    \ \\( \ \  \ \  e ٿ  \  k ]  \Z \ + zQ_q]\ \ \ ] /J \ \ \ *\ _\ W\ E\ \ \ <  \ \0C\0	\0\0!\"1q 2AQa 0 #3@BPr Rb   ` \ $Cs \  S \ c  \ \0\0? ^Ad 5    O  K2 l\ \ tS    \0 2Y \ \ i  \  \ \n ~ao7\ o \ O{B \ \ U \\B \ ?   \ Tۯ\ hV \    o-pR.iՁ{OG \ \  ?G{>\  \0   ! \ ^\ \ `   o\ Ȓe* aE  \ ׍F\ k;.\ \ b \ UIn L   \ 4 p ۚ  ? \ \ ĺ nʇ4\   K Q  s0\ \ b \r\ q N M  os~\ $\ YlN\ n > \ b * x4* \\U\ \ |\ *_\ ǸT   t+\ J  \00   |1   I \ \ ,A~)+\ c$y gv%V/ V\'8    \ osC     9 -֑ \ \ ߣ \  |\nx * UT?\ 6  ܐ  #\ T	-\ )W\ 5H  \\l & \ ޽dMG \ Gw\ k\ W\ r
? \ V\ \ \ L U ұC  ʑ \ e {DXQ&:)1ť|\ ]\"  Z֞  Y s\ \  \nO - \n \'Nc\ \  ]<C U jd     Y +7 %<\ \ \ E\ \ \ \ #    I\ J\ x@_Tr\ \ \ <ԉ  \ \ \  J , .
  + \ \ kuay\ \ \ |~>a9󛳵 )𶨸J  T* [ d<\  \n  -    \0u s\\Bxq    \ eeD 
+j\ K
 Y\ ,LX \n j\ \ 6pÈN q\ U \Z  \ \ o   \ \n + \ %BŎS\ 3O  Bt\ V\   ̿   \ \ d Ylg\ d  2[ d   ͪ \\U\r mR\  Ma Ud\ V&y-\ j A U>\ ᠷ2     /ʝ &  \ U\ \ ` \ ࿲\ ] r-\ n  K%   Ȭ V Y \ k5 \ K% \ \ jK5 Yl\ \ qY~V\ \ Td \ \ g . ٞAn9\ gr ǒ  \ {\ \ x <*S , \ \ -&wO tO Mf ~K% \ d?\ 	3U\\y\ al׸ \ `\  X 7\ iSij\ J|   \0 \ :
 !=\ \ > \n t*  Kp a.J >_\ Z }  \0 ǹ ^ @   A?O m C\ \ +V)Ë  + Rp z\  f\ 6j \ W̨ \ UZ~ w S\rq\ | E޲ E\ \ 5   v \"<H~^65ڬ3jw  \'\ bT(0]ʳ_ \ ;,\0 S\"
 \ \\F  \    \ Y  ѱ+*  +s l  \ \Z܂ \ v\'E| \ y_y  \ (\ c _\r   :(|\ \ v  Q\ \ \ \ +#mbߓ *C:\ UV     L  \0  +C \   zEgag\ Jg)#\ 9xY 2
%  5  \      .    <ǆW <ʟ 4   \ cM8 ! 1\ ]w+ߓ\ \\h \ M\ =Y   a  ׅ_\ B    `Сy  \0t\ \"? \n \ > _!R \ z  \ \ D  ]U  M/ \ -!\ \ r\ D C /4L m  |   \ o% <  	\  Y\ K&7     {  * \ A\n o   . \ y ڷ\  \ {\  \0b   \ \ \ \   \   { ս [ \0   [߅  [߅  [߅    \ [\ yo- - \ \    \ *~  {\  ^  \ ? \ &  0vDH a Q\ B=<2 -\ i 2 r	 Y
 \ ~\ ^\ _x\ T\ E c| 3 ,\  SƢǽ\ 
 N- \\ \ Nh d\ rO{H\ |J  Ğ z ^WH\ Эȍ쁔\ .) \\\0s  ZB> \     0\ 53*!l\ \ \ \ \ éXIMs    y i5 \ v^\ 8K    \ sb L\  [ < \    *  r\  \ \ A S\ 8\ \ \ \ \   j X¤\ dhW   2 3T \ \ hY *\rq\ D\ O!o x6^\ cQG N w]  )9\   @ 6 HeC  ʲ  \ \ j rr  \ 1̐%  :Fx?\ 3E 	 \ \ \ \ }>Y~P\ \ Jc- ma+1\ , K \ \ J\ \ T  hli\ \ En  ,x J \'\ \ p\ D  . \ 5T\Z\   \ZZZrF\ M \ w  I 55>I Y Q     1@Ę mhs x  T>\  \ D \  7R|G 
\ n  sn N \ \ g6&i`\ z3y k?    ?ʆ:l\ 
\n ?  V \ Y \ [\ x  +}\ 2 D  ߕt \ o \";\ z\ ˢ   2   6\r  J4 sY, K- \ Û|7\ +\   \ \ X\ \ ٦DP xBa~r  o a\ \  \ 9\Z\'z; iŀJ P \  آ \  w \0    \0\     \ D\   P \ *P\ >\ њ\ ; \ kS\ &  \ Ka   +$\  \0 C[  DrW -Ps  S    \ M{\ \'D E\ qI \ c \ \ Xwx  ݼ\ \ 6^E 4 ֞ ң  \0V\ ctCM 7 K\ 񕗁  P]  Ko&G  K h\ 9\r/\ns]\ \ uF \0 \ \  \0  \0S QC . \ \ !  %u 9(C M  j   Q ƍGl\ 3 sT\ !    s% {   Ӛ*],M k\ \ \ 9  ^ Ԗ  9 9x\ 
   \ & \' O \rl\Z.\ 3 MW        \ q\ \ S  ih _S9( \Z  \0\ re7= TE    \ \  \0t\ E\0ET xZ19Ф9 z8ql;   #1{b\"  	 Z %z\ e z  \ \    W  X7Z  ly  O  9  \ \Z 	\ \ > *{D@h 2 \ \ {\ ©iը \ ey/ 幼 Q m   L  9l5
  <  \  %J	\ \ 3_ Q{( [{\ )  \ o } \ ǳ E] y \ \'۹\  \ fy#\ u\ 
k\  \0  \ Oi \ZeJ ݓi2 \ 5\ CE~R   )&O9 Cq\ ӭ  78q*|F h ٛT6   \  m\ v},,<rX_vL\ \ aon Lg\ { 5R\ dM Hg     > \ \Z \ *Ҍ\'i \ ,$ ̪ %\ CQ\n  \0D mc @   ] x5 C \  & \  aq \ 	#\ \ B <ԧ!\ \  W  \ j\  l6͉qR;ƮXw  \ L  h  ݙ I ְ  \'oG+   \ j  D &\'YE $=  i\ Tm \r 4n    [ƈ]\ \ &\ ޕm\rP\ #  \r\ \n \ \ O4\  SC~y4 \ G\  .\ \'  \0\n\'آI\ i ^ \ .l\ c\ & \ \ Ap  \ Q  v=k  z  G{a ӏ( \\-f NC\ q\ BdW O  Q%Z &    G\'l\  N\ u   # YPz\ \  j 6\ \ m6 Pٟ$\" (<T\ 4 ~\ 
 \ \ IQ \ #\ ?     	 L2	) x\0<\ L & )\ U :   y1C E \ Лho* \Zs \ v!      \  Z ,\ ) {1 o G 9dѰA\ \  x    \  2X\ 4tmT\ \r\ \ *w\ \ ,~    #7C GK )[_  :)\ \ 5R\ M *v T4\ rsNN  \n! 
\ 1\ {        5Q:\ *4   \ \ O @ qv \  ӽ[ E ʩk5\ N D\ \ r   m
$w\ J \ h6+ 3 \ Usq 衄\  C(o t \0V\ ]NǬ3 h\ \ z \ |	\ @-   h 9ah	 (  \ \ <G m\ x\ Hل: Pil\ h    \ )N\ Yy e SZ N\ \ lcx: }U n9 B#ru\n \ 7  AE? _ \ \ \ \ \ 2ڴ <L\  L98 \ ȓ \ n C  \\ \ Qh7 \ G/2h3 \'8w   ..	  Y   2YZ\  p\ ܵ^  \ ϠFۡb\ W\"S \ \ \ [^P h\ H 	    iȡ:\ \ m   B\ u  \  \ \ 3 6  \ q\ \ ߈ \   _oD=\ \ m7   @\ dd \ i9    ,  /ԳY ؇1 E\ x \  y \ g AM4 2 w b- 中\ \ \'*) 2  \ ䷒s9\ w˒!\ \ \ %\ \ ko!t MBj: Se\ 4X5?  \0  > + t  3i   W\ e \"G \ \ a \ \ L`Ns  f Q|W4 l(uo 4bwD\ vsPd\ \\H#)\ ; 
/#\ \ J \   \ \ \ Ayl7\ .h1 
&  a \ j ] Y| 2\n\r| X\ \ \ C< >  4Y,|\   (Z\ t    +E!4ZMsL >Ҥ 2<T5
 	 \0h [>%uj% >    \   L l ?\ 3O \0VO  t\ \"sT\0t  \ QK    \ M\ \  +  m\ ̬9쓳\ ; s J`\ 1   *c} a5\  \ jv  BkaB \ M  vt\n\ s d  *\ \ 9t \ . :ǎ  <  R 	  d Z \  LL\ CP \ K UD \ +EA$E \'#<셢 :.\ +Zī%\ \ f v ]B 6bٗO\  cK Da mky     M  9\ \ R \ \ Ly&8q^  Nz\ y: fw = \  \ 9  \ \   n  J\ j Y \Z9\ <1 |͇Q \ Ąo\ M  \n  -T 6\ T^*  ޤa \  D  M \ =\   ׀D   W
\ \n \ \ T\ GP /H8 ;l   CLP  \ f\ \' B=\ *n2T U[% Qp\  \ c\ \re\ \Z  \ \ qȧ3 \ u\ k^p   |\  MNܕ3\ \ n{Bsؗ \'f\ ^@A 岤A    ŲA\ !Ú\ \ s 	 M \ j \ f  \ U2#GCl1\ 8   l 1\ 7 >  \ \ w \ <0  ɷy|@\ C\   ӣ\ 9 Lr  ! \ w\ Gm8d\ Ux  j 5MP{  \"  \  \ & \    \ oR o\ cZ8\ \ \ \'\ Rٕ \ !Um Sq  gzJN\ TS\ \ \ .fn\ v\ K D\\l\ N   \ _  G% oCF\ Y\ b\ \  4\n\ I UU6 UNi䝪	 ʐ lp la \ G\ \ j \ H\ Xࡑ\ \r> ͞\\P \ rS SPs\ P\ 2\ 7 95   2 Ly\ \"\ \ <q^  k\ 1J@\ l  sB.t \ 5A \"  uJ 츩J ă \ Q \ Bl2\ =T)\  \ \ \ \ 9G \ \ , \ QaͦEN\ mv   㒙 mj  e\ \\\r\ Jgj 0 tgp4W\ ѭWGi$\ $AO ~\ ٮ=Ir\ E\']\ \ <ӧ ēT : \ x(\  \ \ K n   ݐ  p li\ |H \  q?j  \   )&7 (b  \   AM \ U N d\ \ k\ 7\ o \ \  *^ ҷ\" \0b 1  {  J  \ \  \ n3 \0 ,  ,\  \0r߁ ^  W_ tNk\r  ]d   \ 	5M\ \ \ d Sr{[Ǻ s rz
t /v\ $\ q  2E \ T\ \ 鱸
   \ _\ 5R\ )z = N-w\ e9 \ \ \ ǂ \ g\ \  ųUk  \' \ 8  c 9 \ 9^co̓  \ ?\ _t7\ K2 èM 8\ \ \ M 7\ mB MZx  Z2*\ rڼ\ \  R2-fk\ !ʳW>` \\\ \ *ID\ \0 Q> K  kK# +\  $ M \'    m=ا K   .K\ L P橌 T  X  {  \ ė0|Y1 2\ \ o \ Kޯ|\ 4IuJ Nl?\ =gK D  \ J  d^ \ z \0Fp W   5] \ u]S Yq[ \ e\  \ * [ _J  )U \ f \05 y \ \ \ \ {  t\ %\ \   q I\ Ȑ< \ (g\ O3g \\ tW6Mj *   \\J\\ʽ  \ ps U\  h+   oU\"b o   |Ԟ vY    zy    7 rs`G ʑ  \ ;W  e\ HC  J iu\ > \   E]  \ mWEL XQ I\ a4VHYF   $S$  ]    D Ӣ S\ 
\ z;\ \ \"\ T#8 S |G\ *,V  R E \ . Phq E  Sf\ o&ic  l   \"\ \ B\ Ŝ or\n  y*Br   A\ oC ^ \ O  \ M   \ >Jf \n. \ k#Du\ \'J]TF7vt@ 6m[z \ WU푢t  X\', ߻\ S  	 \ \ \ jɾJ  [\ qj\ 8f /Y~RIN# GU} 	 J \ =T P 2 \ \ <  X9  \ \ \ ee\  f\ l\ {y ׽\ kJ \0 3j   \ Ǝ\ nmޭR x  \   y\ z   \ ϊ+ bik[ WN}T  \ Cs \ )\ \ \ hd6 \ \ NM S} 5 T ۝\ <P\0泰5 n(z \ b+  \ N\ B M\ nȨW   \ o\n * \\\ \Z\ \ ߑF\ 	hΥ8 4%% \  * EA*lqiX   \ %? 	  LH\ ) CU\ I  ۼT\ j:\'}\ \  Ň\ c   p SͮR\r ֖Ee\ \    \ +c \ I     	,\   ^ k\ 5o   [ ^\  \ \ n5d՘ [\ \ 9{\ y   \ 
  \ d\ \ + \ K!\ ^~\ m56\  G  P  \rj \nd  X\ ۜ  \ \ j$h  \0\ \ d.G\r Z\ n #Z\     D/w$=P 9 PTȯuMT\ 7)ò ]E\ <\ vE: \0\   ׂ \0\ W wT 5z
A 	R \    i0 ^\    \ \ V I7   \ \  \  1\r \ 9 odЌ \ \ a= #% 8u\nQ\ 9\'\ d  (V\ >=x  _  C  \ 4   1 kAF  B_ \ j    	M G\ Bǣ  \ k\ _ \ \ \ U U\  ^ -   Y $\ d: \ X- : y Ľ\ ^ \ j  ͗ \ \ \ ƈYQ5 ْ  R\ <P+    \ V    GՏ    z * 8&Ba \ d\ B5\ bJ vb  \ :\ K  7]\ ^   L\ 
\ 
 \ dF \ \ B}\ \ \ %H H g.*\      =\ op t \0R\ = B \"]\ & \r    \  %\" \ 뤚\\. U  p I{\ ^    c \\\r\ \ fת \0*P  ]D { \'R  \\ # I\ NE\ \ \ 4Q3 C Ssp z U 9 \ .   \ \r   {   5  \ \n \'* õ  Mg5\ BN\ \ !tdН}E  \ ǝ : \0   \  L  : u T <\ LY %  ^ \ \ ;\ o \ g\  U  jQ  \ !~\niâ\ 	\  \ KՂG\ \0QWd/^\ 9?  и(  $\ ,8\';\ H  M r a  M\ n ViΑ<)\ bdA W ĔPf  ]\ B \ \   \ 5\ \ \ 6g\  \ Ew\  \"\ 4  ҹW7ȬQ   \0u_H \0  \0\n  %Q \ \ \ ~?\ g% \ pX\ EL\ (h\0q(n 2 \   \'D   7\ \n(fM\0\' + \ p	 6  \ J \ :N
 & AM \ t^ \ 0@):]J =V \ |   \ ` 2 &ۥDy Ua UX\ _ \0ʼ\ 1\ E5 \ \ \ â \ \ ;T^\ H#x  eBh zr ly\ \ \ (f颣?+p+\ \ p \ \ \ \ 1 r\   N\ yt NF,\ zi\ \ FK) ^\    d \0Y -   \ \ ,a (na  Not f      \n #ERM  S9I4>\ ;   sꢼ4^ j  R  dH̺\ dgcYp D<a9 \0\ <  \ 9Ӕ1\ :A gD֘b S5M  P \r\ ^     )  9^k K 56 w[ \ W z \' * `\ o 0p  ٝ\ 5\ .<    \ \ \r\ Bu \ rQݱ \  J \ \ \ \'&\ \ 蒤O£  jN -t \ HMd e Wk ӝ    㟄$\nн\ Mz\  oK\'\ h   \r  Ɗ U   \ ]kvJ4Y 6\ ckD\ A  \ :  \ )\ g$\ Φ  XT1pn G  \ {ѣ   \ $]U\ &      a P\ \ k2  \  [g\ ^ \\  S\ \ ! S[ ߙ)Ű[@  H\ R!O \\$\ ,   Eu\  \ 
 ׅ -B C q \ \ %\ \ X ɶzY\ $\ S \   `ԝ ]4\ 2pN\ I  -   * &\ SD\ W \ ,آ\\     h   f   \ SNq  ( <*\ \ \ \ TEe\ ^{   x|T\ [\'fl X[ z  \"4)\ 0d7 x\ \ hF\"\ \ J\ ;\   R b Yu^ \ Cl\ D W  XwFJw:     \ T  uA7E\ \ ,A]d W \ z/N T\ \Z 0( G  \ U څ \n \ /\ 3O\ /\ ` a<rP  L uGD j$\ J  4 \ Fj\   ; {y !\ u\'Uf iq  \ \ u  d& pL? C x\ ড L\ {d\ $+\ \0ʁwC\  ) \ n  4\ x WxN\ 4d6k L d\  \r \ q XL\ 8\ T\  \ \ dAR \    UK  \  .Ȯ \   ,$ l Y\ l\Z& r۟+\Z 	  \ zQ\ !\ \  12* 2,  : 8s\n3yU6G y]S  \ IO  `\ +\ Y~U	Tr TA 4\0 TB	\ o.
$D E (\ u  \ ܏B \ V
Oǹ 2 W l   -  B\  *!1 VH	 \ K  b!Ԓ [\ ^\" 4\ i\r K$\ \ \Z]  .5< p\ U6\ lς r 7 Ҍ f&26\ 5 \ (L  nG \ ַ  < Kz# f  {?h( G\ \ y H UUUpTY M] eQ \ ,  r Q\ za  P 2-   M \ \0 M<\ F  p9  * ^ ݻ9\ Yt Z ! \Zn ̕\ О` \  l \"\ \\|j  uD ɧ   Ak Ndʋqa \ T w>
 oܢ  z;I \ y\ N\r D   [f]   X%\ u;: \ Q   ŅNW ] \'  Q%\ V\ l^st \ \ \ PD B,h\ \ \ZI\ mtOҜ\  *\  v h\ +\ \nd    \ ] P ]  h HI /K? \0R  MC ( لy\ \ E\ g\ \ Vk \ P\    \     \" 2  G  \ \ K\ & A4\0\Zx9  \ |u~ \ \ \ J-AT(j  ( a^  (L  sP\ N\ \ 5\ ! W\ \  \ -&ôe \ TN\ \ \r@ y\  Nk \';& * #  T-o3T   Q]\  	\  a H\ \ a1\ ©R\ 읢r !b  kT ̛  Qz0 \ )\   \r \Z(# Y.+;
O     \0\ > | \ \ N X      \  j  \0 @q=\ \ ܁ 6 \ O\ zS \  U!\ Wg;  5* P\ C 7%{ 	  #%S \ H7 ;Σ N j\ J\ v mrT>W  \ Y \ %z\ \ \0\ 8,\ l lcy\ \ B    (\ \ <C  ( \  Ѫ\ JNC \ 4r(\ - \ \ $  bJ V  \ j\'OB \ =\ \ XT\ \  \0MVȒ  +   V\ eA \ ))   - \ \ S:5e   !;   \0\ VK \ \  5  \ 	\ \ v \ l7\'~獉  e\ \  \ Ȟ\ ٫ y &j un  \ d /l@\ f ^ -\  $(.9^Q 3q\ aؘS jg\    By\ ˻\ b \ \ f 
W  1\n  &u<,tNTO!cX4B. R]\ t g0 0NSXw]P \ uE;[y d螝 & Y 8 X\ %V<v ޖ  ɶ L  \0x*  \ \ \ Eaqz  \ Jsz(\ \ ] 
%  , k\  !c  ץ< օszv \n \  \ 3^\ >\ S F H|D f *\  \ VY\ U6 .\"E٨    TuQ+IQ1   \ QS\ i ELx   k\ Ect \ \ A% \ j\ OG   ,kt\ 1  X\ \ T  wxh \ C 3R  ld \0PM\ % \ T\ D\ >Yq XD ,D j9ge\r  \ f\0-rv  \ ~ݚSER\ \ qX#  \    9\  X^\ \ R$ \n c \n \ 4  #P \    i\ < & \ G j{y    \ \ enK  \0«\Z %e \ \ k \ V<  G9 Jw\ | !ԣ- \ f r Ir(  3 *  ST=Q (;)d \ &\ M > `\ H  H\ \ \ \   a c   K\ \ @    \ \0* \ h\ {\ v > # uz蜍m \ ): G\nX n) \ s\ s!5\ \ Òy  k\ N| j 2ml  QꂐX ;.%Q\ * MP  o\'}  ,%\ Ь1 p \  C ( H +\ >`  \ \ 
  \n  J\ Xf \  W 쉋 V9\nI\ snn
ә\n ׁV\ M l d8\'7   \ Ê  Щ   \Z\ & z\ F \ {  g UqYْ\ KsTq[ʭ_ \  O D  ׾C \'9ڛ@\ jS` 7T\ k  M >)\ = )l u\    I9\  j _ \ 57P x _\  \ j\ &9ۘ \ M\" \ ? \ W  _0BD\ e] !bt 5A\ \ \ /{1\ bw   2 v4uP  G  {\'D1gTb \ \ ᷏   T/ Y-\ @6%1;)x 3 Ւ ,   ^\n \r-\ \ \ !R    |C\ \ & \ .!a \ \ \   r m|  w eE  & \ ٺy \ lpO1  ӵT   uP҉p Q: \'\ 3$G ZV^J\ Z m$t]r\ o  -\ a X \ ߂u  \ Z(Lmt \Zz q[ %+ \   Z>  7 4u^ z  +/2 tv^ Oq    	T   8 \ \  \ \ K2   \ & ֍M #) Pک6 /n \ \ \  #clsy\Zn \ ;B Y O\nt  Ѥ     \ ES%BD\  E r\ \ ?* |͐  G\ P\ \'f 
]vi  ,RY d \  n$ 7     , &\ \rm * \ \ i @J 7y, ԬOj#4\ \ 9 Qd     \ \ ܲ@p̢NA>\'\Zm \'  \ %Gy   GeG\ )\ {\\ x \ f-i\ <     í \ \ \ {P6    \ \ \ i  n1  A \ O /g\Z]\ .D\n\ \ 7P  |xc \ 5PÏ2 \'\ \ $e$vា{G y( n\ 3 \ YY_ P \ U  XJjxB\    #  \"u* ڸW  *  \'\ P 1g)sB 4&& Z\ %l \rS9 z       2P\ N𰐈. q\Z+\ \ e  \  \ B 9T\ c  /f  \ B\ HY   H\ o\ O\ ӡ^  B\ i \ U[#\ {7  Q#C\ Sg 1\   kݕI\Z G \ ھg  \ 5V  ۤ    s\rU3 l~ \ R  \nsW js(  \ t4 @ , \ :Ipo26f  \Z  \ \ T  9@\ )  Rʯ* ,\ ?] J \ \  yҞ9 \ ܐo \  \0 !  5C\ م * g%   . ? \ GA\ \ 5 U    K\ {\ ϑS ? I\ p꽬+ U\ E #    9  X\\\n\ \ \ \ C=  v\ vG    \  \ Y\ 0 W  -  W  z\ v  T \ E -PO  \Z eE6 & 8Q  \ \ :\\䂆G% \ \ yӽ\ l䲲\ c\ ,ϊ\   \ Q~\ `) m E] ) | C=TN    {y\0W nW Jv Z ݳ
[  \0 v   +  R-3  6 P -Щ |   F\ u^\ \ \ +ލ\ZK0  KV     \  71\ 3^꺭 MX! \\\  \0    FP  8\' 5      񪝏=l \ 80: \ Of \ \ Vh\ \' b\ \r \  C%RVK!  \ \ 1B\ \ E M 7M h N+t     7 d \ G\   Z  A  s QA\ 	;0 \ \ u\   >\ Ja] &  iȯj۫\ \ S _\ \ ˧\ NN\ b^k\ Bi\  uҰ \  R \ 4X\  .\ h p \ \"\ ;   !  S \ A\  \   tF}\ l\ #.%< \ <\ \\\ #5 UFs\ \ h\  D 	\ \n& -\nd\ -     4\ \ ,  6\ y l \ 
\  T \  8r\ P0 QY\ 8&; RE \ y  \n \ R
+2Uh [ Ms\0șԪ9\ K{ ՛W5P  ` ͳ    ^\ k|\Z |\ \"  ?%  < T \0e_\    \  \0 8O _0aK\ ! u
	{\n 1o ( \ \ R \ mT 48uW \Z! \ /H.sG  \ \ E ^\ UrT((l [$ \Z* 2    8s= n\ \ \ \   LP \ \  T Y K\ p\Z 
 \ 
*Ub 9\ 05[ \ T +JТP \ C  G\0\ #-\ \ m\ o \ L,\ {*  V ʰ]\ ȃ     e\\Y\ d Q_\ T* pU  YKg)    \ y\ {fw
پEM \ E_\  e\ \ %\ b \0r\ 2\ Uv40 \ \ X @}\  *Q\ y-  c%UDM\ EB \ \ \ b  , \ p* 1 v Tݰ\ JgTd,# \ ,  a>j ѥp
{\ , \ N N+vz \0,\ \n    \ u \ +\ NF[\ Bd\ \ tF!\ #-\ P|J \ g A\ ( Ĉ? S\ \"  zA\ \ aիv	 N \ Y    *\' a\Z Y\ {J fU[ T}: E^\  \ a e`넯o\ \ D *pb T\ 9smB \   8\ <   N  \    z:,Sn  \'<    tr V8r6^ \ #.i    ] \ C\ \ \ d\ l -\ 2 Q  %n q=  ߽  \ \   ֬q\\   \ 
\ Rʮ
\n A>  )s	 \ \ \   \Z8#-\ \ lUnxY, `\ \ \ \ c \ b[ Xj  -\ \  \ D  LKV/ ߂ ʪx[ KGw  \\ \ X|,좪 I\ mi\ c \ gc K\Z95̤ Dh\ y\    [ X\   j q
  \ Z\ P j  \ \ 53 E  F[ƃ\ qG\r \ \ \ 6y [l\ \  d < 2 5    KN F̹ \r      \ \ [   -cZ( \ \ 7 \   {7  \ \ ڬ \ni]\n R%48\ \ {{   \ dvsTT jىbl \ g \ \\V \ \ *L Y P \r \ \ j \"\ NVK    \ <\ dC\ \ \ \ rR  , ^ъ b\ y, Lsp8 Cq    2 \ \ O  O b\0 fd \r    R\ \' )NaL	$˞\ v\ A] d> C[Vh , \ \ \0\ c\ 7  \ \ZD\ .2\   )mWť  -\ \ QW\ \ D  \r  .    J   g\"- o 3  \ 2Y \ \ P\ DM }$ln o{Gu   
05D:)    \ -  Qq+ \ |: 9\ P   ٕ X!
\ \ X\ ܶ&E     
\0\ xLI
 s@ 3\ \ M\ D?  \" YIb+/   \ |J*   ŁP  IWeR\ Щ   aTL N`e١ \ Uq6 \ 6gf\ 0u \' \ >  \ /5 \ j TX  E\ Uv$rB\\\ \  \ T b -7%Nj  қp  S\ N\   \ Sf - *)9S\ \ [ ѕ *  \"p\ c\ _<\ A{8~k\ JC \ ~3-  / \ \ W/ \ PY \ \  zII\  \ \ 2 \ \ M     N\   } | vx   L \   \ \ \  ىS\ r O\np 7  0  |\ \ j,y )= \ ԩ_  J \r, \ q  \nl\ \ \  MT*g\  %  +\ \ c  \ E3 9Y_  \0e  \ \ Y\ \ \ 蜝\ , \ \r\ D\ R  \ aaY|}> P  碟 P\ @ ,  I V~<   \  PÜ \ \ {8~kz\ \' \ \ \ZUN\  x  쩳/ P \ \ \  W t \ /+3 \ l\ \ K\ \ \ \ E\ *   `YO¢\ M \ {#t ౷  6 	 % ,\ J f , . \rB\ n[tۭ \ z,8\ E\"%  \ % \ \ _\n a2\\\ VUR\  bQ\Z\n n  َm \  D N\   W\ | >#/  d \ {F  J ES _;kf n  @  E_  XX\0\ \ \  
?  \ \ b VSXD     Z\ k\ .`    \ n{T  , \   + \ U>  \ QW     e,Ʃ 9[2WO \ \   :}C \ T  \ S\ fU2  XX; w= }. 	E[+ \ H+j \  \ \0*\0\0\0\0\0\0!1AQaq       0\ \  @P \ \0\0?! /D   ]~ \"  4  4 #O}  -۟`m\ \ { ھ\ ^\ \ iN ڐ$ I$ I4I&\Z$ \'D   jH > Ђ	j  Fڭދ \ \ Ɖ
Խi \ Ճo\\h  ҂DVD@  		F ҈\ 4 #H\ 1鄵~ \ i5=\ 8v\ = \ ײc^_ؖ P \r \0\0Y \r%\   А \Z J - ƈBR m \  ֜ \ \ B 5\"   \ ^   - D	ƐA 4k ĎH#H\ ( =Ak  \ j /  !\ N {L  k\ \ \  $O   Z$@  Q   \ _\ V5\ m \     ZQ  R\ z N\ \nJ`  \0 ̎ 6\ DA\ZF\ \ F \ ?\ ɿ b\ 8  \ Aw
 L\   V 	 4 #H\" \ \ F A	\ \r\ \    D\ \ \   \ZA@ S\ _   &Ԋ  !k	
E  YhCY !)΋:/B\ \ \\ \  2 ds˩ \ !l)   ۛ \ Zv \ rO  s  4\ \ H  \ \ ;  5\ \ \ 8>Cdw b}} r  {  \r !  o b`  0\ AADA  #H  \    Y   4؏\ `HH #X -WmW i5\ \' Rp篭
J\Z .Z^  x   \rfQ\\ Ѿ E\ W U\  \ 2K$o  R\ \ R%e n\ F1*ZU>\ Py n  \ \   Cmv1  I \\ e 	  u\ \ *K 2 2G DF A\ZAA$G \       \ $ \ H ` 4 i			  Z- U ڲ  \ $%
ւ\ \n   \r  S\ C
  ^   9\ k9	    B6 uh>\ Φ  ݜ\r tk L    Ŗ   DD<   \r
  2 \ / /\ \ ٓL%-\ \ j  p  \r/\'\ \ #NS \r DAAlAZAAAD\rAB Dk \    E zЄF ִC  ![ z/L  W\ 7n] }p-P   0A\ \Z1F F !\ZG \Ze\ E \ E \' \ 
ح$\ rg d\  D v \0FI  (dg S.\  @Н     q8\Z $:M \  P@\ AAiAi AA\r@\  \ #H A #X ǥzW  \ =  %
M  &\ {nc\ \ o \ \ \\ \\ O    @ a\ [ǹF+J={j -W \ 0`MR \   e8  r\ c. ~H  V Jy ]9 \0C   B      !2p  \  h я%r{H  <\ i&X-bƈ  #H#X    \ 4         }     #X\ 4 \ \ \ uZ h RH rнHI  \ F\ l\ \ @ 	  m` r1Bw p  4%FY> ,Z\ \ \ \ 6Q$\ i  ? T u)  += u\ 2ɉQ \ O \"o    udY\  \"W H\  \ \ >> \ ]\  #d   }Ȝ:8B!\ \ \ P \ AAAAA  \rAF \Z>	C  5 4 4\  \0\ \ \ n\ DNI   		
Дݾ ^ bJP\ W \  [  [\ BZ˱\ 7 \ J \ Z\'ʡ     \ \  3!!!@ D.\ZF @ \ |\  \0bTj      Y R zI \ ԏ^$ \ ,2 ][1I  I D\ i GgK;   0  DՇAȀgk >\    P \ v  E$  \0 G$AAAAA AA4@ \ F %$k\ z6\ 4KH  \ %ŝG \ \ {!\ \ ck  .T-օ  \ 6\ 3 Ŧl\Z\Zq 1 \ >0  !yCk.  S\  ?c\Z}  Ϻ7 \'\ =? +B \   \    a \'  \ 
F  b? M  \ o\ \    BH \\ #U\ \ # \  i>   ^2)R\ \ D ^  \ H\\  \ ) $   $`H Ο_\ \   \ \ZAiiiAiAAAA\ 4AkD\ wPΰOݧD\ {  n4K \ G ;  p
  \ 
 C /\ +H% b\ {	 \ ub \0 \ sd\ ȷ\ |  A <C!ُ9   ( HL  ~\ \    fxn \ G\ . \'\ \ \ \ 0 A\ZA\ZA  i\" Q) A  \ .  \ l   	~ 1v B  3\  /\ \"  \ 3 Z  !
t > \0bHG  Vi b a!-   O\ \ \ +  DzcH  #X           C\ \ wc_$Ym\n\ 
 $l!  F  ά \0 u\" \0 \ |  \ .q\ 
 Z	9e  tO\ \ GL.   @ H B  l \ \ g6ه(\ 7*-\  \ \ 6 @J\ \ \ ~H }\ $  \ \ _Or \ \Z  !\  \ q\"\n\\GB\'b \"\\hk\ _br\ 0[E `|+\ -\ /\  I~ \0\ g.sY\ k;;\ =	AA\Z\ <\ D  -#H6ӑ/\ fx \ =F -cH#\ F  A$AF >    D ȇHt\ \       A.HZ      H#Є!h #\ \Z/U zj\ C  ,k\ #Ƃӧ 5H EPZ\ S`CøB[Y  &}l\\  ~I  ! \ r \"U  \ ?ƭ  #BJ E \  H\ \ \   \ Th-#\  \ 4      DA \ \ Z     j  ˡ =\ s*\ C lZY }\   (   \ YZ(*				AAzZ \  H   A\ u    )G    Ie  \ \nm~  $\ \   Ь(     B DX \ Ө j\ \  ȫA-  R\"   vO:-W Ƒ kAAAh \ =4H   #B\ \ >4c\   (Nٌa  ;N\ {n!\     \  p\ @    o#D @\ ` \ !h #B\ - (   [ 7\ O3kXl q\ `ʍ U J\ f\  {   $톄  &    \ _\ hB @ _\ C я. } p K  \   i\     =\0[\ ԛo D  \0 A \ \ 1aw \    \ #  \0b\n&\ & \"\ @ r\ < 	\   \  \ ̗ X BF\ y:̧\ \ \ \ l ܞ   \ \ \ \ & z	\ XF ԰5    H  Z
  B^  (\  \0\   \ wn@  \ \ 4` =X ! J 
&:\ z,	\ Z E  j k -.&6 \0\ AAAh\ \ A \nme\"n2U) \0 |  \ QŽ u  \  I -z  	\ \ 8 $տb D \ w䗘 ?a\ YQ,  \0!\n3I y( L  \ kȗ  y %\ \  9\ (    m y    iA H   \ - i:N   \  z1 8 \ d\ 膨  
&:\ \ hвt\ \ zҞ \  \'      / h DkAAC O GY5 \ \'  \ \ \\ \   B\ \ # \ * \ ,.\ {0\ ؖ [{  C ٩? 4 \ L   \ \ \'ub\ jD:?  K졞қ   \ 8\Z _\ \   B\n  \ ̘   2\\ |\ _\ \    8x 8z  > \ %   H   3 Ԛb\ \"\  \ 4   4RJdh4\ /3- 8iQ U5\n{\ j\ u \ k\ \ \ s \  >į\'\ \    *oo  @\  \'\ \  [  ;  \ \  GS\   ? ?jG\ H\\\ du \0 \0  s \ Cdxl\ \ &\ \ )HPc \  \0\\]+\  \  X\Z; BNu, \ZR \Z;\   q 釣\"6M7<Y  X \  >;п Ǫ4   \   g@\ i  \0\ E}\ @\ l ŋ\ 3\ \ \ F FKjf\Z    \ :B &\ t\'H\ 	\ \ DQ \ ) \" S  ˲7k #  핸 *D Y\ &$  ]-\ >  \ \ \"  8\ \"  P\ \' C\ F/s\  2g\ ^ 3\r\ e\Z
 ؖ: dv\  &8r`,3y]*  \' T\ \ U _?c=8fs`6 4\ \r  y\ / 	Y #p 
y  <\ ]\ \ \ |2\Z  =S  \Z\  D  %   \ \ \ G  3      ~tGJKh\ r? M D_\ 5 \Z   \ W\  _   j 0A #E  ؞\ \n\   \ N _gK5        xG: \r\   V\ d \n ,\  \r  \n  \"\ \ Dr7\ + {
o $!F #f  }-\ H  \ \ ӓ% \" sD VJZimw:\ \r M XPrjV\Zl TEԆ 
1p \ a  [ \r & J      \  c bU Qla l Mw\\ 7 &\ \ \ ~ -ϑ\ \  \0 \  j :lZ \ )\\\ 9 ]>Y To\ A
\ K   \ \ A C\ ;a \ zct\  >\  DI \ \  F
 \04k  H_\ \ZƐ$  1;_ &d 4\   Sԙ \\  `$R,\ \ bQ\0 \ \ Jfqc /  U3  N \ \ \ #U2\  Mֽ by˙ D s  t M I f  &  / >\ V FP\  v 2  ú  Ȣ Q s\ \ *v   \ZS t  j\ y\ i\ 7Pm Fh % u!  |\ & J  zܿ\"\ rT bH   4 \ T \ CJ   j  \ (  )\ &\ K)(L\ /| )bĥ  h M& y  N \ G\ &\ =   Cb\ b     4Ǿ  KL $  >y - | ѕ\ ~?   X A\Z}m5f \ B   -C K4\"E{\ (\ \ ʉe  (¤@!   \ < \   q OSa  H   B 	*G)\nR ц} &7\ h   JIM_\ Uuk\ x DT   ,\ 2   K M2  \ %\ \ Eg@   JhH*%(T \ N L =\'I 	ZE X  } ˘P  6bA\ D·rU h3*.M *\ # B*\  \0d y4\ w\ RuX   !  \Zܳ\ I    \ M \ \ = \ \rQx  \ 硙A#   \  o\ R \ pW\   \0\ /R l=  \ W   :$  O Z\ %^ i M   \  \ Ȱ Ȑ\ Jݡ 6{\ ĝ \  <  `  vR \ wi H  \ $Ps\   S俶%X\ \  )R  \ \ tlBˤ   \ u }# c \ ,*   n^ T  J{ o\ Zxp!O ?T6\ R (\ T t= u;7 *]a ~ n\ \r  Y \ Ɣ\ C   / E5$ t1U\ 7C 1 Z   Cp   ( \"&7/    >o\ \ \ HDh  F  }\ ^ ϙȚ/  \  .\ \ U/`  8   &\ \"    \ q  \ 7%%ϴX-	X9 *g[ a R\ 0]\ +\ io\ \"  88I\ Yx 1  X \ 	]3J\ B\ h c H \ / \ \  N\ 	|\ru \ \ Ƥ$ H  \ ޅ 4\  e \ iB @\ Yժ\ F< _<  \ \ \\\r\ !s   c+J  Ut \"=  | \"  \ A,T7+ 9m? 0 [U\ D  m\ \Z X\ FI\ \Z[\ I_(6 B3 H\"    #H NF \ b 1j9o \ \ Gi~\   lR% N jU \0\Z x \0\ rw\  lMUt^ Re  \ \ B\'Y>  >   И r $  rN  ݜ+rɚ|\ \'  Ɨ .I2Έ{@w~\   \ & g|13   \ c\n蝬R  K   OdC3 \ bu   9 ͭ \ ܄  %  ? \ \ \ ԨRW  !   \'  a\ V\Z \ &wݱH էW)x\ \0 % ض͝  , \  al \ \' <  G\ ΄  	M\  \n/ \    p\"T /v1. \  DO  \ X\ ] ,-  \Z-[ 3\ KRYX 3\  \0 ? \ K 醉 ajQ:2͠ \ v͗ X (Z \0ǰ {\r5
Q9ʴ. c\ r) \ K  -꿱c  $,\r\ D\ \  0n?1_\ aR  {1F jW\ F _ %`# ?y  % t| {$\ \ A\ *1<͑W (nL     ޹\"BVr\ & Ǐx\ \ D PIm ܇ 1   u 8 ;  Ar  E   (]dxt [7((sB ok &ۢ$ \ \r Dh ҹ m  k 1\ \     o~ P HG͗< q\ Y!   AL\     \ h   h\ D \  t_Ŀ  >3\ \   
7d!v    l  AN΍`W3H V6N r&5  .\ {C$\ \ \ )	b7  \ (b,	 B\ ?\rї JǛ/f>^% X  G\ ;\ \ }!\ l  D٦\ ?\ \ 2\ / N \ Ϣ \0E D1\ \ kE\ XY-6  S5AFp  *\'̏΅l\rbhS  a .	0e ɶ  c \'R\ \ D /.  \n  Z\ ̙C r  \ V4F 0b	f\n  i=\ % b\ bP1r\ hɣ   eb\ q(\ !j  <\ n!=   \0 \ _ >8 cak   T \ dh6 q F\r\  eUR͹$L`\ \ _Bݹ !h ]ĥ m\ \ % .\   l?\  Nf|;\  u !\   RK*  ͺJwNd\  Sc Y\Z\ $In { V!ٗR\ #}ǂ   Fhxg_у\Z @ k SY?l \ la % /ze \ \ \ \ \ \ R \  
\'`K\ nM, M *G\ \Z\ X Ԩqy t\ \ \ x\rq> \ \" 1\ O  \ /\n \ \ T\  6/HN px\ /\Zm 0< AkԦB\ $\ \\Z 9U n\  KE     ? @4  7t4\'q  5e-  &\ O\n\ ~yB Oh\ \ \  R  ]  qȘ  \ R Y    M\   Ub] ~ \ \ ^\ 
.   H\  #<dH$ J\ \ \ V  mH %$2 \ \r\ b ʔ    2J %l  \ F ͷH O|  \ JHh    \  \Zď-= ]  \   L     BV\ J ۛ\ \ \ [! \ \ \ ~  \ @ \  6A\ 
 |&H9ybN  hh  K\  \  -   ?\ 
L0ۆ 臆<\ ; \  \ \rF4 C\ /\ \ !k z1 \ \ 7 q~\  dZ \ _\ T |\n\ JL g\ ޞ\ 8J$ /\0{7\ZOn ˖l d t1 њ  &!\ 8\ l 7\ ŢY\ cJ  \  _\ \ \ \ \ ~\ \ 8 o  i \ \ \ * ;\ GI(/m \ o   [ \ W\ Hr  m\ ^ \ \ \ Vᶱ?ճ{PJ   |hV\ 6\ _4  @ \ \ ᔪ\ \r ] \ z  \      \ PB5 ݡ  - K d \', j  \Zo  [\ \ .a \"$\ \ U \ 1 X0 ьK-M  SB#
v  \  dˡ e  Q  h ߑ0[\ \ D\ z\ ` 0<_
\   \ ρÍ _Ф a \ /  |\' N 1*? ^  \0M#~I \0 i- \ \ 2f I \ -  \0b  \ \ 
 C : e\ 1:Ry\ J } 2(\  a: c (e\Z \ {\ nJ\ Uq}  \ E W  \ 9+D+]   [I  \ +y\ )\ cH   gah \   =b s K 5m   K 3v \ ؿ \ \ l?k \ !  |\ ^\ J e \rK.Ž+ 7\ \ \  \ 7T߅\ \ \  \"  \ B. c P  * K?# i d  & \ rC)Cp/\ 14\ :( r\ \ B1\ s-\n\ 31xȗ1 \ \ 	 \ 3#a  \ Ę\ .\ D* l v e [Yyf-\"ܧC\ gɹ \ p6  \ #\   DM	U  \Z\ \ \ #\   \"  j k שz  п \ = \ 0IT 2ircUor \ ~  \ -,\ LT V*]  D\ y9 Dܲ ~F\"^\ j\ \ bⲋ _\nG @ %C ^ܷ 
 
\ 6(2 \ \ c\  \"f}\     鵸ѹO!y~HK\  E\n I,K~\ IQ  \0\ \Z5 $   =   \ 
M  c\"&\ \r\ \ 1 \ Z5 2L;9 1U_Gڲ g\ cۖJ \ X& np0\ \   ͷ X[  6L%  Ч   v *\ &\ I0$U^ï5  \ JM \    \ DX dC   i \ -4 Ȳe \ , f \ / < }; \rQ \ s  i|98  _ƿ zV  \0\"   A h\  \ L 	x3r  j Ĳ\ Q\ P% + \ ӎ:C Ɠ!.C&`w \ ƹO  R  I{ \n\ - \'\ 21 doNW\  C $u$N N`  MO\ \ ѝ`  m&  b .\ b$M I Xk \ D\ s ͝I$CP A } \ ȉ d Q X \ Q Q \ M[  $dX 1\ 2Ep  \ 	  +n!A hnF  ﮔ   j ˪   `  \  eꭕ \ \rk(˩2 p     W\ n\ \ \ 8  @{ \ \  j ~  ĸ #C  !
E  [X  ,$8ϔ   *U\ & +$n\ Z\ 
 ֬\ P-d^!s u  ~    7\ \" ( iW\ ~ p\  	  Չ\ \ ,  HQ e\ ڵ \"\Z \ \ \   \ \Z;   	\ pZ 3w %|!AF\ 39n=з : \ \ \ x H \ 3ym8     FNm K\ wKk,  \  * a   ,J  N\ \ } A     p 	\ 5   %VȔZ \ T 9\ 7     ck \ 7Z\r-\ \ t-\  #W!m d|Dѷ   \\ n Y \ O ,ٙ 1% )//6&\ ;¡\r\ \ WV\  \ 5l x&㸈K}   j\ ;  B  	\ \ pߑ & \ ep oLa# \  @ \ 1 Q9 cп /M \   \  \"   H  9I  \ c  & \0\  I5y\ * \ #:\ c )  X \ ( -\ ,LPl \n  䈔ˣ\ ĸ  V 8!\ qU \ )T   \ \ \ 2C˻I Q\n\ D  h)\  \ O\  \ \ %  IQ\ lv\ f\ \  G.\ 6&CE  \ \ - F\ ˁE \ \ \ .\r- A*#\ \ .nLј !\ | %\ R͉C\ w3- s4]>lPT2\ ;\Z\ C \ Q jǄ\ &v \ W \ K;ɽ  aKq*  [ =A[J\ L\ k ա.a% \"WA
w:`~ 7<}  y, \ ,XЃ|x\ l u B C m  \ ҷ{ f\ @\ \ M#^\ \ J\   - 
\ >  l [ \ \  i$\ h\ Sn7 \ ,bܳ\ c   \npu@ &%483\  ^  \0 5%. \ )r\ 	\\Nc\"h\ MB   \ \ A\r   \nhѻ\ 	\n3\" \Z   ;g2ZdP\0 ( P v\Z     \ )L 2I{  t \  <Ʋ .5 0!9 IaUd\ Y\ iD ddH Wbv ,\  d(C[0v; \ \ 0UjG ( [  S  R  C\ \ 042hBϙB   6p Ç
\  2挤>C \ # jX0 \Z[  LF\"DMEK\ ,\ \ ,빗&\'\r\ aj^   A . 9Q\ 1i \   Zg \Z  #P  e $\\ ȃ   ? Z!z \"z I:Mݬ<! ѽ  %  ;BXE k\ \ ?;]0)ᑡ~HEa-7\ \ D,    ew] O\  vَ  ?*!\ I JR\   t\ \  \  >o 4\    nWO\ ?M   7= ^\ 4LFI8x!/ \ E [1Y e2 o#N . B  ԍJ\ ! {\ \\{ 4z (\ m6ׁ\\ %    |6`҈  Ђ\\$ 1 14\ ) JR i  Z?    i b$  ]\n \ \ Ȯ S\ 3  G  \ GV J!  & 9\"< tf (   \0y8\ \ ~   \ Ṍ  ^T@k\nV HM 1\ \    l  UZ\ @ } ` rf ]̏i\'\"CaӜ \ Vd N
}J[   \ \ @o\ Z  H\   Q \ / \Z~$J ##Ƿ   \ ]   \'j!   \ E; \ U \      4E   D\ L \0 \ VP\ g	=  Hl\ ә  \ \ y\'\\  \ H)\ \r  X    = 
E  I$ H ̛  \ /\   \ \ ed #8   \ g9 >\ \  s\     e\ ) 2 Yɝ\ d\ W D\ ˂9)lŤ \"  И  f \'  	?\ \"| \ \ yI\  \ \ wr= \ +  \0LHǶ \ \ \ F%-
|1\ Ɯ\ \ s-\ VF` ʖ7   ҔB v {\ \ \ \  
\ Ρ\ 0   :K-{ \ :J vEf P, j\ k T4)  | LI\ ) W    G\n \ R\ /Yh \ \ +  \0  [ -q[M   N\ u,H%\ \Zpc\ J]\ A  [ðuH, \ -m5# ِ\ Mpœ{ @  v؈.%4HA`H,܊7\ F 8]= .B}\ we \"  h\ Ò|2l2v\ Cb\ 6hꀖ  L\ =  J	\ 9 \ :3IТ z\ fi|   ` \'$ϡ\ L\  }\    \'!\ K%\   @ !ԋ\ 6    \ h\ \ P  \ $ DǼ \  L\n֗zJKsY\ X;dF\\g  ]  *\  \ I\'Bԟ@sz\ +\ 3?   \ \ =\ d.\ c*   ir  )\ |% 4     Pt\  \ \ X V\ ȋX`    ֘\   \ 榷\ J1  `\ OLS. & \ t  [IDD h \ \ m     \  0 K\ *i ]\n 2\\^E z \ \ \ \ \ \ \ HR \ 1 Uh ۖD?\ k  v
 \   E\ \ ep  Hې\ I^l\ R \ U
 C E M[ I  \ ؐ  t ʋo\ װU4%F<\ _ \  \0N%% \0 \ &Z  =Ĥ]\ \ \ D \r\  \ G.2   ( i K8 >6! ԥO\ \"  &  J 9
)p?$ $5M \ % !!( eL% \ 18 {my Vg  $\ \n$  폜 -  U h  ?$\ A YfH%%X ]i!LpI\ L b\ \ r 12K1 #G \ \ J=A#i: ҔM  $\    \ {
 \ :\ { ȠDL  \ \ $4a \   \0\Z  b&_\  RB6\   P|Ƈ ;\" \ & S\ 834M\ F  \ O \r \ NR\Zs8y\  ӵ LC \    y   o
 1 v \ d  \ +\ \ \ 縹\'\ \ hBB( \  A>H    0̈́\ 
\ 1Aj\Z\ H G  }/\"K P \\ , Cq\ \ (  Ef?   \ ! \ >\ \Z Ed y$ 3\ \ I \n ]p9 U \ 	  2r< p )(boa    f\ \ \'[e1%\ \ zAg(/7  U   \ GA\ -  %  \ Bl	T/j	d\\ Z i z  B,5 \ OF \ -\  %\   .     \ p4e  ^   :DJ  \    \0   \ @x9 \ \ \ &W\ X\\l ~\ P\ \ 3\ \ \ n^N\ n 9T  a) ;\   yO\ \ 3:\ *\ VD\ \ ֕h-mĲ%  D6 \ =\ HB \ .o\ ؓG@ \ l
+\ L  \ F| .\ \ S  =\ { \ 2\ 4A  :y*\n u |
\ 15&I\  L\ }\ N\ y Z Oa\ \ 3e9d N^  ! \  l \ ; 9\ b*:	 q ~ Buv%1 $\ iO(n\0F\ E WdJ\   Imo6, #\  Em  j\ \ LuO;\n 4  r%Z \  ˨l[:% \  ȯ@   ͏%H\ #HJ[8ssQ l O {3)y bT	\ \ )l `\ N\ \ 1 yȅm\ 1 g\ 쌗 \ sL   i\ 3\  ieÆ/}\ _ B} _h ;     CBE  \ t 7 L (o Z \ * ei %\n*+ $ iN1a=گq\ \ S _ᇇR H\ \ Ƀ\ U\ Δ {  FG) Y0 R8 4  3 A;
\ F N\ZdLҞ z 6 \ >`M\ - 1  \   0 \ \no)\  K ~\ \ [љv\'1^ O=25\ sA  a  U /nv?m  \ J\ \ H\ \ \ ;ŧ ,  \ j)h    8P =\ 3 )򄎳 ؓW  0 m\ \ _\ e|? fI cvY \ SRI$_\ B45 3 8F\'\ B   I:P! \ 6 \'T $l F CD zx \ ) 4MR9)zl\"$U\ \ \ k:#\ p\ \ 5nߐ.ȍ ( HhgO\ \'s\ ґ	ǜ1cIeE\   ȼ0 W N rL   \ xRS\rO    d   s\ Z $  \ z fl  \ : \ !F\ r\ 7o# 7\ o\ B \ \ 2 &q  B I()x \ o \ \  ,O k T\ D 1$Z\ \ \ }y\  \0 ű DL\ \ \  : \ U\ į\ X \ \ 0\ qn%9  %   9B  \ \  g . M	\ \ \ 	 \ +I
2i  9\'PDJ I  S/  \ ݜiR)   R    \ Z :oм$. FM Or\ u=  }Ž͇1`}   C  c  ra 	 e \ H &\ $n\ = \ W \n N\ sG   \ !:M     A  ly$ I$ I  B\'E\ %\ZM) \ u  e =6\' \\     h  A,<  \'M[1  e( *\Z5\  6 \ mn\'  [e8Ț[> \  {Ht TG L   9W\  C}a \   ,   \ \  nG  喒 }  Hy\ NG R ,  1\ -   \ 2= \ B\ (B\ \ e\ \ 
&T@ yb u $ (Z$   G ?F\ Yϙ	D\  a j 緩m \rlX JP_fDVk< X \ 2 Z v \ q  \ AJ 6 @»\ x *  q຤ $\ \ ?ē\ \ ˼ D \ u\ :dIy\n  \"  Sܥ  C \ | \r\ t. \ I   j   g 7\ u n \ \' z E h   f2e \ \ IW\ y\  Ơ \   \ m\ \ lg x H \Z0\  `  H  Ha7cp\'\'8 ѹ \   \0\ &nI\ Aq  D?ZҴ$=\n \ d\"lKt   = \ZO ^q X \ \ )Q)ve\ ]\ \"[x ?91  \ } )d\' 1f  8|  \ f\ )\ Ա \ d\ E ?n  t\   \ \  \ , qz\ \ F8\ \     \0DL -\ $Ԭ    \'  8  35  mK %	  _#l\   \ n	0h= %n   #\  \ aX  1\'  %v  } e   .Q\ A 0Ҋ\'E-q\ \r\ \ 2  ͝R3k`@ \ p뒗 \ 	Վ\ ?l P     e\ g\ \ 5  FD   \  e3\ \"V < ! w \ j \ $o  \ D  \ /%]   w U\ _ B 3# vdIA	(7;j`s\ dQF  \Zh ]$ c \  I-rg,M- ~\ a3  #[s P)\" Y\ 0  SшZ1 \ ؘ  X\n   (   \ 	 `0\\ K;k#\  0 Oq ;;~\ $f   C .S   G,+`k\ ^; \ v \ d  c\ *t ]J\ AJl\   \ )\ l? \"+%bln u \ ^$%H 4\ \ S 0D   ǫ\ \'\ (?vL.Wܒ0\r%S \ np \ $L\ \'![P \nRS\" Ĳ,  \Z #   \ \  č #h  \ A2\ D	 M @ g/ \ 	9  |\"	\ £i  } 1 ռ^	 ؾ\ ?\ /F\ jL 	4  2\ \ L2X   c % 2\ \ \   i9QbVISaP C \ H {pM  
 Q H \r ah   \ a B  Z\ V E4 d\"h \ 2fD` ]mC  z3 \ B \'rK k \ \ \ \  \ d |\ 
*\ M  \ l\ 	D\ \ @\ ~   \ D KĬMdTQ  r
P %s f3 R-  &\ j  \ [Uy  ,$ \ \ b M QM\n \  Ћ	{ 3   &   (\ Oe G\ *=\ G  \ 0  \ \ F\ 2e\"[ 19\ Ŕ\  -R \Z)e \ H   \ } \ Hgr Q\  \ D\ P%%\ \"  D g\ i\ \"Y^ v \ Dx \   ŉl~ZfM d |1j  \ \ SBp\     L  \ }    I  b\ rq K0   \0F 9 	: H \ \ @\  #cxL   \   uP\ + \\}\ K s |2@\ 3 B 	\ Lr \ 1KK  \ \ J \ O ` \ >   $ m <	    $ \'q?\ Z  \ * y_? \\ܭ s@c 7 rK=ZOD\Z \ M	\ 4\ \ u  \ H  p\ \ mv\ $   | f 
 \ \ C8hn\ %G@ \Z \n\ +  \ y\"9 D \ 	 \ ?  @\ 
 )&\ \ ʸ  \ \  )o  T).\ \ ֱ 2\ \ \ <\ 1 T\ )*DpLN\  \ \ \  ϳ?p   R N\ g \ ]  5\ [rF \Z 7  E  \ \ ڤ\ hc\   E  _?\ \ \ b~ t  m|1 A\" ԓ\ B ,  x   S  -j\ 0 #t R,M^ D\ \ H    *\ \ \Z<\ - \ `9\ \ 9 - qKh\\S  BȮ\ \ \ %  Y
A\ \ o f   rg \rI \"p\'ȕM ƒ&7b\ MH     \ zd )\ \ $_ \n \n    ΃ \   d\ \ -D -\ \  ZD1  +F\ *S 1DO9   ˌNd  B<&ݻ1 ! ,H \   ;   \ hq\ BQ!  [  9\ O$\ J|   9\ *j\ \ qL IR\ .v \ ͹}Ǥ  !wb  9 v̋¢ \ /\ \Z^ \ σfv#6   m 0\ m   bH^K  +OQ&i  #D 4r[8O     |\" X!N|u\ \ \ \n 7  \ P0 3o e@   ( dl= w; r ɚ|1[2K*7?  g\ XX%  <
   2\ Bl  ݖ =\ 3c  \ N > \ B cr8\ L<   z \ OQ\ +\ l xBi    \rԼ\  קq \ G\ M {b   
x>Po\ ƌ  \ YX\ \ \ \ 2 V R,T\ K*2H\"+\0 (\ lK/\ EBb[
$M  C~쾰 %3t\ 4( 59\ C e P֘  #ȸ	. \ \r /$aiB  \ i\ h \ (\ \ Ɔp\ s\ :\ \ Z4 \ \\\  ,o wA	Yv\ s  \ 
$   +QHT  T%  \ D\ 
o rbI  \ndK\ \   I  bM Zd  e 뤚     \ \0 \ Grc;Y*   &  \ d\n %\ \ \ Z  ( ϳ7 ȸl \ \   J<\ s{X  !  p   1   !_ h y1 j$   dE|   C\ % \ >ǂPfxg   D*o*&\  H \ !M\  г|0 \ =\ \ X\ \ Я% 1V\ > \ 8g \'a\ c\ tz\',8;  \ \ Խ I$T +\ \ \ 	+ n\\I\ } !  x-  8cdH\  , d\  6\ 
&sP\ &븐 ^\ y   \ G !\  N{   t n NS\ дb   \ [/I 1, \ W E\ 	)  _s uR`K\ xy \nk\ \ U (X+ ?\ \  Ɲ \0	/     FP(\  h \ry \ a d   f 8   }dK&\ \    iy  LI ě \ nXv$ qD4s  p \ @ ; VRp  2}  O\ %GX    %. 	\ ҽ\ \ 윒> \ e\ \ F Yb   : \ x\\  %\   \ \ \ \n\ K\ \ \ 	 \" [\"\\ \ >\ ɀ D <9\ \0  K> w%  w <  ơ  J ;\ `  \ -\ _  ȹ; & [ ا _z\ \  \ \  \ \  \ 	\ R	u5 h| W \ [\ JCp   q\ \  XX nSP m =IBJ   \ iŦ=2d : $t  &c q\ e S\'LM\ V \ #[\rMOq m  |	 L QvbU n}   \   V	 \ ! F @So;\ ͏\ \r\'   .  Y se\ \ h-  q #!R Jc	p%  \\	 A\ \ g  	&K 3\ f
t U~\ t n  \ ci ꆴ >\ &\  1o rxA ^m\ Յ*l\ X z&iDB*\\ 	;  h b t\"@\ i  B]\ |,  #\ !T\ |HX & o\ \' c \ f#, XCt \ %8\ \ B%h Jc.7  . p} \ j \ W4 d  \Z \ o`\ !$ Rf\ 	\ \ \ Ve7 2 \ \ \ ((    \ K   X	\ I[ T  q=E .\"_\  = \ \\ \0 \ \ Z\ \   \ 	\ %.\ MҶ \ j \ B\ \' ί  \"#~  \ V\ 
r%
I\\p 26)~  \ n-56\  \ R S \ ܇U J#   !   ҕ\ J`|R\ f\ +     d+D6\"| K\ me  \r \ \Z_X̥O`l; \   \  :v\ ŋ- \ 8   2Mw \ \ v$ GI\ Kyl[z!i r  Y<~OD\ DI3&ꂷ vn\n 1\ ^  \r \  \"S  4 /      ;\ G\ lϳ 2    |\ W C\ :\" a\ \  O߲ju A 	H= !X  \Z\".q& \ \    ɶ   v\ wBnQ2\\T\ \ZN\ zݞ\  YGQ#\    | l <\ g CɅ  \r_ \ R\ \ j X	w    T x{ H  \ 
  \ g\   \ e - \ \ tБ\ /f\ \ \ 5\ Cކi\ bĆ   \0 |\"\ ޶d  Km\" 5Oչ0&\\  \"vVu \n+ \ \ :E s:\ oB9X\ \ \"lX\ ^An   \ IK\ sIl  ˤDS0 \ \ \n粄)\ \n _ ))DÛm \ \  4   \Z\ -\   9  \n`	$\ eL\  @\ :\  w- |՘\ > 	\  g QV U#q Ip@Ŗ\\ )В0   | f\  Sv  \ m W\ (ƚ  yR4,(ТN 8 \ B|5 3 Aϵ	kvϨ =\ B\rF  \ .\ A\' w	 \ Rn2VM\ CQ { \ _\"d\  l+ [f\ .\ \ Oa 5\ #۸ \ \ K\ q\ b	\ Ke0\ 	 -\ \ \ c a\ _   ZN  ԅ \ tP \ \  \ \ ϊ\ 0>Z>\ 3=\  \0*\ \ H_ \'ݘ3c#Meg   \\ F3  } iM1\ k  5 K\ I c\0P  I  <   \ +ex * _ Cd  L GQҴ + /\ k\ )   \ \  \ (uu    3\"Ks }   K  O-Og#ѐE  \ @Y f9 F$ , *   #5P+\ $ \' bfa  \ 2t\"; \ \"4% xړ  \ S nۛ \ BD &uf\   ߨ  \n  HB\ \ ņ 1f/&d \ _\"J\r ; ah\ \  \  H\ P d5 \  k/\ > 0  U6`Q )\ \ \ \ 鑉\ \r\ !\ \   ʓ   / 	\  ! \  \ \ o  $t\ \ $N L ;[S \ \ \ H  䱲\ DgG< O 6 \ \"    N N  $ d9ՆT DF\Z1\ B     ؅ \ /\   \ #   >D      	\ \  p    ԝ f\ \ \ \ E\ L3<.\ ; J9R%x] !\r 6 r !r\ s O% :j\ N \ \  6  &N Ip&1\  q   \ E b H\\ N}q\ \r<  v \  &    U,    \ U  /F  Ў~\  tm\0K   &wLyP\  6 D4nt [ \ \ \Z* \ ~4۳  \ ~ H Ɍ\ I%\nn\  \ \ fz{A\ v ߺ0      \0עiӃ  \n\ L\ .-` 4 > 9 % \  \ #\nJ\ \  Ā\ \ \r\": n\ \ B\r I$BX} i \    K \ ]\   ^\ 4X$ 9 \ ! \ \"Gk  \    NɎiR! P U\'  $  4\ x  RJ7  I\ M \ BDMz\ /  { ; \ )QKk 0 \ .\  vʓ 2˳  \ ׻ b1%\ C$ \ (|     /,_4 z\    \ }  b\ Hԉ H  Kc-A q \"] l %\ \ R>\ W\"C   4ZN YhC*# ٲa   nEjtz-*\  \ }  \r \n   %\ u\"    4 )\ \nL  )K  C \"> t#bWH\ g  k =P \r@  8Gqt       \ \ %  d\ x\ A  BHcտ  \ !݊\\ ,7 @ O \ 7\ b& \ x\ %71  \\hT  \ ꁍ \'  z S,u0hKE& V   i\" tQ\ [
 *#\   1h̝ dW  UGOVR `k  
\ S  }tI   \ $      \ 	\ \'G  %/I	 ȯ 
~ \  \   
D$\'1w1  Rfl\ \ C0\  j\   &V[\" - \Z9cA R\r\ >\ \ 2Ƙ  ɂ dH` I&a+\ \       5S\ Z |   \ ͩY\ G\ 	㟌\ ,  c L_ !ü \ \ i\n D\ 0[ o SѨd $   \ F )\ ]\"B- Y (-\ K\ \'A  + HH\ H :  5 +\ \ E\ ͊J	    Q \ Ek܊s\ jQC\\  \ \ > ДPЖ `LP<\ s\ BZ \ > \ \ h* uD\ w\ \ Y\ 0 :uJ, 3  G  &  \ z $\"k  y ^) Ȳ\  1yj  \ \  ̲ Kx+&\"\      J  :)T  \ \ \ 5F CV37 C\'\ 	 -\  \n\n7M y B \ Ȁa \ ?  \ w   	 N  + %$ γJ\ )     -  \ 	 Gvn\ Jw#\Z2I$ki\  =0\ ٍm/h a  % EP2\0 \\ 24>  A \ H\ oa\"%  	9d\ \Zi6    # L p  |a\ \  e\" B\ \ %d! \  C \ \ \n ȅX ;r \ \ `\ 6q H)\     C\ JfYF  #\Z 6&D*}K&  vS  DS  h 2 \ #)\n  * g \ \ &# \ \ )\ (M* 1 җ4п l \ \  m DN\ 6W D     h\ M\ \ jtn>Q uɡ m]-\ H \ 0  O n\ \ 	  *x\0g /  \ n  l y(P? QW	 \ \  ē c\ ۖ \\   
 \Z,  A P \r\ \   i dn?\" G, J HMm _q$   G \ *\ G\\\  \ A  HZ   ~  $X \ $ \ J0\ :as\ \Z \  B  /i *\ \Z\ q8>q%zGbŏi a ق	   Ǖ  0 ~   L  X\ \ BB\   \ \ \ Q\\    hV-\ v ; r( >  =U \' Q  N.PNW  ^v_ɂw :  Y\ < \  H\  $@n1 2\ \  >\ Z2\ ن\ ql Ц/ ! Sm ֆ\ {    n   @\ 6  G\  	 &   ȑ )l\ \ \  Du  )A 	N\     \ \'  \ j i\"q % z hh m  f!32՝{W \ :L bl q^   \ 
  \\  \r\ z  /\ ) ߡ zABЉ\ \ 
\ \"\  \ \ W (d\ \' ǣ  gqh Ȣ oq3
\ \  
U\'\ S  6D! D ?Yh Nٕ \"\\}Ƣ\ \ aJ   =7 4P \ ( Z\ _ \   \ \ ;\  CZ	* P  l  f\\ \    ( l4+  \ &K \ $$(\  ;l 4@\ \ dF Be m\ e Ei; Z=   \r\  j=ߤ{ /\ i \" K C\  [\ \ R\ L  c6\\o\ s G\ \ c s\  
y  FL ˚|	\"ck;| = t 3 fK   \ pt W  \ K  `r 텪 \nOMWr   \  \ r \ (\ =#fQ| +\r	M\ i \r- \ oc\ m6: \ X\"W\ ?\\=Ȑ a2v    \ \ q\ E  ƛ\ \  \ \  \ 3\\  \ \ T\ o  c  J3l `  dڢ   ٥{  \ \Z\"r 9N[>\ .\ qWUؑqS \ 	@ÅѢu\ \ \ }\ \ (\ !  %
`\ \  7~  \ q<
(\ d\ q\ K \Z  #u0 k\ \ w- :   $ ,]g  j67d  D\ \  #\rH\ r\ J!5  )  > Ax Эoq0 \ \ \   |~  \ \ 
     \  Cz\ {    \ \ e(]=/?Ƴ   |PM5)\   RB4t  /\ &\ {\ \ C5 \ V %!%\ ?  tA    u \  6\ V&461[ Y& \'ԗ\ \ G\ 3y 4  y     ݺ \ \  Zwy#\ nʹ   gN \ 
\ z \ zib E\ \ 1;  /R   \  Kn  -ˡ    l B$\ \n  \'\'\ K  \ \ S   \ \ b_  \ )\ =<       -\rK\ \ G# \"\ L7\"  R!6  \nwZ \ \ \ M\ \  C  \0\  P      +k\ \ 9X« n \r xG\ @\ # q \ P S_B\ )\    6\ PM\   $!\rZ  uH ttÛ \ FD4C  市 99  B`@  \ \  A\  a * :  \0 \Z1\ ?|2RG   ̣d  6 \ ނ \ ? 2\ (]G O { Q [  Z\ @  ey oA  5Ŕ1m< 3YJ Q{\r  yH[  {a\'fl>\ ПQ   ?9 b\ \ GShB; QD| y|B\ ĢR\\# 洏E\  \ mԾtzLC2% #1[s8W\ M .x6N\ _\  I  sZi\ \ \ I ؈=	\ IV \ t	7E9\'  \  $\     \ V[ \ r\ 	 &z \  \ v(OF      \ Q;a$A \'L 9     cKN  &} 7OF   \ 3w   Ѱ2  l\'֠  _S,{X\ d\ !  LE  ^\ \ x K       \ \n[k { A$L \   X[岄  ٿ  \ /l1=\r ?\ e4  AMM ^\ N(z   
 c*y+I\ hi H\ R  \'\ LC   |ɰ\ \ `IM\ ț\ F\  4\r \ 0x\ )ٯB;(-  	ጩ/tY\  L $Oy\',nRme  \'\\    \ d b\ I4 m<̈́+mhE`98% # L   ĵ H `\ 	H\ /a  \ RC\ |     \ a\ 褕  N \ w\Z  Fdc   @ZK\'\ SF\ \'>f Gq  \ t4F \ Nᅙ\ ʟpĮ  4\ \r  \0yꐉ\r\ \ H  ܼF @    -#$ ӵ@ \ \ z  cj3B eF\ EV  4LB :N  F\ 5\ F\ \ Y)\ \ # ?( \"U  @êre  \ A\Z   -d\ y) \ u \ 
 | E\ \ \ \ P \ +~\ uD\  Qb  \  ӧb9 \ \  >h,;Ѡ;   \ 2Zf\   =Ob*ס   Ñ  T\ `  OF x \  pF   dV\ x&I<R\Z`O\ \  \ #B^  \  F\";\ \  x   n&  X \ \ eE܆\rP \"\ g\0 4\Z\ \Zp    4\ \" \ \ 5)   9 ؕKe  zAMʇP\ /  \ \ 3 N:w - F @ h\ \ q\03p\ \ \ \ \n ` Z Ĉ\ tx\ m : b 8 U\ k  \ \ u[ %$[\'c# \  .\  ;3k\\ \ %  &r \ \ 3i  \ V -\ тudLN 8\ \ <\ $<\ Er2X \ !1 ݾ( b4^Lt\r \ Q9 eNE   	ɡ\r!   yL\ V \Z \ \Z V+\ 1 %ϡ\ գ. D. 	{. rubs ì\ b\'T/ \ \   \ 44ؒu R   Ƅ\ h\ (\  	S\ \ \ 7i]M  (M  \ 8%\'nHCS) \"\ /! % \ E }GO\n4H  £,@ TQ. \ \", 	 Ch   	hNF  \ \ y\'\ Ak \rhH D   \ :n0 ?S\ \Z \ \ \r\ \ \"ݜ\  J |  n!\ aI( \'D BGbmEl`a;\ E    m S8H\"Ma 1\ Q ao V   *JǈM\ 1X\ \ !    EgT  \    \ r%  \ d\ \ $1r\ S `d o aѣ   $ 1\ \  W X \Z*  F Dώ#\ \ U k y \ ݧ  \ Q] 	H\ \ \ \ ,\ 12       L\ P\ # \ \r Zl \ #P 4R\ ie n!6MJR g l  &A    9\  CmH\"tD\rS    $  tD  \  +,r 04`\ C`SG Y\Zh~ \ $ Z(I\ I6g\r \ &` U\ \"  D 9:   ċ% B L \Z;z   \  C@ wD, 6%M   ;\' \ Ј[r \  n	  xhņu| \ T\  w$Wh\ I7\ =pIb\ \r  \ nF  K \Z t  Ж    \ \Z  \ q\n% \"tĠ  wI 	\ +  #V\ HZ\rah\ \ 0H]P  :0 З, T\ n \ \  v\ 춖o   \"G7-  I zN\ \   8\ \ \" \ \ \'Y% >   q\ :<\ ϢlO J䓠j (  )̎  C\ \ \ \ \ Zs\ 4 \ & b \ZLO\ (\ mB H )99\ R\ \ 6I ϒ[ \ \ *D.e39    \'  g } <[G \ RM\' cr\ .m ZC\ R\ \ X\ 	ЉKP  \  % $ ! A ( s\ ye \ \ r MJ  +p}rI\ \ / ^Y  \0\ 2a\ ,$$$A#Й\ \ \ a D3`B\\
l\nXp\ M̉! L\  &\ @ HДH   lLL| [Eh5  \ x{ R \0  y\'\ P\ ֬\ z5 0\ bI X  ( tdJ \ \Z	 \ \ \ k 
\Zo  \r\ _ \ .\ H 8\ {\ GÐE(L Xh   \\\ 1 \ ̓П$  7- 0\"`B\ *    \ D \ z  Rרjt `H m  $A\Z  # \\2 j  d{&\0%a̱\ mF\ @|IN  K$utI<N) >	\ r# S \ ! 5 b|	\ Z  ;\  $ia	$ED 1 \\    \ F  Ƥhh   @ \  \ \ 4PiH ld\ J  Q.~ Rٕ6 \'-OA:y: |$\ ` \ \ ,V=`5 #   ɬ\ DYnȝ  \ \ &\ \ u$ v /p Y\ = JǸ\ R\n    #X {z C )w9 c9\ =0F  \ A$@ F\ ;sd0H \ +   i \ M\ HM\ \ Ȏ :>\ v\ @   {  Ube1\ XALa;  Bm `M7 ۑ    6M D ȃM f\ \ \ H%(1 F hy\  \ R9
Z1\ 7\ + Вe\r<\ -  EJbk  f\ xHC-v:t} ߮\ ($\ 19L AK&\ H ,8! $ z~ j p\ /=\ -  nܝ\ \  W t\ \  ̴\ \ \ R 0J j  h #\\$h  F\ e\r 6\ m  KI\'H % !#GuވT۱7 & \ \ !\Z3 -Z$F 5 K%R\ Ur\ n)    L\\\ \"`}B b\ \ *\    ,l thD Z a    \rhh    ( \  h  Qܙx \ .ʋc L L|\ Y 1  \   4@܉#  K  $\ 4ZO `Р   t &m! һ  !$ K   } \r\ =J B!	W i+QQ\  cԌ І\ \Z } `   % \ uZH\ %Br V7 \     \0C+ 0 #I$ #tћR b  V* A\ m 2+\ ).c  : Ps  I$   F\ 3 K  % D\ D\r\r:3\ ; \ $ J\ \r = O(袈Jv cW \0rt \ \ sdC  Q;P\ r*! H%!c\ A  P ,菩aܧ 9 	X\nnCȴKP  ҥ ,\ F \ ֐B HD\ L 	\ XA\"\ } 6 @\ $\ p     \ \"N
 
U0  `r z/\ \ d%  - 9cB& ГyD6 a  I \ k&u  \ \ \ \Z \Z (JXAJ42(\ I_ \'\rCb  cb 2A  D K G#\  (P| @\ @\ !  :F M Lkٳx\ \ O\"-   gb7C\  s,  ! 䘄  \ D- !(\ z Z $%bBCސ\ F\ `v  m$&* KB  -gD J[   \ \ }]˨n T(  0=
\ ), \ \ #\ KU\ hF\ Y4 \ \   !eb\ L{q  \'Y\ \ Y\ k\Z0 \ x`A& . S$|\'z05\Z4< hhc   F h\ 0 	  KNt\ 5 \ \ ĸ 8)\' \ ot34\\ 8}\ u y&L Ͻ  䖜H\ B[\ Nޥ Ӹ @ BB  c8-8\ @ \ Z \ b JHЙ:Lm#[w Cz!V-*r \nvN 1\ 艴 ] \   M &% H\ n\' \\c \ $ t\ \ )\ K\ K  :! \ h p$DT lIh^(JF B! m \ G3>2,#CBh \ hjt0\Z\ v  m  mg\\\ \ V:9  	 
 ( \ $& n\ \ \ \ <  J#M \'у NE  b\ bQC۴f 0\  -\  = > _ 	    8\' ;\    [Ԃc\ \Z/Ki\ \ ÒrHٖ6e\ 3\ 7`  F\ Z !\Z=6 S\"ʅ   u \Z-V i  D4Ґ1\r H#L\ \Z-LŎH  o I \ s !m5 \ I hn6\'Fl$A\ 4cִY  nf Q\ T \ p ?  vD\ b   &\ ȕ؅ \ 2D\"    @  SC&D C\ \ YŊW$Jr 2\  t    1\ \ \ J ᡍ\ fɖ kV, ;30    @ J\   f\ \r F7   C ǒl \'\  	 \ T\" ` ,XD  &1  p B$\ #H8 I\ |  c - \ f\ \ έ \  # ѩ  н\ cXa v\'\ \ \Z 8k\"\ Lc    H \ hz#RH\ +X  BZ/B \Z\ { AlS= X  
GCi# !B \ X%ܛi\ q8t,\ A! Hdn\ \ ? \  RB) B]ѽ\ ڪg5D p   C1̒I$     ٌ $     Mz ^\ 4 JP C \ \ : :m4P  ! \ \nH0  { FX )RpԒ  :i \ \ \ 2\ A ]X \\\ MK\Z   \"\ b>\ t
\ =  \ \ LHHDQ . \ \ Y\ h \ Y>\ ئIpt#ݣ\" O=,gZ $߃  \r\ 2\ \r  V /E#P )Q\ 4  Dᧀ\ 
\ V i6 5\Z\ `\ %xc  \'  q  ߣ\ZCy%\ 7  1\ \ $ @\ a +F     ]  Rll   ڈ\ : y\  n\ 6\ K \ \  ^\  ?m# l!P-^t@R-S\ zMi& y;i B\  !zV4Z\"F\ \\    + \   O >n\ \ d5\nMn,d#z[hB Z:\ r ^ *\ )\Z\ m$f    \ S6a @ė  ɹ	   \ $   \ \ ӵj \ \  P 	 6 \ &1j\ \r BS   $ I 4Y) P 44%  D sp\ \ \ d \ N ki\ Tزlx0,`Z-&2L   #ai\ ]t*=+T D   %Y\ \ \ \ :\ \ \ :  >\ (E   ]6Jހ\ %#  ^  v\ 1 hE\ X 9 $R c~ ! :B\  i  $ [ Bm W  A\ -	$Bb  \ \ FǄJơ  QṔX \ =B \ ƾ  $A\Z1ā\ J\ \ n~\ #JNv !\ L\  M\ tt. fF J   \ \ B \ E \ ΋E z@- ?   q  Lt\ !\r K څ\  \ )& I\ HC L \ m\ D5 5 Z0-I# |\ a:t; z	\ )`c\ hf}2M\"  zV    Rl  C \Z] .a  \ l7  \0I \"  \0 \ F !\ \'Ϣ4ǢP\ nI $\Z\ u׃
N\ \ \'Z\ :o\ ]I   Z\\ Ih  =V ҽCf ]\   \ x :\Z\ 1d\ \ \ /CR M  *\ kD\ \n8}\ \ gA1(  +pO\"  b\ [ KQ\ %d\ 9 d  4 >  ,\ B25\ N F\ Äڧq 98nH62 \ /\ RҌR\"\ I\" @  tU\ m ݐ\  \  Z=p{\ \ v,Gl\ \ v\ B վ,  \ } \ M \ I \' \ cEG\ 1\ ^ m\ B  \ Kb.\ \ E     \ \ z$D1\ J d ; |\ \ НѰ l\' N 8 &\ ˑU\ \ 1 H@;\ \ \  8   2 St$\ \ \ ^ #:i \ -j\ \ K0  +tF+  \Zr!P   \r H\ & \Z \ \ #oD  C&>bR	\ ω,\ ^ D\"A V ]` \ \\
L *\r M x bL\ 1\  $ 	    \ \ Z  ȨLBb\ E \ \ EFD\ V@(ly \ X~$( !#fq
) \"\  DD\ e\ `f -\ \ \ $\ \ \'E &ƜAΤ\ D  | \ B h  I  /qtI @ \ ?J )  
 ձ܌\nj Zw m<Y 4BDs    &\ \ 
\Z`^  Й$wꂞH	-5U  kd\ Q\ !lc\ b;  n\".\n\r6  * $  &Hވ1S \ 1܍d  N Ɩ \'Ԓt   ɸ ! 	 BX Q D\ \ 5&t s%\   \ ( Iu0 \"hb\ i 	\ L \ \r ci$ \'RZΉ`  ] #33\ \ @ L\"LznV\ I G t+zTI1 \ \ $@  !2;:
d)  Jk:-$LsP\ ԝB   Ф\\\  $\ tإ \'s   c\ \nBa \ F\ \ $\ $ [\ `A:Li Eе2-\'D*\ 4\ JT% LH д lS \n\ %, uc : Ete\"r`D \ \ Z  H j\ Z   \ i   P\ ۄ1PM\ > >\  \ \0\0\0\0\0\0 )
I t	M  `s~  5\ G\ )m \ Ue! [ \ \ f \ ,;ݝ | \ C  e \ 9\n\ ;;S`^o \ \  { F%  ;p \Z -\" \ 7   ~}y\ !f ~\ K   \ \ - X+ l i  䠋 \0 \  HC )  -  T\ e X:\ \ .+=\\%\ \n  J^ ޿   ` }\   1H ; \ g刱n \ ? \ \ \rR\ m \0+  ¦>\ \ \  \'\ ? \ \ 4\ \ ± G\ \ ˵\   .$    \ j \0- \ \  7bs &  \ }\ \\,1Oc7r q   (Q\ *g:ۆ^ i\ \  \0 \ \ rE \ c   x%\ \ B:
 \ \ :	\    ɋ\ \ \Z U [ݼ \ E \ Mw\  \ *\ Y\ ̜\ l,r%\ Y|#X\"  \ \' M   -\'?\ m\Zn I`O\ O ;D	Tq\  E\ @Sr \  ؎{{ ia =\ gݫ 3 2 \ \\\    j8·~  
5\ \ : \ 6 $ M%l< |\  p:  =H\  l\ zx :  4\"\ 7\ ߁4^ \ 1t  ,  \ wq uc~\ &\   𑵾9 @ 8?\r  wҾ VX4  HE\"r\  \  \ e 7 $%\ B\ \'\ Uइ%q   ۾% {L/\ A=coV;c   &\ +\ E  \"ɫ  JQ \ \ d t \ 3\ m! $ ߬)L \ #E  T\ #\ j- \\ Ǵ  ƃ \ Ƙ   \ \  W.-  6Ϯ_  u P\\ Ӹ\ }> \ lfp#y  a(>   \ w]eZrӍ o0ܧ
\ vRe \ \  .   6ae  \ =\  \ |\ zZ݌7zG&R    \ :٣- kFtW= E\ ^ ye   } Am    \ +\ E   [L  uP \ \   \  س}  \ 9  `{M s\ k 9O \ (H6  \0 \rY\ ma\ ji  i\ ŞM \ t m \ $  w \ -\ ǯ\ \ K \'# \0DR  U^ȑ\ \ B B 	 [\ \ ad  \ t  \ \ 1M. WF8U8\ \ t\ /e u~ \ $\ \ y\ \ ˴\  H.W   \ g \ }     j\0 \  \ \ Z\ \ S q \ 
#,ʛ  nH \ D wk \ ;- ~b ١`    U .K1 w  ^   m \ J|	\ qI    /Ѧ \r l  iʊ #Xȃ ! 5Λ \ @ w \ K Ֆ  \ MuUc \ $\ (  g  P\  (	 \\\ z ޿ \ Q L5R\ dw    ;K53\ \    w \0  \ \0. \ \ \"%\"$e  ř\ \    \ Q\ \Z3!6[ epVE\0,\ 1\ 0|       h!\ \ Rԅ j ;\   `\r >\ Ӊ \ H  \ 3 4Z >  Qa   \ <?\r 7 (˖e\Z   Ӟj  Գ>\ n\ \ +\ f  \ HN| 9\ \ Ɣ   \ G  \ ½  <孏 *XO\ \ Z  ȋ T   Cf n`\  ) zX :y= w0JD* ( ˾aWV    \ *\   w 6~\Z  < _ %zsp Dx <|u1L߉\ KovSV   \ C\ FW t\    \ S J   \ P \ Nk \ \ K>  x\ J    )O5 -Hy   \ v \ \ \ \ \ K v\ \   3\  H dӋ%Tp\ \  M :  -a \0G\ az?  $h  9\ \ \ \ \ \  \0Y\ {)  i\    (   +~\ \ \ 5 C \ B  \ \ UQ 8\ r; \ :s3f .\ \ \ 觕 ѵ  G s\\  73#\ Mos \ &m \ +sz Q\ [\ k]\   &\ q tAG\ \ v\ \ _~\r\"\ %   3\0\ 4    z꺡\ # \"\ RX.ۣ\ 3U   $ \ ` f:t[ \ \ ́g\\6ZM s    0 \ 1\ !`;\\^  { t)\ i [ px  W )d\\ <53h p \ \ \ ~ 3A jD69  P \0\0!<\ \\Z p  \ N   +\  \ \   ! [? J~\ \\\ ;     \n \ \ ϡHF  b	*\ 2\ne \0 iN \ F  )  
짟 \ )9K  a\0L6} \ xޤU= 8SE\ F_\ C% ˜-Βڕ \  \ s\ $w-- :o 7 ;\ \ _J\ \ \  \ \ \ <    E  	3: 4 @ \ ~ \ ɻ \r B\ ^̇ +  Y \ Ub \Z\ 9<*h   \rW   \ \ 	< 3   z\ \ \ jΆ oB1 A ( < |T =\ 8 <> ] $]8 i\ \ \  H\ Z \ 
= \ _   8ˎh J\ \\/*r \ iOW\ \ Z엶4 \ 
j ^ 9@ \ t \ ęXb \n 8\ m8\  a\ 8\ I,rB,pK+ fڌY|ڟ   q[\ 3\  fq K,\  5Rl cH\'N  $ Mp \0    \" $\ \ WF\ L< v   u|6\ 5q\   	nRX\ G l0t\ ~  UJ8  \ \ \ C1
Ъ \ \ ]6rS p%tzn,t\ nf iəŻ  .ŧ    Ym \ y\   \ @(3D$0 \0  \\m7  o gB ȈvN    yO*\ZR z b6 =s `\ /O$ 9   a\  \ A+\ ed_ z  [ \ \ {DN0\ \   \ ;    J\ ] j#* =   \ 
  \ u\ 
= G@ ug _5\ (>2 \ W B7 \ 
 7\ M  Y  \ \ \ g\ T	1= 4BM; 5\ ?\  \ \ X\ \ \ J @ ŀ\ JZ wEi_?』 llP\ \     j % \ \ 4_\ Y\ X\ \"\r\  \ OT\ \\]\ q    \   B\  !ϗ  y 4L \ \  \ *[dQS  \ ϊ \  #OW Y6r   \ 7aL<o~  .\ u  1 \0 D K p\ \ 0\r G3 ;   }P4\r    Ct >`\ I   T\ \ \ a+ \ \ { _3\ \   = DS \ \ \  a\ SV$ F   \  \ \0\'\0\0\0\0\0\0\0\0! 1A0Qa@q    \    \ \0?Lo ab\ 	Ly \ r\ ? . .n` [\ bXD\ ~; e	 ך \ N
\ X[\'\ 9\'ʋ \ uʗ  ̾ ,   e,_ pM\ D E  M  e\ K |)  \ \ \ \ \ BD   !0 ,  ^) ƨ Q1c e|\ \  !8  1>L\ uơ< \ \ 	   ( \ \ \ x\\,ҔB&&  $D\ B\ c 2 u\ \ y \n\ \ -9\' , 7D\ !$B DB\\ 8,Qc 4 i~	 v7 ,<\ M\r\\h  %\ >\nQ<\ \ r .	K !3 \ eq\\W\ x qYYK  xR   g Ǣ kBb\ Х( NK  \ ! BaؙH \ O\nR  ರ 4$,yG\ &   D E  !  ] д\"攥\ \ \ R\ g ћ\      0    !OB* jR xQpE\ G  x bb% \"	 ʹ!\ e $> \ 1\  b   \  ؈  \ 6ˎ   <\\   <\ e	ar\\\ \ <  Bc\  XhG OS\n\ [\r X Q| a\ G   HZ\ \ B\" /;     4<X\ ] \ 
 \ bs\ j /A]; XXy!e85   
Qk\ x \    S\ $zB bDR  D ؑ \ \ \ Il\ & .\ Z(\ r] ,ǅ   \ \ Ťt\ C`  `΅ï\ C \ к M0 \ x \ \ k FҐ\ ]\  i½\ B}lX N\ C\ _cZ\ \rlF \ ش-B \ o  .&Wİ SZ \ \"靔u@ gv1	   yp \   [XHbW-Hl t   C\"j }\ 5 t 
 h (   gA  tw  \ B	 \ 
  ;_b\ tޥ/\ 1\ \   Œ0C\ \r  	1 B \ Z6Tň% $k(V  . ] \ ~	\ ,Q#  \ Nt7} \ )x\'8{\  \ \ > \Z 6>,C]6 P A8\ [ vtw1YP笨,B/b^ 5  b    5?  pXf\ DSe \ \' \ \  P %\ \ \ \  ؏\ ,6  /   l  о 3 cY.\ R
aQ   -l1    7о )S(\  qP٨\       \ \ \ )u b =!u   \ obi*!3  \ nA \  )\   z +hzV% *x) 2  1 L1~  cU\Z k P \ Z\   E\ >㝷\ $ \ W  	\ c \  ( LO   ϱ,  \ ;D߰ VҌ-i\n \ \ )\ c \  \ \ ( 
\Z\ PЇ\  {e# V   	  	 X Ƃ\ \ \nZy  = - \  =^ щ \ ؖ     \0BK \ h[_D/    a C֣ e @H\     h   \  	 I Q\ a7  w
p  4[)D\ !I\ 4\ RQ_ $\ \ \"O\ k ! tC   V\ ~ \'ЇcQ.  c#  1n \  *Q &  eL \rS ˲  m \ \ Eo ͠\ W 5\ \ ;1D=*Ck\ r \ Z C ], D\ A \Zd \   6d   dGѱ)p  0 \ \ !\ mAjC e 	 k\ k\ \ \ ׃  
E  ] \ :   ( \ vg \  DV19 \ *׌y/ #o a \'  \ \    1!    oxb	2.~   \ :\ rEt\ C> 6\ c\Z8\rA1%= \ YY& \0Ћ \ZQ\ EN\ j&Ķ\ \ (\ \ XO	 B \Z e\ G( \ <  1}	   \ !   \0 a   7K [:\ (vb }\'     \r\ `ef Q y\ t\'K  \n\ V\ ;M\n$\ M  \ 4cN = hۊ\ ; \ \ \ {\ A   Y\ S\ , M\Z=  > . \ ) \0Z!1D\ i{\Zh :` \"BB_B\Z  Q  <A \ 2 -) \0 i \0 xdB \" lXczF\ \ -ӌ  4 ͠P\ # \ Q @  ; \ S nm 8\ \n{i.\ ֋S   et/  \ D\ K \Z  T;\  \ i   N\ &}	 0\ hh BYo   \ X# wn.\Zi	D*\ Q \\> D!vA|+ K⇂^ \     H\"Ci ^ \ ؑ    A  B   1t  \ m ;  ; \      K
 A(\"\ 3 \ |
\ O \ 6 F\ oH\ \ \ \ <uh\ c	\ \rlh  (L b Ԏ }  E \ \ 0\ [\ (   p  س0 CbmaF3\ZT$. _F \ \ aJ% \ 0J ^ -:
j72 -PŉϾJ\rpb&V\'*> ;P\ Ƭ Б\  :G\ \   \'\ &   Q\n\ 
\n%X\ 6	qLZ( \ 5D  0    e\ \   \ B B\ 
\ \ I a&L! a[\ 6Qh& & BN\ 7 &L\    VfW     b !\  HL[#\ 	\rRL\' !    B
 k  B\  	 ,Ϛ XB\ J ` \ މ5  \ M\ \ \Z 
E  - )\ e7 \ \ J   \' q0 ؞6Qہ\Z*v a6\     Q  `\    YL\ \ 3 Bfq   ( N L! \r    1  \0~B.m\r\ xA
\Z\ \ Qp      x&L\"\ b X  (\ ص c \ \ pײ# \ $$\ !*,\ XK }|  \ 9,!b\ b YY ЉHo ,7  C\ \ Н\Z\ 0  \\` B m R  XX \ \  xXO _  \ ]C \ d   Z   \ b \\ DI L .k

DHB\ X \ h\ \ X Hf `   s \   \ \ \ b\'ĹҰ\ e\"cؗ ,6β ;e\ ;\ bZ$\  \'sFߘ$ \\\ \r \ òa3 !,\' ^4 N\   c E-,4  Mzhx\ \ D\"  \ LxH ,\ N b\ \ \ \Zv$%8B4^l \ P ˉ \  #G ( I    bhLO,\  PX5  ,   \ G ,3 G \ \0&\0\0\0\0\0\0\0\0! 10AQa@q    \   \ \0?  !\ LNk \ E\ b $\ Y &P\ \n< .K : NK\ E R   u\ f  \0\ E lD\  q g\ y \Z&R ƞ)s  a !	䜡3	 o\ 8ce\ )J&/\"e\n4},\\\  !O\ \ 9_ ʥ b p \ JQ2 +	aXKXXЈk &`ɈBb \   	 hm	   严*\'   \  \ )DR D!   \ & \ \\)JR  )J\\җ \ \ GD\ L B0    kؘ  L  1B &!B \\\  \'  
(| \  \0$ B\ D   $!N0 \ \     
 A B\ \ \ \' p :\ \n] 	\ \  f \  !R /Xɫ4!\r  6\'Ɗ\  #||  x= q\ I \ l M	h C\ dJ ] z \  ! J \     p_\ 	  \' w F9+ M
 \ \ }  \ Tt(Ƣ\ a5   tش 7   i H 15   ${\ \ /   vgll  ;	ôttG 	\ .\ յ    emE  	] \ \Z\ ,>\'  Bu O\ \ v|$ Ga\ oB1twG	Hbv9$ \ q	D\ 4f\ ZbLc\ \ \ a   ]\ \ $Kc\  \ v c\  !  &\ b6c  \ \ A	  %N\    \r a $z\ \\h P      j \ *\ \ lF\ d61 ݴ v   >\ \ \ u \"#\ iK֑  L- P\ \ZlKcĽ xZb( XL\ \ ?  k%  Q  9#v5 \ J (nɢR-\r  v2)\ ,4ސ  CG   CG& \ CxcA \ 8\ \'*QyS\ \'X  $|}  \ 7] kAbaeS:\   EX% $ \  а\ Q´  O\  y\ a ư   Q \  &<% &҃] $ D\ \ !R\ a\  m	b\ ;A+qB\ \ v \ * \ M)\ Q= ga፝     $B\ $DDD!\ \Z kXs\ \ HN .O , hI E\ \ \ t64ʄ\ l \\w (β\"\ ؙtT\ l  l TuH0      \ {\ 3\ _> h\ -  ։\ O   \ ~d . >  V\ \ pEG ![h  i \  \   > \ K\  ct\ \ \ \ X h $Lx t\\ $V\  ѭ   {\ZЖ  z+\ lѝ8=1 z  /  $A
\ \ R +  \ \ G  -\ n=\r  \ 
\ \ K\ 4 \ \ \  H \08m \ D I\  !1Oc\ bD:&=
Zz7m M ͮ G~\ Ff2  ^\ F! \ \ <L\Z \Z\ =L6W\ \ ߕ  15  \  \ \r    \ 8\  \ZcC\ ;\  .  \ _!  (|\r &\  \Z2^Ц\ \  t[ !  (\ h\ \ ęB7 \ \ \ ?\ !\ ՟\ \ CX 3\"c  	\ > \  ..\r]~\ \"I\r \ i \0  \   +m  !I7c\n n	  Ͻ\r \ \n ݡB{B   BE5DW\ d R\ \  F \ J}  \Z #\ \  \0E L  9= 2}l \0H\0 . \ 8i\r		 M o 0 (1vΆ   oa  hDUvz3

c  񞣣\  \0\"J\' \0\ #n  \ \ D  Nn c,|M\ ?\r  )  /\ c   \r     G\ Bj\   yZ	    f s\ \ 3bj  \ \ S(  \ @\ > =! >,\ T?W    G T^Z6²\ 4 n|\ l 0K\  \" F\ M\n   * , 5{\ZzbaKe` )\ e+\ ˿\   K:F
\ 5/\ \  \ \ H  L wbxM\r \ bXײ# =  į  #( {\ O\ \ -LMP\  \\%I   8YC\ :\ {! \ R Inȴ: .;$ Zbʝ 5\ \  Vo  Lx\ C  \ &>\ \ \rX o,X F\ X   2\ t\ ˴1bF\    ,mQ  DG@ 5\Z,]ae J\Z 1\ gB Cx\ \ m y|w|&\ZUS   }\" \ k\'c5}vG    u .H  /H R\ a b _\ \ ]   \ \ Up{  *;Bs${ ^!	   룠   \ YC\  =p  ) y=
 \ e -\ jhGE\ \ \ \ t# a BA S()    \ {b  F &  \ \ T 	Qi\   o\n61,4/\   N] 4\ g ! eaoJ\n} =\ o  4  $ \ 12\ \rC \"̕\   l\ B  F\ Ǳ@n 7  \ 	
D!<By N	 TCz  u\   #\  \ G\ 	Qla iv=\ TYOCv6\ \ #Bp   oPJı\ 0\ 9   g+ P e  hM\ b\ &14.\ \ d \" 2N  aI6 \0 \ vΨ K \ ^ƣL.a   pC ְ  \\;\ F  \ K\ blO R	\n XN1 ) \ > \ 3  a\ )q $   G 4R   \ oE./
   \rsYE\ \ he  e\  \ \ 8E a    D\ \ ` 4x   \ } b  4   *JN7 \ _N\ \ \ $h|\r	 oD E   \\\ , 1 DT o q< 	2 !I GDѰ \ Z5  ,Qe\   a\ .
 \ \ y\  (Bbf \ /x\r PL}e!) Dؐ   \ xk7 Ι/% _\ \\\ B	A\ \\ \ ` \ \ \ u\ ,.(\ \rf\ A  G ?=;!. \ \Z\ \ \ D\"\ ,\'H,(>K\ 2f u %\ *Q92Q	ᨔ &!\  Dv%\ LLщ\ 1\ x  J \ 
\\6\'sK _ \ s1r  + qXhjrC^k dN3     §XHBP !sE M c \ \   \ x ( ^, \ \ ǚ	 \ Ύ    +=c|;!0\ >- 
 D\ \  	O  	 d )  x Ţ,)N΅͆ ;\\ \   \\Ҍ_pI1 \ m!+  \ \0)\0\0\0\0!1AQaq     \  \   0@ \ \0\0?Z  L \ \ ^] \ v )K !\\ nZ  \ \ YG<j\ \  \ \ n  yAx 5{ ̏  >`pKS \ +&o \ oxl_\ \"a\ +\ $ M% Uq     \ <\ $\ M\ 腬fST\ b\ @  g  YJ\ &\ \ \  T l _ XqLu # \ 1  $G\ S\r   .0 pkuh %̨¬ 0L,
\ + , J\ c & & ͯx5t    \ \r  y ̼ qDǘa*\ pC D 9 ӆR\ \ q   ]E&\nc\ [\ f j  1.n H  k  )\ \ U a hv ֪_ۙk`#G \Z \ \    F\ .  yIXi \r\   \ y\ n\Z\ \ h`&!ŝW>	I˗ \ 
 \ a9J  \ .\\     \ 9 nbf  \ b# @\ fQCX\ z@\  ̡ h\ )\ (  q\ \r\ jq  Vႉgvw s \ \ \   9s &a \ 3\ \ J\ \n     u  \\  9\  \ \nGb iK  \'v Ӏz\ 5l\ n iye6     \ m R  C   f `/ 2  M\  )\rnh `S] \n 
\  L-o 5q	ڡ [\  \ q\ n e5\\J  7*  \   7+}`& * Ǔ\ ˬ   \ \ >D  \ $ɷ\ PU|\')  q 
 \ z\ m\ a\ \' 5\ \ b\\\ \  \ k\ LQ   \05  \ U]  \r s-&,\ ,  / |F\ c  %B\ MM 6}NI  \ P1 Ѷ   s @ *  W+ϙT  7\r\ j (\ j]%b \ 0 |\ \'x X
\ f T]    Q \ \Z \ m ӷi c p\ \ \Z OI      u \ s\ \ \ 9!}g9 łr  \  ׂ 
7:\ \ \ .\   ul  K06^`)Ԭ  A|\ \\ʫ]j\rm E\ Y\ 5 6M0\ 3m\ j1   ,)x^\ a 3^ Z \ X  . !k\   }\ \ 8ba m   \0 a\ \  {\ &o 0-= d }e, \ פ0 \ \ [\ Xdn sM\  \ \ a\ 4 \ <bS~ \ \ *W[& 4u Ҏ cet \ ces\ \ b       \r )  J\  \ cE R\r\"bQ \ JZ   \" D-f I -\ XY/  \ ڴ z 3a\r\ \ \'I\ \ \ &\ 9\ e RΒƭ \\  \ \   \  [l   @ \ 32\ \r    \ B \ \ T\ 0)\\  `\ 9 T  \  g\ 7 N\Z\ 5\0  SR Y=P c\ \n  kS Y  \nG} +\ :y \ a \ TϷ a NKo >e \ ,08 \ \ \  ͗ QơNco `ag
\r \ \ a )w+I  jQ\ \Z\'\\\ UZ \ (7P\ v f W\n\ \ 
    K\  \ û+u\n _xej\ cr %V6 +\ ߇ \   \  \ H \  \ \ G\ 7/Z o\ \ Ʈ ^r   =:ʶ+\ G D M \0G 5 \   l \rz\ \ \ I\ ~\ JC  &A ͿLhh\ \  jge\ ĳ i  a     \ [0\ 	 B&q T\ =&  \ \  2\ \ xbV\ d  .  w 5  50c \ bx O1 0\ # Aw + \n 2\ \ \\:\  \ 9   E\ 4  2 \ *- Mb\ \  $o R\ ;@\ 5 ϙ\  Y  a\   w \ \ k0W\ 05 \ \ &- \ R   C \"f\'L \ T7\ B8\ - 0JBa  \n\ R \ Y \ro 2\"  \ K>   !)y m\ \ H  ŗ)  \    c \0x \ b\ D  !  `\ \  \    K\'
\ c ` YU* \ L  \ C%\ L^\ H 8  077<K\ \ qчp TJ׼ \ ᚆ3QH  }H l \  \ W =e  ~\    Z  h W E  \ \ . pd|  #   Eݧ\  0AW H\ S\ o  &\   BU    \ \ o 	k     \ \ ` \ \"
 \ =%L. \ \  \0e\ J6\ ¡   \0\ S  B Rթ \ S e\ *d\ <ò \ UQ0\ \ \ z!k\ <A\ \ (   2 \ m. vF-  \0%   N <  ͢6 8   \ v  `\ \ n&\ 0  b Y\  W %a Ԭ\ \ b{ W3I 3e @ 5\ jqΠj	[ 
 +0ìu  n 
\ \ \  i\     \ {\ \n2D \ y! \   0/P ŗ w |k  \ bhr A\nQ\  \ hQ\ ` .\ \ \ Xy  \"K   ޕ]G$ U  :S\ ^  (3F}UM\ =\\ʳʃy \0 r@\ \ bUX WP֨ \ \ O a M L   U e_I ʳ x`f  \ d.qb \ ! x   \ 2g\ s\ 0(\ \ !\ y   qjő N    \ M m \  Ne !\  *\ ^Y \ âj\Z	d a\0\ P   7\ \  T{  [   ]OZ%\ e \ 
K C.pVV\ @\0 (:  /\n  %\ ^6 ]Tm  c* \ l\ 
 q8 T\  t3)WL%\   
 e 3\ )j\ FĢ\ a4  s \ \'5%\  ن\ bg p !:#    T\ s \ 1 SM   \ b\ \ WD C  eT\  \ R ,p2  \\)  \ \ \ \Z\\
    v  e ]IXԮSP \ \ [\ |%#ќ `c w\ \ ]\ *tC& N eb4\ l@ \ ~&qo9  \Z7ĳ +  Cz VbF \ \ .l\ \ \\ \ \ Ĳf c VkQ m\rC= \ I\ :ʓ;6@Ϡf!ך =  ]>Ӳ   0J    j m   \  c2\ Ҧ N     C \0g \ R\ \ Ujb \ S	  \ \n;J !Ή  \0\ \ SOX-ŖU v _IwI߿r\ s e \ !^H\ c\ \n  Y?   \ z  ֜\  Pj \n   CږY\ \'>  )*M `  \ #   m,@\  \ t\n s\ YP \ \ A҄\' O 2 f \ ʜ\r       +__i \ P \ %  S nvVa: lbh\ Y ˉD  jv3 \ wqQ dؚ  \Z \r\ ֿENH K \ I  \ W 0\ ( zq	pU 9\\=\ \  M!gY 	    bU\ &\ UN\ \ \ S 3\0 \ 3ox ca wk\"  2 y\ \ g @\ [\ :jV N%Zjr\ Mj\r\ \nN \n&ׂ. G b L  q, %3 \ b\\V   2      \"ݏ\ 3p,   Cm J u \nw c \ 
 Yʽ\ h  \   LX\ \ V\\  s/Y  4j{  %&w)_\ L ns:\ eTzs0   \ \ M\ \ X    w \ þg  Vs\Z\ M_3`U 3\\-aT, ^ m ͡  cLW %A Xz\ g   \n 0B\ N G ~%9  #  BϚcf\  \ \n ܨ\ L snr\ \\ @S\\b\ \ s}\"Gl
L \ ^ \  L9 	 X\ \ \ gU \ f` ! a \ :& \ \ r 7\ \ `j\ \ \ \ o3-D\ t@\ WDr Z  (\ T\\s >  x\ g q\" 0 Lc 
  J\ \ 3Nn\"e< \ Tۤ\ \ (y\ +AP(\ \r   u\ C\ ̳ ]\ \n F` }峙\  \ I I՞ U\\Ë v7\ v&+  !x r\ \'M\ ,-\ \n	g\\\ \ ̸| m?R      \   =\ QkZz? w \ pf /0\ Eq) ~\  ˶) `\ T \ \       o  \ \ ] u x    Iz\ . EZ \ +   % Y\ *     \ a W  CW\ 
sS & Sz \ 噄\ ^ Yu\ \n  X.  ֡\ \ \ \ qw7\\ R25 x\ \rU \ # E   \ x wR  gĲ\ w  \ @h\ (5ħI B\n wOH\ 8 m\ Y\ 9 h / \ o] \r \ \n7x\  \ \ \ \ )pw1\  \ ^   \   T\0\ C~\ \ \ \  E%  feYbpJZ\ c   \n\ h  t\ eje  U@\ Y e\ ]w\ Z! QU \'2\ bcĮ\ 4\ u\ XY  NQ k    G 7 \ \ \ f\ S  Ɲ\  3 m߼q+:q	 \ ;@s(\n \ w  \ 7 Vx rl \\\ 3 M cY 8\ a ӈS 3\ r\ \ 5  u`  e\ mK  ?E\ \ C} \ \ a k ~ o-K   \0 ZR   0  WpA\ 1  R  TY{\"W I |ʶQ1_J3 a6\ Y\ \ B\nw\ ]`0G[ Z, \ p Ev    P8E \  7\ -E:_\ .  TF  \ x \ \  Ԗ|C q\ *  V7+=} VMƎ7  \0& P\ \\ \ \   	R  h  q  mj \0T\ \n   X  \ . ʩ   E\ \ g\ \\) \ \ (\ f \ y  b8  D \ Yq D}\"  e \ LS Es]%9  >   . \ H\ NF \ +  F   \ \ ݄@ W  \   1aK  \ z7]\ L3Q\ 9\   ͱ\\΢9Ag  \ 2 Eu     Q\ \ 0F\ XݳQ\ 5 a
 ( Τ  b\ \ M  ù e) O a  \ Wi]۫  12\ \ ( \ g  =! 1\ =&\  sN%   .a  83(\ \ : s X* I    b p\ (- sm\ 3 \ }\ NX \ D R \  	%i4K qi\ C \    \ %m omg\ [  \ ˻ !2 `\ i &\  žA^\ v\ / \ ѽr S\ \ \ 4 %	Mfx |  \ 17(\ ]\ \ hD!LԬ0   \ \ %*\ ,8  k_f e MY+E   \ ]
 G \ % \0 \ x& T  \ % s, t F\ 0&(t    8  \ e \ \ \ M u\  \0#,ҁ;C$A ⥧zs  1\ B\  12\ \r\ ٜ/\ \r 
 \ 9{ \ Q{  X\ Aٞ\ \0 QF\  \0`V \      G^n\ LF d\ 2 % \ H    t\Z \ C m6 \  \ s{̯ \ \ 歑  |    F`3Ybr \ s  ,   M5 c\ zy    g\ =\ \rbc \Z\ C\ \ 5 \ \ &\ 5x sp ġ \  *eY @\  ʣ W\ 9  \ U    p\ Y\  5  |\"\\ \ 000t\ :   r   I \ \ f\\\ $9 h9  m\'S\\ Hp  2X5\Z     \ \ r #i\ D  U )  J׸\ f༂ k_  =q \ \\ n )݊\ \ \ \  \  U h  X 5v\ \ u쐱  \ Rۆ\  *^ Ac 1 = K 1\  \  5U-vT z V 9 s/8 \ w\ X:2\ }H Hǭy\"f4     s5  \Z\  ;    AXQ\\\  \ 7ף^ \ E 3%S\ (\ =\  F+`   jN bQs  t\ , (s\ {(E   @ \ >@\"z̜ ]  \0( \'7  \ ڣX  `\r_~%. &\ a  \ \0L ϼ#Ș ) \  5!\ W|  [  z   \0 J   \ ! B\ 7>S.\'  p\\9\   ;& ¡ \ N?      \ \ k  T\'8\ F!b WQ * Gh@ \rv Ϥ z  b:A ੑ\   ̫\ \ 8{ \ d#{@   \ \ Hf KmL͗\ 5K sj \ \ i>\ /   g\0      JĵjPʯ\ c 0I    8\ \ Q?_ \      \  \ \  F lu2  xe _$   \ U\ c \ -0 h-%  A\   գ\ Ǡ F \ of)i V\ zK\ \ \   +\ S[\  \ \  _\ erm d \ +\  x ` \\G/\ k0 \ 52\ i]% \ 9 1L sP 
 \ T   ̹ n!`tb \'x J  ^5	˞\ t^ G  2&%\ $Z P\r_\ =.%\ \ ,# 
  (  \ \ |A\ WۉL  \0\   >  \ AJ\ 7\ \Z | i\ J\ \ \ \ \ \ 5̨bҍK/\ \ C \ ,  L  \n:\ZU  \ 8  \Z +\ \   \ <a&W
bU,  p\ ? \\ ~  ڡ \ P \ Q 3l\ 8\ `05d&   8   mxE 
\ \0SN\ \n5\ @k\ .g f x!\ = 4\ #\ ObuJ \ \ (zD }\"\rt\  KACȝ\ 4<\ Q, W ٝ [ }   _ \ z     *| 8ya\ W + p\Z ҇\ `?\ \  AEA,M%\ 7 B   ĵ)n  b=˛> O\  4V Tt[rއ Dڧ F\ \ O \ RX u\ $P o\ J\   \ /\ 6d h d{!v  F;ՙ \    u  \ 3v \  -  QT\ r @ \ \ yk9y \\; \nU&l q u O:   u I\ a\ xܪ B \   J!\ ~\ : !G  # \ o\ \'x:8l a p)bh y\ &l\ X %\" ;?p2봹 \ ̾J _Sθ  \ pZ *9j\"g7.$] \ \ 3\  j\ Ŏ  X   \ ?I A_ ڽ\ NM@\ \ +=\ f?K	I[  0e TJ\ ʊ )X\  9\ +ጤ c  \ ) iIX\n  s& \ 4  ~:&|B  / i \ Qh \ \ ?0 \ \0 = U m:^\ @jt\ \   `  q\  FByLa c \ 3\ ̐P     1 d\ \ a  Yq\rv S+ ]ʁ9  {\ ` \ T * \ P   
  B\  \Z\\ -\n  Y 6bSxV%nW\    \  \ 0o*\ \ \ D\ SL̃PzT\ feǬ  \r\ \   
,w  R7 Zya4\ \Z  \ \ cP  3  \0\" iQ\ }\ c   \  \n\ ~% [\  *   Ѩl\ % ԫdo\ Qv  )M{\   8T )1 \n 7  S k\ \ ]c wI\ Xr {  `< S>,\ p\   o\ 1 Ԅ\ \ i+ `a `u.D\ \ Y   \ \ m+ F  ^ A  ׬JF d\ )\ \ 3)\ 4  ,  N\ Æi\ \ \ \ n  ^ SS\ 	j\ >ҷ]% QD\'   \  B  \ ֣? % + 3  ,-\ (\ %! 9K\n  0  \ 5rØ \"\ Qk \'    ]zM\ d|A\ IR  Y(  \ \ \ r\ \' 0 ޠ  ~%a`  \ L\ 0\     2  //\ P S9S  	\ fa\ \ \0Hk \ V PXL \"U\  \Z\ &[ $  Zڭx \ \ \  ǙP(` m6 *S [ɟ\ v\ W /\0 q\ \ _  +\ Oh\Z\ \  \ d~&N \nG \ LI   8`zJJ +9 용 \ H2\ HP   6{Fh.v +\ yR->   if -\ \ \ y[\ V\ \ l\ \Z [   14 \  Va S P\ ܓ    ڿ* \ \ Cj   ˎ  ɦa\ \  &s H Lx  DA  \ \  \   {0?f  \ B_b    _ /\ + _   ^    \0diL    { hw \ iQ8-\ @ a<f\ L< $ 	\   Vm9n \  \\\ vei G҃\ P[\Z ;\ \ Sxc  9\ `\ 1\  u
\\蒧ę J!  v h\ _p(! 7Rꁘ \ #\ \  : \ ;\ 02R# ke\ p \ @\ = z L3 [\ \ \      F%Au#ٓP\ V }? Ef\ jgL\ q \0%`  ic5 :  KqC\ \ ?d N\\N m\ 5\n 9  tb @ X \ A\ f	4Y   ]f2> + =<BWHwܫ\ 74 _2 3\ 5\ V\ G 6\ j9  [ D JeT
  \ \ \r   و    4  ,\  M~G TL? /W\ E  i i     \n7\ \" 1 l+\  \ ZR \ Ϋ4 a#\ 9p \ Fߏ  \   	 \   槔M\  AWp\ \ \ (\  n W[ }Q/Lx +H?0C w^\     | u  {@y Н i<  \   \ e\0R -@   \  \ !cP  0  T+ َ \ \rECxx\\\ C7 \'LB\   5:	\ \ \0  @s\ i y\ : 0\"߈g\  ֕ \ L  } \ a
 \ { c1e
)\ =\ \ \ 5W  \ {\ w\ V\\ z\ ܫo \n  >R71\ - #ݎ S.\ gF C\\@  b \'. V \ K  gG   \ d p\ \ \ ,  ]\'  V7 = :\  \"\ Ρq\ &\ \  
\ \rֺT9\ \  *W  \ و\ 5\ j i[ a \ \ 1       >eb%J\ *\ \\\n T
y W0\ f~ă! `\   {\ W\ \nS=  EMSz  z&\ \ I    G\ X\'6\ E.A  \  ( =  \ ԪR  N\ \ y\ ~\  \  X 7\ \ д\ YB\ \ ZG \ \ scd \ \  O3\  2 ) }ec   R\ \ ` G \rDf \ N H  $p  \  E\ \ > 7  \ ̷ $1\ u }   |*i }π \ \  \ o\n \ @     xB \ qn\ Q   \   \ \ P \ P w\ `5pkp0\  K\ \ 3\   \ \ a /C  6`\ \ / 1 + \ ś \ \ =\ : C\  z 6]K<  ˹ \ + \ M\  \ q 4\ Uj\ \ \ \rަE  ֈb\ W\0\ 8 *\   5p (ȱ  \0c \ A   yw; \ nw!]\Z \'h  L p\ \n  \ \ [\ b\  S \ \ J [ T\r\    P%J\   \ \ \ 1\  T5-4> w #LgWUS6 R\ !aV\  	fD # \ r \ (\ y6x F   \ X# &\ }   y q xI \ ȹzW ?TOkج1^\  \0   \  A  Q  d7  A\ f  \ \ > )  tQ  \ _0/\    j j Y \ D[  [\ P jht ̕\ \0 i\\Ǖ H\ zE YԷ\ 1$ʂ   ph͑ E\     6\ <\ qWM^ \ W &T         : Ӽ  \ZcŮ G Q k  2\ U=\  ] ʁ:\ ~\ Ǚ]       ĥ   3 X  9+\ KE~^\   \' \ZNE\"E G0! =   BUxߌ\ +\ $ htIw }  % _\ \ \ _sw\ (     \ \ ~ qo Do\  %J}h D  \ # ɧ  
H44\ ψ- X}MG  \0} 
^  q \ 
r  \ )[^\  \  \0\ ox }J) \   \ \ S 8 >\  \rr u&m\ O  q \ \ o} PߜŮ ] ك\ \ ~\ \ \ \ \ G\ \ J  r@B۞ BM   &F \   (w +\  N YFޯ Mg y!\ S \  0Qr  (, jf mea C  \'2e  12u  n )    H  s	P\ (R  \ 7 \ =  \ 9\ $v  C \ >\ \  <?     Y \   Z \ b \ 1  V  ~Ķ =
 12\  Ia\ F tK %  P p\ O ߴX \ 74I\0  \  \ \ h!\ * ~ ;   uY ub	 $\ 2`  E  KA qN\ y1,     \ \0\ \ \ \  % c   \ J \ \n\ \ \ \ T\"\  1Ⳉ\ b\ \ p  O\"K `W \  :¢0F\ 6@p\ \ \ \ Hoo  ¥6 g\ UX tb  \   !\ K\n \ Tl Kr \ \ \0w\ ]eYSz +2 0PT \ \  KG\  ڢ q\ 
T\ &|\ ^\ \ \     \n\ \ r\ +  hj\ ؓ\  E  pk\ o\ %   (\  Tk J1\ ;UB Ǩ N\ Q   =n \"gıVʁL В 
c   \ #H,\ \ \ \ X  \0\ BѸ\ 9      ľ vbw )Ӟ +\ C  2^j*% U? U  /\ \"U\ \    0ݠQE\ ޒ  \ \ ~\ * a   \ C= Ʊ1S\ h=\ ] Vu$8 \0\ \Z  \\  ? >   \ 7( S8 )\ T\ 3 T \  \ K [  \ \ \ \ %J  \ 5n	P  + TõKJ  Co»f\\.Q `	oW Ј _\  +\ \r J \ v  ~ \ \ +  l=\ R- \rx <  \ E[՜g\ QEv\0\ Q\ 2,r`#&:6 \ )\ Ç IB\ ~X \ \ K` \    7~\  / -]k \ c4+  <[    @ u \rW:\Z\ H \ \'  0{   P\  G=,l  5 \" K ) \ @8 OME\ \Z ,\ \n\ ,\  \ W U5P  !}\  c\  Ơ([  廴 \   \  \  D $,m      \ 
\ \ T l%(\ Iҗ p  f r77 \ *g4# M9 n}\  g \ ߼f  \ /Q    \ _\ \ \ \Z  0\ ~\ \ \Z ~ B6M #  ! 6  d|\    \ @6   \r:   %5 \ = u \ U\    -ψ.\   94   !F  5  򿑡HDo C:O0\ [ \\\  F\   y\ r K h\ \ Jֈ  }\    \  \ Ծ      \ =a\ \ \ ڻ \ Uu \ .:>1\ \ $[0S{\ \ \ \ x ;a  ʫ Y[  \ W  ]\ T  J%J    b\ ] \ 5!   T\n%J + \ *用 i\ \r\ \   9   8_d B\ 1   0xyÈ\" 2 >\ H% \ i)  \ ^\ \ 	\Z Uh \  ?\    \ sG\ \   Q V\ \ c  
 \ oxn N\ w\  [\ J S0\ `) ^_H+   [zm F \   \ ( (Ƅ!b`8\ f (\0eҳR\ j3QN: + L\ 8\ ڇ\ z\ , \ Cb4   ,.S \Z   	\ E  \0 -\ \ \ \ a  8֚  :0   _\ -\  ~\ r.\ \ (\  Ft\ \ viK\ R   TsR S(\ CP\ u \ kEEM: ^ #\ \ \  \0\0\ .    ѷ j 3p|Ƈ \ Q\\Q    \0&\n\ ʹVk k  po \0!H n\ ]  (64 q\0  +3\ \ A` \ ə	   \ E\ \ 95   8 wTl_ +ad }G )j  X \ + \ z  wck \    \ no\ \ ˧1c Ĳo	 $\n G^&V5\ \ Q.  P?\ oHA\  Vkp\ p\ \ \  Ӹ ?ݠ %  W \ J\ I \  D \ \Z V \0  U\0  p:\ \ HJ\ *\ ~`  b`b C \     *V?%M8\ Uġȋ\ h_ 0\ \ \ e3\ m S j  )    !>ӆ\rt\  \ ms;o$i y 2\  >P \ -. \ \'  5m@()  `z \     `  x   (    X6~Yb\rW  C\ \ \ % \ O[ J=$&z+\ \ @ @؄Ychk  \ \ \n   \ jY\ (~    G\'K qD ^`*b\"   \ 2  Ef  \ \ \"   `\ne!UH{  H \ \r\n v{  E`=\ /] \ \ \ H   m+/i R  \ ]u&F \ F\n  Ӱ\ {K   \ v*r  b  T\ \ \ \  ˥  D\ 6 \ \ ]
@ \ 1Y  \  \ \ \ (\  :  s\  z \ *  `  h° \r   +Osh)O   
k    \n 
}{\   8\ \ Ђ\n\ lB; oN  Z\ \ ,
WUa I d8\ 䐲\ \ \ ő\ \ t \ \ A s \rڡVǴ \ \ \ ]\ \ <MԤ UL   %;\ m  W9  T)  Lã  > \ oR # \ \ >𮹁 b\ \ 7p!  \ 	]e_0%~r J H!  ~ = A P ~*UC Y  X u )\  e5P  Ko8 C \  ?   \ \'\ =\0  \ h ׬dA ik ׼\ -9 Ҕ %żK  A!k,\\\ X \  \ (
\ \   Y\Z\ ]&ny}\ 4O   CFԕS\ |01V Vh?\ b|\ \ Ϧ - L \ f2p^  @\ ?K  so\ ) = \ . \  .\n:f\   =9^\\ 0Z \ \ B\ \  #\\  N\ C ty \ 2
 *\"\  #} ! \0􌆲W-4BC Zr  / Z    ۴ r7\ p/\Z!  X\"\ K2  oU  \ZV\ % F fX\ \ x\ a \0h~\ /&{
  W \ &\Z0   a\ b\ aKn ; ߼ \"\ \\  sb\  P \ \ oZϘ  U6 >\ fP^ \  C \   \ %  \ ?\ \ x\ ֈc  TMTx\ * \  \ P   +  y \ &\ Ɗ  \  T\ \   c  E \  [O0cv  B   \ k  \n^qט\  A{\ \ -\ [2\ ]np\ \ 0<\ Y ٍ \ \ :F ?  f\ ܦ \ \ U\ \ Sf  C U@\ 	P i[ *T  n	^`n H{   \ \r  P ᕚ   ]%@\ y k  2  c\   g|\ \ \ \ ,]X  \ i\ ר\ Ƴ\ ߱/ 7T   N\ @ шa9 \ \   ;\  X\ 19: ܰ  }  \ d\ {\ \ \" 6ջ\\\ \ \"\ -5f M\  K4y`9ĽS0SX|[1ÁJ  \ x  p &zz@\ L   \  \ a  @ J( j\Z=\ u_ X  \ \\\ 󈀢  
YA\   \ F\ \ x  f \"޺cJ AaF  \ K  %\ \ \ \   W|L\r\ [\ \ Y 7 \   
y&\ 9 0 ؖy \ 4  \ \ \ йo<Oט\ &\  \r\ J2\r  7o\  \0b>JÊ  % \  \ š.7?\ 0 KM_ I\ ~­ \ nH    V8\ G  \ \ G a   ]#ֽ\ b4 %fS\ Y0\"ʽ\ ; tK\ # q\    / |gS\0M     \ CB4  }a:\ \ ī* K|˴U\r\\ +p      \ \ \ !   6BR\  z\ U \ \  B(  0\ \   L  ~ ΅O _\ g꥓-  \ RT\rC:H |\ \', BŇ̯   \ \ 9 Mc X y   p7 P3* \ \ H \Z P 0\ !t \ V?\Z!  \ J:\ /I `\ J:\ 1\ | y\ \ b\ t   RPȌ XE \ k \ TPF \ C,\ 5 \ \ \  T! ZSzJT    5f\ * c   Y  ,\ \  s[\ wK    \ ߸ \ _\ [    r$ \ c G(U+ B& \ }  7P\r  \  r2\ $P \   Z   9 \ \ K\' 0 b \ 0`*P #[ ^\ E L @) Z@ _ \ N xM>  b  n! h .   \ x  nP	 K\roC]\ m0\ZJ\ { \ YC\ _\n\ G ,y\  H# w G(G    !v\ \ 3$}  \' \ ,+m\ iF  i  樰֏ԣ O\r  \ \ 3\ @r _W\ c it\ p\ l > u  S#\ \ 2 4s]\ \ `_;  
 g\ b\ \"\ .& _ֱ{0{ L[  c \" \ A 6q.o c   y\ \ ]  NǕ \ 8\ H( \ \ b   )Ky aUr\ m k \ 2\ |t :& 8 W \ \ 2  s0    w 4 v0j A\ U \ 1\ \'  Z \ 	- b ʷW!Nم P ÜO3\ \'%C\\C\ W \ \ g g7+  \ + P E@ Q³ \ 5\rCR  \ j YS_ !  \ \     4  ioF}ʝ L S\"\ g`  S    \ \ -3\ p 0/ /\ \   ŗ̵ Q= \ Uie g
 n  ?l KZm 2 R v]\ ^  \'^\ \ \"\0`Gu  L^\njЀ3    \     
=Ita((3 ˏ9j   \0v y-\ A \  \nw\ a>M V\ Wy ߩ Qz     < `\ Y   \ : + jߨ\Z  \ }p\ 5  ; \ \ yu\   q] 缸 \ \  \0& T>Ilg\ XU  `  @Z {;/ ~\ QE  Y   \ (r\ Fի\  \0e s \n \ \ ŝ*   a\ !\    \ wq\ . \ \  \ R \   \ _Y <z$\ $  )   Yo	K< V\     x  7  1( \ W   \ \  HNa\ v)}\ k\"<&\ 7Ʀ Da  \0 $\   \   T[  2Z \ `\ . ̏ \ \  +R D\Z? |\ ea U}  z\ Ӝ\ L Ӽ \0(  UK ,.\\[F -  EƵ\rU\ >bU & ef\ q,NІ J\ J   \  M  ! #0! SX  Za j%@\ `b 2    P  R  \0\ \    D0~ W r7 \ TOR\ V`Ōf3  *w\ \ ^\ o!{ \ \ \  \ 3 2\ J ,i \ CXx  \ >H \Z \0 xb] 0 0 Gg\ & +\ \ \ k<˛Յ \ \ l ~}* \ l 8C\ \r \rQ   8I¤\0\ \ h\ NJ\ ~\ \  x \0      , @s j#JU\ }j   co   ̭\ \ \ Ƙ\ 3H>\" \ \ 0 S  \ \ \ \ )@v=\"   L 8  R \ 0+T \  \ H\    -8~\ v2   M  \ ʎ \ \ 9]y<   R b r   X h\0<s\ *g    ^5? \ e y@9= W\ }\ \ \  *h  \  - %+ H\  \ ^   qj>\ \ #  Af \ fp7   \ \  }eP  \ b\ `Ύް9-\ @տ  9 \ \ \ 52\n   M Un A[\ \ ڷ[\ 
O书  \ \ F  \ Q= 3 \ \ E  \ \  7    +Lx  E\ \ } \ \' $\  0 2 \ 2\ {N?na   P\ e_ &  03*   C T\ \ %M\ \ \  C R  bTF _p y\ ! \  =  > 8  | \ P \0A 3\   ~Cj      (0  z\r\   L q\r  \ \ F\ \  Vǘ 2\ O[/9 [  D/q-h>\  W \ 2ˠ  #  s 9_     SkG    P 0 Rn Ҏ kKW  	< \ 8  |  \ 3% @SA    N\  \  H\  x 6 ?   \n\ \'Wڈ  QkW \ \ _\ G H \ \ \\X\  \ \ \ *  \' o /a?j\ \ 6  \ \ =\Z  a \ \  -@\ G\0 B N \   n\       J@>  G&\ ]: dh\ \ iU    \ +tA     \   i @af4   M `] ED\ \ \ \\\ B. LQ\ \ =\ ^)f?  ;\   . \  \ Ew\ 1u-J\ J]\ vW ttb\ : \ \\6\ u q =  L   q2q\ H \ZZ= TGKۚ\ /\ 2~\  \  $QS$U \ s G{ 3\n\ \ dOrXi  \ \ %C}\ *o \ \  \  \ zB 0\ ! s   \    \0 ps @  p z\ \'     \0 \ q(1   \Z A\r 4}K R}\ \  vJ\ /\ ` a\ p oR\ {\ aM\r {\   A -   \ \n  \    T     8O l   h  T\'\ \ * I|^ #O    R\r b\ \ \ o螰߇ \0\ 0x[wé ,gk ?Q \ \ \ w\ Ρ  \ \ \ \ eP ;\ T A\ \     W `  \ )u]  x^ 싎      6 $IQ ` !!\ 2 \ 2\ W R :D\ \ Hf8=T  (AP\0\ TP\ \ \  3\ \ d: u\ S$|\ \  \ /  \ E z   EPu\ O\ q \ D ńݲ P 77\ M?
 O\   {  \  \ k(\ W \" \ \ + x`   $\ \ % n#N  /̢& -W5p\ ۾% kY\ \   Ev{:\ PϾ\ \ O\  \ Kj J \\AY \0 $f >   34 \ \ !&   RR< v LU\ y\ 
ɞ\ ,$  \ K  } >K\  \ \ \ 3  C7*\ \ PSYZ T   Ed \'\ ߘ\ \ zUo   x \    \ Y%@\ ~B\ bBu   \ 
{BdKVa\ 3 @   u 	[  \ 0 A SD X  eJ  \ (=\ \ 2\ A    B \ \    	P iu 1u]b\ F  \ F \ d    !\   h   t$ i  T J\ g\ \ 2  \0V       \ -16 F\ \ \ KU \rn9 \ 0 V| ق8\ \ri\ %\ ]#r \   X  P\r \ \ A,ۚs 6,p\ hE +,#v\ ti   ^&|  \   \ \   P\ 
0
\   \ \  \ d3  17 \ \ - \ T :  r#X۪5L Tz
 D s ,  \0\ x     \ \ ?<0 ! ] ұ֮\  R    .+\0\r  sq kͱ  \r  _@ f\   k 6    - #\ T \ \ _I\ &:\  h}\ \ r \ \ \ pO B/  3^\r}O#+x   %U\ \ ћ\ a |s4+   i D j \ qUu/L \ mG8f	. b \ sh ٙ\ z {&b2   8)  \ N\ C +\r5  ֌!l9 \ Uq w   \ \ \ \ y^   ]   KWy        P }T9\ G0\ \\>\ 0   \0 ( S  \ Q9R \nk \  fWx_3\ +\'\ \  \ \ XF V\ 6  \ \n\ %M3	\  \ \ \ 5 \ \n     \ Vc S1Xj\ZtكkчJ\ Kv \  y\ ]ꥦ Ɍ \ \ -o\  \ZH   \ j &/ 唕x t n\ P.Q7< TE{r   \r0\Zl\' }    6\ /U  c ׺[]}*  \ ~+8U\ \ %\ q 1)m  (n\0RR   %oZ}  k\ 5\  j      $
U\ w IY\ \ Ho\ 0 \ !)=4,,*\0N 9 C W\   \ \ ( T  T \0< `- \  \ 0\    ((\ q  pJ U( {\ X  |\ \ \ -\ X`i   	Uic
  h\ d7    q,  \ I    \r# Ǥ\ (+o `EV \ 0 }     \n \    RiY1w 8 z~H\ \n\ \ \ \ ^ F / |   s0\  AtOR \ LB ڇ	\ 
  (~\ 1\ _&D˵T   \ \ } \0\ I\ ϳ6  S    4Z\ [V\ \ \ .\"3Pj   \ 4\ M\ O:    |  \   o\ \ \ 5   Z &΁v \ P\ I      r xĢ  \ b\r \ \ /\'ɂJ y P 1(FZV*^C1=:     \ ( \ Z a   : G\ pm \ .,   i\ \ 
;M  ]e@ޠL\ Y <C. <  C 	̢\  \ :\ \ 6\ ; \ ?@ @\ ( \ 4 jf   Tن Bi P? 0  \ u 8\ t\ N + ~ g  G\ \ \0 Nm  h\ ѦQcOؘ
\ \ -ч\ m   \"gG ]  1\ Ѫag5u\0\n\Z\ \ r n  b)\ 9}\    ]\ C\ \ W * 7\ 2\ \ !\   \ \  tsS6E@ \ b ;q;  x,zY \ ~Oפ \ O  U   q YC]Ѧ \ fd uC   4YlU}      \ /A y       \ + \ d   \  e  \n\ .\ à %p_ \ %T _\ \"Ni\ZN3\Z  \ r\ \ \   \ \ dTf,  x 8\0\ 1  _   ?  ҭ ȝkD Fe- N ֶ \" \ ] /|\ iN  ݌ κ #v   ; <l\ x E\ n ~ a\ tU SԆ}\ 兀8< \ \ ?Q  ͱ8 \ \ ;  \  J   4
k\   \   é- L L \  X!   \0 ^ r\n־  \0 \ Q   +\     T  .\  Yۙ\\mdX\  Yb   \ `(. [w j\n   \ \ \ E s7[, V*a w\\!h`h ܸ \  oB ̪h P\ }\ a  X䞳J  \ 0 P\ \r  \ W   K\ 5\ q9A ӬbI UC1s !\r~ \\I x Y\ #  	   \  n%\ q   Tj \   9h*u\ W  \Z3  \ \ _Q. % \ iB ?   !u \ k @Q V\ F|EPdq
\ @_YkPmvr{L \ \ rY\ a=\    k\  \ V \\g v\   @\ \ W(\ <:\ +\\   Rķ؄  r s    \Z  N  } \ \ * \ ~\ qݴ 2 J] \Z  \ , yj\ 7> kq1\Z6 Z僥0\ =Yv+j* +\ R\ \ \ u)\\ \ Qs  \ : U\ \ Mn)\ $ \ \ \ D\ \ s\ Vưn M 2\ XS   8b  \ EXi\ \  XՍ  2\   c e\ nO<\ \0⛁\ \ [  !\ \ \    [\ vc\ \ \ BQ p7(Ҿ\ >\ F \ X \ YE ĸ _ e\ \ \  t )  0X 8 yRE \ ,\ \ 现 )ԝ+\ \ E\raP\ S D\  cZ\ w qW \Z \  \ Nz 7չF\ { b\ -\ Ƌ  /  30 󮄢\ R\ \ dT    wfK    F  /  \ ^kۊ i + ;s8\ 1      \ \ +r   ߣ \ E \ \ `L   6Ll \ | 
d\ =P [  C3   ǚ \ \ \ s8\ W  \  \ \ %\ \ `  1N ˄   2 2\0@k    m  p e堅˴W \ I  \   oN  g\ \Z N;\ + ~  Z\ Du>	K\  ,.+ \ #5\ \ A xz* \ @#  \ ؋\ {\ ͭuE\ Ը(Qn;  5\ \ F\ \ -? IF Jh > Yp
X\r\ > Ð 䋔 p[ o k7 < Cguw\ ̒ \ ƌ y \\   ±e o\ \   \\\  \" \ \ 4p\  \ 0 /2 
sX\   = u\ {}\ \ Sb˘\ .\'P\n^#  d  \ fw   xN \ \0]^   JS g\ A  D\ \  #u\Z   Խmq\ \ ȴZ \  \ ~  nU^B \ 
Q%\ \ O\r@? = @\ \ \ V  Z 0I\  %| a@	O ![n\ ǘ} \ \ F Uj>/  <$*м   \ ak   \ \ =D \   j~\ Z R
  OY ۜ\ !2W\ a ( \ y  -- j  @ `\  \ ,q\ \  ʋO   \ 7Dg ?  YR f\ \ {5\ S M\n\ Q \ 7(La\ j   U\ W x\r5r   HE \ \ >վG\ ͔ \   D  g  b.ʿ\ \ \   ħ9 w\ \ Ig ǀ\ \0\ \ A*q h 9 i 9 )vp  \ z\ ̽Ԗ$\ y/\\]A \ Ĺ  \ P\ 5d\ 0C ~I\ .  \  \ \ V LV\nRc\ q| ̀{Ը\ \  \ 6\ u |   )  l \\ i{< G \   \0      G\ \\ ˌ\ r  Kv \ \ H\ v٩G_G\ פa    {k \ җ S 2r 4 \    \ [\n\Z D\06 {\ \ R \0i+ \ P:l\ }P  t T l\ { ,	s \   h\ An\\z̫U- c\ u t ā\ }/1 \ \ 63\ \\\ D\ B.V d   _\  S/T\ \ \n ;T  d2\ .ܡ)M\ \ Kz@\ `<2  \ }F   \ \     x!z  ~ *5\  ^   b&;   \ %k\ 1   \0Բ    M  bvc 7\  |   sKjd\ \ >\"ꢚ,6\ \ \ \ j f \' e T   h:,9 *\ ]RU\ SG \  L\ 6n  ct  ӂ|\ \ >\ R)F؍  A\rX\    \n:ֺs: \n  \0Z \  l  % QM 50$D\ \ T S?   OC2 \  1Nh;Re\Z0e\ \r 0L \ Բ tf\ \ \Z zj,y7+,  \Z\ e \ n\ k   \\ \ \ \ \ n-
  c   1 6 \ B 3=q	\ .[  [. \ \ {0 _  \ zn O_0 \ Y]q\Z  J\'R\\\ u+M\    !i+pN1 ]+ E  8` \ \ 2\ \ \n .  o\ \ AIhV  \ e m:c\ 3P\ \     \ E\ c B4\ ?eMrZi 7\ y t  &  =j 5\Z eW\ \  l  \  \ \' * g\ u .\"Š l\ \ <+\06N `   Ks  j   \ tqE0\Z\  DN ڽ\ q\ G  \ ^ \ A\ x \nۨvWu\ 7ʒ]+ : \0 P \ V  6 tV\ 1\ \ @\ +ԤRZ  \ 009 p c*|\ ~\ XdФ8zK
 0\ =b9  , \ \ lg     \ \"
yt Q  \  i\ \ \ ZF\ dܺ  \r KnWV7\  \ M  \ 
m  i \ 6  \ )LsOd\ ^ 4\ w   MSyʬ OZ  +e{ƀ8b X J+\ S *57= \ e\ @˸=\ VMu  ;+  \ : 3L\ \ X  bT?\ }r%  \  \  \ 3&o  \ [j  \ .h6 \' \ \ ][7x  ypnOpaX\  I \0\"1 nh U ^  \ \ \ e\ :zQX eh(چ \  \ \ \ ÷Sf \ \n \ \ 	MUe5\ \ H\  Eʛ\  VI\ q_4  \ZWv \ \ q \ x    \ \  \ 2͇Y  = \"Xvx n\ ) b U\r  h\ m \ \ c\0 \ \ \ mɨ3+N>    :  2\ 8  {\ I\n)y   : \'1 /Vt\\0   `E\ :\ R\ \n  a\ ;9 \ \ &J     8	 10b T\ tY 8L/ъeE\ X  ׃\0 \ \ r  |Ŀ  Xs :K\  \ ~  \ }  \0`>\ \  \0务i- \ |O n?P   \  ?J6    \  !\   X    _R\ ̣\   D  U\  hά 5Cj   (\ \rPWn<\   \  -    uk \ VO * Fnl   ^J Tqn\ U\  J ~\ id\ nk wɅ  Δ\ QP\ \ \ c]  \ ~    \"Wv^ h Vc<( Z\ p P-X \ \ =\\\ C5CUwP g Y[\r \0)&
  \" \ 1<a  \ \"\  |\ XJ6(  -a A  }  W [\ni \0    U5 \" _H \ nh\  \ .\ \ GmB9\   enj   Պ   ^ !w \ /ഴyw y   v KX\  W` 5 \Z \ ö   s\ ո \   h  [q  eX\Z\ T 
 \ \ (\ \ \ \  < \ 2 Lk   \ \ c    :U )\ n h \ >E   b  `\ dn Hvr B TEjB{\ s\"+s -\ X ,7t{c\ [qoy\ \ ! 	 \ \ s? !\ \  M\ `\ ,   B  4휑  q g [ǡau \ \ )	\ =\ t\0 j \ \ \  lKۮW\  4  \ b? ;  ] ƫ֦  >\ \\ \Z\ \   \ x
S \ z S\\d \ \ \ \   \ 0Mi Q N\ D  \ X^aE mW  \ \ Ds\ gJe   \ \ ax ŕ\  ;\ uC8g-\ j  G)@ نnMd2{\  X w\ \ ^\  j ɠ   	\ l {˻,}tc h x\ u\ 
*  3 \r  \   f (QSt  w  RW @ \ \ -ʕaO M \ \ \ 5  eU  \ f z A \ O\ \ S  vV   \ W \ \   =   \ i Kb \ B3   O\ q  
 2   |/\ - v\ p# :	+\ @] / \ 3 l {37+p  %Pf \   \ \ ovW9\" \  vu\  `r w \ Q 
\ \   \Z\ ^79 0  \\  \ \ 0  h,  \ 覒\ 5\ \ >  ] Q \  a\ZV \0S ѓĴk\ w~؄X0 R#  ! (   mM \ T  <\ v \ [G\  M\ g\ , P. \'\\&\ r}eU \ P7\n\ \ jdm\"it   \ \ Bq
N o\ r  8ej%V \ 	 \0  /pv~J\  \ k\04 O 
 m\ W \ \ \    o    XH Lс 42  o \ E  l u C-  b\'$<    V%;j \0R 2  FL\"`\0  M* X\ NҊ \ \ \ `\ \ EfE\ Ţ4  \ [O \    l H|  \ \'5   \ \ \ C   [U  Qg\ ɶ/ \0\ l E  \Z\ @ \ ĳXiE \ o 
_(\\9 \ o\ 1   % ݕ \'$رA  \ j-ܫ\ B\ yc\ (3\     p\ z8 Z Ӊ \ C . [ \ AE\ r\ X+ \ \ \" \ 6!\ \ -jAvI|v wPQ Ҿ.X\ W \ & \ C T s *\ 2  \ ;b   \ 5\ Ī \ ԰\ \ mch    \ E	\ @d\  M ie\ b\\zG\ tn:4Y  p\  
jyC  t\ B ט\ 2\ : L\ \ S    l ZB \ Q> \ >̢ u|ǫ\ /\ \  HFbX\ K \ L -(%GB c3 k  \  \ & k  I  [ \ ;\     ._\ _ fN @\ \ \ a\ D   ] X \ x \ .*1X\ \ [\ \ 嵩O\'IQ dP\ 0\ \n  \   ,T \  9U\ \ BWr\ e \ yK|  \ \ ! r  \  5 A \ \  \\ 3 \ {è  E{  &   /x5\ \'  W 8\ Е_ \ q{ w!E  ]AA \" \Z-v[  YЕkZ\    \ Þ \ \ A (   y 2 H#\ 1	 \ e>#ʏ[>\     .\ \ \ 3\ \ L\" \ m\ #Y\ m  \\ [\ Qm7\\8 Ժ\ V\ R(\"  = B Fє3 Ӟ  \ 3t3\ 冝 Q`Cϫ  35q Z\ (RaIT*^*T\\*  n= e\"   \ \' *Q  +v \  Ai\ \ ۯ   +ۥ\ \ \nA\ \ #\ y  ڈQ ߒ - 0  d\ \ ] \0\ L q\ T!oQ\ }\ X\rQ Ж\ \Z Y\  ơK    { ^\ ` \ d; N\ FK%ͫD	  l  N u\ u  y`\   \rT ^YNbV ~@蘂 ( \ \  \ ,\ #\ A= D  \  ]\ >  $-m\Z\ r \ \nb  W YV\ ]` 
w l t4\  \  (,8\ B  Y  = S OH \ \nA<E]U  q	 } Üe\ \ \ ! rǶ  )v ]\n       mKVzZ   \ l rXـ Cv#Y-\  R} \ \ \ \ ^\Z\ \  \ 
m-,\ , /ƤioaE  Y \ { F\ 1S}c f  RS\ =%JCw , < \0\ +\ ̢   y `\ \ fOՆ5m=\ V\ \ \ ^s , \rEc\   \ \  nW\ \ \ \ C\  \0 \ ] \ ^  b \ZF\ @\  \ \ + J }8
}ȹ   =e/ i\ \ $/\     e=H4:\ \ U}Ṯ AlN\ \" +\n Eyvz\      p\  ?s&\  \ \ \  \01ʌ\ \ ye   X  \n  _  4: \0i\\K bg   i  Bʶ ƺ	W0\ _\ 1\ \ \ z\ LMb  \ ^̋\ So CVf٧ (m\ n \ i 0z\ ( \ ( 6 *\ L <  \r\"n|  ̪+ J QK\ \ 9\ \ (  Ɠ ^\ fn\ P \ n _-) }   I_\ \  \ _ }e \ / %&  .5 \ LsL ԏ  >F P i \ %c -_?\ G  ˪[W\Zi  11u  \ \ \ ϲd}  %\ j uj  \ \ \rZY B   ޠ  KF\ w\ 6 \ )Wl\ \nuqJ7/\ t  ,^Y \'\   \Z \ ֠@z$\ 4p%  M0 b\ u G   \ e3 |:  Eu \ \ ~z깸 \ / \ و\ 6  Ҫ 9\ 2\ (*  x\ T1  \     tG Y\ C h 5 x\      w  n\ xD(٢ C x^ C ]  a \   w\ %q m[M    
l=m\ \r S 9 _o  \ \ `]z   .R    *갺\  =  #\n  N [qR z?\ \\5 9GeG   \ J \ \ , 6  yb    u3b\ L f\ Qŗ.4\ \ t \04b\n^  xj\ \ /1  K9c  )uE \ \\\ 4=\ l,z\ j \ Y\ @ \ 1]£ 0 L\ V A Y\ -\ 6 \  \0+    \ $\ Y{  \   jQs	v5\ z \ (  2Ao͙ z\ \ \ \ }  \0]# Ueo  .\ V K u    \ @Z   C\ E \ *t\ J\ \ Q \0 ,  yeb  8\'T-h  a\ =b ʨ5-Ù - Þf b  ̎X\ \ \ \ ȝF5\ \ Ih\ \ \  F6=_  kЯ  \0 2\  @ \ 1U\ &l^w,i J  	zW2 \ tx  5$2  % b[A\ p  Ǔ 2 4 =6C *    fY b=  \ \ 6<\"D/\Z +@)[B#   \ \"˙1)\ {\ AK\  V LjC e2\ \ M\ \ h \ >\ յ\ \ 3iT     0 8p\     \r\ ^$ p   	q Y \ S\r&(zK\ \ m1\n\ Zk;3  \ ]\ \ ϏxR a W9ʻta\ I 	 w   C Êto AlO\ \  9\  o\ 4  <2jV   H  Olp\ wi  Fʬl/ \ a    \ $$  l  2۹\ R  TR ^^   \ sm\ ?  ]\ U:) ]̼\0 /\ ĆA Q X!m 8 \ !:|P\\v \ 52 \   X\ x O /H N i\\*o [  _ \ ĕ\Z  X y M\ \ \ c\ #Y\ QUp% \ 	qR`   \ *\    %`  e \ jR    \ \ ~U q y\ Y u\ \ X(8 \ G  &  ` [c 7 \ K \ J\ #I\ \ K
 7w\0\  \ \  \ t*F  \ $ n ?  L{J- =\ ;\ qm \ h\ ̗  \0R \   \ ^Ͳ Mm\ b\\Z    \  \0r#\ \ ckƥ\" [c(i: (  I    b    X\ \ $j>\ U KY^ ?ĺ   \ \'*-  K/3u|\ \ \ F+o  Y \ ҥ \  \0 \ 1O\ E^ q   \ j\  YM\ \ ,  n^ \ 	  d  0U% j n   g \   si݈\ ӓ2  bi\  \\\\\ ^f L\\ƃ n 3- K\ \"tK\"     iEi.[M IP  92|ō8    v\  Y  \  23K\ \0\"\ E\ \'YY )22h\ *\  \r C K\  0 \ \ #d      qG`  u \ a # QH˹   V 6: k\ :\ \ 5i \ \  Ԇ\ \ 5F  \ 3f\Z  < OI߹7 >0\ 
 \ @ \ \ \r=Od}o߹\Z l4 \ ]t  ak\ e \  #   \r\ ou N  }%6 o\   =\0  W \ h4\  \ }-Ԣɕř\ 7[C \ \ F \ \ \Z \0  \"\ \ \ \  ((]G ?2Kfw sȮܧ\ p  KVD  \ | \ T\ \ # \ \n\ t_  \ \ \ o\ ll .\ \ g n  ?E  XUpfW	j )g 𑊤$ 6^T .\0N \ o b\ 7  7; \ [Im  \ C 7 \ f\  \ l\n\' g8\ ް\ &\ 8B\ /n[r\ QՌ;  \   \"  ]g   xx\ g\ 4^0    vysz\ @;\ 7 q\ ,V b\ ( 7 $ S ξ w\ `  -\n|$K\",(  o   L	\\/  A\ Y\ \ oo\ \n  ,Zc\ N \ \"\ -YT\ \ XXMb(me  Qh \ gPߛN\ 3\" Xᔳ\ E EJ \ W ?p] n  \  #f~\ N΢.˜ P=Ջ 	q{ dcl  M  @ݏn\ ,: 04b ]x  \ *7Ĺ\  \  \ K\ ~\ \  =4Fb i.ݳ\ e\ \\V\ Z   \ ` \ <{\ @\ \ \ xCO\  c̆c\    h   R8Ǵ\  % AV׉t \ 6\ \ 9 ơ     \Z   B Z\ Lʣ\ x:@>\ c}s(0K   bVDWfS\Z)R 2 @ \ # 1\ \ \ 	С   % b \ NwQ  \   A \ ˅  j- \0N VSt  \ g** ^3\  o X f{     \ pr  Y@ V)W\ - \ \ \ \ c SOs 2 T\ \ b9\  .\\ۅ u  5#m  \ l \ 0    v : uFa    ^  \ +  m \  4  (z(\ p\ [iӤ\0  \   rƓ b\ \ c T:   l ;\r\ Pc\ ʴ 15   )Iz\ \\^  2 \ 3Y_( \ XҜޥ\ |\ _\n  h Yu \ X]\ h:Z/ ;r \  < \ )\ \ ]!p]K\ 8O \\?\ ` s+  \  \ P \ z5lu ()\ )~  \ Q% \  
.!  L  D\ \ SY} 9   \ \r\r޹ Q:8  F  ;  rّx )U  j W  \  ܵ8Q\ F  j\ \ U y  Cw%[ \" ^R\   \r\ t \ 7t \ \ /+ [ J; _0  4l 5wZ ~2\ [\Zۆ*\ \ +\ \ ? (	s\ _ 6 \ Ww d@+  J X  \  o  3Q {K\     Wr\   @ \ Bdo Eh  7\ > z   L x  \ \ \ x	@Z\ Rؽ[ N1o Lk\ U   :8   \ s x \ 3 
   j\r_0\ m %\ yK$\ \ . *7\'K\ @  QR\ \0ż̆\" \ e\ } e , \ .=; \Zs P1\ y =#\ 0 t -tF: \ q+1D.\nq   \  \0%+ T:%ѫF   \ >\ 1G w9\  w_f    -1 , ~N\ R     T Oy P څ p\ y \ \ mBՠwS \ H]\0 Ua6g.       HKU H.)  \ \  \ 7 Z  b\ 2u (E\ \ 0A\ Ʌh\ \ \ eڼ \  l e:O  \ 2*\ \'&  4 *Q\    %\ \ 7\r 맘\ Kљb\  \ a0 \   P  \ ,\ 
\ \ bZQ\  j(  J\ \ <  5y#1 \'Rs\ pz\"\ R&  \ < \ L )လF*\ \ \ >s)xUȃR 🔡  \ V+ %   Қ  \ M\ t\00i l\ \   zs~\ hGZ ǎʠ\' 00\ 1z   \ * a|C j (\ m酮\0 <\ u*\  L\ \ \ 7   # `@EiW  J Y~\ x{ [GB\ Z\ `3    _ Q\n8G   C   \ *\ P;\  \0qpa҂\ \ D n\  Bh  \ A鷒/ܠ խY /\ \ @1\ \"0 IhS\ $
\ l\ \\ p\ {6 /\ \ Q < p    }ˢ j\ \  \ OSu + Wf Y p_X\  @+P \ 
o fùb\ \r c L\r-  t\ iS\   9  n {\ \   \ 8%\ q  Y ̴\ v\")D\ R e \  :@  \nl,Xq׮#\ Vf(\ \ ! ʼ\ lZB Fp\ \ \r `\ M A x\  :% \ i\ (  ) 0w 5,|\ wDh  j\ - u(\ \ > ۚ \0%L\ ī)_ Y@8R b h\ g  bg \ b}  {\ #I/\r \\  w  oz( \ 8\ ě \Z  \\q\ 8  \0An \\\ uXr8B[\ \ J\ \ =\ ԡ3I	N c 	s 6W  1ֱ\rbtF -  \ .u0- \\ثec ]ZD -C  Z  H\ Y\ k\ \ P  HD   \ \  B\ B }n+i r  @\ |+2\ l D t\ !y \ Ym \ \r  Ǵ \ K\ |
ሩ    1S\ ΂\ { J\"\ 0*  ϘN \0 , 
 \ \ \" \  ĵʠ <  OP\ ; _   `T*K\ H6q^\ . ~ @  \   >e d  *\\5\ \ r9.T9\ U }c\   ? 7  \ \ 	d^ X<\ \ u W  \ j  2 \' \0P5 х  4Ўe\ \ QWC?0  _g\ 9V d\ #fx  \ +:E & \ U\ U      \ \ +Ռ#;\ `m\ k D \ \  )U`\Zq   \ \ \  c k 4* Tt 
\ l9  : Qsx \0&7\ s\ ? #  \ 8 `\ 櫉  n \  \ F \ E/	  L \ %  F\ U3h! \ \ \ lMJ8e\ u      jW iY\ 1 \ 
 Vx  Q39 A  b: C \ W -kx ҅.\ U_( + \  &R\ v \ \ ;)k\ 33:>\  !@\ Y  3\ \ \n ]\ |H\ o\ \ \ 1\ p`\n\ nFf\  QYf\ \ s1PB \n     \ \ \ y T3\ 4]e\ \ - C\0MX`Y\  GL p   zJ\ L\ J ^X\ E \ \ ej^\ \Z   Y \  h Ac \ \ \ 2Va\ \ H K_F Id \ Yg\ P  H,\ \ {   ӡ  } `    ߹\n    \   ( E \ u \ WT \  \ 5\'  Ft  _ i #/\   c?P*Hi _\  +, X gHU\ ]L\ t u  C ]gRĔ n1y;\ i Bn6\ p\ =5   ~٥  ,G ,N\ Xu)Z\ CU   ):B 3 OS  \  \0%   \ 7_b  \ \  \0 H Kkห ֖[\ \ \ J\ \  N @A\ H- ; @G  >\ #E c )  f\ d\ \ e I b  % h\rnlH \  CQ\ x \ * FgxKuU L  \Z˛D~\ kJ\ }  \ 8 #\"   FF]      yA-* ./>5	 V(\ \ S $\ u Wn\ y~!1 \ | \ ,   ϳ1T 65QV[  X \ Pc\  \Z  ?  ܺв\ .ب\ qRֿH    0^m1dB. [ F+q \ p@\  Uy%^F\ .[-  \ @ m3. \ 2s+\ 1  \ x\ IU\ \ Vn)( \ c w  ĳX 5\ e c\ \ =~\ u a]\ Q|T -  M1\\ Wl \n>  \ .   \  8 \" >ud%qcp jV؂[ \ ! \ \ \"\ \  \Z iL\ \ 7j   \ %m\ MC\np  \ )0 ]\ u\  \ g\ *\   g!J9 J {\ \' `}/ \ r /\Zz@  ,Ku\ \ >- e   tx Nv  \ v Z\ p    j\  \ s\  n4\r    s]\ ` ӡ\ H\"\0  d(\ H ~uCT   8<\ ʃ V\     ķ 89} r  -\ \ o\   \ 9\ =\ qg \ a\  \"   \  
q \ ,Z׮ a  \ Gc  \ aDB  ! y   5  \ ( z `Z g 1cA\\1\ \ }DXp \ \ \   F\ \ o\'x#} Wi mU{@ Cy,   \ S/N   ^7  g ~R \    *)\ ? s xS 0qa	 & [\ ܸ ~  P    \nP\ Y\Z \  \r\ } 3 +  s\ 	R\ C      0#H\ ֪S( -  Fhv  NU$ H\   0c \  s!Zl\ \ q\ |\ C -1 ҇H Ne7 fc]\rE _j \ 3 J  \ LR \ (5X  	\ ! )Qj EP 9\ H   wpM\ \0> \ :m  V	d   \ \ \ # Q.i^b rx L  `\ zJ\ CҦ fy \0 1\ bV5w ]\ Т e\n ` w\ j\n\Z{\ 1># s \ %  c e ?\ n& \   ( ɀ \    }     \Z\ \ <  h x  Es]ȃ  b \  \ U mu ԧɘ̒ ~i \ gLfMir: / 9\  ɰ    @  \ c\nU\r] \"@S\ \ ZS ?R   \0x CA(  \ -}Q !  \Z>%\ \ \ hTTľ Pj!\ZG\  G֡  Z\ f\ Q 6 \   	  v# \ }XE\ +\' L \ \ ľ   m WH9/O  k   nZ\ b #Gƾ\  ^x\ )\ Xit  6z [\ Ǿ\'=\ \ 3>    )  \0f \ 9  d\ \ x\ \ ry\ Qs\ \ \Z\ \ C U  @ \ \ }  2R   \ \  \ c  \ \0]*NҐ \ :b|JXj5g\ 2 .  r\ p \  e{>#\\^ ? h \ \ .   \ \ %oϲ \  a\ TΦ\\) yU    \  n = X J   4\ j @\  x P^a\ \n VyLn<  \ |1ed ul @i 7  \  ,\ \ ^\ Ќ Ϯ  *9\ . \  y\ x=  m\ * y\ ^  ~\'0  v,   J vW ̡s\ 莮.  \" \  f\ +\ \ 2Ћ   5eh&\ \ \"^   +G=\'p $R \  E݀  2  + * 8\ o*Jm D3 \ +  F \ 0  \ \ f  1  1  E yV\ B q\  R\ hhm`  © ڥ ;& \ R \ \ *!\ H\ Ο\ \nR=U 膒\ ūx\ \ \ -7P & t`걁0  S` \ }\ \ \ 4 *
JZ\ 3, 5y<\    \ p\ + ,\  \0     s* e\ \ \ Z/ \ \ b jOvZV\ ! \ :t1sq d   W[ \ 	 \\    \ \ + 7\Z   	v\ c :` f~%\ \  7Yf(_ З\ fK{   ^! _;PZ t% m \ \ \ >d  \r=u R  \ \ 6\\ kt\ \ 6_ ?\ FCK9n  \ 0X 1  Nw\  \'M\0lplf \ \ B֕ \ \ E ) \n\ZAY  pK\"\     K\ ][ < 3\'儲 {\0\"O,*\ W w@:7\ Z `\ { @  K ht  َ%\ \  .\ b   T W  \ \ \ 8Z%x8  |  R kg2  Ԭ\  ! O-~    \  p\ \ \  \0 vZ \  \ g\ >0 \ ٽ\  \'.qq SsW7i HZ  6\ gUDw|    !	n  \r \ \ \ R \0= \n 5h b   
 V$xO\ \ \ W D \0̜1hs    Z7 \ # ~ j\ Gv \ Vיu|\'\ /> \   ~\ K \n\' H @  \">  \ z u  x m W  P
 1F\0ew\n4 h _\ @_\ r 0q (D[ S \ 0\ \Zi *   ̷B  \  [vW\ \ u |\ a J$\ \  & \ K \ \ o>\ (ڎ +5ꨨ\ >\  \0r X  +U ;t }  \ \ \ T0  )d \ ,e  qu  }  _ \   \   =f   
 g q\ t  \ \ f:  !R]\"\ <ˌyVYZ =OH /  \ pM3.    qQ˚%/! f =X Ѳ\ +  
A\ \n  \ \ Ө    g\ 7SZ;  6 JD ծ X[G   Kܰ\ \ M      8~!*(&`  _\ \ *;   \  Bɋf\ /{\ 5 p~\  ̔w  ǵ\ +\ \\   \0	uXN \ \ ϸ: / \ \ b c\ ( g,= τ  \ @`   \ \ m  -2}\ 
(\ \n $ & O  W   `    x\ 5o\ P    / U\ zb   +\ :  Q 9 0>\0 L\ \ i \n f\ ,\   L \ B    \ \ ׋\ &   \ &X?0   * 칀| U  K 
\ V   \0`\Z\n]# !݂KB \  Z$eB/ Q \Z fĆ \ \       XU\ \0  I MFʃ R$: \  spW     R\ \        $ڶ ̾  \ Z  \ \n \ G R iZ\ \ p   {fZ\ \ 5Or  < v \0\ N b\ A\   [ \ V\ \ Ym$\ n,\  ŽK{D, L *P \ \  \ 8 \ g, [ew \ 2 :E Q\ u  \ f\ sf   /  B% \  \ Jf lq\ L     \  C_Q%  #\ ,E Z\ 17Ё sM\ : \0\n Ⱥˍ iϼ\ j  kR ?Ĭ`W S/   43Y \  ,   \ *\ \ \"L T  FOr $  eP י{  d Y  % \ \ o3*\  \"6\ U/\n [\  l]\ j /5 ^ K   L/h\ R  U ?PJ\ 7 }  Pv\  FW>  \ \ ?  L܉rJ  \ fR޷\ \ \ \ `   \ \"\n m^cu \"[ %m\ \\   :\ \ -  F/ W lF,` \ Ǧ Z  B  U|  \ j\Z\\  \0p\ \ q\ \ \ y(   U\ R\ \Z\ \ P\ \ d \ \  U!\ \np{̛jW   /h5%xs ZW\ 5W - \ 7\ <   \ 0y \0giJ\ \    \ \r\ S  P 40=\ Qu  \'\\\   Hص  \ \00
\  I @O\ p \0 \ }   OV e Q\ \ k=bx [o\ Ӊs\n%? ; +V?F9 @o\ Wy   D͵k7 \ ~ (0\ \ F   Js\ +\ \ \ b   M    \ \ /^GfE\ J A5  S  &>\ {A(D @ܬ@ WK\ 9    R3 bk +\ Tu /\ ?p  [ \ %\ \ A\ ?\ *\ _ s DGh\' !\ \ \ \    e\ _  X\ UR  r ʦ %>   \ :\   S@A   &\ \ /k #\   jh \\^Ѯ D\ 9   \ \ ^ TlU9\ \ }   xj\Z\'6\ \ 9 h \ \  * % \ Xl\r\0 G r^\n#ݡ  \ <\    \ nH\ B i߈ \ m       Q O\ cm ta\ \ ana0R \ ?`\ %z\  %0[  \"pMc ۆ\ H ўL\ g,b\  \0n\ h`g  A ( ݄|\ \ / _\ b9 \  \ c=  \ y opFm  3E \ 0\ 
 O * Y ~\ \ Aq  \ F \ \ ._U
E/\ =\    H\ ە :	  Aפ \ * QŞ t4 \ \ zt\  \ \n    F  HT}1 U4  y GN pאR a  q6  \0&| ] X  , \ @ 1k~\ ͦW K   /  ǖ? \ b\\  \    \ \ N \ % \  G E\ K)  \ \ E\ \ R\ ~ 0 ~T+Ɋ\ 2-=ꑵ\ \' d\ Ï Tֱ ϛ#L _c䮃\ U= \\\ gm c\ &g j/ W  \ BY  +\ 
\  \ b\ \ v`\ CQh%\ kq\  J D\ \ VzK \ F X] vĹ\ x\ \ \ =@B  F% .y \ \ \ Km   Nb}\ ez  E N : \ $\n i\ cqU1\  j \ | KN\ 9 s\ K\ ŷAS   )րVK \ b  \ ^\ `  \ 2\  Ϙ/ gM˃  \"V = e \ \ mu\0   .\ \ \ -(\ c\ D V! a|\ \ 4\ \ 2 &MCq\ b* \ ]\ % ʳ  \ ? \\+5\   	  \ BP [ ~$wZ \ A{\ t\0
 ΒЪ  c n`N\ A  K    l U\ VS\ 6\ h  b ~\ V\ A9  \ \ +(\ gR\0  D c  ˌ \ f17=7\ -ZFj; ̇^     v ั\ r\ B \0,   Xd\ [  \   Z!	  \ eI  00aן2ԽB \ /   nPM \     \0\0  \' \'_<  n  S lco &K\ } H8  o>\ \ Q  g ) rA =\0T&=( \\ ϊ  L*#  ״ba\ -L\ _r%~  C    \ ^:\ *\"9 ~Z  գ\ .\ !}W\ \ 6\ =\ h  \ 2\   \  A K 6     Ɩ\   \ |  \0\ Td\ fYq	2 ~Ry_ꋃ8^     \ @͗ )/\ \r +Lz\ \ \ v\ \ (ʶ͇  ئ O,\" :Sm/  yĵVn⎥b  f  |E]3fz\  o   \'  &\ \ V| ϣ_\ s E   $Eb  j 
A\ \ \ ]  [f \ I \ L  Dik^ 1 \  P k\ *1  S+冫_+}Tae\ [ \ ؝\ d^:\\rkN姊5 fs\ $   ͨ\ v    \ / A`AȮ\  ̰\ Ty\ \ ;R \ \ \ *c  K: F   \n?\ 5    3N c\  ^  >q? m \ c d \ f _E9 \ns ܼF ~f9.\  )\ 4 1\\ \ \ g\r R \  By   9\ \  \Z    \ \ 엳[  ` O$ E>PD \ $@ \ >      AwC_x \ l [H Υ7 \ . WPh 1 \ wS \ \r˻\ C~e\ 8p\0   f x    \ (\ f\      \ \ \ :P* )  ٛ!  b\ Hw #T   K޻ =\ f< >X o\ (T\ R eȭ\ u\      7ķ bj \   \  a xP\ \ zAG \" P߬%  &O=\ D c\ WM r > \ \ / \ tS? I f \ )\ \  ȕ1 ((  (\  A :0\0q >ET(a\ \ \ \ \ A Ļ\ \  I  %l 㸢 X\  \"7 56\ a  \ ,d  G / ̲۔  #P\ {Ap  b[6q\ +ޠ\ #\Z Dù\ \ H Oy Ģ   \0\n  \ >  \Z  \ x\0  5\ \ \ ᾊSe +j |ɢ xl5 \r\ b P 5< u ⭆ LF *  RK\ \ \  S\rs+  \ \ \ \ =ഡ0\ @ \ \  =\ \ (S]	 @(\ mi##v\\1 p=   y 4J Ma ې# , & \ n^b\ h X  G1J]\n \ \  / E\ haP  \  > \ ]K8 \  K\n;A\ \ \ 3 Q@ ҫ\ ס+ |   \0 \'\r\0ZTf\0 ;ntA\ Og   } R@ \ G ܍* @J   c\ r \ i yK\ \ )-U̷/ ,-F`\ \ ( m.% \Z \  \ x   VZ  [     /  9J7l9@.:\ b\ ec   Q T B \ z\  
 D5 ?ii\ .\ dA4; 4 \  ss ,ݳ  E \ k* * 0  u   ff\n A= 2 \ #\ ) ȍ  \ \ OYF\ 2 \ \ \   H `h    \ /JP\ZK- \ m  -\ ה؏ 5    [\   
Rȉ ̧\ *r\\9 D *  K F  - X   !\   \n ^ a\ R\ z\\s ؉\ \ $	 \  \ \ \ N  e 0 \     n&t \ K;Q  J@\0\  \"E \   ϋgf\ : a\ ~Ӏ  \  @t \ ;= \ y@cp\ 3w\ \ +, \ O2\   [\ s\ s\Z Q G\ \"4 ~ e ӢK` ~ 
r   \\\  C x\ \nn1 m \ \ 5 \ + 샙 X j. J U\\T\ `\ ;Q[=\ \    ,>!i\ ,   {\  K  \0#\ \ ; > 3d p:ں \ \ F \ ̩\ 6̹2\ b>  !_S0\r \  3  ǫ\    w .  \ I .P   \0\ /XG  R\  *\   	 j \   Rr9  1^  !  \ \ 4\ \   ^`5   4: HYD\nE  3v# R   ~ +o   <3O  \  W\  -S  \"{/-u \0 yfiU &3K \ !=\  \ \ !\ \ 	L\"33\ \ 3} 6    \" u \   3  &\  fc   IR\   3l  5   ͑E\ 5\ \  \ \ 5Ԗ\ 
5\n\ gl^3\ ^ \ %Q#\0{7 & \\  \ \"}G iR    R \ i N\ |ύ    $-)x}\ |ObF  >\'  ;   t\ /o \0 Ui \  	|\ _UGZ\\+   yA  \Zx Č% \ 8\ *pe  :  E-9    vG \0ѭ +\ d q쨠6u4\  \ \ 8 \ \ d: *f \  0  )  S    X ;q<17x & 	n\ #H\ , ;0 i\'& \\D \ C\ \ZzuQP+& n\n5- zT N\ L \ a  -وn  a \ u \" \ VR9 s o   `\ E/z N BǄ_\ % C݂\ #  \  \Z֕pg *  \ eb\ a\ ) ^  \   $Ӈ d\ Jc \ !x   \ }  M\ \ Գ3r  \0 \ \ ~ \ \   0\ #\0 \ \ C \ 在 l\ m  \   \ 	^\ ^t\  > ~ \ RpJ  Gٟ0\    !Q  r#x\ \00*  \ Lѵn6\ ꫙(}%   +2   \ \  U Ar   I]r~ }, -\\|LN%= 穢\" \  0\0\ B \ v\ .u =\ \ \n\ \n\ \ \ %e - x#  7\  e\"w2|J  pec& |      \ e   s3ق  q%п$  si  N\ >\  #- p\ \ \ {?X| a{j 1\ZW    \ ? C\ ?4\ ,%{  \ o    \ \ ˁ\ U P \ ph. ?dk\"\ \ k? $ Ք r\ d\0 ى\ 6   Y\ n WLY\ E jo1     g N  % \ h 2 ً\ L+
| \ >!%   -t b\ ¥wb  \ <\ \ U\ H u\ 4\ \ $ N`E\     x \" \ X\'k\ Q帧7<B  1\ qP   \   #\ 1nѦ\0U  d \ \ _QO ^    Eq ʲo& D#   !  O      To9n  \Zz)Ez}        \ \ Q    .4c
 # Jt#\  5R \0տh hլ e\ \ {\ 4+ Ж     \'\ 2b *&5t߼\n (\  ^\ %\ 6 \ | Ç  Tr; q\  X  ` E      \ 9\ \ G.-  Wy  aZ $ɽ0q\Z \ aQ  h  n\ \Z\ * \ D  \\t2T\ S\ +\ 䎱     չ p K ; n 
 \ tzº\ \    w )\0 \ \n\ \ \ \Z   q  N  \ \ (_\ Ƕ  Z  \ \ \0    \  ƽk i   | \ JP \ tk\ A\ /6{  ֿQ  \   \  e,OZ_g 5/  }|\ BNF\   0 dHt\ \ R& \ \ ߴ?  W\ &\ g 
 ?Cěp   \ tS\ r  \ A   \ D\" 6  3   \ .\' \ \ \r  \0 \ H\ ~: .bd u` \ q+  \ \ \ w-\ w !@̼  \ [尙t \  \n\ / fzTBb \ \ S[\Z `\rx
 hK\ \ 
E]K ȴg; \ Ac |m4h\   ڻF\ 1 `\n?Ȁ[ (2࿨-S5e zD Ӑ\ E \ x  \0Dѧ\ \ .E  ּ  q] \ 0mغ3,\  \" ! S  \ ݴҍb\  \ \   ) ?q ?D 7* ʉat\ \ @!    \ \ 4CU\ n\\^v\ VT3!\  
\ yq|x  /\ \ Z\ b_ *\ Ϩȋ\ 	\ |N -qC-ͳ: \ l \ ?  _q \ ➦a \ntG BBm j; d \ \ J \ ܿ\ Z \ :\r \0#y \ ` <ڗ  \ ~ \ZX<\\ \0\    \ \  \0~Q8 g\ \Z  \0 \ \ \ \ o \ S& QZܥ <ǖ\ J 4{  y   \ fP<! (e  9  C +>~E 9\ $ p\ \ T -\ 6   R\ \ \    \"K\  _ w\  \ kp \Z\  \ A 9oA\ \ :  \ FOi 7 v  *6H}T  c9FO = Bg\ \Z =\ 9 { \  v < * Z\ \ 9 \ W - \ \ C۵&\  \ dd^ T\  ϻ܆-\    \ ]E ^\ W\ _  9 \0 \ \ \ ^ Ǘ&   \ s\ Q \  J\r j\ \n IKJ\  TZ?7=d$O -\ zfox`Hbgm%m\  Ԫ F\ \ \" 	mkX\ P ^ \ ߘ  \ ebv  + 8b ql2  -̼@n \  T(V \0 V>clZ\ :c Yl+\   鄦-˾\ TT14u\ 9
\ \ ڶ4=I` e\ T\ (\ Ρݴv\  \ ,  \"  \ r \ h 	T  \ k ټ\    <KT.E\\ U 0/1r  C  ,\ 1   ] \ \ \ r7\ ј\0  \  \  R\ \ @Z   \" & \  c\ \ ̫ \ >,(w`  \ 1\ w:TW LZ \  r)\ 
~ \ A=?K	  @A\ \ V* G^\ \ ;g [\r u\ \ Ǵ a)\ ׈  P  \ CUP\ -    \ H\ 3\ P\ ]ʧs옚\Z\  p c q\  zʸ 6n\"傃 %-|   9z\ 1r  \ 0Ϲ -\  \0 sZ\ \ \ \Zr\ 7  d         p9 Rf D5<ª \'쀑{?  \  Z \0$ a\  W ,/  dD\ \ \ a  N   8 \nsߩO\ 2\  \0\'  @  \ \ \ (4S \0 Cˑt  ̢\ \  #j=o ?2   \n \0\ n Mz2|     \ q  0^ \ \ _̿S\ +￙ Q }!  \ \ K\ \r&  J\ Xis7״ o\  @ wj m9~\ ?  m>\   m(s̱0V7\ U@W \ Hn nU\ K u  y z u ^      h T\ [ 
       \ G\ T \ S 4FQּ5{    \ k. \  C 2  J  U xu J\ \   \ L\  T} \  1, \ \ ~ b z\ Ū\ ?\ \ l V/\      7d [ \ \ e. FP ? 	 P   \ `̪\ 3  \'  \ p6 `4\  F\'S\ ;\ *\ \ TO;JRP > y{  4\ \ (  \ ] #y\ \ l u)ӫ %sN\ dըJ  a_s \0& \nCU r  t      ߘ(n\ 	 \ M EPp \'л m &`pzL \ usqF \n\n ^Z  h   G   /\ %v~TiT 0  \ R5 B \\Jg \0{\ \ D\   [U& B\ {\ \Z\\  	\ + 	N 9j1  \ eޠ \ \rEt kc k S ӭ@\ w(P   3/   \ YH1 ޣK   z˦	{\ .p &  [Q=\  \ J \\   \0 ?\  q\n\ ϒ\ v(\     \ ⿳/ z @ \    <\ wV=fy Ľ#\  O  {V  \ oSd sk\ \  \0 XC\ X@_t! \ #\ Mq#ҋ) c\ o\ \    K o\ / J\ x
Դ}a  7  j9e \ jm  ^ 5 \  \ E \ \ \ B?T\ N \ R[ ܱ 1@\ % 2 \ _h \ \n \ Ç;\ \ .S 1\ hy\"r X\ %hoN\ L  	 \ _K\ \ \ RdB 4  )K#\"\ /  \0 Ӭ 2\r9> \  _3P (S\ <D\ >\"o+ w \ 	 3hbJ \  3]  üR\ ǚhUu\ 6\  \ 3\   p \ \  B \ 9d  \0\ *1l-uQu%\ \ \ 鉲d  \ ^  e  ,\ vyZ 8,  z  GP \0[ =Ka@;   \ /  of  \ v\ _  @\  \ L\ q~ K\ \  ϫD3p  \ \  }\ \r ⼘ 5 v >U   \ w \ 5\  \ ! ~ \ M{9= \  Ñ 7 v\ \ 80 }KD \09\ ( xDQ   \0\ \r\  \   
 אI P|~ W{    ի \ 7Hɋ\ :04?Q \ > \ 6 \  \'\r\  \ \ l \ 3ձ ~  4   \ \ kQٸaE	 \n  $  T (\ \ .\ cWL- ?d )  %q\ Y #â\ Jj$\ O\"` \"-z@\" 6v\ \ ޱ\ (; % > ~rzD\ NAr 3)\ Ç\    o   C > _\ +K/ \ 5  \ Z/e 15 q\ , 6W\ \r ôn-\ \ {M` \ ae  G &d,Fė$ X\ K\ | t    {h     \   UJo0 \   h \0#4 X TW O\ {;2\ K /  a`rfؕ\ +\ ޔf]ڿD \0  E;T.QZ d\ Xa.WxWy 6 L * O2\  R *\ 6\ - A\ * L~ Z \ \ ;t \   \ \  \0eJTW\ 2@P5b|\ \  Ӭ  6f .\\\   X \ \ 7 \ ޫ   x : \ H Dw  \ % \ >c \\΁\  : [Ͻ\   kLz\    k^\"_   \ G\ U  hj\0x~\ \ ý,      Z  J   ǡE&  \  V wCʨ 4p\  D h> \ W\n/b jz   0[  w 2 \ 2 ҭ	 \0  =\ [\ 
I\ mdJ \ \ #  \ \  \0\  \  \ V\ f \ n	Ĩ Z\ ;z  \ m \0\ \ \ Z[S\ 8R\  @ i }ӫ~\ \  G  ޝ4T\ LVp_\  -b]`\ \         24¢\ \ r Բ   c\ 9\0Qv  |   W\ B  \ S[@ 1%d\ \ -\ 8\   \ \ A  r ь@G  \      ķ) L( \ | \ Y#l  \ c  [V1 9|Nv¶\ \ 3 }\ %\' \0  \ e      ewx  Br \ ]z/\ ->  \  Q  \ qI   \ ħ U    \ \  .S\ \"r^\'\ G -~̓\  JzC    \\  / 8`\ `\0 x  j, : 1 \ \ _\ r W\   \ U\ y 	R & \ \   .  Y\ Bڡ\ Į ܮ _f\r \  -\ [XfQ _yw ؉\ jlM`SJ?\ 5\ EP˗ywg\ #H\r k _ egu/f\ \ \ ݛM|+ @ N  Ä\ \ w  * /p 0
\ ވ; \ 4\ U  b	\ g  J
l\ 8A  W  s\ \ 24fl A\ ڨ- ɷ\ \ /  \     \'  ́ \ Q\ @E\ \ o <(n\ =  9un\nǰp\ ٻH	\0\ UV 	eR ʹZ \  \ q^  6Gׄ?1֫9\ ]\ q\ C } ,HiVO\ i \ r\ %I\ \ \ > \ \  X >\ \ } ] K ޜ  :n \ \   (Õ  R\ A\ \ T X\ e vG\ = ! \   1-	\  7 Q% \ ;\ . а\ bKk\ /\ _\ #\  \0 1 \0\ [\'  ;KE \ !  \ \ a| u\0t
\ nhO\ B     !  1ԷH	\ \ \ \ \  -5u; \0 o {\ ? Q< \  4   0 17 \ G HP\ \ \ m  \ =\ Ѯ\ Ywpo/\  \  *Ds T̃\ =\  JFO    t x   \  \ r\  \ ~  p\ h  > rb,6 Ǵ  \ \ ?d\ b	\ &|TZ\ i U   y \  \ ꟈ\ # e Q \ \";  r &\ AJ\ w\Z]   be  >\"ԍ	T   \Z\ \  ֡  #s@\ z.  U^` \ &[   \ t \ ޽DV^ \  ! ƓI0  r \ 3\ B[  \   q\ P\ \0  \0]\ ­   g\ R\ v P\n\ \ &+ q 1CB -B2 {\  qp\ f \ \  ha~~\ \ ^   \ \ 2ɲڢ(m3  \ \ Q0J \ M Dm5  \ \ \ h\ -   \ K ] \0D\Z \r\ U -OQo 01ب \ `\n\   0\ /먴t ~%\  e{ \ HA ?b e\ \\ sS8    u\ a   <  \ xrG   ,\  I- \ DH ș l\ aܶ  i1.  \ \ \  S\'\ \  	 Q\ X{0CR\   \n\ \    \ 1 \ R	   Z ܸ@:@\ 9B i  	v Y\ \ 9  %\  \ UV\ i\ \ P ZF  Ԭ\ >R    -PH4enX\  s! .4ƞ wRsDA \ I 0\ T\ k :q\ ŗ   \ \   #\  p\  C\ \ e@{\ 6\ Xz wK =e͑ ?p2 h   LUcw Zs\ \ \ \ Wf*\ ]\ pr aLz  \ \ .\  \0~\  r=wm  \ < \ D2F  \ J C7p{ \ ʨfQ>  \ \ o \0 w  \ K^1 *p<G#\ t\ \  ɤ \  e)UV ň 4 \ i* nZł\07
UY\ \  @\ \ Q  t \ 	 Vv ]ap\ to BT98  Ѹ8۵W  1@ \ \" E[,5ͳ\ *+ ʸ0\ j b    D   \   +  Z x#e q\ u L / \ \ \0\ \ U\   NjU* e \  -tz   8 %ކX\  A\ ^  \ 1j\ 2[v\"o\ 8 z}Z ՗ P   /v\ 6  ) \ -\ DT q  M 	 ՅF\ ;C<27\ \  C\ :tT\ \" \\ ˮD 6!    \ +  \r\ \ +g̂ ?s\0\ B  V   p \ 2֗/1~N \  #e ^HW \ \  d \ ;a \ R \n\ \\R\  2\    
%ZΉ  ļ   Z  ϭ\ \ q9 GF sQ \ gq \ *  qp\ &] k\ f  \ )    \   {\ \ a \ =\ gm\ - F !te\   \r\ \  z   Љ{ &! i\ 7\ s_p  \ K i H  җW\ j\ a O$\ ԧN aPW 8 \ \'\ ˨\   (\\\ C Pm\  ] \ ll   aC\ \ Y Vciw\  \ \ \ \ D   \ \ ԣg\ \ v\  \ \ 5#,QbwDU	J~\ D \ F \r
 f  D \ 2 W\ ]   ]Q\ e\ !ׄ8 +\ \nf;\ * _԰P	  :  [R ޱ\ =\ \ 
 \ IGU qjǁ[u6U ;\ t  \ te  \ \  \0r  JJ u    j\ \ (  0;\  5   C) \ \ \'S2\  \ 5P; !/6 \ =  {]G e\0W \ z\ \ _1XÓ6^᪍ FӬҩ X  Za\  ˉ\  \ \ \  L  \ #\ \ = P2   2\ D\ ; \0YU   D 3k\"$bYhz\ s \ +      q o ң \ ȼAP   \ S6봾 ᘭ \Zİ\ X 0VTZy&n   \  \rz     * \'R+  s \Z&֗ \ 7 jԍt \ E K\ Zz\r  e \ \ \  \ Un@T#D u  ( B A\  \  a1,\ pήX\"X \ y\ 0e6P @ K  w2 C\  .P\  .\ 2\ \    (sޚ 1}\\b r \   n e, \ l\  m g fKFۀKB @vK\no  \ \ 9r{\ N2Ŭ\ 2 ڱ v \ p`0\   \Z\ 3\ \0\ 1jwYP   \ !\ \     / \ ]au  \    \ Z \ P \ \\jRY \ \ \ d  \'M  vU\ ?RރV# ܺW  \ \ 	L\ x\ wd B9 \ E 6s*Z  m p\ @\ ڙ\ P    h 2\ 0p {e _ l)  \  \ k,$  \  ]\ \Z \ & \    |E tS a  ͝\ 9Ԫ\ D\ qFZ * AP 1(= M\ \ n; \ ^#C3`=cV ⤬Uq}%\ \ \ \ \r \ TaP j \ \rl\ 1  * \\\ k2ױb   Hx&\   5kX-\ ]`r\ 	et     lٕ+ \ \ Rؚ3p h\   ؗ-LH :JSoVRC yb\ \ LU7 / 0U\0\ \ u\ %WR ~\ 2\ \ [  / b! Be o \ 5 j! \ZP \  \ q; K\  \n X \'(] L Y~\ =   #1   \ J \ZƋ\ EK \ \   \ ew S\ 3K̰ \ H  :\  \ \ \ t L\ \ \n~  T *f \0\ O\ ߘꥄE<Ff  \ \ \Z   1/  O \0\ L\ rǬ o5)Q4dte\ 	פ\ D\Z\ = \0s\n \ $.  `(+\ , 
  \ (Z\  ޥ  \'Ki\ =.  瘡qh  å\ \ ?Ȋ%@:  K Θ \0 \ ř \ .\ \ T \   \ *- 8W  bYw\ k\\ ,\ j 6 u 0\n  X\ ̹[ L\ f\ jB 0Z L \ \ ȼfR\   \ i !\ \ +x  1W  yu( eV∃+  ځ\  D Yh2   X-\ \"\   i\ Y\ [ _1X*   `s\ b\  Aq\ m i  )% Y Ҿ  }&T3Bz\ ] `\"T D \ Y!\r&`1\ 	\0=  tBK ˾ \\    D +\'   \ Vm_\  J;\ V  Jy x HW \ Q6] -A3\04A    %M 0L  =\ ˙8|\ B  
o  * & 1\ *\   WN\ vۖ[]\" \ \ e   ѧ9   eDhms.\ f    \  \ %2 @\  E\ L\ P\ Z   \ 2\ \ \ z̑ \ n6 ڈW \"V\ \ \ \ ^\"\ Ir  r \0   %   U R   \ <@  a N %   \\\ 0 \     DpŠ\ @  ay i 2慚    1 3  .\' \ $  Ne;Y\ +1w<   q\ \ -  oP  Դ I Lਪ\ \  \ % \ q   \ \ /h \0\  \ Y % Z\ 	  \  B  `\ \ ( \ M\rE\ \ 7X t P   \ U+: 4\ [ 2pʧ N  S( -\ 򃸤U\ Ś !C |  \ T f\ oy@ \ D\ @\ zCV ] 9  H A ˘X j+ \ 4I]E  |\ \ ;	*\ D    \'t\Z\ \ \r\ Ȓ]cg 5E \ #   [\ 5EM[ mĈ\ S}\  ћ s
z  Κ b> H\ E P.k0\ eD   ,\"\ ^ M0\ ` \ \ F\ \ \ %\ q  \ \ y  4	\ b\ K  \ _ 5( \ 8j \ ` ݄Jق  O H\ GH ?pp c   r 2  , m I@  E \ Zʵ\ 9 \ u D ,ۭ 7\0b  \ -o     ԝ   x  \ }]n>Q\n   \ X\" \ I zK\ \ P #\ k \ Lk E\\   \ 9v\ \ _9T Ck #*   Y]\0ɦ\ \\A  ?r\ +\ 08 \0 Ku/f\  x       Tȝe ۬\ v਽\ %  Q \ Yw\ vH\ \ ҉\ 2  2 _ kS\ \n n\ w\ 
-\   Nnbv\ \ b\0 n   \ %\   \ \ \ 8 Vږt\"4\ *  8 \ Y  cpW\ xDM ׅ E a \ !\ g \Z :  me x   Нi@   , \ 2 \ \0  j\ }X  T pTDj  Ot\ 	е feS ь K tW Z\\: - > kx5@n\ZPz\ j Զ u   hH LX  \ \  *X\ C %\0r L I8\ \ 0 ˟\ U !\ \"  ʵ+ \ ;J  Y  \ -=c T \ \0u  \ 	{\ \0  \ S fkq ̶{Me\ \\n\ f qL,o  C      
9\  1lr  D\ \Z&  ܖ\  \ v \ U 1\ .\ \ e-qL\ h1 a >    |Arе_\n d  ɯX\n %&p \  @\ H6\  y\ @[\ 6⚸: \ \ \0j *\0\   A  \ \ Q W  k, kEDWЋ  V\ \ v &  \ # \0m\ y EC\" ʥ\ ïRTM    \ %\ `\ \ \ Q R\ R \ \ b	op\n\ q\ Q(al   Q\nX\ Q \ EpM\\ s  =\  \ 3  (       Ϊ x  \ \  zB  \ mP텳S\ \ [  >v\ >d % Z=f _iMv!mkXWH[ = B5z\ \ Y \   7 .ZZDQ  yq \ /\ Qn \  \0`oA \ d@5+p   x\ -o؋0 @P\ \\\r\  \ A b\ ` h \   \ Jt K5\0\ (\ \"\ \ i B \rn  < 8 5
,׎% 8 ) 4 f\ q  mj5`n* d y%   U \  E# \n   \ \ \ 1 \ \'	Yθ   \  s-\ + \n CZ3| rr  \0 F	1soW2\ e\ e\Z Aj_\ \ Od(b\\,G U\ qU\ Q \ 	pv\n\ \ ª T[ j\ f&+     \    w0\  %  \ \ . ex	T7 * \ @    (\ \0  {o\ 27\ <\ \ \   :\ ha9    \ @ǚ ź\ |  \ k   Q \\  ʆ _ \ \  =.
 \ H\ |3    _\ 30-  c )\ u\ \ f\ _0   c08\ ( vC-\ \ L y\ -+  [InX  \0f  \ \Z(\ RX rv `\  \ 8}&Xw !o q vs\ 9\ \ u\ Q5Q@\ \  \ \  ҳ ֏w >\ /l \\  P\   \r\  u `,\\3  \ \"S \   !\   \' X\" qsq]     \   b{G   I \  A\ \  wD9 \ \ Z )ql\ rEn Equ ^2\ \\\ \ 2 \n  Z\\\ sQ ^b ]B ! \ h\ $    w \r \ \ \ \ i     B^eL/1\ f6 t. -iR[ \"  KĽJ   .\ \"\ \ VwE8%⠲ \ $ `]b  \    \ , ,*7pS\ :  q\ \  \ \ \ ꨋ \ {Ķ  \ M   \ \ ;  <\ \ U.V\\  DO J- \n\ _0\\	\ cdk. \\ a!t\  % 	\\:H`t >e\ 1\ 2\ > \ \n  aD    h   +2 s\r Z\ .u F  8\ 4@\ \ W*  (\ ,S 9     <A SĲ  \ \ ),f&oH WMA  \     \ \  \ R\r@  \ d7 B o0 )  b\r >\'٘h <\ Yw8 |\ ]JU\ \  \  {C\ l 0\ *\ 5\nL\ \ c F _nan  \n L F e \ 3 \ Ȁt\  
n\n   xD  ܽ[{\ ţ\ 1?( \ F B8Y    \ \ b  \'   \ \   \ \ (/Y 0\r    6\ W/  b\ <-\ /\ \ 0 `\   N  DwY\ * X\ SL \ Uº g*VX \ fڸU1 i  q \ ݚ bߙ 1\ A\ \ >٥\ 3K C *\ ZY\ .\ w\    V\      \ س-@W 圷 I °.  F,\ n OB  \ G ?\ 3 ^  5    v .\\ \ E\ C Dx   \ q]K B     \ \ y v f `\ P#\ ?p+*EW   7l \ \ s \ SSka]b   
 @:T\0 u   \ \ s 1p \"\ K -C\n\ \ ȭ!z6  U E !lKx    nf=D 1  B t \ a:~   \ = \ \ 7\0Wؕ\ \ zB ŕ  .< \Z\ \ t&	Q x\   \ q() @ KW    R  qU2  r\ `\ \ \ ̬C_@u 2n 1  I {\ \ 9  q *\ B-\ \ <   \ L
- 
\r rǭ     GbjN7   
 \ W    \ u \ s  p  \ N\ bv H  e\n\' k\ \ \ T\ZRgm \ q8 \ \ a )[ wͲ  q\ } [\  /QQ ) \ E  s
 J!K` U =l\ 5 q   [ Z \ =H~ οܥ \  ({Ct\ !\ }Ĵe]\ \ 2Sz\\`$\ \'-@R b. 0 zK?dr\Z 8N \  \\*Tq *\n\ l w5pٶ8  T2ڪ&\ r\ kr ~෉@    \ q. opeb#1^C\ \ \  bf& Lo#s0N G_H\ \\y 9 \ 1\0`p@ַYH <\ Zz\   1 K ZzN 9 XK 1Y% B.n^ \ % iu\ ԩ   \ #  x}	 \ AA\ F8   T\0e\')=\  %. NQT  @߉\  hv\" qd.\\ w 1(  ͙X    8H( J  1 X\ 2  L    < §ɋ\ \ 1 dܧ\ Zf:6  Iwv\ _L ӹ\ w \  L9 
\ \'=!ŧ 6\ P\ J\ wK	j\ *\ %b^*o k j \   r\'i.*^\ WI\ \ Ϭ\ g\n  \" 7t U0諎ti  2  \ \\\ + Բ\ \ e  +TJxf/:v \r   x\Z5  L  \ \Z   +\ p0  g/0 J   0!R \  Q\ Q L \ \0\ J 1;,W\ \' ix -\   Y \ Q ; 4 (U  %Bm  Ĺ  5\"Y ؍ e \ X  \\\ Ao  ]L   5\ *\ -\  \ \ 1j\ i\ 8 p%K\'0 jPc \'\0  ȡE W=%-  7(\ >  @h Q p \ \ % Vr %  W1! P v w ^+(\n F\ 8\ \ ՛>\ ʽJƀ \ 8 H \0 -\ Ax 9&Q\ F 8  \ ΉWly 	\ \ ;\\ E\ mBDSu \   b=\ K20\ .7 {\ M7;K \ \ j \ D  \ ]H\ RF h \n  \ \ \ c  :\ \ \ \ \ V  b+y n{ \ d0W2\ u  +u \ Y  D \ |C 1\  \ / S 2S)  d\ \ \ i  o\' V \ ^\"  bsı\ ۙ  m  U  \r   \ H  n  n[ \  e\   P G  
   } ̴Pĺ   \   %3  N \ I7j  (\ Iu \ vF n @@g\ dc ~ 1s\ \ \'	E}خ\ ) \ 0\n˾\ ҝ \ >ġ\ W PK e b4\ 6njq 8d   ږ/ed \ / \ \n :\ \ YF:\ \ !  \ . (   Z;A(}`  y\ \ \ 	DKĲČ( \ j\ \'   gY  Wbs  fw  _HԆc\ \\\  \ #\ ⰶ\  <@[$ \ N! Ɉ 7* /  \ R- R  f s z  \ -I Ӕfq P&E\ \ &\r\'0  q# \ U,qAȊ-\nE)OivnX0\ .\ ǈ\ e T\ lZ |K  p \ fqq_  f ] \ ,9\  \ R \ \ \ ,  C c s;jnԧ ,g2\ \ 2S.ʣ/  \ 6fi
\ |rBB    V 	M\  J\ \  y\'H    S, \ ]D   γ-i   z\   \ \\O\Z\ \ 8  8 u\ 50`|\ \ ^eR ^ ; \ %  \ F\ Z  Й .! F  \ \ B [ q\0E  \0W \0I \Z V~\ v\  `]_;   @)  V\ HV } ܴ\ u\ \ ƣU  ܿRR  \ \ A\ I膮 / \ Φ3  \ C&  \ \ x\Z \rC q`
  E  X: 5 K  /  Z \ \ \  49  W\ \ \ 1 ]\ ΄』 /f \ [\0a \ !\ In\ \ . {   ~# \ B *\ D\ z   xg&b	\ Ҙ\ r d\ \n: @ \' 	(3 Ep IB	[ X  \ E {O]\ 4e    \ K
CYrࣼܟ1M )\   \0fۗ q3Fe\  bJG$ \  9\ E j TZ\ b V %t\ !{  q\ Ļ e\ \ POrXҕ\ \0 w  0 ah\ `\ S\\G8Ǻ &  -Ի\ !^X5\ \ T w  = \ d;>bKގW B\ \" w ݱ \ \ g\ \n\ u\ 5\ c \ 90+c \ 7   u.Tc @zTp L  \ \ 5\ PM g&m\ 
 s\0- \ ( op\ @qR\ lz\ J J, \ \ u2\ \ \ \\\ \ E \ t Vpq,Ր \\\ W  0kP+  &K   aۘay a` \ d\   s i  j\\{ 
fr a MA e.  L\ n\ #D6BE \ 2 z\  4S \\ \ ī>\ G j=   @\ \  A \Z   A&\    \ \ oj %b\ ʽ\\M    q  \ z  :\0 :  sX[~\ D%Th\ _f` o  a [ I\ 2N\ n]\ 2 \\B V // V  6 ݻ 
Ժ4Ki   ؊
  \ #  \ ,\ \ \ 5t\ X 9 k  \  J\ \ U=%=Z\ \ 	y\ d FW2\ \" c ]\ .\ \ mE   8J \ Dܺ \    	, A b\ z@ {\ ,v    p4\ P\ \ R2zf ]\ \ Z   A\ z\ qg\ (
 /=\ L  (\Z\ H \ \ ,  z½\ ˨   \ ^:ʂ  b\ \ ^\r   y p1֠h\  q s\ \n5(g\ q7 k v8 w 
\ A 7\ ` jP  \ \ \ M\   \ \ .!  R\ ` \n  0P cĤO1(\ \ \ \ \ \ }gJf1ۤT0\ *[ \ ,\ y   \ \ \ \ J    Cט! d n \ Lp  B1 &[A *rM     Y\  # n r0A f+   v   \ Ll 迨hR\ lK0\ L6\ 9\   ?ʳ\ 5\n/f\    1,  ɒr s\0 .  TEQu y$J\ mHGc d   yP\  \ s0&v   \ .\0r z \ e  ̊ \ i \ \ \ Ž\ ^  \ r\ \ U\']#`\ 1 \ ! ̋   \0Ŏ}&\n  -\ &HT p   1  e5\n\ \ yu\n  \ X \ ģ 婅V %\ \ Gi X4\ p  p   & \Z\\  w 2È\n    1    lA5\ \ e׶t ܄  ; \ `rꤛ  Vɗ\ W  1 爝 ^&\ á X Z&{\ l r a} E\ W  \0P6 \ [9 uV \ \ \ 
Y \ \ *\ &ǧԺ \ 2e  u      \ \ `\ ܮ  380 \  #	Z\ \ ߈$ WJ똛 \0sq \ ޹! \  \ \ !    )  n3  KX.#\ j\ \ \ \ \ ?3\ \ )Z[ \n`A(0J UGS  \ [ g  !.\ h\ 04^= &36  Ռ\ s.\ \ b4 \ \ ?1WX \ Z gs   c*  `  \ 6m\ [\ ܋\ %d  2  zD c   \ DF     ?B   P \ pc\ 1M\ \ y   7\ \  \ \Z\ lٜE <\  bk\ l !  1\ ) kU   3 f h \ b\ 
 0T  K
#5p	q$    \ q Q]\ 5  m  E3 \ k\ ,bts+avE  \ \ \ ,D\ B [\ %  \n\ ,\ X\ \ l<;  \  \0\   mˠ  \ \ j5    Z \ {H%,\  \ U  %\\U+ [+ \ g2  ( hv * a 9  \ f \ p){  \ l r\ \ hy\ )y Ib	L\ rJ\ \0 5]&   D4gU ! \ :\ VL   5)d T;˭s\rj/hZ\ \ \0^\ jۂqLA\r\ oT\n\ h   k\Z ?  Q\Z V ?0e % -\0\  a Z |CU@\    	e)\    h\ \Z H Y\ ľy H  J \ 8!\ d @ u3p J 5Q   \r̓ f3.,n:b ` \0\ K j!+w Y  8 VX9 \ \r m  ԃ\ 9  L͗Z  \ ..] qSL @ ˮ  \0Ģ   d˴	 R( \ Dn]H/\'H\ u  [ Qw+~ ٬@ \ F\ %q%\ \ \ \ n=\ 0 #S  &sr   \ [ Y!\   )  P\  ]\ \ l\ ̕\Z n\ 2 R\ \   \ @ 5\Z\ @\ \  \ 6 _\ ? e?U \ \ \   lpq-M\ A   U    )6j\ > 4  \ )\ \ tݔ由 ]       \ 7\ Q  \ \ Vƈg+s  \  Cr \ W nZ0  .  \ @ ] r    e[l\ 1V  \ r\ Sn\ =\  ] \ ^ \ z   ^  ϼ 2JV\  \ j\r # \ ,h: Dt @C\  +\ ) ]\ Iuu7 \ 5 b C   P \Z \ \ :\ \ (\  (  Y   ʄf K q.L\ s     \n  A\nf<.ӌ T8 T   \r狀\ 3]\ u k3m    \ \ \ ) ^   >!  f. r  ěX\ Z \ V) \Zy\ (yn^\\\   V    \ \  \ \08\ \0]g \ \ \ \ [2^IC6  \'S \ru   \ \ P  X ة 
o @\ 3Cj\n\Z|@ iN +\r\ @\ KOIA{ sh  \r\ (60     \  
h 6ˣ \ \ \ ßy nXb\ +8\ \ эXS\ F8`Y  q\ -. -   B  L   \r  Y n%@1 \  1 ! e+  \ % u\nK|\ ^  M ˡk U 5s8  \ Z\ s-K\ 9eg2 US   \ I   jg	  \ \ WD ] e\r\ 0\ >   m\  jm ! \'I %\ *d. Qi* a` LK B\ b ]\ ivӸ cQq i԰Έ o Ĕp ]   =wr\ JӜ̸   <%\ o  `9\ X  D\ : Q   ApC   \ Fa  jg\ p\ \ GYa f \ OGir ЕA  `  Z!q5\ \  \  r  \ \ 
Oyn\ u d>aU\n-Gy  % \  c8L\ cr\ 09\ Gx.\ 2\ T.Y: 
  \ \ .ˇ \ ݔCm f \ \ !n \ )7\ mZ\ & }q \ =  #  8  \ e 8\"\ I\  \   H \   ( ⨌  i ٜJ \ \Z b  #R c   \ 	j z\ \r\    X M32\ \ \ R0n /   >e   \0\ b \ D  :\   3   ׭K:     \ չ \ =`\ \ \ %  \ 9  Q  f\'\ 
^    \ \ R\ C  n\r+ [b  \ L7S$\r\ m \ W \ $ \  y\ V^\ NN \ 0Eq][  U\ t̅nZ՘ \ d \\rf\ h;  GF     /=	te P UA\ \ m \      %  / \Z3 P\ a  Q \ d1 4- YhR@q2.U@ =!)Hzb (\ \0 P 5ԇR\ ՗   Ó0* \" o5G1\ (5     w E   [w  Aplj\ `9\ - {\ \ ,\ Ԃ\ ȶgw+q\r e \ P\Z \ \ * 74  c (*\ x%5 % \  \ 3z\ M}\  Bm  \  \  Ȍ!  U\0\  A %   n\ \ \ 	\ 5    \ \ \ 8N  ,\ E    \ q   9  M ~b$t 0B    +  [p ]  i\ \ 2 \ Y X VA \ `e\ ngg3x U\ X\  +\ \05 `\ ; \Zy ( \nR  FYek   1J\ Ƶ@\\B  x ]  E.1\  N   \ d \ }L)x\    e\ \ \ \ ! \ n*;6+jx ssc]s    0\ \ a\\ ` \  0\ K  \ v<D\r  XC\ 1\ \r O\  \'k}e\ \  s(L笱}j^4 \ \  \ f\ \ G}\  C3f5(Pc\\\ZA|\ `Z \'F-
P   Q R\ Ƹ   \ &^2\ TbU ]u    gJ \ b\ *j4   \ j8\"&\ \ EK X \ QR  \ ^fs DU)+2 ❺\ x  \ \ )u\ \r6  Q;\ Aۉ \ 6\ X\  \ Ẁ \ 4pbg    b^8    {V%  \ BP     \ x \ AH     \ TMO\ M8\ ~\ \ \ Jtсf \ \r% XZhq
ဤÈ1s\   \\6 \ \0 \ \ n B\    w o 8y qɸ; P \ E@ 36\ Pڞ\0  x-F\0 sD$\Z/3Tq\ @ _ CU a \ry  z@Ϟ%
 x \ \ 1;\ @  4\ 
\ \0^{\ \ \ Wy= \ \ e   DS \n5\ \0eql` v  Bf^Z\ 2\ dy \r   \Z\ \ 2b  8 auU(xa \ q iQ\ 71\ o 2\ 8 C? 6s\r*\r Ԥ]; kW4\ yX  \ .   ĭ \ \ p       \ \ Wr  _  0[ǈ \Z\ J    \ kQ
\  Я? nXZ L\'*    ` m\ 2 Z  GgiZ Gx	   y ˼F    \ ; \ \ \\   \ \ r \   \ \   X
ee  \n]\ %  \n   ;\ Ds}bB M [\  \ P \ |Cl h#Rʉ/ \ \ Q LǠ \ .d\ g/3 D\ \ +#G \ 9# BR z7\ ;o  \0 05dHG&\ _ ħH m b͠\ 1* \ \'4 8  Ĭ,:͛ $\ F&M\    [/  \0F  \ A  <\ ~ Pݎ2|@\ S\ P H, 2  \ +⣚j     F  	\ ˫<D:y  Vy V 9 ^\ Q
 gjB )] m\ ni\ \"<8 ~\ W  7 \ m`  \ \n  Rb\ \ *-\ F \ \ \ :G\ \ 
 O AC  \ r CD	  \  !mu\     \ , q/\ YsX\ DPA  k   \ $ E   [  /n e \ t Uc6\ \ \\ \ +)% X uT n\ \nju  ~ \ C\ kQ (\ \ u \ M QP g \ 
P͵ ᆢ\ q;72,Ej \ \ T J[< *\ Ui ɦ#k\ 0q  y   0Ѫ Ķ nU k Y9c\Z\ C   \ p\ Rt  \ 3Hɷ   
\ $  K 3  \   
U\ XW-A=fwq-   \"t B \ \ H\ KF) _  f\ NS \'\' fP\ P F!    a\ %  5  O    \\lF\0K;\  z   3 xR #Cr  k+q     W) 3\ ဌm  \ ϙ \ '),(3,'Cancha Fútbol 1','Cancha de fútbol 7 con césped sintético',3,4,'987654321','07:00:00','21:00:00',_binary ' \  \ \0JFIF\0\0\0\0\0\0 \ \0C\0
		 		 				
						
	




\r\r%\Z%))%756\Z*2>-)0;! \ \0C 
	


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  \0\0 \0 \"\0 \ \0\0\0\0\0\0\0\0\0\0\0\0\0\0  \ \0C\0\0\0\0!1A\"Qaq    #2B Rr\ \  3    $CSb4ct  \  \ \0\Z\0\0\0\0\0\0\0\0\0\0 \ \0/\0\0\0\0\0\0\0\0!1\"AQa    \ Rq\  #2B  \ \0\0\0?\0׃ W L+    Ug\    \ L\ SMK([ \0\ y  -/ Λ  O\ 2\ m v\ U  R \ W G  Mj\ 
   L\ W  `\   驦 `\   驦 `\   cʦ *X S Λ   $\Z 4\ 54\ \n    i \ \ @$ TA i \ @\'  7MQZ  U \ M\ Ψ ,\n    ⦚X9) \ T `׍\ ^ a]ϭ^ \ e   n  jY\ \ \ * \ \ }\ J 5\ Թ  -3MXZ f i      X   n  i`V  i ji  Zji \  \ K+MV n  i`N  i\ j \   5Zi\ |  \   54ӊ\   j \  Е  :j Ӵ\  eV M;MQZX \ Jf \ J Ci]\ ^ =; Z-5\ \ н5zi j Ա@\ \ \ ˓ \"  { Fs   M  {KqZj Ѻ G\  \\ 	  WV6\ ($|+- \ d. ¡ U  H   y\ s AFՏ\ W     ՙ ZEM4\ 54\ \ B \ i i   J   v  R\ \n\ U     X :j Ӵ\ \ K\'MV v  5lP 5Zi\ j \ P :j ӊ\  b   \ N+Ψ ,P  %i\ hJ\ P :yT \ \ T b  \  ՁE \ X \' v\ V\rXZ ( k\ZJa \ \ ֫M:   w~U⑞\ Q\ \r41 ｾ  C\Z      \ lV*b    k%
\ ^ <T\ 5   )   k+4\ 1W k+MLSqU k& Zji \ M5 \" \ i b  B b M7DSP\ +MV iDU\ (QZ \ (H  P  %iء\"  Bt\ *S1  ME\ n[ \ \ 7\n5 \  . \'Q \   +$7V f\ uh \ \ \ r\\ N \ -   7   \ K \ \ b@   #Бﮥ {HZ\ .Vi\ f% ; 4\0   \ _   | cL%\ = w0HHV=\ lH +   y\  K32\ : %Fw\ ~  x\ Ƨ$  \ \ \ Ƶ`9 \ \ \ \0 1  I\'[K6I  T󘨏
 =\   \ o A\ \ \ \"^ fπ\ N  \ 8b T X\ a \ ,g G/\n N[kn#f  \ ׼ + b3 :\  \ 7}  I\ ;x X\ 5* \r8$lw=+q\ M*\'   \ \ 	 cbq \ ; m E\ \ \ k\ \ \ \ $ \ - \ \ C   \ 66;\ \ κ  \ s2    Q  U\ fā \ \ \ z|w\ v   \ \ IW^==  IY * p\n\ C \ \ C \ ; \     X  K @#r\ 2 R	\ y   \ Ƭ\  g گj\ /ͪ} ݖ\ \ 﫵U    rpq .N\'\Z  f4BڊȊwӱ;s  qf Y\ \ \ ګj \ \ f c2ʒ $\ chLj   L \ =zr _i  d\\  U J(\\ \ d  \  0 \ .    
)%\ k\n  L  p \ עHQ @\ .J H\ N ƹ\ \ \\\\\ j \ FK\n \0    y  r   }y \ o \ x    ēۃч Ml{.\ \  IU \ Ah ۺ \r   +  \ `e\ ycs N+\ p)  *vzU \ Bͦ2  Ҹ\'} \  \ \ k AM v  =  #@\ :\ ^ gp     \ \ - K\  ZD    %c\'    \  { .Z  j*\ \  \ 	 \ \ Ҽ\ \ /    1\ A c\ \ \ K\' ?\Z} \  N\ ܆\nQ  N q\"FT \ \ \  !,   G K \ [C2 sI;\ \ZUY \  \0\ /\Zۊ \ 0\  \ N  bK\ )=\  ̏N ۷   \ \ ( u\   P D  kׇ M\ g \ \ cm.i  U\ #Vu K s\ G g  ٪H\ * P@ :um [c?ʼ \ ~%(GDX \ E0\0    }q \ 5 3\ \ \  u+ a\ M    $ R X   aδ\ ] xZn\ ʯ-dū  .    \ Z   f U\\!Ǥ ɢܦ bu2   WO  \'Ţ x Ĉꣵ\ u 7 `\Z\ \ %ٝ\ E\  _߁  *I \ \ 4)e   	  \ \'\ j\ k=\ ݥ\ \ ۄ # +0% m \ \ =qO;\Z f|     \r=EJ\ \ \ \ 8 B,J 3  `[)\0Ԭy\  Y\ \ \ 3_SΟgm \ v\ n\ 
omo #b~\ % \r   ? y \ x  \ C,I +g# \ Ʒ5g     4\   n\ \ C\Zj\\\ Ǟ}\  \ ,j Ŗݡ\ I\ leY \  ?}|\ cǩ\ -\  yF f \ o`-\  q9\ \ , c\ \ \ \ $C \rϰ nm ⲿl  H ]) `I\ \ N\   ]\ U乐\" ( i# t=\ \ B \ \ I\   \ I    \ \ D&\ W\ \ |돉ҕnu W W\ ƾ\ :   & \ -wCd \ \ \ \  \ \ 1  W \ -c y `O    E\ - a  $CP [8   |\ h l k s+ f QadH!v\' \ w\ O \ cQ Y. _\     	\"\ H\0 e!  `t\ v\"_\ |c F O\n\ 1C\" H \ F 2 	#9\ g k>\ ̢Ap rY.t\ pr   \ \ qY \ L < L\  % \ #,q  \ H  \ K\ m  Ճ W\ \  <r =q\ Ìc\ \ \ $\ =H8 \ \  `\ \  \ \ \ \   6\ \ e܀\ \ 1g\  z \ # !- A\' N\ H;\ =\ \ \ rY\ ј\ y \ mΟ_  o_\n j  _C\Z #\ ).# A	 p\ %y  `\ ҵ\    KW \\c 3\"  (A`r ہ    \0ĳ ź \   { x   \0  q m\0\ ?\ \ \ ӥs\ \ Mx+   6 ;\ \\  \ ` x\ \ # r  \ \ {Ze\0Ai#.  ] z	\ $i~ .    `  9\ 1 tK\ G    \  s \ \ oZ]   e\ az ۞sll  :/- Gn\ ɇ h\ a \0   *\  î 0 X\ %%     `  s\ + x  ^\ D/&  3\ 9# de \  \ \ A\ ⁑\ \ \ FԤ\ I E\ \ { *Nqk N x\ q   \ w   \  $\ C \ ,q\ \ nǰV*\ \Z \ o\ Ͽ  l\Z t [ ذ% DX\ DNH98ڸ\ \ ۢ  g l3  f   R \ b,Ib$Wc\0\ +\ [(\ \  :\ 1\   \ ֋7 \ \ M4Q r\"d]LA8έ ? \ y#  \ \r\  \0 \ Oa\Zc# \ \  #9ϟO Ӌ\ \ \ 8   \rޝZƢw烱\ H%]\ \ U  iٌ  JA\Z ys# tS\ IḎ (  \ Lwk$V\ A  T+̳  ƻ ĥ5  \ Z	{8Ւ7  82 g a\ *}\ Ȏ\ \ f b&\     ف\ K   1 3\ >uӥ;G  y\ 	     \\1c$*F @@P\ 埍c \ t ߳\ 41 WFR\ # G   ̌4\ {\  x[%;    \"0 \ \ ._  \Z\ m \ ]A \ &\\,Q ` 2c 2\ p)   \ \ \ I ]ŗK,  [nx&     @ڔ $ !I \ \0]\ q\   \ \ a  \ 2ߓZ \\ \  2\ T \ d `gc  \n 
  \  \\\ w !^vN pdö +\ v -nT\ ˣ    K  \ rn  Z-\ \ \ 4c   YWKL \ DYF\\g8\ \ \ X v=q  \ \ qif ͯ\r e  (    6   \\\ -xܱp\ \ ͪ;\ \ \ +bL7v\ \ \ w\ =+ - Qb  ׹o tr  i  `\r  \ 讱 \ \  \ p   X]d63 \ \ A\ \ ~\ \  \ =\    n\ \ T1s!Ʀ  ^e\ \ \ Ì D\ f  ķf F\ \'#|  c;\  qE\ v?T\ \ \ (23  祝 \ sg \Z \ \ W   +W\\榡  \0:\  g\ \ j z M$H< \0ޏZ    T p\ \ ?s(= 0>U;L\    \ V^\ t\ ί  R\ m u\    \06  ? f\ [ J \ \ \ ~U   [   \ \    [dc¡f\ ~k\ x   j u ` \ W \ \'\ Af q~\  \0  ] _ ?w?QYs  }Fja 23\ a \ ,/\ \ \ B9> / \0Ъw !{1   E  \0Q | l\ s\ ?J x   \ , 
x\ \ U  _ G {\  W\ 9z6>&  , <\ (KH:\ \ * \ ˺  ~  Co \\zf  @} 2\ {d\' H>t`   F\  k{wIٲ *U@ b b  =   1   m \ =~m  5z    \  &\ ~φ   \ \ T^\ =\ $x   \0\   d  g\ SPQ ;z  Z d*	8\ \r\'\ \  ,<3 \   \\\ \ \  ŮP  \"l\ \  $  qst ˊ\  \ uAdΝf 0  و \ A?\n \ 
$ z D % \ 8v(4탒   \ pmf  \ h  IY  G\  6h c  5D   #  r\ \ <\ Z\ \  Xy4\ JL \ \ {M@HW C\0A\ ;  \ l.n  v u2۱ \ F -\    \ 7ٞ: \  nw \0 \ \ 6o P -  \  \ eF?\ I \ 0\0 \ e \ W 햏\ ,v \0 \r \ ^\ \ \ \ - pau \02d|\ A 2  $  \\ ,     T r)\ l  \ \ (\ i\ R \ [\ Y (Ns  gs ҈\ \ o\   ; V  H\ \ \ \ ]GʌMd x$ 8\ 9bq\ \ O  \n^   =4A\ f\ ژ )    \'|)   l\  \0\   \ t 4   A
r   \r 4 ]> DduQ\ vQW  ^> - R 8\ p78&E `oW \   \ \ \ X ^ b1   / 5; ` O> c\   <n[|` \n \Z @\ v\ -\ \   ]  GQ?3D \ZWa\ \ \   \ l\  Fjk \Z   9 \ %   o\ ߠެ¸\ q \ O\   F\ \  U\ | 	 \ 5E ?   F~?:  hQ\ I i\Z\ >     /Ѝ  4? \0 j ߟ O𥓌j\ \ ̚  \  Б\ \ z Ka\  ؝ ʁ   \ .GoL\ \ \ yoM ;\ [\n9 }\   w T  V$\ o s \nǒ    .| _ o \Zg\0 \n i \ \ \  /кk \n\ \  \  MGO˟ʋ1  #8ـ VY\' 0]\ \  g }  \ (\ c   \r!J; \ O i&]  6 āNې7 \ N\  #\   g VA \ dݐNޕĆ\ \ 8\ Y\ dP   ^< zI- \r    \ \ \ q\'{[iH 鮏i: 6 \  \ \ \ 1 \ VZ7# 47RE\   s!u:P} m݀ f J- ku\0\ % \ \ \ P Qp #`͒r   iW  & \  Ha  A \ \'$\ S I\  \ H-\'   \ \ ,V4q [\ \0K] \     \ ֊\'܌ /\  a\ ?  &I  \0  ) B\ LR\\> \0as  )g \ Z< \ c \ K؛  ;\ <Q  D\ \ =q\ t\ {#  \ \ y\ ທx\ q q\ \ 61   \ ~1]~ \ \ ?wQo \ 4\ J~ Y \ ;7  Et~]  O: 6   䵄\  B\ ڄi< \ J  \      s\ c #	\ \re8 >C  \ L W^[  W6\ b  \r+/\\ \ \ 73?  *!~\ ~\ \ \ ڴ W   u JN\ \ 9\  3 \  IN7  \ בY \ \Z O   \ \ Hk  \r   қR
 \ \"s }w -  6\ \ )\ \ (Oҋ   <LN  y  ʥ \ jO܂P \ \ $ \ O\ \ V	\ y \ \ _Ɣ\ ȧK \ C\ <  cN\ \'\ Wg    P1 \ r T׫!t\   \ ){T =N>t[eu\ \ \ B	\ &\0 ^\" )v 	> %\   @dO_CP
 \  m\ jrny] \ (s YI 9 )Uي\ c8  \ \ W w\ ;\n     S
  !0q  \ \ K2 Dg  =\    G 8 d\ \ \'2kb  \n< a  g  Cg98Ϙ ݉\ A>H#\ Q \ & a\ g j    :\ oԒN ҒK	5d $ |M,/5#|\ u  b  \"\ :p22F3ኪ4V\ x  ~ 0\ +\ GΉ  \ 9\ φw  |:U e\ N,ca RH _H 1[ \ ʏ#\ i6jnn \ \ 1+ ƍn\ Lj Y\ \ D	 ϥt =  \ vJ ;٦  	 
H\ 1\ \  w\ +E\ \ X;Zp Sm, F\ \ @ \ ʲ5  * \ \n #I Y\r  rL    L &0 6\ N \0  Һ\ $\ \ 0\ [ \ # } S\ %  
od\ u,  l\ !  Pd  o   c Uӷ  k.qدf \  -ԥ\" % Y 9  k \ \Z\'   \ % \ \ n J 6\ \ \ :  ip{E \ .b \ 쭂2   Y;
xN5y \ Whn ;aM\  \0 :\ \ ][\ \ O E O\ 8 b\\  U    \  |s    $ ؀ H\ Y\'U\0U =  |xϴw\ NM\ \ \ \  
OMs8 f  ǅ    \ Kvz ;Ӧ!\ T \ yԮ  \ \ BA!  \ \ U  p\ Q     \ \ /  ^  \Z   G*  |\    ^TC\'  @0?ZIw\ ͌   EZ \ C  R <v;\ X   G # ^t @\ y   Vte\ n[ng;yQP\ T\ \ \n   - \ F\  \0q\ Ρ9\ :gV:c4\03  t  c>@t\ \r  \0@9+ FG  \ eEX  @  \ (\ r dyƧ\" 4 }J\ \    \ Ӏ  OҰ\ jhxT`ţe\ A!Μ 8`GΫD%Jv̸ C ?  ?*\ bA;\ ߑ Vr  p  \ R  T5c@A  \ r  ~\ U:8\ \ \ )Uߖw\ Ζ[\'bv\ |\ \ Anx\ X yli\ .%+3 H\ \n # \ \ : #ݸ        \ \ \ 8\ ΖY\\ jc (\ 2<p\  \ \r+\ ImM G\  \ o@?Z0\ Q\ P{ \ : L\ \ ﺦ\0 ||  ( #
\" c \  \  `}i \r\r W#-  @6\    rR\  V  T \    \ \ \ \ \ 8U ѥĭ  /   2+ \0 \ x\ \ cη \n &\ -\ z  \ \ 0  r \ ] M\ F <BE\ ֬   B s2  Aj xs\ J :g\ 8W\nS/  \ \ 7\ +J {xOݧ \ \ uʚ \  P\ $  DG  Y j` \"   #\ \ D  =^p \ { .~> ݎ \ G p 4p $ p~\ t ~\"䌑Ƅ\  W? W.i\ .\ G D2 g \ 1 \ $  |   y5q\ 6 \ Z \ 3\ \ W\ t w \ \ \ :hTe B cK6 (   5.i 3}\ y : s\   ҔSQYDd\ \  \ _w jp\ y/8Ks M?\n M gP\ H\ 09 Ѽ\ C q#6 \ M\ B   H@\ 0\ q\   -  \ \ e\ Yf %D B   \  g  ; y  \ \ X\ ܭ $~\ O)+- \ GM a P  ٜn oAּO\  V\ \ n\ .\ iEQ 8  F `? \ -\ \ \ \ \ \ O+\ 4 ^I%bY \ I dc צ1  \ R/aBN\     <   u X\ J$l9  B 3 \  8緭f$ 0\0\ \ \ u\ A\ 6\ `U   収  \ >p͹ ۑ\  tJͰ \ \ \03\ KU   @ ? n * g8 br=Ea   7\ 7 ƥ\ 0#  R  rq˦_\   \ V\ sN|\rd\rMCwR4\ 0G,\ P\ Σ\ \ + \ yg  \ #q   z\ ҥ\ \ 99 p 3\ \"    \ \ \ \ KBH=0  1V 8\ m \ ԠF*J  İ ￭ #- } ] §h \ 2 \ GCT I\ 6   & \\\ c\ \ C  D \\W  g   \ X . \n \ 0 ]i @1 G0	\ ׯJxT   gq   4	` l` Z  \n\ Yp %x |G\r  ۢ`  \ 62\ \ \Z - U  ڞ\ HR7$  \ Ҷ\ p !un;;n \ _\ j  \ \n   \ H \ \ aᖋ3p\ ?   kwuo$   6h\ c\  .k \ 8 \ {q-\ ֮\ !\'I  %`p < =*\ K\  ,   w^\  ] 4t ~\r\   \r}yX_qP Fw  ю  5  \ \ \ V\ \  魭fi g \  FIߒ zW!\ hݮ \ N!  e 8\ \ c U\    N(\ \ \ g\ \ G$    ve cLki__ \ :P \ \ S?g  S	ls ă`  \ 9   wÑ   \   1iPX䜯x\ ~F5t\ \  ~\ 鸏i  l\ v Z PFI     l \ \r ȧ&y\"  <I& \ \ Y  X  흛 y    \ \ WJǂ\ l myP= -%\ \ v\   9 \ b7ώpzS/
\ Oy|Vs<  \ 3$\ ; .rI\ ~dr> {Aw\ \ \ \ lco {e#lB0
| O?\\aN\ Tp\ \ gC {U5\ ][p\ 0\ \ $ 4   \    \ i g˕y.~    \ » F۲P  Y 6  B  \0 uSz  Y o   \r =\ ހFs\ \ J \ _oR p  {o\ O  7\ g \n\ ˖\ \ ~ \00 \ ipyG \ \0 ؐ ګV  #\       \ X. 8\' \ k*)  gA \"\0p0yg\ V v\  \0P \ O!  \ V:W_	<$z>\ @ \ Z$  \  9\ q 	.A\';W\\lEp \ \ (% Z @    `  b     \r8 \ \ ) \0s : oc\r1:N  - \ \  ^ ;{   6Ƞ  i Q\ SmX!JF  D+  #\0z֫Ny \ L  U\ \  0 :   { 7 E W $   e  I; ڷ N\ \ RDfb  f     A\ V\ V L \ 2\ 1  ۫1 l\ ( \ \ ◌AY х   \ \ O{\ z W\ ^{ \ n$  \0\ B A c ; {  v  \0q \Z\ \Z \\o     yK   ρ   3c @yխP Ӌ  \ \ Um| \ \   \ WG \ \ } B   \ $dc\ ~5R\  ,lI,Iggg؆,\ \ s\ sM r  \ (A:[s ys\ X \ 9nٚ&fW \"h\ G V\ P\ G  A\ ?i/\ 0 f\  \Z k %  w\ O\Z\ (\ \0\ mlu=  \ \ \ * \0m{@\ \Z \ W8\ d f B:  m  Y]^_  ! rLqy\ \ }H   \ |4   X Ve1   ݔ  \ \  \n\ \ \0-K \ \ # @89  N I, #   33 \ ē \'z\  ҏ\\b  \ <N\ \ $   !\"^zPʰ >U<ju \ *#ߒ`\  W ?  <Ϩ < \ =\ \ Pu 5  Ҩp7<\ 	:ѿ\   Хg  T\Z~  Ԫ \ '),(4,'Cancha Vóley','Cancha reglamentaria para vóley',4,4,'987654321','08:00:00','18:00:00',_binary ' \  \ \0JFIF\0\0`\0`\0\0  \0;CREATOR: gd-jpeg v1.0 (using IJG JPEG v90), quality = 82\n \ \0C\0 				\r\r\n\Z!\'\"#%%%),($+!$%$ \ \0C				$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  \0  \"\0 \ \0\0\0\0\0\0\0\0\0\0\0 	\n
 \ \0 \0\0\0}\0!1AQa \"q2   #B  R\  $3br 	\n\Z%&\'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz                                   \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \            \ \0\0\0\0\0\0\0\0 	\n
 \ \0 \0 \0w\0!1AQ aq\"2 B    	#3R br\ \n$4\ % \Z&\'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz                                    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \           \ \0\0\0?\0    5 \ Q@    \0R\ QLb\ H(\  \ (P+
E  Ҏ  RcE%-\0  \n\0Z(  
F( \0)E%.h\0   \\v )(  (  * \ ?- FG EME\0yg\ mKN  v sjn b 0 \ fr \ \ W A  Ş\" { N\ \   \ ] cLg o {7  9. \ \ 2 `  ݊ \ U z\   ? \ F    \ \    ɇ  &\ 0I\ \ R\ z 
ט\ \ *=\ 1  \ C    \ A\ \ 2xz\ Y , ܲ \  \ \ G\ 1\\    qu5 \\@7\ `.\ h\  ۇE \ \\\ kR\ {( \riɕDs \     ;o\\i֤YY\ \ ,0   \ w  ] I\ I \ Y\ W[ \ X  I\ ks@   ā  Ƣ r  \ <r \ WW  \ f D\ DNNXg \ y ˭#\ V G \ \ #[j-Ȓ0VUxl T+6=    {m:M2 \    \  \ \ F\ ]\Z\ u \ ne x ;A\ } 5J\ \  \ \ m?U<d\ \ [ qūh\ Q\ \ \ \ # [   L:ᡔ;9=k\ <?kq \   w>cy[X}\ :  \ \"\ D\ \ \ ]? \ \ \ ef  Y \ !+vϵ\'\  v>\ \ \ ,\rj|   \ Xd\nԮs\ B G PH㸒5S ^ ? tuҶ!      \ Q@(  \0(  \0\nZJZ\0(  \0( (h \ \0Z(   QI@
җ4  \0\ )3Fh`-   \ \ Q@
E  \  E&} \ \0f (E  4\0 Rf  \0QE\0QE\0(  qJ\r\0 Q@_ \0Ǎ\  s5  +\ \ L #\ J>  % d<\ qTdӭ [2\ T$  x8= \rxy\ 
  -ҵꭝ fD + \ w5f ^ RQL@)h  \0QE\0QE\n(  Q@!  \0(4Q@%P1i)i( \n*2\ \\ 6p\ ?  ޝ   \ _jl\0\ \nP UQ\ \Z\0d $(\ \  #A   \0\ \ > ;\ KP   $ \ ގCt\ W _A\  ]6  I \    Lv	{t\ g      \ 1ڳ p՞奻  hd\ \    UOE`\ =  ! *\ Z\ R\ \rPi J(  Q@	P\ $s@\ 2   \  *  \"3+lm T o\  \ h\Z\ )\ \ \  VB (*    \ /\ u\    z m\ \ س R d \ \ ]аi\ \ \"H ݏ\'=O֨k\ \  M \ \ X\  \r\n \ \"V\ Hw2 #\ K\ f]V\ 
%Xl\ h  o 9  E 5 \ 
\ x O ԼA q
It- ~K}͐1ܟ\ ^ \ >kc ˦  X\ D\\,l s  \0 }+\ ~8|<  \ _\ I8 \ , )\ 6)\ \' 1 \ 5Y\ \ <\ #3J\ ذ\ I   Ri,[ zU t\ \ !Ic\  \'ң  ,f \ <wD\ D  \ \ q\ \ \ l\ aa \ ?AL  	 Dс\ z{\\ QN \0\  # \ v±8: 3\ GB\ \ Pj%vg	\ =@ 䍘n  jĝ =* KvXl \ Vs [  J\ \ b\ & X ei lr\ 8 j\ FC       ~  ^sW \ X3
+3q ֓ \ y ,\ Tz\ I  * \ w\ [ \ \" \ Z \ h]\ F \ j+\\  \n1J:V   0   X    \n(     \ @0  )\0  h\ ZQIE: AK@ RR\ \ )E%XB\ Fh    ҃@
EOU\ I\ .o\ ]\ o+ f .R  3\ b\ 7\ V  \ w0\ I#ڽ\n\ \ ; x\ \"\'˔n\\ i_ ڱ-\ 
\0 \ N-0  #y ` \ {z \ Z6 \ h\"  )4V   #|  s   95\ M  \ uR j-:\ \ \ \ 3 d,s߰  3ʵ \rx L \  Ik   $D / >T\r\ ھWX\ \ U*    ƛ k \ Z>a  [A   \ #f \   )hTv3\ 	7 Zѷ \ c   S  .=i )\\/q\ C\ 6gk kI  3   \  \  +#Ē  H\  \0\ zT7ن \  \r  \    \ \ 彍+ \r\  r  =\ ߆\ \ 2CՈ\ \ Z  8  b݁  o\ E- yK#   \ f>  \ \ w Y\ &\ Sc 2?C]\ ½\Z\ \ w k35 \ H$   a\ \rz     A \  [ \ \ `  r.s b\rbx  gR \ \ \ 9  Y-nם L  \ D\ \ i\ |Ј\ i d9  \ $\Z\ #  dEʏ3 \\w +t bb QE1 b  \\Q @	KF-\0QK@	F} i(\0\ \0R\ P\ E%\0- P\ E%\0-RP\ IE\0- PъJvh\0b (    \ \0 (\ +\0Q@ \0 f )) \ (( 0  (QE\0 RR\ \0F  : \\   ICڦ \ ĥ\   m \ \ \ u x  ƶ x\  K & )\ \0\  \03۩ cGs\ M\ [  \ HZ\  \ k  * R\      ؑ\  t T \ \ -RS$ZQIE\0-  \"  Lњ\0Z)3Fhi(\ \0QE\0QE\0QE&hh \ 1ٙ \'      z\0 &58\ 0\ \ NUTP 0  \n 5\n \0Q@\ni \ \    gy\ \    \  \ @\\\ \ o%   $] \ \ \ W  \ I \  k t   8ע W  \n 1  H\ \ S Vsظ|G  q xMo[d U Y>m \ \ >ε V - \ QE1Q@     IKE \n  \ i ؛gU`YI \ -Jk c KF  ) q\ }h 5 J \ \  ׌\ p M ß ާ w \ Vp9/ [  u\ \ \ jv\Z\ ί;@ <0 [Q 0\ [o| \ \ z e/  W\ v\ \ kֹ + q #   : ڤg |A  
=5o$   [A U#\  CoRy\ y\   \ \   \ Z\ |3e \\\rR \ _hvx \ V6;\ f< <g ]oN[9 r*0ܨ\  1 <+c  5V2\ 16I\ 5  c   Ԟ\\\ 1 s\ ;U$  J,R-2\  1\ -\ \ &  \ \ ű    \ B    <\ s==*11ݻ h \ i 3 \ v  Y M \0 /   &     *\' 8   + K\ z\ f2^ ʕ
ެI E    -    Z\ BR (           4\0P(\   \ \ @ ZZ  \ Mc \ ]A\0 Xbi<\ q \ f   3: <2 %  n   \ n{ -q  y -E ˁ|   \0  \ P \ ՅP(\ LB\ ފJ: ( AKIE\0-W \ - \ s=Å^ wc\ V    
5\'v? & **\ ͸ \ \ 3.\    s *  |^   nl\Z$ \ \0   y$6񼒺 q \ ݫ͵ & y\"Gh\ @N\ $ G `\ +6Mz \ 7J\ -:\ \   \"N 5\ ^\ZԭI\ \ k D  .2+\ ! \ ww 41y,  \   L    /  1j\ \ y*d-v    9\ q   V3 9 M۩[pN\ pj\ \ k\  E Z\ 
Ew q   } k  \ ~ d3okr    \" \ )E\ { \'A  \ V \0 c\ Dos \ Z \  90\ ŭ\ \ \rEʷc    o /R\  \  c㎘\ 5 =\ ;- k k\ >/x* | Ԛ=\ i a`9  \ \r;D խ\ \ \ b  \ { Ίx\   \"\ yҡ\ \ Mq  0t9R:\ \0 1 yV\ \ = A\ :\ c3\ &K\ 5\n\ \ \ N  ٷ1   8cRY \   x4\\K-\r\  \ \  [Z?  \ 鈎h FG  \ ʸi?Ѧ E?1;@   ]Y  I X\  \ \ \ [  >˳ [Bv\ ,~ N \Z LU (*H ? jZ\ %ݴ7    ؊I *9 [X\ \ \ \'Җ  U)hPKE%\0  P\ 1F(\0     1K \0J 4   Q ( QK@	 1E\0RR\ @	E-\0 b  \01EPER\0  ) QE EPF(  QE\0QE\0QE\0QE\0\ ּ \ \ |s x  nI2  \ m\ è \ $ O \Z\ 6V \ 0 ^Q! Q7 \ T  S\ yǌ5 A` \0  \ \ \  87\ G\ G> z\ D 	E-*  )9   (\0  (\r-PEPEPE\ \0Z1Iޚ\ wlN[ \ \0 \ [b}\ \    zr(E\  \ ޅP  ~ \ h\0& r >\  Ϙp>ﯭ\  \0u4\0 {\ )\ \   E\0/z \ ) ]  * \n _ C# \ $? EM  \ }\ \ \ -0 \0\ ~  \\ \0 [w t \0e#    ;\n[ QL   (3Fh \ \0-  \0VV  êۀ  +   OJԨ/ 㿵{y o\ S b)0<\ _   DCi, Ǧ\ Ͷ)\0 \0s$ x
\ +\ uY 6    ; \ .\ m   Fv G^2kߖ\ \ \ v: \ @ s4 y\  $Q\ \' \ j ?\  /S\   \ 	-յci9% I  \\e~ \Z Sms _\  \ 	r    B\"f\0  wkc\ l/4K{ :m p\ 6~Q  ˳g N9\ \ h   >!  F GG!Xd ;p\ \ ۏSQj  /|!  G 3\ <W-   R(\ .  \'0\ + \ <R ŵF ԓ  \ \  K<Ǩ\ &  \ XnL  E\   (\ D \ F\0\ w N?x *\ \ %X\ \ \ & ҳ Tf  \ \ o 18RI5f\ 	\"b < S y*\  c 6ƃt \'\ \ 9 } r  $j\ [\   \ \ F<\n w \ \0    \\  \ FM \ r p  {T   w{R8e#nH79\ ;  ~ \ \ sKZ QGz\0J)h    J(\ JZ-\0QE\04    2 \ I5k\ q <( rVC   +\  F)5q c\ j|2 5   \ 0	,` s \ \ &  =.\  \ h^x F  \n9T vv  5 \ )4M\ X~ Z \ iE- \ \ j~XnO  \0    l\r\ ѥb UZJ(     \n4  E$\ \ mM< k\ ;\0) >K}k  \ \ v\ $ ذr:) |O X&\     \  \\\  {\ \ \ \ . 2 \0\ S\ zS\ ƭ\ \   e\ 췒   p\ n㚧hQ\ \ +c\ 6\ uW\ 8 VU ~\\Πu -Rg6#\ i V 7 L \ \\5 o \  L\  \0Z\ \ \ L H ] \ ŉQ 3W|/ J\  Zv~ ҭx\ \ - 1 0 \ :WEk%dr\   \ C\nK u T$\ V<̬Ǔ\ BK|\ uUi\ 9\rҼ׹\ \ \n\ ߗ    ~ @\\ɎqK \     nyQ\0 \ 3T U \ .  `e   9     & \ 5K \ % ZF1  !<Qb \ =\\I å^Ӯ\ $e    V WI=jK;g 3!@567/\ q\ 4܀\ \ [   e    n73x j      \ \ њ  \0 I \  \Z\ ; Xڠ;n1\0\ sڲ--V]AW  5\   e  ,Vc  \ 7 ~BG\ x\ kV)i    -$Ӵ[K  0  p+V im8  n6  ̉ ^\ \ FAES\0  d\ \ \ Q@-%(   (\0  iE\0\n(  (  RR \0Z(  b \  s  ғ@	E# \ L{Kv\ U[\ \ = hbQ ғab\ \ dM\ 7e ⹯x\ N\ \ H\ \ \" \ A   \  \0֬\ \rx /\ \ ̔OsÅ  v\ @j\\ + \ ( m  \  <lFv QR =* $\\ё\ #  ՚u \ [1[   q>Պ \' J  MFe   זE%I\ _ \0]K Ia \Z\  7 \ 4 ׆ 2\ \ d \0P \ ֺtq\"\ ^ Z +  
Ew8 \ Ӛb    `5)4\ r r i=A\ =\ \ w0J\ c   \ \ v$   P   @	E) \0Ph\ h\ \0QE\0QJ\0 \ry, Ӿ%j  \ ط  nM  0n\\ {Z  qҹ_\Z\  :[\ \ 7Ēʾ\ @  \  a\ _\ ]SQ\ \ i ӿ  \"\' Z z  \ :\ \0\  J  E \  b  4 Q@Q@Q@%-\0   C@4   \ wlLn\ O \ \0\ s 9~\     } ބ@ h OsKހ\nf|\  \  t\    \0 \ gqڼ\ \  \  H \0\0 \ H1\ p)s@ \ i(s^S 53\ >  z J ω\  \'\ \  u O  |G] \   B\ ٜ~ \ W\' ų\ 8\  eq \ YW =)3L  \ A\ \n\r%\0  R\ 1:Tsod\ w\ } CI R6 \ gNY1 z GҼ K E ^޵ VBɌq: -  	\ {װ:\ R;\ }+  \'\    \ t (㲂[! \0\r#\ nj 3\ ]GJyD    May$ ah\ \ N\ \ v  H\ H  & gR\ \ >  v \ KH  en ZG\r \ ~\  ϓrj W\ \ R\ ݷ \ V M   ~i \ \   \   h\ 	\ O>\" Lcu8*}  2{ .  %y% \ d BK 5 \  \0	j%   Y    \ 	   \ PX {t\ \ \ N M ԡM Y n  \ \ \0z  \ f\    ! GJ 4\ \ \0u\ \ \  x_Z Bs  {Ҳ
 | ğ@j  \' J \ L >U  \ y ͷЬ[ \ - t\    \ - + \ q    \  G@;ֆf  \ (    \Z\ $ j)\ ޟi \\k \ Y\ \   @H I$\ & \n GZ ܺ>\ J\ u S@~ QE%lH      \ \ b \nZ\0Q@    PK \\Q@	E  4i\"2: F*FA    \ #  X \  {   \ \ \"+ FA\ T$C 1 -h\ 2\ ?\  J==E\0^  Y]ІV\0 ▀ R\ @  m \ M\ \ \ 1 Y ׉x \0\  %  l \ ѷ	\ R; oj\ >5^\ \ j \ 	  x- f  #      8 uZVD < \ ҺƩu7< b { ٧ \'rEt \Z \ wO    DFJ\  $BmP  \ +    \ 2|ȃj ݿ·|L\r  j  \ \\)  y 73^ j8$ <\ ]\r) ^\" ў  ޽  m X\ id>   \\ȋl &\ e$\ \ ZS.u s󼬛z\ \" VG Sd x#iB \ 5 uus\n.\ XɌ \ l\ & u ޒ-\ H4  \ ^{;\ \ X \ 	    D  7\0qI\" \  > *G Č\ D#,ʾ t\r  t \ \ MJ  / \ *tI^\"~     J/ .\ +m$   ۃH\ 3 I\ \npK\ G֝r\ .pZ i s	VˇV\ 
   Jøi T$p   \ M ܽ   [  I
\   v\ X\ 9\ r~   \ \ a\ }\ + |s[Q  9 R l}wo %  ~5.*  ( \ l   ߠ  \ [Q@Q @-&i7 m  (iEAww  \ \'* \'  \ =F;܅R 94 -\ HHQ 8   )A I\"ĥ݂ \ MV V   L+  \ |Ƌ   U=OW \ ayn  6 p  X{S4m^-^ ]   \  
 Һ
\ \ Ě^  > v yNcp:   \ Ӽ_eq\ V\ \ e/p	BpW\ \ r(lv:zSMf2\ ( 4H\  \ 3LB\  g ͛[ [s2H  U݆Y \ i# {9\ RCcq\ N:    \ h]\\\   \ ѳ UK\ i`Q .\ N\ \  \ 3y\ 	c3\ i-\ +  > \ ǭp^= \ \Z   (d \  O\ q\ ڳ K\r#     \\\ oqe4\n\ \  \ |\ ϭK +X\ \\\ )v  c\'\ }k\ \  \ \   {  9s A\ I |I \   tB c \ !}  \ ]b\ jW  ɸ  \ \" ̈́ ~\ \ . \ l   3#H\ 3Fv  \ \  \ Ԯ\ D \ \ \ \ I5  \ O&7- \09 Y \ pl &\ \ \r   4   [p4   \ Ӭ~5Y\ k҈\ }\ C\ \ & x \\ U ϓ\ \ @sɦ\\/ڢGC\"9<&\ E_ as\ |A ;Q  L2KsoS\ g ;\ N  :\ S Lw 	 FP   \0u \     ? ]|\ 9\' Un$V N \0=pIu *y\ as\ </\ 
\ f\ 3=   8 F\ .~  \ \ ]  $p u2q\ \ _-Z & ķ  Hr :q ի F:9\ \ \ 
 6 \ ש U\ .}0<[ ^M  %0*(o \  VO |O j\ % \ 4r  9@   \ \ i\ \ \r   \  \ # u\ \ ~7\ ,u9ua}o ]  \ -\ Q\ zV \  \ V %\ ީ#   ߦ$$  ub{ j\ \ \ \ =>\ \ g ?;y) ޼\'M  \ x[P n\ s/    \ ۊ \ Ǿ$  \ \ \ 	 \ \  ?\ ~¥MϡΩg #&\ #v	\  TEIR[   T\Z- \ \ WQOo܆Ed \ B1\ {  \ \    \ VՃm| ?\ ޴R DIRL\ l S T\ V  %
 fޫui\ MX^ IE1 \ Fh b & & QIKڀ s~/]\ \  ؗό\ \ G O  t\ s . /tI7  nO rj@k\ G a     ] \ \r\   \ N2\      R[+s(  * Y 2q `ˆ U  H    \  j  \0Z(  f =  i6);W {\n\0   \ w $ɸ*\ 2 \ZY\ XP \ \ J3Q   z\ z\ HuPT  O8  \ MKH8Q J   PE%5 \ j}\ \   \03\ \ w=  T   O \n  \ >  ֐ ֙̇   \  \0Yׅ t `p  ހwp8\   \      K@R\n`-Q@yw\  \0Ƚ\ \  P5\ W \'V\ \ \  \0f     
>u \ \ ] q\n  \n\ }. \ >\ q\ s\ \\\ QEQER\0  (\0 \ \ZN \0 QM Al\  !FO\ (\0y\  \ =+
G  \ mA    k % y\ 򟺠VG  \ b\ z    \ ,\Zr S  3~To O k. - =Ր \ 7\ \  \0 \ ڕ\ K\ \ B\ R\ l   X-
   C  9;Nq\ G\ ^\ oio ˨h\ 0\ Z_\'\ # S !x*\ \ ƺ  v \ o\\B4 \ Y` IYb\  \ \ \ @ \ u\  \ [][\ \ ]Y  i   g !\' \ Ա  x  K\ >ѢYMi i֍i  \ \ nK   9 s\ : \  ;     \r$ \ 9P\   # \ \ ^k : \ \ w \ ypL{I9\ \ \ \\ \ \ 1 \ i6 X_1  *(P6 +8  \\z\ \ \ n  d r$ju$ ZWi  7 \  b\n GSR31\"A\" *   \ \ \ \ D	H\ vq  +̡Y$  zUi.7F\06y  v$g  J  \'4׈  a \ *kX \r    R EWy9 qR݄\ \ \ Z)+q
E%-\0(4f \0 4R\ 4R F()qF)h1KE  \ -\0    \n\0J)qE\0P   ů  \\a \0a     P\ \   \ \ \ \   uq\ ? - \ \ \ R0\ mu a .(\ - ( \ n \ bq טCj\Zu-  \ լ \ Kk XUÔ\ /=\ \ .ٖ\ (8  /\ \ n\ Fo  \  5& 9:  y$ \ U\  \0 7^ \  \0 !7 J\ \0 \ \nSza`  ! u \ \ s$r  ƠFO\' Y\Z \ \ \ hb2}+ ծ- ԞV d *\ g?Z  O=n\Z5  JY 8\\{  \n  \  q0\\\ gb\ \ Gp Qye \r ֹψV\ m- \ ǽmi\ } E 7M\ u]\  \ \ z   \ !\ on&  v  v\ eS q  +6ciϧ\ | wii夓   \ φE\  m}-\    V My \ % \  c W4y \ \ 1\ A# :\ W $z R    ۼ FÜ(\ E`O\ e 8  \ Ʒ CE\ \ 
F \ g,ĒǞi\"\ f+\ E N\ Z I>`;\ Y@\ w M8     ޛB  \ % WWc\ {[\ *9\ T    <|÷\ \\ v\ \ \   P \ p   \ \ \ \ j^  <X  ʐ \ > U +  XF\ g8\ Z 1ly     \   Z  ڋN! \ 0{i WKCN\  \ v Wg a\ j
 \ \".@\ [ & \r  \r9̟\  >  gJ \  ه e fh\ \ +b  (EnpU I    6\  \ YFۦ?*Ҭ \n \ \ri  طA u\ \ \\  [   x\ 2 f\ \  L x<ޚ ,k    \ o\  o 
; .
y <  \ wcq:f  g➙kk :  Į@ \ \0 qP\ \ ;ˍn\ \ \ Y\ yX bTg ֲ\  QGqq\"\ \ \ 
)  ?  \ q|D [     V V1\r + q\ \ g\ |[\ 1 i\ g a  B ʄt/^ \ \ c\ #  \ \ Yj\ >6 \ ~  \  \ \   =\ ԣ   \ +\ o X  b \Z\ \ u_2Vp\ \' `\ \Z 䌏=ú \ [\'* b\   \ w \ \ + V \ F,[  \ g\  SO \ X\ZgPY\ k  Z  O V d20b  5g f\ ѫ/$ҧ \ m \   o}* wǐʲm   \05 ɶ [y9\ \ \ \ xM  \ \  \ = V Z\ ]  B \'w 횙Nk`L    > %  d  <Ϳ5r \ V   	\'dX  8  \ ָ\ ]^R\  e\ py  \ r9ͳdݑ ū9NOA\ ڽׯ\      \ ĞNq  \ \     K \ |\ k\"6 \ Ry\ }뒺 H\ _\ \ U\ Ko|n[\r\ \ #5> \ \ \ xw_\  .b   \ + Q  =\ <? \     H\ A˳ zĞY @  0ۗ\ [V2  *  \ O G< Q N V   \  ۏ  A c?.\ \\M^ \ čoL\   qyg qh \ r{W N`2!i\ \ ^   ` 馕bPJ b\ \ \ ֟  z\ 5ߊ7Z a\n
`  \ \'\ \ \  /  8\ Q \ dg\ \ \ #\ s\\     Ŝ  Y \ \ ˱\ Bz  = H =[\  \0G񂥅\ W(f D\\ c    oV\ \ 3a<\ 0  V1\ l71; pI  =\ 7  ^S n=\ [\\ۊ \"k  iK، N  [%+\    O ۈ\ i۟  \ cjR   C\ a   \ \ Hug |߯) | \ \  \ ϊ\ \ ʒ1R<\09{V B-  ,pT` q\ iXj\ GBH   ? Dy\ Ǧ;U h\ XYRa\ \ \'  /\ ,\ B 8   \ w2 F% *W \ ޹ \ X\ w(  i M*G\ ݔr+>K\ K\ =    \  S\ `x2o= ڝa  \Zff*rX :Vv \" &	 \ 0sLf\ [\ \  
2  ) %\ [U6  F !=\ Q &r~Z۵ Y \ QXwS\ \ R\  \ R @\ *  \ ?`  \ ~:g +    \ \ +q J % \\\ \ Ӟ j\0zN \ + G  S4\ f  \ \ ?\n5\r^k  -\ }T``u\ l\ \ ַ\ 1 \ \ ֽ , \ .m\ 72\ n 0\'\ E&\ ƙ . pK
Y!1ȿ08\   +Ls^S  ^ L\    \    c \ \0\ x\ \ f  G^ \ }k   U1 G \' l  \ i  /\rx  ӥ귶\ u	\ Ip \ $z\Z\ T ;7Ҫ\ a Rf  w\ LB\  k D$guY`    W] !%   \ Ԯ \ q \ v  v3ސ	 j7w \r\ ,&3 (>  Ae \ \ ai si֯= Q.
!* cҹ   W   \ 5 U\ \ .q\ 5<\ ܫ ײ\ +  @\0   \ \ 5;]=  Es \0	
  3P\  S  - K+k{{ \  L\  w?J\ u \ \ \ Ky< bb\ \   \ *sۥD  \ =  Z \  r\ \' \ \ ( \ 9\ 2y\ O \ \ mt   *\ 4  ,\ #\ k? \Z \  \0 \ [C\ l  @5   \ Ѡ a \ \ ɜ \ \ \'u \ \ 7\ ?\ M\ \ \ \ H   Z\ B      ƫ\ 9\\^\ o/ A2F\0  ˯\nZk\ M|  Y څ  ͊\  T\Z? \ 5\ \\	 \ \ Q`X   ? $\ GGc\ ˻-A  8\ XT\ [ Ѳ}3\ *ֿ  \Z~  y\ \   L     o`   \ u\\ \0 \ V    i$ \  \ Xlb\   Bz \ x\ \ A \ f vP  \ \  px  3\ :W \"q ], 7+ ~ \  cɦ\ . \  \ \   \  \  \ >ޕ \ k+];MK t \ `^+v{\08\ JZ\ ,u\ \ \ 1+a
  \  \ \ \ k
\ }h go!c(\ 7Dq\ Q  Bk\    &. s  Y\ .4 K\ z pGu<G(  A\ q j #  \ # M *, \ y  R\ u\ A d \ .q {   \ 4
  yoaV ah  W{\ \ nZ6s  ] I\ Ҕ\ 4 t\ FAz +̼ Ku\ \ Q]\ gy
o L Oa\ ^ Nc\ d^ \ ~ Q  V$fb\  v \  \0^  v \  4* / & \ 䚢E$ qL \0Y\ \ }\r\'\    /\ ;}=h\0\    \  \ E (   .\ I 	 \ -!   W |R 5 >  \n \" \ \  \0\ \   \ \ \ Vu>  w\ 9 \0 e  L\ ]\ p_	\  \Z g   +  \r S\ \n( 5df  Q@PM\0\  >V
  c\ \n~i F \ ѷ\ a H4 \ ݽ\ l   Y   C       \  3\   \ oU$  Phc \      u nK+x\ X    `:t W:\\ Z   PV$a8\ y\ O +ϙ|-6 tmg] [۸t5X\  \ L \ 5  \   4\ d \ & y\ !  \ \ \ ^\ `\' sgo\ \  R\ P󧻒\ Y   <zא\   qq \ [趱\ \ y Z(2x\\\0q\ =\ s\ \ M 9  
 % #,f& 03\ \ a\ \n\  ; \ {\Z\ u[Xt۽9\ CL$\ $v\ W\  x5 - B !  R j \ f*\   \ R\ P. 	\ (,   Y  J vp\   ;\ \ 4N qګ\ 側M( \\ ;q\n0 U +U \ Q  \ J/a؎\ ٧S @U \ i\ D\   \0b -aiC\ ;U} ɒS \ W*y\r\  ?tu 	nzdjQS T    D     # 0G- ~誵 ~ \ f V\ \n:\ \ \0Lb \\R\   P\0%--\0 R h A (  aҊ\0\       \0  \ : @	T Ŷ $_ r<\  \0xuz \ CdQܯ޷ 1 \0t h\ * \ , \ @\ 7ٖ  \ ϵZ -\ C\ j  \\K1\ # }  <;\ zF  \ \    - 3哹 \ \ y\ pe   {  o p- \ S )| \ W c͔E\n\ N\ T c -W6\ f \ \'?/  <t nxh} \ \  HU\ q  ַ \ *9&  r  W+ \ ;\ Oc,=^i  \Z     4p    \ \ \   xW%A# \ Z\ \ % \ ȅ   oS\ \ +    0 \ \ $ Z\ \n\ ;  \ \ #Zxv	   \ K }\ \\   \ 2\ P\ U\  >  \ i{\   `1 \Z\  \ 2=?WU_ *\ n\  =  p9\ ҝ\     \ H  \ ҮL\ aT\    w\ 5\ \"\ ۠ > ~U.\    :ԝlK \ 6bBi\ д\  \ G\" 8  Q@@@  z  \ c .$\ vnQ \   \ J8\ k  \  v\   &i\r\ 4 \ % X  t  #  \ k\ k  gd:|&_9 \ b  z\ ?ī4 ( H\ B \0d+  i1\ [0r$e\ \ { \ 3 *4gGm\ \rD\\  K \ + (    \rJ  J Yq  \ W>kI+\ \ \ / ^\ \ v VA  \n\ \ ~\ \ * }Es\ 4 \ZipxZ\ \ \ \Z; @    \ \ \ ?5 \ Ċ# Ƨ\ gŚ\ 4\ Jb [H\ \ B\ =	 }[K\ y (X  \ \   u \ = -纸\ \ $  f  Bp޾  3\ \ *y c zV  ]>\ \"VgE\ *pA 4ɯ\r\ \"\ 8 p=\ Sm\ B\ \   %  L$ gD  Q  k W   \ +  =*mX5 \ \ O \Z VE85 <\ ]ˌpsҶZ \ Y  m 3\ \ UG\ ]ʅ\' <\n y|w\"\ , ~       7l\ Q Lb #\0J   ܱ\0 \ , d$  \ Z V \ b G N H\  \Z % ɴ \ 
F \ \ # Z  \ DC&\ o\ 5 \ 4휈ն\ \ ͤ !V} CW\ V[S\ J  \ S\ ޯ ܹX\ u c :  \ h%	9&0>Z \ \ \ c< z \0 \r# p   6 UX\0G@5 C WS\ \Z \  ZuF A\ 4\ \ :  i$} \0{ +J\ RZ2\ P\ zW;v ıM\ Fzt> \ ~Q_   ~   -\ \ F C\\4 \ = [ T \ \ @H\ +  \ \ W\ ~Rrh \0jY     1\ \ \ <?o4 \"ݼ+\ J \ H  \ wb$ \ \ $ ojܴ &\ \      \ !Q}G$ i\'(\ \ )\ |ȓ#?w9 \  x\  9 \ \ E M+   \ *Q [́ )I=\0   \ m\n \ r\ ٯ\"3\' 1  \ O\ 4g  ͙$	 # Ek    \ $\ \ =\ \ QY\ \ +  \ A\ P\ _a3_\n\ pɾVQض1LmY  T , \  k  PW$# ^   ld  \'\n\ %R[1 Ρ   \        \  # z  \ lcH R g =j  Fd-\'8WBwBe   S\ i0 kF   	 ;\  \ p+9 c b\01 \ G6\ vʤ \ ^  X\ n ˔\ *KK v 8V=p°R 1VQ  y# @^\ \ Ố\0\   \0tN[ *\" \ @=\ U  Xf\ w85 I n:\ ( Ir  r z\Z  \  J YBߥ\n\  r0e Ֆ \ \  o \ H߆O \ V
\ ,  1 N  .Y$P#-\ z\ \ \r\ ]M +  c\'j  \ ^ \ +aih  \Z 1\ * M9\ H8\ z׏5  \ \n> ZqkWB m \ \ 20Pp1\ ;v\ E=   \nI5 \  J B\ \ 0} \ \ \ ߈.  \ \       2\ Аk\ \ \"x~\ \'  I\ Q\"6F\     wv\ \\  \  ѹ ߘ\ G3 \  \ 1V \ b n  O K,H#     \ \ x\  R   Eqq 2\ \ 1  ޟZ\ 4\ XCִ֚  : \ f * G̙ \ ֜\ @uv^+ r 6 ^eT  yɭ\ hn\  \0{o*    \  \0Cүg dҵ$\ \ *I(n\0 \ \   \ 4 1\ p\ # \ 3  \ L\rI : ^Z\ \ ѹ   # }k! =h$ \ Q  RnB F1 9 4& :\\\Z 	#s\ \  \ ~ \ \ \ +n.1 \r\ 8 \  ) \ n 
[ON   (Q \ s\ ^ Lt5\  \ ^\ 5Ic 	 B g*C :\Z\ ?\ ծ \ xo\ U  h\ < J  y  |64 y [ n# \  \ \ >U *\ [ L    h1\ \ ^#\\ ۢg \ Lz   -   4ۨ\ \ Gv,g$<\ \ 0k\ t  \ \ #\ >ŉ 8> \ x \  \ G\Z    .U \ \ d  )BzX W \0 {\rA    \ yB hS e \ \Z q \   \ ɥ\ mnɲ\ &\0 =CS^U\    =r; \ f _1\ \    e  \\\ q#|\ \"\ j \ s֫ |  k ڪ\ \ \ :DcE     \" =+\ \      ] S c Xm B  \ g \  q% b: ҪC   ԭ`\"II>lRt_u= M \    t WZ    \ Я X\0\   \ ^c 麍   rAq\0s j6\  8\ [Px Q l } Ŭ\ \ \ c d z  ^\ [ \ |If\ iP,. 1\ v\ \   VOQ D  pxmn r `\ \0|   v  J\ \ t osþ\"H  ʃ osֹ o\ < X \ \"K \ G\ ʩ\ q\ Wm/j j:z[i\ \ ɷPe c=  \ D e  z\ \ z ח\n  7  F÷\ n h0]   !7  ن\\ \ f\\i   \   \ ݤ,p e \ 6   \ ) k\ , 	 -ܖ \ L\  \ O\ L\ \ \\  \ \ \ ʴA ݍ   \0\rz|h F  v \ 5  -\  al  /  V\   J\ (  \ \ q  \    \   .N[  B\0
  㰧\ f \ \  3E\0QE+   E-( \  `-y\ \ 0֜ޱ  Ez5\  \0 ͦ   \ Q=  \ |)o\ \ j=סf \ \ K\  P   k\ iCb nQA   QE\0QE%\0)   \0(   \ }u X V8\ Iu2§\ z \ \ \ a e\ \" \0\ g֐ w\ Qٽ   ̈́ׯ+  P \ rǷJ  mw >( Ӽ &\ \ 7\ % %f  }s\ _L\  )\ \ R   \ \ \ ^ 3  n  I%ݛ]\ utU\ \ ~P} ^ \  j0_   ۸ T\ 4 a \ `j\  \ .K % \ .hL  \ } ޽q-Τ\ ` V(\  P;\ x\ 2/ \ $8\ 0 J{Y%* B 0 Y .|ߘ\ \ ԯBwu   ] l\ @:٭\   H辵b& \ O \ c g \ Ǧ{V  g\ \ 6 \ {P  \  [P\ \ ucګLQ \ [\ ֭% \ n% ܍ Ԟ D F% p\0 4rA  a E\ c\  @ Z 5\ \ `\ sS\ ZG\ \   S \ \ \Z1K 1[ {\ ъ%(  4\0     f  &1KE c4 Q \0PFih P(  \n:Q\ \'z\0Zd 	\ # jW \ x \ \"  \ \ )3}刃  ⧅D\    {z\  \ \\[ 3y bA  j   \ h u y?\  \ h\ [ :\ \ F+HDQ /  5\ \n| w \ \ \Z\ ]& ؀ #kĥ  \ \     &\ b\ y\ Ͻ \ \ h f\ \ /\ Hy\ p+ DY   V|\rvo|G `\Z  B0 \ i 5 X\ o\ ` \ N ֹ  \ 8$\ [\ \ ? 6 k`1 \ ;>Z* \ ?( 0 ڝ ʞ o\n\ \ ( \ ҃  b \ \ \ Ӵ ׈bi.	e=  +WI \ Gyt \  \ \ \ *    h7 ~A 
\ \ \ \0T Sf ʝ8Ǯ 3> \ b\ v  T.\ \ \02\ ;di\0luj\ d PθYĭ&A \ z fXnϽJ\ \ @\ Y $h\ \ qY^w 3\ =\ ϔ6\ ݎ  \ j _ 2O&\ б\  \ j  h e)?+}k\   \ B\ \0\ Jݸ  -\ QI w\ O =    zA -x Z{  \"\ 7ƻN9\ \\\   \"  e \ ` \0 \ \ /pd|7 n\    -& +\ A5 U cl\ mukbL\  0\n q\ Y \    \ px   ͼ %\nn  Q\ VLR-ó\ z\nq  Φ\ RY he    j \ ;  \ J\ /  A  8\ rm^+ ^I   qO\ \ ,=\   0 \n8\ {\ v uu  \ uS\  \ \ *=\ R\ \ \ (C)c -]  _\ {Q\ G  -m\0 \ \ K \ \ \ \0\  \ Y  t/t X\  [\0\ 
 \   cG\Z`      k   C    \  \ j   xbdXZ   \'v!=\ [ҴKk`>\ \ \"`NYs \ u\  6 \ @7    g\ %̱$\ p v\ \\ - 6p   3 0 {z\ \ I \\6I Ij c\ l\ \0 9$ Z u ]\ 2  Q\ \ qG5 `X[x5( \ ,e s w#SQХ c ͌ d  5 $M\"A  ! \0:\n . 塞I!]  z\ZZ 
.H    \0\ h\ y<{\Zݷ \ 58Rm \ I(9\ ? <	nq  < ;j  \ 0\ ~k\ B1\ j֟#.\ !Cu9능   N\ e  \ j %h\ 6\ U\ ޏQk v	2G %\ \ \ [;}qXis A \ \'ҷE !   T8و \ \ Ň\ \ CVb Y \ I\r\ L:_ \\, s ޮi    0  \ . O\ T\" V\ *\ \ 	ĹD8=	     a\"   \0 \ l\ \ (Y    t 䴸 \ \  oX3 K\  5hZ\ \ \  . d\ l<З [ /   J  4\ \ Ę   1 :Ve \ $ ,\ [  қ n  \ l      7Z   .Pdc9\ j 2;{ ]\ X  b9%ڮ\ O5 l      	  g-  j \"     F\ \ UW  \ h   F  \ D߸Ὲ\Zʚ\ \ 0wr\ 8\ \  h G $  A
\ \\s\ \n \ m\ \ \ \ {  \ 3g \  S \ +( \ \ C\ { 	\ ;RD\ J Qn%F\ I bV\ c Ҙn&\'pc    \ \ U\ m18ʞ\ N\ /\"] q   9\n89ȩ Aq - \ 5_##ެٲ  8   k{  g\\vb!!Ld\ \ Z \ [٪ \ `q\ T    \ K  Օ\ \ 7\ 6 \ ^k    \ 5\ óv\\ ⚷  ܎0ij  //uO#W mc LAP  6(w \ \\ \ fXjr\ ʭ  3  = Yc9\ |\ \  P<k  \ Zt\ .u~  \0  k\  \0 #   7 1#m [  ^ \ oi\ ^\Z  \ R   vK,y;O_ 5\ \ :  .P av\ V   e\ I s\ \ i^ù O u\ Y ӻ\ .m\ e *y   =H\ \ \ Vn \  \ #:\ 1 @ 8\ \ \ Ξ jh\rt Z L3 u   N4\   7<S S!$<.F1\ .t ٟK \  K , -/ \ q\ 8l q   F 6` K \n \ + ǜ\ \ כx= \ m\ \\\  ( p\ \ =G Nk\  O? .-\ y-\ \  Ȟ|y\ 2	O \0^ 3{.\ b\ \ θ  ]ʛQC    W  \ \ Z.u  I ۭ  UF2Đ3 \ Z 3:  \ y  h$    \  k2[gO\ \ {\ g\ ˇ : \ \0c 49\"\ \r        }  l}  f\ Wc \ \ xb\ 1\ m  P o6 p/  k\ l\ \ \ \ 㴹!fb- 	 $\ }[W Y\ ] f T 
 8  U  |M & \ \ ȅvD #\ \\ \ ˡ\\ \'i*	   k[\ } } m6ao$ch [g\'\  5gJ\  \ \ e Z\ ~\ |  Q  rw ƓB# \ \ ţ I   sm\ \  \  \ZN_  ;   \ k\ZM\ ż \'Cm  E@ gRx8   ۫   @( }*  g  {YuX  [ xa   \  = U \ -B\ j \0j  \ \ [p \ ~B r\   \ \ j- \ \ ec\ QԵ${ $\0   }jT   - \ ⋀\ $   R  9\ [   A  k  \ *m z \ xM n x!vs  }  \ ]\0 e}r  \ 	   \ I 1\ G+ Яb \0 4  \ =By\n\ \\  ,G \0\ {\n /Z[hc  #  H 8>    \ \ ]2qf;\ 7Һ i
 ʒ p8 ⻒\ br\ Nx}\ X句V $ խ\ `  ʟ Y    \ :~   \  S   `\ S +=4  V}K͙\ \ S ( \ GbkB \n(  \n(   \r%\0QE\0 |T \ \ O O    \  \0Dӏ    \' \ G\ [m\ \ W   \ ^ ^g \ Y   \0ֽ3 M=   Pi	  3 J(\0& Ҋ(\0  I \0ZCE\'z-P(W% @ռC 
m&tIC\r\   }qҩ\\ Q NԵ[-KO \ \ \06\ #`\ d\ 
\ [> <\ Ɩ/. e  \ p I \ /s  \ c\ \ > \ <Z  i r\":\ \ \  }Iɮ7QT r  *\ _B \ \ H :  {g p\' { c,    1\ xv j   \ E\"\\ \0\n \   k&#  4 * \ \  * YI\ )<\ \ \ |\ v i-\ * \ \  \ EbCf 2 \ ^  5 2 ̖  \n|\ \ ̬  # * GR|{K[\ 2t  = yyY £ &\ 2^ݽi@\\\ H#\ :\ HI9$S  \  MCC {\nt &\  *iֲy.]sҘ tQ +bD \ @P0ǽ-&)h
	K\ P   K EQ@
E%(\0\ J \\P\ X# m   IU dюNkf\ \ o-b E*  pQ @4M (  \0  (7\ j\ z܉?(\ ͮ$ \ ~y-O  خx\ \ ܟ v \\{  \ Zzp \0A  \0{-  Cg xjݛ d8 +\ \    \ \ \ \Z 7 \ \  \   R(U rs \ \ 2 H\ Ր\  \ AU| Y\ ou  \ A`8zR  \ u 1\ \   GT} +\n 5\ 3\ \ jU^ \ \"\ vt  \ d\ \ \ \ HWh\  W/ ^L \ \rl\ .Z9? [   	q \ }} X~_   \ A4  ,n \ t *O     v \ 7~ybG5  <  6\ 01 \rR     \ -\ *\ \ \ Gg q dd?B1UL\ 2i  F\ tX \ ۊ  wCQ[ö\ | 9 6 \n  \ A\ ( \ ,i FjîH [<\ 5\"1~  m cgF#\'  Ӫ\   Z\"I QSQ\ j8 DKm\n  c ñ ˝J+y  aQ\ g4Iv  מ  w  I Fp\" RmݚlT ּ ?zy\ *6\ 
% a pM  I= U\ \  % ;qPYm\ \ q\  ]	G` sQ c`$ 4\ \'X 1\ ^* ۋ  \ m\ t6\Z3
?*T	)8\ ǭi++\ eͼ \ ꛂ  \'  5ҼH aֺ W r ee\ \\cCT-t  C q_ \ J2B$\ 㺌 0 \ G;   s\ #r\ w8\ J .V+ |   zS#  U b\ o+#=\  \ \ \ &I\ } %  VS 8\ =*k   9 !OJ_(8P H\  4Z\ Iyv\ \ 0u  b [ \"*K熪qϗ\ O?Z mbP	\ \ F\ \ \  j  \ ~\ \  &r  ^Y.  + Z \ I8\ ޹ƙ F  kKF\ CJ\ \ \'I\ \ Q\ \"d  N`& ]    \ ꧯ\     c\n} `\n  Cޯj\ \ *  ] H \nυ 1     \ 8 䶚l 0.\ \  kN[s`X P c\ \ \ ͹\ O  PpqR\ \ K  ,  \ \ \ 52LZ    !\  >l \  \ Xz v \nyjH#! \ 9  : } \ :  \ =) ͩ\\֙ p      \ \ \" K \ ?xU  enӓ\ j+ *\ \   PX g ʠBP \ m b=A v 3\ \ 9\'  y5FA\ > e\ L <\ \ d \\ \ \  U ;  ,d` \ TE\n  槆`T  \"   \ \ \ U! q  d\ S    @a\ s\ n  nϽZ  \ G ȫ  cY8   i\ \ K  ݁\ RC*ʡB ؁M \ 7v\  \ ^?\n \ \ \ 6ON    6#  	D ħ    h혐OCY3_\  \ \'z⦳ \ \ S\  gg  \   @; V  { #o\ \ \0 \  QHdv }\ \   \ T10 )J\ F? ,g y {v  y \ \ FW[ I\ J\ /  =\ \ !     \'mJf  0sWV\ \ \ TZg\ \ \ !\ \ X  
Aϩ oQ2 \ RB    \\\ e p~bELci !==\ \ ֘\"MGE K  4M$\ \ *\ \" \ \ IRp} 5A O o! H<⣹QR3N\ \  p>@X \ j\ w,.W| \  \ \" (~Z  \ }(`-\  \ , P Ҡ r\ {Չ\ i  v\ vֆE\"C t X y\ N \ Z K7  =+ s \\\"9c  \    s M\\\rMF\ + ^\nӊ ̰\ \ n;w \ ^  ZRN*% L\ZF\'   \ 0]J\ \\ \ j[ @ɱ`CީΈ?\ \ \ qU  >Nz\ Z\ Gi k\   E3  \ \ \   \  b\  6\ +$l $vm\ k\ b 
); Js \ FX u\ E sҴ\r[Q\ 5  \ \Zf l\\ \   `q^ \  G_
  e \ \ \ZI
\ w /Bq\ \Z  \0
  m\r\ hT,Ä  c> ޵  u  %ܦE  \ \ y  u \ \ D\ZΙ ڍ D IWD     \ n\r@  V\ l K\r\   \ 	? ppC\  \ J +u\ 4K  a m\ 6	>Ջ C\nK  \ \Z\ \ \ $\ M R\ \ \ \ 4 \  \rFX\'
 \  VoB{U-:\ \ խ`[X̋.\ 0\ \ ~    }Ü \0kxr[ d -j i ̦r +\ A Rmz \ \ ^?5\ q\"  8\ \ 5YY 9Z\ %A\'(  = ڼ_\ I\ +{M\ \0o\\Ej\ yL f>\ & \ ] \ m.⾆ f \ Ȱ/ Ӟ 4\ \r4#    \ \ \ ],c   \ \ ڿ 4 \  Xȕ   \ oB  \ \  C\ k\ [m6_:\ U2# y  TdՎ  Zjqƻ JƬ\\FGp}Oz \ MB\  \'\ 4   l{ }\ C  \ [\ %\ um;Sf =̒F\ \  \0#\ \\v   \ q * 7   \ c ^\ jx Q1\ $Qlc- \ 9_D&t\  &  ž - \  !x g  W \ ն =Ž w\ \ Y \\\0 \'\  f:|\ \ >䋑$9\ On \ h\ \  3mB ܡl` \ kZwKQ3  .:  \ \ 
E%\0 Rf \ \ Q (\0\   PE \0 QFh\0 ⒃c   j\  \rv \  R \0 ~  \0]  \0A  Î\ \'\ 7ǈd\\   \0: \Z \ \ ת\ = *\   f \ Z)3Fh\0\ њ(\0\  P\ E%\0)  \ 1   \ \ \ _ά\ m c  4\ \Z  q\'  oC\ ޻4 q\" -Xq\ \'Y5}[\ wڇ u   \ ,)#  p2p3^ { \ j	\Z]G\ ,R \ 3ї  SZ Zk) ֯a\ m\ 4\ K \ 2   \ yP\  |E  \ 5; \ \ .  \ /!\  ࢌ}k\  * \ ֳsy( \ FX \ r\n0\ \ \ $g ޣ       \ ҽ Ŵ6  HP \' p:W |Jе-3\ w Ƌ s+\ l \ \0 \ }\ d<\ Q$  P  *O1	g<t  Q\  e  #     o1W\ C { W
\r F
0\ \ ޫ\ \  e\ ==i\ \' 1 S PƮ \ \\c\   
 `\\ N\  v\n , [x#\ f  A- i_#\ \   \ [\ \ z\ -B\ g\ H\ \ @v   6P\  9\ (,\ \0ݜ V    +RE(  \0Q@    (\n^ ZkءA4| )   W;\ }V[`M  <\ \ \"HT\ \ Rnñ\  \ PY^
\ w(\ da 9 )~+ص k  \ \ ^\r \ \  kĿN ַW0I\0,#Ipza  s! ҵ+ l X,  r   j   U\  Oc X\ s+   ;\ f\ \  ⼖\ \ j)#B.Ra\ i6`{> \ \   T 3\ ڜ oF\ p\ 9 L $W) ψt\ bG YH{/      S\ ~%    \ A   \ $\ \" 9\ y?J \ m\"\ \ \ OK   \ \r4\ \ 6 #  \ 9 \  ǣ\ 6 F g\r\ \ NE\ \ \ 	 < ry h	, 6  Y\ Cj {خ \ [\ R\n    ע S\ ڳi t\ |r\ M\n \ eG z\n {7t\ ne\ \ \ \ n+;m u\ pO\ ~	 ~   jS̗  \ ܏\ D1\ \ a I݃;    \0}\  \ \ |K i \  Q ̙ \ g=  X\   \ \ ; n  r)  \"   GEG
  + \ t  \ \ # w \0  7?v\ \ \ u\ V \0\ \n A\  \ l\ E\"  bx˻\0#\ ^  J \   V H \ Jܩ#  \  횶6  7\ ^/-\ i 1 zv j \  \  g   +\ R%X۞   \ \ `  1 E# \ \   \ {\  \ ? ?W gP \ \'? [ k gj n J   k a+% X  s \ q~ Mu\ !U  1#  \Z \ \ \ [J Ɲ8  .> Ucz\ T  Ō 2 *G & \ -   *{lA      =\ L \ UR0\ 9I\'\ C B\ \ \ U\\\ ~4\ )NB  \ Ĥ sP0\  \  p  Ѝ6G(j&~~\ \   5 l[y H MC\ S \ 5XZ] a 4 T+ b:zSn 6\ E\r\ :U9\'V\\\ Z\ ܋    S׌\Zλ +H Q     \ \ Xw  FK _3#    F4j[RB2  +[M\ % yL  \ \ 4\ y 5\ < \ ^x ]F\ \  qF \ 2T  \    K{<\ ?\ \ T \ C߯ȡF	\ \ 9\ c\ z\ rZ 12Y \ \ \ MR _ \nǸ  ǵ% \ ,mɨ\ c&6 1\ {S  k,Gh\"S\    i3\  ݞ	\ Z) ,3\" \ 9\ \Z T \ * \ eiU$v\ \ wf m\ \ G\ 
e\ 格 ;Ia 2ǜ  t w\0H\ d! q\ J\ r\ \  M  0V\ \'<}k>kT $;  S\ B QNFy\ SM g   3  \ SI \ #f\ *   \ \ Z 4 Ws\ 貨\ h \ \'\ \ A bedrqT\ P\ U\ \   *\ l\r om   \ o  e A N\ h\ +,\ \'   \ T\ X \  \ ؚw\ ^\  \ @\ 9 \  L Vؘ\ y ے>lz V]\ \ W;lԴLG/L  T\ Ş\ b_yc\ 
  \\\ e\ fF\ \ ASj3F\ \ n\ \ F\  jM&    \ k\\\ \ i@?Zv \  4 byZ  B-  sp\  G]\ \r\ r\ S $h \Z2)gA \ \ O\ \   cx5 ;\   c   \ \ \ f\   S- 8\0   ̸D S X~\0\ @ \nJ\n c    kE C d\ZVF<\n kd.\'\  [\Z  \ #0F \ 2H\  \ 6C\ \ \ i\ \\[ā6 V\ >  4h \r\ {  : Zַ  LS3AEKb   d\ kV
 mfB \0CP[\ 2 / z S\\\ oqm\ ȋ !  ? z    A# i\'p- OQ   \ \  \\\ K \ ҵ  \ \ \   à z  3\ Aq	hd*  $\ i VS\0\ j $ v  0\ \rh\ Mim\ \".\ \  c \rԟ^ ^\ 1\ Y \ w ҈\ R  \   \ n&2\ N \ ir  \ .6apy=  \ $\ )\ ֯\ :\  zVZ $ O\ 8\ tEhQ~\ \ x.pv  Q   \"D=\   \   \ \ c  \ Y.Xl\ \ 操\ a I\ ]\ #<  *2r \0 qOh\ `  ?\ Uv \"   \\    0\"E ljJg?-X |L\ A\ h\"G ;b  v R  g& \r\ \ d\ 6EM l۷    \\ e\0\ \' jX:\ $ \' \  $G  d\ ;  ;eNv\   \ 702   T  ea   B Hw $ l t \ \ \ 2\ ֜\  \\ $\ \ V f <ch; CB^ \  \ ҡ   \ 	 A!|\0=\ E ?x\' D C O \ ]\ (\\l\ ކ  m\ > b\ c Ix S\ i $  \ B*\ v7&\ =A 

I\ g\ 0\  RƎ \ \ Zn ѭ  5\ &5 W 9     ]\ Z  3 q  U\   -;\ \r} \ *4jJR\ \ 0 \    k \ b_ \n#\\(\ \ >  Ve    \ oF qp\  ;  \ a]  </aie \ \ s\   x\ C .FU  Oι { j o   & /  }*\ Z   \ \\h\ >\ s*M,c p\ -
\ Ս4  )%\ \ {\ \0\ A  |\ ; ҭZ갃$6E\ \ \ ݎ2\ = \ \ |3 |I = \ F\ \ ۰ \ [ :V\ ηg   }F=:[  \    <#G  \ y℉ \  ?R   pY\ wym`Yf   0 \'=8\ U\ u \ kP ?˶  \  1 ^7t\ Տ \  R\ <Eu ]\ c \ đ4N y\   ޭ[  \ }94y ou+\ #[\ ˇ-\ \ :n 	e\ & I   \Z յ\ \ {.\Z	\ \ \ ?{o  z\ u  e2G \ Z I0   \ \'\ Wq x.\ L  V\ \ {i\ >\ \ d\ ~  /H  \ _   \Zi \ -\ \ \  < \ M\ 
2i \ ʰ\ .\ \ \  l \ d:8P{7  
\ \ ښ\ zO \ \ P  \ \ _x2\ \  zeΕr \ 3  c\ 9\ Y  \ &\ \ \ \ \ Z-\ \ ( 1U\  \r\ \  \ z\ \ ?~  o\'-   ʼ?B\ n-$K\ \ {i Uݖ|\  s޽WJ񦝨^\ `  e\ A \ \      gCE \ ElHQI Z\0(4i2hqE&h V J(  4 PEP \ ~) \0\ 2\  N \Z\ k   ?\ Of\ \  \0e5\ q\ \ >\ |S l\ \ ^   nG \ \ \ ?J   {\ZU\ ZJ> V 2 ))\0\Z \0ZL\ i(I   \0*
\ Ȭ  e`pz J  j  n `BGFq w }\ ` J \ \ \ D  ̲\ PG  \ o\ [ \ / # ŝ ݾ\ }\ \ NN;W ~\ ] M=\ Jǧ 7  \ /r sּ OK \ :(g \ f.!26\ w\'  ;    ^\ [ ~ wG yV  w; \ 8#= u 7\ =   Eh x| \ h  a\' W<t  y % v\ v\ P\ \ Wˉ\ 7\ e    \ qِ\ \  a Q\ =\ $ \ H\ b( \'x\ G x|\ w \Z;\ l  #   k\ o\ ͻ 2\  @\  \ S $ f  $\0(;\ \ AU\ O!) z޸  M  cn;f \ ,f%~_Jk\ \ g \ .&1 )\ W \ @^fr6 OZ  \ B\\ O=\ \ 2 &\ \ Y< Dʬ\ 6c `\Z \   Ǡ \\   V=\rTyU   \    \ Ѻ3E! \  E&)y  L\ \    J\0 k8\ .\ > { }k    \ \Z  G I n a$   \ |\ Y B\ m  \ \ p <H;\ =\ \ \     42\ $  \  \ \ I  u]r \ R \ \ \ -Uس@ 1 w\ b\  \ ֹ|  3+<  \ ۥX N   _h : Wq\ =s\\  n)  \ \"  on ٚ)ʖR=F;\ eya \ r \ S\r\ \ @9\\\ $\ \ c\'֥ mp Fuq \ +i  \  ?i  gcT`y\ j\ Wv˒  \ \ jU  yH\ y\ 8W \ \ >  g +jVp۽\  }\ & \ G k\ \ }F\ 2j \  -\ \ Ձ\   \ \ \ \ \ lb  RA &\ # \ ~kl|Dc Ǥ\ [x  U 
U)\"Yꍢ\  >T\ a#T 2  # T\ \ y;  w ># Դ澁   A 7  \0Z J}s \ V \ ${ \ t-7ޅO > \ \ PX\ \ \ ng    UKU\ x 6= թ!4u\ ;b \ l \ 7ɖM  _= \  WE  VS zZ M\ \ \ \   ۮ䷕${ \ 62p \\ +\   q s Gj \ M <n\  &   \ v  >j䁳;\ z\ C \     \ _ G: \ \  \ 2\ \ h \ M\ y n\ \" \ \ ;+X  \n  F -\ -N?\ ډ|(\ /\ \ xRZ\ \ \ A\ { \ \ \'«  gPO\ ^%wq\r -  \ cV<\ |  Fb\ /.\   O\ R ~8b\ aV\ \  eC| \\2!\  ] _đ3e \ \ gQ M s \ $kw] IW)m3 2\ l ƺ\ ۂ6 q\\e ͼ \ i\ ~\ 6	Un\ Ah\ O΁ 	\  8 \ Aτ \' f zxV 2y\"  c  fԙ  Xz* 적S\ M\ %A\  \ 7AJ     \  3VmWvp\ cҡ[y = V% H  h\  汫+# )  ̈ř / ˙ \" BI\ Ւ #\ 9
 sްo.n*A  c v I% $f {3\ o ;S\ \ \ A ֧ A\n  X@\ hm\ \ XL{ xrK \0J g v	 ֟\ %mΤ}\ jkyb \0/^\ @\ pb	l\  ^\ w ̅0\  b O1 Vg\ \ K\"ǐpG \  \ \  -, b;U  K岉F\ gs  \ w\   a׏ ;\\f _4\ \0 *\ { l  J  RU$\ sN s#OC   D    \ \ \ \ \ *ɒ \  5J\ \ \ w Zr] p{ \ `# f tc!OJ   \ =\ 	\ 5\ p\ )  26Ч\ L\ ֲ 
\ ,zb ,  \ y 6.#c!q x4 \ VR  qɫ\ \ \ qn   8?ZǸ <     \ \ yGosJ :\ \ \ \ \ ;s\ ] Q%\ #    2\ g\ O
    f 5\ \ gۻ/\ Q \ e\ q\ \ Y \ 1ǩ #yۺ),\ \ M+X
+z  M\Z #h\ Q  |nH\ ^  \ \  \ \ Z t C2wt&  \ \\ N \ [5 \ 镕  ۞:V\\ `\ \ Oc\ \  v\' \nM# m \ Uv~ \ U\ d `>Ӟ} ]E m \ c=9\ k> y \  1  h\\ /j \' u  .gB6 \ \0\ A    \  4 ^m:WL / ⡡\r
 朰9#-\ \ \ q.\ uQ  K i\ h  \'\00<՝[N1\  p (\ \Z/ш\ [ ep \ ,9\ kF\ N @ N\ \"	\  \"  ӧ \"iv #\  V[Q e\ I\ \r \ \ :C*:` >   0:Ze\ 7f=  \ Sǵg p    \ i\ \r!  K \ \ \ :\ 0 +;t=}) \ \ \ - })$ S  J 4  (d \ \ \ 7v\ \\@  ȫn  j\  P  \\
\ | p 2\  \ RO \ L\ 4Sof\ q=* ȣ a T\  \ @+d   \ V\ eHH  \n \r\ Ƌ: GC\ Z \ ˖_ Fq\ U.\  C +\ ҄\ #&1   \ 9B[y    \ c Wl 5n9 Ѷ=y\ z  3F)  c @\ VUݟ \ \ \ d\  [\ #\  J 3ޟٝ a\  ;   b* ]  =ER \Z)6 {  -ز 1\ T  aHY _ t# 6m-|  fZə]؞=*ݤ\ j \  R\ T2F[ p\ \0Iʜc V \ l \ c C \ Db \ \ ު w X 1  \ h p\ [,#\ \    X  ST<#\   I \ Y\  + pG  9 +_\nk> ^\ h\ \ZH#- \ \'\' 4  \ Y^ } -4K  b <\ T\0u\ NO  \ \ =.-/E ͬm
$ I)*\  \  k  \  }v X/\ a  9Q   \   ᅥ  [\ \ S   `e L \0z  Ԗ :K\r--$  ϳʲ  lϼ 9Ⲵ\ j{K . UR \ \ <c< Wm\  \0h 1   [ mu[Pd}\ p  B=\ y\ 
Z\ &\ ʄ #\ C\ZgK\  dR\ Pyn  DB%b \ \ `s b ƞ3\ 扮4 \ [   GH }  \ ѩ rk\ \ ҥ  u \ ;  n>   d k   \ 9\ \ 0  > \ ][Q  \ \ p[q\   \ w׷\Zޒ f\  ţX\  [ē\ \ \  W  SW\  E \ m5 g4 bD = \ \ e\ ^\  j\Z6 wk#\ ;.[ w\\q  К:\ <M _]I\  :\ d\ dU\ w$ۜ9\ \ 9   \ \ \ 5Dՠ\ \  +}\ \  ev= \ \ \ xdh \ \ V\ \ \ +      B \ U i   x ܶ ަs&ǭh &Ҽm\ ˸/\ \ ݼ I\n.Ǜ<\r   7X N ,̶  K0ي\ I74+\ zW$D\ |n  S\ 3|\ \ 9 ס|:񎤰5 ͽƨ 7\ $ o. O F#3\ z> ]a\  \ ˽8 \ \ Ɂ R=> \ \Z6  p , \ ,\ E?\ Mg b  ԖcM    N\ ԣP\ 6 ڵ ,\' \ )3El!h  \0QI 3@
E&h \ &h  њ)\r\0- f    \  )\ rO\ G 5\ f \   [ ?3\\  \ \ a\ s  C\  .  # `5\ !|M {  {~    P Q +S   4P (qE \n\r   Z@2@  \' ƫ W \ t *; n\ 7 V*AI\ % Q   =g4\ \0 b2GJ \ O \ 9 w(,`\r TE  k:\ \  n\ -  9\ j+7Z
  \ M    \ w \ \'XT\ nVle  9 \0¼oI\ Zг\ !ri] } PjZ  ,gV\ .\ N\ I[* ( _ \ _&Wrà \ MK\ 7 G \ 9ɼ9$\n\ *B&  PÑ\ 1\\   \ \ y 	 b\ J \0J\ 5 B_6e C\ 1<U xd \ `$\  \ 4  D .ihb\ \ \ vp\ Y\ \ %m \ 07n  g \ H L+4;\  s \ һ \ \ b %cm\ u\ K[y\ Y$ ]ף0\ ߥgͩҠ\ 8 sÑ 9&   c  \ \\iW\ M\ \ 0UB99 m 8g   OL 8 _P \ N KV    \ \\\'c  /x -J\ \ n \ 10 \ ҩ*c \" ?h w W6\ Y ,L c޹ g<  p \ ` s\ o]\\\ - K\ w )bH\ {S o] \ \ Ӭl\  .|ؕA=  ur \ >\ \ \ ԛis\ \ 2 \ P Z\ dd\ 9 \\ 6 }o\ : ;^G \ &  ^Kz t \ \  o   o$   \ \ \ = t\ h ( Fx\ O     ځ\r T & G 2I\ \\γ\ -6E  -\" \  ! \  )<Q\ \r2\ [{  c   <  \ S[    \ \ ѣ\ \ \  I    ⋼ ael 1 ̲ w .\ \ yf \ \ \ F)-\ g \   \ ɪ \  ^\ y 4 [\'  LW)= J[8l \  f \"\  0EgyJ .N@ Ų \ \ Db\0   Z+  1   3K\r̮\ 77\ 0q\ Vro  2m >oJF H\ c+ LT\ \r\ ˄   z   \ \ \ c<f  d\ RYʩ.vv < c 8\0u\ Z  \ t\0 \ 4 ,3 \ eI\ m!Y\"Ԛ  I\Z. \r-  sixXH a   \ Cw  @\  ʑҙeg%\ ®\09 i\ 	\ n  jW    V\n !f\'
\ z u |C\0 \ $ { b [\ < 1  \ zW jw   \ F  xa\ E]\ \ $hB  0 hM ;\\ /²\ ]\ \ %ŗؼ 8 \ 2; 1\ \ nտ i R4 \ /p$\ :> + ڕ\ o \ \ \ $ ̺  \  )\ \ k״Ǌ\ \ 0\ \ l  /z\ , #  \0 m\ \ ,mH\  Wk\ +  eo  \ \ 㵫}g ˪m\ ;@ =	\  E]\ c\ \ _  \ A\ :\rx\   \ =3^\  .O x\ x\ \ *  9a Z W B\ v& R8 4ԚfB \ \ \ o  \ σ   \ \ r\ ʳb F \ \ \ \ )\ |\ k\ \ 8  \\ iF6z\ >k OF\ \ ij\ $  ?1 ɵy Y YW\ P n{ \ \ .
v!rI\'5 6 c itji \"\ Ք y   Tv oQ ri T   \ 	 \0    ]\\ s r+H=N,b \ \ \ u%  d\ \     XrT )  \ \ t\  _ _ g=${Xd $e\ y\"I\ $\ {zm xʂFEHV5ޤrzU VH\ p9 E\ tEXϼ >F\ c  \ ;\\!Q g5 r \  Ҝ  TKk-    \'\ N6H X\ י   {pn  z\ \ ]\ p\ =\ W O@)  5  1   M \ $   \  P wd*   Ҩv\ T  Y v>^\ :V \  5 U( i , [    ŅK\\   q wrс \ :EndvÓ   [   	\ s\ M\ \ 11 Bjf\ 	\ _Ԧ\n\ B H\ U\ \ >  @0!T \ =i3 F}\ L@`  R S \  \ B`  Ug\ 	8   \ r3\ *  I?QJHw\ $ށ  \\  \ J h \ ) aF\0 QMb \ \ h\'?1\ Ӣ#9\ >h	\ ~4 $(Z K %  \ \ \rNc\ 2j U1 hL	     \ 0*R  \n`@( Hap\ W\ \ \\C \ +\ g eO #1S \  )ߓ U  \ < s  \ ` j\ \ )\'   =\ `G\'\ \ \ \ ; \ Fd \ m^ rLc;z֍  e -t\Z\ \ S\ a4\ x\ .>y< \ \  PY\ \   ϸ \ 綎 (  ǽF 6 \ =EK\ 
mu  s \ p    \ \ \ \ \    \ 7 \ z\ \ l g8 _n  y\ Q
L\ ʢɕX 5(   GZ \ c~>    [ \'\' PX  \ n.\ \ L   \ 8  c\ Q 	\ \Z qb\ >\ \ 8\ ڦ OǱ| @ UMBQ	\ \ ֚nf @   * \ ɔ$ \ d\ \ j& ^o6 A\  P  1\ \ 6 zjF \  | \ l<dU   \ q\ } % q\ @\ Ny L/\ FE4&k#? Gpj5f  ~ i\ >b\' Tp\ \ rԀ   Y 7`8 &B 7 p P֑H l c\ B` \ Y  \ \ U X  P}\ ?ș
\0   IR&;} \ M bg  ȍ \0zT   = : ʹ\ }\ \ \r a   \ A@ o3\ ֈ\'X] \ O z ;p\ p I \ f\  @$ \ Ž~RNqKa- \ s   sңI@n\" I#ݘс\ Mg \ \ ! T\ t  \ \ m䷾\ \ \ 7\ zν\ _  \ %Y/\ZH- Kf\ \ \ \ $  +\ ]\ wzD+op , \ ~`A  n s Y = iW\ 0 \ [ 6 :c JM :x-y  {Ց   \r\ A錊\ n \ I# # 1!\n0p  \ [PCo \ #D K  \ _>#A i xf $  񔑳  r9  g K H<Ow iq  ܨq       k[  d k 7  \ \n  ~\ [N k\ ˖]\ \ 8# \'\ \ &\ E o<  + X \r   z Y8J   _\ \ \ZV < UU  p   KV    c [ t 1\       h \0 k 6    6  \ u * } z뭼	#h \ Q  \\\ \0 + KsUa ce \   *   \Z\  9\ \ ^\ \ -\  Z
ܝ\ \ \ \0\ \r3R\ m /i $ [4  \\\ \ \Z  K\ \Z  \ M  Ha! Jn
L\ ˨nA$0 y;\ S  >C \n[ <p1ڹE  V Z#\  \ \ n*A\ ޻m[V\ Ryt\ i \  wt%gr9 Giu 
 k +  H W\ ={jSM \   5  \' T  \ =  о\r\ \ M% \ \ /   ia\ (\ S\ i jiF\ t\  ke g\  \   +A\ ot}M\ \ 9\"w  ,}\" 0qw\ M= 9 C6 r*\ 漷F \ k ol ~q\ G k \ 5 Mvx+ މ οQں\ $ ! Y\ KIޖ AE Ƞ  \"  \0Z)	 \ \0.h\ %\0   \ %\0QE%\0-q?A66| N=s\ v \  5s \ } u\ ks\  \ Q  \'e dXv [ӯ \ \ \ E h.m 	 \rx  m  \' H\rz  \ K8. 8#\' aNN :j$\ oƦ- \ 3 A   > %W{ x\ {\ \Z RI,\0 /U )q \ m\n @yAbG n\ \ :W\ \ 3\ Ep     [k  u\ \ \ hShF  \  \ QQ o=Ԝ \ @  \ \ \ P!h\ D ;l \0t *  ޕ U\ ־q \\J\ *\ _ {~k\ \   \ \ ~$c\'  g\\a  \ \ Xb> \n  L XCK 3  \   8\ j     jrK5ɭ  \ r\0\ J \0 g\ \  q* \\r:\ \ Y6 y \ o >N\ d8uS\ 4\  %Ԃ - % \ZІ6T v	\re\ \ vsJ \ \0\ \ I I i\ 0Ӑ8\   \ %8 ]u2`+ 砧 a  *{  C  z  ,\ 6\ ZV\ N  q$ \  \ e{X q\ \ \n@-\ \   WT       8# M&  ]\ M& }f\ \ ;cwl{{V    ١ \ \ \n\ 8   \ G5J \ Dc\ <7 F\ 7c <UC\  j\"ޤo=; k  \ ~\ \ Amq\  񟖹Yf! \ >\ V h\ \    Y\Z0 \ pC  u3D U\   SA %uE <ޙs \ U\'8  %y {Cyk\  췽  \'\     يn 48 J M:\ \ {\ kl\\[ex r[N1  \ \ \ \ \ Zr鰵 O,    g A \ ; F L   \  ~( \ 9QY]~n =\ \ M r !g\  s\Z  yዴ  Agp\ \r \  zS  v  P \ \ H  ;Ķ\ Ai3$w2  N~a\ \ Z \ 2[   \ ڝ\ ǆ c Id    \ ]I\ \n񩤑[\ *q^\  G\ \ e  d 	    ~ x  b z   [\ g }~  \ ٲfU\ \ P\ w\ \ \ $ \ ec\ a[ z\rű/\0i\ U\   ٽ\r&  \ x W ϵ \ ER\ ]\ \    c%\ \ *c   Ԗ 
m \ W 7Z\ \ %qu \ _
\ \  y\  JW     \ X D ] _QC ֠   1{ \\o  c` )\  j   \ \ Z \ \ $  0C ; \ K 5ݞ < \  37ROj\ \ o$\ o+ $  |\ ; \ c  څ`L \ \ O }   w A) q 1 A\  TPʑ \ p$\r \ \ N \ k>[vYHR~ y8  ] -\"  $ ) A \   ~B   \ ^k\ 7 FE {\ R  z\ \ <
 b   #\ VX >yV   z  ӓM k i\Z\ \ Aq* \ ]\ ? z\ >\"\ \"      λb \ \ \\ 3\ N1As    \  y\ \ -` (\ T b,čۀ$ \0k }21 -  s4\ \ 9$ \ {\ ҥ 
G Z \0c\ k$W ;I2\   \ \0\  \ZMB)a \"  \ YG[\ ҝ \ H  \ >̗\    \ A@s s \ sZ   \  w I- G\ D \ c>  yW ʉ Rx    \ $ X {}\    `v> \ 5{]OƖpL\Z3 { .:ס \ w
n    &rk  i Ö \ 1O RoW\n@\ \ s  \ J\ \ n5 m \ \ \ P    9rʀr[+HN  (\ R  v \0 M\ $    : \ Q^ Dp6 m G  \ ;][N \ \ 9 \ \  \ |  O\ \'߽x \  \ ^3  A  #)\ Kq i\" \ w   l\ \ \ e\ \ \ Ɇ	d  \ (\  +CO\r\ rI#G   o  b    jr  | ^\ \ \ \nm \0\ 23Z   \ # \ @  3ǵ z\ \ 6   }\ sZ\ u Ɋe#kL\ ү6  \'  \ \'\ \  0 MԔ6T \ Lӣ KF\   觻< o\ ~\ m   * \'<zU& c\ \ G ⭒ \ S5 \ a\'   J $\ 9!Gz zP E$\ j㪮Xw   - ZŦv& + \ GP  > \ \ r     V\ \  H  Y  D  Pqڂ 3Q0~vف\ ֒(w a\      o+ \ 5n(dH\ \ ڡ~}\ \ j *\ gE8Q      ,d u I B9\ i\  O\ n S\ !@డ\n\ \ \" < 4   Ǯ+ \ m  V \"Ӵ\Zͻ +#
 㡣 v(\ h\ \ qU  I  \ \ <?{  \"0o\ rI ǭU\ t\ ,$ky\ y    \ \ \ q AǶi  }   \ @(PM٠\r/ ,i ?-ֲ\ ;\ gw=jf; `d\ x!    \ U, \ Ojr ߃  \ ih 1\ \  \ B \ \ ִ\ B     \ jNVas Ug$ #4\ R[Eo6 \Z\ XI SʏJt 5 \ L   \ \n SK   \ 1 YA EY P17 \"@ \ Nj $ a*9S\ $ ,   <p)\ \r.n        T\ ~\ Z  2 t\ $ 0\ ( $M- ^7\ g]\ \ f\\T \ &%d8\'  [ <{63\ \ 4l)   \ y<  ,@ nKw `ΤB[ \ = F ܦ6n>  \\\ BA8\ R, H 	 T8    M\ %  q \Z   k}$<Wҭ  \"  - 2zVV\n \ `\ .Yv q\ +\\f\ \ : ޥ  @9<  \    \ \ \ I   ,Ib\'/7q ԎH  @Pdt>   H \  QI4 7 -  q\'    1%Y N   Q7 X    \  N\ 5\ \ \ | \ U\ \ 4V\ \ SX \'   \ b
\ n2 z\ \ L\ ag< x   gڌF\ @ \ M ഊ\ v\ $a\" \ [    D~V m\ J 8\ -\ ֬ Ф`Uga  \ =x\ LdN} \ $g  9+ `\ T+\ %p \0/~\ ,   = TE\   S\ Gs \    T n
,x\ 5 /
 ڐɘ \' ,6`.s \ w\ T 	 \ Y rI.w \0Z f ˸c==i4+\ | X n  c2 ǅ\ PLwc F  \ \r;յ ) m {{U 9
  \ X 8݌zU  \ $^\ E+ *  h\ \ ۽D, ^B\ \    \  \  \04 \ U\ ^y \ \ GO\  \ EƌO ~O갫\  \ F
\ ;C 8 \ 1\ zې   pe\ % \  %dX\ [ U\ OƮ \' Ԭ obYi\ L e ђ \ 1\ W \ \Z&  A jsG\r\ \ 2o Un\0\n3\ z\ R:  뗚    Ո\ \ 249 v  \   W \ igR  \0\ SE殣y( \ \ \r  W[\ o z    \ ҴƋR 9  Y}    }*\  \'O H\ ˧B-\ \ Hl    ri \ \  }_\ ~\  \ \ B5\nJ \      ş\' \ \  m&2|\ @#  z  \  T  ͕Ҵ VŘ\ !$}z  I584 (\ \ uX g \"2\ O@y\ \ KR 1ᖵ [\    8UDq\ HP:c*  wǶ \rR\ GVܯ#&I \0 \n\  bmF6[9 \'ٍ\  מ|r ~ [=7m\ \ | \0GP=     g\ \rOS7 A Mk4 \ ô {ekCѼA, vzt\ M\ \ O 2c\ 9\ =   ] \ \ \\ Mf He o =7c W \ suo \ Zlq\  b\"\ E\ \ \ \ E\ \ c\ # f  YD Eh K 7R =\  Mi\  N 
 { & \ * L   \ rj   Cu+\ X\ @ 0ٿ\  e3 \Z\ kI . / gXrv \  \' g)>\ rf \ - ٠F  b 8 d!\ ==  WW\ t\ \ ŵ 3 c \   =    u\ \ [Y 6  cL? 8\ Z %\ t\ \ a X  U rȠm8 t \  \ZJښ6 \ % X Ӡx\ l*2 =\ Z\ \ 
<  πX(\   ,0 \ \ Y   \ Ɋi3Eb\n(\ !u_ ʿS@
Ec\  \' ў$ 9\  p   qT\ \ v/ U \ \'\    ̆ Β \ >&ӂ  \ C Q  l ݎf?@)s  6h  \\ j\ \ \ V\ \ W2 7  \ )9  \ G5\ 6  ?   \ \0 SU   \ 2\ \ j \"h\ \ TBpj} #=j\ \ Z@Ҳ\ \ \ f& \Z\ iȍ6    pkǧ ˢJS \  N? R \    ze\ \  \ \'65ݭu Imc k cv *[ r  [ 5R	\ F\   \ \'\   \"  mZ\ \ ` Kg9  \";l\ B \ \ \ T  ̺K,eb8  B=k  m\nxsN }R  \ q&߳ \ A\ : \ !m Q   })4Լk {\   |\ ? b (     z_ e:݄ rK&$\ h  \ 0a     b8S \  V9[ !S4\  H\ ? #Y 3 $u=h Tĩ  k\ \ \ c\' 8 Y&3m    ]  \r) 5\ e   ~IT \ +  J\    *    y3 \   Jj   \ \ \  :\ 2J\ \ \ eۙ$VM\ Ŀj   h\n< 6P 5O\ V \0g g m+\ 5\ A \  D tde\ {S iI	\ )\ \ $\ |Uv \ \  \" \ Dg  I  ] \ bH Ky   _I, N\    c[\ 0 \   kZi  8  |V  ϒ5 \ \ n  \0*}    3\ \ j\ \ \ G( 2O^\ \ \ =WPg\ k \ #\ dQ: kQB Lțñ  { \ \ \ 4 @   <;a ]  B J\\ zw  \ \ m\n\ 0q \ \ 5\ R\ \   \  ?  M/y\ \ Q\ hu\ ] ŷ $F<rT \ \ g\  Q1    R\ וj>ѫ8\ 4D}+\ <X\\c MiV\n\" \ j \ \ \ -3  \ 0\ ~\ h\ `9\ )e8 \  \ 5,XY \ bG\nJ  ] 0   T_  gִ,\\} 2 9QR\ \nMg~$PG q \ * 3hspkZN J\ 呷z\ =+d\ V\ ea@\ 1\\e\ \" \ p + F\ c QN R*: F aioo  _8\  0
\ }+ 5u\ Ԥ&\  5\  2 \ -nW\  L -\ \ }  \ ^{ww } 0 \ \ <>\ =u  j$2 T   \ ,  qt\"   FN;Ub	\  $ \ I` )#% \  5\ \ \ >  \ -\ t\ g  \ .c q\ j  \ \ \ v \ q2\ 	r \ m  < \ \ E
@	~b /ޥ  K  w    )ޯ\ \ QZ\ -N J {\ vd #1\ 9\ \  \ Z  i E G$k `\ \ Ҳ|3 EyjV	\ Ke\ \ \\v \r    / 
.\ ` \ &+1  T   OX  \ m  b e jm  7    n\ |  a\ q   \0 X dz\ v\\l F\ H \ W |g  {mg5ו$\  S \ ;Q \ \ \ wVm>\ } \ i|\ \ #E t< \Z S\ pj2 \ Mh   H     wĚ  f\ +J# `G +\ \  5皮  \  Gaq<̣l;\ 6\ \ {ԽJL t J Ӡ\  7G \ :6*\   ֬ 5+y\ ]Co K\ \ \  g  j  \ zM \ [\ # x9\ Bͅ% 9 G 5\ iz,>\ e \ sq \ UT*\ tR   ` \ Q隵  >  k \ \ d_ Z 
6\ \ Ǡ\    +I  =WӼ    I Y,\ w\ `On\  \ \  \ \ %  q A& lVG@\  \ \0    SNҴ s\\\ \ tXb   \ ?\ I \ q .9t\ N s Լ1\ % \ W\ \ Zy\ b ԍ # /  =F\rq\Z6    6 \ *ݦSnp  \  \0\ L\ ?  5\ c\ RD 3 \ \ @\n\ \    j\  u\ Oh 7 \"   \ e e ! p  56)hU \ \ \  : 0<  & \ M\ A\ \0{k  \ ./7  \ \  Z\ Y5]R\ \  \ W-;  8|ʹ\ v\ X\ O r_\\\ bg\'lO Ǫ    +Ay\" \ $ ;A \ l  eo\ # } Y\ ! \  Oʳ2H-   \Z 
\ I* v  rb: #\ K\ \ : rjWQ4R4  \ 8\ # \  K    y, 䵶\\dn/ \ i4   R \ \' nB\  \ \ \ |`n5i\ Y3 \ %A(\ YOZw \ 8\  [6\ _w8\  u^Ԗ\ \ Y\ ,  T\ \ j  Ͻe\ ip_\ X+^  \ \ #  p\ 3c ν  \ q  ^s̆  \\\ \ \ f  k\ H Fm 01  \ ^y x \ I\ 徶\   I-\ >    %\r \r]  Ju  c    iiy\ R ʈ\\ -2>( \ \ U   y b ڜ\ \ z}*  \ 1 3\ o^  \ \ i   V D 쨋\ 7 $   \"X \ $zR o  \ X  %,\\ # *) Z6\r\ ~\ e\ 2#    U^\ Y   8#oJ f	 vw \ ֥Q\ vY 2  }j ( mґ B  \ Y4\ -i  \0-! kZ s4{\ db rj\ \ j     ڋ Kո Q @b\nq\ Z\ b  < ( = *  j)l \ \\L ŗ*7  \ \ w   læ\Zr? i\ \ jԥ^ p<\ 0 _\ ǝ 6\ VK  \ x9   ׋\ zŧ\  -\  \0Z   ıqij[\ \\Jѻ ң(\ & :\\\ 5M $O wG\ / 1 \0 \ \ \ j  & \ \ZB \ t \0\Z #nV X W!y\ Eg]l L9    &? ~1 @_D\ <`\\& R\ ~  \ \ 8М \\c\ C \ ֡ i\   \  \ lG Iun\ +>\ ׊\ \ xW ջ\ JTH  x \ ]\'G t   \\\ \'<m=  ޺  \ \'MK9\ qH &\ R> \ Zz\' 4Vw\ S! 7  \ wi \ +۴
,( y \ \ +îc+q(\ #   a \ \ \ ^]\ sl \ /̸ Zi\ f x  2 8 \ W\ l\ m4 .gM\ h w \   \ K . glĲ?\ CzRhf[\ F  S\Z!\0 \ \ ڗ_2]XEp \ \ p\ =O    ìu(\Z\ \ 		]\ ^   0    FPt \n\ ⒑\\  \ \n $m>  \ ,E \ #\  \\u z\ H \  B 7 (\n\  ͅ4\ 3hmմ0 1 \ ,      .>L\  X$ϰ\ {b  ,  $)cӞ \ \ S! 0>bB   \ #n\ {b   \ pʤ W  \ by \nȩh\  \ I\ E  0\ ȧkua֩   g-   !I\ ]   \'m&      1\ 9  \ 1 n\ \  \'f/     @ \ \ \  9 \ 2  F  +  Ri \      c  \\p  qM \ e c \ \ \ b:T\ WH\  u5- !H\ pH\ ֏        bL z\ T\ Esiu<Y9 \   p  =+    G\ ; 1 -UԴ\ &\ \\\ 0 \ \ RM (\ !h \ 0N R Ё {\ 춉#h\   \\}\ jl p6  \ `  \ 2 s    \    = \ s ?ջ 1U ڣ (\ 2 :Ԛ  eݬ0\  a#:\ `O 6ԅ98Ǹ 
wLd *\ 3.\ $:\ v \ \  v\ mnХ\ \ \ I\  8  6  z5Y7QƄ*maި\ \ \  e\'  \ e\ v  _CT\ m6|\ #\ үA6c\ \ x\ Y  r\ ,z \ W \ \ R\ \\g\r\ \nR c \ =\ IW7cV\" \\ 硤\ \\ \ :ԟghd\ q RG   \ rs \  3(\ :q֬  6 U{K\ g\ \\\ j#g봸Va\  # S\ Z \ k _m&y Tng\0\ \ pMP\ qӯJc 5,)  A5	C\ \ \ fsH
2DJ\  j A   U iP\r \  t۸  :g E \ -\   eX  \ :U}B9wA\ \ ;\ x\\  	\ ^f]   \ 4L\ \ \ M \ N@ \ 9\ \ \0  \ \ E  ~ <x  ġ \0z\Zl[ 1SF ; A4\r XݥnA\ q־  K\ ;-7\ \  T \  \ #U\ 8OD#ھmyy_.\ F\  w _ -4
\ I O= \  \"\ [ S    \ J\ V \ \ \"\  / \ [̗E LyD \0  X  kZ\     X\ ae\ \ \ 1\ s  a x\ N[ \ 9ȫ [^\  Fe ~6 Z\ S\ H \ k+ |Y= \ ı^\ >IՈ- \  ȯ[\ u/\ :\rޕ  +r\ 9  ,	W .  \\O迵[  - \0+;g nAa׆u/\ q  E \ L  \ Tj2  %   \ /      \r  g \ \ P\ \ \0|Ð+z\  ~! , =\ \  =ˏ)3 [ N9ɮþ8O
i  \ m \ 2 V \  \ a  \  \ V \ \ c۬  \0	 \ P \ \ZO=\ @\ ԓ W   {\ k/    \ @+ U@\ \0= \rU\ w    RE BQ  VS߽r\ \ 仞\  \ [ \ M \ n! Q \" \Z\ v z \ _ ɪ  ) I ~  g\"V
\" nO r˞ k\ c\ n)%  E   O Yn/f I, B\ rs  }5 \ \'  i n Yݷ Me\ Z    MB\ Ke F \ \ \ \\ Zt  \  +x ?\ \  M \ ɥ\ \ md gʓpϧ֋_Pݞ\ g #  |\r  Vħ \ #l\ \        \ w   U\ \ \ \0\  \  #   V)-nW \ \ \  5ͬ%[2? \ ښ tU\ y? 6 m \r \ \ ɾE\nO *  \ J  \  ; q  \   Ů o\ Gr\ \ \ 85  hwza\ \ \Z2xu9  x  J\ \  T\ \ N@ 吏   S\  WK\  .   ?\ ^\ ei<A   \Z Ԏ&     \Zb[ &\ }\ b ser      g-  \\ ]w ~(  \ 5 \ e \ ;o\ }\ 8 R W    Q  \  c c
 EW\ d Qҳ  *1Fߍ K\'   vy [\\ 9x > \ 6 5  \ M\ \ c; \ #   \  \0 Z \0Oi  y>  瑱\ iSJOQK\ \ >\' \ a \ (S  q \ 5\  1 F \ ; Au; 8  mo>¼\ W U\ ς  \ H\ % uu\" \  w 5     \ \ O, b4lT vⱾX\ E  \ f k \  X  > \ H7  GJ  X\ P  \0\ \\\ 4H ;W\ >;? R\ <\ v  k  m \ w~$ km:\ e3\nD\ UZ34\  \ h$\Z  El\ \ ՞\ h? \  \ ˃ \Z /  Y]1 \ \ Z Ƭu\  ,  \ ʺ\ \ $v+
\ \  \ \ \ \ Ұ*\ [\ \ `=> \ \ \ ,\ NG K ̿  3\ 6e\ D	 \ N  s.\  + X  jI-\ \ \ \ b88) \ \   Ysj0me{\ t?\ j    [Qc* \ \  2\ \ \ V L\ = \ Z}\ \\9d    N;m6 =    \  X S\ \ \ } ( _  NqZ\ \  \ \ \ HW{\ \ GS\\  k2At\ [yRI\" @\ \ \"\ i P %\ \ \ +k䜥      Q\ D%G ܻ\ H H t  %r\  px +GQ\ a \ d- \ LY:n $ i  2  ڠWK\ \0 ( k* %v #   \ QC\ 6  \ \ \ ^0    \ ) ]\  \0hF qW\" b  \ P\ ɭ \Ziu      \ ~9	\\ƭໍJɠC\"3 \ 89   \ w P\ q ]\   % p7M! kjN[ a (\ rH Z ?\ D  *\\B :b  \'J{  h\0Q \\ r\'\ ~\ \Z\  ϘnY
K 7qUQͫ 5F+c x/\ S  e>ѓ j/쫧\0ͩ7mH\ ך \ \ 	   U\  j\    \ ⋰[Im*]#(\\a ~T rѺ4А뵀b2*kx B d# JqF  { \    3 > Q6\ ;d  \ \'#\ +^+\ S ou   \ Y o 6 a C(n}    kRy 8 i֚\ \ =ս\ vV\ \ ˃   P  x׊ { )Wv   \ \ Lp { \0  汳H\ dO J T: \ 9 Rׯ  .\ \"\   C`3   7s  Q\  \ \  
 p  \ Ub \ ݼ   u5 +C3  k\ra\ 0 BF\0\  F/ \ }\  7mz  \'\ \ p\ \ \ 7bqX $\ f \ id  -\Z x  d\ q\ ]   j  \ -dl| d]\   I\ R   J\ \   \0\Z\ p \ y  |_kc Z \ Guc<\ \ 0\ \\N \   ؔIw<p,\ lk\  \ \rm   \ 8b ky\Z33y\   y\ \ >\" m2\ .\  ٢\ p\0\  {\n\ L  yu伆ت\\< c#Lϒ\ \ v5<    Kw   -\ \ _\ b	8 &$  \ H 0`T }+ mF \0DT  K\ n v \ =9<k5v  \ \ g F   \ <\ U 
gR[  \ ?Z\ / Wk{    } G ^  <ހ Oִ  u Ka6 \ {  ( ͇?\ aڹOx\ L a T \ .~a\n  b? \ 8 u\ i  jVھ v }  \ 1 m\ GL稨 W\ + 7\ ^ =  ˷\ Xs    \ \ ?\ n      \ L̏ G  \ VU    \ 贚7= %f . \  wb:_x [    ]5\ Y 8  33g  # C^ ]  M׎,! \ V\"5    \0$r  ~x  ]*\ 4\ k\ ,n nخl\ +  
\ {\Z  \0 \Z-\  9њX$Q& a\ s\ \n\ Э7 4?   oq\ ⣣G!V q  \ }s\\\ 	x \ 6}cQ\ 4 \ W 7O  `p	  \r\ Ň |& ^ wp   Z$W \ `	\0  9 +C\ \nk  rʗ  QD\   {\ \ 5rޔG\ =;B\ g \ t\ .\   \ %2\ ?x+qXڇ\ [m>\ M6Mzdu\ Jψ\ L\ c \ \Z \r\ ! \ .E \   U\ ʎ  k\ \  6 * \  \ ;   \ \"\ \ &cwS \ :z\ h ߡ\ x\ ឣ [\ sm [  أ\ _ % \ =\ s  7\ :T, Z|\  f. +  	 l\  ]  _Y ;\ 5\ -\  R  \   \ \ P \ \ 5  \ ٭ F[p\ l \ n~   (  &x    \ ^r7\  v?Z \ b\  D:)9\  = G~ \ S\ : \ k 2G \ v  ;\ K _O\Z    \ (   ˟\  à \0\Z | \" Y  > i=\  \ YP \ ; 8\ +\  \ 85 \ \ +3  b \"  \ ]  ?J\ \  \ S w ]b  ҈\ Q\ \ \  \ O   w0  \ +\ 2܎  `{).\ $yHB` \ (  >#]M\ \ -%Ȏ>=:  \ Xv]\ $ \ E\ =\ Wd < L s%U \ S LFT 8 \" \ Lk;   Q^ \ 8l (\ x5\ ^ ő  ?SY 5RJ #. \ \ Q\  dB2ï\ W\ \  j\  z\  eic  \   .\ 0MaB܁ \ 馎\\\ \ Z  uI 	r  \0 W\ \ +s־g;$ 87   z ^26 dU \ \  \ H  (3қ W/ ]\    \ Hѯ\ l   \ \ h<\ \ >\ E=  \ 4  k :g x? iG\ c \0\ U-i q \ Z \ :M\ \ \' ы2
  \ 3 ` y \ :R66\ RB d( e\ X  \Zp\ (\ ?V% `\ 9:x+ \ \ <. =!~bU pzj\   wag\ ;V  9b{  j  W H6X\ !  j\ ¹jM)X\ +CF\ \ Exȩ 2  \ \ QC /\  `  e \ |   \ 댑 b3 b    B\ \ ӥ\Z\ \  ie\ \ x -c A 
 ~\ \ Ӛ\  bm|Cg# Ϝt\' ҽ7\ R, 4  v  9\" \ 	  k4  Հ \ \ l&z  \ / Ԓ
4\ ~7 B/ oGd\ c3I\ RY \ \\  \  \rIZ\ \ & Ta]I\ +  \ q\r \\j [nc 4S\     qg\ i. % \ \ZrO- \   Db Y \ (ɝ 9 \r{ǋ\" _ : \ \ @v\ d\ ג\  P\ \ Ge  J炄d\Z  \"QkS  o0   Udb%\ [\"\ dеI  W2ÓY 
\  6 3 H\ j 3\ Ȏ \      -ܗ  \ p\ Sd U ,\ <t װ\ jWl  .0\ A`t  a  \ \ nQd \ \ >\   U\ZH `   \ % g  p  ۵?iD\ z\ bd\ x\ \ 7_   9f \       Z  \\  ֟w&\ 1  \   W
  4\ \ \ X O Auv\ ;a@$ Z Hb\'Q\ \ R\ Ӂ\Z\ \ \ s\ +\ a\n  r  p;\ 0B
 Z ͻ$
  rjп   , \r  NN \ -\'\ \   e\ 3\ y,\  rx :͚J \ \   v +:7\ 
y $/\r \ Oq T \ `=* k 00\r    i FH=j\ Τ,  \ ]\ x\ Q ķ  K\ \  n9& \ R\ \ \   b  \ \ \'\  X ;\ \ \ \ 2  ÝƧQ i\ ;X椆y  \  WU   T  z p >u䎠S\ 
\ \  \ 09\ ) j  \ w  /O  \\\ *A\"|\ wu楦\"\ :tw*  a  O-  ;Np\n mu! \ @\ Z \ )6c*\n \ Z  مs 2o*zH >\ ,\   A S\ W5K|˅}  Mg    \  8\ \rmP\ Ь - g G  8\Z2U  6\rMcr  \ eW%J  \ \ \  QK\" X\ \  X\ ֨ h\  N u\ f E е&\ \ \ Cm}\ \ \ db3 ?x W/w
\   ch\   j\ \ -4\  =\ \ \" mʐ>  qLi \ 5 d!\ \ \ R*r\  [\   ^\ $  \0  \\ \" \  4	 7  s\ 7\ $ds  8=鮇 q@ \ \ < j\ \ Hè<w s#)\ RB i  \ Ib x   \ < \ Q\  Y @ (Ѷ\ Qa\ ca\ \ ?Ρ \ n\ +Z\ C \ \ %   Ί\ } \ {   s.\ZC  sHdM    N  .\ *֧	2   b_ \ ҡ9 0{ ҽ\ K\ \   Sڴ\ tSq \ 0Z08     kPg`  ݍz  |Ki K\ [   E\ I  li 
D     k)P\ g^\ \ \ [- Y\ @l쮷 7 c \'  X 4-fFX48[p&\ \ a\\>   NZ\ 1 \'   \ CrI ſ=X   ˯2[( ao+\r\ #| G a\ \\ ` aҷtۥ \ ԧ \ $RQ PZ \ 4   \ qUd  \ \ o^9> 5\ \ ֫|M d   #L ` \ \  SM\ \ rG6\ y .
   \ Vc(P\ \' Y  \ \ \ \ ݈\ \      A yy .  .Ձ\ \ w\ S   Z\ p \ - \0A q\ \ :\nе+4
 B\  Wmi\ H \   yffP\ \0	Qߚ\   \ \ \  \ ޻ C>oq  d#\ \ 
C 7c   \ [ @ \   \ \   \ -\ E L \r w \ _\ :r\ ڎ \ \  \"P3\ \ J\ /PV<\ \ Hl \n  ПJ r]  +6\ \ +ڬ|=\ [ q+@3pr  +    p \ [\ \ \  kH\   \ ;\ \ X\ ,O  \  E\ P , ?t 5   } \ o\  -  < 08\ \0S\ [  \ : u .  cҮLbE`\ \r{    \   < Gt * \  \ \  X\ +s\ ҳ5 YA	1M\ O   \ \ J\ 3-\   oA\n\ \n \ \ խ?WH
\ Q\\\ \ ԗHҭ\ \ n\ \ =Χ= \  ppN8\ qK\ З4 B  m\ 4Yߙa \\K 6GJɱ s Ze\  K\ `\ t Y|E; g F\ >w\n  \ !x.ܹ W\ \\z\n\ \ _ \ 
 3i \" \ 3c \ \  \0\ K  66 \ \r\ 9%  \ %wwu \  H  	*k  Y  `\ \ q  X sսHnm\ \' \ |I   \ ۙO \ U \ <  =   My\ 2;\ \ \ \ \ \ ^\   \ 嵌  ʊ\ ԇH S  1E> \ ̘`c$` 3 \ \  g  \ f \ K5 bc pr> \ \  &\ E9 mfO\ O  u4ӧ\ ĸ\ \ 霜? u inl\ wq \ \ \n\  O \ ߥ \ *	\ J  U <yLr  \ | \Zա`v+\ \ :S >  \   d@VWǨa CYP-?\ H܎ ^u  Y\ @\ & -{\ SN      eM w?   M\ \ \ \ 55 A3| {ӵ
x +*  r\ L U2klh \ >ӬۦTp΃  \ FSk \ E  &#? 7ld( D \  d 5[& \0 \  5 \ :\ P ;!\    ;hk \ i   #TyddH & 
i B   \ 4\ \ _d  ? @\ 4  _\  ]NS\ n+7  \ ̧  @\ \' {G 6n\ \\е \     :\  |/vOm V 7\ )   \ L  \n\ 8- >0\ giZt\ \ $ 0 Nzu  I\ 	  t    XE\ \ d \0zbhox  WG\ W\ s59eҖ\ \ 2R+\ \ ]Iq m #=B\Zմ \ C \ \\\ \ T>8 `;KC cMo   M6? D \03T \ #\' \ k \  %\ \ Ԕ  ;  5I>\ Y  \ H?\  \   \ m\ \ Fu  \ D   \\\ \ _\ v\ >jČ\ F}1Z w u
M؄\ ?\ O \0Z N \ x}r\ \ * Xg\ kw\  \ b  = \ y  د  F\ J?\ 4 \ \ \  \  \0?Z\ \ .ۤԯ\  \Z|  \ 0 \ M \0}Q ]  f     iA\ H\ \ Mf\rp*\ \ `{\ + Ե
      H\ StKֺВ\ vg#q\ z\ ur\ ]  8|\ N\ o \ s , \  <j\  2k  |\n\ ,/\ ִ\ /a \ @Y@s\ EA\ \ ֗, e H\  ydR \ ~ ;r  |w{y{r h Xve ,rԚ h\ o  Vѩ>@\ Ez    k=  ,R4x\ I\ z\  Ց W  (  3[\  +\\\ \"R \ Nb \   X# H \ T 0X 5 w \\ \ n   I\ _ z. \ ;\ \ M :B F`0>l   J[\ \ [
\ -o4R\ \ ם֛    4 WP  5\ IQ0\ _\\\   _,(u\ H[\'>S \   ++}Mna\rg  0  Z  _	\ JB    \  )ST =iM\ j k\ ڕ \ ۮ : B E  \ Q\ x<
 ԋ<3\ f d\ ܕ\ [!  j\r\ \ o    \ Y\ \ !\ \ m࿼ 8 p \ Ғ \      |\ \ HqQKT[ \ ƻ\ ۙ/n5%  `\ \ \ G+ \ v\ f E׿ /4 Vv\ \ \"\ \ O d z  \ ]E f q5ޙwb]  4   \ WK \ ~\  خ<Aa  FD d   \0PW W\\%ta8Yߡ\ \ ^!Эl    \ \ \   p  \ \ ִ<C Xx K\ vY- 2^   c#\  Y\ \  \ ^S\ E H.\ \ \ a&  U x\0 ]\   \ ߈7 R;M Au «XR  z\nә8 :+\  \n  ,\ /\ -\ $d4= V\ \ `\ j61j  \ m  g2Mp  \   \ #ޭ躴 (    I  GY[e \  \ r	\ Wt? z \ %    SH
\ =8 I  p  \"\ >(ټf\Z+Mv  G  \ \" \ + \rb\ \ \ E DrAg\ =\ 5  |* \Z\ 3- 1JȲo\   \  \ % V R\ s \ ͎G \'U 4 \" & W\ 	u\ o \ Am&  >b\    J]\"\ \ Rv  ϵu  _c\ [  \ \ NX \ B \ 1 +u\ 3 \ \ny5\ \ \ 6 }. \'\ \ a8 K\ z\ 57l  a N\ ^<\ \ 
1] i  b-㻞\ %s\",w s\ \\
jw b;  ڧ	\ \ \ jy  !, \ ` #F  nT \ i  n =V}SÖ I jo}r-_z\ o! \    ˹<\' \   \ \ U  p \\ 	ל㚱  4  D 4  =\ &| \' \ \ \ o\ \ . ይ1 \ Ρn  e  Px\ UdƤљ㟅  J  I  \ BEY  V9R9  \'P , Vx G    W[\ / ~n    \ k+ B( g\ S OJ  \ S \0hIm \ 5\ N0   c \' fL 1<1      |1   c :q_E ʓ\\ է   j
 Il\ \ \n\ \ z\ \ A\ ?J\ \"\  ְM\ ͜^ dMuH  2/\ ] D ~  GXc   r0\ upd\ 3 E(=XMm cV  R  \ 1M-  \ 3 $ 8   x  c\   l G l  \ \rWž  \ !  o !L  Fq\ W l\' \ -^@ \ \  `  \ 8  \ tƂ | \  2 \ \ QY-ʀ\ \ y \0  \ N Tpw++ k\ N \ ƚi? dGlnU \  b  ߇ 
\ e  n#  F V9jQR|\ NcR\ ? !Dݝ $Ƴ   v\ \ t \ \ S Aq( z  }\ { & 7ɯ\  w \  \0WM\  1 \Z $  <\ \ \ 
!Q \ D}\ \ +\ 8FbC \ ʼ\   Z 1\ 0gF\ x\ \ ^   \ άB  <\ _S 	JP  !8 \ \ ,F9}*a H+ X  \ k\ 	  Ž\  \\\ qn om9  \'$R \ \ l \ \ \Z\    #  p^  \' me΍y{s\ \0  \ ]7\ ׋ k 5]f\ \ 2\ 0Hמk76 \ j\ \ q  =B͋XZ    tT 	5KD\ \ t 2+V{ y A$~|\n\ \\ &O ڴ\ \ ( \   j\ x H	 &ٺF \n hl #r  F+   \ m[\ !Ѝ  щU\ T   ޣӾ  \' //  >OJƤ9 pZ \ \ |-R\ 1\ \   Ro  ݕ\  E5   W     b  5  \ \ y \   c zo \    f  2HŘ) J\0\   & \ 9n/\ \ ÌF S\\ f  \ \ \ |t\ {%  -<#\ \ L G\n;   ^9 ] \0\ 2]_y AB C\ :Y\ { [H \" ƹ\ ]  \ ?N  \ \ , q    \ =+  \ F 2Mf \   8    ͐ e _ ڲ  _O \ y 8 4 \ \ 5Y R\ZF l6\ n \ ZjW \ \ Mn\ s*@ \0{\0U \ L e H 1 \ o\ D #E9\03U  Q.go   ӕ O\ \ \ 5{\ \ \ 6x ـH9\ryܭ Նvg8\ u7 / ^ ҰYG\ \0c\" n4Ղ)\ \ *\ \ \0t    [,T    \ 25hi>  \   }N \ HWiAp \   K n pEP \ \ a,|: \rc:n.\ \ 5     .$0\ 
K{xas  ǵ\ \'9\ c e\  n 2 9\ Wo /.l [   &.  `0OץR 7g\ ?+3S8X  (^ c 9 _* \  \ jk S3 @ *MWP$<7jV)	s   \0SD  yf   @$ T
\" \ ;\ ; \ b ^]\ 9   q [! U7  c\   MKnRwn  bM/$ V %ݞrOZ y) f >C \ x  \ 9c  I A \ w  \  = \    $-\n+ \   \ >\ \ -\"\ \ W >\ \  T)\ U\ w>3Ӟi \ + _~OZu\ \ J\ PY 0;UR d + @< l\nU \ 2 4  \ \  \ #9 i\"N̓  \ EgIp  	 \ D7mo  F) 3 )\  MpB\ x  [   犬 \ X\ \ \ Gu_ÓK xX\ \ ̸Hv  \ \ G\ jB\ ųFʳa \ n  \ \Z1\ \ \ I$  \  /l\ E\ MOG \ \Z      lW	$` \ \ \ m \n8<- w_\ \Z\ Ȱ \'\ \  2p}\ \r\" O/խ\ d    7*~  \  /  L   ! \ \ }   ^8 \ !  r8 ψwJ 2\ >\ S\ [ \n  \ f\ _ I\ \ \ G ą\0c\ qN1  p  R  :\ \ ;3+\ $\ \\ 
 \ X4     \ ⑚C \0g\'һ\rN    . u }h\ 8<\   \\  `\  \ -\ kww  \ ɲv  \  A \ 	!\ J \Z ߆z ռ\Z \ wh# b 1\ \ ֬G i >d A  \ \ I\ \ Qoc\ \\H    =jH
;~b:f <Aj   , c  q AYJ\ : H=kD\ f\ \ -\ x\  }D7+\ 9\ ) Z2 v *\ \ Tk\'\ \0~Gl\ bZ$   s֨2\ $U +  :TrĬrA  +F\ y\ b 3t\ i|  \ ^ \ \ 2\ i \ \r  (/ \ \ g    Np t\ ֧\ <y   ʨ  yb+/  :  ͲZ\ [Ű\ g \0rk\ \  w \ ե\  B\ Hq\ !\ 8n : c\ |u\ P \0\ \ 6p  \ ,\ 0 \ n 0   T \ \ <s   \ \  \ 1\ \Z>\ N7v5\ :  \ i%  ?\    - \ )  j
  4L\ Fj(     m\ 9\ #<\ \ t=D \"\ ]n G4\ nKh \  hLn\ \ Q \  pTVŇ   o\ \'  \"\ \ ЌZ\ >ԢԞ\ \ \ ,  S ԪR\ \ \ &\ 3(\ \0  Ԉ ;% 63 Wj>\Z\ Om&\ \ # Uܖ\ \  z\n E } E|\ \"   3   * َ5\" f, =     ޵\ ]>kD  $;\ 9\ \ \  -)\  5\ \ \   O\  \ ? \ \ $1  J	;  3Q\ j^\  8Z <\ \ \ \ \ XG7  K 0\ Q W \ q e  \ \ Ex  0\ < ԡԟZ \ &ȌG Z\ \ \ V  ț `:\ \ \  \ D T  f\ i7\ 햲4r\ !d*=z    \ Q hB\ \ 8< k  ֭,# $ & \ r:f  ۨ\'{p \   <OD
 \ M\ $V w \  \ g1K \Z K۟ ]  j\ b \ \ 9 X  \ e jwN ܉\ u\n:~Y M [\ e]5 q k   1    1崽\ obUd : T W i2\ \r B  
\ # \\|f͟\ 6 p\ n]bD\ \ =1  2  { VcIkfv1 \ \ r    \ $\ D^K *99Z\ \ ՟  l \ )   \ \ n ]O?3\Z\  : Ә  B\ \ 2 K\ 5   \ pN `  r   ^{   8fu# T 7\ ޕ7 i\ ʠ\ \ [\ Z\ Q\ u \ am\ 	E\ k7  zFK   b[ M\ ǖ\ \ }\ } \ n&F \ Khr\n kR-F\ \  \ \ \ gM2 x - sX \ ׺w \ Z\ _, \ W#    x> x ȱ   = V \ \ 0\nUmN\ S\ c     E    Wĺ\ Q \ ̸\ +Y  \  D <\ } \ rH\ h  Kv/ K    \"N׉  \ T Î _N MFs  N\  \  \ \ ]AVW \ ̐  zzV, \  WyI 8<R ʢ \Z\ M Rm:Mf\ ɰ^Q *8 \ \ \   ^  I
L   # \ & x H8%E  \  k\"\  \0 O]* r\ 9=ko ӊ   3=x 	 B\ @ II-  i㹮5\   ckl |\ s\\   U߅ف\ *c -   \ \ \ \  Mn\ \\   kļD  ڿ\ 	a\ SR\ \ \ \ #/ N> c   
  \ h  N1    MӮ/|!     zg k\\f\ Ǻ^z a\ \   	V sWG %ާ Żd>D\ 5* q\ [V l2 \ * 0,  ޹;+ *\  ʛRy\ \ \ r+ у\\C3\  Ϡ\ ]J0 \'$ iV  ( Iu0(@  M  `  ~觺`\ qk\ K )Z\ @y כ   ̮z  r RL\ \ Z *  a袄D8b  z \"Zj \ g  BƗ }1_\  m\ \ Bx u\     p ROy~]:`Th\ s .\rz8\ t m U \ ۟\ H\ F  0 \ ? \r/ % \ \ y\ 0c\ QJ	 (\ >  :++U*v[q\    qko\ m<t\  jk\ \' _\ y@  - -  \0t\  k? 	 RG  4 `D \ 	 ]       } Vy \ /   L!  DԤP  ^ v Ƽ| ~ z\\d@  \0x K\ ̿ \ < 
U\  ]  <r\0 -|? \\\ \ , m\ \ \ zHG \0 aK \ 
d_   }jc  3\ \ \ z   Z \ \ J \   \ =I Wv \ ?s  2 \0\" \ 3\ 5   SxB \ ̶  ¹\ \ RiSĲ<rR X W\'t#>   {\ \ س | \ v  է) َ* #M\ # \ 3-  c8 \ 1 ~\Zʥ\\ ʚ/]൞@+`zo ng\ tf     \r 0 ӉJ\ \ 6	˖V# _ M \ yF?\Z m% \ \ t(坰})|/\' \ \ ˎ ~f \ \ ˍKI \ \  rY@U \0W\" S  5 \ \ >\ .5\ ՝M N SJT,  \\\    S \0M\  \ xn\ \  .    əv    \ \ ؃\ v  ST \ 
  n= Eq\ Y <L  W \  \ s W (@ U \0  γ  \ \ \ P \ \ FS<S\ g.ĺn\\ ;  e\ \ ƙ4vv 475Ȯ\ D m\ $6 \ 76\ 6@P    ҵ\ /\  \ \ \ 8  aڥ \ uc\ =@\\ ]    5Ȱ  \ \ \ rL s \ N\ so	 \0   ҹi	 } ^y\ \ |[  Lx n\  \  \0K  I\ Щc sZ LW\ \ M  L  W|2\ rs\ G Z n \ OռQ X ) \ \ r \ K C(  5=  \ n9\ \ ţ !R(\ \  ֒\ Z\ h. G@  4}dd {  \rC \ _l      x \ \ q}  C\\  | oz q\ \ E\ k\ |  P߉   k,s k  \04\  i \ otppF\ M`\ 8 2   9 
\ ~\"\ ei&Ҿ\ * \ ql\ \ \ ]\ s C`Y 5w\ L7 7 \ k14=a  ]uO \  \ TZ\\ y⏩Q q v!} \'\ <Iߞ  < 6ܟ.1 ; ϳ \ 73\ s Y\ \  hq \ 9  {֪xkY\ 6 \'  \0\ 5 m\ -n4  G \  \ %    x\ XG  \ *\ e  JX    \\   T \ Zmm\ p ,\ Mz  \" \ H\ ]d <T \ d#  {\  R\ P_l  \ !\ k\  R \ l-    \ ͖ =\rh a    \  \ \ D- #  X @   r W^\ \  N #ΥO	k\ Fm\ 現?Ɨ\ \ ? \\\  \0ϲ ֌ I \ DX4b\ V# Q؃T \ \\D nu\\ǳ
  \  ֶ \0\ ֔|\ J	88 \0\Zw \"z , \ \Z1 r \  \ \ xj	i2\ \ I\   I    \ 4 \ \ 63  \ \ U庇i-\  d >}3[\ > t ! 
ky\'0\ vu+ \  \ \  \0\ \ @; NO c΢ :2 4 \ J   8m+  Zeݽ\ [[C\"8bD  \ zlGI  b^\ \ H\ qfaϷ5\ \    {   Ƙ\ \ 8  \0\r \ ^ \   Z\   ) \ c͎\" )ڢ\ \ \ -# \ \ ؠ|\ K 5   V \ \ o! a;u \  W Sss;2[  r    \ \ 0 \ M 
 T   /d \ Wڷk  K4    \ ]0  \ : \ \ VV\ ꚄK  i 7 }1Ph\ ?`   lF nʽ G5 \ KK{j,  \ 6\  \ \ 0 䋉JrZ! \ Δ3J\ \ \rb  \  \0ښT U\ p cy.=\ri\ - E m\ \0 /   mj\ w\ n    ² \"\ \ H\ Դ\ Ηck  3 Y\0T/\ 䶋\ W &.\n\ s\ ZMM }*ԏ  	 o2= \  @\ ]X,e{@ ܻ\ \ \ \ ~\ 5\ \ h\ 0  B E \  D7SC4E \ $=\ S  1\ \  E e( \ \ ~5  Am 2  C#G\ ^\ \Zӽ\ \ \ I֣  cv 0m m\ Ҵ \ l<   -KL\ \ 2%  \ L\ N l\0 j ŷ ,.\ZC\ 	 CP^d\ ⥂\ Y&\ |      6F> R \ I -qc \ \ 	\ \ E\ \Z: \ Ǆ \ _ \    l\  U\ 3Ҷ ԼE    \  Ж   (\ @ V\ \ M? w  W u \\d\ Z飷  kX \  - 97I\ >    q  (\ \ Z 4\ ^ \ t\   \ +J\ \ &[]\ \ \ \\Ʉ  r m  I \ 䙙G 89^\ ڋkՊxdd  y\ \  oC\r\Z S  t \ \ ! \ bo:գ- \ X8 \ [ƒ _  F~\ q W uK  I`\  ܿ \ W\  ڳF nbR Hs  J vr ^J\ \'I\'     r7GQ \ EY  D\ t  \ Ő  / \ \ >\ \ } g= .Z\ \ ] 5%  f\ \ Rˢ t5 ~\"  ]\ \ 4 q      :?jQ\ !{ \0`F6  \  r jv >?\ Jh  \ \ [ \ \Z P\  D ( \  )e   \ 4jtx\ \    ?  hM팛O_+5ǃ C	7 y\ 0?pNh    )WoT \ |{\ +ټ \ 
 \' Ҫ    ? >4O \0x Td  9 _ -ל., \' \ \ z   , f ; \0
c\ g:   sXF \ ! \ ?
  3xZH q I    \ 	\ D \  dm8 ꄾ\nqlљ HV\ ŵq:\ \ L\nl \'\ J  Nx\ Y   h &\ $ \ =K\ \ \ d  E  \ mm  a \ i->͙V;\  ##s +6\  \ Y` [h\ y-S  \ k/[     C$~ax \ B <~  ܷu \ ^\  \"   I  DJY c\0	\ OOa UqᯄR  5[\ a &C  \0\ \  94  g!er y\ ` \ Z[ l   c o I\ 7  \ Z i     I{u ¢ &A\ \ M_ _	 \ ON  d  \0\n\ ]6e {; \ \ 29   .\ K ǐ {\   窷^ \0wڇM\  \    ̲ * \r7 \ \ I >=?F) ן\ . n\ n w 4	 \n G \ R\ \ O{ \ U    ) \ }*; \ B  1\ ( O \'I 0 ۃ \ \   9& \ `  S \ 5\ ;tɴ   Y e  8<  *ٛL\Z yw`Oz\ n   \\\ w \0 \ 	\ ̷  j\ 	!x \0ǩ  = z\"O ,>=\ 7c ּ +}5, \ F W  \ \ \ ZK t\ E!K\  He ϥW V\'ڧ  E? ݔ\ m \ \r  :g \ c 7 `\ 3Ҝ  {  \   \ \  \ \ \ bh	 S   Ȩ-Ზ\ 7W\ \ >\ \ c<r7T(. u;I \0g9` \ L}	\ 6/\ \ \ \ <   Ol \  \ M{\ o \ 8Ã = V   []R\ K \\\ bm\ tx \ G\  R\ c \ Uq x I\ A i  2\ B,&  3    b \ Z5 \ Y\ \ / \ \ 0 \ FZ  \0ciQC4O\ \ N\ 6  \ *\ ; \ ߅>\rj - v \ \ \  3 9\ |U\ [\   w< E \ \ \   \0\Z\ \ I   ?
 \ @r  j\ \ \  <\ \ \ \ \  \ \ \ į?ZN\ R  \ |\r\ n5{k\ q  8Iߎ \ W5߃~( \ 4\ _N Ӆͬ>[<   Ҩإ  0y\" q\n \ \ 3 \ \  E\ G  6I\rѿƅJ/v  \ <  \0f \0 \ \ .  < 1v\"S\  cN  <H Q\ y{   \ \ \ +֣ u\ 춤\ +  \0 ) Uܑ  Q S 5^\ \ G  ה\ \  k+5 X\\\ QEj\ \  \ \ s ^t \  Z\ \ 5\ ?B x Qr }i\  3% 7 \ ?\ N_\ FP  \ ot \0 \n ?\  ^    ﭥ -\r p3  lq T  Y /*,[ \0/  \  &\ c*597g \ ?\ \\  49tc	 \ g\ vJ.\ ?) \ 59? oR+\ 9K y v 8 [ %\0\n c ?f  }KI z\ \ k\ \ +C\ j\ +\  \ W?\ 8}^ \ \  \0ף\ \ :\\^\ R\ ǚ?\ \ \ 	   i   X V    T  \ ,O\  KOZ s ] ˃ \" \ \   \r\ \ \ \ K  Eu4 m\ \ #.\ \ -\ Ob_  p n  A   ? i  KN\ 9嚭\ \ m5s \ 9  \0 -:s\ c   @s$   \ !V\ \ & < \ \ zIp\ \ \r N~\ On  z\  ii C4j (R@?: {ұ Uh a\  \ l \ k ¡  _֥ \ u Q h  \ ` \   b  N  \  Ѹ x̤  x  \ w \ w 
i\ ȹ˂ ;y + \ \ q\   i g\ m  mwITU*X篷j{x>\ \ +6  * B6   \    ޥ  C\ < =\ $\ \ ֬
 ] 7a \ 8c\ \    tZEƬY\ \  :  ٓ   c      KfI\  \Z\ ,!\ Y!q \ \ ͋\ , \  \  7F0Kp   *m2 c\ ً\"\ \ \ [ QPy\ \ i:rJ\ 	FN\ \Z  Ѯ  \ n ^ \0j ܒ X\  U-sE\ \ yg   ׫m .7 8- \\sY\ @Z\   fd[ Y  I\ x \ \ s$6:w |_g \ Fg \ WQ ɧI \ 9F *(\  7 5 Zϑ*\ \ \'  9    g,\  \ |\ \ \' nx i\  1 ] ]     Ӂ\\\ \ 9 \ \ 7\  r  S] N^\   O \ \ :EΧiq\ 1  \ N@\ O\ \ 3Q u
 BI^9  \ \ `  \ \ < z\ \ @@l\ L Qqx[*\  \ ZL7\ W 1 W   %Q\ z8j KM\ \ \ rrn 9벛 \0\n\ \ \ \ S ] *\ \ h \ c Y}b sO R S O \ r $ \0  J<
  2_ 0GfS CAc\ ~ \ u\ > * \0  \ [vȁ \  Q\ \r@Ų \ [D \ \  \0 1I 
s\ ~  \ O ^\    Ǝ \ L \0 ju\ t Q߼\  \ 7  )\ XD  \ s q G U4 $  q / W .\ - \ | \\  \ ڻ¸   q\ E   9 Np \ [\ d  \ \ ť잇  ͥ  got 缃\  U\ \ -l\ \ $    \  \r\ f  #\ n E \ \"_I\ \ \ Z F\ / >0 UC    ?*\ \ o,\ ty\ a0 . \ F>l Z d   g\ idg X* xD \ o  6i D         o\" . c\ .:f  \ R\ G \ vkt \\U ;Nz\ \ \  @ \0{Mo\ +t\r\ q\ \  u2E#k\ ƗR\ ̾=F\ ej  \    \ m)\ e\ ֶ	\ \ K \  < \0\ 5\ \ 1\ =Hs x\r&	 :\ \ d V\ t%.mVO8 \  zVV  K xgW  W \ W\ j̤\ W 0 \0  \0  \ A \0n ?\ 忝f\ j  \ u   \ r \    \ dRA \ \ jZΝ6\ mi\ @ 9\ \ 7\  y   *; \0kx    g 4  \ ͱ\ o ?\ \ \ 8 inH   ֔\ Is\ }5\ \ R\ ͓\  fM xM\ O<\ U 
cƱ      l    }\ \ \       T  Ev P m Ԡ  \  5L  \ \ y \0 6 \ ySzs]\  \'& \ t   q^ ap* k\  W \ \ ^    \r m  Z c\ ^4    )\ 䥸  hݘ  v    i9\ \ \ R17 ,Cځ!9 \  \r F$   \0^    {P$\ }0  \  \0\ c \0|ӖeeN  Mg\ \  \0v $\    ʌ\ \ ? (u#  _  &\  Ǯ:~ \0 \ \ \ =)@#   \0  ;8\ ,\  E! \ \ \ h\0\  b  \0      ϻS \ n( \' \   \0  \0\ \ j	 \0z $  uO\ S  \0\ 91 4 c K ,?ƀ    \ >  \ b\ \ ( v  Ɖހ   
\ v\ }kM ޖ 1! bm   \ \ |T\\ \ ^ A  ? ɇ\ Qxc\  \ \  k\ \ / 4 +L Il\ \ZT\0\ pA \  ._:#r \   \ \ Uq8  J2&   l\  \0 G\ v\ \   L 4 2 xQIR2 A# & \ \'o 9C \0Z\ [\ w\ ;   \0I\ \ |*H  \ \ \ZO 0]\nL \ G4\ \n -.=\ o\ C{  \ \ ?\ <6    5OE \0   ՟
 2j  tj  \  U^  D  * \ B{\ OL\  > jְB\  \ \ > _ú      \ ul  - y\  <!  :\ \0e  ҥ\ \ O \ P#     \ -.pJ\r .\ e ^Cya\ ш a  \ ^  C}    \ 1^I\ \ O l\ 9?0ϯ5\  \0
 l  |   F\  ՈwÜXm1V=h=A۩\ns\ q麍\ \ \ HB\  \ 5\ @\   :L\       >   \ \  P  (?\ PNpz \ n    \0 h \ \ \ m\0.\  \0  \ \ < iK8e   \ ;x Y H\ ^K \ \nvb  \  \0L  5[Q\ b\ \ \ \ e\r\Z  I\ \ { Y  M  \'\   \ y+ 5    ]fy, խ\ZX \ \ 0v> q \'  F\  \ \ \ 0\ 1 M\ 3  \ f \ .<8  \ D Y+6  \ \\]\ \ I  C% חt  %s\ I -   \ c$ [J m 9\ \ ޴ 5mL\ Q Y6 \ {-Z\ \ K( Ko ˑ0[ 1Xz \'\ \ ) ]\ \ \ U  \ ~ ?  \ e5 .\ 䵎+\"F\   \ qV\ <*\ }  { \ 2\ \ \ F/\ \   ;W\"Ӽ \ ڠ\ \ \ \ \ \ y   Fou\ ]> ?p \0 j N     \Z   	J\ \ :os\ \ + r ;>\ \'\  \ +  \ \    FJʨ \ \  {{פx C - \0 \ p\ y  ,     M 2/ \0v\ \ /\ \ y Թ\ t;X a%\ 6     /j mwhmY 4ef4x \ :    \ T z \  |    Essjtr\ m a \ \ \ g   \ R    h  \' \ \\W ]  ]u   \'  _ M\    | Xdg[\" \ s ]\ j\"  \ 0\  	\ N׶ j ~\ Vpw *]>\ k)    : \"64Y   \  [ \ C Rf \\ YQ\n Źv\ k.mt/ \ \ A   \ B \ c \  x  qmk  ̀B \ \ \    \ ]و Ȥ \ \  clD x< m_iy- D b#n\"a\ s  D[Rl\ \ SЂ\ \ F  \ <s8# \n wu\nX  M9X \ \ t` F   \ &   \  \0,<   iג ^ \ W  Yo+R;e&>c t W9l`$\ \ \r=`Ԣ@\ 7+!    comk x \  |\ . w   i ;\ \ =   tV¡\ o K \ Cq :\ :  \ n D+  \ V\ e\          \ .       n  \ \ Is   \ 6}\ I\nô  ]     Imop  1( AҺ xkϞ\ o. ^\' \ c   *e.\ \ :jr \ 0y\ r zU \ )z\ Yٷ  K Y $\ g5  ^
   ͨ2\ k8d\  \0 M !| vk. \ 0G\ \ ]T+8\ 4sbp\ KF ; \0FB M \ \Z\  \  Z\ \  N \  ׷#\ fd\  ԋ ～\ i 
$M\ p\ \ k o\ gm5h h \   Zi    \0 I   .\ 6\  @ \ o \ d7v\ \ (YؔS \ \ \ ^
 n\ K
 `@A   o   X T\ \   \ J\     H . 9 =CL{!7 q   Y2  U ;
 \ {w m 8y9 \ V \Z5  \ \   \ 0Q LF    _n\ \ p \0^ J \n	 \ \rSXԠ\ b   R \ , s\ j { _A 
o Y 	     \ \ u[  K p H   7\ I dԾ\ \"\ y|c?Z \ mI ?C&\ X\ n\ \ K& H lo39+T  
  ՖRU  \ m $ JҗF \ X \ \ &h  )\ \'        \ \ \ = 9 N \ m  \  \ 7   \ D \ H Vr\ \     \ \ H`X\ Ѕ$} 8 \ Ep4I 7 \\(  \r\ R Y\ u yӠn -\  =Z \ \  {T?a  jT \ t 
\ ^; Ap[#&\     \  8 \\\ ? #U   RN?\ ]s zP\ kS-\ ^-KM \  \ 6
    { j)\ \rZ\ \  ̩\ [  _  [ \ \ \ -\ D  \ t Ջ \ $ծ#T  dQ\ )\   Էsݬ\ Z Ӡ&%+·~GzY5  \ f\ c
p N7   \Z B`)u\ \ Ϳ  \ Aum  *\ hM 1NW  A5.\ إ \ 6 g   Q ;  4N\   7	 \ g\ \ 6A\ ;\ \ \\x -n腸 \ \  _  \r  Q\ \ o % h\ -4\ B  })m N<\ \ ڇ\ \ \ M6g;X è  \ P\ \  v \n\ \  \0     =\ ּ3\ \"=:\ \ \ e e  &[ 98 B\ ZK\ ^6 @  	  \ \ \ N3M]1J  Ԡ   k3\  `  9 \ D A-WL $ 9\ \ \ r;ո    x  Vp \ )\ }jH\ \ U\ d{ \ \  \ 	\ ޓ`    ؛O C Ħ+    \  5 i:  ŭƚ<    D  \ \  k\ \ \ 	kwιY  =F \ c\ Q    Ks ]   \r\ \ UF	ŊM  xK\ z  n4\ \ gx F\ZC \ U\   $  .\ J\ 0  +ڴ \ Ϯ\ $Xmr &2*߂M\ h\ YneNÀ\ ~   Њ: xlh 
;Re&\ \n s\ \ ݰ\ |< @\ %  R[\ Ēq\ j]|\\  bd\ c\  =kOG3I \ 1a \Z\  q  &մyt  a2| Ls\ \ \  E   n %G  oO gx g \  +]\ V\ \ t6 a \"q   Wژ VOii  l  ?p\ q\ j \   ھ g}p % 
  r % \ Ʊ \\ ?L.  cG=\  F6  \  M ?Jg>   9_a@ 8 \        \ \ X \'\ \ \ ]˳ \0  /\ dm& n t .N[ \ \ ZR    ~< h\ \0,  \ \ ?      u \'\  \ ^A   k\ : \ \ Z PI \ \ $R\08 w Kcm9\ oCO\0  1Umo    \ \ \ )m\ ]\ \" Cʧx̣  4 L\ \ \  .\ \  \Z J \ A\ \ Ԁ \ A \  [\ ?\ \\ \0   M1  yJ\ \ >e9 \0e b   ]X) B  t Ό\   G kж \Z\ ^  \0  [apd  HW̙  \ ݪw-j tD \ d \ \0  <y	;IX\ u   j Y\ F\ u M 
 n#Ȃh\ =>c  3M\r  \0  1} 8nۇ AA$\\V ` \ \ >  z ` ZN\ \ {Hry \ R \ b   \"\ ˶A O\ # Ofҋ Rn \ y1\ O  Q\ \  # ˥\ \' jKB\ Mo   \ X\ 9\ ަSV t RL  \ \ V\ \ \Z(\ ` < iP@\ Z=  Gu\  \ %  \  A[`     \' T\ 1\ 2\ N  A  6\   \ \ E\ \ Lշ \ \   6\   \"q \ \ \ \ 7\ yw  y_ E \ 3[ Ynd \ \ ( N ٔ \ GJȁ \ y \ Ef U 9\r   \'g  ux\ zg   ]\ hՃ(#޷,\ `  % ic H\0 \ \ # cP\ m\ s[ -2\ q^U \  (iM!\ o i \n\    ܨ \0 x \0z \Z|[\ |z W0Ow9 \  O\ \ \ ++ \ \  \   ( \  \ u \ oi^/\ \ Q\ \ FC\ \ ɇ  V e  \    \ b\ tw\    \ \  \0\ 3K    \0 P_ g   ܸ \0 T  \0 @ \0 f 	\ 77   \0\ P! C \0< *\ >%\ >cU\ ] ,GO k    ӭ \ ǘ~ \ o  \"9 \ \ M Uӛ   M X  z\ ( ;u<\ : \0:. \ 8\ d \ ۞  \   t N G ;X\ \n\ \ \ \ - \Z   S    X\ 3\ @ ע :ufܧ,  \0{M9 \0 EbO  B ~\ q \ \  * \'  \  \0  \ r  \ 	跧? &\  \0 \ p \0 \  X1 \0- \'   ߘy 5 \ 3 A \ +*\  rè   :  IjjHżK ` 0   Y >|% !=.\ri\ >+\  \ , ?*ˀ \0< \ 9 \ 2\  /\ LMׅ\ \ ~\0RXI cĩ \Z,\  5đ o,  =h *5\  Ϙ`$\  - f  \ ;T \ 󭤐 Y   hT U ]?\  \ \ ] u W\ Zxe?=  | L#    \ \ } \ \rw\ 9\  \0\081 \ U \ K  \0T  k ]E-4\rB\ \\  ʶ \ m   
  \r,M   \ k\ t\ Q ۶\ կ_ | c\ { k F  ` -^\  \ ⥧ f Ц 0\ \    m  \ H    \ eNrʓ9\ *} <\   >  \ z 	 C~n H  R\ p \ c   \ )A$gt_  W\r\ y     ;  \ F\ #!\ Q \0פ; \    \0נ\ d\  P %? \  9 ?*@\ <ʿ   d? \  \   L})w \ }) \  \0   V   &{   ,s ?   \   3 \0 {\ G   :A2\ \ \ A 3   \0H`Ѯ\ ; +\ \ \ \ \ gk   c. NCN{WjeA\ W\    +ξ#HR \ \ C׎  sϔ\ \ K \ 1 v 6  \"\ &e  TL O\'\0W\ \ S ) 8  OS4  \ #a o  j  ? z \ \ \ Ҫ\ ]\ \    =\ g   *\ :ǁ\ < O wu\    8D6\ \ 6U\    G\ $ jD \ \0  S T \\  ֬\' \ OT\ ر\ \ F[ \"k&  r * \ \ \ ^ \  \ m@ 1  y9\ P &y~\ |  \Z\ \0\ \ QxKT k\ \ Zv6 Y\ .  ֫ \ /h  cc\  ʶ  \ w8    \ \ N ޑ֧ ] \ \ \ \ 0 2>  ᛫  尙Ż;1 <늆;˨ ^ Cq$p\ ( #S  \0ZR \ СQ \"  A G #\' =\ o K\ -~ [ߊ_  fM~X  \ M3 \ <=\ (I < ϱ  \ \\\ ck   ðm\  c U f\   \Z<3 ^E \ \ g;ea^  \ 4z \  h\ \ \ uO s̢  =/~   \ 7qc\ | \0 JA \0 \  \ ) \ \ F :χs \Z \ \ l\"]\  y
p /       =\ 
 kf\n \  y  t+ \r\r\ \ \ \ \ \  ~ \ c Mc \ w\ \ t A6 0$=ɮ P\ ׹\ \n ͧ\ \  y I s#w\ \\\ \ o ]\ k \ \ o  \ \0 ּ\ \  j \'  0E 䘺N\ \  \ O5\ \     yi \ e \ c{[  т1À\  \0  (\ .̻\ q -x V\ !\ b\ 4 \ k
  \  (OC Y\ ׼l 4\ L  \ r V  \ \ k    .!\ \ \ !OOƮ\  V:% V mH ;C c   D (I ɜ  -\ \ \ \ \ \ uW\ \ S \ \  / C  H O H\ X6w\ O O:-  \0p ߟқ  I\ 8x<Tʤ  \nQ    ie5\ + \ > #f s \  ;%\ km L\nb^D\ \ US 늖; fr   \ vVm UbS \  EssB\     M \ \  \0 iJ\ ܩ*\ 8B(A  }*\ ˞L`    0\n NqV }X \ M   *  t>O {מA  [\n ϥzF      \ a \0 x : RѰ#  + \n ֎dn\ \ ^\'   Ե	m Ic$a \ t \Zn go\ \ i \" Y 4f r=+   t  \n  vR A \\ ΋ +, =EgdZn\ \ \ [R T & \ 0:\ d J>C R^\ m  \0oƹ)B    \ ð |) Z&@B  T t5 \ \ ? \ \  CE F\ H \  \0qT Ao5  \  \0l$9h  g \rK \ l     \ 4\ =Ȼ \nҀ&8   b\ 1    X4-gl\ ݄ p\\׃Z  qK Y\  \ \0\ \ G 4\ ;4 ,    0{q\' yZnB <g \ 1~ :k ЁZ \ \ \ ?k <i rsҳ\ \ \ \  x\ S\  fI8 V\ \ ˖ cE\ pI s }*  7\ v      ، U ݌k t Y ʹ\ \ ѡ. z g-   \ \ 3Z8q  3 )   -^=:\ \ 2, \ 6   f;H ٯ>\ o \ \Z7 `G  \ s6  7e=  Nl[Lcn\ \ s j ͧ  G6N$UR \ t\ J~ c  \ g    l* `F2& y!  \ \ \  D
   4 e+4۽*\ e\"  6\0   V\ dt\ 8  \    \ \Zf   ݟ Z  \ \ 뚳k{ d} \ f\  2~ \ Gs\Z #\  4\ ^ k$hL!00\ \ \ F t چ pдM \ <\ \n   	 +r )\Z\ QA\  \ X ro/ ( \ $g J\  3Х #J\ h F;zԟ/|Sm\ ܃	N,s  ?Z A \  9B ~ \  \0  G H,q\ k o\ E\ gT  \\l\ ] < 9  \ \'6,\ ) `~ ַ\ \ \ $W \ RH;   \ 9 \ _!  Ѽ \Z\ \   o\ s M6\ r Mw  wuqy8]ɱ x n    \ 4\ \ `  a \08L\ q\ V֓ > \ \ ƓE0\n\"Y
  \ \ Y- 4   \   U9E=	Q  0`I hS5\ J\ J  u  ȋ\     \ FE OlM V 3׵,  \ g3~ # VSw7  \ <  \ 3 O  <Um\ Ҽ  o$ J\ X ݨ\ ׊\  Q6 y\ !*\'i\ Q\ fyd:\r  y2
  +sp )tf    j3\ o/n\ L\ \ \ \ \ M*\ v \ 	I\ \ -  x~\ \ L   \   \ \ eG  /b\  ^xcQ \   : K\   \ +  k\ q e\ \ z\ \ MM:\ [   \  #%  uō\ 8 a   \ \ hO& lome7q\ `aO! 5  h F ޅ{a\ (\ z\ \0 ֬J z6 (  2\ ] ?/^)59mP\ cX G \ d  0  ;\ ] jG\ {k     F- \ \ \ZM\n[- \ \   \ qHPFJ  \0 \Z~ a \  \ kX 12 \ \    _\ ?\ \ LM J\ .̿4\ dv\ YN*k \ %s   |^, \ .\ o ƠD W\ 9\ \ \ f L \ k I\ ^  9o\ \"   h\ Lv*,\  \  t V. q   |iDE?4\ \ \ Ң \ V  X        uW +
bG\  c z\ o \ Z\ 2 FB\ ̿\ z皷%  \ -ݴ    \ D \ b Asb  #    33 \ +f {  & n o\ w? ǹ  \ %O\r\ ĶO\ I	. \ 21P   \ \ \ \"<  ?\ ?c  ڵ  \ \"1,    i]   r \ ^      ߑ  378 ]  -\ \ L H 
  Js  \0z { \\& W  qn  ) 8  |gs  sis b bܱ*{ kv6R \ \  \ 2H쪩\ <f  \  KJ \ t\ &\ {u \ #  k  (  ?|  #\'iS\ x\ \ \ e \ :l \ \0@I \0\ T    \ |\ BiT J;eI W\ >\ \  /  \ UWa ,2    i   \ &YTrA   \r۽ \ \ 06\ \ `gc   J;s F\  6\ v\ cxˏ\ V J  3 ~s[O    7 {W3\ -J[O\ \\\ i, + X  \0c\ $P4v\nWw PH\ A V=  -\ \\ã߼n2 1  \ \ |Es \ &} \ $)c$#i=?  6X ;~ \ |J4 I\Z2 %\   \0Z / My \ K}u ]GCs>@ \  \ hБb h\ ^K ; \ \ j \ $gWX   \nmbڤ z 8    @ 3  \ ZX\ c .N9\ W \ ≴m\"\ \    EUK \ \ O\  # l^%G  X \ 	\" V\'  i4 hҝ  \  * KOZۺ\  \" \ .\    \   \0    & ^ \ ` \  \' \ V̋)\'\ #  W  О(XɆh     \ \ \ G  Z\ \ \ \'ޔ7A ~f R ? =pO \  \ wD = q\ k\ \ S ?  ̮  ?\ Z    oβ<XcmČ\ K 8a ҟČ\ Şaz. \ y  : S\ ,\ q
5\ ͛c \  *  \ $ - h \ c SQaK  \ \ |  | 폥{.\ G \ B[	$ = Iz	T 6۞ 5< y6.M\ \  ~\ \ 4+
 \ 7$  ,} iӤ YNE \ 1>\ Ct \ W 6W \ \ \ 5  
s)  \0tt  ,  \\Jv_;      ]NLP( h  x  !{ n  B \ \ NҢQ6 \ џ ֺ}  yV\\2M&  ]\ m\r I, \ #\ W ֟  \ G}F\ +Kr \ \  i\ \ CPA\ :m \\[ rFX 3  S\\\ O  \ R w  /X]   }\   2d  \ x $ žl@ -Ruǣ \0:ψ  a I\ \ \  \ \ \ \ \ |= j 24P5  F9\' \ uSv \ V-    \  O\ {WH \ \\n\ ڹ   \ HQ \ 9\ k _  :w : \ \ G 4c\ x  WϿl\  \\  !\\ |й
\ ץ{\ \ \ [ ,ҕX\ R\ pN\0   \ k J I  = \ \ \ \rێ\  : \ lm\ \ I\  4?f\ ]B\ u\ e% Urxˎ \0 n  \ ֗ \ =  /tQ  f \'ڹ/\0\ :Յ \ ( Q| 8N:   ա \ \ R    w 5 l-J)s \" hTo d{   F\"G\n\ \ / s\ y v  zw |Yk\ \ \  ) Y\ y\ 	C  \ \ U \ k 5\ |:\ u ?i\ N\   3 \\  +d\ \   s \0}R\    \ \ \Z  #$c  8#\ G \0|\ K\ 8 \0\ \    u    \ =   q b\' \ \  # 4\ r< d \ [a \0  lW \ : \   0<\  y \ \ |I \ \ *mW& L\\ q  /\0ǉ \ 8 j \  \ %\ Y \' {Eo po   _   6\ / \  u  ͋\ 5 \ \  >ֵ :  o J#\ }8 \0\ 5 7   8\   \0:\  w \ \ \  K\ g X   \0 8{_\ Cm\   \  \  %\  ( |m \ \Z\ \  \\xٿ\  \0 \ # \0 ?   C4  { <[  \ d? \ZȵR|-\ \ @ Yr /\    \ YV _	k  \0    rf  $   \ KE?    \ \ L\ G H\0 \ Rِu JX\0!#  ) c6O - \    \ e؟i \ n? \Zˑ| &\  ۬ \ \ n
o3\ q6\ \ \ ~O q ?:r\Z}M#-}   \  9g o )o\ZߧR9  J\     \ #\ h\ 0; \ \ \ \ \ \  T Q  Q_ f\ T0   \ o\ Z%֠ =.\ [  1)c W |# ޓ \ M6  Mr41\ n\ `{ {}+\ 4\  %\ \ Km*\ ;$E۶ }s  o _5[R I JAq$  \ x\    \  \ F \ 3ٝW-\ a$s\ #ښJ ß 8 r  \ Hs b P 3  \'sҐ \ 1\ AG\  4~\ \ H\00#;  ܸ\ H\ .\ \  \0\   \0,(
 ?\ R     @7A\ AW \0 9 !|̟   ir\ |Q \ \ ֝ \' X~F I  GHd\ \"d>\ \ zBE4  A\r  	?\ R   \0 A P<\ \  hq=! i  X    \ ^u \ \ - \"  5\ ٘\  O\ ^} \n)\Z &eA   х \"91 \ g n Ϲ\ + \  v \ Wn \r\ I  z\   : 5[E%|\'r\ 5\ bwG	~\ LM \'pT\0J 4 \Z <?9 Z ҁ>   xy  \  \0\ \ }=N\ \  # \Z}\ \ \ 	.u 1\ \    \ \ MW {\ n\0 9 륭\ E \ \rs\ K  w75]	>-b:  U  |Cw \ 7 `? W  )XK \  D  0\ -\   P\ \ ? 3\ & g$l q g\ \ V  Է\ -@\ ĳ Q \ t \    \    C\\\ m ԣ  b\ \ е Ç\  ԏJ ?>5d\\uS\ \ t  \0 DGu    n%=G#=  \r\ \rvy    I  W  \0   \ ~t   X\ d   \0\ \ \ \   B  U f \r  q a\'\ Q\   6  |; *\ з 3 9\ + ,q  \ j   3 \ \ \ I  QO   !  \ #aMwn  w  ٫~ԵmKj  N[\' p  \ L D- 퐍 \ \ и \ \ )f`71ު\ 8  I \ D  !2\ 1V\ _\ \ g  \ \ N  v?\ V \ \ ? *\ \   \ h\ \ / \ \ N 2!  q\ T A  .=T\ T\ \ ȋ\ \  Ϩ<Ӽ  l 9\ )\ z  \0\ U 9  \ gH\ [2    ] q  慨h ܱ\  ?p [\ k  \ 5  2i e\n  \ g \ ޴n$ G  pw ? ` O\ \ jE\ i  y\ j\ =I \0   [ 1 \'<dU=mI  V I ى     \ CZ\ I[\  x1 Dm\ \ k  K)  @ \ YN3   \n\ \'R     6\ \ \  g  !٭5x\  Nƪx w\  g`&+  ^W Mj B!=3\ U Di:S1V\   pkF  \ \ t # O\r\ Wu\ L jv  d \ \ 5\ K  \\d\  \  w
\'  # \ ڲ\Z\ ڛA  H V&B\ RAn 5g\ V \  \ \ \'`8- 1PEc,\Z\ \n  X\   ٦\ . NB ˁ \ ֑\ - _ċr J2n]&\ [<\ \ ? JH N~f3X $  >   ӬjA\ \ \ ]   -% \    \ \ m;*  \ ֒ \ \ [Z02 \Z  d\ f8c ڛw&  䫓  y\  R \ ]4m F>z   \ U   \ K \ =  	) \  \ z { V 8c+=B	 X&g   A \ ? V \ \  MdX1 ǒ3\ ֧/q i \ $ \ m IpO ֲm MWSխ᷂H`(3y# \ @3\ 5.J+R  \ \ y.S[p  AȈz}*\r\  TF\  yc ҭ][j+  2 R \  	 \   Hg\ X p|μַ\ Zl\   \ \ \ \ 1W w  \   뻃 - D  ZԟN\ \ \ :$ \ Fȿ62} ꎛc \ e,s  / \ T #  \ 0   B \\  ?dU`[( zf i G  FQ \ V  ̚&.6  \ \ ڤѣ\ \ N\ \ \ y~:\ O  ԾjZhA# \0 X\ \  *
qn2A= j/md  1\ \ H9.}jfT   \ \ \ )`,- \ X ,z  \  \ 9d j nߍi\ co)v $2 w; \ 4 c \\\ 
| *  \n\ ɏ\ 3L\ \ \ . 4 ^\ ˁV \ fI\n  \ \ 85k\ \ ɂ\" ]  /J` \ 5*\Z,I$ \ =;
\ W  \ F   \'  ^MJtg_(ex\     h \ ۣsu\0?\  ;\  &u܀)M\ ;\ ! N \ ٖ  a\ #E<\ \ ~ \ \ R \n ﻊ\ >+k   i a	v Gf!
p  \ \\7@\   \ \ ɬ   a\ <\ \ |ݠ!\ \ = <\ \ ^\ .4\ S 5Y a s \0֭\ E\    \ ٱ  \Z o  zW7\ P {\  \ \ & d\  & =*)N  \ N 8\ ֱm\ cQ$ $\ ,.4 V \  :9# \ \ 0=I  & 	\ +u ]  tq x   6 \ J \ 8>\ 5\ \ zH  H  ?m 2 g8RN8 \ WL\ E\Z\ 6  M 
(M GD   t     yZ\ 3+.c <\0k&8 \ \ յ4(\ \ \  $ I ګ\ \    DÜ1 p=^ H 3\ ݄^G <B\  s ݎH5 Q:M `E1\ c ^ h  W  \ 1 ` [ * \ Y \0fyO  V}  \ ^?Z\ Doo#N\ C _H#LH rU `\rR\ \  a\ q _ \  \    2\ \ ɢ \ \ ˑq  jvvMu\"  \ \  \0\ x  ҍ T  Ju\ g\ \ \ 0}E6֍   D\ 0! t\ # ֣[K/\"<\ \ \ \ \  s\ =jl,\ ]o ]   s     Fj/  \ & R  \   đ˸:2 ^}t\  \ u\0 I\Z\ ɴ/ \',@  	\   jP  \ \ V`\Z\"   ^}7Y \ c[\ 1^\ Mt\ /  Nd+ y+$l\ >\ t \  kpr   xr\ O\ \ \ \ g H|   S   b z  *\  ֬} \  \"\ r Ɍ       \ \ \ Q 8\ \  c B\  \0\ \r\ & \ ❅ ׃4 \ F H 5 \ q  Px\ \ \ ]/KTEl  \ \ \  \ ^mw OvٚR `d \ 84\ ϤS L   $G 9  ?g
 ۍUK \   ) 2\ e8  ; \ og\ jhz\   p 2A*   > r \ }|\ 6>X}\ \ =   E \0   X\ \ \ l   \ \ ~7  \ \ 8c\ a\\:  xV   ^\ xU %   ]  7   \ \ 5a\ _ \ \ v   0 ,v @02\ \ \ /7 <}5\ ad \ 1 \ }\ \ QҴ\ 
V  \  \ \ c{u\ WHѼ#\ 6 \ u$K <\ \ _lv  ;  \ m,] \ \ \ \ Oxb>Χ\0   㗀 sK2#:  8 \n޽  [ѥ  Q +<~X Ha }++\ d\ 4h\ \ v\ \ \ 9$l 1 :҃JC [  mc  Z\   [ 3c\ )  Ey  \ ʒ\ \ \ 2 t0 ?ʽ \ v6\Z  m\ n<Bm w y +ǎ t\ y]   ` xg     \ | o#`g 9\  Z؛l`\ , \ 젰 \ \ wa#\ x \ eOc ڽ   \ \ t_ ]\ @ \ \   \ 5\ \ \ |9x S \ \\  \   21 ׸xHh\ \ \  ]_\\Z  \0v * a\ }\ g&  QF [  R\ #\0  ,  e\    \0 <Md z\ O   )  >  <V ] FNIs[ {`-?7\ P \ ZT  d \ \ !8? ]? 2*k $\ Zv  { 0 \    \ \ \ Py Fz\ e ] Z   xkD \ 1#ӓI7 5+r\r   \ 1k\  \ { \ V   J\ )\ 9  / :\ w+ H皳\r Kd6 Ԭ-\ 0  ~j  \0
OQL \ m \ \   @  { |   \ \n  \0 \" L\"\ \n 3
  \ k\  \ 5;  -5S-   9  N\ [ Hmot\rV$   \ w  \ \ [ J  h\ \Z   NJP }   kė  \ FּEn `Gm*ƿֹ[  \ wi`Ⓓo \rf O + \ J\"\ c\ $  ޵ \ \ Ez/÷6ҢZi\ 29\ r3x \ @\ D)qwu\\   \ \ \ b \ W\ >  \ Q \ \ @\  ǧ5\ *uStڱ\ : d\ e+  \ Վ\ ,\ \ S\ t\ \  4  __Y\ \ b $sB :  z  1   k  Kl_6\ ҫ\ \ H\ W \ \ ͆\  #  \ iӕ   V n =_ \ WF d  \ \0%\ ڹ   I\ + r  9\ J \\\ 5[}I [E-\ \ ̍/( u=z\ g\ 3    jx ; |# \ r\ 4 \"D$\ \  +\ 5[+

 K=KT   .?t  }\ Ƹ _ g  \ \ P\ \n\  x\ r  \  \\\ \ <Ť \ ݎY \ ]Xlk Xu1   Y\'3\  $\ m\ .  ~k  <Lu# y  <?! Ȏ	T @{ ޯ|ֵK%  Y\ ]&T1  \ 6r8#?w\ _\    \\\  Z  >s z\nҽ_ E7 \"   j;3ȭ 	;4fy =1\ }\ \ \ ;I\ \  m\ @ in-\ \ \ 2Mq\ % ȆXٺ \ \  \ ʋ\ L  \ \ \ 7\ յf Xw\  \ { n#\r b   \    U\ >\' \ \ He@3\   ν;N\ \"Ԭ   ;&@\ \ \ \ J­>Cjs\ Eџ\ 7\ +     ڏ    t   ? *\ ~!d\ [  ~ 9\ O \0x  ?\ g \  O$ \0\ u t\ \ \ ##  N\  6r|  9 H>#By\ 5\ \ z  @ sC\ Cb \0 \re@G #:\  \0\ ʚҴ     x + \0  ́[ \ `ㅜVL\ &\ `Y \ \ ? \ c ̸\ _ \ [0 \ M= \  \    C \ F\0q  :- \ lx\ N?\ \  \ V8 #{\ \ [L   \ \   X ǂ{   Υ hkH\ \  \0\ \  \0e  [ ;mS]Ae6\ ^m-   5 \ \ ;   \0\ kGg} ^h 0\ \ -\ ؒ% \ \ Gmݿ*  \ .Ɣ䔓e\ %   u \ M H U c\'\ \Z\ m\ F \ f㈊ Yz[Zx~\ T  0 v\" .  W= jΏx/& \ 6 \ \ \ J\ XzSQnGN*p \\   E iq\   \  ɫ~<\ 58l\ V \ Q UU
.0 ;`\ G]\ ҟ 䟠=k\ ~8 X\ K V m!  ǥ\\  *u\ \'v y  \ ^\ \ J S\ \ q   O  i0\ \Z	
 \ # \ [Z\r \ -\ w B\ ي2 \ }	\ [ڞ  
Y\  N6\ l\ ȯ: 	\ |\  \nЫ c\ m Z&ޭ +b\ ^ RE|2  \ \Z  i\ Z6 Oݞ +>3 t  Q^Ǻ|=    j6\ {L% 8  8 5\ r  8\ _4|\n S\ \ \ 	  l\ \  `d     \ vE \ r|  \ s Ҥ i\\    ~ O  Ns \ C \ A \   \0\ 8\ 
   : \  \ P  d {\ ? \ ?΍  x\ ?\Z0\ %:\n Ǔ \Z\0R   \ hظ \0R   \\ 9 i6\ /\ \ \  \0\ % \ \ \    \   fߝH\ Fߝ\0?fG/\ \\ J%\  >Q \ \ \   \0 \ \ |vc\Z BKF6\    7 ˋ 8 4m \ \ :\ n 6xFsꦭx 3 \ 0+ڪX\  \0 Jc\ i\ ]j \' !4 
\    L\ [ $ \0	 X)  \ j=✘  O OS \ \ \ !t \ =9 U[   ,O \ \ \ ]  \  \'m*\ \\o  m< \ t\ \ \ \ \ I\ 3\   \0  \ L  j;R\ \ 5/   5   \ gw8   \ o\ G\ y\ +;  ht::   r\0o`G\ [Z\\\  :\  k,4p A|     \ h\ gy %sl\ [  | + [  z % u z O\  u |\ q<c d_\\\ \ ̑Ϊ \Z  ȭ?  T ~\ ׌\ 5\ E \0  \ q\ ޢ \\\ c =  *ü  \ !  ~/Mp:  - \  2> 겵| W  \ l֌ J\ \ gݪ \ 6c J\0\ КT\ \'  s\ 5t\ vB\ oa\ u\ X Κ\ \ \ c EB2 \\ W= \ \\\  S\ 4` \ $$c\ k A\ \ 9    b\ 4o \ A \ \ `cˬm25 D¨\0`%k  y \ \ e  ?N\r  \ 5\  6 ߊ4\    ܥ   w[ 2 \ t P  k 8\'>pi#Wa ` \ M\ qkVY\   \0 h ;s \0  ɐ~5\  A\ 5\ k\r\ \ \ Y]  [    \0\ 2mwc 6xi3 \ .[  	 V? n  Ҡ\Z n/\ \ \ \ \ \  Z  \  \    \Z \rO\  \'\ Uc\0F br{  )\ \  h !.\ me\ |  \ \  ?̹  vF A  \ \ \ \\  ]8wk ؕ{   \ \ X D\ /  \ YN0 y s]t L{   , *7 OF9  q\ ? emB\ ηI\ ~nƟ> \"\  RI ֱ 8p\rl  +?} \ x\ l s\ Qi \ / l\ p\ y2 | ޣ H \ \ Qrc! \ 	 k>k \ H\  ;F V P \0  \ 5yw ` \ \ N >  gνׅ  ƪ\" \ \\M \ 6\ 0\ 1\ +cǄ \0k\ ɜ  0ֳ G5\ (\ >\ #   \ \ WWL H\  B\  VֻH5 \0& q C \ O1R p\0\ ~U\ \Z \ c;t ze  ~ p ]HY ,d=y Q \ O)% G Z\\xl\ \ \ Ů\\5 É   X  \ f6J \ \ 6\ 1 \ Њ 7 ==  r \   (T:  \n72 }\ \ O     \0  \' <PZ\ T  m
of \ = \ \ oË$  \ \ z \ [;0 -\ O dk\ / \  UY9	\ t\ LZ5    H w	| Ⳬ\  tPnmۡ\ ]\ x\Z\ \  o !0  \ N\  \0\ \rxd- \ lr:C\ k\ l\Z \ x\ jH  ?* T \ \ 	ǿ=\ U    =F\ L k5   n\ \ >Vj ſ  r\ _  g.  Ǩ \ {}E\ 3a\ ^c ) 5̷1\ $\ \ \' ř $ WE:W\ aR   z\ 4 4 R\ \ \ \   v \ \ \\ K\ bHf 1c\ &1 +  \  E A ,u   - YEo  a  \ r\ V :\ ;\ 3Z\ mDx  #\ E:H  7N7ep\rR  F\0\   S  rB\ f g\ ,I \ \ I    i t ?Y\ Xf\ \  \ o~\ \ %;   & \"\ )X\ S 5 \ >§\ \  j\ - c \0 m |   i \n\ \ \  Ν  J & \ i  \0]   q   4\  ,YG E\  e - D\ Ԣ  q{ \ \ ڢg\0e P;fAPIwp\ 0g\ \ )\ x M ͌7WV\ \ i \n pI# \0 \\\ \ e\ `Ҵ\ \ \ mKv\"Q |  \ Z  T :$  s.\ \ ygx{   \0 >% 5    7\ ; \  ]T \ Q\ \ \ khy] \  \0\nh\ }   I\'\r\    l<i\ K Z\ \ \ dY C \ \  Uϋ
  <5y ۥ \  rҹ   n ך\   \ \ \  v  \ \ < \ ͝\ = 1U\   \ \ \ \"= P    \0 5w \ Y  \ \ 3f%FA \  V> \ }\ ? \ O\"[  o s Eqn H l@\r)    \ \   X\ ڤ \rC <\ \ ] 46 \ \ ǅ \ \ Y  ,\ a   b  \ \ [K G{\ \ \"1  v `팅5\ 6\ DX\ [s    \ Y\ n\ N}*ZC  ]\ _\ -ݸ \ ZAC9Q\ U\ \  \ ?h\ \ K \'5\ I ep\ \n G֘  \ B   \ q  R 4 \ M 0 q H\n
  9ozm ī\ Ե    a\ sj )\ J\ ͝e d`~ \ ,̄ \ \ \ \ 
 W  \ 5 $* \ \0x Z\'Z  \0
W\ ^U V O1\ `     a \"4M &4\   F4\  \nn\'\ mª \ 5\ wsx\ k  \Z \ U*0 lsҹ e  jk  \  \ Xm\n\ j\ N\ \ \0t \ \ K n i \ \ I) d|| \  VTR e&ub  t-i\ qK  \ \ ϩ\ k  \0gq\ \ o*  > \ =#I T L\ ޓ W岎 &\ \ c\nI/\ q\ 5\ \  D 6  kZ\ \ č  \  tYq֬^   ly\ \0 5 m    85\ T   P~\ 4чZs6B J\ #   Z6 u \  ^ZJ\ $m ; ⾊    :\\ 1$R \  \ \ \ Z}ռpj\r i T|pH\ ]  f \ ,\ \ w1\ z}*$ )  j\ \ > X\ Rk 4\ \ ِI\  \ =k̼;c7  Q =B A\" `ޠ G8#ҷ 4 \ Ӡx\ y\ \ ڵ \r\n\ C\ \ \ \   gGYr@\ \ 5 V\ ބϚ\ D ? \ \ d6\ } \" y~Ue\ \ -WU S {v XRW d) f  #ZԴ \0Cs E<+\")  Q %\ Wں#!= ՛ y -JV\ e w\ ( 4PMn< R >  t \n q}{<˔H\ \0\'5\ \  \ \ Ӧ ! ħ(r\rxܡ   ݜ`V   K& ?(\ q9  k  \ hk \ {{ s\ ]{ ÷Z (\ k[ \ H XoQ\ b  Z   2\ \ Hm6Ĭw8\  m \ s\ <) U\ o\ \ } J \ Pd ^   \ 򯞼9kp\  Lq v?/WA \0 \0   \  ! \0\Z\ v-&{P \ \ P ² P  4߻+ s ޼ 4\ \  F   Ƥ \ \ 3FR_\  V   f -& J.I  r\  8 k  \ Cx \ \ m$ R \ @# r+K Vo \  \  9\ U \ \ M l1 rB m   \ <\ \ Rv  M\  #k   -     . d\ E`\n k 6ѕ\ ASZx ]rɚ[ \ vǉ\ \ >  ˆ\ GҺ  r |\ 8 1  - ži\ , n\ qya\ \ne G \ > \ t ;\ 3M Y ƫ # & \ i  i+ \ \ ڔ,őb \ Lq 1 \ \ u % ܤ(w \ ޸ \ *  \  28XQV  \ \ \ 6 \0l [u\ Y6  `O \ \ \ HZ\  3\ \ Sל\ ܒ\ y=NEe\ =  i= -|     |\ k9ʫ\ \  \\  E*   t3 ^\\~ ͎Hd\nH\  V         \0Ы?D\ \ N   \ \ l    *\  :\ 3f5\ \ Nk\\=x\ 	KsU	Nm\ c\ <:E \ \ \ Di \ \0\ Z\  \ m<!\ \ 2 Z  \ \ V eG  + \\  \ ۫k) \ \ i\ \ \ r\ A
\   ź{\\xoI  ȵ_ \\  G \ ٴu > \ QsI uR| Qd\Z\ \   I ]\ 
iesdH F\  \ ߭| 8ֽ \ _\ U\  }  0[v \ .q  c\ @: \ +nh z \ \ +V  	 @]YK   k=onask- \ c\'x=A   \ %\ \ KU\r 7/\ \\w c	\ \ \ O%]  }E:8 ) XھB 9  _ Ф\ QWc  N\ ,`{ MaY   pa݃U d 22\   \ w y -  j s\  C^ \ ˴{(\ @  x⼂\ \ E W	1\ \ \ Y\  \0Cm\n\ s(  b Onk {  CgE  Y \ \\Ǐ\ _\  r6\ 	\ Z>6\ Kg j/     t\ J\ \ m5\'u $( \ h }6a W \ 8\\y  u  6l  &$r@j\ n\ \ = ! ; f 6\ :\ \"\ 1 _J \'8 <Zp Z mf  \   \' 5F#\ \ \ \ g~%a hҁ\ 6 \\ \0t\ \ (b 
ZDy # \ QP仚  \Zv  L8맱 \0\ k&)\ \  \  r̬ń@\ kN\ T   \  \ 
 e ͡ H    $ i\  ӵw mr)Qe  ȃ \ `?\Zʥ[ \r!O]Jrx \ \ p  \ 1  \ )  J \0S  \ 0@\"p\  \ 5\ p &\ /O   + \ o M v\  \0 k\ 6 m@D0)\  u \ \  \ \  G \ i    ,\ \ \ ց B  k I\ Em ^Y\ VZ   \ ñF	Xy#\' ϵz \ ï\n\ \ l\  Qyi4  \ c    Vu\ \ -\Z	2 6 \ ER   \\\ Yν^g\ +#jTc٣\ |O \\Y\ wZT  ΐI  \   _ +i:\ Ԁ {}   \ 7\ O   \ MKǞk3r   s\ \ i  \ Z6    \  뻉f \"\  ۜ  Z飈   \ \ \ Vn\' \ bg \ <#)W鹏_§ \ ,, .\ Gt    8\ ǝ²  =  W     z ;!yr\ V*3\ ש% \ _  os< \n\ \r @@>ƴ5   9  %  ˜ \ tQ      \ K ޥ\ a_ t\ \ n   Z   \ m   q\\  {  \0\r    \ :\ \ \" O O)\ V~&hi 6   >\\S \ \n:8\  ח: K \ \ \ {7 q >\ jw3\ su >\ jFp=\ \ \ 㐑  g\ \ \ \  	\ \ ( @ \ c W@X \" \ l K  |  \0:A<ğ    \0\ $ \ TɈ{\    \0, > ֌ E\  \ ݊ND 4\ Єs\  \0 LV%X \ ٨+ \0L\   MU ȊA \0 \0\ \    z\Z\0  y   M S t     }I q \  \ q6 ?Z2? &~ 
c \ h\    \ R`  \ (\  \n dG\   .G ޞ\ \ )d   \ \ ( kjAb6 \ E ȟ \ >9 ۪g\ W\   V g\ \ \ ůݜ  \ \ -*c x q\ \\YxP  ǽs\  ką \0  /ч kӉ|%n l Ppsڻj \ g\rF22 \0 \ \  \"\ rm2C\ /=A \ \ \ i\ (·\ \\ Z\   w  \ \ 	f \ =   qC\ H\ ɵ\ 9\ \ ڱ   :\'$  \ \  3 \\F  $   \   p\ r    
 +     .G)- ͺ (   \ zS?x  8>  @Ѽ
6 l.e      \  \0\ Z- \ FV   0#\0  c\'\ 泫 a\ \ \ _   4   c \ \ Ŗ 1 \ Vi    j]   -g 7  9\ >n  \ [\ ZE\ ur i\ p\ ܏Ji Hm6IY  \ 8V*
~u Ͷ}Z \ r \ 7z  %  vDL\ \   <  ^Fw \' Z~ 6  e  h~ӟ 
\  k>\ S ) vq `z{\ e9 M   &\ ē+ \ \ x   \ zc\ k g C  ` \    Vfџ  \ Q4o3   ?E s \  	Y B  
  ?و \0 g\\ E    \ \ =  \0U\ S\ [p ]\ \ dq%    *K\ # \ w \ ! Iln6Dz0   X\ zg /  w0 %9-\ \ c{#94z- U   h D #r\ O W  \0\ Ұ 5\ \ r n2 V    \r R\ \ ,\ PG 2  w -  \\\ u \ I .  \ %   \'   /_κXc[T\     ƹ ? }t\ / 5};\ eᤗ \n\ \  \'xr\r9/!\ \ |  \ | \ \  \ Z \ \  B;
i o+)b7 ^	\ \ Z  >Ԛ \ \  UN` U\ W\ rkfK[8I q 3 \ ~ 5 \ { <z  Q     H BG 8\ \ A9G w\ \ /\ 4\ I  Ւ\ \ /\"NT  }ct \ q\\G   a  Z b\ θ  q  \ ᙘc> ݷ /4 \"M*  5_ \ &\   )8  \ ZԆu FO    \Zɵw4\ \ ]   J \ZbHŃ 
!q\ \  k\ \  \ b \0\ \0\ \ *\ ̲y.\0 O@+\ e U,3 k kS j\ ̧ <\ \ S2  Ĝ  қ\ 2  3  \ bӦK  \ #\ S\ zU\ ˫\ \ X\ /  Rw+.  q Z $ ? .m,/fj]h e o\r\ _\  \ $g   &  ^  u\0 @T\0\ 7\ +;    BJ z R Ct -_²\ & #+  V\ \ \ \ \ 	U\nħ   :W1 w\n   k  2\ a H \ ;W8\ Q{   [C h- S dWQ   )\ \ U\ \   \ nU Lpx>   f-\ f<\ \nsW \ 5Xyvr \'
  wD{4A- 2Z\ +O \ \ ] \r\ 4\ ^
 ;|\  {z\ _\ \ J} ]è<R 	\ \  
z h\ B ) 9?   V H\ P|ͤ\ Jj \  7VQ4\ 4`ya \" ռMy\ << d\"/ Y s+)\ \\m   u Ei\  Ax8\nI\ \ +  J  {\ \ B IE \ M\  9 ZYq\n\ | \ \0A\ \ j \ \r ےr \   xN I  յ\ @7 p j\  w\ !f  \\s \ *\    \ *P =L Z9.  v玕 дY\  o\ \ j\ Ƒn:  s\ \ I?ʲN ah   \ 1\ \   UZ\ \ E\ o w\ 7%\ BFa $  cҒo z 1D \ ʃ\  Tm I\ nR[ S\ 2   ݈\\ 5\Ziz=㸶  1<  \ Z 6\ \ , v^% ^  \ T O\Z5\ [\ %A\ ڹ   \ &\ \ \" A ?     [%\ J \ Q  ȬH 2n>\   Pݺ\ZWW  ? 
  @*  5\ \  ڜ߆\\ \0 6^	B> ; \  \ 召  \ y {\ ̌ <U ?]N\   \ A&  I  +   \ \ xN$R^[e 2 +  f a᫛{8   k \ o @ϵ5\'\ N Zs \ oI\  \ \   \Z  \ ߃q9   :\ ^ʰj} F]\ ]K)   MMS pN9 acMJOdO  \ \ s iZ\ \ 㵻fۿ\ \ \\ \ v}\ [$ 9 G \ jZ P0\0C ~uE [ %\ 1\  \ y j  \   Ǭ 4Ց\ \ jF[ $c z\ t  6[x T \ \ @    \ Z\ Akc h Wm\ b4\  B\ ~ \ l 3    \ ɗ͏\  I \ tЋ   8 -& \    G   ֡ ^ɨ ll\ ;csdd \ \ y 1\ z  hڗ*  N\  R \ 뱵  \ \ Yv ,}OATt i\Z I   L\ \ ^\ ccc *\ (ԉ \ b \ \ M>[ i ۴\ \ Zzh  1\ ¶<-  ։ -   ɒx>կ \"rR\ \  Vq\\\ \ \ j\  \ F\ \ \ Ǉo \ \  \ \ º   ºӤϜ  F؄\n Yތ\" \0  +E     { w ! \ 9  i\  w  dǯ\ ] د\ j7g\  JiҤq ˫  \Z> \\^ފ9q\  \ \  |Ĝ\  v$WN\ ,n0 \\0 2  Э@ \0TI ,Ʃe m \ R 9  A 8-.> +x&؜ \  +  ó \ \ \ H E   \ , T ڏy
\ T\ C    } ;/\ ԞN\  x \ \Zv  - 3 \ 
cb/o\ ]\ \ !H l)\ pv  +\ \ i7VR  ]\ g\ 5 \   婬* X\ F: /j  Ė  H\ 1S\ j^\"   \ \ kX\   @ `i ]  v-,`y\    9 \ \    d\ z  w\ ~S\ \ )J ڽ̩Ц - >\ e N \ *C \ \ZG\ 0=\ ;\ \ZO /  
, \  ?!\  \  5\ |ӣ  V  \ \"\  \ \\ \ t   P@ cY`\ @? \\  _iq \ \ 9\ \ Giǁɠôd(?Zz : \ +=   ?R \"/nb f $#  = \  \\/ %  Ɩ\ h c 7 0:(Md\ >/\ \ 𕷅\   \  $7<}k־x* \ zy\ $   \ \0 @Lq \ > C9 \ [ \ gq\ [;  { L m | 1  q\ 8n\ n,e f  eC X \ Qi\ K\   \0j &  /     \   `+  {j}̈> n\ O1m / 乭d    \0G- cS.      o  )   \ Ӭ  P \ ؿkM @ \n\ pc 7  Oz [E\ ~\ \  ]  e:  T \ A_U\ ⋐ ˥/  %  ~\\,  D\ w<\  SN4 B D E\ \ ߴ  \ |Ym}m\ m A \0\ zp z\ 2\ \ \ \ +\ B\ bl  \'\ \Z\ ?h\ \ }W\ \ D \ \ \ \ 0g p/Oҷ k:k|>\ ỹ  X \  e \ \ aJp % -\ z\"iP!m\ \\z(  ʃ \0  s M\ T \ ;QM\Z~ 9 us \ \ p}Q   bE\ }H ?    }XV_ #\ O  TF   5   \ _@~ 6 E8 np~3\ a ׺ : q| A\ ^]qr 4 g,\ X ^ \ k^!\ \ NH \ $H ?>a\ y \ |\\ )-  $# W  \ {J1   <   * ݳ ӣ { \0 ZD\ n  $ \ \' Mv\ d  2   %\ kOE ~ \ \ \ \ W@ z  2  ۂ \Z <\r\  2\ [ ū\ X    k .̣   9  \ R \ \ \  \  \   .x\ ҩ\ 
 <aMi_ ?W\ \ % Ӵ  \ q岱 \ V6    \ խƒ\ q\ \ z\ \ \ & g   ]VV\ \'5\ \     w ?   \ \ 5\ ^\ /  
ݎ  \0\Z\   \ 1\ Ҥ%)\ kм5q Xxs i\Z *\ d  YRުk\ g^2m \ a 5fW\ |% \ [å\ X  >P\ \ q 8 -w ^/:    kf   R  ? 	\ @\ Rj\'Ɛ\ )} \ }fc\ \ \ \ \ 5\ x} Y{\ y  bk \ \ W  V<\ ݛ5͢G!\ \ y خ\ \ s+:\ A\ Z / s\   .bW \ 1\ )^K\' <ac, P\ S\ \ \0 \"\ v\ {   .  \   \ \  \ ~m \ 󨄤ӹ \ \ 8 9\ \ \r  \ \ \ r	 =\ \ \ 2FI\ _V]x*\ ) \ >\ 1[\ \ |\0H  |;`u?i 9g H\ = اNN\ \ ֌y )\  \0\r\ e\  /l\ ;پ^ j  t   ][;c\  \ o\ A\  N\ \ 0#   \ |K\r \  \  \   \ \ #~]  \ Ң \ [  /cc  \ Y An  \ a\   Ę\ ~ \ \ \   m  }j q  2  0\ \ ?.\  \ \ ߱cM p( VӐ ] \ Vԥ r\ A\ q\ 5\ D̑  \ \n\Z\ = \ Ԉ`S) \n\ \ \0V8 \  Y\ g %\ 6.~ 52xoSc     k\ ~\ x *c٠ ^w gc \   \ 6 MmQL\ \ o k\ \r c\ SM      t\ \ - \ \'[Y\  \0\ -^\ \ =:c$r \ \ r \n  O\ \ ~\"@  ڒ  :*  U* %\ G h V v1\ -ɏn~ +WG\ m |A A\  \\x\0y Y \ -  \ X\Z\ G\n\'(@+\ |- B  ;F mI X   \ <zV  ۱  n O  +|Q\ \"\'4Iӏ +  & wmp  9TP0   Z\  \ }J \ S J 
  \\  5<\Z \ zt
 \  ȩ\  `g \ \ \ `P\ z -&}grd    \ v  & \    \  H݆  wh\ ?  \r}\ k8\"\ l\ @  l{\r 5\   H \ n\ \ \ \ $ \ y   r 7  MF\ \ \ \ )    . \ \ J  \0\Z. i% \   \ 쑄S  1\\    ߂4  ?\ \ <|\  \ V ,kZf a2Qc> }ER ڰ8 [\ |9\  \ }w [ \  Υ\ \  \ .   \ Ǥ\ M p  = *   Ē\ \Z V \  |\ | \nָ \ Ee \ Ȧ R \ v z j]v \ h  { 8 Cg$ :  A / W Z8  XbW\ W ]h    \ \ \n+rQs\\V m\r  5 +  \ bz\ZJ \ J aR )\ ( O ^ \ 1Ez\ Y xM\ \  ^\\ <i |  w5\  iv *@ \ \r  \ \ \ \ ۝8; ;\ n  E  \"\Zd[QB  T \ y% \ \ ѫ m.s\ ^)  \  \ kD\ c P ۱\ \'\ +O\ \ \ \      | \0 \ y\ \ \  M \ \ \ \'rO \ 1 N\ O&\ \ cS/ĭ	\ \ \  \0  yq  S~\ /  x iv=q~#\ x \ O  z A  q \ \   kǌR\ ? !  \  T  Og \0 \ ì8\    *E OMb<  J \ /\ Wڮ % s[\ I\ 1 % R   	[ls\ H\ 0$\ Td\ \ 3 hA ɤ\ OOhN\ k6 \0 T\ \ m\ZAƯk  \ yS #U \ snB<   \ \ ߈/  ́\ YT  Ժr \ 8ԋvL Q i\ \ ꖇ   \ \  \0 P   \0 ?Ƽžx  \ e}<\ \\ \ \ }\ w\nhX  \ \rO(   .ч\ ul~  yǍ Y5 ѱ\0  p > P] \ ե)rJ\ U \ #cG\  D \0\0 \ \ G\ wX^g1 3    \ Wu\ X    3 1\ \ ڷ \"\ \ :\ Y4M*Is\ \ oarV \ 4 6{ +   > f\ \ \ \ ݧ      \ X򼤚\ \ \ 3   S[ \ \ \ ?!e\"< k Ԓ \ \ Q  \   \ ->\ f\ [ | \ s^\ \  \0	N  Ʊ$Cr\ \  5\ -] a   #\  +\  qo __ V 3±    W K9\ 4 \ O \ \ \ S 7^\ \ l  7\ qx \\ Kh\ \ 2  2Gz\ K 7 ɶC }~\    ı 
S  \ ,/ة\ JǄ n=\ ݿ\ M\n\  Z\   7\ b\\ u \\T)Bv \ u`\ Vp UgآI=i # W 
Y*  \ Z o\rX(\'l#\  \0 z O#\  v< @ \ \ Z   ͣ(\ \ b `Y   \ \ No  h\ vr   Y\n \ vcC  ` \ E\ , l_  K ]   Yt «Βc F ̱^\ \  . h1! \0 TԪ? /cM} \ ,on,\" D  \ \   wwct\ \ M2͓  \ }\ zX  \ \ Zw٠ \ 9 TU޲ \" tz\  \ ,/.^I\   $\0:W; xWZ Q\ ZN\ @\ { \ E\ \ L \ )\ f 柌 \ *y+>   Ϝ  |O\"  ȼ1 %F? _ \ZԖ4V\ ޮ\ &8=z\ \ \ A򥽺 \ \Z )ک \0 y5J gЗ*
 \ v\r ԇ緎\"z \ ֵ   U   pK`\ ҽ|%\ \ \ \ \   $ \0\  bQU lB SyJ _\ ۿt Q  \ X > V   /ߴN   \ \   Bӎ r \0\ns\ < RK  S\ KqU Jֻ  \ \ lB\ \ \ a$ \ \   \ ל   i\\ \ l ?t ף\ |?cT)\ 8\  t zkP\ 0-+s\ C 4    DF a W9 \ )?   Pi\ \ wQ   I  { ~ MFl`\' Jz \  :  C  5 L M#\ &
V\ #/ ֬2Y\' \ -4{  Q  \0?\ \  \0|   cA k-}de,l_\ %mcN    G v \Zkk\ \ a 88\ \ P \0  J \ \ ?y  K 1m\ 5 IU K  O\ M G\ +KP\ 5 \ xb O\    0l \n \ \ 2dV\ J\ _Y   ~   \ \ Nw   X  W ;ui <   T\  \n\ Z   ؏ \ Κ\ R  6 t  \ \ A  r\  ݜ \ V  搪 ,ʣՎW\ h  /oQ =\ >\ \ 5 \ omu:   \ \ \ \ k]R\'  \  \ 0s^ |a _\ \ Z[K   \ \ \ Z׾𶝪iK  2Ga* : g ^tcR  \ c q MFoV\ \ T Z  \0/ {n\ Z?\ p\ >+\ <7w j .   y@ | \ \nS W\ \ I\ \ v\ \ M+  7\ x3? 6߼JqJ m   C U\ /\ )\ y\ \ru p\ g9  d  \  \0\ Jt V\ k?\ \n    )ꯞ\ 8ǰ\ }YV->NR\ > S    A=\ ғ\ \ R  \r\n   i \ .\ G    \ Ԍ\  x %v  3vF  \ \ \ R\ ƈ#V\ 0Ys  \ ^7y \ \ \ }*1H \ Z 	߈\   b { ! ] ^ \ \Z  \ ]r;8%\ \ H\ \"1\\5\  \ \ Έa\ s\ cF \ <F\ \ \ 8K\" i$Q {zW xB\ \  oN    t\ 9 \ \  \ sNд\ \'\\ ҵ  A+  8u  WS \ j \ ş \ Y̅຋8q؃\ \ 1 \ a\ MV y;3\ Bṥ;}    }֟ \ Q\ 8 #\   Ӑ2 ~   -F\ R \ e\"\ p B e+hrԇ+ \ o\ M \ |3% \ \ [> s  <5 \ \ \  B^Y[h# ֽ \ ^      eq*\ O   x\ \ o  \ \ /\ ԏ    p˚ ~^ \ q :<\ s\  U \ X \ +   R\ p  # ֏\ A Awt\ \ lG؟z \nuI\"h\ @\ \  d\Z _ 4\ M i   䃺Q\ Z\ 0rJ 2   7 v   \ Oa\ I%i0 = _k +\   \  o\ \ J\ m\'V\ ~ƽ ,;\ VbmϠ\  \ \0c \" !  j\ 9\ \ )F : &\ Ɠ\  V+ C Э= Q \ \ 0 Xsd @a\ P  \ I\ < (\ \"  /  s6\ ݫ\ s^5 Nܳ \ +   \ ۫  \ p 2 V?\ =1\\  \  f \Z]\ c  YH %\ \0}k\ \ ӕZʚ= hҤ\ #  _\ A A& 4!n. lC z 5\ \ mV\ \ w+\ ,  \\  )n @\  )\  ώug ~g\  { \0 	 0V  ^ʒ Fj \ ͞  \ t\ 	K|\   \ !>\ +\ uK\ \ n \ l Ҵ  I F \ \ ơh *΍\ G \ F\ ^X\ ؃  +)\ {(\  ;lЍ Q T   Ҳ| S Ə<\ \ k  оX\ \  \ \ .\ ,h  < á }\ }k\  7\ O  Χ{4   80$ s^ 
\ \ 寸  \ h݁M\ ޻ su\ Mc\ 4 zSX 8  	u!KI H  \   / \ SM6ZA  \ \ s[ \ / X-.  ؑ1\ \ T  \ \      G  IR \'_L\n稛  \ ڛI;  \ e5\ $ b2 	3\  Td    GP W \ d
 Y\ Ϩ#5\ j  j\Z}ţ0\ \ P\ \ \    X=  ;K P t\ };\n3 ^ S   \'٠n \'\ P oZw9 8 \ \n   6V Ɋ?ʘ\  p O ,EH	4\ K M\  \ [2     { Ǥ   y\ \ jW  G\ H[\' 7<   @X  f7Ȼ2  \0\ S4 0 \ 	_ N/5u\  I    \   Q \Z/ oU\ \ \ U\ S >\  \0ދ>  \  U  MC\ q  IR  ] \ D  j ~}>\  \0\ b*a\ [ 2 1\'   U  \ &k?\ \ E t  _/ H ^  `j\  \  G\ 4 E?\ 5  \Z
SQ  \ }} 6W\ z# ~\ 醄\ \ ++h n @\   5\ FA\  \ [S _K p3Њ穀Pj7\ \ 8 %{l]>#Ч D ӷ!є \ \ A  |\ [ G\  \ T 5   \ \ \ 
`2 G rI o  \ ĸ\ hb }C*  7 EL \ qĩ=\ ?o! Q   d #   \\   F \ ? \ T,>\ !\ u\ \ ]/Ŧ   kh  vٴzל  N\ <1uN t F~\  {b \ BJM. EY sgZ \ _\ 2})\ \\  > 5      \ t \ A\ \ V  p z\n π $\ 5  \ \ \    \"d\ j 0\ ֽ\'\ Tױx\ }  L \  \ \ \ 6 ?t \ .\   MF4\ ,  =!5F\ \\ >  \0 x     \ \  JW׵   |w\ Z  T SeR\ boG\ m%\  GY L\ n \ I  k
\ X[\  r) x  t   \0]Gժ.      # n ĿA\\׍u[  \ ,p ǐ  B  ֭  \ ##   \ Z  \'i  \ \ \ \ \ t+\ A\ b   \ Z \0  \0 \ \\  D |n  R\ \ c{ $ \  \r\   O O ԺM煴\ N\ u &     K \ \ n-h ~]B3   Zm ~ 8#=@  y    {I yg |$\ i\ ױI  Z\ \ \ \ k \0 yZB+ Oҳ ox7ZTI\ \ J os7+F\ :\ \ 殕3p\ K \0\ \ &  \ \ KΖ K Brw 0+\ <?  |w  h \r @\ 
ۥyŏ\ Mz\ \ G \ \ QضC+O J\ 8F ړN.R \ x\Z \ ~ IKy  ٫    Z\ :   O m+\ \ M Íb$P q \ p _j\   /\ \ w [\  \0 B  r \ \ \ k 2Lڦ C\ l ,  \ M գE4 ; ]߈\ , \ @\ \ \ \ ( * \0\n }\ W\Z\  --P ἴn\r;\  V  \ zm\r  /   qC    5\ \ \ \ /\ \ ,仝 c I5\ Z\  꺅\ \ \ 7\0v\  # V u \0h\ LaW1 W k\  E K \ \ 6\  \0`(  NJ ];m \ |5 k\ \ \ \ \ |  s\ S  \  (\ \ \Z\ ; Y_\r k/ \ \'  	Hv\rԑ\ K\ MF\ \  \' \ \ )$M  0\ j\'\ . 6 ױ w=CM  4 {  2F O }    In \0\'  8\ Z\ G    sT\ FO  } } \  \ G {?Њ \ \    c \ \ R $s2@\ 2   \ nh ] k x\ *\ 68\   Z? ]q X  ɮ úq\ 4  2  \ \ NդoS* ^\ \  \Zk;׳\ g \0\'\ Bit\ 	M   \ c\ _x?\ \ K\  \ Y>֐\" \ ̛7  I     fM&\ \ PQ r +\ xZ\\ G ]gR\ \ ̹Ѯ4?
Y\ U \ x\ s +\ u   y7  \Z 8&x U ( \ \ *8  \ \ b\ \ \ 8 \ s   F  ͌˞\"   fyv ~   \\!s \ \ W_  % O h  \ Q  n \ &\ kKu \ \    - \ p  iP  0D\ 	 _\ \ Q l T  G+ j+qc \\\\\ ~\ B 2+\ .  \ .%  
 \ ] Ԛ ]~F\Z- ,\n \'ҹs:/ \ & 	] 0  ~þk<-:r \ k  E$ +\ |\'  \    8 ! 2 \ mX( \0f \03]N   #  Z\ \ jX w + A y : JM# n) \ o>\r\ i\ 3\ N\ s\Z\  U_ p~*ю  \ ^ #b  5\ ~#ܺ=\ \0 8 k\ 5   \ K{\ 7\    \   K SZpsv>c f 4 X թ I\ Xd\0  \ h6 \ S\ \ \  F	\   $:  kk,E \  )   \ \ 2\ /xO\ S wX Ԡ\  #\ w _  {`| ږ `{ɢGS \ A?6} \ y׊ 
C e\ Y\ \ JT( n[$  i  \rCĞsm\0 (  O d~Ղ\ ڛ  1ѩB+ s3\ 5;\ ~& \ zuƥ<P6$vwg⹄ U \ 7 ;\   u# \n a \ å  F h    W V  \ \ R\ aF\  ۇ Q   \ y  ujN* /twKk9O\ \ Z\ , \0   	  \ 8 zV \   i>\ qm\ F  B f >\ 0SK\ \ C   K       P0?*r ;ҕ  Р \   ێE  \0=iJST +  g M\ y   (Da Ur \ \\pi  C MU H   iX/q\ ƍ\ \  KǠ \ zQ`+Mf\ \n~@\ k9# (\ zS })  U%h \ \n\ N N\ `@3 +  &F`\ \ E sj   \  \ k   7s  o 6:T, aS  \ \ \ tn 9  \ {G\ I \ \ b ȣ lդ\ \ f\ е(P?   \ R\0Gzj \ a}I  84 i8\ \ \ 8 \ \ \\Ӣ 0]\ s7  US  \ q$s\ :-Y,   P J \ \reZ\ |  \ e\ m@\   % g     $) \ _  U   bckk  -   \\G_ [  #fB\ Ř \ js| @oʦ~h ێUҗ  / /\ -n\ ^ Q\ # ۝\ oVgo \'  \ ! \ J\ 7\  OҐ^K  x*   i\n\n ] \ g\' \ z> i`d H I b7  M\ x }=&\ \ $ \ \ v7f`?Ʈ}  v/s\ \' \ZmP*is iGB\  } \\\    [s \ J
 k  \ r- f  c U /\ O  I  -	 jB\ - \ S  (  g . \  \   T 3u  \ \ R $ U@ u hJP剥	\ 2\ 70\ [$Y\0(  =\ \  Y j    \ } ͉	 dB~S^\ ,a
    \ &\'*?* a\   .2r]O<\ t[\r{GO;O \rA  1  \ =Et^  O[\ ] \ ږ!  \ \ \0f  \ 8ڸ     \ V \ )\ m+ U  \ \ \ # \ u\ U 5GG iw z\Z\ yy(cg\0 \ \ a[ @J\  nS  \ !& pP \ \ \ \ g͚W  B\ 6]+V   r|  4c\ \ $ \' ƽ\ J\ ƀP@+c\  \  \ F\ ]\ \ ՊC\  R\ SQW{ \ \'wd5  j; \  \ [W` 2\ 댌S c  R \ ]N\ 9 \ e\ <=\ \ aՠ   \ ݃ \ 6     +\ a\  \ 6ܟƹ  \0 +    wv    \ d g 4 J\ 9\  2;Ѹ\ \ \\`S  \ EйF })6柞  QpH kz~  N9\ Թ \ \" \ % Ǧ   \ $ (bf\'wP* \ [  B\ U\ Ì 0 \0\Z\ >-Y  \ \ s   U\ |  \ \ Gʖl	 , \ T   Е\ 4{   \ ~& n\ W  \ rDL\   \ \ : \ w)<f H\ x\ )4n X\ \ hٜ  ,  \ ӡռ3$ m  \ 2y \n\ \ # \ C Q \ \ {L \Zxv	,bl n\ O 9 n\ I U H~β\ \ F: _+w\Z g\ ʊ \ SD n  h\ \ \ !R\ \ |\ \ X Zm     G,c=   l 1 \ ˍ$Q \ \ 㻑  -2,ĪGN\ ы \ F2\ s\ TjI\    7V -  ya -U \ ~l`v oS\\   Dw `\ \ A \ ) lZ  < m W.	 4`t u.A Ӑn\ \ HA ٤>敂 \ )  > /n  ~nrj D݄ q \ :!\ 1  \ ӣ$ þ  M?ni   8\ Sb  jF ┟zk1# 4 \ \ , \0Q  \n\\ :\ X z  ݌;Q  )|\  C@  E laړkjy \ 	}piY  \ \  :Ԇlq ?*U `Rw\Z    i< f ԭ1<d\ w }\ KQ\ t0u\ gT\ n  \ \ ;  	y6 \ w  =P\ \ 𫍒   b \ .s ԛ \ :\ Sl\ T 9lfks_ڛC< E(+#@\ i \0x\Z\ \ ^\ 5$ 	vc!\ Δ.9\ \ + hwҪ ??J ЍM[!T 4G#\ 
\ \ b # \ \ \ 3Y~6 |GὮ h.\ i P\ \ ,2NG\ \ 9 D , X /  L  \ \ Z4L  T\ \r   k\ ME /Kas 6 \ jӴ  y \ \ j E 6z\ WA5ս\ y ʄz\  \ 3\  U{)_ \ \ eR;   \ ȧO   V G > u
mx$  \ ^  C   \ 5Y\ h\ \ &ጒr f\ \ \   X }  G(G$\ `\ 5[  \ N 7 \ Ȧ    i} 7\ \   \ րù    м Ub.< I E( ( 
 k\   \ \ E  8 J 猚N+ JR\ E%   &\  \0v m\"͎Z  \ \ H  ҃\ #EV ٲ \ @\ b\  5hV\ ;Ze 5j&E1 5
I\ W֪  g\r% \ ;˥ z{\ \ \   T _l  j\ 9 R  \ %    ڽʑɬ\ p    \ M W\ \ #\ \ S \ ɫ H\ ^!\ \ \ :w \  [۶\ \ \\x %(Sn+S \r     ;={\\ \ W%\ \'  3Q\ [^i\" \ ܺ)b\ >\ \ 5{\ Z \ 8     \ \ \'P  zU  k XImk e-ݎ: \  \  -\ ^:\\ >j\ \ m  pG\ n= \ < Ƣ(\ i ^(\ u9{4r0a פ \'\ Q[H \ ,g =+ N\ K  j[ ڞ) \ 
Y8 F \n  i\  i. Г \nZ \0}s ͳ񦅨_G \ _#\ 8\  \ 󭭣o*}Eu\ p֟71ω\ Fi ^/i t  \ \rN *\ _   >\ \  W<\ зX ? Lkg\ \ OʵyT 3  ٝR\ [\ m   \ S. a! \0  V? \ Ƹ\ \ m   \ Q  h\  \ j? *. ,]/3  \ O  s\ k!?\   \ J ܱ  H u\ q \ _E \    \  \0   y\ ƛ \ J  P \  \   w21# \ 5R]K \ p \ \ Er-at sP _ hƀ  g\ ծ8 rk/ \ ]
   \ Ã
\ \  \0mI ǡ:<d_\ \ 3 
d sf\ ^C ꯏp   O   V   x:݆ \  duW\ Oqi,2LJȻ[ \ ˟@~e ΃ \  ! \ R\    \0  ^C\  \   P \" \ 4MJtjY  \ \ Gko+4%P\ ` \ [\ \ aq\ \ & %   ?L  O_)\ [ǰ   \ Q }S5PV\ \  Ə >! ƣm \    \ iynq   \ y{ S\ .   
   \ \ |^ ͎ ko M 䃼NNO +\ nE \ b @=T ]ZD)8J\   xOĶ Ǩ pL 8e I  W\ :> pV\ M c  hq EyY G   k\ X  V~\ &\ Y \ v7~<  \r\ \  \ \ ˑC  A m6  \ ͧ4\ | 6\ C Q  ڼ>\ \ [Y  \ S\  \ W |# U\ c       ̀\0  P W J   \ {:iQ͹\r\ \ ѷ# \  O !  R ?\ I \ S >>\  d 8\' ӛG $\  & d\ q\ H 2q֢8  5 <  R \ \ MnE l\Z,; g  r  \Z`ph${Ը   \ qM\ Gz  i ǰ as\nH#  lT{ pE;\ N\ l 0n٥\ 8 Ao\\S   \ 	 g hң  \ 9\ \ \ bU$gu\ z\ZhPx\ 4\  |\ \ p9\ (  h#4m >Qs. I T\ 	=k\n\ \ J?\ 5  K\ \ ۩x LV-\ k  k \ $    +\ 1\ \ 1  # jfNk Ӷ \   f;p  \ `S\ \ y\ rr(\ k\ Aȟ\ \  \ )I\ R6A  3 ⴌ\ \"Qkt3i\ Ҕ aJI\ @  UɱE  B8; 0  \ZMاqX Zƣ\ ^) \0\  eqHzQq8   \ G\  U    b    1r \  ?Jp\ \  ԡv \0  \\V  s@\0 \ H i3\ + Aȴ \ A/\' \'r  `\  S:   :R Ч W\ \ h\ \ Ӱ\\c  )    I\ h    i\ \ ɞ   j3 \n8\ >Q);  ^  \ \ Z\ H   a! @\\ ,z\Z  \0ۉ8 =\ [g \ \r\  $\ =x    .\ \ cV{ < #7,\ \ 2 F l f\   Y<dֱVH K]\ \ e D&? 5 $sMk} |     \ [j2ˣ5  L\0劐P}k2\ -\ *` $V\ 1 f  m%b\ nNy#$U  \ m 0   $ \  wW$\r vFz B۷?:q  \ # d.V3v:҂\ \r;\ N `  \ \     \ \ y \ 	 p*B#   pFh X iL j6x\ ! \ P \ 91 =sқvW  (  {\ J	\ !   \0 \ -\ q \0,c   \ .# \ Ť u Hᐇa 0A\ n t\r\ Y\ \ \  \ 0\" K>\ ^MLZ t  ;!I 4ٿ  f ,\ O4 $h    U\    a \ X \ · \ j  ϩ Jrj-  J\ 3   \ Z  KK e\ x\' ~i
=\    a \ \   S : \r  \  $H\ \0\ s_@ \  I    \ S* \  \ \   
Aγ \ \ \ %K  Eˏ \ 7 m\ ڼ 
]  6zר\ y m2 \ 4l{\ \ \  \0h \ b    \ J\ \ \ 9Ee \ >  $z\r ! \ 5 6\  #\ ~      ؔu\ A + }k SVg%iޣm ޚ\\v_֫  Zq\' 5 )  0~3 hi\ T   \ \ >P\ \' @*6   L2 v n \"[l  >   O  7i\ L 섛,   o \  #     ╇\ \ &OCM/\ Z  Ji} \ 
\  \ \ C>   ި K   n#ҡ=z\ ǭ%2m  \  \ :   \\    v}j>sOROaKA  \ : J \ i \ J  ҋ  %B}*@\ Ң iŸ\ P\ Qb lqU C I   S֫ \ t$P  rY=\ s?6\0\ ؁ q\ w\n\ Y q X \Z    (>a  \ T\ .Ȩ =Ϙ~m\ V#\'W\ P } 6\ ,@f;4P}[\0\ 󯖭b3^A  Tƾ  yQ y   \ `\ ߘ\ >T  5\ZCk;\ A X Vg \ 1^  \ w Ə$\Z   \ ILd$ } p \n ] k I  p \0 Q \0,\  \0C\\߆ O iڭ  \ F8\ PS\ ;v\ :V \ V5 _m\rY \ \ 4\ Pz \ Pã k  ^\ b  \ J],\'  \\R \0 \ 4 zR\ * _s>e\ q\ \ H#  J\\ 8cE t 8\ Oބӹ\ G ǁ \ ,\ I #3ri Ӊ  3HH=\nA  \ \r9J \ 5 \ .6 ## rz\ `wlSH$ h  Xn=\  ~3ص  >\ J\  Xz\ pk\ ʶkž:n]cO   y k   \ (\ M>\ :\ \  e^5\ \Z 9\ n   Ɓ\\ ۸\ W  \ n\  T (; h[ \ k\ \ \ \n\     C!ô \ \ J\ ZХh# ӄ \ 3® x }Be \ nX b  \ \'޲  3\ ]>\ \ r\ \ qς\ %\\ \ \ _YXjZ% \\ # \ \  \ U(o f I   $X ^o%I Q\ \   s\ \ \ { y  2  _   Rh fa\  g?\ \ }\ wŞ\ |T J!Xn ;\' f 7Vѵ\n\ \ \ \ )cm\ \ \ \ + 1 ϡ\ \ \Z R  .G r_ V %ѐ;  @H3\    /  VRWG \ \ \ \ (.GLQ \ )1\ j ct\  ih  bFw\ \ /\ R=E4 h 1 P\     ✼zP!  \ ֤<  \ ޘ)\ E$ \ G\ S =*3 Qd\ v 1u_\r麚l   E  \'\ o\r\ \ M_ \ \ bďJgQ\ \ t  @ K \ K ï\ Ч\ \ V_  ,o .\"o ^  c 0 }*^  %*\ ]O=  K J  [ #Շ U 7\ ͎ 孚t$` Ú\ \ \ sND    /\ )b . = \ ! \\ȿSV#ӵ \ \ R/\ ?\ [ \0)\ P 4_B  Yu5\ 灚k\" Z  w?Ja\ \ i\ q֣a {\ 2 \ <T	  ަ\ zTܤs֔t\ Q  \ j 4\r |`\ P )I& f\ i  } HI +ޞ9] \ \ 1\ .F2j20y\ @  Z ~\ 9 W  c N\  C dp \  y \nr \n\ L\ t M \\NF\rcj\0  P? Z\ Pk\     \ \ y( \0j   \ :j|   JM Ӊ\ \ Q \  V  :sH\ ◑\ Q \ \ \ hH  # h|?\0` Ss \ KVr   B\ RKAJ   Ru\ 8 \r \ ;*\ ?* )\ }QiF^De[֑s \\Ի3 N}  @\ \ 5c\"%I  dSNq\ ?gp) a\ Wtf\   \ (  gv)\  a 9 \ u t\ w\ C0\ Z9 81	\ i  ӚvT \ :ӹ6wzt % \ 6? Ry  Q\" \ 4  +!>ԆB \ 9cC  a4 Q&  c\ sM?Z-  \ = 8\ Q hA\  #  Ǯ) \ 8Āgx  \ ? 4\  ԃ  \ o19y>X) yG  I=\  򸣗\ |\ D \Zf O\n   s Q    ʃ   a \0SL  3F\ ZL(=qUʉs 0  }MC\ \ \ 6 ꍛ 1BK   q$ qC \ 5\ \ 4 A \ U   \ t\ D\ \n \ ӚB\\s 5I\ K     7\    ӂ \ \"  qC) B \ \ \ K\ g P \ )4Rd\ YJ1- O Pi \ 0 \ \ $m \ \ jpV  J E9 \ !#_j\ 2\\ <9k\n <ێq\ 5\ L    \ \ -4 8\ <  \0? g   ˣ  \  ͵\  \ r 7  \ \  } y7 m ̒\ Y }\ \ şS\ ׭b8? a  \ 
 \\T\ +!Tx& g\  \0   ū@\ |\ z \ : m   [\ V   \ K  t  \ Oï\ Z\ i)\ i ћ  \ ޥ\ x [BX \ \'  \ {@t\ z O Ϸ\ V@  \ ^   \ V8\ \ \  \\w ;0\ n\ ¢1cҏ/  k \ ԗ\r\ 4\ \ $\ + \0  o\ 剧q a \Z`!N)\ A  \rF$\ \ \r²\ ;y   r3I\  (\"  \ w\ R\ F SO\r   O\ \ \ E7k\ 4j5\  \ N?(\ i =\ SH \ \ J\ . cq\ ?\Z\n\ uN o`qE   eq\  +\ I i  ߓE  = )rH\ \nhlsF\ z\ZvA\ \ \ \ )2\' - \ , ZP ٤\ R|Àx AjL  җ58  ) ; 9 3\  {c  w 4&HX\n[  \ \ \ \ $    \ } ŔF  \ 9   \  \  w t\ F\0  PA \r \ _Qn\ 9     \ |en\ i*\     >  }\0f\ \ + \n   Ϊ \"\roJ ״  :\ s\  \0t ?   uM*\ @\ g\ \ [ɏ  Z  ܯz \ sk~- ,턏  - | 9  \ A8 v	Y\  \r\ \ \  Y\ я\ m  ?ᮻq h\ &ۺ \ \n c  \  \ ] \ ̪\ \ `	    )\ \ Jd\ Eir, \ OJi\ )   G z F \  N rqH$\' \0\  F   z C Ԋ7` H[&  }  wSI s   ( s֚TQ\ k;Uֆ  \ \ ,   !`    zR  u` 屣  xo\   Ķ  *\ g\ & ?Ěޱ \  > mcۑu4   U\ Z i    } Y \ $ \ z\ È\ S \ \ J    _ i  7 zz\ \  )   x + w p*\ \ Li \ ,g*   {U   8 \ q\\ ¤ ;c  l & l0\0~ [q\'9 #9<  B ˨GRbx \ 6>.Ӛ\ \ 4Y\ &) T?\ [1\ ֤,@\ g*jJ\ \ M    \ \ KῊ\Z9\ \ \ \ \ H \ \  c\ ;   :   C^+ ^ 5\  X@ < \ ~j3\ \ 3XAg ę \ , \  \  >t \ Q\ \ \  \ \   )  Ǽ ,W z\ |   A\' \ ڸ\  g\ \ 7aN\ \ F     `sސ y \ @h \r ۚ\\qҐ;H 2 \ ]    \0 G_JB\ 替\ \ G0r   \ =  \0UB\ \'\ b `\ ƹ9\ Q  \ \r u9 \ Ċ|\ Y 2d\ Kx\ \0    t \ B\ b \ ORqL9\ \\c  \ \ \ G\ i 9\ (\'ҋ  N{S  @       $   }x *H  R
i_\0#~\" 2\   \ \ \"  w\ &^  \" \ # t  ꛮ\ Y $zf \ <\ \ $\  \  \ \Z8  [ {\0h  R1  #s֕ \n0$b~ Ֆ \ ҄\ \ Ҥw ;\ 1 \  R D\ \  0 | ={B\ p o 4 \ 爒 \ bxU \ F \ 
\ J Gz \ c( *6  \ 𦹅 h  5WP  짚, 6e\r\ $\nxva \ $K\"a ƛM 
 &r>  \ -kP  v   2 qXn  \ \ ]Բ ұV\ 3\ ֲb    $ \ UP*\ \  sR\ {9 \ sj    ,{~&  xʊ` \ 5 \ \ \ `\ &W{  Qܚ u4 fz  .a\ T  oΏ1  f \ )  ڟ\"1+K  \Z~  L\ ~\0s  \ d\ lS\ A\ \ h  \ ?\nC)\ ?5W,H\ q M)R  CU% \  \ ` \ZFʜ0\ E \ \ 9%#    s  \  o   \ 1L\ \'  \ \ \ zG  ! z q \ Z1 2 \ #\ I  vA   9\ [& \ \rX\\M9 Ѽ\  \ h\  @ (\ 7 F\r\0 t \ 4ܰ< K z CB    i T\ h9\ 1\\S  \ D	\ zpnzRc Q  \ \ Hv\ \ \ \n \ JbcK0\ hYT&   \ W1@l)en R\ 1  m#; ! <PE-  )3  JT҄`8S .  ϰ    ]OB\ \ ? P  Ŋ \Z^\0\  \ @\  R	O͓G0 m  	\ 4 8 j3$d\ f <  ӻ\ +. p%  H~S\ ) i3\  Ry  <Q\ Ö/ \ ,å);qL\\\ 9 \ Ori] \   z \ Q  &   4%iּc\ m Wzͅ R 0B\   -\   n tHH 2x 9 &  M \ wڥ\ \ Ӭ $ 0s#  P\ \ \ \\8\  V :(Sט \0i \ \     <\   ?ʺ/0g # %   9+,j  \n  \ a]T y fۓ-	       x #؊ \   \ g\ #y p\rT  lWm\  O	 Zg\ ;tVZ] `  ^   ּ \  \r    \0_\ e  ӭ [!\ R\  \ ^ kr [\ \ *\ \n \0 ^{\ 0X Jr :1vL  	\  \  `  Xc\ \  ȯH\ >S\ \ZRA Tj\ \ 板Ni\ VM$  n   4\\M\n  4 H\ \ Р ɧp  9\ )\ \ L\ b `   (f    `   {S -13\ 3N@\ Mf\0 $\ \\5 h     jw\' a\ GcF ڣ!  \ \ =1րG \ 8\ G \ * y\"  <   \ j2=hۓ֓  \ZFq\   k 4 6F\ 0\n   y L   1  ,9>   ;\ \ B$  ўG \\( TRE FiJ7V\Z  \Z\ B\ F    uq~0$ eW1 Wq\ \  SUD|d Ʈ,*\ EaJ  ٚN  \ r˸ \ 5 k s[x \    :h F\ \ \ s]\ Z \ _ \ \' x\ W  \ L{n  ?:  T\\  s ٵ\ ?Y밼 ::d# C _ \0 ]  X \ \ F K(  \ 8\ m\ Ҵ Iӏ)5& \ \ \ u -(LO   \ Ӛxr(\ \ ќ W \n JilqNlӸ  ғ b \08\ ZC  )$  f;\ \ C \ Db \ )x\ \Z\ L  F \ \ WʑF\ n 5uf	\ \ 5 ?O\ aXo ;  &\ \ .H Ǡ\ \ C\ \ 
,F\ 0\ A\ \ \ :Ku \ Jhv lW?\ )    % KI \ l\"  c$T n# n5G +\' \ \ C\'+\ P \  5<E  x$L j ( L   \Z\ ֧ \ >A  M ? \\\Z\ P1H\ \"     ijye    \ % \ \Z\ i$m؆<!>   E\ \ ӭ\ K)Gr94 2dzՈ\ P   ˕g-
 &  = x  @ M(\ Rq\ @9=\r

 4 q\ JI=) a\ E  Ojas\   \0\ \ Q \ \nM\ s \ Kd q4# OP*6ǭ=  *&\ zЙ-0\ 搕4   T3N\ Z  `> lϭ& ;\ d\ \ \ s \ \ N [♅\ Hv  \Z9Ps A+ \ <   1O(+ d IA ;7 \  *> 7\ S Ĥ}8  4 ϥeȍ  )   39 \0 SW\'\'s  \0=\ H \  ʅ\ \ ;  Ҝ8\ Bx  \ \ d	 n\ ڐ\ 瞵\ N1ށ @ Zg\0 9 \ f :\ ɓچv\ \ 8 M  f 8␁֍޴X  \n \ ֣(\ i\ V\ Q@\ \ x , ㊌\ c \ \ ☋ t \ 8 \  T \ \0 Ӄ  \ i<\ D FsM$z\ / 8\ p6.\ # B\ AL! Ӹ +(\ @\ ޅb8\ 8 \ \ U
a    P\  t\ I zP\ ͎\ zf 7)\ \r8 2s@ \ @ d  zM \ v    4yx      2ؐ HF qG 1 \ L  i P   y\Z֛5\ [M#i\ Lf@x   #\r \nrC  \  \ \']\   \    2 挐x\ \ $Y/Σ.OEA[Ƨ2 L ]$?y\ G\ \ Q\  \ZiߞX\ {݅[Пc\ ?:kO!P \ SA\ Q \ JB IG\' Y\0  \r x  4 5} Pq  R1_  \Zilt4  K   %ؐJ     \ni% 3 aLu$\ ʁ̑   UE7\ sޙ ;f = \ \"< 	 \ i
\ \ 1 fO4 5 ɱ    Q \ =*R j@\ LC%A \ \ Tπ03 u\ \ 4c 5  \ ݅)S  LD@0 Z \ ?`\ ;S¨<PЕ\ g4  \ =j2  C s֐   \ :74  ֑I        w*	\ Er  y-  E^\ $  \ J \ Le\0 5\ W
N    YGDei\ mŭ p\ rҔ\ ] J \ & r< Z\ 4\ U .wwd7\ x \ oM S  \ e   \0leGQI p( . \ R  \   C\ PN|   
gO \ w  ͥ pʸ \ \ \  V  # \rجiai\ w 5 iIY   xA     <\  /N \ d>\ 0\ ӚZ\\{\ \ 0I   qC|  h\ `01N\  =8  :t \  7Q` \ \ H= Q\  ӂ Hb    \ J2  8<c4 4 ^   <\ \ \ \ rNh\ $riw Ҧ 8\ \ ?  Ԅ  \ Fq 4\\v ֔  7 \ iA  KcB   \ \\Sz P  q \ \ p\r5 ?Z6\ қ\ z a  6 T \ Q  h   \'\ P\ 㱦\ F\  \ b0 |Յ\  S\ ps  ] \ ĕ O    \ $\ ) ܊- 6 \0\rO   l09 n\ 9 l  \ \ M1_   57*ò\  i\ ;z\n $ \ 14\\  ;R\ Zi\rҝ\ y q\ ]   *: @Gp\n< E\  pzQ <R \ &@4\\,!4\ \0 Ӄދ     \ )ʒx Ď\ Nㆦ hj  \ r ` \ \ ª\ \ f\ \ \ T !^£ \rޞ g \ iX  1Aa ) \   (  < Ո\  x\ Rc# J\ n \  \ I\ \0\ \Zp=  {\0    _\\ 4\r@  3 ⓐ)3\ LQq  8\ &\ GZ21Lb;E\ a\ a\ )  sқ  q\ 

  ,\ d \ N\ ֣e  ) K  \ \ >\  \ hbݩ\ \\ \ t\' 7\ H# \ \ 5( # Q \ :\ ]KT$ \ ʐ^ jo  \ VG \npGP2\ \  \"   7b0T  6~ \  \ > 86h \ w#  #\\~ \ # ϕjv2 \ uj> N [\ \ f+ d\ n$g \  )´W% =\   \ \ O4\ ) 1\ \  $ )7`  \n j<  愅q  8    <   !U\ \" \r   \ ҟ \n \ =( 6&pq U9\ N)6 \ \ \ .	\ \0S&A\   \ G o P\'q   \ \ Cr\r\"  Ri2   \ \r&)\ PO\n3\ N21\ 
 t \ } \ ]\ ($ S  \ i X5]\ Еcs\ M;\ & W`NI4 &j=\ \ \ \0  nph= 1\ Y,  d N\r  \ :\n7\Z _ ӱ#2  \ E r	 , 9\ F\ \ ZEX ; \ 1S\ ?N3 06   \  G\ NV\ E&  Ý C# ɤV   \'  d5RV&\ C\ Nݞ\ <zS;\  \\` i  b 88\ 5X\ \"   1Y  rJn\   ҆ $\ YK \0      ɏ\ Bz ;\ 3\'\ X <V њ im-P  T\ \ L%  E:9\ \ I   ^6 ޳  a + #NJs ] 6 0M3i VZԁ `\ \ \ \"꿝o\nі\ \ Te 08\ .\ \ @)v   {dV \"\ 1\ \0 R~ZqSL\'b cJ L\  J \ @Ps b :\ # 4 c\ M`     Zkg<\0)  \ 0 \ ąf*94\     5! j\0q\ \   \ A S\0\ 0qK\ 89\ @{\Z\ ֐h\0g \0!`1ϵ7<\ & ۇ_\ M$\ \Z,\ \ Oz@\ \ ҀGLQ`c3  \ ] \ s\0F0G \n `\ Ӱ 4! M(Hȩv zi\ qE vG u \'ڞ] qM  s P\ \ 4 \' \ N1qڜ#a\ 摕  ) 0@\ 5* .A\ \ <0& 
7QC@  ٤\  \'Aҗo<`   R  \ 8I\ )\ jC7 \" 6zqN$ \n6    qXn\   +\ 6\   b \ \\vC~`z\ \ {J q\ ) 担 \ \ GҔ s v\ = \0ZaA\ @$ \ i<\  (	  p\0v\" \ \ \ \ rz \ z ҆# \ZW
\ }qM f \ \ ֍\0B    JsN\ 4 FK\ \ N \ H   0 \   (8 ! \ JA\ (  \ P\\ 8 8 )    `7\0\ i Ө  \  J  X\ @4BT 4  n\ Ґ+/O֓hJ,^A\ * 9\ \' -J 8\ \ bT f  qQ # H# C)\n \ v\ i   d \ Xbqi\ \ \0\nVRH    q\  8 \ Z  Ca \  \ t  Ǡ4\ q3 jB \ X}i v9\"  ?    \\b   h  k: Ӛ 0\ Ն g   \ G Q\ \ =    3Q\ =ERW% 4p8<\ ԀF@\ 74(9\ CHi \  E< P?\njt n  *,Rc \ <S 0i9\ qJ  \ .\ d x  y OJ>  F\ n  !>\    \ Qa\ R; k  b r   h\ \ m\'\ *[ ݍ& CJ7^(\ {Ԣ<  \ \  Q ̙>  u魙  7 X\ 1I ǡ h% I\ \ 6=X\ R  K \\C \  j]w P{$ e!\  =  kq՜a\ [76 \ ? 7հ)   \ ٭  \ \ q h Y h ɍ\  =q R$    \ ?\ 9? Bڅ\ \ D\ HW     l ݏSG o\ w \ X \ \ M< \ Wh o*s!?\ ni^\ B0 S\ *  3 \  y*\  -5\ \ \ \ _\  \0Z   9; \ P rW *2X kEJ۳?h \"fqɍ\ fA D P W= Re[\  +E \ \ 7 ֜i N:\nw=\ 4  \  \ \n\ Ҩ k \r\ N\ 3\ i\ 1J\ a[$\ AK s i`  0CI\"  dv \ \ d \ \r+GJWd E4 <U_9 \0qOI	\  J\ `&M=p8\ *0ݷf  LC \ }\ @-K  8 Ɯrh\ \  C\  ╱MD\ = ǁ  \ 4# H\ Nݷ  \ 	 y  \ \ y \  \ N\ \ \ T P\ \ 4   i &\  ocJ\'Rt\ 4͸$\ a\\s\0~\ 4.: R =1JC7  \ZW\ 4  4 08  \ 8 \Z\n뜊p \ \ L\  & O \0!ϥ{柹O `AE\ \ $ I  9 b@\ M\ \ ; ] y# UpG# Pø4h\ <`S\ \ qM+  H  ; \0;s)ʒ֧K W q\ \ UL \ Ғ{t  P  5 YCbЂ	   ކ u \ 3 Z G \ S$ ( | C\\ ʽ? W^f\ ҕO Y  \ \ cӹ Ier~V Q-  7 U\ \ z2e   \rJ\ 8<\ ylH\ \"  oQ\ \' I    \ \ \ B` \ \ 7t\ <)jk _ ;   <  S\ 	 \'wPhVe< qXM Ҟ :{T  \ E\ x    \ iB縥 3 P! f\ R>\ 8 \ H=h y\ \ \ Sq J\ \ s #+ 0x 2l 8t M8\ H\ P m  ~a\nm\ R \ I  9\ ?h sE\ \  \0i  \ 1AۓM(è\ $G}\ A  T\ \ \n \rQ\"}\r#  T   8  y&  \ \    \   \r G [ ( XLg  R\  \ NR \\\Z@ ; \ H] t  9 * \ ZC   b  =M?\ f \ q q\ ?\ZC\ 8    ƔG<\nIA\    \rvn) \ q\ \ MV\' @ J@?v E0\ N\r   C\ \\\ q\   \ =iz\ }(G \    j^ ~  /a `\'?tԘ=O a` PX NX\ \ PUW\ ʀ  y\ R\0 i\ \ U\ \ ݁F\ 8s@G򇜐(] q\ ֗2+    OZq= 1 ڋ  \ \Z\ Ml\Zx^~ \ \ Si \ \\\ \ E8 <  \  +q \ X E <\ aT: r {S@8   p:Qq\ z\ \ ʌv  S   \ \0P zz \ 0NM4  $  6 5v \ pWvd\ c > N\ \ *  \ 9- S\ f,y\ 
     ʛ\ \ Rx\ 8 ` <PO \ ! ֖ pN\ =7R\ Nx\ 1 Me\    ri   W\Z (  \ .     4\ \ =(L,!   T-f  \0\  4ǐ \ 4\ \ !\ Q\r\ }G֦q \ n  N\ \'-R. ^i \  \Zpm\ m ~\ * # ? \ Q3\ ?J ,۾{ \ U!٤i\ \ U@\ 4슟\  /ޓ?AOX\ #\ \ }\ \'   S4 \ 2 X S ;c  U U ~ dΘ^\'3=G  \ 젷d?fn\ \0 4  \  \0 )\ 5 K v  M\ B $ Ow  \  \   \n y EY     \ M I? W B ̳\ \ \'%\ZS\ \  \ EF\"   
\ \ T ^  P\0\ \ RH\ \ , LrX \ jG\ \ \ H} \ M$\  $C  =s Ҁ ҃\ \ `Z   B Mn \ Ma  3 \ +` 	\ 1 v4  9 Sy &\ 9\ M28& О i  GBER$RzH˻  Iל\ni o  \ z9 = Q   җq\ R G Ґ z\ r{ L\ hh  f \ s\ N8  )aߚ F\ n)\ \ ! Ȣ\ ^\ 2 䊬\ jY	\ 58   \r\ \ O  <  \nz\  X \ 6MN  \ \ }\ d\ \ S  <{R   NG%   \ \ \0) F*Q \ iN}) z\ \ .\ z\ ╘\ 92G$R: i 3\  w HWsf * \ ǎh\ \ \nv\ 4 O^i+\ 5Bc d qQ z qN884\ DY q F\ lnp  @s\ E \ $bT 4 \ Rds\ S \ x# n{\ \0\ R)  s \   ֘}i\ gm 8\ 0 \ \ 2M : M8\0    8& x  bC OR\ z   \0G֕ \ n82 \ R \ ry d/< 8\ G \ I\ \ 4g 	 90ݍ\ \ \ 2f Ǧi\ x [ { =\ \ N \ H\  \ j\0	\ \ Jx\ @  8\ ZJ\ Fn. v- \ \ x O  {rc;  VW & W \ 	\  iS֋  \ \  \ g U26/\ \ \ @r MZ\0   }\ \ 9 ap  \ n\ZUV   S֛+\ \ ̱ #R\   \ ♒y\ uS  \ \ \ %f  n  R\  Ԝ\ Fbڭ2Z>2)2O .\ 94 *  i\ V \ v\  \ y  \ q\  5 !  JS c4 4&p9  \ \0 *\ \ Ͻ@\ Q    @\ N:\Z21 & g .  \ \ b;S FNx p \ \ cӥ?i\' @\ &    \  t \ *
2q < \" V\ \ 4\   {SC穥	  Qp \ {v ڤ \ \0\ 8  s R  zSs    \ i  y\ @f\0 3H
jV|  GP( \  4\ ׃ L\03֙ =3@ bB  \ 7\0\ N(= j\0p\ \ \Z\  E4 { q \  \ \ \ ɤ \ M \ =\0 4 6 ?Jiی\ \ =\ 6;y\ GC pb: \ W
   s  \ nKdZ q \   nh\0z )  p 4ZL4D   ~ 
  \Zb  X  d   D d j\ \ 9  \ Eo \0]U      k( x-\ \   H &&\  N\ K֐ t48\ 8  8	  oʗ\ =ri Ą   P:\ T\\\ T   H\ \ =\ \ G~ \ =)۽\ 0C is  \ \   \ B?  \ \ P <\ 4  ֗j  \ O- )  .\0  nȤ+ 8\ N \\ӽ\ \ =FO4 T \ \    \ =3F     \ =N)\  g S@-\ ~ 9En5ރH\0w   S
Y g d\ \ZU \ V/ 5T$ +\ \\\ 4Ҥ J  C   7 0  7  \'  ` γx \  ՙ 	_ *o؛?9Q   \  \ \ $c5\ \  !a \     .z \ @妺\\ [B \ $ S m# ElO    \ \n\ #A\ 9 \ +  R\ZN \Z  oj fY  z  TJ\ H~:c\ \ UbH FH\ 8\ \ K \ F 4?  c \ & { \ \ ߇E^iw \ \ \ 9\\i,NsL\ A\ sS_ F\ 7J By U\0u\ ( \ @# Ji\\ \ \ 4O   8\ Iϯ|\ cp\ qL, ޚ[>ԧ   \ @XB{n4=()\ 8   V\ Q3\nB\ o \ =F\ }h $< \0 \ 5	  PK/AM\'\ (#7   s إ 0y  \ t4Մ8K t K  T[  \\S _  6/R!\" NMF\ 	 [>\ 9  \ \n>ʪrpG +j;    ~\rF \' &   \   \ R94 W\  c\ 03\ \nP8\ hH a 9T jE\ x4 3\ Q  (Hy\ P6 \ Fv\ U$B 4,\ O = F\ QNA  L \ \ T  v\n7n?\ZzH\ L N   㱦  & v \ ;⨥8\ G  \ \ \ LLV\ Hwt 9&  \ \0(    \ 3MF8  \ #  \rǥ0 \ F\  UbM!G< k 8 6\ S \ \ (ji  \r`\ $ k N\ \ \  )0M.\ \ ‽    \ c\   sҚrI4\ ?nހҨf\ \ `  Z< \  \ `\ <DG\'\ =\ \ I n S  \ LcpGSM9\ S \ n֨  Ü\n\Zrx S\ \r&O|\n       /  S\ \ \  S  G\ q 5#!#       \     & c W \ i\0 K SJ \ )  =) w Vo| y,;SK ;S  @ O 4 V\  ޚv  \ lp\ )8\  [ ˨ćrӷA8\ \ > U] \ xe<\Z\ - C\ ~F \ \ ij \Z\ נȨ  \ \ ֞ S \ ڞ%  ps\ C Z ƹ t>Z5>f1X	\ g\ \ - F ڣ`  \ ޞ\"\  2 \ t= c f  \'\ \ <̷^) \0)\ ƶ2\ \  \ i\ \ 4  ) t\ \ \ @\ ݦ    [ @hH p\0>jD$v4   \0h=\ \  x\0 0;\ \ \ OA\\P[9\ C  E!<\ \ \ `(\r  \ 4 X P)|\ JP\ #   =($  \ M,{@\ \ 4`\Znɦo &5rp R3HKI5I\ 
  f  & \0 \  Ӷ n>  &:R\Z  1I O,) H9\Z9\ n?h \ \'#\     \ qNU! XS XR    9 ,)bV \ P &\ \ ވi< \ ҕc\ \ \  X\ \ 9 ,s J\\\  ( D &\n \  1\ Ny lh \ d ֓ {}ir]\ Lnv\ !  I \ rO+ Ғ\ r3ȫ 3w{    H\ J\ \ 
   )r  1ݺP	n\n T`G\ HGa\  Q  x\ {P@zPT   A   y  0/  AC \ \n   Oc \  L Tg*x柃  4 \ 	 B\ ͞EJ\n  \   1O-\ ݤ\ \ M* \ \\R  \ iB\ Ҹ\ \ \ <\ T y& T.x S} C \ \0=I  VݚF \ ȁN:\ \ \ 5`\ *   QA/]\ f Q ) O   \" Ï R$, \0 [\ Օ v \0 \ h\   u\ sY \ %  J #  \ XrJ 㚍 D = §3X ea\ o۶  \ \ 	Tݿ\  \ \rV\0 \  \ \ s)  !  = / O/ \0  8 \ \'R\  Q\  z !\ %\ B 1   s胏\ \ o\ b\r=K⑳ Ut@p G 4   \ \ U\n^DJ \ ]mV Wj  Ѯڧ  2\ \ \ \ \ \ g$ \  m 8 U\"= A\ \ Mq \'   9\ 4 s U inK  <| \ \ ;I ;| \ V   &ݟQF\  \ F \ )\ \ Hvw< N;x\  \  OZn\ & l   \ 4Ҹ\ <Q\ <P\ NNzSQv \  8  ry \' \ Ҁc\ f  \ 4 \0~ 4\ B \ \r Wv9 -  \ қ { Pe\0`K \ ; \ X\ 6:\0j#1>\ \ +\nX}) \0\ ̓\     \ $\ 8jbv\ 7lsLbq      H $   \ M(u+ MM 2)\0i  \ V\ 3  |Q< R	> 8^   \ I v\ pj  K y  }sOِp\ Ӱ  #
   \'  6 \ \ \ \   0V M| 7\ F 54aYw3}\0 \ pةp  \'5\ \   i % f \ \ H9 C   x\ \n#  R 8<Ҫl\ \r 2 p) c\  \ =*P> \ 0 \ q ]\  4!f  [1 }i QS I Q9 T\ \ \" \'\ \ 7Jbi\"  9\ N\ \ G 昐\ #    Z^  \  \  \ \ \ F\ P	  >  1\ (`x#q \ \  ݃ B&\ \ \ \  \n38 \r
 8\ \ZL 9\0S  +\ M
XF\ x\ 7,   ? \ )8 \ 3\ R \ M,é ) 1\ \n\0 8\ )	\ <T#9\  c     杕
 f 7\ Sq\ ) \  x)? !- 7\n@J 4      &\  4  | 8  v\ (b \ .Q\ R  \ :` Ӊ$\ #\   `lpN>R)W  j-\ \ p wf \ ܗ \ (^3 EBA  &эԬ;    X 1M  4  \ eb\ 9 e \ J\ >  \ \ ,1 \ (`z\ }\ ԇ  y \ (\  b  J@\ hve \ h`0 \ z})\ A  T \0    W\ t  \ sI 
 ړ   \ j\ W   F \ T\   yϥa[N    :Ӄ Yp \ \ 8oz KYb9\   榎 X  \ \ \ * ^  \ 2\  \0\ \ uh\  ՟tDW\   Ҋ: W \ \ \\0(\  $s +HcU j.W\ D צ\ \ s ӱ  \nc$ pq@~ſ*쌓WG3 N\ 	Zi\0 JX\  4jw \r\ K m\ 4 \  юh Xqb\ H\ z\ D  .\ \ p &\ ךF  J@d \ $ ( XceGP \ Zs\0GZELs    \\  RW=3Fx\ @\  \ \"  G\ ⓜ q\ @$ ѿ8 Q;\0<\ Ғ1    jp\r\ \  T\ !7=(bF	  \ K @\ \ \ J\ I  P \ Ѱ M!8\  ސ\ q \0\   EN\ \ x\ $Ӽ\ \  ۊ q  z\Z| vK D!B-ɣ: ~  \ \  a{ U{k\ (a \0 iۉȨ \ t  Pwg S  <. y (W4\ 8 ߕ \ \r&  \ \ )\ 2:\ \0XS  rh \ aH\ H  ~l{S\ (\ h G^i \ n3\ i ) \ aK # \ H 	\ ٦4\n{S z\ Jc   )7 \ZR{\ U\   j\ v 1 \0W   슿~U_aXKEu6T*2 9   \ \ \ \    y*\ Is\'  2G    -  / 4T\" )\ \ ߢ\Z l]q   5i\ &\ \ (G pO\ Lac[ \'> `Ts֗T ڔz\\j\ \n}\ 
{\nv\ < vc\ j6  1\ Z \ \ \ Jz0OaMP  &\ \ d  \ otTG=\ \ \  \ ]\ # ^k8\ \ ~bX  a  E\ G\ \ u   {g `i F :  \ $q   5@ <\  4 pH * WbY< \  K~u/ 1 zns\ 8 7ޭcC [㜕\ ڐH9`S \ \0  r@ \ H9   \ZUm f \n \ ?J@	\0u IqFNx\ ) < }*?3p\ .\Z   Ď Q |\ \ a \ j$  \ qP  \  5!rx \ OlS@}\0 q\    >   h
,  x& _\  X Ӷ ! 
 }I    \n\ \ ӆ\ ч\ @Xb я4 A&3\ i  \ P\Z 9\0R ʊkH\ x8  \ \ 9 PC\ Lt 䑱\ \ p \ iA>  ( 41#\ \ 	b\ ?*   \ * \0  \\ l Ǔ E4\ \  )  \  \n\ J  S   \ 40Q  |\ h  <\ \ W (~8\ ,: ~  n7yȤ\ \0F~  s 8   c\ ,a@}   X  ԭ  ƚz L   #    \  4 @4\ \ \0 \ ; \ e \ S\ Y I\ dj?  4   ݩ>S\ Ӱ \  ߻Ҕ $ \ \   z \   \ Ɠp  >ԃa\ s\  n朹\ \ 3\ LicHF\ \ ͷ 4Փ$dPƅ\r z󊍉ϥ* y  ۶(\'=\ E\0d\ > Q`    9  & ~}  \ \ \ \  \\SԜt @\ $\   \r4\ ! \0)\ h t)U\ \ .K8 $\       \ z f0ry\\{\nc \ (\ (\' ǥ+\'<)!   \ * ל\ \  \ D \ @ i #/ \  `R O;酐 I \  
\nIn  \ 3 \ \" \   x.=qCv@ GJq~0 z  P\   \'pj\ a ?-7\ 9\ \ V  E#: \ p \ \0u\ (\ : C\ \nP \ \ ǵ3 \ E, \ \ B  ۳ڐ4O  OZB  # 5 \0)U]  \n4\ 6A  \ pF	  1 R1\ _Ҁ q Jv P\   \nBˁ  ] \ (߅\ ( 8\ \ .  fvs\ 8H碜ZM  eU\ M =)\ \ 0\ P   gԥ 1 \r#(\  ?   `9p y  \ -DY S     v \ \ \ \ N\  Կ&9\ 
\  \"3HP M3\n9掼i\0\ @n\ ~   \ O(; \ \0p    # ƣ;;  \ 4 \ 2*e\ Y  7S- \ F$ {d f3 j  {`}i\ \\   W7չ_57c bV  6KYW \ B 8<\Z Ԋq&S\ [K | \ hu M  ?45N^\ )玤\ \0\ 5fK7A G  \ r m5 *\ 
2 9Gt;o  \ \ u\ .\0H\ #\r\ \   Hɦ   \ R| 9,~  ) \  \ 4\ \ sH )| x$ N\ a   \ (   )\  H\ \" Xr  h\ =@ h g< P   4jB\ A  i\ _<-6I\ \ \ | ( 
\Z} MJ\ D  oSP3  ? \0  f \ s~ Ɯ\ \n\\1\ \ \ 4d L \ 8 
rkh h \ \ \ EVS\ b # \n\\ 8 y\ \ N a     <\np\ y\ .\  \ =(hHh# 柴S .F@yjz75;nU q\ ?o֤H \ E _ K\ j z W \ q 9t)\ \ \ u\'oɷQ \  \  -A\ F\ j\ \ ًf \ \ \ *l\'\ ~   H\ S~5   \ Y0   jYtk \ ^j\ \ оO\   & \ $Z \ \ 3Vѿ b\ c _ /\ *\ Ǥ[ \ \ \\\ 0 \0 ch   ]R\ mt\     5?  \ -\nN vDQ !  >\ 5qt JQ\ 
 \0y 1PI _ \ I@v @ R^M.L H\ К  o\  u\ [cNK\ \ Z @ \0uMBͦF	A4\ \ q   \ \ \nP\  5\ \Z	-\ eVL\ ]RH \   /p2j	 +  |\ ߞ \ UP \ ц:U qFnm  \  \ M.\ \0L \  ,z  d8 Oާ\0[   B\ \ _ 8+(班+  \ \ .\ : L =ɥ\ \nw
\nz H  Q 3  iv  56\    8 \ PTd M  \ O)J\ > !\ \r4n\ \r=\ Mkf\Z=и\ \ р{ Q =\   }\   mt Śa  >   r\0   sK %r ` ۚ7 L\ tϭ7 6 T  qc I\ \ D u95 C   \ UЬ\ \ \n r \ R3 \ af# )( q h\ 3Q(\ sF\ \ \"  )<Rd 9  \ 3N\ ; i\ `f 1      @W\ @ ! `y   ?xP\\jb Pp  4ªs P\ X  \ EFOj
2 \ Y H\ Rd\ \ \  \  5    \ \ \ b b \ G\ Li] c n  b \ ilt \ \" $R8\" p \ \ S  FӜf \ \ 8 \ *Fz{\ N sLV\ =iw >   c\ @@I\ ;\"nƼ  \ Y   U \ \0 m\ c7*\ \ !}\ =NGCQ\ \ z ScA\ q    QA` & F: \0w_Z\0끚<    sp@ 0Lk+3qҤD\  4\ 힀Rǩ D  ! aL  b  0%{ M%s 摉n i u4 &\ 1\ SK t8  < Nڣ @\\\ \  q h\ R g  \ A  \'  }\ K\ \ })eI\ jHm\n \ \ \   p43\  \0  j(\0s PO|   i\ 01 s@  #iy\  E,   ӹ\ Ú4 Rx \ =I \ wL\ \Zb 9< ipM;v8\ (\ <b  Z1C\ $R	ϖ3\ I\ q  \ \ N\ \ @	\ H w4 ª> \ +@\0 E#az\0i \ lӄg\ XV \nR  8 1\ =Gғ(  \ V9f>\ ti   \ Z  \ ֋ B  RnV8+  w ~  h\ lZq @ ـ   # a\  ߕSI   ( ҋ H@\0 K   ~  \ -+o \ \ C3q\ Q  \ R n98\ K }\ \nW \ C  \ N  J\ \ \ d  ?\n   \ 睴n \ ֝ = E 3  \0    \\`74\   \n\  \ I   ? ~u* L\ `ѨRނ   \ >f8\ R n\ \n?f\ ֏/  s   lz @n#`u\ & \ Z\\\ R` 늑        Q \ \ \  \ &A=qE ༏ \ Ҁ1  \Z1 \  R z\   .e aNG J ,  s\ P	l 
tJ\ Xx=v~F  5\ B̶  \ f  m   R*u 2>p	  jí\ nT羌\ \'    M_6   f kb ʢ Uc  d:R\ jVߎ 4 1\ =\ )\ \Z \ t   \ \ \ \ \ 4 v u \ zS  S np\0 I   .   \ g      i d\ $qE\ n  = 2ێM \ z\  y`  i  \ s  H\ 3   *T \ ݍ\ ަ r  ZR J;\ \n4jKdS` g .\ \ ~uy \ \ N  R   ~b \0 s l>\ ٿ\ eoy S0)\ \Z m    \ \ \ B}3V  \\ \ cվZ  N[Fޣ [   \ 1\ j {  m   \'Q 5a    B \0eN\ jc \"y\ ؅-՞\   Iӏٹ\ 599 0E=\ \ ml_\ \na\ 3   [ 
剨 \ 5	83 k \ \ \  RXi=  \ -   \0\ k\ s<\ Zg\ p> Ƶ\ ! \0_  \ \ 5\ c\ +HIwg$ &  0Ek- \ \ \ \ l\ MGI \    i[ ʑ   1m\r   \0a\0? c ?   \ \ ֪ z\ f\ >  u
 \ .\ 9\   NrO 4Ҍz\ Xw8 c D9\\ 9^0) 0\ i\0  R\ `\Z  p\0 \  A-\ i\0oƂ\n \ \'ҧmʰ\0\0\ 3J= \ \ 89 \0 `UtK   \ \ \ \ > ? !\' \  u\ qK   q# ( h \  LQ \     d 7\  	 \ \ ڂ\ x  ݏ\ @S  ; \ 9 2s      h\  0A w   	  \   ,z S A\ Ԭ\r   \ \   \    T| 4  \  \ E5  <S̊\ >x\0~,\ ;qN(\ \  o_ ֚ \ \ d\Z \ W   ٕ ӛsu \ 	 \0\n\\ wc
 539c  \ bi 9\ Q\ \  \ )\ \ 2 \ xQ֥ VW\n\\( 4]   ͤ   ՉR$\\, \ 0*  ? %R  *vـR1 i    ʎ  J$\ \  U E  1_= h\ \ 4 !\ j \ 皧\ M 2p\r3$sO ~}) sE!   p\0 \0k\ \  R`    Ra  5\'ɨۮC\ X  \ w\ `{\nVO8\ \ N \ 4 \'  W jN  L9\ 4@ zp= U\0  O\ g 9 k \ `  ?Ξ \ \ i\ \ z\   SQb   \ \n\ { a X\ \rFv  sO  \ ` \ \ ͳ  LF \ C \  ڕ   \0\ dӕ 5  Zz ~\ n愅 \ \  xF#& \   v1R  2[ 4\ S (\ \r \nǜ\ /AHT E\0u   (M ښ ,)q\ \ Ю?\0c iPs\ !`x\0\ dv  q @  %riC 1 ~T  \ p! E(V- ahb{ \ 0  x  ,M \ \ (\\   6    4   pM#K\ \   x   pzzaqVL \ F }\ r) 1\ G 4  \ + ye4\ \ }j,  \'  0 }h  M  ֛\ zSSq`gڤ?}  \nw \ <R\  Δ ,yȤ\ `\ \ a\0 \ i  \ i \ ١ <c H	9 \ X \0 b0W xw\ ⋀\ \' \r#7^i \ ,s \r8s  5
 \ _Ƒp\ ? < c\' M r@\" ɶ \ \0 \ \ OJ~  9\ \ J\  \ (9\ \" Y \ r\r(u#  (H\Zc ub~ \r 8\ Jv    q i s0-   #6ޘ\ \   H7p  \ N¸\ !# )+   \"`2>  c\ \ H{ O|{\ 3 b \ \\d\ \ UGE Ҹ\ \  \'_\ t
 \ A\ { ;Q\ \" \ !\0 S \\\   )IR8)\ ,4 8\ h( p  ܹS M\ \ 3\  \"= dS ~\ ~  P8ϭ  E  n rr)\ 8 m\'\ ֜Ѯ\ \ Ҥ \    y\ MکП !P2(\ rsH\ = 	/\ F> 1bwE \ \ \ }M.\ q QM\n;ԫ \  \0	 &  ,H\0\Z] \ \ F\  \ ސwv\ E4I Z Nᴧ\ {S \\j GJ]\ 744@tl{\ZNK}  
 F1 jH\ \Z.  i  3 Nz\ZPq  \ J  C  b\ 1\ E? \ \ \ R 9f e \ U1 A\ Ҟ \ r A 5\  ѕ # by   ZI
a Ǩ \"@X  zV  \ \ ˰  ? \ , \     c\ XG_XM+ 6  (ܯ    1\ N[   \ ~ \ \ \ \ \r\ \ P \ \ 5l d  w \0 k  \ ?h ݽW   {\" \0B   	➷  \ mA= \Z\ \ 1 {&$ r*U\ \ #@\" \  8G-]߫!\ \ Yz\"U \ \  \0\ [ j}  ֞ <  \ j0F: ݸ\ d  \ \  \ ێ*(\  H\ k5  3u\ ٲ \0 丝 \0\ \ R n\  ]./g \  U    \ bǒMh    V]\ry|G J $  F U.  9 y$    #  \'|   8. NR{ |\ g\ M(O\'  D  ޤÏ\ V\ * \ )\ Y} I\ \ ҉wv\ !\ 1  J \ Mtj]  ԅ9$ \ (B : P   E\0    =>_ +\ \   ѐ: \ Ml\ \ \ hr  \ ֝  `\nE*:\ Y{b  G\'?ZiP\'!)\  S	Lt4\r0A\ \   \ Қ\0 $     qw\ rzR7  eS\ N}E8H O    \ ;c
ғ$u 4\ w=hG \0  &K\ \009 \ p \n  Ӄ u  \ m\  F `= jx p;Ѽ\ \ \\ J \ \ O\ \  s\ \Z_  \0  \ qr\ \n    ` \ \ ͸\ \\0 1<\ x ␸S\  v\ \ -  \Z̓\ $ \ K  \ *` x\ \'  pjmb FX B \ *V oS    \ Oq\\U h   ڏo iʬx 4$6\ %Xp) m\ \ \ \ f  \ \ 2z 0O  b   \ \ F\ R1I  /=\ $ iT 8\ X<dS
 \0 \ ȧaO   3 0 4  \ 6 zVC ?\ \ 56  H\  \ ~n:~ 8 \ $}  qښ	\ \r)v8 O֐\ y4Y  \ # H \ M\ns\ )\n\ \ +\ -\ E\ \ Q 9\ N\n   u<j \ qO u+\ Dr 9 =M8   \" ğ   R]̜XI\   u   ! \ J7g \Z\ o\0 \ !f8ȧ\  \ sM*\  bkQ !S܊M \ Δ \ 4 6A4\ bi\nv\   2  G֛\ \ z\ %\ \ x c=r=\ U \ \  \08ʏN 6q 1R    l\  \0  ʜ0  lJ 1H[ԓK Z   jc\ZX \0w (    SI   hH]F4 =  8\ ;n8 ֒z × րBS6  4\ \     x|  Rz-(\' 𠫑 \ cp~ )Tc \0S ֣,\r ,  \ x  | \  3 \ ?t\ \\ 9C   H    8\ O\0 , 3  iRG& 3 0?\ZF \ XUhQ z = [\ \ c 0uO\ h
 \ G  \ R      \   \ h@\ 0@8   / 9\  \  ΤV   qYNO\ i Q\  S\  S\ZE=8 B  \  ҂} \\Sw    \ \ = \ L.;,:R H\ Ф 0qJ \ nX  & \ n \ \ @# ԒD p     4dz \ +5 1\\~4 @T aI \  0$ \0 a\ Bđ  
 \ ǹ  u\'\ z   =v \ \ \n
 ё\ HF\ p3 \0pd\r  P\ ri  \'  \ u\0qC \ \ \   f\ (2O ܋   
\nry  \ ށd  ƔDr\ *  \ X cK \0\ H  R \  ֡  1e\ \ B <\ $S \0<v   \ \ \ \n+q6! \ I\0\ HQ \0 ϵ< s֔ \  \ Z  \n䎔\ AQ\ id!9\ CE y恫 \ \ \ ڝ\ [ Zj F<СY:\ \ q480\ qҜ \  \ LM      h G@\  \ ^W  mNq \ \  \ M&xq\ @\  s\ Rt ?,\ |\ vIJ.6 \' \ \    \"  0     Z]  9\ L y \" \ \    \ I[\ \ \ U mQ  \ Y Ն? g* [  $ E\r\ 8\0\0z\Z\Z7<\ \ W\ Ƈ\ w   y i\ m \ &n5	 u\  k\'  M~E \  *\ H\ ֞ ܀ \\ f  Y\ \   Ҽ\ ;\ \ \  S|>[Hm  \0\ 8\ %V  b\n[     ܜGc6Bˁ Տ F\ \  \ \ \ u\  G\ U յ; \"}BR=\ ~B    ]    iV \ \ \ \ ?b\ `  Ry \ 5 4Ƹ  A  )?\ \ 5 \ \0d  \ M \ s \  \0 j 9 ͩ]\ k\" \ ٳ] *  +(M*\   \   D\  n\ $ \ \\ a\ * Q\ W{ V  J`    v\ 6\ 0  \ S, \ \  U   J    yooBi\ \ wF Y\ r \ 0\ 5F{#~T \ *-\ 2\ V \ \ 5\ [x\ Mq*8 _   \ \ Ѩ \ oB   \ \ ~ \r\np:v\ O \ \ $63\   \ q\ W \   )\ \ \ \ t \ @`\ \ \ c	ߒ; L   {犦  \ \ \ `g\  \ \ 9\0c ҆br  \n	Ln\ 3֜Ӏ0T\ M\0(      Z.=E)\0> \ \ <z _(/C  \0 ʜ \\S \ `  9N9 \  )\ \ \Z\ \ O8\ !͏   _ @fQ\ )\ M m  \01I ?ʔ    û ކ\"@  
 R i \ \ 隋   \ \ \ \ I  L@ 9 4\ lZiV=1֓k\ #ޝ\ \ ,s  S   A   \ )q \   \r
 B(h   \ /\  Rnl  #Ҁ\ o s l ( i\ \   V\ %~ \0 \ \ \ Pr  < e N   r>P769\ N \ K  \  =   r  9 O p8  9d\npT\Z X ǭ.H\ \ >  \  @= v\ \ })\ C \  ݬ F=\    \ \  \  \ ڕ \\F  \ 2*?3W#Ҕ䓌\ Ҁ \ 6 Ӹn.  \ J z\\ <s\ Q PHw\ = 7  & X \ > hm \ Qo  \ R  8E|t\0҇,} jf| 3\   	 E1ܕ 0 G>  \ A \ &\  ҳ1Ͻ <\n6 yԀ ~ V ߺr) ۞T t\ iTdeE=[¨ \r! Gҙ 1S \ \ 0: \ \ Q`c:g LzpiΫ ڔ(\ 0j@g\ y  ]N=\ Q&\ \ \ Hd  3@\ y    I \  \ \'= 7zc\ F ii)  \ H\ ^ Sw6; \ UdM\ Aŷt\ \ K\ =CQ Ps { a`OZ  \ \ +   6{  \  \0 ϥ8  r  Ll8+ \  } {N\ z\ \\ \ CcP8 [\ By 
   \ \ \ \r    \\\ \ \ \Z 8 \ \ Չ8\   ! Z J֪\ 2n\ R b x e    a\ Lk \\\ ب\ \ \ 8  _\  U -%\n6   <\ L \ >d\  V  { mn.~\\\   D\ # \ ڝ x  - \   R\  \ ǥ1J f d T9\Z( p\ ß  \ ? \nT җ\  ! fqI   N/  \r7NZz \  \ \n_   aF hc[	\ r(2m4  :d҇ }\ VE   zf 
\ 23pI  q \ \\b  1 P N~   =\ hU  Lh
\   `  (b \ \  JKA ǆ$  & +  i6    \ 2iH> \ Vx iH\ ;\ B \r  qB\"\ \'\ N!\  4Xw  ! # ;vӐ\0   zR\ z\ n\ \n< \ \   < SI\ C@l<  \  B y` 4ܱ \ C\09ZĬ.@袗q\ \ !u    4\0 l i   zsN t\ \ E\ )  86{ M)  p>g ;\ p \ 3o9      J   \   \'Ԛ6  ? cx_   0\ M;\0   \ i   ~  H  -\ b    A\ J2 aL\n\ \ z M \\~\ {\nv\ \ $T;  $ bnK \  S7 q ) \\ \ { &J {      \ \ 8\ < p7\ \ )6RB \ \ \ G;s\ i Ƨ!s 4 o\ \  b Gq   4|ē v\ !-  \ \ 4 Q\ >\\zR   	& \ \ \\ Dp 6I Թ$>V\ ߎ  Ri  \ Ǧ+F& \ *\ B?ݫ× fo& \0M\n Z
 J  p\ 1ԓچMÏZ\ ]*\ n5X Ɯ& \ wwr\   Q\ \  U\ T\ 0   j \r \ \ < y_=\ _G\ c \ ă \ \ ~  e . .Un\ \ \n R  coQ S]E  ֩1 D y8 \ P  ~ i@\ 5 q}wpO {3\ \ U D \ 撅in\ \ [#  Y \ < \'\ pj# i\ ? 6 \  \ 00 9b$ \ WO\ m  }\r  M H ! S\ j\n & }6E\ 䍸 n\ D\ \ p0(G\ ߅TiS]\ \'\ WےX  sM- |  >  z Bs  R \ z -\ > #瞔\ |ۇ  /  \Z  Jc.T\ \ 5 * \ VlQ|\ \  S   T q\ . 9݋PZ I\ :d\ jʝ \ 
 2s   ᕄi RI\ Y\ e  j\ \ \ S~\ gMi  H \ φ! K 8# 5T  \'֞I\ \0\ + # FF\ ґ J \  \ f\\ Nj> H4\ X(\ rԘ! 
H  \ A \"\ \ Qf	 ۺ   7S֤ R  =     nicB\ \ I    p\r9~ \'    r\  + Nx\ \ B \ SB  x\  \0\ OD\n\ \ ݤ4 \ T玔 Y\ ߥM櫾|  w4 @\  a?\nvA \ PF	  T\ yp=     \ ׁ֕  \  ~c   9  \ v FP  ЮB\ /5[
q  yi\0px5$g 1Lr  \ J\ b3 <q@.G J Uy\  S\"  - u8    Ni  K\nkc \Z^ $9  i\ \ Q0 [   b j I Q      \ ?xTAʐd.NN:\nvF6 ޝ 1
  z   P  qM#.y\ Sb6  <ӃL\ \ \ #   KqH\Z% < \ :R   6 ~ ` \02i \ 4 >Y;a 0\ \ \ \0}h\  8 `s @\ & $   օን& !d Ta\  =(
;  5Ol`}i    H   \0  3 f$ 9Ͻ;\ \ q  M\ \ V ǆ E\ #\" ~\ M   V5\\ H \  NT \ _   Rmel   Iy\ \ R&\ \ 1 V\ZqV  ~ \ \  à\  \  \ H>e\ GҤުv    1X c99#\ \ >[`\'   \nqLBː(   22 EA\   g   4Ъ 7 R \   @U\ 	   X  = # \  e \0y\ \  \" .B hI\  Fi   ## A\"\ R\" <\nc\ \r\ \    H\\   R `   \ W 2=\ \\~  * \ & 98\ \ N\ р9 \ \ R> \ 8 \ `OC ^\ }h$ 8\ ;v S\ ӹ \ 3 b $q {\   q  i\';qV   \ *32 \0 \ ŪQ >n=\r3k/=  \   f\ _ hZl; )9 )Ŧ+̇ v +\ ޑ \ :T /   \ \\V> \ (ヷۭ
c  \ \"\     \ K\ &?h͠\ J>Pxɦ  9\\ ڜ \n.\Z\r   \'\     ͸\ Qq\ qV=X\ O  \ y iF \  E j78\ N$\ R\ = N\  ϵ\Z  \ q֔6zR  9&  >0   \ LM\r޴\ ͏ 4 r8  \ \ZM %\0   \ lx\n K ҙ$ \  g MH 3 \ H\ Z   \ .H$$v   n   \ sN#  \ 
p  \ \ /\ M\ =I?J]ŏJl  \ Nާ Zi  R  \  W ` C֏ݯrh  U\ ~44LN@$җ\ :a~ y N
\ZV\Za  R \ i  uq P\ ֘Pu Qh<4K \   )< \ 1p\  (\ . 31 \\ # 
   A h\0P \ 4 z\ X7JiF$ p* !̤w   \ <)\ \  \ \ 8 7`w y h\0\ \ A j  \ X < ǃH
  ӷ \0 \nC  4 \r  q  }MFʝ\ ?JqV\ \r/n( \ \ 71 \0w?ZR F)D\  \ \ f ţj   \ \ ): [  I\ \ +;{T I$ \ri \ =D Ҵ z  *\ \ l`Q  ^0z\ f  & ɗ\Z3\ a\r \"   \ \ \ > \ % a\ x \  |# L  \ 5\ O\ ~\ +y\ \ Y>\ lޛFjx =B^E   a  7  ~X\ !ODP*   Ҝ\ t = M:ϲ\ יdh%pn.!  \ ({m.\  L\ \ V{\ }٨_/ d   g7   -     j    > ١ Ix?\ \ !\  Y^k \ V\  g5\ =u \ \ \ u F\ 2  S \ T s!̓3  j,{Ъ; \ 1 \ \  c E\    B  \\w D _1< e ۓ f[9 jS \ L p \ 1 м S\   \ 2  \ J q܃\ * \ @ \  G\ 2  \ ;  \ \0 \ 9d   }*< ! \   ұC\ ר\ ڐ#c \ \ i BF:{\nP	ϯ Z    ֕ 8\ H  \ 
pj2   cHs p#\01  
 \ \ 9=*Kx q H  \ U\ 3\   >U=  V\ ta\ ~ j
 jU \  \ H0rW C)\     ;   \' 4  ֣f\ \ > \ ٘  қLрx`q\ (FMI    zq r~  \"F
\ 䊓!׾O 4  ;c <ӄ x\ > \ !ћ bi\ 
{\n  z BO\ J ~\ r=\rMʱ&\ _  \ Ӳ[  =E1Ll 8\ 4\ .\  \ S \ \ \ \  \ 䎝\ 7k29 \0\ Pw.w ( @!zw?  \0Z \ @s  .O   ƚ[ x  q \ \ sJfm#q   f\ \     $rИ4< \ 1 \    \ \0\  ~ \' X{қ ~U\0U_AXhI1 8\ 0&Ò\   }\  t }\ 3\ Kq .  t bF8\ \r  v \ t\r  \ \ .Їiz\n  4 \ \05\ 	\ \ \ A jc dTd 2}醂m,8 Ѵ \0\ i@\ rFO\ J 9 \ li\  *St  \ R\ \    Q B;\  \ j\ La }ՠ  \ c=\ H \r \0}*7\ 6X F \ S \ ڟ\ F ʹ> ݪO  ( 8\ @Y\0\ r}(7\ HUq > y@r\ E\ \0\ >\ )C  \ Rޣ.3 H4   ( # m\ K   N\ RI*ݨ\ p1 \ K \ Mq sM\ O\ : (c  \ $})P \' \ \ v \  \  \ \ L^  `\ q  >\ ?1\ 9 an \nv\ \ #ڜ a<  ZC 2)  9\'4\\N\ Q \ f  [qJ2 #\ \ 8 `Hs7\ B sL2)\  \  J\ ւ \ <   \ \ m  B\ d )\  ;SU x \ 1 \ il[ A@\ LY[ UǷZA Aظ 5\ I=)G <\ H^  \' \ UT MJ@#ɨ\ XJ4\  `? ph$ ⛸g99  \  8  \ 6  Y w 0\ w` \ v.;\Z Ԇ\ iY\ :k; \ Q; 2  \  4  |¢9  (` I\ Z\0= cP l \ *  Lҵ  G| c 7   + ~`{ӷFG    \ \  `SB  x  T\ ?\Zw q\ -Ũ c  \ 4\ J I  X\ \n5\ m nx  \r  0Ni \' 4Ry? A \ D;1 \ : Sp7qR :\ +   \  PI# Aa =i  \ ; >Ԡ  ø ) 7 9\ LV0GR)	 \' / q\ \ G ; M o )U \ (\ \Z &       pi aQ [  > \ 8\   c& ø  \ h r7g\ ) |\ 3V 7	\ \ q\ Oߎ  t  \ HI( \ #Hݱ \n \ \\\ \ \ L nI8\ H\  \\   P{\ k \ hq\ 6 I {\ l   nƜ!a\ 2 Ɛ\ 4Ӟ ԥP    f5)?ST+ p  \ \ # ?\ =T\\R w\ \ H4\ p3  GԁLb\  Ԡqօv \ ?y \ )\0P\ ! MH \nz\ \\  \ O`3CinM oa\ T~  \ \" ţ\ \ \ Gm)  U  ) ?\ G  VoN;    \ \ \0   \0   \0\ qs @  i m \ r\ \ 9 \ T}j\ M \ Zݘ{@5,QK)
lĜ\0 Z\ \Z  nJA  \ \ $ M \ WHqoq  V       ݉   i e    \ \ I ]\ w     H    R~^ lUVgrL  s  \Z\ v JP[#t\  %  \ JI \ \0R   Zs   \ Nk O7\ K\ \   \ :    -l   ؅\ Q   q\ s \0g \ .ǹ 7   z\ M\ \ -<  - l \ 5U   z\ JX SN `\ I. ︹E\n?iVV8Jj o 8 F Aކ\ \ x  iw}i] A| \ 1N ڐM\ =)  3 j\ 9cg!@%  ) G- m 6C\ \ 4 go\ 8\ Mxٹw  \ \'a he\ s\ \ Mb\  \'\ S   \0~ \Zb= >\    O $| {S7 8$\ XL \ GVU * O \ \'   )44H\n     <\r JU \ \ >dKCp{ i7 <t ` i\ \\    )	\ \ i Hl \ ?+A\ \ ڤV$c V\ \ 
ds Oz \ s  O 4    \ \ U\   *   a I     \ S \ xsHn :$`|ݪ   >S z yɎ1   @\ \ \ I<VX8Z<Ƙ \ a F!E.\ \ 1\ *  \ 5   < »[\rg\' \ ~\ 䎕!# S|ݜ   $;GU \0?\ SA  2\ 2 { F	$ *(\ #   vS<\n _ h ~   dd i\ Wc\   D ܟJz c < * \0 0\ ` \ -\ \ q   \ \ b 8\r I\  Ƙ \ hR \ *\ \ pW\'  \ H  籦    ΑJ  zJw
} \ qoo \ H H[\0w\ ?   \0QE\ \ ,x$ \0֩UF d  \0Z \nBO \0]*\ \ 8\  \0_ \0 @4` b b \ G\   i<\  \\   &C\ ?\  \ y i怇v   \0<R3  \nN  \0  Arq\ &	\ z\Z  (zz   jg \ 1  \ l\ \ \n  n\ hy#\ sMf\ r?\  \  \0 3J\ d  ihF@\ \ Ҁ |\  \n_,Iܓ\ i 
.A\ \ N°\ 4 \ 9  x] қ   O  \0> \ `B  hR\    OV\08 \ Ґ/  \ JH  ~d7za~ \\   \ b \  \ Ƙ\ 8\" { \ ;\ W \ \ Ab8\ \ iCo?0 E&\ \ sQ  \ 6s  S>bz\0=\ M\ \ z d  \ =(@.g 9   UPO \"F3  \n $=i\ /b/6L \ J\ \ O\ M#&FsH.\    R \   \ @R4  (\ \ sO \0\ y  9\\ r  $}hL\Z$\ X p)
  =\ c< \r\' \ 3\ \ h  bO f \ c ?\ P>gǵ5 W\  \ 2w  4 \"    \ <     *]ƚ8   ,|\ \ \ *-  \" \"\ A .+1\ !9W\ ֚ \ / })$ Z \r\ )\   JB\  \ \ H ;d\ZlC  ;\nPU I  D \r M%\  \ `L   &  \ZO3wjR@- j \ ԥ H\ H\ ~\  & .ǩ\'\ @&+ i\ \  SD\ \    dr:\ EB @\ 5q\\  c!O\ Qo  \ *;  Ӳ\ >lS  4ʧ\ M\   E _zp  \ h 
 \0\0\ i\ !Ԑi$F c\ ,: i\0 \0 t  M    Nț w aL\ 1\ JB iV\0 y \ I  vj\ \  :\ 㞟 / p  \ \ \ 8\ Q   ] \ 1G r2@\ 49\ Zp {qLB\ @y$ (\ \ \ \ \ m# \ s\ =i\\ < F@ s ښ\ ړw  = [= is\ jc\   <\ 6    t\ L^GJ #  ۚw 6[  \  \ \n ,  &X  \0+ɴMn \ nv }\ Q\ \  a@Z\ ,x  Ԑ?\Z  brX\ EʞM\'&4 ?*    M \ =  TC  q \ Mʱ) HbQ 9 \ \ p>  1\ \ f   \ 3ᢴ  ܌P\ \ nơ\'ЁY \ iJ\ 5   uF; b t%\ U \ hy \ !Oe e  \ Z   \ m SI5ӈ 3lO \ \ 0  4x F  \0 }) n  ̟\ W  ݘ0Z\ 1
\ O T Ѓ\ :  3[yC\ F
W$ }\ 6\ A
\ 
Y \ 7  Zi\ >   ˢB \  /  \ `4   z b\ ~T \ \  7W\ L \Z\ V)|  }\ \ i \"p\  \  s\ \  \ WV   | 4͏\ \ 7 Yx \ \ GN2s\\\  ֔\ ǁ  J\Z\ \ =  \Z\   V  Ja   WRgͺc 5W\ \ I4\ \ ZF # !ͽ\ \   \ 3R s 4 ʜ\ V Ȗ?\ \ E \ ?18   HO\ M )Cdq֚ z ʇOZI zHy\" ߓP*Ue ;6-  i*3I \ S A?y ~  ( } \ q\ \ 9  A\ B~ \  Bg\ h y\ J \ r \ H]  h,\  $\ 1  %G  ڠ\ \ ,} F>S S \ z Hc\ \ #
   z  J #   \ zj\ \ v \ d\ c\'4 \ <҆A\  {Ҹ\  \ 4\ X Zqu`\ \ ( Y 7| S 3 g> ܟLZTBǻS\r % d } u  \ _zd  8,y\ =\  c֝ \0>  bS n#֔\ G\ U_¢ 

\ \ @N\  M1   Ɣ # j,1߻\ w1 \nU!H*  y H \ ZP  \  ?\  f C|\ <gڛ  \ i잼\Za\\ \      \n \ 2*\ J   \ ?\   N1\ \ ԓJ  @\  \  \0 \\8   Qه\\   33;9$ i\  \  ?\  5\ A  \ @   \ \  I  k )\ 4 ?\   O \0]#aN	\ \   \0\Z0\ g  \0 R\ 8\ u\0 ȟ\ ZZ\ \\a `  #   \ \ .@㧦8D  I =2)K?( Sa BB  L \  \0 JcÆs ;     8 n \0\ ? j. \ d  H9?ONhV\ 3  \0J6\ \\\   \0v  \ z O\ h   <d  \n \   # SC   \0 \ \  \ \ 8? abC  \ \ N
 \ \  S7cө tǔA T ; =\  \0п  \ /`\  <\ \  4 ((A  4    \  # 4ҭ    4 b\ I \0@bʹs\  [ Pv  H\ I+\ GҔ 19G^~   _\ \ \ \' \   \Z!E\   \ \ q\  \nFf-  \ *7c I   Rj\ fRH\'q\ HG
 \  09?Μa\  \ ?\  (wa \ rF	;        M1F޼   =N\ 2s\  #I	 \ Ya\ Z@ :   \0>\  `s\ \   (i ܑ   \0     /J]\ \  i  \  to\  X \0? ]ɱ\'     \ Mt;x`  Ý\ g= ژ  ?u )| \  \ \ J \ 0\ #ޓ	 	>   \  # \0   \ 39\ )\ K  \ P\ Y   )64   \' j *zΫ)\ r0*t\ Қ\   \ Ҙ\ EL 4\ P\ )  \ \  % E&\ N}> )  $@     $sOu\0`\ \ @   M =\0ˊ@\ \ \ c\ R\r \  \ Me 8\rR\ A Aжh, ps  \\ =\  S  N\ \ CZ<  - @ Ѕԇ \ L  yʧ q\ Mk z  &\ \ ##ړi ֝\ / r \ \ GL\ B  9  (   \ \ K Fi0l\ `q\ {\ \ 9[vFi\ p:sI 3    d\' [g\ \  }Ö\" rwP :    qܚ,!\ } i \ z_, \\ !!sL   \ \r.\ \ {R1\'\ M\ O␆    gҏ/q9\'֏\'- U \ {\ !hX Rm\ \ >\n\ \ \0 \    \ -` \ { \ NuA \ HG8 \ M Ҫ9\ )Fݸ\ eJLcҺ  P/C \ HJ \ ϵ!Pz N\ h
?f\ 4 \ @ )Bs \ `< O \r \"6M\ d       ?J  bW8ڄ ֐l!v \0m \  ;w  ā ېM8N  ҋ\r Wp\ O (a  h  \ w y- Hw5)  ?:Q\' \ M©\  \ c 	4 i\ nX\ \ & $\ mP3G \ \ Hwbr2F;   \ pd\ \ 0 8?Jb   N) ԛ 8\ \  \0 @ \ @  \ u#CJ\ % w\0{R\' \'4 \ O9\ 2?n & z \r < \ >\ +v5NO[8 \ \ r9 \ E  \0\ ]\  9\ s  Z\ \   I0\  q Z\ \ MJT{     \ o,\ \ \ zp+Hj u  Ŋ1幧K⛣  T 0 O     
vC uK  eS\ \\    
 \ \ \ A ; gK jS    E v̗O &  yn\ *kdtcD    \0IԤ    EBڟ l\ e  g iI }+\0y|\ \Zie\ N}j~  M \ {$t/\   䵲 =   G \ > N+\   >\ \ \  5 p \ \ RE    &K ?\ U8\ \ #1     El  !  b \"?t1  ~  ( \n \"\0繧\ i p \ $ = I  \ J q @ 9i B	 \  \ i    j&Lr\Z  h  SO\" \ ZD \ \ Ҥ2/e\ Q(s© 1 \ _ƫA+ f϶*4   \nq\n\ \'\ L!w \  i\\vc  < FB \0uM98   Ibh Xg  \ \ HvF  \ \ :PT \  f  . ݝ  Ԇg\ T* B g \ \r c  {\n\ $23 \ \'\ I \ pG 9\ M\ $ H \ ! 4\ \ piKqR\ =.\" Ěv\ y\ ݃ b \ i \ \ T\ 1@ʶE&I h&  \  &  	S\ _I\   \ A jj -  \ ihP1 bv\ U$R x \ @  w \ \ zf ` q\  \" ؚ\0 vܳ{b \ \ ȩ1   I  ̋\ \   s@  v aH  ר  \\ +\ V \ #g \ hێy4 \  Tg R \ `  PF\ \  & \ 8\ 3o#h \0\  \0 C  ޗy\ ?\  \0\   \\+ =\rG$x t  \0?  (q  F\ \ \  \0AME\ r\r;c\ v\ <  \  RI= 4  F~\   \0# ҕ
\  ✻K`\0s\   !CvCJ\ \ \ | (#\'\'\ \ UZ\'  $ \  5ur\nr;  \ 63 ^   a & \ ^ F\   XX \ \ \ >  NX3e :   \ \   \  H\ y? \   \ ^d X.F8\ O Fr y8\ ! 4+\ _|w \   q\nO\\q  \0 >`  3   n \ 9  \0^ \ <  {\ P ^y\'  \0\ P\  \ \ \  \0֥A A\ 8\  ?֍\ \0# \  \0 O \ 3|\ q ߠ ; \ 61 \  М \  \0 ҩ;   \0Z !\ ~m К Q\\GM    )$>Gs\ \ M,FT\  \ AS9\ Fs     S \ 9 \  t\ Q \ {qO1Ąnr\ c\ r? 7\ P \" :d zR\Z  8   \r \ >={ \0   ac 9^O\  \0ץ0*\ *á\  X(\n \ \    +LX   \ 5  A? ?֚	f\0 ?  \"o0 = ?\  \0 NTB rC7 \ E B\ #     \0Z 0\0 \\   `\     y    rG\ \ Ӕ y^ G֝ I 8\   1S{ hC ߃\  \  )\ k(\'  \0 һI\0s\   m    ?\ i  PĒ s\ >  )a   \  iU   \  ? p  G\ \   !6& \   \0 I !I\  \ QO*\ \ `\0\ H  \ X  - \ F>v\ ѵ  \ \ \   \09 I \ Tc\ LRA\ \  ? &ƴ\Z1  c\ R s  ^\ ݁  \ L  \   { z/aZ仛$J \ \ H1 \'  ?\nT\ \  \Z9  i  \ t\    j7  =)\ ,,q䒤g \r)    S\ \ Y 3 \ 4Kb\ ͓ 7\ \   ) i\ G  \0\ZC0CQp$   \ B @*- @  \ HG9f\ E V\ : (   S  r+p2}\ Wo Ґ\ !;: ~  n \n ނ \  qK )\ ǥ\0 Y\  \ 4   >  
9\ TN [ކƅ1+rgޓiL\ \'ޤH    嗡 \ 
  G Nh t\ H\ n\ @ )1  Z  bO8 ȥ   > OCM
 zP& q\ \ 4 	   HCJ71\ \ }i  \ 3L\'\ S A  \ \ R    y \ K\ ʨ G֛  \ \  \ \ ֑\ : hS\ ҂\ & \r\ \     \0 }q@@q  N\  = H  ϊG ז\ )  8  \ m \  0 &  < N\  $qE  &Ӝm 1 \ \r<H 4 v\ \ \   \ }ic \0W J\ e m 5(\ }i\ h  n\ \ \ .\ \ ]\ ҒF2h \  \n\ rJϏ\  S  ֜\\ w \ M8n Sz  \0 = L[ \   4   (H\ 0n\ Js 4 y8\ )`\ O4\ +  \ \ < i\'r MTH\  9  \ (  .C 28 0\0zQE p7 T F\ \ \ E\" j\ vV R( 0\ y5\ Kemk\ m\ ^    Q^v)   3P  0&`3\ VM\ \ \ pelQE<: \ S.\ 2X  ZU   h  b )2\ \ Lm\0Tn\ / QEl  ؓ\ =  ~r;QEg-   \ \ *M Ҋ)t4}\ H: 4QS  \    V  (\'p    9  \rr}iG \ E11\\) # ( ` \" \ \n v(   QP_Bv d p\ E$K \0QEZ r\ JÊ(  \' !\rT \ \" \")ў  (b  \ (~0Gz( \ \ 1>   \ MRBb Z      \ Ekb  a  :b 	bA9ǭQ\ \ ܃\ A  ̥ \   \ Tc \ E   \   ǭQ\"P\ y?ZI$e\\   \ ( e bq\  \0 Rc2\ ?֊*\ \ z \ \ 4\ r  \ \ O\ \ V \ U 9   (\  \ Z(  孂F+ 8\  \ EC\ \ \ O \ E \rn6%\' rZ \0DN9  \  Vs Yk\ F   GC \ \n͔ =  ٢  0;\   	1 \  \r4 [\     Y\ ry\  jr  \ E   v\  \  S\\\   Sd\' \  + } j( BdhN =\  5$1 F	\ *( P  \ A \  TH \   \0QE ,RN\   \ GQ }h  G\  \0 QԂ\ \" * =I   \ <\ i :  aE\ RY \'  4 \ ~  \0A  \"`HS \ \ \Ze\    *Pt#O   \ \ ו  \0\ MUD J G %\ 0\0#\ \  \ 4QT  f$ d\  \0\ )09\  񢊖4,\09P\ #\" \0e \n( 9 \ \  S S {E\ ; \ Cp}j\ =  \ ( r\08 @ t\ \ s     \ \ f \ zw  QV c\0\ \nH Z(  Ը\  ¨2.\ 1\     ,\0(  \0\nq\ E @^ &\ J QE ؎\ j $Ɗ)= \n\0<i  S \ 	\ (   Ԏ `\ S! *I  V,\ \'4Q@\ F2M8 \ EL01Ң  ;f (` \ \r\nO RE11 v\0QM $`\ \ qSmR  f )  \0\ \"  m   \ P c :\  \ N9   $$  P # SD9\  QE\"^\ 3 \ T\ E  ^\"  6r3E1 	   u  Los \ '),(5,'Salón de Eventos','Salón para reuniones o eventos sociales',5,4,'987654321','10:00:00','22:00:00',NULL),(6,'Taller Artesanal','Espacio para talleres municipales',6,4,'987654321','09:00:00','13:00:00',NULL),(7,'Campo de Atletismo Principal','Campo de Atletismo de 5 carriles',7,4,'987654321','09:00:00','18:00:00',_binary ' \  \ \0JFIF\0\0\0\0\0\0 \ \0C\0
		 		 				
						
	




\r\r%\Z%))%756\Z*2>-)0;! \ \0C 
	


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  \0\0 \0\ \"\0 \ \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0  \ \0E\0 
\0\0\0!1\"AQa2q    #B \ 3  CRSbr  \  $  \  %4s\  \ \0\Z\0\0\0\0\0\0\0\0\0\0\0\0 \ \0/\0\0\0\0\0\0\0\0!1AQ\"2Bq #a   R \ \  \ \0\0\0?\0 E	 \ Б_v|\n#9 9 H \"    \ BsFE1  \ 4  M \nL  6*J )  i @\ \ZRcjb( ң\ 6)   ,Qb \  Kǭ,\r蠱\nq :p>\r1X;\ \0i D D\ \ \  X  \r  
 \0 ) &\"   JE	  2<  H  \ ;\"  ԥz\ `\ 1dSH #\ ZlQ\ M)b M,R    K X ,  *Z| LyS`S \ FV    <  p4   4\ i pv \  *|yP \ >(    D8Z0\r2l`(  S  \nh! b(J\ \ i \ *  \" +BV   +S  +@  \ jm4\ h i   \ KM -4\ jm4  P=\ 8 \ S饢 \ A    M-4
q p .   \ \ B . Zz\ =\ Zi \  i\ \  B\   \Z!!
F \   E   U* / ƍ@\ N\  v:
E	Z    gf U+BV   1\ bh S _* c ) JvC WE1Z  ʇG ;\" \ )i :<  c\ \nҰ   \ KE\\ \ K \ <k   zԓ\ +  m\ 2   t , \ WpŏC W6mV<-)>μ\Z< \ q]^ KEu/\ \ Q  Gv<\ BZ&    T     \ r\ m qw \ 2ԡ ő  \ s\ e\ ) ah\ u6  ˧1  g\ ? u\ \ \ *\ \ Vy~\0ӈ \ \ L \ \  \ \ ,q\ v  \  F \0 }  # J\ \ X \n\ UX  ~UdGK@ \ 5\rT  Wv\ QK1=\0& q[\ ,\ I   U H8]d  æ7 k\  Ifr V,  \rG|\ I\ \ \ 꽥b垞 \ \ \ τo\\ (r  F b#;j9>UA \ \ C iI\' \ erڱ q +)\ ]   \  \  1 O\ j ˈ  !ݙC\ t.    ¼ \ \ 䕩W\  1{?5N7 5$\ W 4A\ UU*\ !* F z\  [\ QK$C\ v \'
 ~k  Tr  8\Z  \  \\ww  m}- \ f P 7H\  \ \ t Zi \ 1\ \ &Ũ\ \ p $ \ :@
 
  \Z \  #Θ\ \ \\zKq|\ >[ \ \ C arN!ea \ 79\ ;wV\ C _L-\   \ NB \ \0\ q5\ CW	 \ \ \ \ 
 \ P5  2     
  \n  PH i  XC]  \ +)\\c b   \ \ 3  ,  \ s     mcõA-\ \ Z S ǹv \' Y\ \ I    D H\ `    ;\ \ \ s  Ch[kH *\ \ qpdh    _d /\Z\ & 3U\   7ǣ       \ P	\ 0c \ e\0cNz 3\ U u\ \   \ 4\ p  e  0\ l \  ᇆ Z    Qd \ \ f L 0q  ww_. }  
o.   r\ \ T \ G\ ǥ \ I$ * \ Ǎq 4%7QݳMq   Tk
 Xi\  \   \ n\   WP H`w _\n zՕq \ <N\ (  \ <t(N Zq
 \\hA
 N $ 7 i ]\" \ \ m \ . !\ \ \'\ ?* \ WsF  1 r\"   @@m
 m \ z\ d \ \ @  \ !\ \n2q\ j\ p!=  \ \'  \n \ Z  \ 5 \ \ \ \ \ \r Ҝ ,J G ! Y \ \" < Vp\ \ +I>@\ F@U  =\ *( \ \"4\  A \ \  C  
  i   ݠ\ \ :   -n3\ f\ \ \ SIߜ \ θ k3\ \  -    t\ D 3\ #Fy,  \ \';y\  \0\ \ M-\ Q\ \ . K*/x      v-ٓ *\ ! \ \ %\0$N:t\ /\ 樐G     \ \Z\ w T vi%\  v - \  a\ p 8e?gId8e涐I\0g;  1ULD   \ t2\ ^   \ f e N  w \ BxM 9\ (ޑ*\   ڪL\ \ i\ \   ?( V  3  r\ 3F \\C 51PN;\ ^髙 n\r\n  sh1 +r\  \ ݜ k=|c\ &\ 9v\ \  \'\ l \ b  (RH\ Ie\ \ 9\ :gj䀕\ e d\' \ \"VX\ P\ 鷕zϣ^ \ \ ʹ\  $H\ \Z \ 2r  Gy;\ \\uϢ R\  x\  
  B O,7dƜ\ !Ii1  q y\ \ k4\ \ =\ 2 J]     \ @7a \ \ \ \ >qT\ u}@ \rꌆ\ 
d` \  \ ub   @  eI%1 %͹Hl8  N \ n |   x = } ʱ\ \ \ MZe ϛV \ \0\ F\n\ \ 3\ \ Rf\ 8 wb\  dU\0c== 6W  b   9  \ ꫷ \ Ic\ l  H\ h\ i  -&  \  \'\ J\  ҶL \ H\ e bז (92 \ \ \ WB<6  N \ ^t  0 9\ H\ 桹    \ \ $bF~Yq [F3 {\ w \ \ B \'H\ \\ \ \0 \ )#\  _  R o\ \ ʮ \n 疱F \     8   (e3\ ) \ 	gbݕ;     \ 
,V 廲 a$\ f$ 9P   \ W\ \  \ \nM\ ,\ ]\ \ et  3\ C/Cԟut     \ \  ) {\ \ ?1؝Q3>\0\0l 1  w\ M{r&B\ iP e\r @  \ P \ d 3    c \ n%p\Z P\" ?\ +R \ [    J  B \ \ +  $G  -  ͻ Y +\ \ y4B
e \  ##n F\ & 3 ȑ \ \ lnt\ \  Ո  q)hB\ C [\0{/   Ox \ ;P?\ K\" \ ٕ  ! \  5 \ 2\ \ bn  \ \ (\ y H\ q l6  \   ts H\ \ $  \ \  Y \ \ (\ s $   ,\ u@ 3[ \' \ i ޲\\8 Y\ @	\ F\ \ I\ lzf u \ g8) E{\ G\Z[\ mt4\ gE  X Y
gխ \ O\ n\"\ Ja T>G  \ Ʊn ]]X  \ \ J u8e\ \ q\  paawr .Dx   \ W 㔲+( \ .\ z   \ 
Tԭ\  \' \ \ *5  )Q\ 40 = )     \  \ n ;<  Wfbq \r\ &D8 \ M$Wv UpL%\ \'\'Ana  u   \ ث 藤 P\ `  9\ \ ef ,U  S  \ ~[GS  ]->6\ \  _Y\ \ \\)vC ؎ b \ <k qk ע>hU  d\ |   \ \  \ i= KX!^Qx  YyC\'Q9Y9lz \ \  ؽ$  \ \ {Wȗ  \ Y+r `/]   Q\'<Ѯ?\ F8 ˇ :D8   Ix   NE 	. ..ĺR j8 1\ +   ј 2I\ #\ \ \ Ep\ \ \Z  {)\     ;   \ 8\ /m\ \ 24\"\ G }\ 9M:  | Ƀ  mq\ \  \  \ \04m   Tm  \  \ \\v; \ \   \ ?  \ p \ \ 6[ & ,  H `A  ] ^#?;  4R\ .\ I$  Q$2  6F0\ \   3\ .   \ 윸UY]\ \n   լ`l~ ޺ 跥<Z\ ǈ  7M\ s\n\ s:\ *j+  FQ\ m\ \' \" B8   K\ 8- qGẾՠ\  4  1F \   8 \   W p\ ಓ  [ڪ   \ YN 5i   ! ^ \ K8 \0\ \ e\Zw\"Pz\ \ \ ʩ  \     hN Ǣv\ \'J\ ݰ \0  Ys  uC\ \ = \\`_qNa! \  \ &H\ 4 \', ^ \ ϖ\ \'   Pp\ [mod   X FK. 9\0     \ @}5\ s cy  \'\ H5# wm\ \ V  zgk̓ ,sJ \Zn\    s&s T\ Çȼq\ ;   Z   \ UU1q c m.\ g>_ emy   \ $\" ѥ r  t  p  ,x  A +xɪ)Fs  D\ OZ\ g \ \ 3I\"I\0ƭ 220\ \ \\\ eO j T \ X A  ͥ \ }\ \ \ n  @Q\ s 6\ \0  ~U \ 8_ <)\ \ %\ \ \ r ח%\r  x\ >\'O p6w Z_\ \ [* dY_)\ 6   \ g ߦy\ ^܇V $\ u	$ rJ1 0K AOF ![\ \ s\ \  8H ֟       \ U< \0\  H @d\ 8 錓 \  ep\ I \0 y \ 璫dZ^e%\ <H?b   \ \\ \ !\" İ \ \Z\  A  -[  Z\ \ 8  >M \ m( \0 k\'\ ˴ \0qn  &G9˱>nZ \ ԟe\ ?\ \ \  ֈY \ $   \0  \ f+ 2w\ ԯ  \0N CY \ Yq< \       !a\ \  \ 2\  խ6w ?       \0W\ O  \ * 8w  \Z H \  \0%qRr9\0y\ %  &   \ $=Jy\ \'\ Jb\\g \ c\ W q  % ߑ   g5=   a   O* \r\"  Z-G  \ E  \ \ \  pDJ\ q \n \ \ \ U*Z\ \ \" ܪ+\rQ\   \ S98;|j    F \  P$i+V  \r\ _ \ 
X  ƽ\ 6\' \Z  \"Nݢ !vH   \ $ b \"H  \ \ I#   q  2 \"l+ &  \  #+ b\ n  \ y\ FNt   > }1 ̗WKq  1\r1\ \  \ O O®X .XԚt $6 V \ !  \ c	     \ W  {\ M\ \   W{ =   f
 F\ ҪVL    M\n\  2  Ky 4m w\ \ Y\ \ \ \'+msw\ e?\ \ 2Z1 I21\ \" p\ `\ S\ u3  \ oF  V   3.c}QH & c uk؎+\  h\ ȗs\  \Z\ \ PO dRj\ D   \Z ؍ +R\ \  C \'    \ \ @\ \ νc kf  v 
     
E1\ A Z\ \ u ) \ ɤS\ $ 􃂤pEp J\ hZ$&b͙䮑    v>  oE=%2\ \  ڼ \ 8 \  \0(\ ,O mJc\nϐ \\\ \ P VKAt  ~\ m\\ $ \ D\Z \ ֨  ]\ M|[	] g\ 2!\ \ X  Gʷ  I$ \ ^ 3 x3\ s\ +     K\ \ T  C}Ӫ[ wvʱ 	Ѩ.    k\ \ [Y/ \0  [ >
\\\r\ 	 nm\"
 +\ZK	-  \ #\Zr%_ W  sѹN$\ W \ 6\ 4\ <fJ\ Y K    \0 K  y  \  \0&   wz.\Z;V  D\Z \ [ UB Tǧ\ \\#pT B . \ U ݎ\ 	*\ \ ƻ \ V\ oa4\ \ :    i8T\ u%i\\ l  H\\\     =   4\ y p\ c}\ d   G) N1\ \ \r \ M _:ё $*Z yq w]J	  u\ g  \ \ 3  ,ai\n\   P  \ =; O  Y hc    \ S\ ߘC\0?y \   q \ \\\Z\ \ Gc  \ Z   \ \ K w\ \0}+\ m*  \'\ \ Q4\ .  F<R\ Ϭ\r\Z\n\0 1   \ \  \ 3  \ \ X x  e\ b D\ v\ ?d[D ;\ = 	. \ \ z\ \ C\ &\ W \ \ \  \0 \ M1 ; t\ M`\  e#ϘEvo ?\ c_\ ގ  ${\ ғ /\ ~d:@\ @ ; 76,\ ]R6\ D  \ Wc  \  \ \ \\  >\  *\ Y\ T \ \  X\ d k~   k  \ ɺ[r\   c\ Hމm t\ x\ \  ;( }\ ?Z ZȰ\ { ; + \ Ҧ_ 7f$ \ ; \Z { J &h  V n;X \  \ o\ n:|\ \ @\ K<\ n:$cL@ >4\ ,\ 9  \  \ ,X \ |\ \  \r6 \ twO\ \  \   +  >.JM # -! \ \\\  Щ\ g	 N F x  ҜZ \r-\  \  v	7l G   \r ,  YT  㳜\  \ nqN $\ \ \"d yXIr\ C܃ k\ D 	 f? PG\\w\ \ Gkt\ \ 1\"L \0V\  \n q\n̘\ \ %O\ |  HK \ ;! \ %\ = X2\  \ j!r  /c   \ *(g \ \ X p\ OC\ <\  \ ot \ R U \ <    tf \ c\  ! \ ۳ (w\   \' ҪO\n f     \  G  PjB.\ c \"v\ J1 #Ƭ, \ j \  F\  V3 d  h#k   + G 3\ M\  \ RLy0\  d\  \ hLRAWR  3ֶֺ  \ %   	dlt;\ cP  9 Gu  ^ƴ;  &   K 3 9 \ h\ ]    \nBʏ\"6  \ p  \ o) \'  bφl|}Չu\ \ -Ö  oۏ,   \   \n rige%\" |\ :\ ߌ\ * \\@\ ;   8Ƣ2]     Y  EU S\ N  ɩ\ c/,   
\  ?vX1  \ ?J\ \ \  3 h \ -G X@퓱r \'\ \ \  \Z \n n   o2*>=&   -   A\ `e \ 7$ < \ q 4\ \ \nB <*u\ \ \ ~\ 5gd,. \ p  # \0 [p\   \ J\ 
   j\ \'   I      )
 t8 \'\  d\ \ nl ).  !\ X\     \0V~ d% \r\ ( \ 5Տ{mQ\ \ tT x g\ \  R  \ 4 y\ {\ \ Rߩk _  l <\ \ R; \ \ N (\ \ \  3\0   R\  u # }\ ~ \r \ 1=\   _֎ 
K M  _ZQ=\ \ \ ~ ;Ne}O߭ 1   u !?   =Ft \ ]\ H \"\ \ y o p \ [K  *)  \ o  R\ Ǡ\   \  ir\ \ \ i9h \0\ |M<׼2\ 2\ 4j\ \ 0  {\nź wl \ &p%p \ w 9\Z   k & /  p |L\ \ v ͙ ?  ` \  \0p5J\ [\ \n\ Dea 2PR1  \ ǲ Y縸 \ ;\ $ \ \ f\'m $ \r\ 1\'9\ 3  \ \ \ N_	 q\  \ ۫\ \r\ \   #. \0  g\ K \  \ 6BDn  \ \ N?\rR$1@\0\0ݹ\ ƈ(\ \    8䚖 \03[ Ѽx U~ܺ \r$F\ 0\0篻\ 4 \   \"     \ ۻ)a  6\ r \0  \ uK\ \ 6;k \"cXB0H\ = ]\ [ ] \ a\ 6\ x \0   
 \"   \ a s A 1\   \   =cI\ \  ư$\ 4 ,\ 3\ \ ݏm M  \ 욶\ s ʧ y 
n\ \ Ң\ W 90v\ \ \ # \ j q\ p\ cT\ `fџ\  \   {v  \ d\ \   \ ϗԽ 6  |TFUb \    ՛b \ \ P\ \ nYp~͕#! \ \ V\ a  DIR\0\ 9    RY g\ d ҇+  6\ \ m	M ٣\  6\ w  \ \ g]    ^9ŀVI\ R \   ^\ + \ ⪴\ H\ I> \ =\ j 3\ W\ s \ ;m Ou^   |$  \ 4\  \  <  ̪ ؍􁚴 \   J\ n \ I\ @N\  \n\ \ 1ƣ\ ߮Fr6    \ hų HX \ \r  xn>\ZwQl\ kt ŵ\ryzӑ v\ 8   Xu\ }  *&  cJ  pq߂j 	\ mD  y縙 7$ 
\ \ \n \ \'* \ U,Py \ ,\ (  -  #\ +a!Ln \"\0+8\ \ nª
[ dlx      
\ js\  \r u j  \ \ \ T_\ \ Dzg.\  ʇ ?\ X  9\ =ʿ ^\n  `4 \"k Q \ \\\"\ &7:  \ \ 
 \ g,ч=\Z\  \ <v0 \ Y\ \ \  Xcoj \ h \ \ YL ? \\ Ϥ  v- X  
Mӹ\  QYo4 72Vr\ w.\ \ \ m\ . \ 鎝A[:  Hla[B \r\ < \    \nź\  J\  \ 	\'1\  \ c \ w> 5 Uܜ x  u eT ؑ\ 	\ |s^~L l   ,  !X` \ \ Ӡ\ \ R.  %  3  \ V\0\ \0\  \ \ 54K, \   )=\ \ ucO\ 6  ݶ499\ =z \ idr \ \ C~\ 9 S 1P3     \ c~ c !\ {q m\   ;\  \ y /ez r r   \ 3 \0\ eBzy #\ T  ad ;  \ m  ΄= / \ \ ͏W[ rp@ \ \ \ T \" \ %\ q     W Q } {P D \ z \ \ 4 gMZ@bv\ B  \ \ UT\r0 p W ؞ l3  N #;\ qK D \ \ h\ `o  cݦ (     \ 7= \ \ 6 e%9*Oh  #\ 4\ 1  \  n
 E\ 5 +\ 5[Jj eNn&F>\  ?X  \nB<    yTs*#;\rA F  \ \ \    \r.H  \ a \  \    6Ǔu  \0˖׎ g \ L d/l, u-  ~5\ \ \rY [y : B\0Au.vZ   mk *V I       #\ N \\ \ y:]  \\   \ @\ Q# \ {MN-_ Eg%  \ o#   \ T \  	R 2 }]  t    j /N IV \ u i   중 t\\cq\ ) = \ I 8\ X\ D  H EX!yJ  -\  \ \ \ YZ\ ʭ\ kA \ \ 8=HمvQ  \\\ <O eY\ #= bqQ7 \ :S \ \ \\0\ ֓\ 6\ r3 t% \  S K\ \\N\ \ 76x @   =\ b{ϻ\ \Z\ \ ; ȵ c y   (\ | s o\ s  5b8e ) e\ 	 Y\  #  N]\ \ %\ \ \ \ \r<ұ 9w${   \ = [ \ H=  (Ǔ, E  ĒxcD! ;<   V\  6N;# \ \ + M    \ H\ 8\ <H#\ H$  1      oW\ N^T\0 PE ptsd=2CJ\  Q sHHy\ T\ \ UĞ\ \ Ow~N L  @:I h b \ \ \    V \ \ #	4 \ v B \ au7\ ~T73B7@\ }\ d\ d% `5 89?\ ҥ5\ dߑu\ Y]\ X 8  D    .  ՟ t&B\ <݊\ {GBeo ^)\ j  68\  U ڕ:\ p0>5Noi H\ Rd\  z\ \  
 6\ \ \n}  \\ $u ʉ zc \0  JvKtHH \ \   ,z \ Z .\ g8y  q  :\ i %1̀ c \0l3\ B  \ p6\ ;L˄u  \01 4H\ r3 V I.\r EHM $d \ h\  N  8#~ w\ ) z`\ zzƤ\  G `\ Nm \'6\ s \ \ \ 4\ R{_ \ \   ~tZ   u\ \ R  `  \ <= N  \0b\\\ VZM\ d#Sd* \ I,\  \ o, F \ Ϻ \ \ 0um\ \ c\nkxcl  \ d \ 2\ 7  cc    \  i   \ L\ ? y\  \0 z 1\ !\ \"\"v }ϸUe \ |SD \ \ v#-b, ͧ|\ N\ >{   moH\"  a n#E b{\ ~   F.Y\  \ nak \ \ \ \ K a+ \ N\ *$\ \ K  E \ ɑ\ # #ps W\Zq \ q     N\  \ l\ \ &\ 2%;|| \     s   A \  _j S \ Wq \rD  ߿\ \ rHA\  1  9\ )F\ \ Ϊ  \ ۩\ \ \ h My k\ \n \ asem!`h\ K*	 : \ . \ \ QQ\\M;I\ y\ `\rlN0 쾨\ ܴ WNV\ R\    Nڃ ǒ   Ԫ ddV`@OBs&rw \  0 W#2] *\ \07P\ m\ \  vv F,N ( = 5\ \ R H tc>\ \  \\\ \ ӵX  \"\ \ >  * \ ʻ \   \ \' !8ߺ \ 3d.N\ngϴ\ZT }\Z \ A\ \ S9 8H 051  T  \0  n@\ g `$  \ \ Bv J     < Nq  v J ( : \ ! ӁG du덩R } | @\ = \ W   \ z\0q \ 1go *U    d 
 \ .n\ x\ %Uv< \ i$ \ k    A 2yg
  t   Vڞ\ \ \0~k0Ɍ+ \  	 :F \ \  c* \ NN \\   ˪ x \ E    ρ\ إJ  \0訡   $ o 4P\ \ \ ;   \ ޤ\ZT TW  \ ');
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



-- Dump completed on 2025-05-17 17:53:23
