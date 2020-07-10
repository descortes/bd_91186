
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
	/* Declaracion de variables y valores por default. */
    declare it int default 0;
    set @primerDia = DATE("1900-01-01"); 
    
	/* Para la atención del parámetro,  buscamos el último turno que tenga.*/
    /* Buscamos la fecha del último turno, y le sumamos un día, para saber desde dónde arrancar. */	    
	select DATE_ADD(Max(fecha), INTERVAL 1 DAY) into @primerDia from turno where idAt = idAtencion;
    
    select @primerDia;
    
    /* Itero por la cantidad de días. */    
    WHILE it < cantidadDias DO
			/* Por cada día, genero los turnos correspondientes. */
            set @diaTurno = DATE_ADD(@primerDia, INTERVAL it DAY);
            
            insert into turno (idAt, fecha, hora, dniPac)
			values            (idAtencion, @diaTurno, '03:05:15', null);
            
            set it = it + 1;
	END WHILE;
    
end$$

delimiter ;


/* Lo ejecuto para probar. */
call sp_CreaTurnos(1 /* id-atencion */, 5 /* días */);


