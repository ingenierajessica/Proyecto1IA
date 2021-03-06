%------------------------------------------------------------
% Main KB Services
%------------------------------------------------------------
%Clase extension
%extensionDeClase(Clase,KB,Objetos):-
%	objetosDeClase(Clase,KB,Objetos).

% Propiedad extension
extensionDeUnaPropiedad(Propiedad,KB,Salida):-
	objetosDeClase(top,KB,ListaDeObjetos),
	obtenerObjetosPorPropiedad(KB,Propiedad,ListaDeObjetos,Objetos),
	eliminarPropiedadesVacias(Objetos,Salida).
obtenerObjetosPorPropiedad(_,_,[],[]).
obtenerObjetosPorPropiedad(KB,Propiedad,[H|T],[H:Valor|ListaResultante]):-
	obtenerValorPropiedad(H,Propiedad,KB,Valor),
	obtenerObjetosPorPropiedad(KB,Propiedad,T,ListaResultante).
eliminarPropiedadesVacias([],[]).
eliminarPropiedadesVacias([_:'no lo se'|T],ListaResultante):-
	eliminarPropiedadesVacias(T,ListaResultante).
eliminarPropiedadesVacias([X:Y|T],[X:Y|ListaResultante]):-
	eliminarPropiedadesVacias(T,ListaResultante).

% Relacion extension
extensionDeUnaRelacion(Relacion,KB,Resultado):-
	objetosDeClase(top,KB,ListaDeObjetos),
	obtenerObjetosPorRelacion(KB,Relacion,ListaDeObjetos,Objetos),
	eliminarPropiedadesVacias(Objetos,Salida),
	obtenerObjetosDeClase(Salida,Resultado,KB).
obtenerObjetosPorRelacion(_,_,[],[]).
obtenerObjetosPorRelacion(KB,Relacion,[H|T],[H:Valor|ListaResultante]):-
	obteneValorRelacion(H,Relacion,KB,Valor),
	obtenerObjetosPorRelacion(KB,Relacion,T,ListaResultante).
obtenerObjetosDeClase([],[],_).
obtenerObjetosDeClase([X:Y|T],[X:Objetos|ListaResultante],KB):-
	verificarClase(Y,KB,yes),
	objetosDeClase(Y,KB,Objetos),
	obtenerObjetosDeClase(T,ListaResultante,KB).
obtenerObjetosDeClase([X:Y|T],[X:[Y]|ListaResultante],KB):-
	obtenerObjetosDeClase(T,ListaResultante,KB).

%ListaClases of individual
clasesDeObjeto(Objeto,KB,ListaClases):-
	verificarObjeto(Objeto,KB,yes),
	obtenerHerencia(Objeto,KB,X),
	obtenerAntecesores(X,KB,Y),
	append([X],Y,ListaClases).
clasesDeObjeto(_,_,'no lo se').

% Propiedades of individual
propiedadesDeObjeto(Objeto,KB,Propiedades):-
	obtenerPropiedadesObjeto(Objeto,KB,Propiedades).

% Relaciones of individual
relacionesDeObjeto(Objeto,KB,ListaRelaciones):-
	verificarObjeto(Objeto,KB,yes),
	obtenerRelacionesObjeto(Objeto,KB,Relaciones),
	traerClasesAObjetos(Relaciones,ListaRelaciones,KB).
relacionesDeObjeto(_,_,'no lo se').
traerClasesAObjetos([],[],_).
traerClasesAObjetos([not(X=>Y)|T],[not(X=>Objetos)|ListaResultante],KB):-
	verificarClase(Y,KB,yes),
	objetosDeClase(Y,KB,Objetos),
	traerClasesAObjetos(T,ListaResultante,KB).
traerClasesAObjetos([X=>Y|T],[X=>Objetos|ListaResultante],KB):-
	verificarClase(Y,KB,yes),
	objetosDeClase(Y,KB,Objetos),
	traerClasesAObjetos(T,ListaResultante,KB).
traerClasesAObjetos([not(X=>Y)|T],[not(X=>[Y])|ListaResultante],KB):-
	traerClasesAObjetos(T,ListaResultante,KB).
traerClasesAObjetos([X=>Y|T],[X=>[Y]|ListaResultante],KB):-
	traerClasesAObjetos(T,ListaResultante,KB).
