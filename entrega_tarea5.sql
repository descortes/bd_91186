-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.13 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/* Borro la BD si ya existía */
drop database if exists `tarea5`;

-- --------------------------------------------------------
-- Creación de la nueva BD.
-- --------------------------------------------------------

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

-- --------------------------------------------------------
-- Datos de prueba del algoritmo.
-- --------------------------------------------------------

INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (33537549, 'Dr. Adrián Gabriel Cavaiuolo', '1123167897', '91186', '1981-11-04');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (35572166, 'Dr. Mauro Oscar Cortés',       '1155698746', '92436', '1989-03-16');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (34411264, 'Dr. Alberto Zárate',           '1147552145', '92436', '1984-06-21');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (13537549, 'Trenton Snook',                '2223261897', null, '1981-01-02');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (22537549, 'Johnathon Delawder',           '3323365897', null, '1982-01-13');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (12337549, 'Art Talkington',               '4425563897', null, '1983-02-25');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (31237549, 'Kasey Trostle',                '5503564897', null, '1984-03-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (13123549, 'Eleonor Parrino',              '6621665897', null, '1985-04-16');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (41512549, 'Sally Brakebill',              '7721297486', null, '1986-05-22');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (04131259, 'Burton Stillson',              '8822837156', null, '1987-06-08');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (30417127, 'Lena Tillery',                 '9923997123', null, '1988-07-19');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (13041512, 'Monroe Italiano',              '0024098970', null, '1989-08-20');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (21504141, 'Janeen Parrott',               '1125089745', null, '1980-09-01');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (32130419, 'Crystal Orlando',              '2121689745', null, '1971-10-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (13217044, 'Delbert Alexandra',            '3122789745', null, '1972-11-17');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (24321509, 'Freddie Mericle',              '4123889745', null, '1973-12-28');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (35432140, 'Adele Fitch',                  '5124989745', null, '1974-01-09');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (16543219, 'Matilde Linker',               '6125089745', null, '1975-02-10');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (27654321, 'Ewa Slayden',                  '7126897989', null, '1976-03-28');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (38765432, 'Ellis Lineberger',             '8127897989', null, '1977-04-08');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (09876543, 'Dong Pai',                     '9128897989', null, '1978-05-18');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (10987654, 'Nenita Wadlow',                '0129897989', null, '1969-06-28');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (21098765, 'Burl Monarrez',                '1120897989', null, '1960-07-08');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (32109876, 'Aurore Gilsdorf',              '2121974546', null, '1968-08-29');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (03210987, 'Bart Nordyke',                 '3122974546', null, '1969-09-09');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (14321098, 'Dick Vanderpool',              '4123456897', null, '1960-10-04');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (25432109, 'Kelle Strzelecki',             '5124568976', null, '1968-11-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (36543210, 'Cornelia Vegas',               '6125568976', null, '2001-12-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (00654321, 'Sandee Arceo',                 '7126568976', null, '2002-01-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (18765432, 'Rich Nass',                    '8127568976', null, '2003-02-25');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (29876543, 'Keitha Streiff',               '9128568976', null, '2004-01-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (30987654, 'Sibyl South',                  '0112956897', null, '2005-02-09');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (02098765, 'Xavier Dumire',                '2120568972', null, '2006-03-05');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (10568976, 'Leatrice Snowball',            '3125687973', null, '2007-04-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (25687987, 'Gwyneth Wesely',               '4125689747', null, '2008-05-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (35689798, 'Lore Chouinard',               '5125689775', null, '2009-06-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (05689709, 'Brain Hoff',                   '6126876676', null, '2000-07-18');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (16876620, 'Spencer Falkowski',            '7126888897', null, '2001-08-08');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (26888812, 'Dion Caplinger',               '8125645897', null, '2002-09-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (35645831, 'Dolores Mayer',                '9125456897', null, '2003-10-04');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (05456843, 'Santina Jeffress',             '0125688767', null, '2004-11-06');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (15688754, 'Broderick Faires',             '1256897346', null, '2005-12-08');
INSERT INTO `tarea5`.`Persona` (`dni`, `nombre`, `celular`, `matricula`, `fechaNac`) VALUES (26897345, 'Alphonse Karim',               '1256895657', null, '2006-03-08');

INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Guardia Diurna');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Guardia Noctura');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Cardiologia');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Estudio Clínico');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Radiología');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Cirugía');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Traumatología');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Odontología');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Oftalmología');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Enfermería');
INSERT INTO `tarea5`.`Servicio` (`nombre`) VALUES ('Pediatría');

-- Atención
INSERT INTO Atencion (idServ, dniMed, duracionTurno) VALUES (3, 33537549, '00:30');
INSERT INTO Atencion (idServ, dniMed, duracionTurno) VALUES (4, 33537549, '01:00');

