defmodule SmithWaterman.MainTest do
  @moduledoc false
  use ExUnit.Case

  describe "lists" do
    test "short" do
      subject = "this is not a test"
      query = "this is indeed a test"
      assert SmithWaterman.score_ratio(subject, query, 0.7) == 0.6111111111111112
    end

    test "mid" do
      subject = "This implementation doesnt perform the traceback, although it could"
      query =
        "the implementation details perform the perform yeah this text is just here to test things"

      assert SmithWaterman.score_ratio(subject, query, 0.7) == 0.13432835820895522
    end

    test "identical" do
      subject = "This implementation doesnt perform the traceback, although it could"
      query = "This implementation doesnt perform the traceback, although it could"
      assert SmithWaterman.score_ratio(subject, query, 0.7) == 1.0
    end
  end

  describe "optimised lists" do
    test "short" do
      subject = "this is not a test"
      query = "this is indeed a test"
      assert SmithWaterman.score_ratio(subject, query, 0.7, :op_lists) == 0.6111111111111112
    end

    test "mid" do
      subject = "This implementation doesnt perform the traceback, although it could"
      query =
        "the implementation details perform the perform yeah this text is just here to test things"

      assert SmithWaterman.score_ratio(subject, query, 0.7, :op_lists) == 0.13432835820895522
    end

    test "identical" do
      subject = "This implementation doesnt perform the traceback, although it could"
      query = "This implementation doesnt perform the traceback, although it could"
      assert SmithWaterman.score_ratio(subject, query, 0.7, :op_lists) == 1.0
    end
  end
end
