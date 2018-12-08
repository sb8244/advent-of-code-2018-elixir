defmodule Advent.Day8.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day8.Solution

  test "part 1 example" do
    tree =
      "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
      |> Solution.tree()
      |> IO.inspect()
  end
end
