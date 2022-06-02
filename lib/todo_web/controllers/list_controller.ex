defmodule TodoWeb.ListController do
  use TodoWeb, :controller

  alias Todo.Todos
  alias Todo.Todos.List
  alias Todo.Item
  alias Todo.Repo

  def index(conn, _params) do
    lists = Todos.list_lists()
    render(conn, "index.html", lists: lists)
  end

  def new(conn, _params) do
    changeset = Todos.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list" => list_params}) do
    case Todos.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list =
      List
      |> Repo.get(id)
      |> Repo.preload(:items)

    item_changeset = Item.changeset(%Item{}, %{})
    render(conn, "show.html", list: list, item_changeset: item_changeset)
  end

  def edit(conn, %{"id" => id}) do
    list = Todos.get_list!(id)
    changeset = Todos.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Todos.get_list!(id)

    if list.archived && String.to_atom(list_params["archived"]) do
      conn
      |> put_flash(:info, "You cannot update title of Archived list")
      |> redirect(to: Routes.list_path(conn, :show, list))
    else
      case Todos.update_list(list, list_params) do
        {:ok, list} ->
          conn
          |> put_flash(:info, "List updated successfully.")
          |> redirect(to: Routes.list_path(conn, :show, list))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", list: list, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Todos.get_list!(id)
    {:ok, _list} = Todos.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :index))
  end
end
