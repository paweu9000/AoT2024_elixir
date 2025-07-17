defmodule DayTwo do

    def answer do
      File.read!("input/day_two.txt")
      |> String.split(~r{\n}, trim: true)
      |> Enum.map(fn str ->
        nums = str
                |> String.split(~r{\s}, trim: true)
                |> Enum.map(&String.to_integer/1)

        {_, val, _} =
            Enum.reduce(tl(nums), {hd(nums), :safe, :nothing}, fn i, {num, valid, dec_or_inc} ->
                case valid do
                    :unsafe -> {i, :unsafe, dec_or_inc}
                    :safe ->
                        x = i - num
                        case dec_or_inc do
                            :nothing -> cond do
                                    abs(x) in 1..3 and x > 0 -> {i, :safe, :inc}
                                    abs(x) in 1..3 and x < 0 -> {i, :safe, :dec}
                                    true -> {i, :unsafe, :dec}
                                end
                            :inc -> cond do
                                    abs(x) in 1..3 and x > 0 -> {i, :safe, :inc}
                                    true -> {i, :unsafe, :dec}
                                end
                            :dec -> cond do
                                    abs(x) in 1..3 and x < 0 -> {i, :safe, :dec}
                                    true -> {i, :unsafe, :dec}
                                end
                        end
                end
            end)
        val
      end)
      |> Enum.count(fn x -> x == :safe end)
    end

    def direction([a, b | _]) when a < b, do: :increasing
    def direction([a, b | _]) when a > b, do: :decreasing
    def direction(_), do: :none

    # Count violations of direction and difference
    def violations(levels) do
        base_dir = direction(levels)

        levels
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(0, fn [a, b], acc ->
            diff_violation = abs(a - b) > 3
            dir_violation =
                case base_dir do
                :increasing -> b <= a
                :decreasing -> b >= a
                _ -> true
                end

                if diff_violation or dir_violation, do: acc + 1, else: acc
            end)
    end

    def safe?(levels) do
        violations(levels) == 0
    end

    def safe_with_dampener?(levels) do
        if safe?(levels), do: true, else: try_fixing_with_dampener(levels)
    end

    defp try_fixing_with_dampener(levels) do
        Enum.any?(0..(length(levels) - 1), fn idx ->
            fixed = List.delete_at(levels, idx)
            safe?(fixed)
        end)
    end

    def answer_two do
        reports =
            File.read!("input/day_two.txt")
            |> String.split(~r{\n}, trim: true)
            |> Enum.map(fn str ->
                str
                |> String.split(~r{\s}, trim: true)
                |> Enum.map(&String.to_integer/1)
            end)

        Enum.count(reports, &safe_with_dampener?/1)
    end

end
