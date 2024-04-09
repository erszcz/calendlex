defmodule Calendlex.TimeSlots do
  @spec build(Date.t(), String.t(), non_neg_integer) :: [DateTime.t()]
  def build(date, time_zone, duration) do
    from =
      date
      |> Timex.to_datetime(time_zone)
      |> Timex.set(hour: day_start())

    to = Timex.set(from, hour: day_end())

    from
    |> Stream.iterate(&DateTime.add(&1, duration * 60, :second))
    |> Stream.take_while(&(DateTime.diff(to, &1) > 0))
    |> Enum.to_list()
  end

  defp day_start(), do: Application.fetch_env!(:calendlex, :owner)[:day_start]

  defp day_end(), do: Application.fetch_env!(:calendlex, :owner)[:day_end]
end
