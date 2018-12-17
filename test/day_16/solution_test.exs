defmodule Advent.Day16.SolutionTest do
  use ExUnit.Case
  alias Advent.Day16.Solution

  @input File.read!("input/16.txt") |> String.trim()
  @program_input File.read!("input/16.program.txt") |> String.trim()

  test "part 1" do
    possible_opcodes = Solution.compute_possible_opcodes(@input)
    assert Enum.filter(possible_opcodes, & length(elem(&1, 1)) >= 3) |> length() == 588
  end

  test "part 2" do
    possible_opcodes = Solution.compute_possible_opcodes(@input)
    opcodes = Solution.resolve_opcodes(possible_opcodes)
    assert Solution.execute_program(@program_input, opcodes) == [627, 627, 2, 3]
  end
end
