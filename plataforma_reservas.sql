SET SQL_SAFE_UPDATES = 0;

-- Eliminar esquema existente si existe
DROP SCHEMA IF EXISTS `plataforma_reservas`;
CREATE SCHEMA `plataforma_reservas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `plataforma_reservas`;

-- ------------------------------
-- Tabla: Roles
-- ------------------------------
CREATE TABLE `rol` (
  `idrol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` TEXT,
  `nivel_acceso` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idrol`)
);

-- ------------------------------
-- Tabla: Estados
-- ------------------------------
CREATE TABLE `estado` (
  `idestado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` TEXT,
  `tipo_aplicacion` ENUM('reserva', 'servicio', 'incidencia', 'pago', 'reembolso', 'taller', 'usuario') NOT NULL,
  PRIMARY KEY (`idestado`)
);

-- ------------------------------
-- Tabla: Tipos de Servicios
-- ------------------------------
CREATE TABLE `tipo_servicio` (
  `idtipo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idtipo`)
);

-- ------------------------------
-- Tabla: Sedes
-- ------------------------------
CREATE TABLE `sede` (
  `idsede` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255),
  `distrito` VARCHAR(100),
  `referencia` TEXT,
  `latitud` DECIMAL(10,8),
  `longitud` DECIMAL(11,8),
  PRIMARY KEY (`idsede`)
);

-- ------------------------------
-- Tabla: Tarifas
-- ------------------------------
CREATE TABLE `tarifa` (
  `idtarifa` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(255),
  `monto` DECIMAL(10,2),
  `fecha_actualizacion` DATE DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`idtarifa`)
);

-- ------------------------------
-- Tabla: Usuarios
-- ------------------------------
CREATE TABLE `usuario` (
  `idusuario` INT NOT NULL AUTO_INCREMENT,
  `dni` VARCHAR(8) NOT NULL UNIQUE,
  `nombres` VARCHAR(100) NOT NULL,
  `apellidos` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(20),
  `direccion` VARCHAR(255),
  `idrol` INT NOT NULL,
  `estado` ENUM('activo', 'inactivo') DEFAULT 'activo',
  `notificar_recordatorio` BOOLEAN DEFAULT TRUE,
  `notificar_disponibilidad` BOOLEAN DEFAULT TRUE,
  `create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idusuario`),
  FOREIGN KEY (`idrol`) REFERENCES `rol`(`idrol`)
);

-- ------------------------------
-- Tabla: Validación de Usuarios
-- ------------------------------
CREATE TABLE `validacion_usuario` (
  `idvalidacion` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `codigo_validacion` VARCHAR(100),
  `password_temporal` VARCHAR(100),
  `fecha_expiracion` DATETIME,
  `estado` ENUM('pendiente', 'aceptado', 'rechazado') DEFAULT 'pendiente',
  PRIMARY KEY (`idvalidacion`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Servicios
-- ------------------------------
CREATE TABLE `servicio` (
  `idservicio` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `idtipo` INT NOT NULL,
  `idestado` INT NOT NULL,
  `contacto_soporte` VARCHAR(100),
  `horario_inicio` TIME,
  `horario_fin` TIME,
  PRIMARY KEY (`idservicio`),
  FOREIGN KEY (`idtipo`) REFERENCES `tipo_servicio`(`idtipo`),
  FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`)
);

-- ------------------------------
-- Tabla: Sede_Servicio (relación muchos a muchos)
-- ------------------------------
CREATE TABLE `sede_servicio` (
  `idsede_servicio` INT NOT NULL AUTO_INCREMENT,
  `idsede` INT NOT NULL,
  `idservicio` INT NOT NULL,
  `idtarifa` INT NOT NULL,
  PRIMARY KEY (`idsede_servicio`),
  FOREIGN KEY (`idsede`) REFERENCES `sede`(`idsede`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`),
  FOREIGN KEY (`idtarifa`) REFERENCES `tarifa`(`idtarifa`)
);

-- ------------------------------
-- Tabla: Media por Servicio
-- ------------------------------
CREATE TABLE `media_servicio` (
  `idmedia` INT NOT NULL AUTO_INCREMENT,
  `idservicio` INT NOT NULL,
  `tipo` ENUM('imagen', 'video') NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idmedia`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`)
);
-- ------------------------------
-- Tabla PAGO (ahora puede referenciar a reserva)
-- ------------------------------

