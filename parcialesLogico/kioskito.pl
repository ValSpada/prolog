%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% responsable(persona, [dia(inicio, fin)]).

responsable(dodain , [lunes(9, 15), miercoles(9, 15), viernes(9, 15)]).
responsable(lucas  ,                                 [martes(10, 20)]).
responsable(juanC  ,                [sabado(18, 22), domingo(18, 22)]).
responsable(juanFdS,                [jueves(10, 20), viernes(12, 20)]).
responsable(leoC   ,               [lunes(14, 18), miercoles(14, 18)]).
responsable(martu  ,                              [miercoles(23, 24)]).

responsable(vale, Horario) :-
    responsable(dodain, HorariosDodain),
    responsable(juanC, HorariosJuanC),
    union(HorariosDodain, HorariosJuanC, Horario).

% dia(Horario, Dia)

dia(lunes(_, _)    ,     lunes).
dia(martes(_, _)   ,    martes).
dia(miercoles(_, _), miercoles).
dia(jueves(_, _)   ,    jueves).
dia(viernes(_, _)  ,   viernes).
dia(sabado(_, _)   ,    sabado).
dia(domingo(_, _)  ,   domingo).

% horas(dia(inicio, fin), inicio, fin).
horas(lunes(Inicio, Fin)    , Inicio, Fin).
horas(martes(Inicio, Fin)   , Inicio, Fin).
horas(miercoles(Inicio, Fin), Inicio, Fin).
horas(jueves(Inicio, Fin)   , Inicio, Fin).
horas(viernes(Inicio, Fin)  , Inicio, Fin).
horas(sabado(Inicio, Fin)   , Inicio, Fin).
horas(domingo(Inicio, Fin)  , Inicio, Fin).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Definir un predicado que permita relacionar un dia y hora con una persona, 
% en la que dicha persona atiende el kiosco.

quienAtiende(Dia, Hora, Persona) :-
    responsable(Persona, Horarios),
    member(Horario, Horarios),
    dia(Horario, Dia),
    atiendeAEsaHora(Horario, Hora).

atiendeAEsaHora(Horario, Hora) :-
    horas(Horario, Inicio, Fin),
    between(Inicio, Fin, Hora).

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Definir un predicado que permita saber si una persona en un día y horario
% determinado está atendiendo ella sola. Este predicado debe utilizar not/1
% y debe ser inversible para relacionar personas.

atiendeSola(Dia, Hora, Persona) :-
    quienAtiende(Dia, Hora, Persona),
    not(estaAcompaniada(Dia, Hora, Persona)).

estaAcompaniada(Dia, Hora, Persona) :-
    quienAtiende(Dia, Hora, Persona),
    quienAtiende(Dia, Hora, Persona1),
    Persona \= Persona1.

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% Dado un día, queremos relacionar que personas podrian estar atendiendo el
% kiosko en algun momento de ese día. Explosión combinatoria, lo salteo.

%%%%%%%%%%        PUNTO 5       %%%%%%%%%%

% venta(quien, dia, fecha(dia, mes), producto(caracteristicas)).

venta(dodain, lunes    , fecha(10, 8),               [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
venta(dodain, miercoles, fecha(12, 8),       [bebida(alcoholica, 8), bebida(noAlcoholica, 1), golosinas(10)]).
venta(martu , miercoles, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas , martes   , fecha(11, 8),                                                      [golosinas(600)]).
venta(lucas , martes   , fecha(18, 8),                       [bebida(noAlcoholica, 2), cigarrillos([derby])]).

suertuda(Persona) :-
    venta(Persona, _, _, _),
    forall(venta(Persona, _, _, Ventas), hizoUnaVentaImportante(Ventas)).

hizoUnaVentaImportante(Ventas) :-
    nth1(1, Ventas, Venta),
    ventaImportante(Venta).

ventaImportante(golosinas(Valor)) :-
    Valor > 100.
ventaImportante(cigarrillos(Marcas)) :-
    member(Marca1, Marcas),
    member(Marca2, Marcas),
    Marca1 \= Marca2.
ventaImportante(bebida(alcoholica, _)).
ventaImportante(bebida(_, Cantidad)) :-
    Cantidad > 5.