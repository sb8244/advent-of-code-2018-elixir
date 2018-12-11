defmodule Advent.Day11.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day11.Solution

  test  "power" do
    assert Solution.power(3, 5, 8) == 4
  end

  test "part 1 sample" do
    assert Solution.solve(18) == {29, {33, 45}}
    assert Solution.solve(42) == {30, {21, 61}}
  end

  test "part 1" do
    assert Solution.solve(7400) == {29, {33, 45}}
  end

  test "part 2 sample" do
    assert Solution.solve_arbitrary(18) == {113, {90, 269, 16}}
  end

  test "part 2" do
    assert Solution.solve_arbitrary(7400) == {91, {233, 187, 13}}
  end
end
