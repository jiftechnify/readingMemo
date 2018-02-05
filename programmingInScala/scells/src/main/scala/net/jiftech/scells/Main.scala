package net.jiftech.scells
import scala.swing._

object Main extends SimpleSwingApplication {
  // トップレベルウィンドウの設定
  def top = new MainFrame {
    title = "ScalaSheet"
    contents = new Spreadsheet(100, 26)
  }
}
