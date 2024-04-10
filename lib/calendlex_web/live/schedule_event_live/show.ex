defmodule CalendlexWeb.ScheduleEventLive.Show do
  use CalendlexWeb, :live_view

  alias Calendlex.MyContext

  @impl true
  def mount(params, _session, socket) do
    %{"event_type_slug" => slug, "event_id" => id} = params

    with {:ok, event_type} <- Calendlex.get_event_type_by_slug(slug),
         {:ok, event} <- Calendlex.get_event_by_id(id) do
      socket =
        socket
        |> assign(event_type: event_type)
        |> assign(event: event)

      {:ok, socket}
    else
      {:error, :not_found} ->
        {:ok, socket, layout: {CalendlexWeb.Layouts, :not_found}}
    end
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Schedule event"
  defp page_title(:edit), do: "Edit Schedule event"
end
