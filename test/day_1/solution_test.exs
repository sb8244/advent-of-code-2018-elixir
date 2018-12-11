defmodule Advent.Day1.SolutionTest do
  use ExUnit.Case, async: true

  @input File.read!("input/1.txt") |> String.trim()

  test "part 1" do
    assert @input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum() == 497
  end

  test "part 2" do
    numbers =
      @input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    assert go_until_done(numbers, 0, 0, MapSet.new()) == {:done, 558}
  end

  def go_until_done(numbers, curr_i, sum, seen) when length(numbers) == curr_i do
    go_until_done(numbers, 0, sum, seen)
  end

  def go_until_done(numbers, curr_i, sum, seen) do
    n = Enum.at(numbers, curr_i)
    new = n + sum

    if MapSet.member?(seen, new) do
      {:done, new}
    else
      seen = MapSet.put(seen, sum)
      go_until_done(numbers, curr_i + 1, new, seen)
    end
  end
end
