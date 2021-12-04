{:ok, data} = File.read("input.txt")

readings =
  data
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(fn [action, n] -> [action, Integer.parse(n) |> elem(0)] end)

updatePosition = fn
  ["forward", n], {horizontal, depth} -> {horizontal + n, depth}
  ["down", n], {horizontal, depth} -> {horizontal, depth + n}
  ["up", n], {horizontal, depth} -> {horizontal, depth - n}
end

readings
|> Enum.reduce({0, 0}, updatePosition)
|> then(fn {horizontal, depth} -> horizontal * depth end)
|> IO.inspect()