CREATE TABLE `pago` (
  `idpago` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `monto` DECIMAL(10,2),
  `metodo` ENUM('online', 'banco') NOT NULL,
  `comprobante` LONGBLOB,
  `idestado` INT NOT NULL,
  `fecha_pago` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idpago`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`),
  FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`)
);

CREATE TABLE horario_disponible (
  idhorario INT NOT NULL AUTO_INCREMENT,
  idsede_servicio INT NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (idhorario),
  FOREIGN KEY (idsede_servicio) REFERENCES sede_servicio(idsede_servicio)
);

CREATE TABLE horario_atencion (
  idhorario_atencion INT AUTO_INCREMENT PRIMARY KEY,
  idsede_servicio INT NOT NULL,
  dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (idsede_servicio) REFERENCES sede_servicio(idsede_servicio)
);


-- ------------------------------
CREATE TABLE reserva (
  idreserva INT AUTO_INCREMENT PRIMARY KEY,
  idusuario INT NOT NULL,
  idsede_servicio INT NOT NULL,
  fecha_reserva DATE NOT NULL,
  idhorario INT NOT NULL,
  idestado INT NOT NULL,
  idpago INT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_limite_pago DATETIME,
  FOREIGN KEY (idusuario) REFERENCES usuario(idusuario),
  FOREIGN KEY (idsede_servicio) REFERENCES sede_servicio(idsede_servicio),
  FOREIGN KEY (idhorario) REFERENCES horario_disponible(idhorario),
  FOREIGN KEY (idestado) REFERENCES estado(idestado),
  FOREIGN KEY (idpago) REFERENCES pago(idpago)
);


-- ------------------------------


-- ------------------------------
-- Tabla: Reembolsos
-- ------------------------------
CREATE TABLE `reembolso` (
  `idreembolso` INT NOT NULL AUTO_INCREMENT,
  `idreserva` INT NOT NULL,
  `monto` DECIMAL(10,2),
  `fecha_solicitud` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `idestado` INT NOT NULL,
  PRIMARY KEY (`idreembolso`),
  FOREIGN KEY (`idreserva`) REFERENCES `reserva`(`idreserva`),
  FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`)
);

-- ------------------------------
-- Tabla: Talleres
-- ------------------------------
CREATE TABLE `taller` (
  `idtaller` INT NOT NULL AUTO_INCREMENT,
  `idservicio` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `cupos_maximos` INT NOT NULL,
  `instructor` VARCHAR(100),
  `idestado` INT NOT NULL,
  PRIMARY KEY (`idtaller`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`),
  FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`)
);

