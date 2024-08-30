%%%%%%%%      ACLARACIONES PERSONALES      %%%%%%%%

% 1) Al final no me sirvió decir que era una carrera el simulacro porque igual me saltie cosas.
% 2) Chill, no es una carrera
% 3) Darle 3 vueltas a los enunciados

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% a. Generar la base de conocimiento incial

% cree(Nombre, [QuienesCree])
cree(gabriel,  [campanita, magoDeOz, cavenaghi]).
cree(juan,     [conejoDePascua]).
cree(macarena, [reyesMagos, magoCapria, campanita]).
cree(diego,    []).

%tipoSuenio(cantante(discosAVender)).
%tipoSuenio(futbolista(equipo)).
%tipoSuenio(ganarLoteria([numeros])).

% suenio(Nombre, tipoSuenio()).
suenio(gabriel,  ganarLoteria([5,9])).
suenio(gabriel,  futbolista(arsenal)).
suenio(juan,     cantante(100000)).
suenio(macarena, cantante(10000)).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20.

esAmbiciosa(Persona) :-
    suenio(Persona, _),
    findall(Dificultad, nivelDificultad(Persona, Dificultad), Dificultades),
    sumlist(Dificultades, DificultadTotal),
    DificultadTotal > 20.

nivelDificultad(Persona, Dificultad) :-
    suenio(Persona, Suenio),
    dificultad(Suenio, Dificultad).

dificultad(cantante(Discos), 6) :-
    Discos > 500000.
dificultad(cantante(Discos), 4) :-
    Discos =< 500000.
dificultad(ganarLoteria(Numeros), Dificultad) :-
    length(Numeros, CantidadNumeros),
    Dificultad is 10 * CantidadNumeros.
dificultad(futbolista(Equipo), 3) :-
    esEquipoChico(Equipo).
dificultad(futbolista(Equipo), 16) :-
    not(esEquipoChico(Equipo)).

esEquipoChico(aldosivi).
esEquipoChico(arsenal).

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Queremos saber si un personaje tiene química con una persona.

tieneQuimica(campanita, Persona) :-
    creeEn(Persona, campanita),
    nivelDificultad(Persona, Dificultad),
    Dificultad < 5.

tieneQuimica(Personaje, Persona) :-
    creeEn(Persona, Personaje),
    Personaje \= campanita,
    not(esAmbiciosa(Persona)),
    forall(suenio(Persona, Suenio), esPuro(Suenio)).

% AUXILIAR

creeEn(Persona, Personaje) :-
    cree(Persona, Personajes),
    member(Personaje, Personajes). 
        
esPuro(futbolista(_)).
esPuro(cantante(Discos)) :-
    Discos < 200000.

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

sonAmigos(campanita, reyesMagos).
sonAmigos(campanita, conejoDePascua).
sonAmigos(conejoDePascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

% Necesitamos definir si un personaje puede alegrar a una persona.

puedeAlegrar(Personaje, Persona) :-
    suenio(Persona, _),
    tieneQuimica(Personaje, Persona),
    noEstaEnfermo(Personaje).

noEstaEnfermo(Personaje) :-
    creeEn(_, Personaje),
    not(estaEnfermo(Personaje)).

noEstaEnfermo(Personaje) :-
    personajeBackup(Personaje, OtroPersonaje),
    noEstaEnfermo(OtroPersonaje).

personajeBackup(Personaje, OtroPersonaje) :-
    sonAmigos(Personaje, OtroPersonaje).