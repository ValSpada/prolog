/*
Como pensar el paradigma, ejemplo:

goku es un guerrero z         P
guerrero z son poderosos      P=>Q
goku no es poderoso           -Q

LO QUE NO SE PUEDE PROBAR, ES FALSO. SI LO PODES PROBAR, ES VERDADERO.

El codigo es una base de conocimiento y por consola realizamos preguntas para que responda lo que queremos.
Lo importante es saber hacer las preguntas.

Podemos definir la base de conocimiento en: Hechos (premisas verdaderas) y Regla (premisas combinadas)

Retomando ejemplo:
todos los guerreros z son poderosos
goku es un guerrero z
por lo tanto, goku es poderoso
*/

% guerreroZ/1 -> Aridad 1, se trata de un INDIVIDUO cuando tiene un unico elemento.
guerreroZ(goku). % El hecho(elementos que lo componen)
guerreroZ(krillin). % Dentro de cada hecho, los elementos se llaman atomos y no se requiere de una sintaxis especial.
guerreroZ(gohan). 
guerreroZ(feli). % Conjunto por extensión

% guerreroZ(goku, gohan). -> Este hecho es distinto al anterior debido a la aridad.

/*
Para recargar archivos, es con make .

REALIZAR CONSULTAS EN CONSULTAS
guerreroZ(goku). -> Tal persona es un guerreroZ
guerreroZ(fede). -> FALSO, AL NO SETAR DEMOSTRADO
guerreroZ(2). -> Consulta individual

Nace el concepto de Universo Cerrado: Lo que no puede deducir de la base de hechos, no se cumple.

Si alguien es guerreroZ:
guerreroZ(_) -> Generico, preguntas por un algo | Consulta existencial: Existe alguno, no importa quien
*/


% guerreroZ(guerrero) => esPoderoso(guerrero). Esto es discreta
% esPoderoso/1 es un predicado con dos clausulas
esPoderoso(Guerrero):-    % Regla -> Depende de otra cosa
    guerreroZ(Guerrero).  % Definición en prolog, Guerrero es una variable. La variable toma un valor.

esPoderoso(superman). % Para hacer un OR, se agrega otra clausula directamente.

% ?- esPoderoso(yo)
/*
esPoderoso(yo):-
    guerreroZ(yo). Al tomar el valor, consulta en la base de conocimiento y como es falso, entonces esto es falso
*/

% Las relaciones engloban las funciones.

% CONSULTAS VARIABLES -> Las consultas reciben variables, recibimos las multiples respuestas
/*
?- guerreroZ(Quien).
Quien = goku;
Quien = krillin;
Quien = gohan;
Quien = feli.
*/

% Una cosa es devolver y otra cosa es mostrar. Los predicados relacionan.
% Minuscula se representan individuos: atomos(feli,goku), numeros y un desconocido 
% Mayuscula se representan variables.

% Hechos son aquellos que se cumplen y listo.
% Reglas que se cumplen en base a las condiciones.

% Consulta individual -> Pregunto por un individuo especifico
% Consulta existencial -> Si alguno lo cumple
% Consulta variables -> Quienes cumplen la consulta (los que hacen que sea verdadero)


%%%%%%%%%%%%%%%%%%%%% OLIMPIADAS - EJEMPLO %%%%%%%%%%%%%%%%%%%%%

% armaRutina/2
% armaRutina(Atleta, Entrenador)
armaRutina(goku, goku).              % Relación entre Atleta y Entrenador
armaRutina(jordan, timGrover).
armaRutina(kobe, timGrover).
armaRutina(fede, chatGPT).
armaRutina(jordan, bugsBunny).

/*
CONSULTAS
?- armaRutina(goku, Entrenador).
Entrenador = goku.

?- armaRutina(Atleta, goku).
Atleta = goku.

?- armaRutina(Atleta,Entrenador).
Devuelve las relaciones definidas
*/

esSuPropioCoach(Persona):-
    armaRutina(Persona,Persona). % Unificación -> Reemplaza con el valor que corresponde cada vez que encuentra la variable

hizoTrampa(Persona):-
    armaRutina(Persona,chatGPT). % El tipo lo da uno

laburador(Entrenador):- % No asume conmutatividad, por ende realiza todas las consultas con todas las combinaciones posibles
    armaRutina(Persona,Entrenador), % Comas para dar mas condiciones
    armaRutina(OtraPersona,Entrenador),
Persona \= OtraPersona. % Que sean distintas variables. \= significa distinto y tambien es un predicado (\=)/2

medalla(basquet, argentina, 2004, oro).
medalla(basquet, italia, 2004, plata).

ganador(Representante,Disciplina):-
    medalla(Disciplina, Representante, _, oro).

perdedor(Representante,Disciplina):-
    medalla(Disciplina, Representante, _, Medalla),
    Medalla \= oro.

% Consulta con dos condiciones se usa una coma de por medio. Es la &&

laCabra(lebron, basquet).

fraude(Atleta):-
    laCabra(Atleta,Disciplina),
not(ganador(Atleta, Disciplina)). % Agarramos un predicado y negamos lo de adentro | Predicado de orden superior (Consultas)
