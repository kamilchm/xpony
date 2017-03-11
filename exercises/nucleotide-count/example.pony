use "collections"

class Nucleotide
  let char: U8

  new _create(char': U8) =>
    char = char'

  fun hash(): U64 =>
    char.hash()

  fun eq(that: Nucleotide box): Bool =>
    char.eq(that.char)

  fun ne(that: Nucleotide box): Bool =>
    char.ne(that.char)

  fun string(): String =>
    char.string()

primitive Nucleotides
  fun a(): Nucleotide => Nucleotide._create('A')
  fun t(): Nucleotide => Nucleotide._create('T')
  fun c(): Nucleotide => Nucleotide._create('C')
  fun g(): Nucleotide => Nucleotide._create('G')

primitive NucleotideCount
  fun count(strand: String, nucleotide: Nucleotide): U32 =>
    """
    Counts individual nucleotides in a strand.
    """
    var cnt: U32 = 0
    for char in strand.values() do
      if nucleotide.char == char then
        cnt = cnt + 1
      end
    end
    cnt

  fun histogram(strand: String): Map[Nucleotide, U32] =>
    """
    Returns a summary of counts by nucleotide.
    """
    var hist = Map[Nucleotide, U32]()
    hist(Nucleotides.a()) = 0
    hist(Nucleotides.t()) = 0
    hist(Nucleotides.c()) = 0
    hist(Nucleotides.g()) = 0

    for char in strand.values() do
      let possible_nucleotide = Nucleotide._create(char)
      try
        hist(possible_nucleotide) = hist(possible_nucleotide) + 1
      end
    end

    hist
