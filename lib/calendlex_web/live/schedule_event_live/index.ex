defmodule CalendlexWeb.ScheduleEventLive.Index do
  use CalendlexWeb, :live_view

  alias Calendlex.Event

  @impl true
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
        |> assign(event_type_slug: slug)
        |> assign(time_slot: time_slot)

      {:ok, socket}
    else
      _ ->
        {:ok, socket, layout: {CalendlexWeb.Layouts, :not_found}}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Schedule event")
    |> assign(:schedule_event, MyContext.get_schedule_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scheduled events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({CalendlexWeb.ScheduleEventLive.FormComponent, {:saved, schedule_event}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schedule_event = MyContext.get_schedule_event!(id)
    {:ok, _} = MyContext.delete_schedule_event(schedule_event)

    {:noreply, socket}
  end
end
