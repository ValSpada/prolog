% Punto 1

% todosSiguenA\1 | Regla
todosSiguenA(Rey) :- 
   personaje(Rey),
   % not((personaje(Personaje), not(sigueA(Personaje, Rey)))). % Se podria haber delegado y además
   % además esta mal porque si preguntas por todos podrias emplear un forall
   forall(personaje(Personaje), sigueA(Personaje, Rey)).

% sigueA\2 | 3 hechos
% sigueA(Alguien, Alguien). % Aca va a preguntar si alguien se sigue a si mismo
sigueA(lyanna, jon).
sigueA(jorah, daenerys).

% Punto 2


% Errores de expresividad
baresCopados(Ciudad, Bares) :-
    findall(Bar, (puntoDeInteres(bar(CantVarCer), Ciudad), CantVarCer > 4), Bares). % Se podria haber delegado y poner _
    
museosCopados(Ciudad, Museos) :-
    findall(Museo, puntoDeInteres(museo(cienciasNaturales), Ciudad), Museos). % Poner _
    
estadiosCopados(Ciudad, Estadios) :-
    findall(Estadio, (puntoDeInteres(estadio(Cap), Ciudad), Cap > 40000), Estadios). % Se podria haber delegado y poner _
    
% LOGICA REPETIDA EN DARME LISTA, LONGITUD Y SUMAR. NO HAY POLIMORFISMO
ciudadInteresante(Ciudad) :-
    antigua(Ciudad),
    baresCopados(Ciudad, Bares),
    museosCopados(Ciudad, Museos),
    estadiosCopados(Ciudad, Estadios),
    length(Bares, CantidadBares),
    length(Museos, CantidadMuseos),
    length(Estadios, CantidadEstadiosCopados),
    CantidadLugaresCopados is CantidadBares + CantidadMuseos + CantidadEstadios,
    CantidadLugaresCopados > 10.
    
% CORRECCION
ciudadInteresante(Ciudad) :-
    antigua(Ciudad),
    lugaresCopados(Ciudad, Lugares),
    length(Lugares, Cuantos),
    Cuantos > 10.

lugaresCopados(Ciudad, Lugares) :-
    findall(Lugar, lugarCopado(Lugar, Ciudad), Lugares).

lugarCopado(Lugar, Ciudad) :-
    puntoDeInteres(Lugar, Ciudad),
    esCopado(Lugar).

esCopado(bar(VariedadCervezas)) :-
    VariedadCervezas > 4.

esCopado(museo(cienciasNaturales)).

esCopado(estadio(Capacidad)) :-
    Capacidad > 140000.

% Punto 3

inFraganti(Delito, Delincuente) :-
    cometio(Delito, Delincuente), % PREGUNTA SI HAY TESTIGOS, SOLO PREGUNTAR SI EXISTE UN TESTIGO
    findall(Testigo, testigo(Delito, Testigo), Testigos),
    length(Testigos, Cantidad),
    Cantidad > 0.

% Punto 4

% No genera nada y por ende no hay inversibilidad
viejoMaestro(Pensador) :-
    pensamiento(Pensador, _), % Con esto tendremos inversibilidad
    forall(pensamiento(Pensador, Pensamiento), llegaANuestrosDias(Pensamiento)).
    
% PUNTO 5

numeroDeLaSuerte(Persona, Numero) :-
    diaDelNacimiento(Persona, Numero).
    
numeroDeLaSuerte(joaquin, Numero) :- % Este hardcodeo de virgo momo, para eso hacete numeroDeLaSuerte(joaquin, 2)
    Numero is 2.
    
% Punto 6

obraMaestra(Compositor, Obra) :-
    compositor(Compositor, Obra),
    forall(movimiento(Obra, Movimiento), cumpleCondiciones(Movimiento)). % NOMBRE DE MIERDA, siempre buscamos condiciones

% Punto 7

puedeComer(analia, Comida) :-
    ingrediente(Comida, _),
    forall(ingrediente(Comida, Ingrediente), (not(contieneCarne(Ingrediente)), 
    not(contieneHuevo(Ingrediente)),
    not(contieneLeche(Ingrediente)))). % Y esa no delegacion de virgo momo, pasar toda esa gran condicion a un predicado

comidaVegana(Ingrediente) :-
    not(contieneCarne(Ingrediente)),
    not(contieneHuevo(Ingrediente)),
    not(contieneLeche(Ingrediente))
    
puedeComer(evaristo, asado).    

% Punto 8

costoEnvio(Paquete, PrecioTotal) :-
    findall(PrecioItem, precioItemPaquete(Paquete, PrecioItem), Precios),
    sumlist(Precios, PrecioTotal).
    
precioItemPaquete(Paquete, Precio) :-
    itemPaquete(Paquete, libro(Precio)).
    
precioItemPaquete(Paquete, Precio) :-
    itemPaquete(Paquete, mp3(_, Duracion)),
    Precio is Duracion * 0.42.  
    
precioItemPaquete(Paquete, PrecioOferta) :-
    itemPaquete(Paquete, productoEnOferta(_, PrecioOferta)).
    