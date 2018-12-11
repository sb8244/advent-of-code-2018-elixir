defmodule Advent.Day11.Solution do
  def solve(serial) do
    Enum.reduce(1..300, {-100_000, nil}, fn x, acc ->
      Enum.reduce(1..300, acc, fn y, acc = {max, _coords} ->
        three_by_three_sum = three_by_three(x, y, serial)

        if three_by_three_sum > max do
          {three_by_three_sum, {x, y}}
        else
          acc
        end
      end)
    end)
  end

  def solve_arbitrary(serial) do
    Enum.reduce(8..20, {-100_000, nil}, fn n_size, acc ->
      Enum.reduce(1..300, acc, fn x, acc ->
        Enum.reduce(1..300, acc, fn y, acc = {max, _coords} ->
          n_by_n_sum = n_by_n(n_size, x, y, serial)

          if n_by_n_sum > max do
            {n_by_n_sum, {x, y, n_size}}
          else
            acc
          end
        end)
      end)
    end)
  end

  def power(x, y, serial) do
    (((x + 10) * y + serial) * (x + 10))
    |> Integer.floor_div(100)
    |> rem(10)
    |> Kernel.-(5)
  end

  def three_by_three(x, y, _) when x >= 298 or y >= 298, do: -100_000

  def three_by_three(x, y, serial) do
    Enum.reduce(0..2, 0, fn x_inc, sum ->
      Enum.reduce(0..2, sum, fn y_inc, sum ->
        sum + power(x + x_inc, y + y_inc, serial)
      end)
    end)
  end

  def n_by_n(n, x, y, _) when x + n > 301 or y + n >= 301, do: -100_000

  def n_by_n(n, x, y, serial) do
    Enum.reduce(0..(n - 1), 0, fn x_inc, sum ->
      Enum.reduce(0..(n - 1), sum, fn y_inc, sum ->
        sum + power(x + x_inc, y + y_inc, serial)
      end)
    end)
  end
end
