defmodule Advent.Day16.Solution do
  use Bitwise

  def compute_possible_opcodes(input) do
    samples =
      String.split(input, "\n")
      |> Enum.chunk_every(3, 4, :discard)

    Enum.reduce(samples, [], fn [before, cmd, aft], acc ->
      [_, before] = Regex.run(~r/\[(.*)\]/, before)
      [_, aft] = Regex.run(~r/\[(.*)\]/, aft)
      before_parts = String.split(before, ", ") |> Enum.map(&String.to_integer/1)
      after_parts = String.split(aft, ", ") |> Enum.map(&String.to_integer/1)
      cmd = String.split(cmd, " ") |> Enum.map(&String.to_integer/1)

      [{List.first(cmd), command_matches(cmd, before_parts, after_parts)} | acc]
    end)
  end

  def resolve_opcodes(possible_opcodes) do
    assemble_opcodes(possible_opcodes)
    |> reduce_opcodes(%{})
  end

  def execute_program(input, opcodes) do
    String.split(input, "\n")
    |> Enum.reduce([0, 0, 0, 0], fn line, registers ->
      command = [opcode, _, _, _] = String.split(line, " ") |> Enum.map(&String.to_integer/1)
      command_fn = Map.fetch!(opcodes, opcode)
      apply(__MODULE__, command_fn, [command, registers])
    end)
  end

  defp assemble_opcodes(possible_opcodes) do
    Enum.reduce(possible_opcodes, %{}, fn {opcode, possible_cmds}, acc ->
      possibilities = MapSet.new(possible_cmds)
      existing_possibilities = Map.get(acc, opcode, possibilities)
      # IO.inspect {opcode, possibilities, existing_possibilities}
      Map.put(acc, opcode, MapSet.intersection(existing_possibilities, possibilities))
    end)
  end

  defp reduce_opcodes(assembled, reduced) do
    if Enum.count(reduced) == 16 do
      reduced
    else
      {new_assembled, new_reduced} =
        Enum.reduce(assembled, {assembled, reduced}, fn {opcode, set}, acc = {assembled, reduced} ->
          if Enum.count(set) == 1 do
            certain_opcode = Enum.at(set, 0)
            new_reduced = Map.put(reduced, opcode, certain_opcode)
            new_assembled = Enum.map(assembled, fn {k, set} ->
              {k, MapSet.delete(set, certain_opcode)}
            end)
            |> Enum.into(%{})

            {new_assembled, new_reduced}
          else
            acc
          end
        end)

      reduce_opcodes(new_assembled, new_reduced)
    end
  end

  @commands [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]

  defp command_matches(cmd, before_reg, after_reg) do
    Enum.reduce(@commands, [], fn func, matches ->
      if apply(__MODULE__, func, [cmd, before_reg]) == after_reg do
        [func | matches]
      else
        matches
      end
    end)
  end

  def addr([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) + Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def addi([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) + b
    List.replace_at(before_registers, c, new_c)
  end

  def mulr([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) * Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def muli([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) * b
    List.replace_at(before_registers, c, new_c)
  end

  def banr([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) &&& Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def bani([_opcode, a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) &&& b
    List.replace_at(before_registers, c, new_c)
  end

  def borr([_opcode, a, b, c], before_registers) do
    new_c = bor(Enum.at(before_registers, a), Enum.at(before_registers, b))
    List.replace_at(before_registers, c, new_c)
  end

  def bori([_opcode, a, b, c], before_registers) do
    new_c = bor(Enum.at(before_registers, a), b)
    List.replace_at(before_registers, c, new_c)
  end

  def setr([_opcode, a, _b, c], before_registers) do
    new_c = Enum.at(before_registers, a)
    List.replace_at(before_registers, c, new_c)
  end

  def seti([_opcode, a, _b, c], before_registers) do
    List.replace_at(before_registers, c, a)
  end

  def gtir([_opcode, a, b, c], before_registers) do
    new_c = if a > Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def gtri([_opcode, a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) > b, do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def gtrr([_opcode, a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) > Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqir([_opcode, a, b, c], before_registers) do
    new_c = if a == Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqri([_opcode, a, b, c], before_registers) do
    new_c = if b == Enum.at(before_registers, a), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqrr([_opcode, a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) == Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end
end
