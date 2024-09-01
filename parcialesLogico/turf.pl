%%%%%%%%%%        PUNTO 1       %%%%%%%%%%

% jockey(nombre, altura(cm), peso(kg)).

jockey(valdivieso, 155, 52).
jockey(leguisamo , 161, 49).
jockey(lezcano   , 149, 50).
jockey(baratucci , 153, 55).
jockey(falero    , 157, 52).

% preferencia(caballo, jockeyPreferencia).

preferencia(botafogo, Jockey) :-
    jockey(Jockey, _, Peso),
    Peso < 52.
preferencia(botafogo, baratucci).
preferencia(oldMan, Jockey) :-
    jockey(Jockey, _, _),
    atom_length(Jockey, Letras),
    Letras > 7.
preferencia(energica, Jockey) :-
    jockey(Jockey, _, _),
    not(preferencia(botafogo, Jockey)).
preferencia(matBoy, Jockey) :-
    jockey(Jockey, Altura, _),
    Altura > 170.

caballo(Caballo) :-
    preferencia(Caballo, _).
caballo(matBoy).

% stud(caballeriza, jockey).

stud(elTute     , valdivieso).
stud(elTute     ,     falero).
stud(lasHormigas,    lezcano).
stud(elCharabon ,  baratucci).
stud(elCharabon ,  leguisamo).

% ganoPremio(caballo, premio).

ganoPremio(botafogo,     granPremioNacional).
ganoPremio(botafogo,    granPremioRepublica).
ganoPremio(oldMan  ,    granPremioRepublica).
ganoPremio(oldMan  , campeonatoPalermoDeOro).
ganoPremio(matBoy  ,    granPremioCriadores).

%%%%%%%%%%        PUNTO 2       %%%%%%%%%%

% Queremos saber quiénes son los caballos que prefieren a más de un jockey.

prefierenMasDeUnJockey(Caballo) :-
    preferencia(Caballo, Jockey1),
    preferencia(Caballo, Jockey2),
    Jockey1 \= Jockey2.

%%%%%%%%%%        PUNTO 3       %%%%%%%%%%

noPrefierenCaballeriza(Caballo, Stud) :-
    caballo(Caballo),
    stud(Stud, _),
    forall(stud(Stud, Jockey), noPrefiere(Caballo, Jockey)).

noPrefiere(Caballo, Jockey) :-
    jockey(Jockey, _, _),
    not(preferencia(Caballo, Jockey)).

%%%%%%%%%%        PUNTO 4       %%%%%%%%%%

% Queremos saber quiénes son les jockeys "piolines", que son las personas 
% preferidas por todos los caballos que ganaron un premio importante.

jockeyPiolin(Jockey) :-
    jockey(Jockey, _, _),
    forall(ganoPremioImportante(Caballo), preferencia(Caballo, Jockey)).

ganoPremioImportante(Caballo) :-
    caballo(Caballo),
    ganoPremio(Caballo, Premio),
    premioImportante(Premio).

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

%%%%%%%%%%        PUNTO 5       %%%%%%%%%%

% Queremos saber, dada una apuesta y el resultado de una carrera de caballos si la apuesta resultó ganadora.

apuestaGanadora(ganadorPorUnCaballo(Caballo), Resultado) :-
    salePrimero(Caballo, Resultado).

apuestaGanadora(ganadorPorSegundoCaballo(Caballo), Resultado) :-
    salePrimeroOSegundo(Caballo, Resultado).

apuestaGanadora(exacta(Caballo1, Caballo2), Resultado) :-
    salePrimero(Caballo1, Resultado),
    saleSegundo(Caballo2, Resultado).

apuestaGanadora(imperfecta(Caballo1, Caballo2), Resultado) :-
    salePrimeroOSegundo(Caballo1, Resultado),
    salePrimeroOSegundo(Caballo2, Resultado).

salePrimero(Caballo, Resultado) :-
    nth1(1, Resultado, Caballo).

saleSegundo(Caballo, Resultado) :-
    nth1(2, Resultado, Caballo).

salePrimeroOSegundo(Caballo, Resultado) :-
    salePrimero(Caballo, Resultado).

salePrimeroOSegundo(Caballo, Resultado) :-
    saleSegundo(Caballo, Resultado).

%%%%%%%%%%        PUNTO 6       %%%%%%%%%%

% Queremos saber qué caballos podría comprar una persona que tiene preferencia por caballos de un color específico. 
% Tiene que poder comprar por lo menos un caballo para que la solución sea válida. 

colorCaballo(botafogo,          color(negro)).
colorCaballo(oldMan  ,         color(marron)).
colorCaballo(energica,    color(gris, negro)).
colorCaballo(matBoy  , color(marron, blanco)).
colorCaballo(yatasto , color(blanco, marron)).

puedeComprar(Caballos, Color) :-
    coloresPosbiles(Color),
    findall(Caballo, esDeEseColor(Caballo, Color), Caballos).
    
esDeEseColor(Caballo, Color) :-
    colorCaballo(Caballo, Colores),
    tieneEseColor(Color, Colores).

coloresPosbiles(Color) :-
    esDeEseColor(_, Color).

tieneEseColor(Color, color(Color)).
tieneEseColor(Color, color(Color, _)).
tieneEseColor(Color, color(_, Color)).
