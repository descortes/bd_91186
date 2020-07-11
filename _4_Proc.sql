/* Borro el stored procedure, si ya est� creado. */
drop procedure IF EXISTS sp_CreaTurnos;

/* Creo el nuevo stored procedure. */

delimiter $$
create procedure sp_CreaTurnos
(
	idAtencion   int,
	cantidadDias int
)
begin
	DECLARE done INT DEFAULT FALSE; /* Por workaround de un bug. */

	/* Declaracion de variables y valores por default. */
    declare it int default 0;
	/* Horarios en los que atiende el medico */
    declare hDesde, hHasta time;

	/* Un medico puede tener mas de un horario de atencion. */
    DECLARE cursorHorario CURSOR FOR SELECT horaDesde, horaHasta from HorarioAtencion where idAt = idAtencion;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; /* Por workaround de un bug. */

    set @primerDia = DATE("1900-01-01");
	/* Para la atenci�n del par�metro,  buscamos el �ltimo turno que tenga.*/
    /* Buscamos la fecha del �ltimo turno, y le sumamos un d�a, para saber desde d�nde arrancar. */
	select DATE_ADD( IFNULL(Max(fecha), CURDATE()), INTERVAL 1 DAY) into @primerDia from Turno where idAt = 1;

    /* Abro cursor para iterar por los horarios de atencion del medico. */
	OPEN cursorHorario;

	/* Por cada horario de atencion del medico */
    cursorLoop: LOOP
		/* los horarios de atencion del medico */
		FETCH cursorHorario INTO hDesde, hHasta;
        
		/* Por workaround de un bug. */
		IF done = 1 THEN LEAVE cursorLoop; END IF;

		set @horaTurno = hDesde;
      
		set it = 0; /* Reseteo el iterador. */ 
        
		/* Itero por la cantidad de días. */    
		diasWhile : WHILE it < cantidadDias DO
			/* Por cada día, genero los turnos correspondientes. */
			set @diaTurno = DATE_ADD(@primerDia, INTERVAL it DAY);                        			
            
            creaWhile : while @horaTurno < hHasta do            			
				insert into turno (idAt, fecha, hora, dniPac)
				values            (idAtencion, @diaTurno, @horaTurno, null);
				            
				set @horaTurno = ADDTIME(@horaTurno, '00:05:00');
			end while creaWhile;
		set it = it + 1;
		END WHILE diasWhile;
    END LOOP;

    /* Cierro cursor. */
    CLOSE cursorHorario;
end$$
delimiter ;

/* Lo ejecuto para probar. */
CALL sp_CreaTurnos(1 /* id-atencion */, 2 /* d�as */);