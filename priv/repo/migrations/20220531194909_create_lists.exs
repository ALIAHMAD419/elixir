defmodule Todo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def up do
    create table(:lists) do
      add :title, :string
      add :archived, :boolean, default: false, null: false

      timestamps()
    end
  end

  def down do
    drop table(:lists)
  end
end
