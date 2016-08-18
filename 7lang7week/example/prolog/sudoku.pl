/* 行･列･ブロックが妥当(全ての数字が異なる)かを判定する */
valid([]).
valid([Head|Tail]) :-
  fd_all_different(Head),
  valid(Tail).

/* Puzzleに与えられた数独を解きSolutionにバインドする */
sudoku(Puzzle, Solution) :-
  /* 入力された問題とその解はユニファイできなければならない */
  Solution = Puzzle,
  /* リストの要素とマス目の名前の対応付け。またリストの全要素は1から4の数字でなければならない */
  Puzzle = [S11, S12, S13, S14,
            S21, S22, S23, S24,
            S31, S32, S33, S34,
            S41, S42, S43, S44],
  fd_domain(Solution, 1, 4),

  /* 行の定義(ex.1行目は11,12,13,14のマス目からなる) */
  Row1 = [S11, S12, S13, S14],
  Row2 = [S21, S22, S23, S24],
  Row3 = [S31, S32, S33, S34],
  Row4 = [S41, S42, S43, S44],

  /* 列の定義 */
  Col1 = [S11, S21, S31, S41],
  Col2 = [S12, S22, S32, S42],
  Col3 = [S13, S23, S33, S43],
  Col4 = [S14, S24, S34, S44],

  /* ブロックの定義 */
  Square1 = [S11, S12, S21, S22],
  Square2 = [S13, S14, S23, S24],
  Square3 = [S31, S32, S41, S42],
  Square4 = [S33, S34, S43, S44],

  /* 全ての行･列･ブロックが妥当でなければならない */
  valid([Row1, Row2, Row3, Row4,
         Col1, Col2, Col3, Col4,
         Square1, Square2, Square3, Square4]).
