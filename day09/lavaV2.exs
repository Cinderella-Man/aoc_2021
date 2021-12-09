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

find_basin = fn(grid, path, fun) ->
  {y, x} = List.first(path)
  value = Enum.at(grid, y) |> Enum.at(x)


  IO.inspect(value)

  # IO.inspect(y - 1)
  # IO.inspect(Enum.at(grid, y - 1, []))

  top = Enum.at(grid, y - 1, []) |> Enum.at(x, 9)
  right = Enum.at(grid, y, []) |> Enum.at(x + 1, 9)
  bottom = Enum.at(grid, y + 1, []) |> Enum.at(x + 1, 9)
  left = Enum.at(grid, y, []) |> Enum.at(x - 1, 9)

  IO.inspect('--------------------')
  IO.inspect(top)
  IO.inspect(right)
  IO.inspect(bottom)
  IO.inspect(left)
  IO.inspect('--------------------')

  top_path = if top != 9 &&  top > value && !Enum.member?(path, {y - 1, x}) do
    fun.(grid, [{y - 1, x} | path], fun)
  else
    []
  end

  right_path = if right != 9 && right > value && !Enum.member?(path, {y, x + 1}) do
    fun.(grid, [{y, x + 1} | path], fun)
  else
    []
  end

  bottom_path = if bottom != 9 && bottom > value && !Enum.member?(path, {y + 1, x}) do
    fun.(grid, [{y + 1, x} | path], fun)
  else
    []
  end

  left_path = if left != 9 && left > value && !Enum.member?(path, {y, x - 1}) do
    fun.(grid, [{y, x - 1} | path], fun)
  else
    []
  end

  top_path ++ right_path ++ bottom_path ++ left_path
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
|> Enum.map(&(find_basin.(grid, [&1], find_basin)))
|> IO.inspect()
