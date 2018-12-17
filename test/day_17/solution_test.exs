defmodule Advent.Day17.SolutionTest do
  use ExUnit.Case

  alias Advent.Day17.Solution

  @sample_input File.read!("input/17.sample.txt") |> String.trim()
  @input File.read!("input/17.txt") |> String.trim()

  test "part 1 sample" do
    state = %{cells: cells, max_y: max_y} = Solution.solve(@sample_input)

    assert cells
    |> Enum.filter(fn {{x, y}, cell} ->
      y <= max_y and cell in ["~", "|"]
    end)
    |> length()
    |> Kernel.-(1) == 57
  end

  test "part 1" do
    state = %{cells: cells, max_y: max_y} = Solution.solve(@input)
    Solution.State.print(state)

    cells
    |> Enum.filter(fn {{x, y}, cell} ->
      y <= max_y and cell in ["~", "|"]
    end)
    |> length()
    |> Kernel.-(1) # adjust for source
    |> IO.inspect()
  end
end
