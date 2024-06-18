defmodule SmithWaterman do
  @moduledoc """
  Documentation regarding the program goes here.
  """

  require Logger

  @doc """
  Documentation for the function goes here
  """
  @spec score_ratio(String.t(), String.t(), number(), atom()) :: number()
  def score_ratio(subject, query, threshold \\ 0.7, method \\ :lists) do
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
        max_score =
          case method do
            :lists -> score_sw_lists(subject, query, 1, -1, -1)
            :op_lists -> score_sw_optimised_lists(subject, query, 1, -1, -1)
          end

        max_score_ratio = max_score / highest_possible_score

        Logger.debug(
          "Best score of the two is: #{max_score} out of #{highest_possible_score} ratio #{max_score_ratio}"
        )

        max_score_ratio
      end
    end
  end

  # The initial approach using lists and probably a bit of code generation
  @spec score_sw_lists(String.t(), String.t(), number(), number(), number()) :: number()
  defp score_sw_lists(subject, query, match, mismatch, gap) do
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
        # c[i] = max(c[i], t[i-1] + (match if q==subject_char else mismatch))
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

  # Still using lists but trying to optimise a few things from above
  @spec score_sw_optimised_lists(String.t(), String.t(), number(), number(), number()) :: number()
  defp score_sw_optimised_lists(subject, query, match, mismatch, gap) do
    # convert both strings into lowercase list of integers of each character code
    # This conversion isn't strictly required, one could compare any two sequences
    # where the equality operator is supported
    subject = subject |> String.downcase() |> String.to_charlist()
    query = query |> String.downcase() |> String.to_charlist()
    query_length = length(query)

    initial_top_row = List.duplicate(0, query_length + 1)

    # Iterate through every character in the subject
    {max_score, _} =
      subject
      |> Enum.reduce({0, initial_top_row}, fn subject_char, {_max_score, top_row} ->
        # Gap from Top row
        # c[i] = max(0, t[i] + gap)
        current_row = top_row |> Enum.map(fn t -> max(0, t + gap) end)

        # Substitutions from top_left
        # c[i] = max(c[i], t[i-1] + (match if q==subject_char else mismatch))
        # find and sum matches
        top_left =
          top_row
          |> Enum.zip(query)
          |> Enum.map(fn
            {t, ^subject_char} -> t + match
            {t, _} -> max(t + mismatch, 0)
          end)

        # max top_left and current
        [_ | current_tail] = current_row

        current_row = [
          0 | Enum.zip(current_tail, top_left) |> Enum.map(fn {c, t} -> max(c, t) end)
        ]

        # finally gap left
        # c[i] = max(c[i-1] + gap, c[i])
        {current_row, _final_value} =
          Enum.map_reduce(current_row, 0, fn current_value, last_value ->
            v = max(last_value + gap, current_value)
            {v, v}
          end)

        new_max_score = Enum.max(current_row)
        Logger.debug(inspect(current_row))

        {new_max_score, current_row}
      end)

    max_score
  end
end
