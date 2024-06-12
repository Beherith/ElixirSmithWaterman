defmodule SmithWaterman.MainTest do
  use ExUnit.Case

  describe "limited testing" do
    testa = "this is not a test"
    testb = "this is indeed a test"

    assert SmithWaterman.scoreRatio(testa, testb, 0.7, false)


    # Example usage
    seqa = "This implementation doesnt perform the traceback, although it could"
    seqb = "the implementation details perform the perform yeah this text is just here to test things"
    assert SmithWaterman.scoreRatio(seqa, seqb, 0.7, false)

    # {time,res} = :timer.tc(SmithWaterman, :scoreRatio, [seqa, seqb, 0.7, false])
    # IO.puts("Microsenconds #{time} #{res}")

  end
end
