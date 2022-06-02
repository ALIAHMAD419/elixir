defmodule Todo.Todos.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string

    has_many :items, Todo.Item
    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title, :archived])
  end
end
