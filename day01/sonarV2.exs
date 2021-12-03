{:ok, data} = File.read("input.txt")

readings =
  data
  |> String.split("\n")
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(&elem(&1, 0))

countIncreasingWindows = fn
  {counter, last_window, [a, b, c | rest]}, fun ->
    if a + b + c > last_window do
      fun.({counter + 1, a + b + c, [b | [c | rest]]}, fun)
    else
      fun.({counter, a + b + c, [b | [c | rest]]}, fun)
    end

  {counter, _, _}, _ ->
    counter
end

[a, b, c | rest] = readings

countIncreasingWindows.({0, a + b + c, [b | [c | rest]]}, countIncreasingWindows)
|> IO.inspect()
