{:ok, data} = File.read("input.txt")

initial_positions =
  data
  |> String.split(",")
  |> Enum.map(&(Integer.parse(&1) |> elem(0)))

min_position = Enum.min(initial_positions)
max_position = Enum.max(initial_positions)

cost_of_all_positions =
  min_position..max_position
  |> Enum.map(fn final_position ->
    {final_position, initial_positions |> Enum.map(&abs(&1 - final_position)) |> Enum.sum()}
  end)

cost_of_all_positions
|> Enum.reduce(cost_of_all_positions |> List.first(), fn {pos, cost}, {best_pos, best_cost} ->
  if cost < best_cost do
    {pos, cost}
  else
    {best_pos, best_cost}
  end
end)
|> IO.inspect()
