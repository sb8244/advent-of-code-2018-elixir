defmodule Advent.Day6.Solution do
  def solve(input_file) do
    coords = file_to_coords(input_file)
    # infinite_indices = outside_indices(coords)
    {_, max_x, _, max_y} = coord_limits(coords)
    max_iter = max(max_x, max_y)

    processed =
      Enum.reduce((1..max_iter), {coords, Map.keys(coords)}, fn iter, acc ->
        iteration(acc, iter)
      end)
      |> elem(0)

    infinite_indices = get_edge_owners(processed, max_iter)

    processed
    |> Enum.map(fn {_, %{index: index}} -> index end)
    |> Enum.reject(fn index ->
      Enum.member?(infinite_indices, index)
    end)
    |> Enum.group_by(& &1)
    |> Enum.sort_by(fn {_k, v} -> length(v) end)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> List.last()
    |> elem(1)
  end

  defp get_edge_owners(coords, max_iter) do
    Enum.flat_map((0..max_iter), fn i ->
      [
        Map.get(coords, {0, i}, %{}) |> Map.get(:index),
        Map.get(coords, {max_iter, i}, %{}) |> Map.get(:index),
        Map.get(coords, {i, 0}, %{}) |> Map.get(:index),
        Map.get(coords, {i, max_iter}, %{}) |> Map.get(:index),
      ]
    end)
    |> Enum.uniq()
  end

  defp file_to_coords(path) do
    File.stream!(path)
    |> Stream.with_index()
    |> Stream.map(fn {line, index} ->
      coords =
        line
        |> String.trim()
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)

      {List.to_tuple(coords), %{index: index, iteration: 0}}
    end)
    |> Enum.into(%{})
  end

  defp coord_limits(coords) do
    {{{min_x, _}, _}, {{max_x, _}, _}} = Enum.min_max_by(coords, & elem(elem(&1, 0), 0))
    {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(coords, & elem(elem(&1, 0), 1))
    {min_x, max_x, min_y, max_y}
  end

  def iteration({all_coords, to_process_coords}, n) do
    # IO.inspect {n, length(to_process_coords)}

    Enum.reduce(to_process_coords, {all_coords, []}, fn coords, acc ->
      v = Map.get(all_coords, coords)
      acc
      |> perform_direction(n, v.index, left(coords))
      |> perform_direction(n, v.index, right(coords))
      |> perform_direction(n, v.index, down(coords))
      |> perform_direction(n, v.index, up(coords))
    end)
  end

  defp perform_direction(acc, _, _, {x, y}) when x < 0 or x > 500 or y < 0 or y > 500 do
    acc
  end

  defp perform_direction(acc = {coords_acc, processed_coords}, n, index, coords) do
    case Map.get(coords_acc, coords) do
      nil ->
        {Map.put(coords_acc, coords, %{index: index, iteration: n}), [coords | processed_coords]}
      %{iteration: ^n, index: i} when i != index ->
        {Map.put(coords_acc, coords, %{index: -1, iteration: n}), processed_coords}
      _ ->
        acc
    end
  end

  def left({x, y}), do: {x - 1, y}
  def right({x, y}), do: {x + 1, y}
  def up({x, y}), do: {x, y - 1}
  def down({x, y}), do: {x, y + 1}

  # defp nope_outside_indices(coords) do
  #   {{_, min_x}, {_, max_x}} =
  #     Enum.group_by(coords, fn {{x, _y}, _v} -> x end)
  #     |> Enum.min_max_by(fn {x, _} -> x end)

  #   {{_, min_y}, {_, max_y}} =
  #     Enum.group_by(coords, fn {{_x, y}, _v} -> y end)
  #     |> Enum.min_max_by(fn {_, y} -> y end)

  #   (Enum.map(max_x, fn {_, g} -> g end) |> Enum.map(& &1.index)) ++
  #   (Enum.map(min_x, fn {_, g} -> g end) |> Enum.map(& &1.index)) ++
  #   (Enum.map(min_y, fn {_, g} -> g end) |> Enum.map(& &1.index)) ++
  #   (Enum.map(max_y, fn {_, g} -> g end) |> Enum.map(& &1.index))
  #   |> Enum.uniq()
  # end

  # defp nope_remove_outside(coords = %{}) do
  #   coords
  #   |> Enum.reduce(%{
  #     min_x: 10_000,
  #     min_x_indices: [],
  #     min_y: 10_000,
  #     min_y_indices: [],
  #     max_x: 0,
  #     max_x_indices: [],
  #     max_y: 0,
  #     max_y_indices: []
  #   }, fn {index, [x, y]}, acc ->
  #     acc =
  #       if x < acc.min_x do
  #         acc
  #         |> Map.put(:min_x, x)
  #         |> Map.put(:min_x_indices, [index])
  #       else
  #         if x == acc.min_x do
  #           acc
  #           |> Map.put(:min_x_indices, [index | acc.min_x_indices])
  #         else
  #           acc
  #         end
  #       end

  #     acc =
  #       if y < acc.min_y do
  #         acc
  #         |> Map.put(:min_y, y)
  #         |> Map.put(:min_y_indices, [index])
  #       else
  #         acc
  #       end

  #     acc
  #   end)
  # end
end
