{:ok, data} = File.read("input.txt")

readings =
  data
  |> String.split("\n")
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(&elem(&1, 0))

readings
|> Enum.reduce({0, List.first(readings)}, fn next, {counter, last} ->
  if next > last do
    {counter + 1, next}
  else
    {counter, next}
  end
end)
|> IO.inspect()
