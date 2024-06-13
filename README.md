# Smith-Waterman algorithm

```elixir
SmithWaterman.scoreSW("string1", "string2", match \\ 1, mismatch \\ -1, gap \\ -1)
```
This local alignment algorithm calculates the score of the most similar alignment of all possible substrings of two strings, including gaps and mismatches. 
The default scoring scheme is:
 - Match +1
 - Mismatch -1
 - Gap -1

It is optimal, but `O(|N| * |M|)` in time complexity, and `O(|N|)` in memory complexity. 

The implementation does not provide a traceback of the optimal alignment.


```elixir
SmithWaterman.score_ratio("string1", "string2", threshold \\ 0.7) 
```
The `SmithWaterman.score_ratio/3` function calculates the highest possible score of two alignments, and if the threshold is achieveable based on the length of the strings, it runs the `SmithWaterman.scoreSW/5` function to calculate the ratio of similarity as a number between 0 and 1.
If the similarity threshold cannot be achieved due to the lengths of the stings, it just returns 0.


# Example usage
```elixir
SmithWaterman.scoreRatio("my first string", "my second string")
> 0.4666666666666667

SmithWaterman.scoreRatio("my slightly longer string with more information in it", "my slightly longer string with more information in it random chars")
> 1.0
```

## Installation
First add to your dependencies in `mix.exs`.
```elixir
def deps do
  [
    {:teiserver, "~> 0.0.5"}
  ]
end
```

## Possible Improvements
[ ] Compare any two lists of items where the equality operator is supported.
