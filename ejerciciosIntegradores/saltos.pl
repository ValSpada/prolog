%%%%%%%%%% BASE DE CONOCIMIENTO %%%%%%%%%%

puntajes(hernan, [3, 5, 8, 6, 9]).
puntajes(julio,  [9, 7, 3, 9, 10, 2]).
puntajes(ruben,  [3, 5, 3, 8, 3]).
puntajes(roque,  [7, 10, 10]).

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% Qué puntaje obtuvo un competidor en un salto, p.ej: qué puntaje obtuvo Hernán en el salto 4 (respuesta: 6).

puntajeEnSalto(Nombre, Salto, Puntaje) :-
    puntajes(Nombre, Puntajes),
    nth1(Salto, Puntajes, Puntaje).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Si un competidor está descalificado o no. Un competidor está descalificado si hizo más de 5 saltos. En el
% ejemplo, Julio está descalificado.

estaDescalificado(Competidor) :-
    puntajes(Competidor, Puntajes),
    length(Puntajes, CantidadSaltos),
    CantidadSaltos > 5.

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Si un competidor clasifica a la final. Un competidor clasifica a la final si la suma de sus puntajes es
% mayor o igual a 28, o si tiene dos saltos de 8 o más puntos.

clasificaALaFinal(Competidor) :-
    puntajes(Competidor, Puntajes),
    not(estaDescalificado(Competidor)),
    sumlist(Puntajes, Resultado),
    Resultado >= 28.

clasificaALaFinal(Competidor) :-
    puntajes(Competidor, Puntajes),
    not(estaDescalificado(Competidor)),
    findall(PuntajeMayor, puntajesMayoresAOcho(PuntajeMayor, Puntajes), PuntajesMayores),
    length(PuntajesMayores, Cantidad),
    Cantidad >= 2.

puntajesMayoresAOcho(Puntaje, Puntajes) :-
    member(Puntaje, Puntajes),
    Puntaje >= 8.
