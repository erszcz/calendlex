defmodule CalendlexWeb.EventTypeLive do
  use CalendlexWeb, :live_view

  def mount(%{"event_type_slug" => slug} = params, _session, socket) do
    case Calendlex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)

        {:ok, socket}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendlexWeb.Layouts, :not_found}}
    end
  end
end
