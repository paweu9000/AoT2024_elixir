defmodule DayOne do

  defp answer do
    File.read!("input/day_one.txt")
        |> String.split(~r{\n})
        |> Enum.flat_map(fn s -> String.split(s, ~r{\s\s\s}) end)
        |> Enum.with_index()
        |> Enum.reduce({[], []}, fn {el, index}, {odd, even} ->
          if rem(index, 2) == 0 do
            {[String.to_integer(el) | odd], even}
          else
            {odd, [String.to_integer(el) | even]}
          end
        end)
  end

  def answer_one do
    {a, b} = answer()
    a = Enum.sort(a)
    b = Enum.sort(b)

    Enum.zip(a, b)
    |> Enum.reduce(0, fn {left, right}, acc ->
        abs(left - right) + acc
      end)
  end

  def answer_two do
    {a, b} = answer()

    freq = Enum.frequencies(b)

    Enum.map(a, fn el ->
      Map.get(freq, el, 0) * el
    end)
    |> Enum.sum()
  end

end
