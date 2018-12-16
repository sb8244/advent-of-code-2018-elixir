defmodule Advent.Day15.SolutionTest do
  use ExUnit.Case

  alias Advent.Day15.Solution

  @sample_input File.read!("input/15.sample.txt") |> String.trim()
  @sample_input2 File.read!("input/15.sample2.txt") |> String.trim()

  @input File.read!("input/15.txt") |> String.trim()

  test "part 1 sample" do
    graph = %{height: 7, width: 7, units: units, iteration: 47} = Solution.solve(@sample_input)

    assert units
      |> Map.values()
      |> Enum.map(& &1.health) == [200, 131, 59, 200]

    assert get_number(graph) == 27730
  end

  test "part 1 sample 2" do
    graph = Solution.solve(@sample_input2)
    assert get_number(graph) == 36334
  end

  test "part 1" do
    graph = Solution.solve(@input)
    assert get_number(graph) == 264384
  end

  test "part 2 sample 2" do
    input = """
            #######
            #E..EG#
            #.#G.E#
            #E.##E#
            #G..#.#
            #..E#.#
            #######
            """ |> String.trim()

    %{units: initial_units} = Solution.populate_graph(input, 3)
    elf_count = initial_units |> Map.keys() |> Enum.filter(& String.starts_with?(&1, "E_")) |> length()

    {_power, graph} =
      (1..100)
      |> Enum.reduce_while(nil, fn elf_power, acc ->
        graph = %{units: units} = Solution.solve(input, elf_power: elf_power)

        if String.starts_with?(List.first(Map.keys(units)), "E_") && length(Map.keys(units)) == elf_count do
          {:halt, {elf_power, graph}}
        else
          {:cont, acc}
        end
      end)

    assert graph.iteration == 33
    assert get_number(graph) == 31284
  end

  test "part 2" do
    input = @input
    %{units: initial_units} = Solution.populate_graph(input, 3)
    elf_count = initial_units |> Map.keys() |> Enum.filter(& String.starts_with?(&1, "E_")) |> length()

    {_power, graph} =
      (1..100)
      |> Enum.reduce_while(nil, fn elf_power, acc ->
        graph = %{units: units} = Solution.solve(input, elf_power: elf_power)

        if String.starts_with?(List.first(Map.keys(units)), "E_") && length(Map.keys(units)) == elf_count do
          {:halt, {elf_power, graph}}
        else
          {:cont, acc}
        end
      end)

    assert graph.iteration == 46
    assert get_number(graph) == 67022
  end

  def get_number(%{iteration: iteration, units: units}) do
    units
    |> Map.values()
    |> Enum.map(& &1.health)
    |> Enum.sum()
    |> Kernel.*(iteration)
  end
end
