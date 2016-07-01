fact(1, 0).
fact(Fact, N) :- N > 0, N1 is N - 1, fact(PrevFact, N1), Fact is PrevFact * N.

fib(0, 0).
fib(1, 1).
fib(N, Fib) :- N > 0, N1 is N - 1, N2 is N - 2 , fib(N1, Fib1), fib(N2, Fib2), Fib is Fib1 + Fib2.