INSERT INTO Atencion (idServ, dniMed, duracionTurno) VALUES (3, 35572166, '00:25');
INSERT INTO Atencion (idServ, dniMed, duracionTurno) VALUES (4, 35572166, '00:35');

-- Horarios de atención.
INSERT INTO HorarioAtencion (idAt, horaDesde, horaHasta) VALUES (1, '09:00:00', '12:00:00');
INSERT INTO HorarioAtencion (idAt, horaDesde, horaHasta) VALUES (1, '14:00:00', '16:00:00');

INSERT INTO HorarioAtencion (idAt, horaDesde, horaHasta) VALUES (2, '09:00:00', '13:00:00');
INSERT INTO HorarioAtencion (idAt, horaDesde, horaHasta) VALUES (3, '14:00:00', '18:00:00');
INSERT INTO HorarioAtencion (idAt, horaDesde, horaHasta) VALUES (4, '14:00:00', '18:00:00');


-- Excepciones
INSERT INTO excepcion (dni,fechaDesde,fechaHasta,horaDesde,horaHasta) 
    VALUES (33537549,ADDDATE(CURDATE(), INTERVAL 0 DAY),ADDDATE(CURDATE(), INTERVAL 2 DAY),'10:00','11:45');

-- El día 3, da horarios solo hasta las 10:00 
INSERT INTO excepcion (dni,fechaDesde,fechaHasta,horaDesde,horaHasta) 
    VALUES (33537549,ADDDATE(CURDATE(), INTERVAL 3 DAY),ADDDATE(CURDATE(), INTERVAL 3 DAY),'10:00',NULL);
    
-- El día 4, solo puede dar turno desde las 15:00 en adelante
INSERT INTO excepcion (dni,fechaDesde,fechaHasta,horaDesde,horaHasta) 
    VALUES (33537549,ADDDATE(CURDATE(), INTERVAL 4 DAY),ADDDATE(CURDATE(), INTERVAL 4 DAY),NULL,'15:00');

-- --------------------------------------------------------
-- Stored procedures y funciones.
-- --------------------------------------------------------

DROP FUNCTION IF EXISTS fn_libreDeExcepcion;

DELIMITER $$
/* Funcion que evalua si un turno no esta contenido en el rango de excepcion*/
CREATE FUNCTION fn_libreDeExcepcion
(
	idAtencion    INT,
	dniMedico     INT,
	diaTurno      DATE, 
	horaTurno     TIME,
	duracionTurno TIME
) 
RETURNS BOOL DETERMINISTIC
BEGIN
  DECLARE respuesta BOOL DEFAULT TRUE;
  DECLARE fin       INTEGER DEFAULT 0;
  DECLARE fechaDesd DATE;
  DECLARE fechaHast DATE;
  DECLARE horaDesd  TIME;
  DECLARE horaHast  TIME;
  
  DECLARE cursorExcepcion CURSOR FOR
  	SELECT fechaDesde,fechaHasta,horaDesde,horaHasta FROM excepcion WHERE dni = dniMedico;
  DECLARE CONTINUE handler FOR NOT FOUND SET fin =1;
  
  OPEN cursorExcepcion;
  loop_excepcion: LOOP
	  FETCH cursorExcepcion INTO fechaDesd,fechaHast,horaDesd,horaHast;
	  IF fin = 1 THEN
		LEAVE loop_excepcion;
	  END IF;
	  
	  /* Rango fechaDesde - fechaHasta incluido los mismos*/
	  IF diaTurno >= fechaDesd AND diaTurno <= fechaHast THEN
		/* si no tiene asigando la franja horaria se asume todo el dia*/
		IF horaDesd IS NULL AND horaHast IS NULL THEN 
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;
	   /* para turnos desde que comienza el día hasta un limite superior*/
	   IF horaDesd IS NULL AND horaTurno < HoraHast THEN 
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;
		   /* para turnos desde limite inferior hasta que termina el día*/
	   IF horaHast IS NULL AND ADDTIME(horaTurno,duracionTurno)> horaDesd THEN 
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;   
	   /* si esta parcialmente contenido por el limite inferior*/
	   IF horaTurno<=horaDesd AND ADDTIME(horaTurno,duracionTurno)> horaDesd THEN
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;
		  /* si esta totalmente contenido*/
	   IF horaTurno>horaDesd AND ADDTIME(horaTurno,duracionTurno)< horaHast THEN
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;
		  /* si esta parcialmente contenido por el limite superior*/
	   IF horaTurno<horaHast AND ADDTIME(horaTurno,duracionTurno)>= horaHast THEN
		 SET respuesta = FALSE;
		 LEAVE loop_excepcion;
	   END IF;
	  END IF;
  
  END LOOP loop_excepcion;
  CLOSE cursorExcepcion; 
  RETURN respuesta;
