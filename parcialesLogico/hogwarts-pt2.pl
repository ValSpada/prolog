%%%%%%%%%% BASE DE CONOCIMIENTO %%%%%%%%%%

% accion(quienLaHizo, tipo, accionRealizada, puntos)
accion(harry, mala, andarFueraDeCama, -50).

accion(hermione, mala, tercerPiso, Puntos) :-
    lugarProhibido(tercerPiso, Puntos).

accion(hermione, mala, seccionRestringidaBiblioteca, Puntos) :-
    lugarProhibido(seccionRestringidaBiblioteca, Puntos).

accion(harry, mala, bosque, Puntos) :-
    lugarProhibido(bosque, Puntos).

accion(harry, mala, tercerPiso, Puntos) :-
    lugarProhibido(tercerPiso, Puntos).

% No se si se puede usar, ya que los ejemplos del enunciado son muy marcados
% accion(Mago, mala, LugarProhibido, Puntos) :-
%     lugarProhibido(LugarProhibido, Puntos).

accion(ron, buena, ganarEnAjedrezMagico, 50).
accion(hermione, buena, usoSuIntelectoParaSalvarASusAmigosDeUnaMuerteHorrible, 50).
accion(harry, buena, leGanoAVoldemort, 60).

accion(draco, neutral, mazmorras, 0).

% lugarProhibido(lugar, puntos).
lugarProhibido(bosque, -50).
lugarProhibido(seccionRestringidaBiblioteca, -10).
lugarProhibido(tercerPiso, -75).

% esDe(mago, casa).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% a. Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de 
%    las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).

esBuenAlumno(Mago) :-
    mago(Mago),
    accion(Mago, _, _, _),
    forall(accion(Mago, _, Accion, _), noEsMala(Accion, Mago)).

% AUXILIAR

mago(Mago) :-
    esDe(Mago, _).

noEsMala(Accion, Mago) :-
    not(esMala(Accion, Mago)).

esMala(Accion, Mago) :-
    accion(Mago, mala, Accion, _).

% b. Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.

esRecurrente(Accion) :-
    accion(Mago1, _, Accion, _),
    accion(Mago2, _, Accion, _),
    Mago1 \= Mago2.

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.

puntajeTotal(Casa, PuntajeTotal) :-
    esDe(_, Casa),
    findall(Puntos, puntajeCadaMago(Casa, Puntos), Puntaje),
    flatten(Puntaje, Puntajes),
    sumlist(Puntajes, PuntajeTotal).
    
puntajeCadaMago(Casa, Puntos) :-
    esDe(Mago, Casa),
    findall(Puntuacion, accion(Mago, _, _, Puntuacion), Puntos).


%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una 
% cantidad mayor de puntos que todas las otras.

casaGanadoraDeLaCopa(Casa) :-
    esDe(_, Casa),
    puntajeTotal(Casa, PuntajeTotal),
    forall(puntajeTotal(Casa, Puntajes), esMayor(PuntajeTotal, Puntajes)).

% AUXILIAR

esMayor(Puntaje1, Puntaje2) :-
    Puntaje1 >= Puntaje2.

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que
% nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta 
% y qué profesor la hizo.

% respuestaEnClase(pregunta, dificultad, profesor)
respuestaEnClase(dondeSeEncuentraUnBezoar, 20, snape).
respuestaEnClase(comoHacerLevitarUnaPluma, 25, flitwick).

% darPuntosPorRespuesta(pregunta, puntos)
darPuntosPorRespuesta(Pregunta, Puntos) :-
    respuestaEnClase(Pregunta, Puntos, Profesor),
    Profesor \= snape.

darPuntosPorRespuesta(Pregunta, Puntos) :-
    respuestaEnClase(Pregunta, Dificultad, snape),
    Puntos is Dificultad / 2.

% acciones
accion(hermione, buena, dondeSeEncuentraUnBezoar, Puntos) :-
    darPuntosPorRespuesta(dondeSeEncuentraUnBezoar, Puntos).

accion(hermione, buena, comoHacerLevitarUnaPluma, Puntos) :-
    darPuntosPorRespuesta(comoHacerLevitarUnaPluma, Puntos).
