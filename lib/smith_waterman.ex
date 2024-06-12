defmodule SmithWaterman do
  @moduledoc """
  Documentation regarding the program goes here.
  """

  def scoreRatio(subject, query, threshold \\ 0.7, verbose \\ false) do
    subject_length = String.length(subject)
    query_length = String.length(query)
    highest_possible_score = subject_length

    if query_length < highest_possible_score * threshold do
      if verbose, do: IO.puts("Bailing because query is too short")
      0.0
    else
      if query_length > subject_length * 10 do
        if verbose, do: IO.puts("Bailing because query is too long")
        0.0
      else
        max_score = scoreSW(subject, query, 1,-1,-1, verbose)
        max_score_ratio = max_score / highest_possible_score
        if verbose, do: IO.puts("Best score of the two is: #{max_score} out of #{highest_possible_score} ratio #{max_score_ratio}")
        max_score_ratio
      end
    end
  end

  defp scoreSW(subject, query,  match \\ 1, mismatch \\ -1, gap \\ -1, verbose \\ false) do
    # convert both strings into lowercase list of integers of each character code
    # This conversion isnt strictly required, one could compare any two sequences where the equality operator is supported
    subject = String.downcase(subject) |> String.to_charlist()  |>  Enum.map(&(&1))
    query = String.downcase(query) |> String.to_charlist()  |>   Enum.map(&(&1))
    query_length = length(query)

    top = Enum.map(0..query_length, fn _ -> 0 end)

    # Iterate through every character in the subject
    {max_score, _} = Enum.reduce(subject, {0, top}, fn subject_char, {max_score, top} ->

      # Gap from Top row
      # c[i] = max(0, t[i] + gap)
      current = Enum.map(top, fn t -> max(0,t+gap) end)

      # Substitutions from topleft
      # c[i] = max(c[i], t[i-1] + (match if q==subject char else mismatch))
      topleft = Enum.zip(Enum.take(top, query_length), query) |> Enum.map( fn {t,q} -> if q == subject_char, do: t+match, else: max(t+mismatch,0) end) # find and sum matches

      # max topleft and current
      [ _ | currtail] = current
      current = [0 | Enum.zip(currtail, topleft) |> Enum.map(fn {c,t} -> max(c,t) end)]

      # finally gap left
      # c[i] = max(c[i-1] + gap, c[i])
      {current, _} = Enum.map_reduce(current, 0, fn c, acc -> {max(acc+gap,c), max(acc+gap,c)} end)

      new_max_score = Enum.max(current)
      if verbose, do: IO.inspect(current)

      {new_max_score, current}
    end)

    max_score

  end
end
