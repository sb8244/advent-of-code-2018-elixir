defmodule Advent.Day8.Solution do
  defmodule Node do
    @enforce_keys [:num_children, :num_metadata, :metadata, :children]
    defstruct @enforce_keys
  end

  # 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  # A----------------------------------
  #     B----------- C-----------
  #                     D-----

  2 3 *0 3 10 11 12* *1 1 0 1 99 2* 1 1 2
  0 3 10 11 12
  1 1 *0 1 99* 2
  0 1 99

  def tree(input) do
    tree(String.split(input, " "), parent: nil)
  end

  def tree(list, parent: parent_node) when list == [], do: parent_node

  def tree([num_children | [num_metadata | rest]], parent: parent_node) do
    num_children = String.to_integer(num_children)
    num_metadata = String.to_integer(num_metadata)

    metadata = Enum.take(rest, -num_metadata)
    trimmed_rest = Enum.drop(rest, -num_metadata)

    IO.inspect {num_children, num_metadata, rest}

    my_node = %Node{num_children: num_children, num_metadata: num_metadata, metadata: metadata, children: []}
    tree(trimmed_rest, parent: my_node)
  end
end
