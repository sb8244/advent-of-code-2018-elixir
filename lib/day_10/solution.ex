defmodule Advent.Day10.Solution do
  # position=< 9,  1> velocity=< 0,  2>
  def solve(input) do
    points =
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [[_, pos_str], [_, vel_str]] = Regex.scan(~r/<([^>]*)>/, line)
        [pos_x, pos_y] = String.split(pos_str, ",") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
        [vel_x, vel_y] = String.split(vel_str, ",") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)

        {{pos_x, pos_y}, {vel_x, vel_y}}
      end)

    {points, tick} = tick_until_touching(points, false, 0)

    {tick, visualize(points)}
  end


  def visualize(points) do
    points =
      Enum.map(points, fn {point, _vel} ->
        point
      end)

    {min_x, max_x} = points |> Enum.map(& elem(&1, 0)) |> Enum.min_max
    {min_y, max_y} = points |> Enum.map(& elem(&1, 1)) |> Enum.min_max

    Enum.reduce((min_y..max_y), "", fn y, str ->
      Enum.reduce((min_x..max_x), str, fn x, str ->
        if Enum.member?(points, {x, y}) do
          str <> "X"
        else
          str <> "."
        end
      end) <> "\n"
    end)
  end

  defp tick_until_touching(points, true, iter), do: {points, iter}

  defp tick_until_touching(points, touching, iter) do
    next_points = tick(points)
    touching = all_touching?(next_points)
    tick_until_touching(next_points, touching, iter + 1)
  end

  defp tick(points) do
    Enum.map(points, fn {{pos_x, pos_y}, vel = {vel_x, vel_y}} ->
      {{pos_x + vel_x, pos_y + vel_y}, vel}
    end)
  end

  defp all_touching?(points) do
    Enum.all?(points, fn {{pos_x, pos_y}, _} ->
      Enum.any?(points, fn {{test_x, test_y}, _} ->
        same = pos_x == test_x && pos_y == test_y
        x_diff = abs(pos_x - test_x)
        y_diff = abs(pos_y - test_y)
        touching = x_diff <= 1 && y_diff <= 1 #  (x_diff == 1 && y_diff == 0) || (y_diff == 1 && x_diff == 0)

        !same && touching
      end)
    end)
  end
end
