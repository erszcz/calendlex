defmodule Calendlex.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Calendlex.EventType

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "events" do
    field :comments, :string
    field :email, :string
    field :end_at, :utc_datetime
    field :name, :string
    field :start_at, :utc_datetime
    field :time_zone, :string

    belongs_to(:event_type, EventType)

    timestamps(type: :utc_datetime)
  end

  @fields ~w(event_type_id start_at end_at name email comments time_zone)a
  @required_fields ~w(start_at end_at name email time_zone)a

  @doc false
  def changeset(event \\ %Event{}, attrs) do
    event
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
