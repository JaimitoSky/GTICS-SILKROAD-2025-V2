DROP SCHEMA IF EXISTS `plataforma_reservas`;
CREATE SCHEMA `plataforma_reservas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `plataforma_reservas`;

-- ------------------------------
-- Tabla: Roles
-- ------------------------------
CREATE TABLE `rol` (
  `idrol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL, -- Superadmin, Administrador, Coordinador, Vecino
  `descripcion` TEXT,  -- Descripción del rol
  `nivel_acceso` INT NOT NULL DEFAULT 1,  -- Nivel de acceso para el rol
  PRIMARY KEY (`idrol`)
);

-- ------------------------------

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
  `password_salt` VARCHAR(255) NOT NULL,
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
-- Tabla: Tipos de Servicios
-- ------------------------------
CREATE TABLE `tipo_servicio` (
  `idtipo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL, -- piscina, gimnasio, etc.
  PRIMARY KEY (`idtipo`)
);

-- ------------------------------
-- Tabla: Servicios (canchas, piscina, etc.)
-- ------------------------------
CREATE TABLE `servicio` (
  `idservicio` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `idtipo` INT NOT NULL,
  `ubicacion` VARCHAR(255),
  `estado` ENUM('activo', 'mantenimiento', 'inactivo') DEFAULT 'activo',
  `contacto_soporte` VARCHAR(100),
  `horario_inicio` TIME,  -- Horario de inicio del servicio
  `horario_fin` TIME,     -- Horario de fin del servicio
  PRIMARY KEY (`idservicio`),
  FOREIGN KEY (`idtipo`) REFERENCES `tipo_servicio`(`idtipo`)
);

-- ------------------------------
-- Tabla: Media por Servicio (imágenes/videos)
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
-- Tabla: Reservas
-- ------------------------------
CREATE TABLE `reserva` (
  `idreserva` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `idservicio` INT NOT NULL,
  `fecha_reserva` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `estado` ENUM('pendiente', 'aprobada', 'cancelada', 'rechazada', 'pagada', 'pendiente_pago', 'aprobada_pago') DEFAULT 'pendiente',
  `metodo_pago` ENUM('online', 'banco') DEFAULT 'banco',
  `comprobante_pago` VARCHAR(255),
  `fecha_pago` TIMESTAMP,  -- Fecha del pago
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idreserva`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`)
);

-- ------------------------------
-- Tabla: Asistencia (para Coordinadores)
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
  `valor_anterior` TEXT,  -- Valor anterior en la acción
  `valor_nuevo` TEXT,     -- Valor nuevo en la acción
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
-- Tabla: Historial de cambios en perfil
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
-- Tabla: Solicitudes de eliminación de cuenta
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
-- Tabla: Gestión de Roles y Permisos (subroles de administradores)
-- ------------------------------
CREATE TABLE `subrol` (
  `idsubrol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL, -- Ejemplo: Gestor de Reservas
  `descripcion` TEXT,
  PRIMARY KEY (`idsubrol`)
);

CREATE TABLE `subrol_permiso` (
  `idsubrol` INT NOT NULL,
  `idpermiso` INT NOT NULL,
  PRIMARY KEY (`idsubrol`, `idpermiso`),
  FOREIGN KEY (`idsubrol`) REFERENCES `subrol`(`idsubrol`)
);

