defmodule Advent.Day5.Solution do
  def run(polymer) do
    # IO.inspect(String.length(polymer))
    polymer
    |> String.to_charlist()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [l | r] ->
      l = [l]
      l != r && (:string.uppercase(l) == r || :string.lowercase(l) == r)
    end)
    |> case do
      [] -> polymer
      pairs ->
        pairs
        |> Enum.reduce(polymer, fn pair, polymer ->
          String.replace(polymer, to_string(pair), "")
        end)
        |> run()
    end
  end
end
