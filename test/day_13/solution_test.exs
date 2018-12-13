defmodule Advent.Day13.SolutionTest do
  use ExUnit.Case

  @input File.read!("input/13.txt")
  @sample_input File.read!("input/13.sample.txt") |> String.trim()

  @down "v"
  @up "^"
  @left "<"
  @right ">"

  test "part 1 sample" do
    graph = construct_graph(@sample_input)

    assert Enum.reduce((1..1000), graph, fn tick, graph ->
      tick(graph)
    end) == {:halt, "0 piece left", []}
  end

  test "part 1" do
    graph = construct_graph(@input)

    assert (1..100000)
      |> Enum.reduce(graph, fn _tick, graph ->
        tick(graph)
      end) == {:halt, "1 piece left", [{146, 87, "v", 5567}]}
  end

  def tick({:halt, _, _} = res), do: res

  def tick({graph, pieces}) do
    sorted_pieces = Enum.sort_by(pieces, fn {x, y, _, _} -> {y, x} end)

    next_pieces =
      Enum.reduce(sorted_pieces, [], fn {x, y, dir, curr_turn}, pieces ->
        curr = {_, curr_piece} = :digraph.vertex(graph, {x, y})
        next = {{next_x, next_y}, next_piece} = :digraph.vertex(graph, next_location({x, y}, dir))

        next_dir = get_next_dir(next_piece, dir)
        {next_dir, next_turn} = intersect(next_piece, next_dir, curr_turn)

        coming_from_crash = Enum.find(pieces, fn {x2, y2, _, _} -> {x, y} == {x2, y2} end)
        going_to_crash = Enum.find(pieces, fn {x, y, _, _} -> {x, y} == {next_x, next_y} end)

        if coming_from_crash do
          IO.inspect "Crash coming from #{x}, #{y}, removing carts"
          Enum.reject(pieces, & &1 == coming_from_crash)
        else
          if going_to_crash do
            IO.inspect "Crash going to #{next_x}, #{next_y}, removing carts"
            Enum.reject(pieces, & &1 == going_to_crash)
          else
            [{next_x, next_y, next_dir, next_turn} | pieces]
          end
        end
      end)

    if length(next_pieces) <= 1 do
      IO.inspect {"Only 1 piece left", next_pieces}
      {:halt, "#{length(next_pieces)} piece left", next_pieces}
    else
      {graph, next_pieces}
    end
  end

  def get_next_dir("/", @left), do: @down
  def get_next_dir("/", @up), do: @right
  def get_next_dir("/", @right), do: @up
  def get_next_dir("/", @down), do: @left

  def get_next_dir("\\", @right), do: @down
  def get_next_dir("\\", @up), do: @left
  def get_next_dir("\\", @left), do: @up
  def get_next_dir("\\", @down), do: @right
  def get_next_dir(_, dir), do: dir

  def intersect("+", dir, turn) when rem(turn, 3) == 0, do: {turn_left(dir), turn + 1}
  def intersect("+", dir, turn) when rem(turn, 3) == 1, do: {dir, turn + 1}
  def intersect("+", dir, turn) when rem(turn, 3) == 2, do: {turn_right(dir), turn + 1}
  def intersect(_, dir, turn), do: {dir, turn}

  def turn_left(@left), do: @down
  def turn_left(@right), do: @up
  def turn_left(@down), do: @right
  def turn_left(@up), do: @left

  def turn_right(@left), do: @up
  def turn_right(@right), do: @down
  def turn_right(@down), do: @left
  def turn_right(@up), do: @right

  def next_location({x, y}, @right), do: {x+1, y}
  def next_location({x, y}, @left), do: {x-1, y}
  def next_location({x, y}, @down), do: {x, y+1}
  def next_location({x, y}, @up), do: {x, y-1}

  def construct_graph(input) do
    graph = :digraph.new()

    # Create vertices / pieces
    pieces =
      String.split(input, "\n")
      |> Enum.with_index()
      |> Enum.reduce([], fn {line, y}, pieces ->
        String.split(line, "")
        |> Enum.with_index()
        |> Enum.reduce(pieces, fn {cell, x}, pieces ->
          # off by one on x some reason
          x = x-1
          if cell != " " && cell != "" do
            :digraph.add_vertex(graph, {x, y}, cell)
          end

          if cell in ["^", "v", ">", "<"] do
            [{x, y, cell, 0} | pieces]
          else
            pieces
          end
        end)
      end)

    # Create edges
    :digraph.vertices(graph)
    |> Enum.each(fn vertex = {x, y} ->
      :digraph.add_edge(graph, vertex, {x-1, y})
      :digraph.add_edge(graph, vertex, {x+1, y})
      :digraph.add_edge(graph, vertex, {x, y-1})
      :digraph.add_edge(graph, vertex, {x, y+1})
    end)

    {graph, pieces}
  end
end
