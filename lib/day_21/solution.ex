defmodule Advent.Day21.Solution do
  use Bitwise

  def solve(input) do
    [ip_line | command_lines] = String.split(input, "\n")
    ip_reg = String.split(ip_line, " ") |> List.last() |> String.to_integer()
    command_lines = command_lines |> Enum.map(fn line ->
      [func | instr] = String.split(line, " ")
      {String.to_atom(func), Enum.map(instr, &String.to_integer/1)}
    end) |> List.to_tuple()

    registers = %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0}
    ip_val = 0
    iters = 100_000_000_000

    Enum.reduce_while((1..iters), {ip_val, registers, MapSet.new()}, fn _, {ip_val, registers, seen_reg_3} ->
      seen_reg_3 = if ip_val == 28 do
        reg_3 = Map.fetch!(registers, 3)
        if MapSet.member?(seen_reg_3, reg_3) do
          IO.inspect {"Repeat", reg_3, ip_val, registers}
          exit(:done)
          seen_reg_3
        else
          IO.inspect {ip_val, registers}
          MapSet.put(seen_reg_3, reg_3)
        end
      else
        seen_reg_3
      end

      {func, instr} = elem(command_lines, ip_val)
      registers = Map.put(registers, ip_reg, ip_val)
      applied = apply(__MODULE__, func, [instr, registers])
      next_instr = Map.fetch!(applied, ip_reg) + 1
      {:cont, {next_instr, applied, seen_reg_3}}
    end)
  end

  def addr([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) + Map.fetch!(before_registers, b)
    Map.put(before_registers, c, new_c)
  end

  def addi([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) + b
    Map.put(before_registers, c, new_c)
  end

  def mulr([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) * Map.fetch!(before_registers, b)
    Map.put(before_registers, c, new_c)
  end

  def muli([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) * b
    Map.put(before_registers, c, new_c)
  end

  def banr([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) &&& Map.fetch!(before_registers, b)
    Map.put(before_registers, c, new_c)
  end

  def bani([a, b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a) &&& b
    Map.put(before_registers, c, new_c)
  end

  def borr([a, b, c], before_registers) do
    new_c = bor(Map.fetch!(before_registers, a), Map.fetch!(before_registers, b))
    Map.put(before_registers, c, new_c)
  end

  def bori([a, b, c], before_registers) do
    new_c = bor(Map.fetch!(before_registers, a), b)
    Map.put(before_registers, c, new_c)
  end

  def setr([a, _b, c], before_registers) do
    new_c = Map.fetch!(before_registers, a)
    Map.put(before_registers, c, new_c)
  end

  def seti([a, _b, c], before_registers) do
    Map.put(before_registers, c, a)
  end

  def gtir([a, b, c], before_registers) do
    new_c = if a > Map.fetch!(before_registers, b), do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end

  def gtri([a, b, c], before_registers) do
    new_c = if Map.fetch!(before_registers, a) > b, do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end

  def gtrr([a, b, c], before_registers) do
    new_c = if Map.fetch!(before_registers, a) > Map.fetch!(before_registers, b), do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end

  def eqir([a, b, c], before_registers) do
    new_c = if a == Map.fetch!(before_registers, b), do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end

  def eqri([a, b, c], before_registers) do
    new_c = if b == Map.fetch!(before_registers, a), do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end

  def eqrr([a, b, c], before_registers) do
    new_c = if Map.fetch!(before_registers, a) == Map.fetch!(before_registers, b), do: 1, else: 0
    Map.put(before_registers, c, new_c)
  end
end
