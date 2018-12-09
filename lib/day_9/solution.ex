defmodule Advent.Day9.Solution do
  def ll_solve(num_players, num_marbles) do
    node = %{n: 0, l: 0, r: 0}
    nodes = %{0 => node}

    play_ll_game({1, 0}, {nodes, 0}, num_players, num_marbles, %{})
  end

  def play_ll_game({current_value, _current_player}, _, _num_players, num_marbles, scores) when current_value == num_marbles do
    scores
  end

  def play_ll_game({current_value, current_player}, {nodes, node_num}, num_players, num_marbles, scores) when rem(current_value, 23) == 0 do
    {nodes, ccw_7_node_n} =
      Enum.reduce(1..7, {nodes, node_num}, fn _, acc ->
        ccw1_node(acc)
      end)

    ccw_7_node = Map.get(nodes, ccw_7_node_n)
    ccw_8_node = Map.get(nodes, ccw_7_node.l)
    ccw_6_node = Map.get(nodes, ccw_7_node.r)

    current_score = Map.get(scores, current_player, 0)
    new_score = current_score + current_value + ccw_7_node.n
    next_player = rem(current_player + 1, num_players)
    new_scores = Map.put(scores, current_player, new_score)

    new_ccw_8_node = %{ccw_8_node | r: ccw_6_node.n}
    new_ccw_6_node = %{ccw_6_node | l: ccw_8_node.n}
    nodes = Map.merge(nodes, %{ccw_8_node.n => new_ccw_8_node, ccw_6_node.n => new_ccw_6_node})

    # IO.inspect current_value
    play_ll_game({current_value + 1, next_player}, {nodes, ccw_6_node.n}, num_players, num_marbles, new_scores)
  end

  def play_ll_game({current_value, current_player}, {nodes, node_num}, num_players, num_marbles, scores) do
    node = Map.get(nodes, node_num)
    cw1_node = Map.get(nodes, node.r)
    cw2_node = Map.get(nodes, cw1_node.r)

    new_node = %{n: current_value, l: cw1_node.n, r: cw2_node.n}
    nodes = Map.put(nodes, current_value, new_node)
    new_cw1_node = %{cw1_node | r: current_value}
    nodes = Map.put(nodes, cw1_node.n, new_cw1_node)
    new_cw2_node = %{Map.get(nodes, cw2_node.n) | l: current_value}
    nodes = Map.put(nodes, cw2_node.n, new_cw2_node)

    next_player = rem(current_player + 1, num_players)

    # Process.sleep(200)
    play_ll_game({current_value + 1, next_player}, {nodes, new_node.n}, num_players, num_marbles, scores)
  end

  def ccw1_node({nodes, node_num}) do
    node = Map.get(nodes, node_num)
    {nodes, Map.get(nodes, node.l).n}
  end
end
