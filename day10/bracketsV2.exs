{:ok, data} = File.read("input.txt")

to_points = fn
  "(" -> 1
  "[" -> 2
  "{" -> 3
  "<" -> 4
end

matching = fn
  "(", ")" -> true
  "[", "]" -> true
  "{", "}" -> true
  "<", ">" -> true
  _, _ -> false
end

calculate_score = fn opening_bracket, score ->
  score * 5 + to_points.(opening_bracket)
end

incomplete = fn
  [], [], _ ->
    nil

  [], [_b | _rest] = stack, _ ->
    Enum.reduce(stack, 0, calculate_score)

  line, stack, fun ->
    last_bracket = List.first(stack)
    next_bracket = List.first(line)

    if Enum.member?(["(", "{", "[", "<"], next_bracket) do
      fun.(line |> Enum.drop(1), [next_bracket | stack], fun)
    else
      if matching.(last_bracket, next_bracket) do
        fun.(line |> Enum.drop(1), stack |> Enum.drop(1), fun)
      else
        nil
      end
    end
end

data
|> String.split("\n")
|> Enum.map(&String.graphemes/1)
|> Enum.map(&incomplete.(&1, [], incomplete))
|> Enum.filter(& &1)
|> Enum.sort()
|> then(&Enum.at(&1, div(length(&1), 2)))
|> IO.inspect()
