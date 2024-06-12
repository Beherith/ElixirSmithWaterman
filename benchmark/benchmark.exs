defmodule SWBenchmark do
  require Logger

  def get_texts(file_name) do
    lines = File.read!("benchmark/#{file_name}.txt")
      |> String.split("\n")
      |> Enum.reject(fn
        "#" <> _ -> true
        "" -> true
        _ -> false
      end)

    count = Enum.count(lines)
    Logger.info("Opened file #{file_name}.txt, extracted #{count} lines for #{count * count} comparisons")
    lines
  end

  def compare_all_lines(lines) do
    lines
    |> Enum.each(fn l1 ->
      lines
      |> Enum.each(fn l2 ->
        SmithWaterman.score_ratio(l1, l2)
      end)
    end)
  end

  def run() do
    Logger.configure(level: :info)

    # Open up our files, read in the lines
    short_lines = get_texts("short_text")
    mixed_lines = get_texts("mixed_text")
    long_lines = get_texts("long_text")

    # Empty line for readability
    IO.puts ""

    Benchee.run(
      %{
        "short" => fn -> compare_all_lines(short_lines) end,
        "mixed" => fn -> compare_all_lines(mixed_lines) end,
        "long" => fn -> compare_all_lines(long_lines) end
      }
    )
  end
end

SWBenchmark.run()
