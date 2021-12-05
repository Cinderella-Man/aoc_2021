{:ok, data} = File.read("input.txt")

lines =
  data
  |> String.split("\n")

to_decimal = fn binary_number ->
  binary_number
  |> String.split("")
  |> Enum.drop(1)
  |> Enum.drop(-1)
  |> Enum.reverse()
  |> Enum.reduce({0, 1}, fn bit, {acc, n} ->
    if bit == "1" do
      {acc + n, n * 2}
    else
      {acc, n * 2}
    end
  end)
  |> elem(0)
end

most_or_least_common = fn bits, predicate ->
  bits
  |> Enum.count(&(&1 == "1"))
  |> then(
    &if predicate.(&1, length(bits) / 2) do
      "1"
    else
      "0"
    end
  )
end

find_number = fn
  [number], _, _, _ ->
    number

  numbers, index, predicate, rec_fun ->
    common_bit = most_or_least_common.(numbers |> Enum.map(&String.at(&1, index)), predicate)
    filtered_numbers = numbers |> Enum.filter(&(String.at(&1, index) == common_bit))
    rec_fun.(filtered_numbers, index + 1, predicate, rec_fun)
end

life_support =
  lines
  |> find_number.(0, fn a, b -> a >= b end, find_number)
  |> then(to_decimal)

co2_scrubber_rating =
  lines
  |> find_number.(0, fn a, b -> a < b end, find_number)
  |> then(to_decimal)

IO.inspect(life_support * co2_scrubber_rating)
