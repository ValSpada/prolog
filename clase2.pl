% Aridad = Parametros/Argumentos del predicado

% vuelo/3
vuelo(aep, scl, 150000).
vuelo(scl, aep, 160000).

vuelo(eze, gru, 200000).
vuelo(gru, eze, 190000).

vuelo(aep, eze, 10000).
vuelo(eze, aep, 14000).

% costoIdaVuelta/3
costoIdaVuelta(Costo, Ida, Vuelta) :-
    vuelo(Ida, Vuelta, CostoIda),
    vuelo(Vuelta, Ida, CostoVuelta),
    Costo is CostoIda + CostoVuelta. % A la derecha del IS hay funciones, pero hay que respetar al paradigma

% Predicado is/2 (significa es) y es solo para cuentas

% millasParaIdaYVuelta/3
% Cada milla son 100 pesos.
millasParaIdaYVuelta(Millas, Ida, Vuelta) :-
    costoIdaVuelta(Costo, Ida, Vuelta),
    Millas is Costo / 100.

% vueloBarato/2
% Es barato si sale menos de 200000
vueloBarato(Ida, Vuelta) :-
    costoIdaVuelta(Costo, Ida, Vuelta),
    Costo < 200000. % Operadores logicos funcionan igual.

% diferenciaEnPesos/3
% Cuanta diferencia entre ida y vuelta

diferenciaEnPesos(Diferencia, Ida, Vuelta) :-
    vuelo(Ida, Vuelta, CostoIda),
    vuelo(Vuelta, Ida, CostoVuelta),
    DiferenciaParcial is CostoIda - CostoVuelta, % abs(valorAConsultar, valorAbsoluto)
    abs(DiferenciaParcial, Diferencia).

% El orden de los factores altera el producto, en la suma por ejemplo cuando unificas perdes las variables.

% Problemas de Inversibilidad (Estos fallan):
% Todos los valores a la derecha de is deben estar unificados = Que se hayan consultado antes
% En comparaciones (<,>,=<,>=,\=), debemos unificar las variables a consultar.

% Cuando podemos hacer consultas variables a todas las variables de un predicado, es totalmente inversible
% Cuando podemos hacer consultas variables a alguna de las variables del predicado, parcialmente inversible

aeropuerto(aep, buenosAires).
aeropuerto(eze, buenosAires).
aeropuerto(scl, santiago).
aeropuerto(gru, saoPaulo).
aeropuerto(mdq, marDelPlata).

ciudad(buenosAires, argentina).
ciudad(marDelPlata, argentina).
ciudad(santiago, chile).
ciudad(saoPaulo, brasil).

% inaccesibleEnAvion/1 -> A una ciudad no se puede llegar en avion
inaccesibleEnAvion(Ciudad) :-
    ciudad(Ciudad, _), % Para solucionar problemas de inversibilidad, vamos a restringir con un PREDICADO GENERADOR
    not(accesibleEnAvion(Ciudad)). % Problema de inversibilidad -> Verificar bien las consultas que hacemos

accesibleEnAvion(Ciudad) :-
    aeropuerto(Aeropuerto, Ciudad),
    vuelo(_, Aeropuerto, _).

% Para valores concretos, funciona pero no para temas de consultas

% Problemas de Inversibilidad (Estos no fallan, triste):
% not: No genera valores. Tenemos infinitos valores que permiten hacer verdadera una consulta

% imposibleSalir/1 -> Ciudad tiene vuelo de ida pero no de vuelta
imposibleSalir(Ciudad) :-
    accesibleEnAvion(Ciudad),
    not(tieneVueloDeVuelta(Ciudad)).

tieneVueloDeVuelta(Ciudad) :-
    aeropuerto(Aeropuerto, Ciudad),
    vuelo(Aeropuerto, _, _).

% vueloNacional/2 -> dos aeropuertos, sale y llega a argentina
vueloNacional(Aeropuerto1, Aeropuerto2) :-
    aeropuertoArgentino(Aeropuerto1),
    aeropuertoArgentino(Aeropuerto2).

aeropuertoArgentino(Aeropuerto) :-
    aeropuerto(Aeropuerto, Ciudad),
    ciudad(Ciudad, argentina).

% Se busca que todos los enunciados sean totalmente inversibles.