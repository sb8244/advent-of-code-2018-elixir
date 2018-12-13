defmodule Advent.Day4.SolutionTest do
  use ExUnit.Case

  @input File.read!("input/4.txt") |> String.trim()

  test "part 1" do
    all_info =
      gather_info(@input)
      |> Enum.reduce(%{}, fn {ymd, info}, acc ->
        guard_info = Map.get(acc, info.guard, %{sleep_time: 0, asleep_at: %{}})

        guard_info =
          Enum.chunk_every(info.events, 2)
          |> Enum.reduce(guard_info, fn [sleep: sleep, wake: wake], guard_info ->
            sleep_range = (sleep..wake-1)
            sleep_s = wake - sleep
            new_asleep_at =
              (0..59)
              |> Enum.reduce(guard_info.asleep_at, fn minute, asleep_at ->
                if minute in sleep_range  do
                  existing_time = Map.get(asleep_at, minute, 0)
                  Map.put(asleep_at, minute, existing_time + 1)
                else
                  asleep_at
                end
              end)

            Map.merge(guard_info, %{sleep_time: guard_info.sleep_time + sleep_s, asleep_at: new_asleep_at})
          end)

        Map.put(acc, info.guard, guard_info)
      end)

    {guard_id, guard_info} =
      all_info
      |> Enum.sort_by(fn {_id, %{sleep_time: time}} -> time end)
      |> List.last()
    {minute, _time} = Map.fetch!(guard_info, :asleep_at) |> Enum.sort_by(fn {_min, value} -> value end) |> List.last()
    IO.inspect({"Part 1 solution is", guard_id, minute})

    {guard_id, guard_info} =
      all_info
      |> Enum.sort_by(fn {_id, %{asleep_at: asleep_at}} ->
        asleep_at
        |> Map.values()
        |> case do
          [] -> 0
          list -> Enum.max(list)
        end
      end)
      |> List.last()

    {minute, _time} = Map.fetch!(guard_info, :asleep_at) |> Enum.sort_by(fn {_min, value} -> value end) |> List.last()
    IO.inspect({"Part 2 solution is", guard_id, minute})
  end

  defp gather_info(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      ["[" <> ymd | [time | _]] = String.split(line, " ")
      time = String.replace(time, "]", "")

      acc =
        Regex.scan(~r/Guard (.*) begins/, line)
        |> case do
          [] ->
            event = if String.contains?(line, "wakes up"), do: :wake, else: :sleep
            acc_day = Map.get(acc, ymd, %{events: []})
            minute = String.split(time, ":") |> List.last() |> String.to_integer()
            new_events =
              [{event, minute} | acc_day.events]
              |> Enum.sort_by(& elem(&1, 1))
            acc_day = Map.put(acc_day, :events, new_events)
            Map.put(acc, ymd, acc_day)

          [[_, guard_num]] ->
            guard_ymd =
              if String.starts_with?(time, "23:") do
                {:ok, date} = NaiveDateTime.from_iso8601("#{ymd} 00:00:00Z")
                NaiveDateTime.add(date, 24*60*60) |> NaiveDateTime.to_string() |> String.split(" ") |> List.first()
              else
                ymd
              end

            # IO.inspect "Guard #{guard_num} on #{guard_ymd}"

            acc_day = Map.get(acc, guard_ymd, %{events: []})
            if Enum.member?(acc_day, :guard), do: throw "Invalid guard #{guard_ymd}"
            acc_day = Map.put(acc_day, :guard, guard_num)
            Map.put(acc, guard_ymd, acc_day)
        end

      acc
    end)
  end
end
