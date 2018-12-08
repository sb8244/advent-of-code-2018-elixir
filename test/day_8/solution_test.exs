defmodule Advent.Day8.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day8.Solution

  test "part 1 example" do
    assert "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
      |> Solution.tree()
      |> Solution.reduce([], fn node, acc ->
        acc ++ Enum.map(node.metadata, &String.to_integer/1)
      end)
      |> Enum.sum() == 138
  end

  @input File.read!("input/8.txt") |> String.trim()

  test "part 1 solution" do
    assert @input
      |> Solution.tree()
      |> Solution.reduce([], fn node, acc ->
        acc ++ Enum.map(node.metadata, &String.to_integer/1)
      end)
      |> Enum.sum() == 35852
  end

  test "part 2 example" do
    assert "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
      |> Solution.tree()
      |> Solution.sum_by_metadata_entries(0) == 66
  end

  test "part 2 solution" do
    assert @input
      |> Solution.tree()
      |> Solution.sum_by_metadata_entries(0) == 33422
  end
end