END$$
DELIMITER ;

/*-------------------------------------------------*/
DROP PROCEDURE IF EXISTS sp_TurnosDias;

/*stored procedure auxiliar que agrega un cierto rango horario y cierta cantidad de dias */
delimiter $$
CREATE PROCEDURE sp_TurnosDias
(
	idAtencion    INT,
	duracionTurno TIME,
	dniMedico     INT,
	cantidadDias  INT,
	primerDia     DATE,
	hDesde        TIME,
	hHasta        TIME	
)
BEGIN
	/* Declaracion de variables y valores por default. */
	DECLARE it int DEFAULT 0;
	/* Bucle por cantidad de dias*/
	diasWhile : WHILE it < cantidadDias DO
		SET @horaTurno = hDesde;
		SET @diaTurno = DATE_ADD(primerDia, INTERVAL it DAY);
			/* Bucle por franja horaria*/
			creaWhile : while @horaTurno < hHasta DO
				/*si no esta exceptuado ese turno se agrega*/
				IF fn_libreDeExcepcion(idAtencion,dniMedico,@diaTurno,@horaTurno,duracionTurno) = TRUE THEN
					INSERT INTO Turno (idAt, fecha, hora, dniPac) VALUES (idAtencion, @diaTurno, @horaTurno, NULL);
				END IF;
				SET  @horaTurno = ADDTIME(@horaTurno, duracionTurno);
			END  while creaWhile;  
            
		/* Itero la variable. */
		SET it = it + 1;
	END WHILE diasWhile;
END$$
delimiter ;

/*-------------------------------------------------*/

/* Borro el stored procedure, si ya esta creado. */
DROP PROCEDURE IF EXISTS sp_CreaTurnos;

/* Creo el nuevo stored procedure. */
delimiter $$
CREATE PROCEDURE sp_CreaTurnos
(
	idAtencion   int,
	cantidadDias int
)
Proc_sp_CreaTurnos:BEGIN
			
	DECLARE done INT DEFAULT FALSE; /* Por workaround de un bug. */
	
	/* Horarios en los que atiende el medico */
    DECLARE hDesde, hHasta time;
   
	/* Un medico puede tener mas de un horario de atencion. */
    DECLARE cursorHorario CURSOR FOR SELECT horaDesde, horaHasta FROM HorarioAtencion WHERE idAt = idAtencion;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; /* Por workaround de un bug. */

	/* Me fijo si hay turnos libres para esa atención. */
	SELECT COUNT(*) INTO @existeTurno 
    FROM Turno 
	WHERE idAt = idAtencion 
      AND dniPac IS NULL
      /* Pero me fijo que la fecha sea mayor al día de hoy, para no generar turnos en fechas pasadas.*/
	  and fecha > CURDATE();
    
    /* Si existe turno/s libre/s entonces no se crean nuevos turnos*/
	IF @existeTurno > 0 THEN		
        select 'Existen turnos libres para esa atención.' AS Respuesta;
        leave Proc_sp_CreaTurnos;
    END IF;

	/* Para la atencion del parametro,  buscamos el ultimo turno que tenga.*/
    /* Buscamos la fecha del ultimo turno, y le sumamos un dia, para saber desde donde arrancar. */
    # Se tendria que settear un fecha fija para que sea deterministico
	SELECT DATE_ADD( IFNULL(Max(fecha), CURDATE()), INTERVAL 1 DAY) INTO @primerDia FROM Turno WHERE idAt = idAtencion;
	/*Cada idAt tiene una duracion del turno asignada*/
	SELECT duracionTurno, dniMed INTO @duracionDelTurno, @dniMedico FROM atencion WHERE idAt = idAtencion;
	
    /* Agrego validación para que no se puedan crear turnos en fechas que ya pasaron porque no tiene sentido.*/
    if @primerDia <= CURDATE() then
		/* Entonces los turnos se crean a partir de "mañana", sí o sí. */
		set @primerDia = ADDDATE(CURDATE(), interval 1 day);        
    end if;
    
	/* Abro cursor para iterar por los horarios de atencion del medico. */
	OPEN cursorHorario;

	/* Por cada horario de atencion del medico */
    cursorLoop: LOOP
    
		/* los horarios de atencion del medico */
		FETCH cursorHorario INTO hDesde, hHasta;
      
		/* Por workaround de un bug. */
		IF done = 1 THEN LEAVE cursorLoop; END IF;
        
		/* Llamada al procedimiento auxiliar para la generacion de horarios por franja horaria*/
		CALL sp_TurnosDias(idAtencion,@duracionDelTurno,@dniMedico,cantidadDias,@primerDia,hDesde,hHasta);
	END LOOP;
	 /* Cierro cursor. */
	CLOSE cursorHorario;
END$$
delimiter ;
