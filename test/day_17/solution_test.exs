defmodule Advent.Day17.SolutionTest do
  use ExUnit.Case

  alias Advent.Day17.Solution

  @sample_input File.read!("input/17.sample.txt") |> String.trim()
  @input File.read!("input/17.txt") |> String.trim()

  test "part 1 sample" do
    %{cells: cells, max_y: max_y} = Solution.solve(@sample_input)

    assert cells
    |> Enum.filter(fn {{_x, y}, cell} ->
      y <= max_y and cell in ["~", "|"]
    end)
    |> length() == 57
  end

  test "part 1" do
    _state = %{cells: cells, max_y: max_y, min_y: min_y} = Solution.solve(@input)
    # Solution.State.print(state)

    assert cells
    |> Enum.filter(fn {{_x, y}, cell} ->
      y >= min_y and y <= max_y and cell in ["~", "|", "+"]
    end)
    |> length() == 31934
  end

  test "part 2" do
    _state = %{cells: cells, max_y: max_y, min_y: min_y} = Solution.solve(@input)
    # Solution.State.print(state)

    assert cells
    |> Enum.filter(fn {{_x, y}, cell} ->
      y >= min_y and y <= max_y and cell in ["~"]
    end)
    |> length() == 24790
  end
end
