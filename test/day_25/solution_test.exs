defmodule Advent.Day25.SolutionTest do
  use ExUnit.Case

  @input File.read!("input/25.txt") |> String.trim()

  test "part 1 sample" do
    input = String.trim("""
    -1,2,2,0
    0,0,2,-2
    0,0,0,-2
    -1,2,0,0
    -2,-2,-2,2
    3,0,2,-1
    -1,3,2,2
    -1,0,-1,0
    0,2,1,-2
    3,0,0,0
    """)

    points = get_points(input) |> set_immediate_neighbors()

    assert points
    |> Enum.with_index()
    |> Enum.reduce(points, fn {{point, _}, id}, points ->
      traverse(points, [point], id)
    end)
    |> Enum.map(fn {_k, v} -> v.c_id end)
    |> Enum.uniq()
    |> length() == 4
  end

  test "part 1" do
    points = get_points(@input) |> set_immediate_neighbors()

    assert points
    |> Enum.with_index()
    |> Enum.reduce(points, fn {{point, _}, id}, points ->
      traverse(points, [point], id)
    end)
    |> Enum.map(fn {_k, v} -> v.c_id end)
    |> Enum.uniq()
    |> length() == 359
  end

  def traverse(points, [], _), do: points

  def traverse(points, [curr | frontier], id) do
    point = Map.fetch!(points, curr)

    if Map.get(point, :c_id) do
      traverse(points, frontier, id)
    else
      new_point = Map.put(point, :c_id, id)
      new_points = Map.put(points, curr, new_point)
      traverse(new_points, frontier ++ point.neighbors, id)
    end

  end

  def set_immediate_neighbors(points) do
    Enum.reduce(points, points, fn {point, map}, points ->
      neighbors =
        points
        |> Map.keys()
        |> Enum.filter(fn point2 ->
          distance(point, point2) <= 3
        end)

      new_point = Map.put(map, :neighbors, neighbors)

      Map.put(points, point, new_point)
    end)
  end

  def get_points(input) do
    String.split(input, "\n")
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> Enum.map(fn point ->
      {point, %{coords: point, neighbors: []}}
    end)
    |> Enum.into(%{})
  end

  def distance({a1,b1,c1,d1}, {a2,b2,c2,d2}) do
    abs(a1 - a2) + abs(b1 - b2) + abs(c1 - c2) + abs(d1 - d2)
  end
end
