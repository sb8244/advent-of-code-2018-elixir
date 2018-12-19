defmodule Advent.Day19.Solution do
  use Bitwise

  def solve(input) do
    [ip_line | command_lines] = String.split(input, "\n")
    ip_reg = String.split(ip_line, " ") |> List.last() |> String.to_integer()

    # registers = [0, 10551, 2, 9, 10551361, 0]
    # ip_val = 9

    # 189847

    registers = [0, 0, 0, 0, 0, 0]
    ip_val = 0

    Enum.reduce_while((1..50), {ip_val, registers}, fn _, {ip_val, registers} ->
      command_line = Enum.at(command_lines, ip_val)
      [func | instr] = String.split(command_line, " ")

      registers = List.replace_at(registers, ip_reg, ip_val)

      applied = apply(__MODULE__, String.to_atom(func), [Enum.map(instr, &String.to_integer/1), registers])

      next_instr = Enum.at(applied, ip_reg) + 1
      if Enum.at(command_lines, next_instr) do
        IO.inspect {ip_val, applied}
        {:cont, {next_instr, applied}}
      else
        {:halt, {:done, next_instr, applied}}
      end
    end)
  end

  def addr([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) + Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def addi([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) + b
    List.replace_at(before_registers, c, new_c)
  end

  def mulr([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) * Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def muli([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) * b
    List.replace_at(before_registers, c, new_c)
  end

  def banr([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) &&& Enum.at(before_registers, b)
    List.replace_at(before_registers, c, new_c)
  end

  def bani([a, b, c], before_registers) do
    new_c = Enum.at(before_registers, a) &&& b
    List.replace_at(before_registers, c, new_c)
  end

  def borr([a, b, c], before_registers) do
    new_c = bor(Enum.at(before_registers, a), Enum.at(before_registers, b))
    List.replace_at(before_registers, c, new_c)
  end

  def bori([a, b, c], before_registers) do
    new_c = bor(Enum.at(before_registers, a), b)
    List.replace_at(before_registers, c, new_c)
  end

  def setr([a, _b, c], before_registers) do
    new_c = Enum.at(before_registers, a)
    List.replace_at(before_registers, c, new_c)
  end

  def seti([a, _b, c], before_registers) do
    List.replace_at(before_registers, c, a)
  end

  def gtir([a, b, c], before_registers) do
    new_c = if a > Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def gtri([a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) > b, do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def gtrr([a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) > Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqir([a, b, c], before_registers) do
    new_c = if a == Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqri([a, b, c], before_registers) do
    new_c = if b == Enum.at(before_registers, a), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end

  def eqrr([a, b, c], before_registers) do
    new_c = if Enum.at(before_registers, a) == Enum.at(before_registers, b), do: 1, else: 0
    List.replace_at(before_registers, c, new_c)
  end
end
