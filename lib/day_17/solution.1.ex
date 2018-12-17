defmodule Advent.Day17.SolutionBonked do
  defmodule State do
    def new() do
      %{
        max_y: 0,
        min_y: 0,
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
      %{state | cells: Map.put(cells, {x, y}, "|")}
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
    input
    |> setup()
    |> flow_water([{500, 0}], MapSet.new())
  end

  def flow_water(state, [], _) do
    state
  end

  def flow_water(state = %{max_y: max_y}, [curr = {x, y} | frontier], done) do
    if MapSet.member?(done, curr) or y > max_y do
      flow_water(state, frontier, MapSet.put(done, curr))
    else
      # State.print(state)
      # IO.inspect frontier
      # Process.sleep(50)
      cell = State.get_cell(state, curr)
      up = State.get_cell(state, {x, y-1})

      # IO.inspect {curr, cell}

      if cell_maxed_out?(state, curr) do
        # up

        if up == "." do
          flow_water(state, frontier, MapSet.put(done, curr))
        else
          # IO.inspect {"maxed", {x, y-1}}
          flow_water(state, [{x, y-1}] ++ frontier, MapSet.put(done, curr))
        end
      else
        case cell do
          "#" ->
            flow_water(state, frontier, MapSet.put(done, curr))

          _ ->
            {new_state, frontier_add} =
              case cell_contained_by_walls?(state, curr) do
                false ->
                  {State.set_water_flow(state, curr), []}

                contained_coords ->
                  {Enum.reduce(contained_coords, state, fn coords, state ->
                    State.set_water(state, coords)
                  end), [{x-1, y-1}, {x, y-1}, {x+1, y-1}]}
              end

            below = State.get_cell(new_state, {x, y+1})
            left = State.get_cell(new_state, {x-1, y})
            right = State.get_cell(new_state, {x+1, y})

            case below do
              c when c in ["~", "#"] ->
                frontier_add = if left != "|" do
                  [{x-1, y} | frontier_add]
                else
                  frontier_add
                end

                frontier_add = if right != "|" do
                  [{x+1, y} | frontier_add]
                else
                  frontier_add
                end

                # left+right
                flow_water(new_state, frontier ++ frontier_add, done)

              "." ->
                new_state = State.set_water_flow(state, curr)
                # down
                flow_water(new_state, [{x, y+1} | frontier_add] ++ frontier, done)

              "|" ->
                flow_water(new_state, frontier_add ++ frontier, done)
            end
        end
      end
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
          if below == "." do
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
