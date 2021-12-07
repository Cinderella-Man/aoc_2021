{:ok, data} = File.read("input.txt")

initial_fishes =
  data
  |> String.split(",")
  |> Enum.map(&(Integer.parse(&1) |> elem(0)))

1..80
|> Enum.reduce(initial_fishes, fn _, fishes ->
  Enum.map(fishes, fn
    0 -> [6, 8]
    n -> n - 1
  end)
  |> List.flatten()
end)
|> Enum.count()
|> IO.inspect()
