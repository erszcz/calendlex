defmodule Calendlex do
  @moduledoc """
  Calendlex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate available_event_types, to: Calendlex.EventType.Repo, as: :available

  defdelegate get_event_type_by_slug(slug),
    to: Calendlex.EventType.Repo,
    as: :get_by_slug
end
