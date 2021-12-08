{:ok, data} = File.read("input.txt")

output_values =
  data
  |> String.split("\n")
  |> Enum.map(&(String.split(&1, " | ") |> List.last()))
  |> Enum.map(&String.split(&1, " "))
  |> List.flatten()
  |> Enum.filter(&Enum.member?([2, 4, 3, 7], String.length(&1)))
  |> Enum.count()
  |> IO.inspect()
