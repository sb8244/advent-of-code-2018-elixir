defmodule Advent.Day7.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day7.Solution

  @sample_input File.read!("input/7.sample.txt") |> String.trim()
  @input File.read!("input/7.txt") |> String.trim()

  test "part 1 sample" do
    nodes = Solution.nodes(@sample_input)
    start_nodes = get_start_nodes(nodes)

    path = Solution.dfs_explore(nodes, start_nodes, [])
    assert Enum.join(path) == "CABDFE"
  end

  test "part 1" do
    nodes = Solution.nodes(@input)
    start_nodes = get_start_nodes(nodes)

    path = Solution.dfs_explore(nodes, start_nodes, [])
    assert Enum.join(path) == "GDHOSUXACIMRTPWNYJLEQFVZBK"
  end

  test "part 2 sample" do
    nodes =
      Solution.nodes(@sample_input)
      |> adjust_time_to_complete()

    start_nodes = get_start_nodes(nodes)

    assert Solution.concurrent_dfs_explore(nodes, start_nodes, 2, [], 0, %{}) == {15, ["C", "A", "B", "F", "D", "E"]}
  end

  test "part 2" do
    nodes = Solution.nodes(@input)
    start_nodes = get_start_nodes(nodes)

    assert Solution.concurrent_dfs_explore(nodes, start_nodes, 5, [], 0, %{}) ==
             {1024, ["G", "O", "S", "D", "U", "X", "H", "A", "C", "I", "M", "R", "T", "W", "P", "N", "Y", "J", "L", "E", "Q", "F", "V", "Z", "B", "K"]}
  end

  defp get_start_nodes(nodes) do
    nodes
    |> Map.values()
    |> Enum.filter(fn node ->
      node.from_nodes == []
    end)
    |> Enum.map(& &1.name)
  end

  defp adjust_time_to_complete(nodes) do
    nodes
    |> Enum.map(fn {k, node} ->
      {k, Map.put(node, :time_to_complete, node.time_to_complete - 60)}
    end)
    |> Enum.into(%{})
  end
end
