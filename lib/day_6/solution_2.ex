defmodule Advent.Day6.Solution2 do
  # def solve2(input_file, max_size) do
  #   coords = file_to_coords(input_file)

  #   Enum.reduce(coords, coords, fn {coords, _}, acc_coords ->
  #     explore_map(acc_coords, %{}, [{coords, 0}], max_size)
  #   end)
  #   |> Enum.filter(fn {_, %{distance_sum: sum, visited_count: count}} ->
  #     count == map_size(coords) && sum < max_size
  #   end)
  #   |> length()
  # end

  def solve(input_file, max_size) do
    coords = file_to_coords(input_file)

    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coords, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coords, &elem(&1, 1))

    Enum.map(min_x..max_x, fn x ->
      Task.async(fn ->
        Enum.reduce(min_y..max_y, 0, fn y, sums ->
          Enum.reduce(coords, 0, fn coord, sum ->
            sum + distance({x, y}, coord)
          end)
          |> case do
            sum when sum < max_size ->
              sums + 1

            _ ->
              sums
          end
        end)
      end)
    end)
    |> Enum.reduce(0, fn task, acc ->
      acc + Task.await(task)
    end)
  end

  defp distance({x, y}, {x2, y2}) do
    abs(x - x2) + abs(y - y2)
  end

  # defp explore_map(acc, _visited, frontier, _max) when length(frontier) == 0 do
  #   acc
  # end

  # defp explore_map(acc, visited, [{{_x, _y}, iter} | frontier], max) when iter > max or iter > 200 do
  #   explore_map(acc, visited, frontier, max)
  # end

  # defp explore_map(acc, visited, [{visiting_coords, iter} | frontier], max) do
  #   visiting_cell = case Map.get(acc, visiting_coords) do
  #     nil ->
  #       %{distance_sum: iter, visited_count: 1}
  #     %{distance_sum: sum, visited_count: count} ->
  #       %{distance_sum: sum + iter, visited_count: count + 1}
  #   end

  #   if visiting_cell.distance_sum > max || Map.get(visited, visiting_coords) do
  #     explore_map(acc, Map.put(visited, visiting_coords, true), frontier, max)
  #   else
  #     new_frontier = if Map.get(visited, left(visiting_coords)), do: frontier, else: frontier ++ [{left(visiting_coords), iter + 1}]
  #     new_frontier = if Map.get(visited, right(visiting_coords)), do: new_frontier, else: new_frontier ++ [{right(visiting_coords), iter + 1}]
  #     new_frontier = if Map.get(visited, up(visiting_coords)), do: new_frontier, else: new_frontier ++ [{up(visiting_coords), iter + 1}]
  #     new_frontier = if Map.get(visited, down(visiting_coords)), do: new_frontier, else: new_frontier ++ [{down(visiting_coords), iter + 1}]

  #     # IO.inspect {visiting_coords, visiting_cell, new_frontier}
  #     explore_map(Map.put(acc, visiting_coords, visiting_cell), Map.put(visited, visiting_coords, true), new_frontier, max)
  #   end
  # end

  defp file_to_coords(path) do
    File.stream!(path)
    |> Stream.with_index()
    |> Stream.map(fn {line, _index} ->
      coords =
        line
        |> String.trim()
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)

      List.to_tuple(coords)
    end)
    |> Enum.into([])
  end

  # def left({x, y}), do: {x - 1, y}
  # def right({x, y}), do: {x + 1, y}
  # def up({x, y}), do: {x, y - 1}
  # def down({x, y}), do: {x, y + 1}
end
