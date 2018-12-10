defmodule Advent.Day10.SolutionTest do
  use ExUnit.Case, async: true
  alias Advent.Day10.Solution

  @sample_input File.read!("input/10.sample.txt") |> String.trim()
  @input File.read!("input/10.txt") |> String.trim()

  test "part 1 sample" do
    {tick, visual} = Solution.solve(@sample_input)
    assert tick == 3
    assert visual == """
    X...X..XXX
    X...X...X.
    X...X...X.
    XXXXX...X.
    X...X...X.
    X...X...X.
    X...X...X.
    X...X..XXX
    """
  end

  test "part 1" do
    {tick, visual} = Solution.solve(@input)
    assert tick == 10418
    assert visual == """
    XXXXXX..X....X..X....X..XXXXX...XXXXXX.....XXX..X....X..XXXXX.
    .....X..XX...X..XX...X..X....X.......X......X...X....X..X....X
    .....X..XX...X..XX...X..X....X.......X......X....X..X...X....X
    ....X...X.X..X..X.X..X..X....X......X.......X....X..X...X....X
    ...X....X.X..X..X.X..X..XXXXX......X........X.....XX....XXXXX.
    ..X.....X..X.X..X..X.X..X..X......X.........X.....XX....X.....
    .X......X..X.X..X..X.X..X...X....X..........X....X..X...X.....
    X.......X...XX..X...XX..X...X...X.......X...X....X..X...X.....
    X.......X...XX..X...XX..X....X..X.......X...X...X....X..X.....
    XXXXXX..X....X..X....X..X....X..XXXXXX...XXX....X....X..X.....
    """
  end
end
