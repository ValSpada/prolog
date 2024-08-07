% pelicula/2 (pelicula, genero)
pelicula(losVengadores, accion).
pelicula(laLaLand, musical).
pelicula(americanPsycho, thriller).
pelicula(starWarsAMenazaFantasma , cienciaFiccion).
pelicula(mentirasVerdaderas, comedia).

% critica/2 (pelicula, estrellas).
critica(losVengadores, 3).
critica(losVengadores, 4).
critica(laLaLand, 5).
critica(americanPsycho, 4).
critica(starWarsAMenazaFantasma, 1).
critica(mentirasVerdaderas, 2). % Atomo -> Texto

% trabajaEn/2 (pelicula, actor/actriz)
trabajaEn(losVengadores, robertDownyJr).
trabajaEn(losVengadores, chrisEvans).
trabajaEn(laLaLand, emmaStone).
trabajaEn(laLaLand, ryanGosling).
trabajaEn(americanPsycho, christianBale).
trabajaEn(starWarsAMenazaFantasma, nataliePortman).
trabajaEn(mentirasVerdaderas, arnoldSchwarzenegger).
trabajaEn(mentirasVerdaderas, jamieLeeCurtis).
trabajaEn(mentirasVerdaderas, tomArnold).

% premio/2 (actor/actriz, premio)
premio(emmaStone, mejorActriz).
premio(nataliePortman, mejorActriz).
premio(christianBale, mejorBatman).
premio(arnoldSchwarzenegger, mejorMusculo).

% Todo lo que vimos hasta ahora era de existencia, si alguno cumplia las clausulas planteadas.

% Para todo x : P(x) => Q(x) -> Esto lo transformamos en algo más sencillo
% Para todo x : -P(x) V Q(x) -> Se acerca bastante
% No existe x : -(P(x) Y -Q(x))


% imperdible: no hay actores que no hayan ganado algún premio
imperdible(Pelicula) :-
    pelicula(Pelicula, _), % Limitamos el conjunto
    not(actoresQueNoGanaronAlgunPremio(Pelicula)).

% Mas sencillo pensar por el sí y después negarlo.
actoresQueNoGanaronAlgunPremio(Pelicula) :-
    trabajaEn(Pelicula, Actor), % P(X)
    not(premio(Actor, _)). % -Q(X)

% Vamos a lo más sencillo ahora
% imperdible: TODOS los actores/actricez ganaron algun premio
% forall/2 (antedente, consecuente) -> Predicado de orden superior, recibe otros predicados para consultar

imperdible2(Pelicula) :-
    pelicula(Pelicula, _), % Unificamos la pelicula, y preguntará por cada pelicula por separado
    forall(trabajaEn(Pelicula, Actor), premio(Actor, _)). % (Antecedente, Consecuente)

% Para todo actor, existe una peli: trabajaEn(peli, Actor) => premio(Actor, _)

% Algoritmo: backtracking
% En algunos casos queremos tratar las relaciones como TODOS o UNO
% Variables sin unificar -> Actuan como "TODOS"
% Variables unificadas -> Actuan como "UNO"

% actorDramatico/1 : Si todas las pelis son de drama
actorDramatico(Actor) :-
    trabajaEn(_, Actor),
    forall(trabajaEn(Pelicula, Actor), esDeDrama(Pelicula)).

esDeDrama(Pelicula) :-
    pelicula(Pelicula, drama).

% aclamada: todas las criticas de LA peli son 4 o 5
aclamada(Pelicula):-
    pelicula(Pelicula, _),
    forall(critica(Pelicula, Estrellas), Estrellas >= 4).

% between(2,3,x) -> Los dos primeros son las cotas y el valor a consultar

% pochoclera: Criticas son 2 o 3
pochoclera(Pelicula) :-
    pelicula(Pelicula, _),
    forall(critica(Pelicula, Estrellas), criticaPochoclera(Estrellas)).

criticaPochoclera(2).
criticaPochoclera(3).

% mala: Cuando todas sus criticas tienen una estrella
mala(Pelicula) :-
    pelicula(Pelicula, _),
    forall(critica(Pelicula, Estrellas), criticaMala(Estrellas)).

criticaMala(1). % Usar el = es sinonimo de pecado

% En el not, si no viene ligada la consulta variable => Es como preguntar por _
% El forall trae problemas de inversibilidad, si las variables no vienen ligadas es como preguntar por _, al menos una variable libre

% Selectivo: todas las pelis en las que actua un arctor/actriz son imperdibles

selectivo(Actor) :-
    trabajaEn(_, Actor),
    forall(trabajaEn(Pelicula, Actor), imperdible(Pelicula)).

% Unánime: Todas las criticas de la peli son el mismo puntaje
unanime(Pelicula) :-
    critica(Pelicula, Puntaje),
    forall(critica(Pelicula, OtroPuntaje), sonIguales(OtroPuntaje, Puntaje)).

sonIguales(Puntaje, Puntaje).

% mejor crítica: La crítica más alta para una peli

mejorCritica(Pelicula, MejorCritica) :-
    critica(Pelicula, MejorCritica),
    forall(critica(Pelicula, OtraCritica), MejorCritica >= OtraCritica).
