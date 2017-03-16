use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestEmptyDNAString)
    test(_TestRepetitiveCytosine)
    test(_TestCountOnlyThymine)
    test(_TestEmptyDNAHasNoNucleotides)
    test(_TestRepetitiveOneNucleotide)
    test(_TestCountsAllNucleotides)

class iso _TestEmptyDNAString is UnitTest
  fun name(): String => "empty dna string has no adenine"
  fun apply(h: TestHelper) =>
    h.assert_eq[U32](0, NucleotideCount.count("", A))

class iso _TestRepetitiveCytosine is UnitTest
  fun name(): String => "repetitive cytosine gets counted"
  fun apply(h: TestHelper) =>
    h.assert_eq[U32](5, NucleotideCount.count("CCCCC", C))

class iso _TestCountOnlyThymine is UnitTest
  fun name(): String => "count only thymine"
  fun apply(h: TestHelper) =>
    h.assert_eq[U32](1, NucleotideCount.count("GGGGGTAACCCGG", T))

class iso _TestEmptyDNAHasNoNucleotides is UnitTest
  fun name(): String => "empty dna string has no nucleotides"
  fun apply(h: TestHelper) =>
    let histogram = NucleotideCount.histogram("")

    _H.assert_nucleotide_count(h, histogram, A, 0)
    _H.assert_nucleotide_count(h, histogram, T, 0)
    _H.assert_nucleotide_count(h, histogram, C, 0)
    _H.assert_nucleotide_count(h, histogram, G, 0)

class iso _TestRepetitiveOneNucleotide is UnitTest
  fun name(): String => "repetitive sequence has only guanine"
  fun apply(h: TestHelper) =>
    let histogram = NucleotideCount.histogram("GGGGGGGG")

    _H.assert_nucleotide_count(h, histogram, A, 0)
    _H.assert_nucleotide_count(h, histogram, T, 0)
    _H.assert_nucleotide_count(h, histogram, C, 0)
    _H.assert_nucleotide_count(h, histogram, G, 8)

class iso _TestCountsAllNucleotides is UnitTest
  fun name(): String => "counts all nucleotides"
  fun apply(h: TestHelper) =>
    let histogram = NucleotideCount.histogram("AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC")

    _H.assert_nucleotide_count(h, histogram, A, 20)
    _H.assert_nucleotide_count(h, histogram, T, 21)
    _H.assert_nucleotide_count(h, histogram, C, 12)
    _H.assert_nucleotide_count(h, histogram, G, 17)

primitive _H
  fun assert_nucleotide_count(h: TestHelper, histogram: MapIs[Nucleotide, U32],
                              nucleotide: Nucleotide, count: U32) =>
    try
      h.assert_eq[U32](count, histogram(nucleotide),
          "Wrong " + nucleotide().string() + " nucleotide count")
    else
      h.fail("Nissing " + nucleotide().string() + " nucleotide in histogram")
    end
