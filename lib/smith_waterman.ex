defmodule SmithWaterman do
  @moduledoc """
  Documentation regarding the program goes here.
  """

  require Logger

  @doc """
  Documentation for the function goes here
  """
  @spec score_ratio(String.t(), String.t(), number()) :: number()
  def score_ratio(subject, query, threshold \\ 0.7) do
    subject_length = String.length(subject)
    query_length = String.length(query)
    highest_possible_score = subject_length

    if query_length < highest_possible_score * threshold do
      Logger.debug("Bailing because query is too short")
      0
    else
      if query_length > subject_length * 10 do
        Logger.debug("Bailing because query is too long")
        0
      else
        max_score = score_sw(subject, query, 1, -1, -1)
        max_score_ratio = max_score / highest_possible_score

        Logger.debug(
          "Best score of the two is: #{max_score} out of #{highest_possible_score} ratio #{max_score_ratio}"
        )

        max_score_ratio
      end
    end
  end

  @spec score_sw(String.t(), String.t(), number(), number(), number()) :: number()
  defp score_sw(subject, query, match, mismatch, gap) do
    # convert both strings into lowercase list of integers of each character code
    # This conversion isn't strictly required, one could compare any two sequences
    # where the equality operator is supported
    subject = String.downcase(subject) |> String.to_charlist() |> Enum.map(& &1)
    query = String.downcase(query) |> String.to_charlist() |> Enum.map(& &1)
    query_length = length(query)

    top = Enum.map(0..query_length, fn _ -> 0 end)

    # Iterate through every character in the subject
    {max_score, _} =
      Enum.reduce(subject, {0, top}, fn subject_char, {_max_score, top} ->
        # Gap from Top row
        # c[i] = max(0, t[i] + gap)
        current = Enum.map(top, fn t -> max(0, t + gap) end)

        # Substitutions from top_left
        # c[i] = max(c[i], t[i-1] + (match if q==subject char else mismatch))
        # find and sum matches
        top_left =
          Enum.zip(Enum.take(top, query_length), query)
          |> Enum.map(fn {t, q} ->
            if q == subject_char, do: t + match, else: max(t + mismatch, 0)
          end)

        # max top_left and current
        [_ | current_tail] = current
        current = [0 | Enum.zip(current_tail, top_left) |> Enum.map(fn {c, t} -> max(c, t) end)]

        # finally gap left
        # c[i] = max(c[i-1] + gap, c[i])
        {current, _} =
          Enum.map_reduce(current, 0, fn c, acc -> {max(acc + gap, c), max(acc + gap, c)} end)

        new_max_score = Enum.max(current)
        Logger.debug(inspect(current))

        {new_max_score, current}
      end)

    max_score
  end
end
