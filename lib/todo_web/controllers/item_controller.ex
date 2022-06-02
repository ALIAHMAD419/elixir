defmodule TodoWeb.ItemController do
  use TodoWeb, :controller

  alias Todo.Todos
  alias Todo.Todos.List
  alias Todo.Item
  alias Todo.Repo

  def create(conn, %{"item" => item_params, "list_id" => list_id}) do
    IO.inspect(item_params, label: "item_params")
    list = Repo.get(List, list_id)

    if list.archived do
      conn
      |> put_flash(:info, "You cannot creat item in archived list.")
      |> redirect(to: Routes.list_path(conn, :show, list))
    else
      item_changeset =
        Ecto.build_assoc(list, :items,
          content: item_params["content"],
          completed: String.to_atom(item_params["completed"])
        )

      Repo.insert(item_changeset)

      conn
      |> put_flash(:info, "item created successfully.")
      |> redirect(to: Routes.list_path(conn, :show, list))
    end
  end

  def edit(conn, %{"id" => id, "list_id" => list_id}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, %{})
    render(conn, "edit.html", item: item, list_id: list_id, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params, "list_id" => list_id}) do
    list = Todos.get_list!(list_id)

    if list.archived do
      conn
      |> put_flash(:info, "You cannot update Items of Archived list")
      |> redirect(to: Routes.list_path(conn, :show, list_id))
    else
      item = Repo.get!(Item, id)

      case item |> Item.changeset(item_params) |> Repo.update() do
        {:ok, item} ->
          conn
          |> put_flash(:info, "item updated successfully.")
          |> redirect(to: Routes.list_path(conn, :show, list_id))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", item: item, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id, "list_id" => list_id}) do
    item = Repo.get!(Item, id)
    {:ok, _item} = Repo.delete(item)

    conn
    |> put_flash(:info, "item deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :show, list_id))
  end
end
