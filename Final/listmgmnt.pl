%----------------------------------------
% List management
%----------------------------------------
%Change all ocurrences of an element X in a list for the value Y
%changeElement(X,Y,InputList,OutputList).
%Example (p,b,[p,a,p,a,y,a],[p,b,p,b,y,b])
changeElement(_,_,[],[]).
changeElement(X,Y,[X|T],[Y|N]):-
	changeElement(X,Y,T,N).
changeElement(X,Y,[H|T],[H|N]):-
	changeElement(X,Y,T,N).
%Delete all ocurrences of an element X in a list
%deleteElement(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])
deleteElement(_,[],[]).
deleteElement(X,[X|T],N):-
	deleteElement(X,T,N).
deleteElement(X,[H|T],[H|N]):-
	deleteElement(X,T,N),
	X\=H.
%Verify if an element X is in a list
%isElement(X,List)
%Example (n,[b,a,n,a,n,a])
isElement(X,[X|_]).
isElement(X,[_|T]):-
	isElement(X,T).
%Convert in a single list a list of lists
%Example ([[a],[b,c],[],[d]],[a,b,c,d]).
append_list_of_lists([],[]).
append_list_of_lists([H|T],X):-
	append(H,TList,X),
	append_list_of_lists(T,TList).
%Delete all elements with a specific property in a property-value list
%deleteAllElementsWithSameProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])
deleteAllElementsWithSameProperty(_,[],[]).
deleteAllElementsWithSameProperty(X,[[X=>_,_]|T],N):-
	deleteAllElementsWithSameProperty(X,T,N).
deleteAllElementsWithSameProperty(X,[H|T],[H|N]):-
	deleteAllElementsWithSameProperty(X,T,N).
%%Single without weights
deleteAllElementsWithSamePropertySingle(_,[],[]).
deleteAllElementsWithSamePropertySingle(X,[X=>_|T],N):-
	deleteAllElementsWithSamePropertySingle(X,T,N).
deleteAllElementsWithSamePropertySingle(X,[H|T],[H|N]):-
	deleteAllElementsWithSamePropertySingle(X,T,N).
%Delete all elements with a specific negated property in a property-value list
%deleteAllElementsWithSameNegatedProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,not(p2=>v2),not(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,not(p3=>v3),p2=>v4,p4=>v4])
deleteAllElementsWithSameNegatedProperty(_,[],[]).
deleteAllElementsWithSameNegatedProperty(X,[[not(X=>_),_]|T],N):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).
deleteAllElementsWithSameNegatedProperty(X,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).
%Single version
deleteAllElementsWithSameNegatedPropertySingle(_,[],[]).
deleteAllElementsWithSameNegatedPropertySingle(X,[not(X=>_)|T],N):-
	deleteAllElementsWithSameNegatedPropertySingle(X,T,N).
deleteAllElementsWithSameNegatedPropertySingle(X,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedPropertySingle(X,T,N).

checa_lista_vacia(X,_):-
	X=[],
	write('No lo se').
checa_lista_vacia(X,1):-
	write(X).
checa_lista_vacia(X,2):-
	updEnv(X).
