Matrix := Object clone
Matrix val := nil

Matrix dim := method(
  x, y,
  mat  := Matrix clone
  matv := list()
  for(i, 1, x,
    row := list() setSize(y)
    matv append(row)
  )
  mat val := matv
  return mat
)

Matrix set := method(
  x, y, val,
  self val at(x) atPut(y, val)
  return val
)

Matrix get := method(
  x, y,
  res := self val at(x) at(y)
  return res
)

Matrix transpose := method(
  x := self val size
  y := self val at(0) size
  tr := Matrix dim(y, x)
  for(i, 0, x - 1,
    for(j, 0, y - 1,
      tr set(j, i, self get(i, j))
    )
  )
  return tr
)
