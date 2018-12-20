defmodule Advent.Day20.Solution do
  use ExUnit.Case

  test "part 1 sample" do
    map = generate_map("^WNE$")
    assert get_longest(map) |> Enum.max() == 3

    map = generate_map("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$")
    assert get_longest(map) |> Enum.max() == 23

    map = generate_map("^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$")
    assert get_longest(map) |> Enum.max() == 31
  end

  test "part 1" do
    input = File.read!("input/20.txt") |> String.trim()
    map = generate_map(input)
    assert get_longest(map) |> Enum.max() == 4025
  end

  test "part 2" do
    # map = generate_map("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$")
    # assert get_longest(map) |> Enum.max() == 23
    # IO.inspect get_shortest_path_map(map)

    input = File.read!("input/20.txt") |> String.trim()
    map = generate_map(input)
    assert get_shortest_path_map(map)
    |> Map.values()
    |> Enum.filter(& &1 >= 1000)
    |> length() == 8186
  end

  def get_longest(map) do
    get_longest(map, {0, 0}, 0)
  end

  def get_longest(map, curr, depth) do
    %{connected: neighbors} = Map.fetch!(map, curr)
    # IO.inspect [curr, neighbors]

    if neighbors == [] do
      # end recursion
      depth
    else
      Enum.map(neighbors, fn neighbor ->
        get_longest(map, neighbor, depth+1)
      end)
      |> List.flatten()
    end
  end

  def get_shortest_path_map(map) do
    all_coords = Map.keys(map)

    Enum.reduce(all_coords, %{}, fn target, depth_map ->
      # IO.inspect {"iter", target}
      depth = get_shortest_path_map(map, target, [{0, {0, 0}}])
      Map.put(depth_map, target, depth)
    end)
  end

  def get_shortest_path_map(_map, target, [{depth, curr} | _]) when curr == target do
    depth
  end

  def get_shortest_path_map(map, target, [{depth, curr} | frontier]) do
    %{connected: neighbors} = Map.fetch!(map, curr)

    neighbors = Enum.map(neighbors, & {depth+1, &1})
    new_frontier = frontier ++ neighbors

    get_shortest_path_map(map, target, new_frontier)
  end

  defmodule Node do
    defstruct [:coords, connected: []]

    def new(coords) do
      %__MODULE__{coords: coords, connected: []}
    end

    def connect(node = %{coords: coords, connected: connected}, %{coords: new, connected: new_connected}) do
      if Enum.member?(new_connected, coords) do
        # IO.inspect {"Didn't connect, duplicate", coords, "->", new}
        node
      else
        # IO.inspect {"Connected", coords, "->", new}
        %{node | connected: [new | connected]}
      end
    end
  end

  def generate_map(input) do
    stripped = input |> String.replace_leading("^", "") |> String.replace_trailing("$", "")
    start = Node.new({0, 0})
    generate_map(stripped, %{{0, 0} => start}, {0, 0}, [])
  end

  def generate_map("", map, _, _), do: map

  def generate_map(str, map, curr = {x, y}, return_to) do
    char = String.at(str, 0)
    # IO.inspect [char, curr]
    next_str = String.slice(str, 1, :infinity)
    self = Map.fetch!(map, curr)

    case char do
      "(" ->
        # recurse deeper
        generate_map(next_str, map, curr, [curr | return_to])

      "|" ->
        # return to last return_to and continue
        [next | _new_return_to] = return_to
        generate_map(next_str, map, next, return_to)

      ")" ->
        # return
        [next | new_return_to] = return_to
        generate_map(next_str, map, next, new_return_to)

      "N" ->
        next = {x, y-1}
        node = Map.get(map, next, Node.new(next))
        next_map = Map.put(map, next, node)
        next_map = Map.put(next_map, curr, Node.connect(self, node))
        generate_map(next_str, next_map, next, return_to)

      "S" ->
        next = {x, y+1}
        node = Map.get(map, next, Node.new(next))
        next_map = Map.put(map, next, node)
        next_map = Map.put(next_map, curr, Node.connect(self, node))
        generate_map(next_str, next_map, next, return_to)

      "W" ->
        next = {x-1, y}
        node = Map.get(map, next, Node.new(next))
        next_map = Map.put(map, next, node)
        next_map = Map.put(next_map, curr, Node.connect(self, node))
        generate_map(next_str, next_map, next, return_to)

      "E" ->
        next = {x+1, y}
        node = Map.get(map, next, Node.new(next))
        next_map = Map.put(map, next, node)
        next_map = Map.put(next_map, curr, Node.connect(self, node))
        generate_map(next_str, next_map, next, return_to)

    end
  end
end
