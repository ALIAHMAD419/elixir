defmodule Todo.Cleanup do
  use GenServer

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Todo.Repo
  alias Todo.Todos.List

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    time = Timex.shift(Timex.now(), hours: -24)

    List
    |> where([l], l.updated_at >= ^time)
    |> where(archived: false)
    |> Repo.update_all(set: [archived: true])

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000)
  end
end
