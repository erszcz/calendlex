defmodule CalendlexWeb.ScheduleEventLive.Show do
  use CalendlexWeb, :live_view

  alias Calendlex.MyContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:schedule_event, MyContext.get_schedule_event!(id))}
  end

  defp page_title(:show), do: "Show Schedule event"
  defp page_title(:edit), do: "Edit Schedule event"
end
