defmodule Advent.Day24.Solution do
  defmodule Group do
    defstruct [:id, :type, :num_units, :hp, :attack_type, :attack_power, :initiative, weak_to: [], immune_to: []]

    def new(id, type, num_units, hp, weak_to_str, immune_to_str, attack_power, attack_type, initiative) do
      %__MODULE__{
        id: id,
        type: type,
        num_units: String.to_integer(num_units),
        hp: String.to_integer(hp),
        weak_to: String.split(weak_to_str, ", ") |> Enum.reject(& &1 == ""),
        immune_to: String.split(immune_to_str, ", ") |> Enum.reject(& &1 == ""),
        attack_power: String.to_integer(attack_power),
        attack_type: attack_type,
        initiative: String.to_integer(initiative)
      }
    end

    def effective_power(%{num_units: n, attack_power: p}), do: n * p

    def compute_damage(attacker: a, defender: b) do
      if a.attack_type in b.immune_to do
        0
      else
        if a.attack_type in b.weak_to do
          effective_power(a) * 2
        else
          effective_power(a)
        end
      end
    end
  end

#   17 units each with 5390 hit points (weak to radiation, bludgeoning) with
#   an attack that does 4507 fire damage at initiative 2
#  989 units each with 1274 hit points (immune to fire; weak to bludgeoning,
#   slashing) with an attack that does 25 slashing damage at initiative 3

  def construct_groups(immune_input, infection_input) do
    Map.merge(construct_group(immune_input, :immune), construct_group(infection_input, :infection))
  end

  def fight(groups) do
    Enum.reduce_while((1..100_000), groups, fn _, groups ->
      targets = targeting(groups)
      new_groups = attacking(groups, targets)
      type_length = new_groups |> Map.values() |> Enum.map(& &1.type) |> Enum.uniq() |> length()

      if type_length == 1 do
        {:halt, new_groups}
      else
        {:cont, new_groups}
      end
    end)
  end

  def construct_group(input, type) do
    String.split(input, "\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, id}, acc ->
      [_, num_units, hp] = Regex.run(~r/(.*) units each with (.*) hit points/, line)
      [_, attack_power, attack_type, initiative] = Regex.run(~r/an attack that does (\d*) (.*) damage at initiative (\d*)/, line)
      [_, weak_to] = Regex.run(~r/weak to ([\w,\s]*)/, line) || [nil, ""]
      [_, immune_to] = Regex.run(~r/immune to ([\w,\s]*)/, line) || [nil, ""]

      id = "#{type}:#{id+1}"
      group = Group.new(id, type, num_units, hp, weak_to, immune_to, attack_power, attack_type, initiative)
      Map.put(acc, id, group)
    end)
  end

  defp targeting(groups_map) do
    groups = Map.values(groups_map)
    immunes = Enum.filter(groups, & &1.type == :immune)
    infections = Enum.filter(groups, & &1.type == :infection)

    groups
    |> Enum.sort_by(& {Group.effective_power(&1), &1.initiative})
    |> Enum.reverse()
    |> Enum.reduce({%{}, []}, fn group, {acc, taken_groups} ->
      candidates = if group.type == :immune do
        infections -- taken_groups
      else
        immunes -- taken_groups
      end

      will_attack =
        Enum.sort_by(candidates, fn candidate ->
          {
            Group.compute_damage(attacker: group, defender: candidate),
            Group.effective_power(candidate),
            candidate.initiative
          }
        end)
        |> List.last()

      if will_attack do
        {Map.put(acc, group.id, will_attack.id), [will_attack | taken_groups]}
      else
        {acc, taken_groups}
      end
    end)
    |> elem(0)
  end

  defp attacking(ogroups, targets) do
    ogroups
    |> Map.values()
    |> Enum.sort_by(& &1.initiative)
    |> Enum.reverse()
    |> Enum.reduce(ogroups, fn attacking, groups ->
      attacking = Map.get(groups, attacking.id)

      if attacking do
        defender_id = Map.get(targets, attacking.id)
        defender = Map.get(groups, defender_id)

        if defender do
          damage = Group.compute_damage(attacker: attacking, defender: defender)
          units_lost = Integer.floor_div(damage, defender.hp)
          new_defender = %{defender | num_units: defender.num_units - units_lost}

          # IO.inspect {attacking.id, defender.id, attacking.initiative, damage, units_lost, new_defender.num_units}

          if new_defender.num_units <= 0 do
            Map.delete(groups, defender.id)
          else
            Map.put(groups, defender.id, new_defender)
          end
        else
          groups
        end
      else
        groups
      end
    end)
  end
end
