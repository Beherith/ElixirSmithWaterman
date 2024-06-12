# Smith-Waterman algorithm
Description of algorithm and purpose goes here

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

