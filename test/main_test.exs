defmodule SmithWaterman.MainTest do
  @moduledoc false
  use ExUnit.Case

  describe "limited testing" do
    testa = "this is not a test"
    testb = "this is indeed a test"
    assert SmithWaterman.score_ratio(testa, testb, 0.7) == 0.6111111111111112

    testa = "This implementation doesnt perform the traceback, although it could"
    testb =
      "the implementation details perform the perform yeah this text is just here to test things"
    assert SmithWaterman.score_ratio(testa, testb, 0.7) == 0.13432835820895522

    # Test identical
    testa = "This implementation doesnt perform the traceback, although it could"
    testb = "This implementation doesnt perform the traceback, although it could"
    assert SmithWaterman.score_ratio(testa, testb, 0.7) == 1.0
  end
end
