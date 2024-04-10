defmodule CalendlexWeb.ScheduleEventLive do
  use CalendlexWeb, :live_view

  alias Calendlex.Event

  def mount(params, _session, socket) do
    %{"event_type_slug" => slug, "time_slot" => time_slot} = params

    with {:ok, event_type} <- Calendlex.get_event_type_by_slug(slug),
         {:ok, start_at, _} <- DateTime.from_iso8601(time_slot) do
      end_at = Timex.add(start_at, Timex.Duration.from_minutes(event_type.duration))
      changeset = Event.changeset(%Event{}, %{})

      socket =
        socket
        |> assign(changeset: changeset)
        |> assign(end_at: end_at)
        |> assign(event_type: event_type)
        |> assign(start_at: start_at)

      {:ok, socket}
    else
      _ ->
        {:ok, socket, layout: {CalendlexWeb.Layouts, :not_found}}
    end
  end
end
