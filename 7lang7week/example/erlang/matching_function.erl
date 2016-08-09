-module(matching_function).
-export([number/1]).
-export([match/1]).

number(one) -> 1;
number(two) -> 2;
number(three) -> 3.

match({error, Message}) -> "error: " ++ Message;
match(success) -> "success".
