defmodule Advent.Day22.SolutionTest do
  use ExUnit.Case

  test "part 1 sample" do
    erosion_levels = get_erosion_levels(510, 10, 10, padding: 0)
    assert Map.values(erosion_levels) |> Enum.map(& rem(&1, 3)) |> Enum.sum() == 114
  end

  test "part 1" do
    erosion_levels = get_erosion_levels(9465, 13, 704, padding: 0)
    assert Map.values(erosion_levels) |> Enum.map(& rem(&1, 3)) |> Enum.sum() == 9940
  end

  test "part 2 sample" do
    erosion_levels = get_erosion_levels(510, 10, 10, padding: 10)
    terrain = Enum.map(erosion_levels, fn {k, v} -> {k, rem(v, 3)} end) |> Enum.into(%{})

    assert traverse(terrain, {10, 10}) == {45, {10, 10}, :t}
  end

  test "part 2" do
    erosion_levels = get_erosion_levels(9465, 13, 704, padding: 10)
    terrain = Enum.map(erosion_levels, fn {k, v} -> {k, rem(v, 3)} end) |> Enum.into(%{})
    assert traverse(terrain, {13, 704}) == {944, {13, 704}, :t}
  end

  def traverse(terrain, target = {tx, ty}) do
    nodes =
      Enum.flat_map(terrain, fn {{x, y}, type} ->
        Enum.map(list_types(type), fn c ->
          {{x, y}, c}
        end)
      end)
      |> List.delete({{0, 0}, :c})
      |> List.delete({{tx, ty}, :c})

    dist = %{{{0, 0}, :t} => 0}

    Enum.reduce_while(1..100_000_000, {nodes, dist}, fn _, {nodes, dist} ->
      # find node with lowest dist
      {nodes, dist_entry = {u, equipped_item}} = extract_min_node(nodes, dist)
      dist_cost = Map.fetch!(dist, dist_entry)

      if u == target do
        cost = Map.fetch!(dist, dist_entry)
        {:halt, {cost, u, equipped_item}}
      else
        {
          :cont,
          get_neighbors(terrain, u, equipped_item, target)
          |> Enum.reduce({nodes, dist}, fn {v, cost}, {nodes, dist} ->
            alt = dist_cost + cost
            v_dist = Map.get(dist, v, 100_000_000)
            new_dist =
              if alt < v_dist do
                Map.put(dist, v, alt)
              else
                dist
              end

            {nodes, new_dist}
          end)
        }
      end
    end)
  end

  def extract_min_node(nodes, dist) do
    candidates = Enum.filter(nodes, & Map.has_key?(dist, &1))
    curr = Enum.sort_by(candidates, & Map.fetch!(dist, &1)) |> List.first()
    {List.delete(nodes, curr), curr}
  end

  def get_neighbors(terrain, {x, y}, equipped, target) do
    curr = Map.fetch!(terrain, {x, y})

    [
      {{x-1, y}, Map.get(terrain, {x-1, y})},
      {{x+1, y}, Map.get(terrain, {x+1, y})},
      {{x, y-1}, Map.get(terrain, {x, y-1})},
      {{x, y+1}, Map.get(terrain, {x, y+1})},
    ]
    |> Enum.reject(& is_nil(elem(&1, 1)))
    |> Enum.flat_map(fn {coords, terrain} ->
      if curr == terrain do
        if coords == target do
          [
            {{coords, :t}, (if equipped == :t, do: 1, else: 8)},
          ]
        else
          [a, b] = list_types(terrain)
          [
            {{coords, a}, (if equipped == a, do: 1, else: 8)},
            {{coords, b}, (if equipped == b, do: 1, else: 8)}
          ]
        end
      else
        {will_equip, cost} = must_equip(curr, terrain, equipped, coords == target)
        [
          {{coords, will_equip}, cost}
        ]
      end
    end)
  end

#   In rocky regions, you can use the climbing gear or the torch. You cannot use neither (you'll likely slip and fall).
# In wet regions, you can use the climbing gear or neither tool. You cannot use the torch (if it gets wet, you won't have a light source).
# In narrow regions, you can use the torch or neither tool. You cannot use the climbing gear (it's too bulky to fit).

  def list_types(0), do: [:t, :c]
  def list_types(1), do: [:c, :n]
  def list_types(2), do: [:t, :n]

  def must_equip(0, 0, :c, true), do: {:t, 8}
  def must_equip(1, 0, :c, true), do: {:t, 8}
  def must_equip(1, 0, :n, true), do: {:t, 8}
  def must_equip(2, 0, :n, true), do: {:t, 8}
  def must_equip(0, 0, :t, true), do: {:t, 1}
  def must_equip(2, 0, :t, true), do: {:t, 1}

  def must_equip(0, 1, :t, false), do: {:c, 8}
  def must_equip(0, 1, :c, false), do: {:c, 1}
  def must_equip(0, 2, :t, false), do: {:t, 1}
  def must_equip(0, 2, :c, false), do: {:t, 8}

  def must_equip(1, 2, :c, false), do: {:n, 8}
  def must_equip(1, 2, :n, false), do: {:n, 1}
  def must_equip(1, 0, :c, false), do: {:c, 1}
  def must_equip(1, 0, :n, false), do: {:c, 8}

  def must_equip(2, 0, :n, false), do: {:t, 8}
  def must_equip(2, 0, :t, false), do: {:t, 1}
  def must_equip(2, 1, :n, false), do: {:n, 1}
  def must_equip(2, 1, :t, false), do: {:n, 8}

  def get_erosion_levels(depth, target_x, target_y, padding: padding) do
    Enum.reduce((0..target_y + padding), %{}, fn y, acc ->
      Enum.reduce((0..target_x + padding), acc, fn x, acc ->
        erosion_level = if y == 0 do
          rem((x * 16807) + depth, 20183)
        else
          if x == 0 do
            rem((y * 48271) + depth, 20183)
          else
            if x == target_x && y == target_y do
              rem(depth, 20183)
            else
              rem(Map.fetch!(acc, {x-1, y}) * Map.fetch!(acc, {x, y-1}) + depth, 20183)
            end
          end
        end
        Map.put(acc, {x, y}, erosion_level)
      end)
    end)
  end
end
