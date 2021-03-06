defmodule Advent.Day17.Solution do
  defmodule State do
    def new() do
      %{
        max_y: -1000,
        min_y: 1000,
        max_x: 500,
        min_x: 500,
        cells: %{
          {500, 0} => "+"
        }
      }
    end

    def set_sand(state = %{cells: cells}, {x, y}) do
      %{state | cells: Map.put(cells, {x, y}, "#")}
    end

    def set_water(state = %{cells: cells}, {x, y}) do
      %{state | cells: Map.put(cells, {x, y}, "~")}
    end

    def set_water_flow(state = %{cells: cells}, {x, y}) do
      case get_cell(state, {x, y}) do
        "." -> %{state | cells: Map.put(cells, {x, y}, "|")}
        "_" -> state
      end
    end

    def get_cell(_state = %{cells: cells}, {x, y}) do
      Map.get(cells, {x, y}, ".")
    end

    def set_limits(state = %{max_y: max_y, min_y: min_y, max_x: max_x, min_x: min_x}, {x, y}) do
      state
      |> Map.put(:max_y, max(max_y, y))
      |> Map.put(:min_y, min(min_y, y))
      |> Map.put(:max_x, max(max_x, x+1))
      |> Map.put(:min_x, min(min_x, x-1))
    end

    def print(state) do
      Enum.each((state.min_y..state.max_y), fn y ->
        Enum.each((state.min_x..state.max_x), fn x ->
          IO.write get_cell(state, {x, y})
        end)
        IO.write "\n"
      end)
      IO.write "\n"
    end
  end

  def solve(input) do
    setup_state = setup(input)
    final = flow_water(setup_state, {500, 1})

    Enum.each(final.cells, fn {coords, cell} ->
      if State.get_cell(setup_state, coords) == "#" and cell != "#" do
        raise "something went wrong"
      end
    end)

    final
  end

  def flow_water(state = %{max_y: max_y}, {_x, y}) when y > max_y do
    state
  end

  def flow_water(state, coords) do
    # State.print(state)

    # Start with the cell as a |
    next_state = State.set_water_flow(state, coords)

    next_state = handle_wall_fill(next_state, coords)
    next_state = go_down(next_state, coords)
    next_state = go_left(next_state, coords)
    next_state = go_right(next_state, coords)

    next_state
  end

  # If the cell is contained by walls, then set the entire row to ~
  defp handle_wall_fill(state, coords) do
    case cell_contained_by_walls?(state, coords) do
      false ->
        state

      contained_coords ->
        Enum.reduce(contained_coords, state, fn coords, next_state ->
          State.set_water(next_state, coords)
        end)
        |> State.set_water(coords)
    end
  end

  # If the cell below is a ., let's go down
  # defp go_down({:done, _} = acc, _), do: acc
  defp go_down(state = %{max_y: max_y}, {x, y}) do
    below = State.get_cell(state, {x, y+1})
    if below == "." and y <= max_y do
      flow_water(state, {x, y+1})
    else
      state
    end
  end

  # defp go_left({:done, _} = acc, _), do: acc
  defp go_left(state, {x, y}) do
    left = State.get_cell(state, {x-1, y})
    below = State.get_cell(state, {x, y+1})

    if left == "." && below in ["~", "#"] do
      flow_water(state, {x-1, y})
    else
      state
    end
  end

  # defp go_right({:done, _} = acc, _), do: acc
  defp go_right(state, {x, y}) do
    right = State.get_cell(state, {x+1, y})
    below = State.get_cell(state, {x, y+1})

    if right == "." && below in ["~", "#"] do
      flow_water(state, {x+1, y})
    else
      state
    end
  end

  def cell_contained_by_walls?(state = %{max_x: max_x}, {x, y}) do
    {acc, stopped} =
      Enum.reduce_while((1..max_x), {[], false}, fn left_diff, {coords_acc, stopped} ->
        coords = {x-left_diff, y}
        cell = State.get_cell(state, coords)
        below = State.get_cell(state, {x-left_diff, y+1})

        if cell == "#" do
          {:halt, {coords_acc, true}}
        else
          if below == "." or below == "|" do
            {:halt, {[], false}}
          else
            {:cont, {[coords | coords_acc], stopped}}
          end
        end
      end)

    if !stopped do
      false
    else
      {acc, stopped} =
        Enum.reduce_while((1..max_x), {acc, false}, fn right_diff, {coords_acc, stopped} ->
          coords = {x+right_diff, y}
          cell = State.get_cell(state, coords)
          below = State.get_cell(state, {x+right_diff, y+1})

          if cell == "#" do
            {:halt, {coords_acc, true}}
          else
            if below == "." do
              {:halt, {[], false}}
            else
              {:cont, {[coords | coords_acc], stopped}}
            end
          end
        end)

      if stopped do
        acc
      else
        false
      end
    end
  end

  def cell_maxed_out?(state, {x, y}) do
    cell = State.get_cell(state, {x, y})
    down = State.get_cell(state, {x, y+1})
    left = State.get_cell(state, {x-1, y})
    right = State.get_cell(state, {x+1, y})

    [cell, left, right, down]
    |> Enum.all?(& &1 in ["#", "~"])
  end

  def setup(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(State.new(), fn line, state ->
      [x_str, y_str] = String.split(line, ", ") |> Enum.sort()
      x_parts = String.split(x_str, "x=") |> List.last() |> String.split("..")
      y_parts = String.split(y_str, "y=") |> List.last() |> String.split("..")

      x_range = get_range(x_parts)
      y_range = get_range(y_parts)

      Enum.reduce(x_range, state, fn x, state ->
        Enum.reduce(y_range, state, fn y, state ->
          state
          |> State.set_sand({x, y})
          |> State.set_limits({x, y})
        end)
      end)
    end)
  end

  def get_range([start]), do: String.to_integer(start)..String.to_integer(start)
  def get_range([start | [ending]]), do: String.to_integer(start)..String.to_integer(ending)
end
