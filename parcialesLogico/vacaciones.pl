%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% dondeViaja(Persona, [Lugares]).
dondeViaja(dodain, [pehuenia, sanMartinDeLosAndes, esquel, sarmiento, camarones, playasDoradas]).
dondeViaja(alf,    [bariloche, sanMartinDeLosAndes, elBolson]).
dondeViaja(nico,   [marDelPlata]).
dondeViaja(vale,   [calafate, elBolson]).
dondeViaja(martu, Lugares) :-
    dondeViaja(nico, Destinos1),
    dondeViaja(alf, Destinos2),
    union(Destinos1, Destinos2, Lugares).

% Como Juan no sabe y Carlos no se toma vacaciones, no serán modelados por ahora

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% atracciones(nombreLugar, atracciones). 
atraccion(esquel, parqueNacional(losAlerces)).

atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).

atraccion(pehuenia, cerro(bateaMahuida, 2000)).
atraccion(pehuenia, cerro(juanCarlos, 2100)).

atraccion(pehuenia, cuerpoAgua(moquehue, sePuedePescar, 14)).
atraccion(pehuenia, cuerpoAgua(alumine, sePuedePescar, 19)).

atraccion(calafate, playa(6, 10)).
atraccion(elBolson, parqueNacional(falopa)).

% Queremos saber qué vacaciones fueron copadas para una persona. 
% Esto ocurre cuando todos los lugares a visitar tienen por lo menos una atracción copada. 

vacacionesCopadas(Persona, Vacaciones) :-
    dondeViaja(Persona, Vacaciones),
    forall(member(Lugares, Vacaciones), sonCopados(Lugares)).
    
sonCopados(Lugar) :-
    atraccion(Lugar, Atraccion),
    esCopada(Atraccion).

esCopada(cerro(_, Altura)) :-
    Altura > 2000.
esCopada(cuerpoAgua(_, sePuedePescar, _)).
esCopada(cuerpoAgua(_, _, Temperatura)) :-
    Temperatura > 20.
esCopada(playa(MareaBaja, MareaAlta)) :-
    Marea is MareaAlta - MareaBaja,
    Marea < 5.
esCopada(excursion(Nombre)) :-
    length(Nombre, CantidadLetras),
    CantidadLetras > 7.
esCopada(parqueNacional(_)).

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron.

% noSeCruzaron(Persona1, Persona2).
noSeCruzaron(Persona1, Persona2) :-
    persona(Persona1),
    persona(Persona2),
    Persona1 \= Persona2,
    not(seCruzaron(Persona1, Persona2)).

persona(Persona) :-
    dondeViaja(Persona, _).

seCruzaron(Persona1, Persona2) :-
    lugarDondeViaja(Persona1, Lugar),
    lugarDondeViaja(Persona2, Lugar).

lugarDondeViaja(Persona, Lugar) :-
    dondeViaja(Persona, Lugares),
    member(Lugar, Lugares).

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% costoDeVida(Lugar, Costo).
costoDeVida(sarmiento,           100).
costoDeVida(esquel,              150).
costoDeVida(pehuenia,            180).
costoDeVida(sanMartinDeLosAndes, 150).
costoDeVida(camarones,           135).
costoDeVida(playasDoradas,       170).
costoDeVida(bariloche,           140).
costoDeVida(calafate,            240).
costoDeVida(elBolson,            145).
costoDeVida(marDelPlata,         140).

% Queremos saber si unas vacaciones fueron gasoleras para una persona. 
% Esto ocurre si todos los destinos son gasoleros, es decir, tienen un costo de vida menor a 160.

vacacionesGasoleras(Persona) :-
    persona(Persona),
    forall(lugarDondeViaja(Persona, Destinos), sonGasoleros(Destinos)).

sonGasoleros(Destino) :-
    costoDeVida(Destino, Costo),
    Costo < 160.

%%%%%%%%%%        PUNTO 5       %%%%%%%%%%

% Explosion combinatoria, no se hace (no me linches Fede).sonGasoler