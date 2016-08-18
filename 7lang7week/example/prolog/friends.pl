/* likes(a, b): "a likes b" */
likes(wallace, cheese).
likes(grommit, cheese).
likes(wendolene, sheep).

/* friend(X, Y): "If X is not equal to Y, and both X and Y like same things, then X and Y are friends." */
friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).
