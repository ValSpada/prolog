%%%%%%%%%% BASE DE CONOCIMIENTO %%%%%%%%%%

jugador(jugador(valentin, 20, 10, [criatura(yshaarj, 10, 10, 10)], [criatura(nzoth, 5, 7, 10)], [criatura(cthun, 6, 6, 10)])).

% FUNCTORES:
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
% hechizo(Nombre, FunctorEfecto, CostoMana)

% daño(CantidadDaño)
% daño(CantidadDaño)

%%%%%%%%%% PREDICADOS AUXILIARES %%%%%%%%%%

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.

tieneCarta(Nombre, Carta) :-
    esJugador(Nombre, Jugador),
    cartasMazo(Jugador, Cartas),
    member(Carta, Cartas).

tieneCarta(Nombre, Carta) :-
    esJugador(Nombre, Jugador),
    cartasMano(Jugador, Cartas),
    member(Carta, Cartas).
    
tieneCarta(Nombre, Carta) :-
    esJugador(Nombre, Jugador),
    cartasCampo(Jugador, Cartas),
    member(Carta, Cartas).

% AUXILIAR

esJugador(Nombre, Jugador) :-
    jugador(Jugador),
    nombre(Jugador, Nombre).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene, 
% ya sea en el mazo, la mano o el campo, son criaturas.

esGuerrero(Nombre) :-
    esJugador(Nombre, Jugador),
    forall(cartas(Jugador, Cartas), sonCriaturas(Cartas)).
    
% AUXILIAR

cartas(Jugador, Carta) :-
    cartasPorPartes(Jugador, Mazo, Mano, Campo),
    union(Mazo, Mano, MazoYMano),
    union(MazoYMano, Campo, Cartas),
    member(Carta, Cartas).

sonCriaturas(criatura(_, _, _, _)).

cartasPorPartes(Jugador, Mazo, Mano, Campo) :-
    cartasMazo(Jugador, Mazo),
    cartasMano(Jugador, Mano),
    cartasCampo(Jugador, Campo).

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Relacionar un jugador consigo mismo después de empezar el turno. Al empezar el turno, 
% la primera carta del mazo pasa a estar en la mano y el jugador gana un punto de maná.

empiezaElTurno(Nombre, jugador(Nombre, Vida, Mana, CartasMazo, CartasMano, CartasCampo)) :-
    esJugador(Nombre, Jugador),
    vida(Jugador, Vida),
    mana(Jugador, ManaViejo),
    cartasCampo(Jugador, CartasCampo),
    Mana is ManaViejo + 1,
    levantarCarta(Jugador, CartasMazo, CartasMano).

% AUXILIAR

levantarCarta(Jugador, Cola, CartasMano) :-
    cartasMazo(Jugador, [Carta|Cola]),
    cartasMano(Jugador, Mano),
    append([Carta], Mano, CartasMano).

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% Cada jugador, en su turno, puede jugar cartas.

% a. Saber si un jugador tiene la capacidad de jugar una carta, esto es verdadero cuando el jugador
%    tiene igual o más maná que el costo de maná de la carta. Este predicado no necesita ser inversible!

puedeJugarLaCarta(Jugador, Carta) :-
    mana(Jugador, ManaJugador),
    mana(Carta, ManaCarta),
    ManaJugador >= ManaCarta.

% b. Relacionar un jugador y las cartas que va a poder jugar en el próximo turno, una carta se puede 
%    jugar en el próximo turno si tras empezar ese turno está en la mano y además se cumplen las condiciones del punto 4.a.

puedeJugarCartas(Nombre, Cartas) :-
    empiezaElTurno(Nombre, Jugador),
    findall(Carta, puedeJugar(Jugador, Carta), Cartas).

% AUXILIAR

puedeJugar(Jugador, Carta) :-
    cartasMano(Jugador, Mano),
    member(Carta, Mano),
    puedeJugarLaCarta(Jugador, Carta).

