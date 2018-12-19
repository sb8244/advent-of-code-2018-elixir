defmodule Advent.Day19.SolutionTest do
  use ExUnit.Case
  alias Advent.Day19.Solution

  test "part 1 sample" do
    input = """
    #ip 0
    seti 5 0 1
    seti 6 0 2
    addi 0 1 0
    addr 1 2 3
    setr 1 0 0
    seti 8 0 4
    seti 9 0 5
    """ |> String.trim()

    assert Solution.solve(input) == {:done, 7, [6, 5, 6, 0, 0, 9]}
  end

  # 3 4 5 6 8 9 10 11
  # test "part 1" do
  #   input = """
  #   #ip 3
  #   addi 3 16 3
  #   seti 1 2 1
  #   seti 1 1 2
  #   mulr 1 2 5
  #   eqrr 5 4 5
  #   addr 5 3 3
  #   addi 3 1 3
  #   addr 1 0 0
  #   addi 2 1 2
  #   gtrr 2 4 5
  #   addr 3 5 3
  #   seti 2 3 3
  #   addi 1 1 1
  #   gtrr 1 4 5
  #   addr 5 3 3
  #   seti 1 6 3
  #   mulr 3 3 3
  #   addi 4 2 4
  #   mulr 4 4 4
  #   mulr 3 4 4
  #   muli 4 11 4
  #   addi 5 5 5
  #   mulr 5 3 5
  #   addi 5 15 5
  #   addr 4 5 4
  #   addr 3 0 3
  #   seti 0 6 3
  #   setr 3 5 5
  #   mulr 5 3 5
  #   addr 3 5 5
  #   mulr 3 5 5
  #   muli 5 14 5
  #   mulr 5 3 5
  #   addr 4 5 4
  #   seti 0 5 0
  #   seti 0 1 3
  #   """ |> String.trim()

  #   assert Solution.solve(input) == [6, 5, 6, 0, 0, 9]
  # end

# A B C IP D E
# 0 1 2 3  4 5

# PART1 D = 961
# PART2 D = 10551361

# #ip 3
# 0 addi 3 16 3 # ip = 0 + 16 + 1 = 17
# 1 seti 1 2 1 B = 1
# 2 seti 1 1 2 C = 1
# 3 mulr 1 2 5 E = B*C

# if (B*C == D) {
#   GOTO 7
# } else {
#   GOTO 8
# }

# 4 eqrr 5 4 5 # E = 1 if eq
# 5 addr 5 3 3 # if eq (7) else (6)
# 6 addi 3 1 3 # GOTO 8


# 7 addr 1 0 0 A += B
# 8 addi 2 1 2 C += 1

# if (C > D) {
#   GOTO 12
# } else {
#   GOTO 3
# }

# 9 gtrr 2 4 5
# 10 addr 3 5 3
# 11 seti 2 3 3


# 12 addi 1 1 1 B += 1

# if (B > D) {
#   RETURN
# } else {
#   GOTO 2
# }

# 13 gtrr 1 4 5
# 14 addr 5 3 3
# 15 seti 1 6 3
# 16 mulr 3 3 3 # EXIT


# 17 addi 4 2 4 D = 2
# 18 mulr 4 4 4 D = D*D = 4
# 19 mulr 3 4 4 D = 19 * 4 = 76
# 20 muli 4 11 4 D = 76 * 11 = 836
# 21 addi 5 5 5 E = 5
# 22 mulr 5 3 5 E = 5*22 = 110
# 23 addi 5 15 5 E = 110 + 15 = 125
# 24 addr 4 5 4 D = E+D = 961

# if (PART 2 (A = 1)) {
#   GOTO 27
# } ELSE {
#   GOTO 1
# }

# 25 addr 3 0 3 IP = A (0) + IP
# 26 seti 0 6 3 # GOTO 1

# 27 setr 3 5 5 E = 27
# 28 mulr 5 3 5 E *= 28 = 756
# 29 addr 3 5 5 E += 29 = 785
# 30 mulr 3 5 5 E *= 30 = 23550
# 31 muli 5 14 5 E = 3300 * 14 = 329700
# 32 mulr 5 3 5 E *= 32 = 10550400
# 33 addr 4 5 4 D = 961 + 1478400 = 10551361
# 34 seti 0 5 0 A = 0
# 35 seti 0 1 3 GOTO 1
end
