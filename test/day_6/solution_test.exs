defmodule Advent.Day6.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day6.{Solution, Solution2}

  test "the sample is solved" do
    assert Solution.solve("input/6.sample.txt") == 17
  end

  test "the problem is solved" do
    assert Solution.solve("input/6.txt") == 4143
  end

  test "part 2 sample is solved" do
    assert Solution2.solve("input/6.sample.txt", 32) == 16
  end

  test "part 2 is solved" do
    assert Solution2.solve("input/6.txt", 10_000) == 35039
  end
end
