CREATE DATABASE IF NOT EXISTS `tarea5`;

USE `tarea5`;

CREATE TABLE IF NOT EXISTS `Persona` (
  `dni`       int          NOT NULL,
  `nombre`    varchar(100) NOT NULL,
  `celular`   varchar(100) NOT NULL,
  `matricula` varchar(100) NULL,
  `fechaNac`  date         NULL,
  PRIMARY KEY (`dni`)
) DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `DirE` (
  `dni`       int          NOT NULL,
  `dirE`      varchar(100) NOT NULL,
  PRIMARY KEY (`dni`, `dirE`),
  CONSTRAINT `PersonaDirE` FOREIGN KEY (`dni`) REFERENCES `Persona` (`dni`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Domicilio` (
  `dni`          int          NOT NULL,
  `calle`        varchar(100) NOT NULL,
  `altura`       int          NOT NULL,
  `piso`         varchar(100) NULL,
  `departamento` varchar(1)   NULL,
  `localidad`    varchar(100) NOT NULL,
  `tel`          varchar(50)  NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `PersonaDomicilio` FOREIGN KEY (`dni`) REFERENCES `Persona` (`dni`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Servicio` (
  `idServ` int          NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,  
  PRIMARY KEY (`idServ`)
) DEFAULT CHARSET=latin1;

ALTER TABLE Servicio ADD UNIQUE KEY `nombre_ck` (`nombre`);


CREATE TABLE IF NOT EXISTS `Atencion` (
  `idAt`          int NOT NULL AUTO_INCREMENT,
  `idServ`        int NOT NULL,
  `dniMed`        int NOT NULL,  
  `duracionTurno` time NOT NULL,
  PRIMARY KEY (`idAt`),
  CONSTRAINT `AtencionServicio` FOREIGN KEY (`idServ`) REFERENCES `Servicio` (`idServ`) ON UPDATE CASCADE,
  CONSTRAINT `AtencionMedico` FOREIGN KEY (`dniMed`) REFERENCES `Persona` (`dni`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;

ALTER TABLE Atencion ADD UNIQUE KEY `servicio_dni_ck` (`idServ`, `dniMed`);


CREATE TABLE IF NOT EXISTS `Excepcion` (
  `dni`           int  NOT NULL,
  `fechaDesde`    date NOT NULL,
  `fechaHasta`    date NOT NULL,
  `horaDesde`     time NULL,  
  `horaHasta`     time NULL,
  PRIMARY KEY (`dni`, `fechaDesde`),
  CONSTRAINT `Excepcion_fk` FOREIGN KEY (`dni`) REFERENCES `Persona` (`dni`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS `HorarioAtencion` (
  `idHorario`     	int  NOT NULL AUTO_INCREMENT,
  `idAt`    		int  NOT NULL,
  `horaDesde`		time NOT NULL,
  `horaHasta`		time NOT NULL,
  PRIMARY KEY (`idHorario`),
  CONSTRAINT `HorarioAtencion_fk` FOREIGN KEY (`idAt`) REFERENCES `Atencion` (`idAt`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;



ALTER TABLE HorarioAtencion ADD UNIQUE KEY `horario_idAt_ck` (`idAt`, `horaDesde`, `horaHasta`);

CREATE TABLE IF NOT EXISTS `DiaHorario` (
  `idHorario`     	int  NOT NULL,
  `diaSemana`    	int  NOT NULL,
  PRIMARY KEY (`idHorario`,`diaSemana`),
  CONSTRAINT `Dia_HorarioAtencion_fk` FOREIGN KEY (`idHorario`) REFERENCES `HorarioAtencion` (`idHorario`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `Turno` (
  `idAt`          	int  NOT NULL,
  `fecha`    		date NOT NULL,
  `hora`    		time NOT NULL,
  `dniPac`			int NULL,
  PRIMARY KEY (`idAt`, `fecha`, `hora`),
  CONSTRAINT `Turno_Atencion_fk` FOREIGN KEY (`idAt`) REFERENCES `Atencion` (`idAt`) ON UPDATE CASCADE,
  CONSTRAINT `Turno_Persona_fk` FOREIGN KEY (`dniPac`) REFERENCES `Persona` (`dni`) ON UPDATE CASCADE
) DEFAULT CHARSET=latin1;


