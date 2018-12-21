defmodule Advent.Day21.SolutionTest do
  use ExUnit.Case

  alias Advent.Day21.Solution

  test "part 1" do
    input = File.read!("input/21.txt") |> String.trim()

    Solution.solve(input) |> IO.inspect()
  end
end