%%%%%%%%%%        PUNTO 5       %%%%%%%%%%

% Explosión Combinatoria, lo salteo.

%%%%%%%%%%        PUNTO 6       %%%%%%%%%%

% Relacionar a un jugador con el nombre de su carta más dañina.

cartaConMasDanio(Nombre, NombreCarta) :-
    esJugador(Nombre, Jugador),
    cartas(Jugador, CartaDanina),
    nombre(CartaDanina, NombreCarta),
    forall(cartas(Jugador, Cartas), esLaMasDanina(CartaDanina, Cartas)).

esLaMasDanina(Carta1, Carta2) :-
    danio(Carta1, Danio1),
    danio(Carta2, Danio2),
    Danio1 >= Danio2.

%%%%%%%%%%        PUNTO 7       %%%%%%%%%%

% Cuando un jugador juega una carta, él mismo y/o su rival son afectados de alguna forma:

% a. jugarContra/3. Modela la acción de jugar una carta contra un jugador. Relaciona a la carta, 
%    el jugador antes de que le jueguen la carta y el jugador después de que le jueguen la carta. 
%    Considerar que únicamente afectan al jugador las cartas de hechizo de daño.
%    Este predicado no necesita ser inversible para la carta ni para el jugador antes de que le jueguen la carta.

jugarContra(hechizo(_, danio(Puntos), _), Nombre, jugador(Nombre, Vida, Mana, Mazo, Mano, Campo)) :-
    esJugador(Nombre, Jugador),
    vida(Jugador, VidaAntes),
    Vida is VidaAntes - Puntos,
    mana(Jugador, Mana),
    cartasPorPartes(Jugador, Mazo, Mano, Campo).

% b. BONUS: jugar/3. Modela la acción de parte de un jugador de jugar una carta. Relaciona a la carta, 
%    el jugador que puede jugarla antes de hacerlo y el mismo jugador después de jugarla. En caso de ser un hechizo de cura, 
%    se aplicará al jugador y no a sus criaturas. No involucra al jugador rival (para eso está el punto a).

jugar(Carta, Nombre, jugador(Nombre, Vida, Mana, Mazo, Mano, Campo)) :-
    jugadorVidaYMazo(Nombre, Jugador, Vida, Mazo),
    convocar(Carta, Jugador, Mana, Mano, Campo).

jugar(Carta, Nombre, jugador(Nombre, Vida, Mana, Mazo, Mano, Campo)) :-
    jugadorYMazo(Nombre, Jugador, Mazo),
    jugarHechizoCuracion(Carta, Jugador, Vida, Mana, Mano, Campo).

% AUXILIAR

convocar(Carta, Jugador, Mana, Mano, Campo) :-
    member(Carta, Mano),
    puedeJugarLaCarta(Jugador, Carta),
    manaPostUso(Carta, Jugador, Mana),
    cartasMano(Jugador, CartasMano),
    agarrarCarta(Carta, CartasMano, Mano),
    cartasCampo(Jugador, CartasCampo),
    append([Carta], CartasCampo, Campo).

jugarHechizoCuracion(Carta, Jugador, Vida, Mana, Mano, Campo) :-
    convocar(Carta, Jugador, Mana, Mano, Campo),
    vida(Carta, VidaCarta),
    vida(Jugador, VidaJugador),
    Vida is VidaCarta + VidaJugador.

manaPostUso(Carta, Jugador, Mana) :-
    mana(Carta, ManaCarta),
    mana(Jugador, ManaJugador),
    Mana is ManaJugador - ManaCarta.

agarrarCarta(Carta, [Carta|Mano], Mano).

jugadorVidaYMazo(Nombre, Jugador, Vida, Mazo) :-
    esJugador(Nombre, Jugador),
    vida(Jugador, Vida),
    cartasMazo(Jugador, Mazo).

jugadorYMazo(Nombre, Jugador, Mazo) :-
    jugadorVidaYMazo(Nombre, Jugador, _, Mazo).