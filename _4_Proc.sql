
/* Borro el stored procedure, si ya está creado. */
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
    declare hDesde, hHasta time;    
    DECLARE cursorHorario CURSOR FOR SELECT horaDesde, horaHasta from horarioatencion where idAt = idAtencion;    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; /* Por workaround de un bug. */
    
    set @primerDia = DATE("1900-01-01");    
	/* Para la atención del parámetro,  buscamos el último turno que tenga.*/
    /* Buscamos la fecha del último turno, y le sumamos un día, para saber desde dónde arrancar. */	    
	select DATE_ADD(Max(fecha), INTERVAL 1 DAY) into @primerDia from turno where idAt = idAtencion;
    
    /* Abro cursor. */
	OPEN cursorHorario;
    cursorLoop: LOOP
		FETCH cursorHorario INTO hDesde, hHasta;
        
        /* Por workaround de un bug. */
		IF done = 1 THEN LEAVE cursorLoop; END IF;
        
        select hDesde, hHasta;
      
		/* Itero por la cantidad de días. */    
		WHILE it < cantidadDias DO
			/* Por cada día, genero los turnos correspondientes. */
			set @diaTurno = DATE_ADD(@primerDia, INTERVAL it DAY);            
			
			insert into turno (idAt, fecha, hora, dniPac)
			values            (idAtencion, @diaTurno, hDesde, null);
			
			set it = it + 1;
		END WHILE;
		
    END LOOP;
    
    /* Cierro cursor. */
    CLOSE cursorHorario;
end$$

delimiter ;

/* Lo ejecuto para probar. */
call sp_CreaTurnos(1 /* id-atencion */, 5 /* días */);
