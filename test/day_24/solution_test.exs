defmodule Advent.Day24.SolutionTest do
  use ExUnit.Case

  alias Advent.Day24.Solution

  test "part 1 sample" do
    immune = """
    17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
    989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3
    """ |> String.trim()

    infection = """
    801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
    4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
    """ |> String.trim()

    assert Solution.construct_groups(immune, infection, immune_boost: 0)
    |> Solution.fight()
    |> Map.values()
    |> Enum.map(& &1.num_units)
    |> Enum.sum() == 5216
  end

  test "part 1" do
    immune = File.read!("input/24.immune.txt") |> String.trim()
    infection = File.read!("input/24.infection.txt") |> String.trim()

    assert Solution.construct_groups(immune, infection, immune_boost: 0)
    |> Solution.fight()
    |> Map.values()
    |> Enum.map(& &1.num_units)
    |> Enum.sum() == 17738
  end

  test "part 2" do
    immune = File.read!("input/24.immune.txt") |> String.trim()
    infection = File.read!("input/24.infection.txt") |> String.trim()

    boost =
      (1..10000)
      |> Enum.find(fn boost ->
        Solution.construct_groups(immune, infection, immune_boost: boost)
        |> Solution.fight()
        |> Map.keys()
        |> Enum.all?(& String.starts_with?(&1, "immune"))
      end)

    assert Solution.construct_groups(immune, infection, immune_boost: boost)
    |> Solution.fight()
    |> Map.values()
    |> Enum.map(& &1.num_units)
    |> Enum.sum() == 3057
  end
end
