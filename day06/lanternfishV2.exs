{:ok, data} = File.read("input.txt")

initial_fishes =
  data
  |> String.split(",")
  |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  |> Enum.group_by(& &1)
  |> Enum.map(&{elem(&1, 0), length(elem(&1, 1))})

1..256
|> Enum.reduce(initial_fishes, fn day, fishes ->
  Enum.map(fishes, fn
    {0, n} -> [{6, n}, {8, n}]
    {d, n} -> {d - 1, n}
  end)
  |> List.flatten()
  |> Enum.group_by(&elem(&1, 0))
  |> Enum.map(
    &{elem(&1, 0), elem(&1, 1) |> Enum.map(fn tuple -> elem(tuple, 1) end) |> Enum.sum()}
  )
end)
|> Enum.map(&elem(&1, 1))
|> Enum.sum()
|> IO.inspect()
