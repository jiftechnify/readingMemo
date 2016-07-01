concatinate([], List, List).
concatinate([Head|Tail1], List2, [Head|Tail3]) :-
  concatinate(Tail1, List2, Tail3).

my_reverse([], []).
my_reverse([Head|Tail], Res) :- concatinate(my_reverse(Tail), [Head], Res).
