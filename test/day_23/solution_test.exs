defmodule Advent.Day23.SolutionTest do
  use ExUnit.Case

  test "part 1 sample" do
    input = """
    pos=<0,0,0>, r=4
    pos=<1,0,0>, r=1
    pos=<4,0,0>, r=3
    pos=<0,2,0>, r=1
    pos=<0,5,0>, r=3
    pos=<0,0,3>, r=1
    pos=<1,1,1>, r=1
    pos=<1,1,2>, r=1
    pos=<1,3,1>, r=1
    """ |> String.trim()

    bots = parse_input(input)

    assert most_in_range_for_largest(bots) == 7
  end

  test "part 1" do
    input = File.read!("input/23.txt") |> String.trim()

    bots = parse_input(input)

    assert most_in_range_for_largest(bots) == 7
  end

  test "part 2" do
    # Idea for part 2 is to get the distances and then do a "binary search" for the closest max points. This is
    # a bit messy in practice due to having competing coordinates. So once it got to a small enough rstep (95),
    # I just ran the rest with step=10 and it was the right answer.
    input = File.read!("input/23.txt") |> String.trim()

    bots = parse_input(input)

    {low_x, high_x} = Map.keys(bots) |> Enum.map(& elem(&1, 0)) |> Enum.min_max()
    {low_y, high_y} = Map.keys(bots) |> Enum.map(& elem(&1, 1)) |> Enum.min_max()
    {low_z, high_z} = Map.keys(bots) |> Enum.map(& elem(&1, 2)) |> Enum.min_max()
    {min_r, max_r} = Map.values(bots) |> Enum.min_max()
    rstep = max_r - min_r

    {[{x, y, z}], _} = part_2_algorithm(bots, {low_x, high_x}, {low_y, high_y}, {low_z, high_z}, rstep)
    {[{x, y, z}], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z}], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z}], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z}], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z}], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    rstep = Integer.floor_div(rstep, 2)
    {[{x, y, z} | _], _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, Integer.floor_div(rstep, 2))

    {coords, _} = part_2_algorithm(bots, {x-rstep, x+rstep}, {y-rstep, y+rstep}, {z-rstep, z+rstep}, 10)
    assert Enum.map(coords, fn {x,y,z} -> x+y+z end)
    |> Enum.sort()
    |> List.first() == 112997634
  end


  # 583 when r_step = min_r
  # 762 when r_step = min_r / 5
  # 797 min_r / 7
  # 809 min_r / 9
  # 826 min_r / 12
  # 843 min _r / 14 {15845720, 46721849, 46256008}
  # 847 min_r / 16  {18520766, 47613535, 45810182}
  def part_2_algorithm(bots, {low_x, high_x}, {low_y, high_y}, {low_z, high_z}, r_step) do
    IO.inspect r_step
    xs = Stream.iterate(low_x, &(&1 + r_step)) |> Enum.take_while(& &1 < high_x)
    ys = Stream.iterate(low_y, &(&1 + r_step)) |> Enum.take_while(& &1 < high_y)
    zs = Stream.iterate(low_z, &(&1 + r_step)) |> Enum.take_while(& &1 < high_z)

    Enum.reduce(xs, {[], 0}, fn x, acc ->
      Enum.reduce(ys, acc, fn y, acc ->
        Enum.reduce(zs, acc, fn z, acc = {max_coords, max_count} ->
          in_radius =
            Enum.filter(bots, fn {{x2, y2, z2}, radius} ->
              dist = abs(x - x2) + abs(y - y2) + abs(z - z2)
              dist <= radius
            end)
            |> length()

          if in_radius == max_count do
            {[{x, y, z} | max_coords], in_radius}
          else
            if in_radius > max_count do
              {[{x, y, z}], in_radius}
            else
              acc
            end
          end
        end)
      end)
    end)
    # |> elem(0)
    # |> Enum.map(fn {x,y,z} -> x+y+z end)
    # |> Enum.sort()
    # |> List.first()
    # |> IO.inspect()
  end

  def most_in_range_for_largest(bots) do
    [{{x, y, z}, radius} | _] = Enum.sort_by(bots, fn {_k, v} -> -v end)
    Enum.filter(bots, fn {{x2, y2, z2}, _} ->
      dist = abs(x - x2) + abs(y - y2) + abs(z - z2)
      dist <= radius
    end)
    |> length()
  end

  def most_in_range(bots) do
    Enum.reduce(bots, {[], 0}, fn {coords = {x, y, z}, radius}, acc = {max_coords, max_count} ->
      in_radius =
        Enum.filter(bots, fn {{x2, y2, z2}, _} ->
          dist = abs(x - x2) + abs(y - y2) + abs(z - z2)
          dist <= radius
        end)
        |> length()

      if in_radius == max_count do
        {[coords | max_coords], in_radius}
      else
        if in_radius > max_count do
          {[coords], in_radius}
        else
          acc
        end
      end
    end)
  end

  def parse_input(input) do
    String.split(input, "\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [_, x, y, z] = Regex.run(~r/<(.*),(.*),(.*)>/, line)
      [_, r] = Regex.run(~r/r=(.*)/, line)
      coords = {String.to_integer(x), String.to_integer(y), String.to_integer(z)}

      Map.put(acc, coords, String.to_integer(r))
    end)
  end
end
