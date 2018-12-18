defmodule Advent.Day18.SolutionTest do
  use ExUnit.Case
  alias Advent.Day18.Solution

  test "part 1 sample" do
    input = """
    .#.#...|#.
    .....#|##|
    .|..|...#.
    ..|#.....#
    #.#|||#|#|
    ...#.||...
    .|....|...
    ||...#|.#|
    |.||||..|.
    ...#.|..|.
    """ |> String.trim()

    map = construct(input)

    after_10 =
      Enum.reduce((1..10), map, fn _, map ->
        tick(map)
      end)

    after_10 = Map.values(after_10)
    assert length(Enum.filter(after_10, & &1=="|")) * length(Enum.filter(after_10, & &1=="#")) == 1147
  end

  test "part 1" do
    input = File.read!("input/18.txt") |> String.trim()

    map = construct(input)

    after_10 =
      Enum.reduce((1..10), map, fn _, map ->
        tick(map)
      end)

    after_10 = Map.values(after_10)
    assert length(Enum.filter(after_10, & &1=="|")) * length(Enum.filter(after_10, & &1=="#")) == 384416
  end

  # I solved this manually by confirming that it gets into a steady state, and checking at time 1000
  test "part 2" do
    input = File.read!("input/18.txt") |> String.trim()

    map = construct(input)

    {_, _, _, res} =
      Enum.reduce((1..1000), {map, MapSet.new(), %{}, %{}}, fn i, {map, seen, first_seen, all_seen} ->
        ticked = tick(map)
        check = Map.values(ticked)
        val = length(Enum.filter(check, & &1=="|")) * length(Enum.filter(check, & &1=="#"))

        all_seen = Map.put(all_seen, i, val)
        first_seen =
          if MapSet.member?(seen, val) do
            # IO.inspect {i, val, "SEEN FIRST IN", Map.fetch!(first_seen, val)}
            first_seen
          else
            Map.put(first_seen, val, i)
          end

        {ticked, MapSet.put(seen, val), first_seen, all_seen}
      end)

    assert Map.fetch!(res, 1000) == 195776
  end

  def tick(map) do
    Enum.map(map, fn {coords, cell} ->
      adjacents = fetch_adjacent(map, coords)

      #open
      if cell == "." do
        filled = length(Enum.filter(adjacents, & &1 == "|")) >= 3
        if filled, do: {coords, "|"}, else: {coords, "."}
      else
        if cell == "|" do
          #tree
          filled = length(Enum.filter(adjacents, & &1 == "#")) >= 3
          if filled, do: {coords, "#"}, else: {coords, "|"}
        else
          #lumber
          filled = length(Enum.filter(adjacents, & &1 == "#")) >= 1 && length(Enum.filter(adjacents, & &1 == "|")) >= 1
          if filled, do: {coords, "#"}, else: {coords, "."}
        end
      end
    end)
    |> Enum.into(%{})
  end

  def fetch_adjacent(map, {x, y}) do
    [
      Map.get(map, {x-1, y}),
      Map.get(map, {x+1, y}),
      Map.get(map, {x, y-1}),
      Map.get(map, {x, y+1}),
      Map.get(map, {x-1, y-1}),
      Map.get(map, {x-1, y+1}),
      Map.get(map, {x+1, y-1}),
      Map.get(map, {x+1, y+1}),
    ] |> Enum.reject(& &1==nil)
  end

  def construct(input) do
    String.split(input, "\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.split("")
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, acc ->
        if cell != "" do
          Map.put(acc, {x, y}, cell)
        else
          acc
        end
      end)
    end)
  end
end
