defmodule Calendlex do
  @moduledoc """
  Calendlex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate available_event_types, to: Calendlex.EventType.Repo, as: :available

  defdelegate get_event_type_by_slug(slug), to: Calendlex.EventType.Repo, as: :get_by_slug

  defdelegate build_time_slots(date, time_zone, duration), to: Calendlex.TimeSlots, as: :build

  defdelegate insert_event(params), to: Calendlex.Event.Repo, as: :insert

  defdelegate get_event_by_id(id), to: Calendlex.Event.Repo, as: :get
end
