%1.1
% search2(Elem, List)
search2(X, [X, X | _]).
search2(X, [_ | T]) :- search2(X, T).
% search2(a, [a, b, a, a])

%1.2
% search_two(Elem, List)
search_two(X, [X, Y, X | _]) :- X \= Y.
search_two(X, [_ | T]) :- search_two(X, T).
% search_two(a, [a, a, b, a])

%1.3
% size(List, Size)
size([], 0).
size([_ | T], R) :- size(T, N), R is N + 1.
% size([1, 2, 3], X)

%1.4
% sum(List, Sum)
sum([], 0).
sum([H | T], R) :- sum(T, N), R is N + H.
% sum([1, 2, 3], X)

%1.5
% minMax(List, Max, Min)
minMax([H | T], Max, Min) :- minMax([H | T], H, H, Min, Max).
minMax([], TempMin, TempMax, TempMin, TempMax).
minMax([H | T], TempMin, TempMax, Min, Max) :- H > TempMax, minMax(T, TempMin, H, Min, Max).
minMax([H | T], TempMin, TempMax, Min, Max) :- H =< TempMin, minMax(T, H, TempMax, Min, Max).
% minMax([1,2,3,4,5], X, Y)

%1.6
% sublist(List1, List2)
search(X, [X | _]).
search(X, [_ | T]) :- search(X, T).

sublist([], _).
sublist([H | T], L) :- search(H, L), sublist(T, L).
% sublist([1,2], [5,3,2,1])

%2.1
% dropAny(?Elem, ?List, ?OutList)
dropAny(X, [X | T], T).
dropAny(X, [H | T], [H | T1]) :- dropAny(X, T, T1).
% dropAny(a, [a,b,a,d,e], L)

%2.2
% dropFirst(?Elem, ?List, ?OutList)
dropFirst(X, L, T) :- dropAny(X, L, T), !.
% dropFirst(a, [a,b,a,d,e], L)

% dropLast(?Elem, ?List, ?OutList)
dropLast(X, [H | T], [H | T1]) :- dropLast(X, T, T1), !.
dropLast(X, [X | T], T).
% dropLast(a, [a,b,a,d,e], L)

% dropAll(?Elem, ?List, ?OutList)
dropAll(X, [], []).
dropAll(X, [X | T], L) :- dropAll(X, T, L), !.
dropAll(X, [H | T], [H | T1]) :- dropAll(X, T, T1).
%dropAll(a, [a,b,a,d,e], L)
 
%3.1
% fromList(+List, -Graph)
fromList([_],[]).
fromList([H1, H2 | T], [e(H1, H2) | L]) :- fromList([H2 | T], L).
% fromList([1,2,3], [e(1,2), e(2,3)]).

%3.2
% fromCircList(+List, -Graph)
fromCircList([H | T], G) :- fromCircList([H | T], H, G).
fromCircList([E], H, [e(E, H)]).
fromCircList([E1, E2 | T], H, [e(E1, E2) | L]) :- fromCircList([E2 | T], H, L).
% fromCircList([1,2,3],[e(1,2),e(2,3),e(3,1)]).

%3.3
% outDegree(+Graph, +Node, -Deg)
outDegree([], N, 0).
outDegree([e(H , H1)| T], N, D) :- H \= N, outDegree(T, N, D).
outDegree([e(N, H1) | T], N, D) :- outDegree(T, N, D1), D is D1 + 1.
%outDegree([e(1,2), e(1,3), e(3,2)], 2, 0).
%outDegree([e(1,2), e(1,3), e(3,2)], 3, 1).

%3.4
% dropNode(+Graph, +Node, -OutGraph)
dropNode(G, N, OG) :- dropAll(G, e(N, _), G2), dropAll(G2, e(_, N), GO).

%3.5
% reaching(+Graph, +Node, -List)
reaching(G, N, L) :- findall(N1, member(e(N, N1), G), L).
% reaching([e(1,2),e(1,3),e(2,3)],1,L).
% reaching([e(1,2),e(1,2),e(2,3)],1,L).

%3.6
% nodes(+Graph, -Nodes)
nodes(G, N) :- nodes(G, [], N).
nodes([], L, L).
nodes([e(H, T) | T1], R, L) :- append_one_time(R, H, L1), 
			append_one_time(L1, T, L2), 
			nodes(T1, L2, L).

append_one_time(L, E, L) :- member(E, L), !. 
append_one_time(L, E, L2) :- append(L, [E], L2).
%nodes([e(1,2),e(2,3),e(3,4)],L).

%3.7
% anypath(+Graph, +Node1, +Node2, -ListPath)
anypath(G, N1, N2, [e(N1, N2)]) :- member(e(N1, N2), G).
anypath(G, N1, N2, [e(N1, N3)|P]) :- member(e(N1, N3), G), anypath(G, N3, N2, P).

%3.8
% allreaching(+Graph, +Node, -List)
allreaching(G, N1, L) :- findall(N2, anypath(G, N1, N2, _), L).
% allreaching([e(1,2),e(2,3),e(3,5)],1,[2,3,5]). 

%3.9.1
% grid-like nets
interval(A, B, A).
interval(A, B, X) :- A2 is A + 1, A2 < B, interval(A2, B, X).

neighbour(A, B, A, B2) :- B2 is B + 1 ; B2 is B - 1.
neighbour(A, B, A2, B) :- A2 is A + 1 ; A2 is A - 1.

gridlink(N, M, e((X, Y), (X2, Y2))) :-
	interval(0, N, X),
	interval(0, M, Y),
	neighbour(X, Y, X2, Y2),
	X2 >= 0, Y2 >= 0, X2 < N, Y2 < M.

gridgraph(N, M, G) :- findall(E, gridlink(N, M, E), G).
% gridgraph(3,3,K)

%3.9.2
% Try to generate all paths from a node to another, limiting the maximum number of hops
anypathHops(G, N1, N2, [e(N1, N3)|L], H):-
				member(e(N1, N3), G),
				H > 1, 
				H2 is H-1, 
				anypathHops(G, N3, N2, L, H2).
anypathHops(G, N1, N2, [e(N1, N2)], H) :- member(e(N1, N2), G), !.
% anypathHops([e(1,2), e(1,3), e(2,3)], 1, 3, L, 2)
