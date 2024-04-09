defmodule CalendlexWeb.Components.EventType do
  use Phoenix.Component

  import CalendlexWeb.LiveViewHelpers, only: [class_list: 1]

  alias __MODULE__

  def selector(assigns) do
    ~H"""
    <.link href={@path} method="get">
      <div class="flex items-center p-6 pb-20 text-gray-400 bg-white border-t border-gray-300 cursor-pointer hover:bg-gray-200 gap-x-4">
        <div {[class: "inline-block w-8 h-8 #{@event_type.color}-bg rounded-full border-2 border-white"]}></div>
        <h3 class="font-bold text-gray-900"><%= @event_type.name %></h3>
        <div class="ml-auto text-xl"><i class="fas fa-caret-right"></i></div>
      </div>
    </.link>
    """
  end

  def calendar(assigns) do
    %{
      current_path: current_path,
      previous_month: previous_month,
      next_month: next_month
    } = assigns

    previous_month_path = build_path(current_path, %{month: previous_month})
    next_month_path = build_path(current_path, %{month: next_month})

    assigns =
      assigns
      |> assign(previous_month_path: previous_month_path)
      |> assign(next_month_path: next_month_path)

    ~H"""
    <div>
      <div class="flex items-center mb-8">
        <div class="flex-1">
          <%= Timex.format!(@current, "{Mshort} {YYYY}") %>
        </div>
        <div class="flex justify-end flex-1 text-right">
          <%= live_patch to: @previous_month_path do %>
            <button class="flex items-center justify-center w-10 h-10 text-blue-700 align-middle rounded-full hover:bg-blue-200">
              <i class="fas fa-chevron-left"></i>
            </button>
          <% end %>
          <%= live_patch to: @next_month_path do %>
            <button class="flex items-center justify-center w-10 h-10 text-blue-700 align-middle rounded-full hover:bg-blue-200">
              <i class="fas fa-chevron-right"></i>
            </button>
          <% end %>
        </div>
      </div>
      <div class="mb-6 text-center uppercase calendar grid grid-cols-7 gap-y-2 gap-x-2">
        <div class="text-xs">Mon</div>
        <div class="text-xs">Tue</div>
        <div class="text-xs">Wed</div>
        <div class="text-xs">Thu</div>
        <div class="text-xs">Fri</div>
        <div class="text-xs">Sat</div>
        <div class="text-xs">Sun</div>
        <%= for i <- 0..@end_of_month.day - 1 do %>
          <EventType.day
            index={i}
            current_path={@current_path}
            date={Timex.shift(@beginning_of_month, days: i)}
            time_zone={@time_zone} />
        <% end %>
      </div>
      <div class="flex items-center gap-x-1">
        <i class="fas fa-globe-americas"></i>
        <%= @time_zone %>
      </div>
    </div>
    """
  end

  defp build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def day(assigns) do
    %{index: index, current_path: current_path, date: date, time_zone: time_zone} = assigns
    date_path = build_path(current_path, %{date: date})
    disabled = Timex.compare(date, Timex.today(time_zone)) == -1
    weekday = Timex.weekday(date, :monday)

    class =
      class_list([
        {"grid-column-#{weekday}", index == 0},
        {"content-center w-10 h-10 rounded-full justify-center items-center flex", true},
        {"bg-blue text-blue-600 font-bold hover:bg-blue-200", not disabled},
        {"text-gray-200 cursor-default pointer-events-none", disabled}
      ])

    assigns =
      assigns
      |> assign(disabled: disabled)
      |> assign(:text, Timex.format!(date, "{D}"))
      |> assign(:date_path, date_path)
      |> assign(:class, class)

    ~H"""
    <%= live_patch to: @date_path, class: @class, disabled: @disabled do %>
      <%= @text %>
    <% end %>
    """
  end
end
