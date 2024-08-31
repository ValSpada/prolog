%%%%%%%%      ACLARACIONES PERSONALES      %%%%%%%%

% 1) Chill
% 2) Elegir buenos nombres
% 3) Revisar repeticion de logica
% 4) Buscar buenas delegaciones

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% juego(nombre, tipo(), precio).
juego(cod,          accion,             100).
juego(battlefield,  accion,             200).
juego(darkSouls,    rol(1000001),       150).
juego(wow,          rol(10000),         150).
juego(weWereHere,   puzzle(25, dificil), 50).
juego(superliminal, puzzle(15, facil),   10).

% descuento(nombreJuego, descuentoDecimal).
descuento(cod,        0.50).
descuento(weWereHere, 0.75).

% usuario(nombre, juegosQuePosee).
usuario(mekane, [darkSouls, wow]).
usuario(jose,                 []).

% adquisicion(usuario, tipo(nombre/regalo si es que se regala algo)).
adquisicion(mekane,          paraSi(weWereHere)).
adquisicion(mekane,           regalo(cod, jose)).
adquisicion(jose,   regalo(battlefield, mekane)).

% PREDICADOS AUXILIARES

nombreDelJuego(paraSi(Nombre), Nombre).
nombreDelJuego(regalo(Nombre, _), Nombre).

genero(Juego, Nombre) :-
    juego(Juego, Genero, _),
    nombreGenero(Genero, Nombre).

nombreGenero(accion, accion).
nombreGenero(rol(_), rol).
nombreGenero(puzzle(_,_), puzzle).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% cuantoSale(juego, precio).

cuantoSale(Juego, Precio) :-
    juego(Juego, _, PrecioSinDescuento),
    descuento(Juego, Porcentaje),
    Precio is PrecioSinDescuento * Porcentaje.

cuantoSale(Juego, Precio) :-
    juego(Juego, _, Precio),
    not(descuento(Juego, _)).

% tieneBuenDescuento(Juego)

tieneBuenDescuento(Juego) :-
    descuento(Juego, DescuentoDecimal),
    Descuento is DescuentoDecimal * 100,
    Descuento >= 50.

% esPopular(Juego).

esPopular(counterStrike).
esPopular(minecraft).
esPopular(Juego) :-
    juego(Juego, Genero, _),
    generoPopular(Genero).

generoPopular(accion).
generoPopular(rol(Jugadores)) :-
    Jugadores > 1000000.
generoPopular(puzzle(25, _)).
generoPopular(puzzle(_, facil)).

% adictoALosDescuentos(Usuario).

adictoALosDescuentos(Usuario) :-
    usuario(Usuario, _),
    forall(planeaAdquirir(Usuario, Adquisicion), tieneBuenDescuento(Adquisicion)).

planeaAdquirir(Usuario, Juego) :-
    adquisicion(Usuario, Adquisicion),
    nombreDelJuego(Adquisicion, Juego).

% fanatico(Usuario, Genero).

fanatico(Usuario, Genero) :-
    usuario(Usuario, Biblioteca),
    juegoYGeneroBiblioteca(Biblioteca, Juego1, Genero),
    juegoYGeneroBiblioteca(Biblioteca, Juego2, Genero),
    Juego1 \= Juego2.

juegoYGeneroBiblioteca(Biblioteca, Juego, Genero) :-
    member(Juego, Biblioteca),
    genero(Juego, Genero).

% monótematico(Usuario, Genero).

monotematico(Usuario, Genero) :-
    usuario(Usuario, Biblioteca),
    juegoYGeneroBiblioteca(Biblioteca, _, Genero),
    forall(member(Juegos, Biblioteca), genero(Juegos, Genero)).

% buenosAmigos(Usuario1, Usuario2)

buenosAmigos(Usuario1, Usuario2) :-
    regaloPopular(Usuario1, Usuario2),
    regaloPopular(Usuario2, Usuario1).

regaloPopular(Usuario1, Usuario2) :-
    adquisicion(Usuario1, regalo(Juego, Usuario2)),
    esPopular(Juego).

% cuantoGastara(Usuario, Gasto, Adquisicion).

cuantoGastara(Usuario, Gasto, TipoAdquisicion) :-
    usuario(Usuario, _),
    esDeEsteTipo(_, TipoAdquisicion),
    findall(Gastos, precioAdquisicion(Usuario, Gastos, TipoAdquisicion), CostoTotal),
    sumlist(CostoTotal, Gasto).

precioAdquisicion(Usuario, Precio, TipoAdquisicion) :-
    adquisicion(Usuario, Adquisicion),
    esDeEsteTipo(Adquisicion, TipoAdquisicion),
    nombreDelJuego(Adquisicion, Juego),
    cuantoSale(Juego, Precio).

esDeEsteTipo(paraSi(_),    paraSi).
esDeEsteTipo(regalo(_, _), regalo).
esDeEsteTipo(_,             ambas).