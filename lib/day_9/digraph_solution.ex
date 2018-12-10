defmodule Advent.Day9.DigraphSolution do
  def solve(num_players, num_marbles) do
    circle = :digraph.new()

    :digraph.add_vertex(circle, 0)
    :digraph.add_edge(circle, 0, 0)

    play_game({1, 0}, {circle, 0}, num_players, num_marbles, %{})
  end

  def play_game({current_value, _current_player}, _circle, _num_players, num_marbles, scores) when current_value == num_marbles do
    scores
  end

  def play_game({current_value, current_player}, {circle, current_piece}, num_players, num_marbles, scores) when rem(current_value, 23) == 0 do
    [ccw_7_node_n] =
      Enum.reduce(1..7, [current_piece], fn _, [curr_node] ->
        :digraph.in_neighbours(circle, curr_node)
      end)

    [ccw_8_node_n] = :digraph.in_neighbours(circle, ccw_7_node_n)
    [ccw_6_node_n] = :digraph.out_neighbours(circle, ccw_7_node_n)
    :digraph.add_edge(circle, ccw_8_node_n, ccw_6_node_n)
    :digraph.del_vertex(circle, ccw_7_node_n)

    current_score = Map.get(scores, current_player, 0)
    new_score = current_score + current_value + ccw_7_node_n
    next_player = rem(current_player + 1, num_players)
    new_scores = Map.put(scores, current_player, new_score)

    play_game({current_value + 1, next_player}, {circle, ccw_6_node_n}, num_players, num_marbles, new_scores)
  end

  def play_game({current_value, current_player}, {circle, current_piece}, num_players, num_marbles, scores) do
    [right_n] = :digraph.out_neighbours(circle, current_piece)
    [right_2_n] = :digraph.out_neighbours(circle, right_n)

    # create new vertex and insert it into the Linked List
    new_node = :digraph.add_vertex(circle, current_value)
    :digraph.del_edges(circle, :digraph.out_edges(circle, right_n))
    :digraph.add_edge(circle, right_n, new_node)
    :digraph.add_edge(circle, new_node, right_2_n)

    next_player = rem(current_player + 1, num_players)

    play_game({current_value + 1, next_player}, {circle, new_node}, num_players, num_marbles, scores)
  end
end
