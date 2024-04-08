defmodule Calendlex.EventType do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "event_types" do
    field :description, :string
    field :duration, :integer
    field :name, :string
    field :slug, :string
    field :color, :string

    timestamps(type: :utc_datetime)
  end

  @fields ~w(name description slug duration color)a
  @required_fields ~w(name slug duration color)a

  @doc false
  def changeset(event_type \\ %EventType{}, attrs) do
    event_type
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:slug, name: "event_types_slug_index")
  end
end
