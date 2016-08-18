/* クイーンの座標が妥当か? */
valid_queen((_, Col)) :-
  Range = [1,2,3,4,5,6,7,8],
  member(Col, Range).

/* 盤面が妥当: 全てのクイーンの座標が妥当 */
valid_board([]).
valid_board([Head|Tail]) :- valid_queen(Head), valid_board(Tail).

/* 全てのクイーンの列の座標のリスト */
cols([], []).
cols([(_, Col)|QueensTail], [Col|ColsTail]) :-
  cols(QueensTail, ColsTail).

/* クイーンがどの斜め線上にあるかのリスト1 */
diags1([] , []).
diags1([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
  Diagonal is Col - Row,
  diags1(QueensTail, DiagonalsTail).

/* クイーンがどの斜め線上にあるかのリスト2 */
diags2([] , []).
diags2([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
  Diagonal is Col + Row,
  diags2(QueensTail, DiagonalsTail).

eight_queens(Board) :-
  /* この段階でクイーンは全て異なる行にあると定まる */
  Board = [(1, _), (2, _), (3, _), (4, _), (5, _), (6, _), (7, _), (8, _)],
  valid_board(Board),

  /* クイーンの列座標のリスト、およびどの斜め線上にあるかのリストを構成 */
  cols(Board, Cols),
  diags1(Board, Diags1),
  diags2(Board, Diags2),

  /* 同じ列と斜め方向に複数のクイーンがないか? */
  fd_all_different(Cols),
  fd_all_different(Diags1),
  fd_all_different(Diags2).
