{:ok, data} = File.read("input.txt")

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

convert_to_number = fn
  ["a", "b", "c", "e", "f", "g"] -> 0
  ["c", "f"] -> 1
  ["a", "c", "d", "e", "g"] -> 2
  ["a", "c", "d", "f", "g"] -> 3
  ["b", "c", "d", "f"] -> 4
  ["a", "b", "d", "f", "g"] -> 5
  ["a", "b", "d", "e", "f", "g"] -> 6
  ["a", "c", "f"] -> 7
  ["a", "b", "c", "d", "e", "f", "g"] -> 8
  ["a", "b", "c", "d", "f", "g"] -> 9
end

resolve_number = fn codes ->
  one = Enum.find(codes, &(length(&1) == 2))
  seven = Enum.find(codes, &(length(&1) == 3))
  eight = Enum.find(codes, &(length(&1) == 7))
  four = Enum.find(codes, &(length(&1) == 4))

  sub_of_a =
    Enum.frequencies(seven ++ one)
    |> Enum.filter(fn {_key, n} -> n == 1 end)
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_g =
    codes
    |> Enum.filter(&(length(&1) == 6))
    |> Enum.map(&Enum.frequencies(&1 ++ four ++ seven))
    |> Enum.map(&Enum.filter(&1, fn {_key, n} -> n == 1 end))
    |> Enum.filter(&(Enum.count(&1) == 1))
    |> List.flatten()
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_d =
    codes
    |> Enum.filter(&(length(&1) == 5))
    |> Enum.map(&Enum.frequencies(&1 ++ [sub_of_a, sub_of_g | one]))
    |> Enum.map(&Enum.filter(&1, fn {_key, n} -> n == 1 end))
    |> Enum.filter(&(Enum.count(&1) == 1))
    |> List.flatten()
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_b =
    Enum.frequencies(four ++ one ++ [sub_of_d])
    |> Enum.filter(fn {_key, n} -> n == 1 end)
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_f =
    codes
    |> Enum.filter(&(length(&1) == 5))
    |> Enum.map(&Enum.frequencies(&1 ++ [sub_of_a, sub_of_b, sub_of_d, sub_of_g]))
    |> Enum.map(&Enum.filter(&1, fn {_key, n} -> n == 1 end))
    |> Enum.filter(&(Enum.count(&1) == 1))
    |> List.flatten()
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_c =
    Enum.frequencies(one ++ [sub_of_f])
    |> Enum.filter(fn {_key, n} -> n == 1 end)
    |> then(fn [{sub, 1} | _rest] -> sub end)

  sub_of_e =
    Enum.frequencies(eight ++ [sub_of_a, sub_of_b, sub_of_c, sub_of_d, sub_of_f, sub_of_g])
    |> Enum.filter(fn {_key, n} -> n == 1 end)
    |> then(fn [{sub, 1} | _rest] -> sub end)

  codes
  |> Enum.drop(10)
  |> Enum.map(fn code ->
    Enum.map(code, fn
      ^sub_of_a -> "a"
      ^sub_of_b -> "b"
      ^sub_of_c -> "c"
      ^sub_of_d -> "d"
      ^sub_of_e -> "e"
      ^sub_of_f -> "f"
      ^sub_of_g -> "g"
    end)
    |> Enum.sort()
    |> then(convert_to_number)
  end)
  |> Enum.join("")
  |> then(&(Integer.parse(&1) |> elem(0)))
end

data
|> String.split("\n")
|> Enum.map(&(String.split(&1, " | ") |> Enum.join(" ")))
|> Enum.map(&String.split(&1, " "))
|> Enum.map(&Enum.map(&1, fn code -> String.graphemes(code) |> Enum.sort() end))
|> Enum.map(resolve_number)
|> Enum.sum()
|> IO.inspect()
