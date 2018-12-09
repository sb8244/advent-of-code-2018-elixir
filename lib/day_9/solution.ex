defmodule Advent.Day9.Solution do
  def solve(num_players, num_marbles) do
    play_game({1, 0, 0}, {0}, 1, num_players, num_marbles, %{})
  end

  def ll_solve(num_players, num_marbles) do
    node = %{n: 0, l: 0, r: 0}
    nodes = %{0 => node}

    play_ll_game({1, 0}, {nodes, 0}, num_players, num_marbles, %{})
  end

  def play_ll_game({current_value, _current_player}, _, _num_players, num_marbles, scores) when current_value == num_marbles do
    scores
  end

  def play_ll_game({current_value, current_player}, {nodes, node_num}, num_players, num_marbles, scores) when rem(current_value, 23) == 0 do
    {nodes, ccw_7_node_n} = Enum.reduce((1..7), {nodes, node_num}, fn _, acc ->
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

  def cw1_node({nodes, node_num}) do
    node = Map.get(nodes, node_num)
    {nodes, Map.get(nodes, node.r).n}
  end

  def ccw1_node({nodes, node_num}) do
    node = Map.get(nodes, node_num)
    {nodes, Map.get(nodes, node.l).n}
  end

  def play_game({current_value, _, _}, _cir, _cir_size, _num_player, num_marbles, scores) when current_value == num_marbles do
    scores
  end

  def play_game({current_value, current_index, current_player}, circle, circle_size, num_players, num_marbles, scores) when rem(current_value, 23) == 0 do
    current_score = Map.get(scores, current_player, 0)
    ccwise_7_index = mod(current_index - 7, circle_size)

    new_score = current_score + current_value + elem(circle, ccwise_7_index)
    new_circle = Tuple.delete_at(circle, ccwise_7_index)
    next_player = rem(current_player + 1, num_players)
    new_scores = Map.put(scores, current_player, new_score)

    # IO.inspect(current_value)

    play_game({current_value + 1, ccwise_7_index, next_player}, new_circle, circle_size - 1, num_players, num_marbles, new_scores)
  end

  def play_game({current_value, current_index, current_player}, circle, circle_size, num_players, num_marbles, scores) do
    clockwise_1_index = mod(current_index + 1, circle_size)
    new_index = clockwise_1_index + 1
    new_circle = Tuple.insert_at(circle, new_index, current_value)
    next_player = rem(current_player + 1, num_players)

    # IO.inspect {current_value, clockwise_1_index, clockwise_2_index, num_marbles, scores}
    play_game({current_value + 1, new_index, next_player}, new_circle, circle_size + 1, num_players, num_marbles, scores)
  end

  defp mod(x,y) when x > 0, do: rem(x, y);
  defp mod(x,y) when x < 0, do: rem(x, y) + y;
  defp mod(0,_y), do: 0
end
