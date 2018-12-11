defmodule Advent.Day2.SolutionTest do
  use ExUnit.Case, async: true

  @input File.read!("input/2.txt") |> String.trim()
  @sample_input File.read!("input/2.sample.txt") |> String.trim()
  @sample_input2 File.read!("input/2.sample2.txt") |> String.trim()

  test "part 1 sample" do
    assert solve(@sample_input) == 12
  end

  test "part 1 " do
    assert solve(@input) == 5704
  end

  test "part 2 sample" do
    assert solve_distance(@sample_input2) == {:stop, 'fgij'}
  end

  test "part 2" do
    assert solve_distance(@input) == {:stop, 'umdryabviapkozistwcnihjqx'}
  end

  def solve(input) do
    {x, y} =
      input
      |> String.split("\n")
      |> Enum.reduce({0, 0}, fn line, {occ_2, occ_3} ->
        counts = String.to_charlist(line) |> Enum.group_by(& &1) |> Map.values() |> Enum.map(&length/1)

        {
          (if Enum.member?(counts, 2), do: occ_2 + 1, else: occ_2),
          (if Enum.member?(counts, 3), do: occ_3 + 1, else: occ_3),
        }
      end)

    x*y
  end

  def solve_distance(input) do
    inputs =
      String.split(input, "\n")
      |> Enum.map(&String.to_charlist/1)

    str_size = List.first(inputs) |> length()

    (0..str_size-1)
    |> Enum.reduce(:cont, fn
      _, acc = {:stop, _} -> acc
      position, :cont ->
        shortened_inputs =
          Enum.map(inputs, fn line ->
            List.delete_at(line, position)
          end)

        sorted = Enum.sort(shortened_inputs)

        if length(Enum.uniq(sorted)) != length(sorted) do
          [dupe] = sorted -- Enum.uniq(sorted)
          {:stop, dupe}
        else
          :cont
        end
    end)
  end

  # def solve_distance(input) do
  #   inputs = String.split(input, "\n")

  #   Enum.reduce(inputs, nil, fn line, acc ->
  #     Enum.find(inputs, fn line2 ->
  #       diff = String.myers_difference(line, line2)

  #       if length(Enum.filter(Keyword.keys(diff), & &1 == :eq)) == 2 && length(Enum.filter(Keyword.keys(diff), & &1 == :ins)) == 1 do
  #         IO.inspect diff
  #       end

  #       (Keyword.get(diff, :ins, "") |> String.length() == 1) &&
  #       (Keyword.keys(diff) |> Enum.sort() == [:del, :eq, :eq, :ins])
  #     end)
  #     |> case do
  #       nil ->
  #         acc

  #       found ->
  #         {:stop, line, found, String.myers_difference(line, found)}
  #     end
  #   end)
  # end
end
