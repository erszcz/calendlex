defmodule CalendlexWeb.ScheduleEventLive.FormComponent do
  use CalendlexWeb, :live_component

  alias Calendlex.MyContext
  alias Calendlex.Event

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Enter details
      </.header>

      <.simple_form
        for={@form}
        id="schedule_event-form"
        phx-target={@myself}
        #phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:email]} type="email" label="Email" />
        <.input field={@form[:comments]} type="textarea" label="Comments" />
        <:actions>
          <.button phx-disable-with="Scheduling event...">Schedule event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event = %Event{}} = assigns, socket) do
    changeset = Event.changeset(event, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  ## TODO: leave validation for later, currently this crashes
  #@impl true
  #def handle_event("validate", %{"schedule_event" => schedule_event_params}, socket) do
  #  changeset =
  #    socket.assigns.schedule_event
  #    |> MyContext.change_schedule_event(schedule_event_params)
  #    |> Map.put(:action, :validate)

  #  {:noreply, assign_form(socket, changeset)}
  #end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  #defp save_schedule_event(socket, :edit, schedule_event_params) do
  #  case MyContext.update_schedule_event(socket.assigns.schedule_event, schedule_event_params) do
  #    {:ok, schedule_event} ->
  #      notify_parent({:saved, schedule_event})

  #      {:noreply,
  #       socket
  #       |> put_flash(:info, "Schedule event updated successfully")
  #       |> push_patch(to: socket.assigns.patch)}

  #    {:error, %Ecto.Changeset{} = changeset} ->
  #      {:noreply, assign_form(socket, changeset)}
  #  end
  #end

  defp save_event(socket, :new, event_params) do
    %{
      end_at: end_at,
      event_type: event_type,
      start_at: start_at,
      time_zone: time_zone
    } = socket.assigns

    event_params =
      event_params
      |> Map.put("end_at", end_at)
      |> Map.put("event_type_id", event_type.id)
      |> Map.put("start_at", start_at)
      |> Map.put("time_zone", time_zone)

    case Calendlex.insert_event(event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
          socket
          |> put_flash(:info, "New event created successfully")
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
