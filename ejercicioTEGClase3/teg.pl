%%%%%%%%%%%%%%%%%%% HECHOS INICIALES %%%%%%%%%%%%%%%%%%%
paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, india).
paisContinente(asia, afganistan).
paisContinente(asia, nepal).

paisImportante(argentina).
paisImportante(alemania).

limitrofes(argentina, brasil).
limitrofes(bolivia, brasil).
limitrofes(bolivia, argentina).
limitrofes(argentina, chile).
limitrofes(espania, francia).
limitrofes(alemania, francia).
limitrofes(nepal, india).
limitrofes(china, india).
limitrofes(nepal, china).
limitrofes(afganistan, china).

ocupa(argentina, azul).
ocupa(bolivia, rojo).
ocupa(brasil, verde).
ocupa(chile, negro).
ocupa(ecuador, rojo).
ocupa(alemania, azul).
ocupa(espania, azul).
ocupa(francia, azul).
ocupa(inglaterra, azul).
ocupa(aral, verde).
ocupa(china, negro).
ocupa(india, verde).
ocupa(afganistan, verde).

continente(americaDelSur).
continente(europa).
continente(asia).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 1   %%%%%%%%%%%%%%%%%%%
% estaEnContinente/2: relaciona un jugador y un continente si el jugador ocupa al menos un país en el continente.
estaEnContinente(Jugador, Continente) :-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 2   %%%%%%%%%%%%%%%%%%%
% ocupaContinente/2: relaciona un jugador y un continente si el jugador ocupa totalmente el continente.
ocupaContinente(Jugador, Continente) :-
    estaEnContinente(Jugador, Continente), % -> En otro caso, podes pasar el ocupa(_, Jugador) en un predicado de aridad 1 nombrado Jugador
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador)).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 3   %%%%%%%%%%%%%%%%%%%
% cubaLibre/1: es verdadero para un país si nadie lo ocupa.
cubaLibre(Pais) :-
    paisContinente(_, Pais),
    not(ocupa(Pais, _)).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 4   %%%%%%%%%%%%%%%%%%%
% leFaltaMucho/2: relaciona a un jugador si está en un continente pero le falta ocupar otros 2 países o más.
leFaltaMucho(Jugador, Continente) :-
    estaEnContinente(Jugador, Continente),
    not(ocupaAlMenos2(Jugador,Continente)).

ocupaAlMenos2(Jugador, Continente) :-
    estaEnEsePaisYContinente(Continente, UnPais, Jugador),
    estaEnEsePaisYContinente(Continente, OtroPais, Jugador),
    UnPais \= OtroPais.

estaEnEsePaisYContinente(Jugador, Pais, Continente) :-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 5   %%%%%%%%%%%%%%%%%%%
% sonLimitrofes/2: relaciona dos países si son limítrofes considerando que si A es limítrofe de B, entonces B también es limítrofe de A.
sonLimitrofes(Pais1, Pais2) :-
    limitrofes(Pais1, Pais2).

sonLimitrofes(PAis1, Pais2) :-
    limitrofes(Pais2, Pais1).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 6   %%%%%%%%%%%%%%%%%%%
% tipoImportante/1: un jugador es importante si ocupa todos los países importantes.
tipoImportante(Jugador) :-
    ocupa(_, Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 7   %%%%%%%%%%%%%%%%%%%
% estaEnElHorno/1: un país está en el horno si todos sus países limítrofes están ocupados por el mismo jugador que no es el mismo que ocupa ese país.
estaEnElHorno(Pais) :-
    ocupa(Pais, Jugador),
    jugador(OtroJugador),
    Jugador \= OtroJugador,
    sonLimitrofes(Pais, _),
    forall(sonLimitrofes(Pais, PaisLimitrofe), ocupa(PaisLimitrofe, OtroJugador)).

jugador(Jugador) :-
    ocupa(_, Jugador).

%%%%%%%%%%%%%%%%%%%    EJERCICIO 8   %%%%%%%%%%%%%%%%%%%
% esCompartido/1: un continente es compartido si hay dos o más jugadores en él.