-- ------------------------------
-- Tabla: Gestión de Tarifas y Promociones
-- ------------------------------
CREATE TABLE `tarifa` (
  `idtarifa` INT NOT NULL AUTO_INCREMENT,
  `idservicio` INT NOT NULL,
  `descripcion` TEXT,
  `monto` DECIMAL(10,2),
  `dia_semana` ENUM('lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'),
  `hora_inicio` TIME,
  `hora_fin` TIME,
  PRIMARY KEY (`idtarifa`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`)
);

CREATE TABLE `promocion` (
  `idpromocion` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `descuento` DECIMAL(5,2), 
  `fecha_inicio` DATE,
  `fecha_fin` DATE,
  PRIMARY KEY (`idpromocion`)
);

-- ------------------------------
-- Tabla: Gestión de Reembolsos
-- ------------------------------
CREATE TABLE `reembolso` (
  `idreembolso` INT NOT NULL AUTO_INCREMENT,
  `idreserva` INT NOT NULL,
  `monto` DECIMAL(10,2),
  `fecha_solicitud` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('pendiente', 'aprobado', 'rechazado') DEFAULT 'pendiente',
  PRIMARY KEY (`idreembolso`),
  FOREIGN KEY (`idreserva`) REFERENCES `reserva`(`idreserva`)
);

-- Crear índices en claves foráneas para optimización de consultas
CREATE INDEX idx_usuario ON reserva(idusuario);
CREATE INDEX idx_servicio ON reserva(idservicio);

-- Crear tabla de estados
CREATE TABLE `estado` (
  `idestado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` TEXT,
  `tipo_aplicacion` ENUM('reserva', 'servicio', 'incidencia') NOT NULL,
  PRIMARY KEY (`idestado`)
);

-- ------------------------------
-- Estados para RESERVA
-- ------------------------------
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('pendiente', 'Solicitud enviada por el usuario, en espera de revisión', 'reserva'),
('aprobada', 'Reserva aprobada por el administrador', 'reserva'),
('rechazada', 'Reserva rechazada por el administrador', 'reserva'),
('pagada', 'Pago realizado y reserva confirmada', 'reserva'),
('pendiente_pago', 'Reserva pendiente de pago por el usuario', 'reserva'),
('aprobada_pago', 'Pago validado por el administrador', 'reserva'),
('cancelada', 'Reserva cancelada por el usuario', 'reserva'),
('reembolsada', 'Reserva cancelada con reembolso aprobado', 'reserva'),
('no_show', 'El usuario no se presentó al servicio reservado', 'reserva');

-- ------------------------------
-- Estados para SERVICIO
-- ------------------------------
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('disponible', 'Servicio disponible para reservas', 'servicio'),
('reservado', 'Servicio reservado por un vecino en este horario', 'servicio'),
('en_mantenimiento', 'Servicio inhabilitado temporalmente por mantenimiento', 'servicio'),
('bloqueado', 'Bloqueo especial por evento o actividad programada', 'servicio'),
('inactivo', 'Servicio fuera de operación de forma indefinida', 'servicio');

-- ------------------------------
-- Estados para INCIDENCIA (reportada solo por coordinadores)
-- ------------------------------
INSERT INTO `estado` (`nombre`, `descripcion`, `tipo_aplicacion`) VALUES
('reportado', 'Incidencia registrada por un coordinador', 'incidencia'),
('revisando', 'Administrador está evaluando la incidencia', 'incidencia'),
('en_progreso', 'Acción en curso para resolver la incidencia', 'incidencia'),
('solucionado', 'Incidencia resuelta satisfactoriamente', 'incidencia'),
('no_corresponde', 'Incidencia invalidada tras revisión', 'incidencia'),
('duplicado', 'Ya existe un reporte previo con el mismo problema', 'incidencia'),
('crítico', 'Incidencia urgente con prioridad alta', 'incidencia');

-- ALTER TABLE `usuario` DROP FOREIGN KEY `usuario_ibfk_2`; 
-- ALTER TABLE `usuario` DROP COLUMN `iddistrito`;
DROP TABLE IF EXISTS `distrito`; 


CREATE TABLE `taller` (
  `idtaller` INT NOT NULL AUTO_INCREMENT,
  `idservicio` INT NOT NULL, -- piscina, gimnasio, etc.
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `cupos_maximos` INT NOT NULL,
  `instructor` VARCHAR(100),
  `estado` ENUM('activo', 'cancelado', 'finalizado') DEFAULT 'activo',
  PRIMARY KEY (`idtaller`),
  FOREIGN KEY (`idservicio`) REFERENCES `servicio`(`idservicio`)
);

CREATE TABLE `taller_inscripcion` (
  `idinscripcion` INT NOT NULL AUTO_INCREMENT,
  `idtaller` INT NOT NULL,
  `idusuario` INT NOT NULL,
  `fecha_inscripcion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idinscripcion`),
  FOREIGN KEY (`idtaller`) REFERENCES `taller`(`idtaller`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

CREATE TABLE `chatbot_log` (
  `idchatbot` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `pregunta` TEXT NOT NULL,
  `respuesta` TEXT NOT NULL,
  `fecha` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idchatbot`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

-- En reserva
ALTER TABLE `reserva` DROP COLUMN `estado`;
ALTER TABLE `reserva` ADD COLUMN `idestado` INT;
ALTER TABLE `reserva` ADD FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`);

-- En servicio
ALTER TABLE `servicio` DROP COLUMN `estado`;
ALTER TABLE `servicio` ADD COLUMN `idestado` INT;
ALTER TABLE `servicio` ADD FOREIGN KEY (`idestado`) REFERENCES `estado`(`idestado`);

ALTER TABLE `reserva` MODIFY `comprobante_pago` LONGBLOB;

DROP TABLE IF EXISTS `promocion`;

CREATE TABLE `pago` (
  `idpago` INT NOT NULL AUTO_INCREMENT,
  `idusuario` INT NOT NULL,
  `monto` DECIMAL(10,2),
  `metodo` ENUM('online', 'banco') NOT NULL,
  `comprobante` LONGBLOB,
  `estado` ENUM('pendiente', 'validado', 'rechazado') DEFAULT 'pendiente',
  `fecha_pago` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idpago`),
  FOREIGN KEY (`idusuario`) REFERENCES `usuario`(`idusuario`)
);

