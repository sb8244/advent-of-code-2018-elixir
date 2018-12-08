defmodule Advent.Day5.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day5.Solution

  test "example" do
    assert Solution.run("aA") == ""
    assert Solution.run("abBA") == ""
    assert Solution.run("abAB") == "abAB"
    assert Solution.run("aabAAB") == "aabAAB"
    assert Solution.run("dabAcCaCBAcCcaDA") == "dabCBAcaDA"

    assert Solution.run("dDd") == "d"
    assert Solution.run("dDDd") == ""
  end

  test "part 1" do
    input = File.read!("input/5.txt") |> String.trim()
    assert Solution.run(input)
    |> String.length() == 10598
  end

  test "part 2" do
    input = File.read!("input/5.txt") |> String.trim()

    assert Enum.map((0..25), fn char_index ->
        Task.async(fn ->
          char = to_string([97 + char_index])
          pruned =
            input
            |> String.replace(char, "")
            |> String.replace(String.upcase(char), "")
          Solution.run(pruned) |> String.length()
        end)
      end)
      |> Enum.map(fn task ->
        Task.await(task, 30_000)
      end)
      |> Enum.min() == 5312
  end
end
