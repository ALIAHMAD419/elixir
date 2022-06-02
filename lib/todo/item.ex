defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    belongs_to :list, Todo.Todos.List

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed, :list_id])
    |> validate_required([:content, :completed, :list_id])
  end
end
