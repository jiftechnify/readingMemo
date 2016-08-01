class Person(firstName: String){
  println("Outer counstructor")
  def this(firstName: String, lastName: String){
    this(firstName)
    println("Inner counstructor")
  }
  def talk() = println("Hi")
}

val bob = new Person("Bob")
val bobTate = new Person("Bob", "Tate")
println(bobTate.lastName)
