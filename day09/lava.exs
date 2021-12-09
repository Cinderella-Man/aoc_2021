{:ok, data} = File.read("input.txt")

find_numbers = fn lines ->
  Enum.zip([
    # candidates
    Enum.at(lines, 1),
    # top
    Enum.at(lines, 0),
    # right
    (Enum.at(lines, 1) |> Enum.drop(1)) ++ [10],
    # bottom
    Enum.at(lines, 2),
    # left
    [10 | Enum.at(lines, 1)]
  ])
  |> Enum.filter(&(Tuple.to_list(&1) |> Enum.drop(1) |> Enum.min() > elem(&1, 0)))
  |> Enum.map(&elem(&1, 0))
end

data
|> String.split("\n")
|> Enum.map(&(String.graphemes(&1) |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)))
|> then(&[List.duplicate(10, List.first(&1) |> length) | &1])
|> then(&(&1 ++ [List.first(&1)]))
|> Enum.chunk_every(3, 1, :discard)
|> Enum.map(find_numbers)
|> List.flatten()
|> Enum.map(&(&1 + 1))
|> Enum.sum()
|> IO.inspect()
