-module(double).
-export([double_all/1]).
-export([square_all/1]).

double_all([]) -> [];
double_all([First|Rest]) -> [First + First|double_all(Rest)].

square_all([]) -> [];
square_all([First|Rest]) -> [First * First|square_all(Rest)].
