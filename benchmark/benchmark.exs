defmodule SWBenchmark do
  require Logger

  @methods ~w(lists op_lists)a

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

  def compare_all_lines(lines, method) do
    lines
    |> Enum.each(fn l1 ->
      lines
      |> Enum.each(fn l2 ->
        SmithWaterman.score_ratio(l1, l2, 0.7, method)
      end)
    end)
  end

  def run() do
    Logger.configure(level: :info)

    # Open up our files, read in the lines
    short_lines = get_texts("short_text")
    mixed_lines = get_texts("mixed_text")
    long_lines = get_texts("long_text")

    # Empty line for readability, sleep to ensure the line is _after_ the logs
    :timer.sleep(20)
    IO.puts ""

    Benchee.run(
      @methods
      |> Map.new(fn m ->
        {m, fn lines -> compare_all_lines(lines, m) end}
      end),
      inputs: %{
        "Short" => short_lines,
        "Mixed" => mixed_lines,
        "Long" => long_lines
      }
    )
  end
end

SWBenchmark.run()
