{:ok, data} = File.read("input.txt")

lines =
  data
  |> String.split("\n")

number_of_lines = lines |> length
line_length = lines |> List.first() |> String.length()

to_decimal = fn bits ->
  bits
  |> Enum.reverse()
  |> Enum.reduce({0, 1}, fn bit, {acc, n} ->
    if bit == "1" do
      {acc + n, n * 2}
    else
      {acc, n * 2}
    end
  end)
  |> elem(0)
end

sums =
  0..(line_length - 1)
  |> Enum.map(&Enum.map(lines, fn line -> String.at(line, &1) end))
  |> Enum.map(&Enum.count(&1, fn bit -> bit == "1" end))

gamma =
  sums
  |> Enum.map(
    &if &1 > div(number_of_lines, 2) do
      "1"
    else
      "0"
    end
  )
  |> then(to_decimal)

epsilon =
  sums
  |> Enum.map(
    &if &1 <= div(number_of_lines, 2) do
      "1"
    else
      "0"
    end
  )
  |> then(to_decimal)

IO.inspect(gamma * epsilon)
