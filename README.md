
Definir una base de datos con el esquema representado, y un procedimiento almacenado para generar turnos libres 
para m�dicos en servicios a partir de sus d�as de semana y horarios de atenci�n. Consultar por la estrategia 
para decidir cu�ndo y c�mo se generan los turnos libres invocando el procedimiento almacenado.
Tener en cuenta que para generar los turnos deber� usar un cursor dentro del procedimiento, y funciones de 
fechas y tiempo propias de MySQL.

--------------------------------------------------------------------------------------------------------------
	
Efectivamente, si un turno tiene el dni de paciente nulo, significa que est� libre. Cuando se asigna un 
turno a un paciente se registra el dni del paciente al que se le asign�...

--------------------------------------------------------------------------------------------------------------

Puede haber distintas estrategias para crear turnos libres. Hay hospitales p�blicos que generan turnos libres 
para cada servicio y para per�odos futuros de extensi�n fija; esto implica la imposici�n de restricciones 
temporales para solicitar turnos, ya que por ejemplo el �ltimo d�a h�bil de un mes se generan los turnos 
libres para el mes siguiente, y los pacientes deben pedir turnos los primeros d�as del mes con el riesgo 
de que se agoten...

* Otra posibilidad m�s flexible ser�a que se generen turnos para cada m�dico en cada 
servicio cuando se pida un turno y no exista ninguno libre, con la cantidad de d�as a generar turnos 
como par�metro de entrada.

Para la �ltima opci�n, el procedimiento deber�a recibir como par�metros un identificador de atenci�n y una 
cantidad de d�as del per�odo a generarle turnos libres al m�dico en el servicio que representa la atenci�n. 

Hay que investigar en MySQL las funciones con fechas para manejar d�as de semana de una fecha y suma de d�as.
A partir del d�a siguiente al �ltimo turno que haya registrado para un m�dico que no tiene turnos libres, 
hay que definir un cursor para obtener todos los D�aHorario �orrespondientes al identificador de atenci�n
dentro del per�odo, que no est�n afectados por una excepci�n, y generar todos los turnos libres con un ciclo 
que deber� usar la fecha de ese d�a y variar horas con una funci�n de suma de tiempo que observe la duraci�n 
de turnos de la atenci�n y la horaHasta del horario de atenci�n...

--------------------------------------------------------------------------------------------------------------




"Glosario""

Tablas:

Persona:         Contiene los datos de las personas(paciente y/o m�dicos).
DirE:            Contiene las direcciones electr�nicas asociados a una persona por su dni.
Domicilio:       Contiene los datos de o los domicilio/s de una persona dado su dni.
Servicio:        Contiene los nombres de los servicio disponibles en el establecimiento.
Atencion:        Contiene los datos de la atenci�n de un paciente, as� como el dni del m�dico que lo atiende, el servicio que necesita y la duraci�n de ese turno.
Excepcion:       Contiene los datos de los d�as y horas que se ausenta el m�dico. Si no existe horaDesde, se toma desde inicio del dia?, hasta el horaHasta, idem las otras combinaciones?.
HorarioAtencion: 
DiaHorario:      Contiene el d�a de la semana que corresponde con el idHorario.
Turno:           Contiene el turno  asignado a un paciente.
