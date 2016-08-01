class Person(val name: String)

trait Nice {
  def greet() = println("Howdily doodily.")
}

class Character(override val name: String) extends Person(name) with Nice
