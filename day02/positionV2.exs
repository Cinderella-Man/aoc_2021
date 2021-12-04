{:ok, data} = File.read("input.txt")

readings =
  data
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(fn [action, n] -> [action, Integer.parse(n) |> elem(0)] end)

updatePosition = fn
  ["forward", n], {horizontal, depth, aim} -> {horizontal + n, depth + n * aim, aim}
  ["down", n], {horizontal, depth, aim} -> {horizontal, depth, aim + n}
  ["up", n], {horizontal, depth, aim} -> {horizontal, depth, aim - n}
end

readings
|> Enum.reduce({0, 0, 0}, updatePosition)
|> then(fn {horizontal, depth, _aim} -> horizontal * depth end)
|> IO.inspect()
