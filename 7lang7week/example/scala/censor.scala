trait Censor {
  val nonHonorific = Map("Shoot" -> "Pucky", "Darn" -> "Beans")

  def censor(words: List[String]) = words.map(word => nonHonorific.getOrElse(word, word))
}

class Person

class CensorPerson extends Person with Censor
