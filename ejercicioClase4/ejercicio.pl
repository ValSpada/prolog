%%%%%%%%%%%%%%%%%%%%%%%%%% HECHOS BASE %%%%%%%%%%%%%%%%%%%%%%%%%%

linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,pueyrredonB,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,pueyrredonD,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[lasHeras,santaFe,corrientes,once,venezuela,humberto1ro,inclan,caseros]).

combinacion([lima, avMayo]).
combinacion([once, miserere]).
combinacion([pellegrini, diagNorte, nueveJulio]).
combinacion([independenciaC, independenciaE]).
combinacion([jujuy, humberto1ro]).
combinacion([santaFe, pueyrredonD]).
combinacion([corrientes, pueyrredonB]).

% NO HAY DOS ESTACIONES CON MISMO NOMBRE

%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 1 %%%%%%%%%%%%%%%%%%%%%%%%%%

% estaEn/2: en qué línea está una estación.
estaEn(Linea, Estacion) :-
    linea(Linea, Estaciones),
    member(Estacion, Estaciones).

%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 2 %%%%%%%%%%%%%%%%%%%%%%%%%%

% distancia/3: dadas dos estaciones de la misma línea, 
% cuántas estaciones hay entre ellas: por ejemplo, entre Perú y Primera Junta hay 5 estaciones.

distancia(Estacion1, Estacion2, Distancia) :-
    estaEn(Linea, Estacion1),
    cualEsSuPosicion(Estacion1, Linea, Posicion1),
    cualEsSuPosicion(Estacion2, Linea, Posicion2),
    Diferencia is Posicion2 - Posicion1,
    abs(Diferencia, Distancia).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 3 %%%%%%%%%%%%%%%%%%%%%%%%%%

% mismaAltura/2: dadas dos estaciones de distintas líneas, si están a la misma altura 
% (o sea, las dos terceras, las dos quintas, etc.), por ejemplo: Pellegrini y Santa Fe están ambas segundas.

mismaAltura(Estacion1, Estacion2) :-
    estaEn(Linea1, Estacion1),
    estaEn(Linea2, Estacion2),
    Linea1 \= Linea2,
    cualEsSuPosicion(Estacion1, Linea1, Posicion),
    cualEsSuPosicion(Estacion2, Linea2, Posicion).

cualEsSuPosicion(Estacion, Linea, Posicion) :-
    linea(Linea, Estaciones),
    nth1(Posicion, Estaciones, Estacion).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 4 %%%%%%%%%%%%%%%%%%%%%%%%%%

% granCombinacion/1: se cumple para una combinación de más de dos estaciones.

granCombinacion(Estaciones) :-
    combinacion(Estaciones),
    length(Estaciones, Cantidad),
    Cantidad > 2.

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 5 %%%%%%%%%%%%%%%%%%%%%%%%%%

% cuantasCombinan/2: dada una línea, relaciona con la cantidad de estaciones de esa línea 
% que tienen alguna combinación. Por ejemplo, la línea C tiene tres estaciones que combinan 
% (avMayo, diagNorte e independenciaC).

/*
cuantasCombinan(Linea, Cantidad) :-
    linea(Linea, Estaciones),
    member(Estacion, Estaciones),
    combinacion(Combinaciones),
    member(Estacion, Combinaciones),
    length(Combinaciones, Cantidad).
*/

% Feli Solution
cuantasCombinanFeli(Linea, Cantidad) :-
    linea(Linea, _),
    findall(Estacion, combinaPara(Linea, Estacion), Estaciones),
    length(Estaciones, Cuantas).

combinaPara(Linea, Estacion) :-
    estaEn(Linea, Estacion),
    combinacion(Estaciones),
    member(Estacion, Estaciones).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 6 %%%%%%%%%%%%%%%%%%%%%%%%%%

% lineaMasLarga/1: es verdadero para la línea con más estaciones.

lineaMasLarga(Linea) :-
    linea(Linea, Estaciones),
    length(Estaciones, MayorCantidad),
    forall(linea(_, OtrasEstaciones), esMayor(MayorCantidad, OtrasEstaciones)).

esMayor(MayorCantidad, Estaciones) :-
    length(Estaciones, Cantidad),
    MayorCantidad >= Cantidad.

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 7 %%%%%%%%%%%%%%%%%%%%%%%%%%

% viajeFacil/2: dadas dos estaciones, si puedo llegar fácil de una a la otra; 
% esto es, si están en la misma línea, o bien puedo llegar con una sola combinación.

viajeFacil(Estacion1, Estacion2) :-
    estaEn(Linea, Estacion1),
    estaEn(Linea, Estacion2).

/*
viajeFacil(Estacion1, Estacion2) :-
    estaEn(Linea1, Estacion1),
    estaEn(Linea2, Estacion2),
    linea(Linea1, Estaciones1),
    linea(Linea2, Estaciones2),
    combinacion(Combinaciones),
    member(UnaEstacion, Combinaciones),
    member(UnaEstacion, Estaciones1).
*/