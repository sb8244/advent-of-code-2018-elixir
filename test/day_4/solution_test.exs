defmodule Advent.Day4.SolutionTest do
  use ExUnit.Case

  @input File.read!("input/4.txt") |> String.trim()

  test "part 1" do
    @input
    |> String.split("\n")
    |> Enum.sort_by(fn line ->
      [ymd | _] = String.split(line, " ")

      {ymd, String.contains?(line, "begins shift")}
    end)
    |> IO.inspect()
  end
end
