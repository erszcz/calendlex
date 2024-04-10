defmodule CalendlexWeb.ScheduleEventLive.Index do
  use CalendlexWeb, :live_view

  alias Calendlex.MyContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :scheduled_events, MyContext.list_scheduled_events())}
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
    |> assign(:page_title, "New Schedule event")
    |> assign(:schedule_event, %{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scheduled events")
    |> assign(:schedule_event, nil)
  end

  @impl true
  def handle_info({CalendlexWeb.ScheduleEventLive.FormComponent, {:saved, schedule_event}}, socket) do
    {:noreply, stream_insert(socket, :scheduled_events, schedule_event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schedule_event = MyContext.get_schedule_event!(id)
    {:ok, _} = MyContext.delete_schedule_event(schedule_event)

    {:noreply, stream_delete(socket, :scheduled_events, schedule_event)}
  end
end
