%--------------------------------------------------------------------------------------------------
%Operations for removing classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------
%Remove a class property
rm_class_property(Clase,Propiedad,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,NewProps,Rels,Objetos),OriginalKB,NewKB),
	eliminarAtomosPorPropiedad(Propiedad,Props,Entrada),
	eliminarAtomo([not(Propiedad),_],Entrada,Aux2),
	eliminarAtomo([Propiedad,_],Aux2,NewProps).

%Remove a class property preference
rm_class_property_preference(Clase,Preference,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,NewProps,Rels,Objetos),OriginalKB,NewKB),
	eliminarAtomo([Preference,_],Props,NewProps).

%Remove a class relation
rm_class_relation(Clase,not(Relacion),OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,NewRels,Objetos),OriginalKB,NewKB),
	eliminarAtomosPorPropiedadNegada(Relacion,Rels,NewRels).
rm_class_relation(Clase,Relacion,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,NewRels,Objetos),OriginalKB,NewKB),
	eliminarAtomosPorPropiedad(Relacion,Rels,NewRels).

%Remove a class relation preference
rm_class_relation_preference(Clase,Preference,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,NewRels,Objetos),OriginalKB,NewKB),
	eliminarAtomo([Preference,_],Rels,NewRels).

%Remove an object property
rm_object_property(Objeto,Propiedad,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,NewKB),
	verificarPertenenciaALista([id=>Objeto,Propiedades,Relaciones],Objetos),
	remplazarAtomo([id=>Objeto,Propiedades,Relaciones],[id=>Objeto,NuevasPropiedades,Relaciones],Objetos,NewObjects),
	eliminarAtomosPorPropiedad(Propiedad,Propiedades,Entrada),
	eliminarAtomo([not(Propiedad),_],Entrada,Aux2),
	eliminarAtomo([Propiedad,_],Aux2,NuevasPropiedades).

%REmove an object property preference
rm_object_property_preference(Objeto,Preference,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,NewKB),
	verificarPertenenciaALista([id=>Objeto,Propiedades,Relaciones],Objetos),
	remplazarAtomo([id=>Objeto,Propiedades,Relaciones],[id=>Objeto,NuevasPropiedades,Relaciones],Objetos,NewObjects),
	eliminarAtomo([Preference,_],Propiedades,NuevasPropiedades).

%Remove an object relation
rm_object_relation(Objeto,not(Relacion),OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,NewKB),
	verificarPertenenciaALista([id=>Objeto,Propiedades,Relaciones],Objetos),
	remplazarAtomo([id=>Objeto,Propiedades,Relaciones],[id=>Objeto,Propiedades,RelacionesResultantes],Objetos,NewObjects),
	eliminarAtomosPorPropiedadNegada(Relacion,Relaciones,RelacionesResultantes).
rm_object_relation(Objeto,Relacion,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,NewKB),
	verificarPertenenciaALista([id=>Objeto,Propiedades,Relaciones],Objetos),
	remplazarAtomo([id=>Objeto,Propiedades,Relaciones],[id=>Objeto,Propiedades,RelacionesResultantes],Objetos,NewObjects),
	eliminarAtomosPorPropiedad(Relacion,Relaciones,RelacionesResultantes).

%Remove an object relation preference
rm_object_relation_preference(Objeto,Preference,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,NewKB),
	verificarPertenenciaALista([id=>Objeto,Propiedades,Relaciones],Objetos),
	remplazarAtomo([id=>Objeto,Propiedades,Relaciones],[id=>Objeto,Propiedades,RelacionesResultantes],Objetos,NewObjects),
	eliminarAtomo([Preference,_],Relaciones,RelacionesResultantes).

%Remove an object
rm_object(Objeto,OriginalKB,NewKB) :-
	remplazarAtomo(class(Clase,Madre,Props,Rels,Objetos),class(Clase,Madre,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	verificarPertenenciaALista([id=>Objeto|Propiedades],Objetos),
	eliminarAtomo([id=>Objeto|Propiedades],Objetos,NewObjects),
	delete_relations_with_object(Objeto,TemporalKB,NewKB).
delete_relations_with_object(_,[],[]).
delete_relations_with_object(Objeto,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|ListaResultante]):-
	cancel_relation(Objeto,R,NewR),
	del_relations(Objeto,O,NewO),
	delete_relations_with_object(Objeto,T,ListaResultante).
del_relations(_,[],[]).
del_relations(Objeto,[[id=>N,P,R]|T],[[id=>N,P,NewR]|ListaResultante]):-
	cancel_relation(Objeto,R,NewR),
	del_relations(Objeto,T,ListaResultante).
cancel_relation(_,[],[]).
cancel_relation(Objeto,[[_=>Objeto,_]|T],ListaResultante):-
	cancel_relation(Objeto,T,ListaResultante).
cancel_relation(Objeto,[[not(_=>Objeto),_]|T],ListaResultante):-
	cancel_relation(Objeto,T,ListaResultante).
cancel_relation(Objeto,[H|T],[H|ListaResultante]):-
	cancel_relation(Objeto,T,ListaResultante).

% Remove a class
rm_class(Clase,OriginalKB,NewKB) :-
	eliminarAtomo(class(Clase,Madre,_,_,_),OriginalKB,TemporalKB),
	changeMother(Clase,Madre,TemporalKB,TemporalKB2),
	delete_relations_with_object(Clase,TemporalKB2,NewKB).
changeMother(_,_,[],[]).
changeMother(OldMother,NewMother,[class(C,OldMother,P,R,O)|T],[class(C,NewMother,P,R,O)|N]):-
	changeMother(OldMother,NewMother,T,N).
changeMother(OldMother,NewMother,[H|T],[H|N]):-
	changeMother(OldMother,NewMother,T,N).
