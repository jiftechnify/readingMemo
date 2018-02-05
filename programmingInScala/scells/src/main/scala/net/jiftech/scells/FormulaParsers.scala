package net.jiftech.scells

import scala.util.parsing.combinator._

// 入力された文字列を解析して、対応する数式オブジェクトに変換
object FormulaParsers extends RegexParsers {
  def ident: Parser[String] = """[a-zA-Z_]\w*""".r
  def decimal: Parser[String] = """-?\d+(\.\d*)?""".r

  // セル(座標): 英字1字 + 数字の列
  def cell: Parser[Coord] =
    """[A-Za-z]\d+""".r ^^ { s =>
      val column = s.charAt(0).toUpper - 'A'
      val row = s.substring(1).toInt
      Coord(row, column)
    }
  // セル範囲: <座標>:<座標>
  def range: Parser[Range] =
    cell ~ ":" ~ cell ^^ {
      case c1 ~ ":" ~ c2 => Range(c1, c2)
    }

  def number: Parser[Number] =
    decimal ^^ (d => Number(d.toDouble))

  // 関数適用: <識別子> ( <式>* )
  def application: Parser[Application] =
    ident ~ "(" ~ repsep(expr, ",") ~ ")" ^^ {
      case f ~ "(" ~ ps ~ ")" => Application(f, ps)
    }
  // 式: 範囲、座標、数値、関数適用
  def expr: Parser[Formula] =
    range | cell | number | application

  // テキスト: 先頭が等号でない任意の文字列
  def textual: Parser[Textual] =
    """[^=].*""".r ^^ Textual

  // SCellsが扱うすべての値を認識するパーサ
  def formula: Parser[Formula] =
    number | textual | "=" ~> expr

  // 文字列を解析して対応するFormulaオブジェクトに変換
  def parse(input: String): Formula =
    parseAll(formula, input) match {
      case Success(e, _) => e
      case f: NoSuccess => Textual("[" + f.msg + "]")
    }
}
