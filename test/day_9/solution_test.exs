defmodule Advent.Day9.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day9.Solution

  # @input File.read!("input/9.txt") |> String.trim()

  test "part 1 sample" do
    assert Solution.ll_solve(9, 25)
           |> Enum.sort_by(&elem(&1, 1))
           |> List.last() == {4, 32}

    assert Solution.ll_solve(30, 5807)
           |> Enum.sort_by(&elem(&1, 1))
           |> List.last() == {19, 37305}
  end

  test "part 1" do
    assert Solution.ll_solve(462, 71938)
           |> Enum.sort_by(&elem(&1, 1))
           |> List.last() == {195, 398_371}
  end

  test "part 2" do
    assert Solution.ll_solve(462, 71938 * 100)
           |> Enum.sort_by(&elem(&1, 1))
           |> List.last() == {93, 3_212_830_280}
  end
end