-- ------------------------------
-- Tabla: Inscripciones a Talleres
-- ------------------------------
CREATE TABLE `taller_inscripcion` (
  `idinscripcion` INT NOT NULL AUTO_INCREMENT,
  `idtaller` INT NOT NULL,
  `idusuario` INT NOT NULL,
  `fecha_inscripcion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idinscripcion`),
  FOREIGN KEY (`idtaller`) REFERENCES `taller`(`idtaller`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Asistencia
-- ------------------------------
CREATE TABLE `asistencia` (
  `idasistencia` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `hora_entrada` TIME,
  `hora_salida` TIME,
  `latitud` DECIMAL(10,8),
  `longitud` DECIMAL(11,8),
  `observaciones` TEXT,
  PRIMARY KEY (`idasistencia`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Notificaciones
-- ------------------------------
CREATE TABLE `notificacion` (
  `idnotificacion` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `titulo` VARCHAR(255),
  `mensaje` TEXT,
  `leido` BOOLEAN DEFAULT FALSE,
  `fecha_envio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idnotificacion`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Logs / Auditoría
-- ------------------------------
CREATE TABLE `log` (
  `idlog` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT,
  `accion` VARCHAR(255),
  `tabla_afectada` VARCHAR(100),
  `valor_anterior` TEXT,
  `valor_nuevo` TEXT,
  `fecha` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idlog`)
);

-- ------------------------------
-- Tabla: Reportes Generados
-- ------------------------------
CREATE TABLE `reporte` (
  `idreporte` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `tipo` ENUM('PDF', 'Excel') NOT NULL,
  `filtro_aplicado` TEXT,
  `ruta_archivo` VARCHAR(255),
  `fecha_generacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idreporte`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Historial de Perfil
-- ------------------------------
CREATE TABLE `historial_perfil` (
  `idhistorial` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `campo_modificado` VARCHAR(100),
  `valor_anterior` TEXT,
  `valor_nuevo` TEXT,
  `fecha_modificacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idhistorial`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Solicitudes de Eliminación
-- ------------------------------
CREATE TABLE `solicitud_eliminacion` (
  `idsolicitud` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `fecha_solicitud` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `confirmado` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`idsolicitud`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- ------------------------------
-- Tabla: Chatbot Log
-- ------------------------------
CREATE TABLE `chatbot_log` (
  `idchatbot` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `pregunta` TEXT NOT NULL,
  `respuesta` TEXT NOT NULL,
  `fecha` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idchatbot`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);




-- ------------------------------
-- Índices para optimización
-- ------------------------------
CREATE INDEX `idx_usuario_reserva` ON `reserva`(`idusuario`);
CREATE INDEX `idx_reserva_sede_servicio` ON `reserva`(`idsede_servicio`);

CREATE INDEX `idx_estado_tipo` ON `estado`(`tipo_aplicacion`);
CREATE INDEX `idx_usuario_email` ON `usuario`(`email`);
CREATE INDEX `idx_usuario_dni` ON `usuario`(`dni`);
CREATE INDEX `idx_sede_servicio` ON `sede_servicio`(`idsede`, `idservicio`);
CREATE INDEX `idx_pago_idusuario` ON `pago`(`idusuario`);
CREATE INDEX `idx_pago_estado` ON `pago`(`idestado`);

CREATE INDEX `idx_reserva_fecha_limite` ON `reserva`(`fecha_limite_pago`);

-- ------------------------------
-- Insertar datos iniciales
-- ------------------------------



-- Roles
INSERT INTO `rol` (`nombre`, `descripcion`, `nivel_acceso`) VALUES
('Superadmin', 'Acceso completo a toda la plataforma', 3),
('Administrador', 'Gestiona usuarios, reservas y servicios', 2),
('Coordinador', 'Asiste en campo, marca asistencia y reporta incidencias', 2),
('Vecino', 'Usuario final que reserva servicios', 1);

-- Estados
-- Estados para RESERVA (simplificado)
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('pendiente', 'Reserva pendiente de validación', 'reserva'),
('aprobada', 'Reserva aprobada por el administrador', 'reserva'),
('rechazada', 'Reserva rechazada por el administrador', 'reserva');

-- Estados para SERVICIO
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('disponible', 'Servicio disponible para reservas', 'servicio'),
('reservado', 'Servicio reservado por un vecino en este horario', 'servicio'),
('en_mantenimiento', 'Servicio inhabilitado temporalmente por mantenimiento', 'servicio'),
('bloqueado', 'Bloqueo especial por evento o actividad programada', 'servicio'),
('inactivo', 'Servicio fuera de operación de forma indefinida', 'servicio');

-- Estados para INCIDENCIA
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('reportado', 'Incidencia registrada por un coordinador', 'incidencia'),
('en_progreso', 'Acción en curso para resolver la incidencia', 'incidencia'),
('solucionado', 'Incidencia resuelta satisfactoriamente', 'incidencia'),
('no_corresponde', 'Incidencia invalidada tras revisión', 'incidencia'),
('crítico', 'Incidencia urgente con prioridad alta', 'incidencia');

-- Estados para PAGO
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('pendiente', 'Pago pendiente de validación', 'pago'),
('confirmado', 'Pago validado y confirmado', 'pago'),
('rechazado', 'Pago rechazado por el administrador', 'pago'),
('reembolsado', 'Monto devuelto al usuario', 'pago'),
('no_pagado', 'Reserva sin pago registrado', 'pago');

-- Tipos de Servicio
INSERT INTO `tipo_servicio` (`nombre`) VALUES
('Piscina'),
('Gimnasio'),
('Cancha de Fútbol'),
('Cancha de Vóley'),
('Salón de Eventos'),
('Taller');

-- Sedes
INSERT INTO `sede` (`nombre`, `direccion`, `distrito`, `referencia`, `latitud`, `longitud`) VALUES
('Complejo Deportivo Maranga', 'Av. La Marina 1350', 'San Miguel', 'Frente a la Universidad San Marcos', -12.079500, -77.087300),
('Polideportivo San Miguel', 'Av. Costanera 1535', 'San Miguel', 'Cerca al Parque de las Leyendas', -12.075800, -77.090200),
('Centro Cultural San Miguel', 'Av. Federico Gallese 750', 'San Miguel', 'Junto a la Municipalidad', -12.077400, -77.084000);

-- Tarifas
INSERT INTO `tarifa` (`descripcion`, `monto`, `fecha_actualizacion`) VALUES
('Tarifa estándar piscina', 15.00, '2025-05-08'),
('Tarifa gimnasio mañana', 10.00, '2025-05-08'),
('Tarifa cancha fútbol', 50.00, '2025-05-08'),
('Tarifa cancha vóley', 25.00, '2025-05-08'),
('Tarifa evento social', 100.00, '2025-05-08'),
('Tarifa taller', 60.00, '2025-05-08');

-- Servicios
INSERT INTO `servicio` (`nombre`, `descripcion`, `idtipo`, `idestado`, `contacto_soporte`, `horario_inicio`, `horario_fin`) VALUES
('Piscina Principal', 'Piscina olímpica con 6 carriles', 1, 
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '08:00:00', '18:00:00'),

('Gimnasio Municipal', 'Gimnasio equipado con máquinas de última generación', 2,
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '06:00:00', '22:00:00'),

('Cancha Fútbol 1', 'Cancha de fútbol 7 con césped sintético', 3,
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '07:00:00', '21:00:00'),

('Cancha Vóley', 'Cancha reglamentaria para vóley', 4,
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '08:00:00', '18:00:00'),

('Salón de Eventos', 'Salón para reuniones o eventos sociales', 5,
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '10:00:00', '22:00:00'),

('Taller Artesanal', 'Espacio para talleres municipales', 6,
 (SELECT `idestado` FROM `estado` WHERE `nombre` = 'disponible' AND `tipo_aplicacion` = 'servicio'),
 '987654321', '09:00:00', '13:00:00');

-- Asociaciones Sede-Servicio-Tarifa
INSERT INTO `sede_servicio` (`idsede`, `idservicio`, `idtarifa`) VALUES
(1, 1, 1), -- Piscina en Complejo Deportivo Maranga
(2, 2, 2), -- Gimnasio en Polideportivo San Miguel
(1, 3, 3), -- Cancha Fútbol en Complejo Deportivo Maranga
(1, 4, 4), -- Cancha Vóley en Complejo Deportivo Maranga
(3, 5, 5), -- Salón Eventos en Centro Cultural
(3, 6, 6); -- Taller Artesanal en Centro Cultural

-- Usuarios
INSERT INTO `usuario` (`dni`, `nombres`, `apellidos`, `email`, `password_hash`, `telefono`, `direccion`, `idrol`, `estado`) VALUES
('87654321', 'Admin', 'San Miguel', 'admin@sanmiguel.gob.pe', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/rH8L.SK8Wp8YKHnV6Qjp1JYjXrq', '987654321', 'Av. La Marina 123', 1, 'activo'),
('75234109', 'Sofía', 'Delgado', 'sdelgado@sanmiguel.gob.pe', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/rH8L.SK8Wp8YKHnV6Qjp1JYjXrq', '987654322', 'Av. Costanera 456', 2, 'activo'),
('12345678', 'Luis', 'Fernández', 'lfernandez@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/rH8L.SK8Wp8YKHnV6Qjp1JYjXrq', '987654323', 'Calle Los Cedros 102', 4, 'activo'),
('23456789', 'Carla', 'Mendoza', 'carla.mendoza@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/rH8L.SK8Wp8YKHnV6Qjp1JYjXrq', '987654324', 'Pasaje 3 Mz. B Lt. 4', 4, 'activo');

-- Media de Servicios
INSERT INTO `media_servicio` (`idservicio`, `tipo`, `url`) VALUES
(1, 'imagen', 'https://ejemplo.com/piscina1.jpg'),
(1, 'imagen', 'https://ejemplo.com/piscina2.jpg'),
(2, 'imagen', 'https://ejemplo.com/gimnasio1.jpg'),
(3, 'imagen', 'https://ejemplo.com/cancha-futbol1.jpg'),
(4, 'imagen', 'https://ejemplo.com/cancha-voley1.jpg'),
(5, 'imagen', 'https://ejemplo.com/salon-eventos1.jpg'),
(6, 'imagen', 'https://ejemplo.com/taller-artesanal1.jpg');

-- Talleres (estado: 'activo' = idestado: 18)
INSERT INTO `taller` (`idservicio`, `nombre`, `descripcion`, `fecha_inicio`, `fecha_fin`, `hora_inicio`, `hora_fin`, `cupos_maximos`, `instructor`, `idestado`) VALUES
(6, 'Taller de Cerámica', 'Aprende técnicas básicas de cerámica', '2025-06-01', '2025-06-30', '10:00:00', '12:00:00', 15, 'Prof. Ana Sánchez', 18),
(6, 'Taller de Pintura', 'Introducción a la pintura al óleo', '2025-06-15', '2025-07-15', '15:00:00', '17:00:00', 12, 'Prof. Carlos López', 18);

-- Inscripciones a Talleres
INSERT INTO `taller_inscripcion` (`idtaller`, `idusuario`, `fecha_inscripcion`) VALUES
(1, 3, NOW()),
(1, 4, NOW()),
(2, 3, NOW());

-- Pagos de ejemplo (estado: 'confirmado' = 22, 'pendiente' = 21)
INSERT INTO `pago` (`idusuario`, `monto`, `metodo`, `comprobante`, `idestado`) VALUES
(3, 60.00, 'online', NULL, 
 (SELECT idestado FROM estado WHERE nombre = 'confirmado' AND tipo_aplicacion = 'pago')),
(4, 50.00, 'banco', NULL,
 (SELECT idestado FROM estado WHERE nombre = 'pendiente' AND tipo_aplicacion = 'pago'));

INSERT INTO horario_atencion (idsede_servicio, dia_semana, hora_inicio, hora_fin)
VALUES
(1, 'Lunes', '08:00:00', '20:00:00'),
(1, 'Martes', '08:00:00', '20:00:00'),
(1, 'Miércoles', '08:00:00', '20:00:00'),
(1, 'Jueves', '08:00:00', '20:00:00'),
(1, 'Viernes', '08:00:00', '20:00:00'),
(1, 'Sábado', '08:00:00', '15:00:00'),
(1, 'Domingo', '00:00:00', '00:00:00'); -- para deshabilitar


INSERT INTO horario_disponible (idsede_servicio, hora_inicio, hora_fin)
VALUES
  (1, '08:00:00', '09:00:00'),
  (1, '09:00:00', '10:00:00'),
  (1, '10:00:00', '11:00:00'),
  (2, '08:00:00', '09:00:00');

-- Luego insert de reservas referenciando `idsede_servicio` y `idpago` ya existentes
INSERT INTO reserva (idusuario, idsede_servicio, fecha_reserva, idhorario, idestado, idpago, fecha_limite_pago)
VALUES
(3, 1, '2025-06-10', 1,  -- 08:00-09:00
 (SELECT idestado FROM estado WHERE nombre = 'aprobada' AND tipo_aplicacion = 'reserva'),
 1, DATE_ADD(NOW(), INTERVAL 4 HOUR)),

(4, 2, '2025-06-15', 4,  -- 08:00-09:00 en otro servicio
 (SELECT idestado FROM estado WHERE nombre = 'pendiente' AND tipo_aplicacion = 'reserva'),
 2, DATE_ADD(NOW(), INTERVAL 4 HOUR));
-- Finalmente, si lo deseas, puedes hacer update del campo `idreserva` en `pago` para cerrar la relación inversa:
UPDATE `reserva` SET idpago = 1 WHERE idreserva = 1;

UPDATE `reserva` SET idpago = 2 WHERE idreserva = 2;


