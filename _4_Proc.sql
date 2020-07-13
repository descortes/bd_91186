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
		IF horaDesd IS NULL OR horaHast IS NULL THEN 
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
        select 'Existen turnos libres para esa atención.';
        leave Proc_sp_CreaTurnos;
    END IF;

	/* Para la atencion del parametro,  buscamos el ultimo turno que tenga.*/
    /* Buscamos la fecha del ultimo turno, y le sumamos un dia, para saber desde donde arrancar. */
    # Se tiene que settear un fecha fija para que sea deterministico 
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

/* Lo ejecuto para probar. */
CALL sp_CreaTurnos(1 /* id-atencion */, 3 /* dias */);
