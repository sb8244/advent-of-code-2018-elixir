defmodule Advent.Day7.Solution do
  defmodule Node do
    @alphabet ?A..?Z |> Enum.to_list()

    @enforce_keys [:name, :time_to_complete]
    defstruct @enforce_keys ++ [to_nodes: [], from_nodes: []]

    def new(name) do
      [char] = String.to_charlist(name)
      time = 60 + Enum.find_index(@alphabet, &(&1 == char)) + 1

      %Node{name: name, time_to_complete: time}
    end
  end

  defmodule Working do
    @enforce_keys [:name, :completes_at]
    defstruct @enforce_keys
  end

  def nodes(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, &create_and_link_nodes/2)
  end

  def dfs_explore(nodes, incomplete_frontier, path_names) do
    valid_frontier = get_valid_frontier(nodes, incomplete_frontier, path_names)

    Enum.sort_by(valid_frontier, & &1.name)
    |> List.first()
    |> case do
      nil ->
        path_names

      next_node ->
        node = Map.fetch!(nodes, next_node.name)

        additional_frontier = Enum.reject(node.to_nodes, &Enum.member?(path_names, &1))
        frontier = incomplete_frontier ++ additional_frontier

        dfs_explore(nodes, frontier, path_names ++ [node.name])
    end
  end

  @doc """
    nodes = hash of all nodes
    incomplete_frontier = list of node names
    worker_size = int
    path_names = list
    current_tick = int
    working = map
  """
  def concurrent_dfs_explore(
        nodes,
        incomplete_frontier,
        worker_size,
        path_names,
        current_tick,
        unresolved_working
      ) do
    # Resolve workers and calculate the frontier based on the resolution
    {resolved_working_names, working} = resolve_working(current_tick, unresolved_working)

    {path_names, incomplete_frontier} =
      Enum.reduce(resolved_working_names, {path_names, incomplete_frontier}, fn resolved_name, {acc_names, acc_front} ->
        node = Map.fetch!(nodes, resolved_name)
        names = acc_names ++ [resolved_name]

        additional_frontier =
          node.to_nodes
          |> Enum.filter(fn node_name ->
            node = Map.fetch!(nodes, node_name)
            Enum.all?(node.from_nodes, &Enum.member?(names, &1))
          end)
          |> Enum.reject(&Enum.member?(path_names, &1))

        {names, acc_front ++ additional_frontier}
      end)

    capacity = worker_size - map_size(working)

    valid_frontier = get_valid_frontier(nodes, incomplete_frontier, path_names ++ Map.keys(unresolved_working))

    Enum.sort_by(valid_frontier, & &1.name)
    |> Enum.take(capacity)
    |> case do
      list when list == [] ->
        # IO.inspect {current_tick, Map.keys(working), path_names}

        if length(path_names) == length(Map.keys(nodes)) do
          {current_tick, path_names}
        else
          concurrent_dfs_explore(
            nodes,
            incomplete_frontier,
            worker_size,
            path_names,
            current_tick + 1,
            working
          )
        end

      node_list ->
        new_working =
          Enum.reduce(node_list, working, fn node, working ->
            node = Map.fetch!(nodes, node.name)

            Map.put(working, node.name, %Working{
              name: node.name,
              completes_at: current_tick + node.time_to_complete
            })
          end)

        frontier_names = Enum.map(valid_frontier, & &1.name)
        # IO.inspect {current_tick, Map.keys(new_working), path_names}
        concurrent_dfs_explore(
          nodes,
          frontier_names,
          worker_size,
          path_names,
          current_tick + 1,
          new_working
        )
    end
  end

  defp resolve_working(current_tick, working) do
    resolved_working =
      Enum.reject(working, fn {_name, working} ->
        working.completes_at <= current_tick
      end)
      |> Enum.into(%{})

    {Map.keys(working) -- Map.keys(resolved_working), resolved_working}
  end

  defp create_and_link_nodes(line, nodes) do
    [[_, from_name, to_name]] = Regex.scan(~r/Step (.) must be finished before step (.) can begin\./, line)

    from_node = Map.get(nodes, from_name, Node.new(from_name))
    to_node = Map.get(nodes, to_name, Node.new(to_name))

    from_node = %{from_node | to_nodes: [to_node.name | from_node.to_nodes]}
    to_node = %{to_node | from_nodes: [from_node.name | to_node.from_nodes]}

    nodes
    |> Map.put(from_name, from_node)
    |> Map.put(to_name, to_node)
  end

  defp get_valid_frontier(nodes, frontier_names, path_names) do
    frontier_names
    |> Enum.map(&Map.fetch!(nodes, &1))
    |> Enum.filter(fn node ->
      !Enum.member?(path_names, node.name) && Enum.all?(node.from_nodes, &Enum.member?(path_names, &1))
    end)
  end
end
