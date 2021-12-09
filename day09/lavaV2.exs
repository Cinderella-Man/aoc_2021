{:ok, data} = File.read("input.txt")

find_numbers = fn {lines, index} ->
  Enum.zip([
    # index
    0..((Enum.at(lines, 1) |> length) - 1),
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
  |> Enum.filter(&(Tuple.to_list(&1) |> Enum.drop(2) |> Enum.min() > elem(&1, 1)))
  |> Enum.map(&({index, elem(&1, 0)}))
end

find_basin = fn(grid, coords) ->

end

grid = data
|> String.split("\n")
|> Enum.map(&(String.graphemes(&1) |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)))

low_points = grid
|> then(&[List.duplicate(9, List.first(&1) |> length) | &1])
|> then(&(&1 ++ [List.first(&1)]))
|> Enum.chunk_every(3, 1, :discard)
|> Enum.with_index()
|> Enum.map(find_numbers)
|> List.flatten()

low_points
|> Enum.map(find_basin)
|> IO.inspect()