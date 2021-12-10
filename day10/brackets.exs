{:ok, data} = File.read("input.txt")

to_points = fn
  ")" -> 3
  "]" -> 57
  "}" -> 1197
  ">" -> 25137
end

matching = fn
  "(", ")" -> true
  "[", "]" -> true
  "{", "}" -> true
  "<", ">" -> true
  _, _ -> false
end

corrupted = fn
  [], _, _ ->
    nil

  line, stack, fun ->
    last_bracket = List.first(stack)
    next_bracket = List.first(line)

    if Enum.member?(["(", "{", "[", "<"], next_bracket) do
      fun.(line |> Enum.drop(1), [next_bracket | stack], fun)
    else
      if matching.(last_bracket, next_bracket) do
        fun.(line |> Enum.drop(1), stack |> Enum.drop(1), fun)
      else
        next_bracket
      end
    end
end

data
|> String.split("\n")
|> Enum.map(&String.graphemes/1)
|> Enum.map(&corrupted.(&1, [], corrupted))
|> Enum.filter(& &1)
|> Enum.map(to_points)
|> Enum.sum()
|> IO.inspect()
