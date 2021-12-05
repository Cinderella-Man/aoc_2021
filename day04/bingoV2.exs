{:ok, data} = File.read("input.txt")

lines =
  data
  |> String.split("\n")

numbers =
  lines
  |> List.first()
  |> String.split(",")
  |> Enum.map(&(Integer.parse(&1) |> elem(0)))

parse_board = fn lines ->
  lines
  |> Enum.map(&String.codepoints/1)
  |> Enum.map(&Enum.chunk_every(&1, 2, 3))
  |> Enum.map(
    &Enum.map(&1, fn double ->
      Enum.join(double, "") |> String.trim() |> Integer.parse() |> elem(0)
    end)
  )
end

boards =
  lines
  |> Enum.drop(2)
  |> Enum.chunk_every(5, 6)
  |> Enum.map(parse_board)

mark_number = fn number, board ->
  board
  |> Enum.map(
    &Enum.map(&1, fn n ->
      if n == number do
        true
      else
        n
      end
    end)
  )
end

is_winner = fn board ->
  horizontal_winning_line =
    board
    |> Enum.find(&Enum.all?(&1, fn n -> n == true end))

  if horizontal_winning_line != nil do
    true
  else
    vertical_winning_line =
      0..4
      |> Enum.map(fn index ->
        board
        |> Enum.map(&Enum.at(&1, index))
      end)
      |> Enum.find(&Enum.all?(&1, fn n -> n == true end))

    if vertical_winning_line != nil do
      true
    else
      false
    end
  end
end

calculate_board_score = fn winner_board ->
  winner_board
  |> Enum.map(&Enum.filter(&1, fn spot -> spot != true end))
  |> Enum.map(&Enum.sum/1)
  |> Enum.sum()
end

play_bingo = fn
  [number | rest], boards, false, rec_fun ->
    boards = boards |> Enum.map(&mark_number.(number, &1))
    loosers = boards |> Enum.filter(&(is_winner.(&1) == false))

    if length(loosers) == 1 do
      rec_fun.(rest, loosers, true, rec_fun)
    else
      rec_fun.(rest, loosers, false, rec_fun)
    end

  [number | rest], boards, true, rec_fun ->
    boards = boards |> Enum.map(&mark_number.(number, &1))
    winner = boards |> Enum.find(is_winner)

    if winner != nil do
      calculate_board_score.(winner) * number
    else
      rec_fun.(rest, boards, true, rec_fun)
    end
end

play_bingo.(numbers, boards, false, play_bingo)
|> IO.inspect()