ALTER TABLE `reserva` DROP COLUMN `comprobante_pago`;
ALTER TABLE `reserva` DROP COLUMN `metodo_pago`;
ALTER TABLE `reserva` DROP COLUMN `fecha_pago`;
ALTER TABLE `reserva` ADD COLUMN `idpago` INT;
ALTER TABLE `reserva` ADD FOREIGN KEY (`idpago`) REFERENCES `pago`(`idpago`);

CREATE INDEX idx_estado_tipo ON estado(tipo_aplicacion);

-- Considerando que un coordinador puede registrarse como vecino aparte, solo se duplica dni, mas no correo
-- ALTER TABLE `usuario` DROP INDEX `dni`;

-- Opcional: para búsquedas eficientes por DNI
-- CREATE INDEX idx_dni ON usuario(dni); 
INSERT INTO rol (nombre, descripcion, nivel_acceso) VALUES
('Superadmin', 'Acceso completo a toda la plataforma', 3),
('Administrador', 'Gestiona usuarios, reservas y servicios', 2),
('Coordinador', 'Asiste en campo, marca asistencia y reporta incidencias', 2),
('Vecino', 'Usuario final que reserva servicios', 1);
INSERT INTO usuario (dni, nombres, apellidos, email, password_hash, password_salt, telefono, direccion, idrol, estado)
VALUES 
('12345678', 'Juan', 'Pérez', 'juan.perez@gmail.com', 'hash123', 'salt123', '987654321', 'Av. Los Álamos 123', 1, 'activo'),
('87654321', 'Ana', 'Ramírez', 'ana.ramirez@gmail.com', 'hash456', 'salt456', '912345678', 'Calle Lima 456', 2, 'activo'),
('45671238', 'Luis', 'Torres', 'luis.torres@sanmiguel.gob.pe', 'hash789', 'salt789', '945678123', 'Jr. Puno 234', 3, 'activo'),
('23456789', 'Carla', 'Mendoza', 'carla.mendoza@gmail.com', 'hashabc', 'saltabc', '955112233', 'Av. Brasil 999', 4, 'activo'),
('11223344', 'Marco', 'Gómez', 'marco.gomez@gmail.com', 'hashdef', 'saltdef', '987112233', 'Pasaje 3 Mz. B Lt. 4', 4, 'activo');
