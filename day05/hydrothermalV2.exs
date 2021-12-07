{:ok, data} = File.read("input.txt")

data
|> String.split("\n")
|> Enum.map(&String.split(&1, " -> "))
|> Enum.map(&Enum.map(&1, fn coord -> String.split(coord, ",") end))
|> Enum.map(
  &Enum.map(&1, fn [x, y] ->
    [Integer.parse(x) |> elem(0), Integer.parse(y) |> elem(0)]
  end)
)
|> Enum.map(fn
  [[x, y1], [x, y2]] -> y1..y2 |> Enum.map(&[x, &1])
  [[x1, y], [x2, y]] -> x1..x2 |> Enum.map(&[&1, y])
  [[x1, y1], [x2, y2]] -> x1..x2 |> Enum.zip(y1..y2) |> Enum.map(&[elem(&1, 0), elem(&1, 1)])
end)
|> Enum.reduce([], &(&1 ++ &2))
|> Enum.group_by(& &1)
|> Enum.filter(fn {_, lst} -> length(lst) > 1 end)
|> Enum.count()
|> IO.inspect()
