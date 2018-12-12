defmodule Advent.Day12.SolutionTest do
  use ExUnit.Case, async: true

  @sample_input File.read!("input/12.sample.txt") |> String.trim()
  @input File.read!("input/12.txt") |> String.trim()

  test "part 1 sample" do
    assert solve_a(@sample_input) == 325
  end

  test "part 1" do
    assert solve_a(@input) == 3051
  end

  test "part 2" do
    # This doesn't actually do anything. I ran it and manually inspected iteration + sum to find a pattern. My pattern
    # was increasing by 26 every iteration once it stabilized. Then just some manual math and we have it

    # solve_a(@input, 50_000_000_000)
    # ((50_000_000_000 - 233) * 26) + 6727
  end

  def solve_a(input) do
    solve_a(input, 20)
  end

  def solve_a(input, iter) do
    [start | ["" | rules]] = String.split(input, "\n")
    buffer_size = 1000
    buffer = Enum.map((1..buffer_size), fn _ -> ?. end)
    start = buffer ++ String.to_charlist(start) ++ buffer
    rules = Enum.map(rules, fn rule ->
      rule = String.to_charlist(rule)
      {Enum.take(rule, 5), Enum.at(rule, 9)}
    end)

    (1..iter)
    |> Enum.reduce({start, MapSet.new(start)}, fn i, {state, seen} ->
      next = do_generation(state, rules)

      if Enum.take(next, 5) != '.....' || Enum.take(next, -5) != '.....' do
        IO.inspect "on the edge at #{i}"
      end

      if MapSet.member?(seen, next) do
        IO.inspect "Loop at #{i}"
      end

      # IO.inspect {i, sum_generation(next, buffer_size)}

      {next, MapSet.put(seen, next)}
    end)
    |> elem(0)
    |> Enum.with_index()
    |> Enum.map(fn {char, index} ->
      place = index - buffer_size
      if char == ?# do
        place
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def sum_generation(state, buffer_size) do
    state
    |> Enum.with_index()
    |> Enum.map(fn {char, index} ->
      place = index - buffer_size
      if char == ?# do
        place
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def do_generation(state, rules) do
    # Add buffer of 5 to each side
    state
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.with_index()
    |> Enum.map(fn {plant, index} ->
      Enum.find(rules, fn {rule, _char} ->
        rule == plant
      end)
      |> case do
        nil ->
          {index + 2, ?.}

        {_rule, char} ->
          {index + 2, char}
      end
    end)
    |> Enum.reduce([?., ?., ?., ?.], fn {index, char}, acc ->
      List.insert_at(acc, index, char)
    end)
  end
end
