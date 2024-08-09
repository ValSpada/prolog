%%%%%%%%%%%%%%%%% MODELAR LA BASE DE CONOCIMIENTOS %%%%%%%%%%%%%%%%%

% Saber disciplina por género
% Variedades de una disciplina

% De natacion sabemos metros y estilo de nado
% Lanzamiento sabemos que lanzan
% Judo sabemos hasta cuantos kilos permiten
% Deportes grupales no más informacion

% PRIMERA SOLUCION -> Predicado por disciplina

% natacion(masculino, 200, espalda).
% natacion(femenino, 1000, pecho).

% lanzamiento(masculino, jabalina).
% lanzamiento(femenino, disco).

% judo(masculino, 90).
% judo(femenino, 70).

% futbol(masculino).
% futbol(femenino).
% voley(femenino).

% Si queremos saber la disciplina por genero, tenemos que armar predicados para cada una; además la aridad
% va difiriendo en cada caso. POr culpa de esta idea tenemos 5 clausulas para cada uno, se repite logica.

% Si queremos saber las variedades por disciplina, usaremos un findall y tendremos uno por disciplina.

% SEGUNDA SOLUCION -> Agrupar Predicados en uno solo

% disciplina(natacion200Espalda, masculino).
% disciplina(natacion1000Espalda, femenino).

% disciplina(lanzamientoJabalina, masculino).
% disciplina(lanzamientoDisco, femenino).

% disciplina(judo90kg, masculino).
% disciplina(judo70kg, femenino).

% disciplina(futbol, masculino).
% disciplina(voley, femenino).

% disciplinaPorGenero(Disciplina, Genero) :-
% disciplina(Disciplina, Genero)

% No se puede saber cuantas variantes de disciplina porque estan mezclados con las competiciones.

% TERCERA SOLUCION -> Listas para las competiciones

% disciplina(natacion, masculino, [espalda200])
% disciplina(natacion, femenino, [espalda1000])

% disciplina(lanzamiento, masculino, [jabalina]).
% disciplina(lanzamiento, femenino, [disco]).

% disciplina(judo, masculino, [90]).
% disciplina(judo, femenino, [70]).

% disciplina(futbol, masculino). % Agregar lista vacia, pero como es vacia daría 0 y no tendria sentido
% disciplina(voley, femenino).

% Para conocer disciplinas por genero tendremos 2 clausulas distintas para los dos tipos de predicados
% de disciplina que tenemos. No es tan grave, pero repite logica.

% Para saber las variedades de disciplinas estás joya por tener las listas, el tema es que el caso de futbol
% y voley no podes hacerlo. El tema es que vamos a tener que sumar el tamaño de todas las longitudes de 
% cada disciplina en cada genero.

% CUARTA SOLUCION -> USAR FUNCTORES

% disciplina(masculino, natacion(200, espalda)) -> FUNCTORES, TIPO DE INDIVIDUO QUE ES COMPUESTO Y NO SON PREDICADOS
% disciplina(femenino, natacion(1000, pecho))

% disciplina(masculino, lanzamiento(jabalina)).
% disciplina(femenino, lanzamiento(disco)).

% disciplina(masculino, judo([90])).
% disciplina(femenino, judo([70])).

% disciplina(masculino, futbol). -> functor vacio pero no tiene sentido, parece una funcion y da igual ponerle ()
% disciplina(femenino, voley).

% INDIVIDUOS SIMPLES: NUMEROS Y ATOMOS
% INDIVIDUOS COMPUESTOS: LISTAS Y FUNCTORES

% Los functores tienen nombre/aridad

% disciplinasPorGenero(G, D) :-
% disciplina(G, D).

% Para la variedad por disciplina, los nombres de los fuctores no es VARIABLE

% QUINTA SOLUCION -> Functores recuperando el nombre

disciplina(natacion, caracteristicas(masculino, 200, espalda)). 
disciplina(natacion, caracteristicas(femenino, 1000, pecho)).

disciplina(lanzamiento, caracteristicas(masculino, jabalina)).
disciplina(lanzamiento, caracteristicas(masculino, bala)).
disciplina(lanzamiento, caracteristicas(femenino, disco)).

disciplina(judo, caracteristicas(masculino, 90)).
disciplina(judo, caracteristicas(masculino, 100)).
disciplina(judo, caracteristicas(masculino, masDe100kg)).
disciplina(judo, caracteristicas(femenino, 70)).
disciplina(judo, caracteristicas(femenino, 78)).
disciplina(judo, caracteristicas(femenino, masDe78kg)).

disciplina(futbol, caracteristicas(masculino)). 
disciplina(futbol, caracteristicas(femenino)).

disciplina(voley, caracteristicas(masculino)).

variedadesPorDisciplina(Disciplina, Cuantas) :-
    disciplina(Disciplina, _),
    findall(Disciplina, disciplina(Disciplina, _), VariantesDisciplina),
    length(VariantesDisciplina, Cuantas). % SOY UNA BESTIA, SALIO DE UNA

% Disciplinas por genero
disciplinaPorGenero(Disciplina, Genero) :-
    disciplina(Disciplina, Caracteristicas), % -> El functor entero es una variable
    generoEnCaracteristicas(Genero, Caracteristicas). % Minimo e indispensable para que esto funcione

% Polimorfismo, trata indistintamente a los functores y trabaja con el correspondiente

generoEnCaracteristicas(Genero, caracteristicas(Genero)). 
generoEnCaracteristicas(Genero, caracteristicas(Genero, _)). % El tener un _ , el hecho sera parcialmente inversible pero no jode
generoEnCaracteristicas(Genero, caracteristicas(Genero, _, _)).