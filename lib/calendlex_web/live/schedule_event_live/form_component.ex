defmodule CalendlexWeb.ScheduleEventLive.FormComponent do
  use CalendlexWeb, :live_component

  alias Calendlex.MyContext

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage schedule_event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="schedule_event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:start_at]} type="datetime-local" label="Start at" />
        <.input field={@form[:end_at]} type="datetime-local" label="End at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Schedule event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{schedule_event: schedule_event} = assigns, socket) do
    changeset = MyContext.change_schedule_event(schedule_event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"schedule_event" => schedule_event_params}, socket) do
    changeset =
      socket.assigns.schedule_event
      |> MyContext.change_schedule_event(schedule_event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"schedule_event" => schedule_event_params}, socket) do
    save_schedule_event(socket, socket.assigns.action, schedule_event_params)
  end

  defp save_schedule_event(socket, :edit, schedule_event_params) do
    case MyContext.update_schedule_event(socket.assigns.schedule_event, schedule_event_params) do
      {:ok, schedule_event} ->
        notify_parent({:saved, schedule_event})

        {:noreply,
         socket
         |> put_flash(:info, "Schedule event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_schedule_event(socket, :new, schedule_event_params) do
    case MyContext.create_schedule_event(schedule_event_params) do
      {:ok, schedule_event} ->
        notify_parent({:saved, schedule_event})

        {:noreply,
         socket
         |> put_flash(:info, "Schedule event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
