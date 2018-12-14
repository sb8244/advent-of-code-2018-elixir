defmodule Advent.Day14.SolutionTest do
  use ExUnit.Case

  test "part 1 sample" do
    assert solve_for(5) == "0124515891"
    assert solve_for(18) == "9251071085"
    assert solve_for(2018) == "5941429882"
  end

  test "part 1" do
    assert solve_for(681901) == "1617111014"
  end

  test "part 2 sample" do
    assert solve_for("51589") == 9
    assert solve_for("01245") == 5
    assert solve_for("59414") == 2018
  end

  # Times out when you run it
  # test "part 2" do
  #   assert solve_for("681901") == 20321496 # off by 1 error, submit as 20321495
  # end

  def solve_for(seq) when is_bitstring(seq) do
    answer =
      {[0, 1], {%{0 => 3, 1 => 7}, 1}}
      |> solve(nil, {seq, "37"})

    answer
  end

  def solve_for(iter) do
    {_elves, {scores, _max_index}} =
      {[0, 1], {%{0 => 3, 1 => 7}, 1}}
      |> solve(iter, {nil, ""})

    (iter..iter+9)
    |> Enum.map(& Map.fetch!(scores, &1))
    |> Enum.join()
  end

  def solve(acc = {_elves, {_scores, max_score_index}}, size, _) when size != nil and max_score_index >= size + 10 do
    # IO.inspect acc
    acc
  end

  def solve(acc, _size, str_acc) when is_integer(str_acc) do
    # IO.inspect acc
    str_acc
  end

  def solve(acc = {elves, {scores, max_score_index}}, necessary_size, str_acc = {looking_for_str, curr_str}) do
    # IO.inspect max_score_index
    # IO.inspect acc
    current_recipes =
      Enum.reduce(elves, [], fn elf_index, recipes ->
        # IO.inspect {elves, elf_index, Map.get(scores, elf_index)}
        [Map.fetch!(scores, elf_index) | recipes]
      end)
      |> Enum.reverse()

    new_recipes = split_recipe(Enum.sum(current_recipes))
    new_score_data = {_, new_max_score_index} =
      new_recipes
      |> Enum.reduce({scores, max_score_index}, fn score, {scores, max_index} ->
        {Map.put(scores, max_index + 1, score), max_index + 1}
      end)

    new_elves = elves |> Enum.with_index() |> Enum.map(fn {elf_index, i} ->
      shift_by = Enum.at(current_recipes, i) + 1
      # IO.inspect {elf_index + shift_by, max_score_index, next_index(elf_index + shift_by, max_score_index)}
      next_index(elf_index + shift_by, new_max_score_index)
    end)

    if looking_for_str && String.contains?(curr_str, looking_for_str) do
      solve({new_elves, new_score_data}, necessary_size, max_score_index - String.length(looking_for_str) + 1)
    else
      if looking_for_str do
        next_str = trim_string(curr_str <> Enum.join(new_recipes), 20) # |> IO.inspect()
        solve({new_elves, new_score_data}, necessary_size, {looking_for_str, next_str})
      else
        solve({new_elves, new_score_data}, necessary_size, str_acc)
      end
    end
  end

  def split_recipe(int) when int >= 10, do: [div(int, 10), rem(int, 10)]
  def split_recipe(int), do: [int]

  def next_index(index, max_index) when index > max_index, do: rem(index, max_index+1)
  def next_index(index, _), do: index

  def trim_string(str, size) when byte_size(str) > size do
    String.slice(str, -size, size)
  end

  def trim_string(str, _), do: str
end
