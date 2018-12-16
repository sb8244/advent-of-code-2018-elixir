defmodule Advent.Day15.Solution do
  defmodule Graph do
    def new() do
      %{
        graph: %{},
        units: %{},
        unit_count: 0,
        iteration: 0,
        height: 0,
        width: 0,
      }
    end

    def fetch_unit(%{units: units}, unit_id) do
      Map.fetch(units, unit_id)
    end

    def fetch_cell(%{graph: graph}, coords = {_, _}) do
      Map.fetch(graph, coords)
    end

    def set_cell(data = %{units: units, unit_count: unit_count}, {x, y}, cell, elf_power: elf_power) when cell in ["G", "E"] do
      unit_id = "#{cell}_#{unit_count}"
      power = if cell == "E", do: elf_power, else: 3
      new_units = Map.put(units, unit_id, %{health: 200, attack: power, id: unit_id, looks_for: opposite_type(cell)})

      data
      |> Map.put(:units, new_units)
      |> Map.put(:unit_count, unit_count + 1)
      |> set_cell({x, y}, "u" <> unit_id, elf_power: elf_power)
    end

    def set_cell(data = %{graph: graph, height: height, width: width}, {x, y}, cell, elf_power: _) do
      new_graph = Map.put(graph, {x, y}, cell)

      data
      |> Map.put(:graph, new_graph)
      |> Map.put(:height, max(height, y+1))
      |> Map.put(:width, max(width, x+1))
    end

    def increase_iteration(data = %{iteration: iteration}) do
      Map.put(data, :iteration, iteration + 1)
    end

    def get_units(%{graph: graph, height: height, width: width}) do
      Enum.reduce((0..height-1), [], fn y, acc ->
        Enum.reduce((0..width-1), acc, fn x, acc ->
          Map.fetch!(graph, {x, y})
          |> case do
            "u" <> c ->
              [{{x, y}, c} | acc]
            _ -> acc
          end
        end)
      end)
      |> Enum.reverse()
    end

    def move(data = %{graph: graph}, from: coords, to: next_coords) do
      {:ok, cell} = fetch_cell(data, coords)
      # IO.inspect {:move, coords, next_coords, cell}
      {:ok, "."} = fetch_cell(data, next_coords) # sanity check

      new_graph =
        graph
        |> Map.put(next_coords, cell)
        |> Map.put(coords, ".")

      Map.put(data, :graph, new_graph)
    end

    def attack_unit(data = %{graph: graph, units: units}, coords, power: power) do
      {:ok, "u" <> unit_id} = fetch_cell(data, coords)
      {:ok, unit_to_attack = %{health: health}} = fetch_unit(data, unit_id)

      case health - power do
        new_health when new_health > 0 ->
          new_unit = Map.put(unit_to_attack, :health, new_health)
          new_units = Map.put(units, unit_id, new_unit)
          Map.put(data, :units, new_units)

        _killed ->
          new_units = Map.delete(units, unit_id)
          new_graph = Map.put(graph, coords, ".")

          data
          |> Map.put(:units, new_units)
          |> Map.put(:graph, new_graph)
      end
    end

    def print(data = %{graph: graph, height: height, width: width}) do
      Enum.each((0..height-1), fn y ->
        Enum.each((0..width-1), fn x ->
          cell = Map.fetch!(graph, {x, y})
          IO.write(cell <> "\t")
        end)
        IO.write("\n")
      end)
      IO.write("\n")
      data
    end

    defp opposite_type("G"), do: "uE_"
    defp opposite_type("E"), do: "uG_"
  end

  def solve(input, opts \\ []) do
    elf_power = Keyword.get(opts, :elf_power, 3)

    graph = populate_graph(input, elf_power)

    (1..10000)
    |> Enum.reduce_while(graph, fn _i, graph ->
      perform_round(graph)
      |> case do
        {:done, graph} -> {:halt, graph}
        graph ->
          # IO.inspect i
          # Graph.print(graph)
          {:cont, Graph.increase_iteration(graph)}
      end
    end)
  end

  defp perform_round(graph) do
    Graph.get_units(graph)
    |> Enum.reduce({graph, []}, fn {coords, unit_id}, {graph, moves} ->
      Graph.fetch_unit(graph, unit_id)
      |> case do
        :error ->
          # enemy was killed this turn
          {graph, [:killed | moves]}

        {:ok, unit} ->
          enemies_remaining = graph.units |> Map.keys() |> Enum.map(& String.at(&1, 0)) |> Enum.uniq() |> length() == 2

          if !enemies_remaining do
            {graph, [:done | moves]}
          else
            bfs_for_enemy(graph, [{coords, []}], unit.looks_for, MapSet.new())
            |> case do
              :nothing ->
                {graph, [:wait | moves]}

              [_start_at | [_next_coords | []]] ->
                {attack_coords, _, _} = pick_enemy_coords(graph, coords, unit.looks_for)
                {Graph.attack_unit(graph, attack_coords, power: unit.attack), [:attack | moves]}

              [_start_at | [next_coords | _rest_of_path]] ->
                new_graph = Graph.move(graph, from: coords, to: next_coords)
                new_graph =
                  pick_enemy_coords(new_graph, next_coords, unit.looks_for)
                  |> case do
                    nil -> new_graph
                    {attack_coords, _, _} ->
                      Graph.attack_unit(new_graph, attack_coords, power: unit.attack)
                  end

                {new_graph, [:move | moves]}
            end
          end
      end
    end)
    |> case do
      {graph, moves} ->
        if Enum.member?(moves, :done) do
          {:done, graph}
        else
          graph
        end
    end
  end

  def populate_graph(input, elf_power) do
    String.split(input, "\n")
    |> Enum.with_index()
    |> Enum.reduce(Graph.new(), fn {line, y}, graph ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(graph, fn {cell, x}, graph ->
        Graph.set_cell(graph, {x, y}, cell, elf_power: elf_power)
      end)
    end)
  end

  defp bfs_for_enemy(_, frontier, _, _) when frontier == [], do: :nothing

  defp bfs_for_enemy(graph, [{curr, path} | frontier], looks_for, visited) do
    {:ok, cell} = Graph.fetch_cell(graph, curr)
    victory = String.starts_with?(cell, looks_for)
    new_path = [curr | path]
    # IO.inspect {:bfs, curr, cell}

    if victory do
      Enum.reverse(new_path)
    else
      if MapSet.member?(visited, curr) or (path != [] and cell != ".") do
        bfs_for_enemy(graph, frontier, looks_for, visited)
      else
        new_visited = MapSet.put(visited, curr)
        bfs_for_enemy(graph, new_frontier(graph, curr, frontier, visited, new_path), looks_for, new_visited)
      end
    end
  end

  # Add to END of frontier in order up, left, right, down
  defp new_frontier(graph, curr, frontier, visited, new_path) do
    frontier
    |> append_to_frontier(visited, new_path, up(curr), Graph.fetch_cell(graph, up(curr)))
    |> append_to_frontier(visited, new_path, left(curr), Graph.fetch_cell(graph, left(curr)))
    |> append_to_frontier(visited, new_path, right(curr), Graph.fetch_cell(graph, right(curr)))
    |> append_to_frontier(visited, new_path, down(curr), Graph.fetch_cell(graph, down(curr)))
  end

  defp append_to_frontier(frontier, _, _, _, :error), do: frontier
  defp append_to_frontier(frontier, visited, new_path, coords, {:ok, _}) do
    # performance optimization
    if MapSet.member?(visited, coords) do
      frontier
    else
      frontier ++ [{coords, new_path}]
    end
  end

  defp pick_enemy_coords(graph, curr, looks_for) do
    [
      {up(curr), Graph.fetch_cell(graph, up(curr))},
      {left(curr), Graph.fetch_cell(graph, left(curr))},
      {right(curr), Graph.fetch_cell(graph, right(curr))},
      {down(curr), Graph.fetch_cell(graph, down(curr))}
    ]
    |> Enum.map(fn
      {_, :error} -> nil
      {coords, {:ok, cell}} ->
        if String.starts_with?(cell, looks_for) do
          {coords, cell}
        else
          nil
        end
    end)
    |> Enum.reject(& &1 == nil)
    |> Enum.map(fn {coords, "u" <> unit_id} ->
      {:ok, unit} = Graph.fetch_unit(graph, unit_id)
      {coords, unit_id, unit}
    end)
    |> Enum.sort_by(fn {{x, y}, _unit_id, %{health: health}} ->
      {health, y, x}
    end)
    |> List.first()
  end

  defp up({x, y}), do: {x, y-1}
  defp down({x, y}), do: {x, y+1}
  defp left({x, y}), do: {x-1, y}
  defp right({x, y}), do: {x+1, y}
end
