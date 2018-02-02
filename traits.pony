trait Named
  fun name(): String => "Bob"

class Bob is Named

class Larry
  fun name(): String => "Larry"

interface HasName
  fun name(): String
