defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def up do
    create table(:items) do
      add :content, :string
      add :completed, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:items, [:list_id])
  end

  def down do
    drop table(:items)
  end
end
