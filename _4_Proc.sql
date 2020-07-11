DROP PROCEDURE IF EXISTS sp_TurnosDias;

/*stored procedure auxiliar que agrega un cierto rango horario y cierta cantidad de dias */
delimiter $$
CREATE PROCEDURE sp_TurnosDias
(
	idAtencion INT,
	cantidadDias INT,
	hDesde TIME,
	hHasta TIME	
)
BEGIN
/* Declaracion de variables y valores por default. */
    DECLARE it int DEFAULT 0;
/* Bucle por cantidad de dias*/
diasWhile : WHILE it < cantidadDias DO
		SET @horaTurno = hDesde;
		SET @diaTurno = DATE_ADD(@primerDia, INTERVAL it DAY);
			/* Bucle por franja horaria*/
			creaWhile : while @horaTurno < hHasta DO
				INSERT INTO Turno (idAt, fecha, hora, dniPac) VALUES (idAtencion, @diaTurno, @horaTurno, NULL);
				SET  @horaTurno = ADDTIME(@horaTurno, @duracionDelTurno);
			END  while creaWhile;  
	SET it = it + 1;
	END WHILE diasWhile;
END$$
delimiter ;

/*-------------------------------------------------*/

/* Borro el stored procedure, si ya est� creado. */
DROP PROCEDURE IF EXISTS sp_CreaTurnos;

/* Creo el nuevo stored procedure. */
delimiter $$
CREATE PROCEDURE sp_CreaTurnos
(
	idAtencion   int,
	cantidadDias int
)
BEGIN
	DECLARE done INT DEFAULT FALSE; /* Por workaround de un bug. */
	
	/* Horarios en los que atiende el medico */
    DECLARE hDesde, hHasta time;
   
	/* Un medico puede tener mas de un horario de atencion. */
    DECLARE cursorHorario CURSOR FOR SELECT horaDesde, horaHasta FROM HorarioAtencion WHERE idAt = idAtencion;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; /* Por workaround de un bug. */

	/* Para la atenci�n del par�metro,  buscamos el �ltimo turno que tenga.*/
    /* Buscamos la fecha del �ltimo turno, y le sumamos un d�a, para saber desde d�nde arrancar. */
    # Se tiene que settear un fecha fija para que sea deterministico 
	SELECT DATE_ADD( IFNULL(Max(fecha),DATE("1900-01-01")), INTERVAL 1 DAY) INTO @primerDia FROM Turno WHERE idAt = idAtencion;
	/*Cada idAt tiene una duracion del turno asignada*/
	SELECT duracionTurno INTO @duracionDelTurno FROM atencion WHERE idAt = idAtencion;
		 
	 /* Abro cursor para iterar por los horarios de atencion del medico. */
	OPEN cursorHorario;

	/* Por cada horario de atencion del medico */
    cursorLoop: LOOP
    
		/* los horarios de atencion del medico */
		FETCH cursorHorario INTO hDesde, hHasta;
      
		/* Por workaround de un bug. */
		IF done = 1 THEN LEAVE cursorLoop; END IF;
	/* Llamada al procedimiento auxiliar para la generacion de horarios por franja horaria*/
	CALL sp_TurnosDias(idAtencion,cantidadDias,hDesde,hHasta);
	END LOOP;
	 /* Cierro cursor. */
	CLOSE cursorHorario;    
END$$
delimiter ;

/* Lo ejecuto para probar. */
CALL sp_CreaTurnos(1 /* id-atencion */, 3 /* d�as */);