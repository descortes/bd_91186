/*

*/

select 
    idAt     as atencion,
    s.idServ as servicio_id,
    s.nombre as servicio,
    p.dni    as medico_dni,
    p.nombre as medico 
from       atencion a
inner join persona  p on a.dniMed = p.dni
inner join servicio s on a.idServ = s.idServ
