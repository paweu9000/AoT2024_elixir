defmodule DayThree do

    def answer do
      load_file()
      |> mul()
    end

    def answer_two do
        text = load_file()
        scan(text)
    end

    defp scan(input, enabled \\ :enabled, acc \\ 0)

    defp scan(input, :enabled, acc) do
      case Regex.split(~r/don't\(\)/, input, parts: 2) do
        [valid, rest] -> scan(rest, :disabled, acc + mul(valid))
        [valid] -> acc + mul(valid)
      end
    end

    defp scan(input, :disabled, acc) do
      case Regex.split(~r/do\(\)/, input, parts: 2) do
        [_invalid, rest] -> scan(rest, :enabled, acc)
        [_invalid] -> acc
      end
    end

    defp mul(text) do
      Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, text, capture: :all_but_first)
      |> Enum.reduce(0, fn [a, b], acc ->
        String.to_integer(a) * String.to_integer(b) + acc
      end)
    end

    defp load_file, do: File.read!("input/day_three.txt")
end
