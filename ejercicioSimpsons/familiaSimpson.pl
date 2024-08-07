%%%%%%%%%%%%%%%%%% Hechos conocidos %%%%%%%%%%%%%%%%%%

padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge, maggie).
madreDe(selma, ling).

%%%%%%%%%%%%%%%%%% Punto 1 %%%%%%%%%%%%%%%%%%

% tieneHijo/1
tieneHijo(Progenitor) :-
    padreDe(Progenitor, _).

tieneHijo(Progenitora) :-
    madreDe(Progenitor, _).

% hermanos/2
hermanos(UnHermano, OtroHermano) :-
    compartenPadre(UnHermano, OtroHermano),
    compartenMadre(UnHermano, OtroHermano).

% medioHermanos/2
medioHermanos(UnMedioHermano, OtroMedioHermano) :-
    compartenPadre(Hermano1, Hermano2),
    not(compartenMadre(Hermano1, Hermano2)).

medioHermanos(Hermano1, Hermano2) :-
    compartenMadre(Hermano1, Hermano2),
    not(compartenPadre(Hermano1, Hermano2)).

% Auxiliar
compartenPadre(Hermano1, Hermano2) :-
    padreDe(Progenitor, Hermano1),
    padreDe(Progenitor, Hermano2),
    Hermano1 \= Hermano2.

compartenMadre(Hermano1, Hermano2) :-
    madreDe(Progenitora, Hermano1),
    madreDe(Progenitora, Hermano2),
    Hermano1 \= Hermano2.

% tioDe/2
tioDe(Tio, Personaje) :-
    padreDe(Progenitor, Personaje),
    hermanos(Progenitor, Tio).

tioDe(Tio, Personaje) :-
    madreDe(Progenitora, Personaje),
    hermanos(Progenitora, Tio).

tioDe(Tio, Personaje) :-
    padreDe(Progenitor, Personaje),
    hermanos(Progenitor, Pareja),
    pareja(Pareja, Tio).

tioDe(Tio, Personaje) :-
    padreDe(Progenitor, Personaje),
    hermanos(Progenitor, Pareja),
    pareja(Tio, Pareja).

tioDe(Tio, Personaje) :-
    madreDe(Progenitor, Personaje),
    hermanos(Progenitor, Pareja),
    pareja(Tio, Pareja).

tioDe(Tio, Personaje) :-
    madreDe(Progenitor, Personaje),
    hermanos(Progenitor, Pareja),
    pareja(Pareja, Tio).

% Auxiliar: Pareja/2
pareja(UnPersonaje, OtroPersonaje):-
    padreDe(UnPersonaje, Hijo),
    madreDe(OtroPersonaje, Hijo).

% abueloMultiple/1
abueloMultiple(Abuelo) :-
    nietoDe(Abuelo, UnNieto),
    nietoDe(Abuelo, OtroNieto),
    UnNieto \= OtroNieto.

% Auxiliar: nietoDe/2
nietoDe(Abuelo, Nieto) :-
    padreDe(Abuelo, Progenitor),
    padreDe(Progenitor, Nieto).

nietoDe(Abuela,Nieto) :-
    madreDe(Abuela, Progenitor),
    madreDe(Progenitor, Nieto).

%%%%%%%%%%%%%%%%%% Punto 2 %%%%%%%%%%%%%%%%%%

% descendiente/2
descendiente(Descendiente, Ancestro) :-
    progenitor(Ancestro, Descendiente).

descendiente(Descendiente, AncestroMaximo) :-
    progenitor(AncestroMaximo, Ancestro),
    descendiente(Descendiente, Ancestro).

progenitor(Padre, Hijo) :-
    padreDe(Padre, HIjo).

progenitor(Madre, Hijo) :-
    madreDe(Madre, HIjo).