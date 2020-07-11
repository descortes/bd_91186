
Definir una base de datos con el esquema representado, y un procedimiento almacenado para generar turnos libres 
para médicos en servicios a partir de sus días de semana y horarios de atención. Consultar por la estrategia 
para decidir cuándo y cómo se generan los turnos libres invocando el procedimiento almacenado.
Tener en cuenta que para generar los turnos deberá usar un cursor dentro del procedimiento, y funciones de 
fechas y tiempo propias de MySQL.

--------------------------------------------------------------------------------------------------------------
	
Efectivamente, si un turno tiene el dni de paciente nulo, significa que está libre. Cuando se asigna un 
turno a un paciente se registra el dni del paciente al que se le asignó...

--------------------------------------------------------------------------------------------------------------

Puede haber distintas estrategias para crear turnos libres. Hay hospitales públicos que generan turnos libres 
para cada servicio y para períodos futuros de extensión fija; esto implica la imposición de restricciones 
temporales para solicitar turnos, ya que por ejemplo el último día hábil de un mes se generan los turnos 
libres para el mes siguiente, y los pacientes deben pedir turnos los primeros días del mes con el riesgo 
de que se agoten...

* Otra posibilidad más flexible sería que se generen turnos para cada médico en cada 
servicio cuando se pida un turno y no exista ninguno libre, con la cantidad de días a generar turnos 
como parámetro de entrada.

Para la última opción, el procedimiento debería recibir como parámetros un identificador de atención y una 
cantidad de días del período a generarle turnos libres al médico en el servicio que representa la atención. 

Hay que investigar en MySQL las funciones con fechas para manejar días de semana de una fecha y suma de días.
A partir del día siguiente al último turno que haya registrado para un médico que no tiene turnos libres, 
hay que definir un cursor para obtener todos los DíaHorario çorrespondientes al identificador de atención
dentro del período, que no estén afectados por una excepción, y generar todos los turnos libres con un ciclo 
que deberá usar la fecha de ese día y variar horas con una función de suma de tiempo que observe la duración 
de turnos de la atención y la horaHasta del horario de atención...

--------------------------------------------------------------------------------------------------------------

Resolucion:

Para sp_CreaTurnos dado un idAt crea turnos segun la cantidad de dias pasados por parametro.
Al momento de crear los turnos de un medico,
1. Se valida que los turnos esten dentro del horario de atencion del medico y cada turno tiene una duracion fija segun el valor del campo *duracionTurno* de la tabla **Atencion**.
2. Si un medico no tiene turnos asignados (no existe en la tabla **Turnos**), entonces se crean los turnos desde el dia de la fecha actual.
3. Si un medico tiene turnos asignados y desea agregar mas, se toma la ultima fecha de referencia en la tabla **Turno** y se agregan los nuevos. 

```sql
call sp_CreaTurnos(1 /* id-atencion */, 1 /* d�as */);
```

"Glosario""

Tablas:

Persona:         Contiene los datos de las personas(paciente y/o médicos).
DirE:            Contiene las direcciones electrónicas asociados a una persona por su dni.
Domicilio:       Contiene los datos de o los domicilio/s de una persona dado su dni.
Servicio:        Contiene los nombres de los servicio disponibles en el establecimiento.
Atencion:        Contiene los datos de la atención de un paciente, así como el dni del médico que lo atiende, el servicio que necesita y la duración de ese turno.
Excepcion:       Contiene los datos de los días y horas que se ausenta el médico. Si no existe horaDesde, se toma desde inicio del dia?, hasta el horaHasta, idem las otras combinaciones?.
HorarioAtencion: 
DiaHorario:      Contiene el día de la semana que corresponde con el idHorario.
Turno:           Contiene el turno  asignado a un paciente.
