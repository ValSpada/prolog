%%%%%%%%%% BASE DE CONOCIMIENTO %%%%%%%%%%

vuelo(arg845, 30, [escala(rosario,0), tramo(2), escala(buenosAires,0)]).

vuelo(mh101, 95, [escala(kualaLumpur,0), tramo(9), escala(capeTown,2),
tramo(15), escala(buenosAires,0)]).

vuelo(dlh470, 60, [escala(berlin,0), tramo(9), escala(washington,2), tramo(2), escala(nuevaYork,0)]).

vuelo(aal1803, 250, [escala(nuevaYork,0), tramo(1), escala(washington,2),
tramo(3), escala(ottawa,3), tramo(15), escala(londres,4), tramo(1),
escala(paris,0)]).

vuelo(ble849, 175, [escala(paris,0), tramo(2), escala(berlin,1), tramo(3),
escala(kiev,2), tramo(2), escala(moscu,4), tramo(5), escala(seul,2), tramo(3), escala(tokyo,0)]).

vuelo(npo556, 150, [escala(kiev,0), tramo(1), escala(moscu,3), tramo(5),
escala(nuevaDelhi,6), tramo(2), escala(hongKong,4), tramo(2), escala(shanghai,5), tramo(3), escala(tokyo,0)]).

vuelo(dsm3450, 75, [escala(santiagoDeChile,0), tramo(1), escala(buenosAires,2), tramo(7), escala(washington,4), tramo(15), escala(berlin,3), tramo(15), escala(tokyo,0)]).

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% tiempoTotalVuelo/2 : Relaciona un vuelo con el tiempo que lleva en total, 
% contando las esperas en las escalas (y eventualmente en el origen y/o destino) más el tiempo de vuelo.

tiempoTotalVuelo(Vuelo, TiempoTotal) :-
    vuelo(Vuelo, _, Recorrido),
    findall(Tiempo, tiempoCadaTramo(Tiempo, Recorrido), TiempoPorTramo),
    sumlist(TiempoPorTramo, TiempoTotal).

tiempoCadaTramo(Tiempo, Recorrido) :-
    member(Tramo, Recorrido),
    tiempoTramo(Tiempo, Tramo).

tiempoTramo(Tiempo, tramo(Tiempo)).
tiempoTramo(Tiempo, escala(_, Tiempo)).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% escalaAburrida/2 : Relaciona un vuelo con cada una de sus escalas aburridas; una escala es aburrida si hay que esperar mas de 3 horas.

escalaAburrida(Vuelo, Escala) :-
    vuelo(Vuelo, _, Recorrido),
    esAburrida(Escala, Recorrido).

esAburrida(escala(Ciudad, Tiempo), Recorrido) :-
    member(escala(Ciudad, Tiempo), Recorrido),
    Tiempo >= 3.

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% ciudadesAburridas/2 : Relaciona un vuelo con la lista de ciudades de sus escalas aburridas.

ciudadesAburridas(Vuelo, Ciudades) :-
    findall(Ciudad, ciudadAburrida(Vuelo, Ciudad),  Ciudades).

ciudadAburrida(Vuelo, Ciudad) :-
    escalaAburrida(Vuelo, escala(Ciudad, _)).

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% vueloLargo/1: Si un vuelo pasa 10 o más horas en el aire, entonces es un vuelo largo. 
% OJO que dice "en el aire", en este punto no hay que contar las esperas en tierra. 

vueloLargo(Vuelo) :-
    vuelo(Vuelo, _, Recorrido),
    member(tramo(Tiempo), Recorrido),
    Tiempo >= 10.

%%%%%%%%%%       PUNTO 4.5      %%%%%%%%%%

% conectados/2: Relaciona 2 vuelos si tienen al menos una ciudad en común.

conectados(Vuelo1, Vuelo2) :-
    vuelo(Vuelo1, _, Recorrido1),
    vuelo(Vuelo2, _, Recorrido2),
    Vuelo1 \= Vuelo2,
    member(escala(Ciudad1, _), Recorrido1),
    member(escala(Ciudad1, _), Recorrido2).

%%%%%%%%%%        PUNTO 5       %%%%%%%%%%

% bandaDeTres/3: Relaciona 3 vuelos si están conectados, el primero con el segundo, y el segundo con el tercero.

bandaDeTres(Vuelo1, Vuelo2, Vuelo3) :-
    conectados(Vuelo1, Vuelo2),
    conectados(Vuelo2, Vuelo3),
    Vuelo1 \= Vuelo2,
    Vuelo1 \= Vuelo3,
    Vuelo2 \= Vuelo3.

%%%%%%%%%%        PUNTO 6       %%%%%%%%%%

% distanciaEnEscalas/3: Relaciona dos ciudades que son escalas del mismo vuelo y la cantidad de escalas entre las mismas; 
% si no hay escalas intermedias la distancia es 1.  P.ej. París y Berlín están a distancia 1 (por el vuelo BLE849), Berlín 
% y Seúl están a distancia 3 (por el mismo vuelo). No importa de qué vuelo, lo que tiene que pasar es que haya algún vuelo 
% que tenga como escalas a ambas ciudades. Consejo: usar nth1.

distanciaEnEscalas(Distancia, Ciudad1, Ciudad2) :-
    vuelo(_, _, Recorrido),
    findall(Escala, recuperarEscala(Escala, Recorrido), Escalas),
    nth1(Posicion1, Escalas, escala(Ciudad1, _)),
    nth1(Posicion2, Escalas, escala(Ciudad2, _)),
    DistanciaParcial is Posicion1 - Posicion2,
    abs(DistanciaParcial, Distancia).

recuperarEscala(escala(Ciudad, Tiempo), Recorrido) :-
    member(escala(Ciudad, Tiempo), Recorrido).

%%%%%%%%%%        PUNTO 7       %%%%%%%%%%

% vueloLento/1: Un vuelo es lento si no es largo, y además cada escala es aburrida.

vueloLento(Vuelo) :-
    vuelo(Vuelo, _, Recorrido),
    not(vueloLargo(Vuelo)),
    forall(recuperarEscalasIntermedias(Escala, Recorrido), escalaAburrida(Vuelo, Escala)).

recuperarEscalasIntermedias(escala(Ciudad, Tiempo), Recorrido) :-
    recuperarEscala(escala(Ciudad, Tiempo), Recorrido),
    Tiempo \= 0.