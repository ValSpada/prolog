%%%%%%%%%% BASE DE CONOCIMIENTO %%%%%%%%%%

% mago(nombre, statusDeSangre, [caracteristicas], casaQueOdia).
mago(harry,    sangreMestiza, [inteligencia, orgullo, coraje, amistoso], slytherin).
mago(draco,    sangrePura,    [inteligencia, orgullo],                   hufflepuff).
mago(hermione, sangreImpura,  [inteligencia, orgullo, responsabilidad],  ninguna).

% casa(nombreDeLaCasa, caracteristica()).
casa(gryffindor, caracteristica(coraje)).
casa(hufflepuff, caracteristica(amistoso)).
casa(slytherin,  caracteristica(orgullo, inteligencia)).
casa(ravenclaw,  caracteristica(responsabilidad, inteligencia)).

%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% Saber si una casa permite entrar a un mago, lo cual se cumple 
% para cualquier mago y cualquier casa excepto en el caso de 
% Slytherin, que no permite entrar a magos de sangre impura.

permiteEntrar(Casa, Mago) :-
    mago(Mago, _, _, _),
    casa(Casa, _),
    Casa \= slytherin.

permiteEntrar(slytherin, Mago) :-
    mago(Mago, _, _, _),
    esSangrePura(Mago).

% AUXILIAR

esSangrePura(Mago) :-
    mago(Mago, sangrePura, _, _).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Saber si un mago tiene el carácter apropiado para una casa, 
% lo cual se cumple para cualquier mago si sus características
% incluyen todo lo que se busca para los integrantes de esa casa, 
% independientemente de si la casa le permite la entrada.

caracterApropiado(Mago, Casa) :-
    caracteristicasDeUnMago(Mago, CaracteristicasMago),
    casa(Casa, CaracterCasa),
    cumplen(CaracteristicasMago, CaracterCasa).

% AUXILIAR

caracteristicasDeUnMago(Mago, Caracteristicas) :-
    mago(Mago, _, Caracteristicas, _).

cumplen(Caracteristicas, caracteristica(Cualidad1, Cualidad2)) :-
    member(Cualidad1, Caracteristicas),
    member(Cualidad2, Caracteristicas).

cumplen(Caracteristicas, caracteristica(Cualidad)) :-
    member(Cualidad, Caracteristicas).

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

% Determinar en qué casa podría quedar seleccionado un mago sabiendo 
% que tiene que tener el carácter adecuado para la casa, la casa 
% permite su entrada y además el mago no odiaría que lo manden a esa casa. 
% Además Hermione puede quedar seleccionada en Gryffindor, porque 
% al parecer encontró una forma de hackear al sombrero.

puedeQuedarSeleccionado(Mago, Casa) :-
    mago(Mago, _, _, _),
    casa(Casa, _),
    caracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odiaLaCasa(Mago, Casa)).

puedeQuedarSeleccionado(hermione, gryffindor).

% AUXILIAR

odiaLaCasa(Mago, Casa) :-
    mago(Mago, _, _, Casa).

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos
% si todos ellos se caracterizan por ser amistosos y cada uno podría estar en la 
% misma casa que el siguiente. No hace falta que sea inversible, se consultará de
% forma individual.

cadenaDeAmistades(Magos) :-
    esAmistoso(Mago1, Magos),
    esAmistoso(Mago2, Magos),
    compartenCasa(Mago1, Mago2).

% AUXILIAR

esAmistoso(Mago, Magos) :-
    member(Mago, Magos),
    mago(Mago, _, Caracteristicas, _),
    member(amistoso, Caracteristicas).

compartenCasa(Mago1, Mago2) :-
    Mago1 \= Mago2,
    puedeQuedarSeleccionado(Mago1, Casa),
    puedeQuedarSeleccionado(Mago2, Casa).