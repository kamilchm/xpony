use "collections"

primitive A fun apply(): U8 => 'A'
primitive T fun apply(): U8 => 'T'
primitive C fun apply(): U8 => 'C'
primitive G fun apply(): U8 => 'G'

type Nucleotide is (A | T | C | G)

primitive Nucleotides
  fun fromChar(char: U8): Nucleotide ? =>
    match char
    | 'A' => A
    | 'T' => T
    | 'C' => C
    | 'G' => G
    else
      error
    end

primitive NucleotideCount
  fun count(strand: String, nucleotide: Nucleotide): U32 =>
    """
    Counts individual nucleotides in a strand.
    """
    var cnt: U32 = 0
    for char in strand.values() do
      if nucleotide() == char then
        cnt = cnt + 1
      end
    end
    cnt

  fun histogram(strand: String): MapIs[Nucleotide, U32] =>
    """
    Returns a summary of counts by nucleotide.
    """
    var hist = MapIs[Nucleotide, U32]()
    hist(A) = 0
    hist(T) = 0
    hist(C) = 0
    hist(G) = 0

    for char in strand.values() do
      try
        let n = Nucleotides.fromChar(char)
        hist(n) = hist(n) + 1
      end
    end

    hist
