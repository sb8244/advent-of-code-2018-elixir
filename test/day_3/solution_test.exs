defmodule Advent.Day3.SolutionTest do
  use ExUnit.Case

  @input File.read!("input/3.txt") |> String.trim()

  test "part 1 sample" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """ |> String.trim()

    assert construct_map(input)
    |> Enum.filter(& elem(&1, 1) == :collide)
    |> length() == 4
  end

  test "part 1" do
    assert construct_map(@input)
    |> Enum.filter(& elem(&1, 1) == :collide)
    |> length() == 112418
  end

  test "part 2" do
    possible_safe =
      construct_map(@input)
      |> Map.values()
      |> Enum.reject(& &1 == :collide)

    assert possible_safe
    |> Enum.find(fn line ->
      [_ | info] = Regex.run(~r/(\d+)x(\d+)/, line)
      [w, h] = Enum.map(info, &String.to_integer/1)

      length(Enum.filter(possible_safe, & &1 == line)) == w*h
    end)
    |> String.split(" ")
    |> List.first() == "#560"
  end

  defp construct_map(input) do
    String.split(input, "\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [line | [_ | info]] = Regex.run(~r/(.*) @ (.*),(.*): (.*)x(.*)/, line)
      [c, r, w, h] = Enum.map(info, &String.to_integer/1)

      Enum.reduce((c..c+w-1), acc, fn x, acc ->
        Enum.reduce((r..r+h-1), acc, fn y, acc ->
          case Map.get(acc, {x, y}) do
            nil ->
              Map.put(acc, {x, y}, line)

            _ ->
              Map.put(acc, {x, y}, :collide)
          end
        end)
      end)
    end)
  end
end
