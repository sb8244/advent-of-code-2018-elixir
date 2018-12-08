defmodule Advent.Day8.Solution do
  defmodule Node do
    @enforce_keys [:num_children, :num_metadata]
    defstruct @enforce_keys ++ [metadata: [], children: []]
  end

  def tree(input) do
    {[], tree} = tree(String.split(input, " "), parent: nil)
    tree
  end

  def reduce(tree = %Node{children: children}, acc, func) do
    acc = func.(tree, acc)
    Enum.reduce(children, acc, fn child, acc ->
      reduce(child, acc, func)
    end)
  end

  def sum_by_metadata_entries(%Node{children: children, metadata: metadata}, acc) when children == [] do
    sum =
      metadata
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    acc + sum
  end

  def sum_by_metadata_entries(%Node{children: children, metadata: metadata}, acc) do
    child_sums =
      children
      |> Enum.map(fn child ->
        sum_by_metadata_entries(child, 0)
      end)
      |> Enum.reverse()

    sum =
      metadata
      |> Enum.map(& String.to_integer(&1) - 1)
      |> Enum.reduce(0, fn index, acc ->
        Enum.at(child_sums, index, 0) + acc
      end)

    acc + sum
  end

  # private

  defp tree(["0" | [num_metadata | rest]], parent: parent) do
    num_metadata = String.to_integer(num_metadata)
    metadata = Enum.take(rest, num_metadata)
    without_metadata = Enum.drop(rest, num_metadata)

    node = %Node{num_children: 0, num_metadata: num_metadata, metadata: metadata}
    new_parent_children = [node | parent.children]
    new_parent = Map.put(parent, :children, new_parent_children)

    {without_metadata, new_parent}
  end

  defp tree([num_children | [num_metadata | rest]], parent: parent_node) do
    num_children = String.to_integer(num_children)
    num_metadata = String.to_integer(num_metadata)
    node = %Node{num_children: num_children, num_metadata: num_metadata}

    {rest, node} =
      Enum.reduce(times(num_children), {rest, node}, fn _, {rest, parent} ->
        tree(rest, parent: parent)
      end)

    this_metadata = Enum.take(rest, num_metadata)
    without_metadata = Enum.drop(rest, num_metadata)
    new_node = Map.put(node, :metadata, this_metadata)

    new_parent = if parent_node do
      new_parent_children = [new_node | parent_node.children]
      Map.put(parent_node, :children, new_parent_children)
    else
      new_node
    end

    {without_metadata, new_parent}
  end

  defp times(n) do
    for i <- 0..n, i > 0, do: i
  end
end
