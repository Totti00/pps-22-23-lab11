%1.1
% search2(Elem, List)
search2(X, [X, X | _]).
search2(X, [_ | T]) :- search2(X, T).
% search2(a, [a, b, a, a])

%1.2
% search_two(Elem, List)
search_two(X, [X, Y, X | _]) :- X \= Y.
search_two(X, [_ | T]) :- search_two(X, T).
%search_two(a, [a, a, b, a])

%1.3
%size(List, Size)
size([], 0).
size([_ | T], R) :- size(T, N), R is N + 1.
%size([1, 2, 3], X)

%1.4
% sum(List, Sum)
sum([], 0).
sum([H | T], R) :- sum(T, N), R is N + H.
%sum([1, 2, 3], X)

%1.5
% max(List, Max, Min)


