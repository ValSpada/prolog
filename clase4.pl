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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REFERENTE A CLASE 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pelicula(elResplandor, thriller).
pelicula(cloverfield, thriller).
pelicula(oppenheimer, drama).
pelicula(toyStory, musical).
pelicula(wallaceYGrommit, cienciaFiccion).

% asesinato(Pelicula, Asesino, Victima).
asesinato(americanPsycho, patrickBateman, paulAllen).
asesinato(americanPsycho, perro, patrickBateman).
asesinato(americanPsycho, patrickBateman, perro).
asesinato(americanPsycho, patrickBateman, perroRabioso).
asesinato(americanPsycho, patrickBateman, gato).
asesinato(elResplandor, jack, elJardinero).

% cancion(pelicula, cancion)
cancion(toyStory, yoSoyTuAmigoFiel).
cancion(toyStory, cambiosExtranios).
cancion(toyStory, noNavegareNuncaMas).

% anio(pelicula, año)
anio(starWarsAMenazaFantasma, 3200).
anio(wallaceYGrommit, 1989).

% segmento(pelicula, segmento).
% segmento(pelicula, casorio).
% segmento(pelicula, funeral).
% segmento(pelicula, pelea).
% segmento(pelicula, mediosHermanos).
segmento(oppenheimer, mediosHermanos).

culebronMexicano(Pelicula) :-
    segmento(Pelicula, casorio),
    segmento(Pelicula, funeral),
    segmento(Pelicula, mediosHermanos),
    segmento(Pelicula, peleas).

futurista(Pelicula) :-
    anio(Pelicula, Anio),
    Anio > 3000.

puroSuspenso(Pelicula) :-
    pelicula(Pelicula, thriller),
    not(asesinato(Pelicula, _, _)).

asesinoSerial(Pelicula, Asesino) :-
    pelicula(Pelicula, thriller),
    asesinato(Pelicula, Asesino, _),
    forall(asesinato(Pelicula, OtroAsesino, _), sonElMismoAsesino(Asesino, OtroAsesino)).

sonElMismoAsesino(Asesino, Asesino).

asesinoSerialBis(Pelicula, Asesino) :-
    pelicula(Pelicula, thriller),
    asesinato(Pelicula, Asesino, _),
    not(hayOtroAsesino(Pelicula, Asesino)).

hayOtroAsesino(Pelicula, Asesino) :-
    asesinato(Pelicula, OtroAsesino, _),
    OtroAsesino \= Asesino.

slasher(Pelicula) :-
    pelicula(Pelicula, thriller),
    asesinatosDe(Pelicula, Cantidad),
    Cantidad >= 5.

asesinatosDe(Pelicula, Cantidad) :- % Predicados auxiliares no necesariamente deben ser inversibles
    % magia para generar lista
    findall(Victima, asesinato(Pelicula, _, Victima), Victimas),
    length(Victimas, Cantidad). % relaciona la lista y la cantidad de elementos de la lista
    
% Sintaxis de lista -> []
% length(Lista, Cantidad). -> Relaciona una lista con su cantidad de elementos. Es totalmente inversible
% member(Elemento, Listas). -> Relaciona si un elemento está en una lista
% sumlist(Lista, Elemento). -> Relaciona una lista y el elemento debe ser el resultado de sumar la lista
% findall(Individuo, Consulta, ListaResultante). -> Individuos que hacen consulta verdadera y mete en lista

% SOLO LISTAS COMPLETAMENTE NECESARIAS -> CANTIDADES, SUMA DE N NUMS, ORDEN

% nth1(posicion, lista, elemento) % Relaciona si un elemento esta en cierta posicion en una lista