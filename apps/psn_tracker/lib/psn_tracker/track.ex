defmodule PsnTracker.Track do
  use GenServer
  alias DB.Status

  @check_interval 60 * 1_000

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    Process.send_after(__MODULE__, :check, 5000)
    IO.inspect "STARTED TRACKING PSN"
    hash = case Status.latest("psn") do
      [%{hash: hash}] -> hash
      _ -> nil
    end
    {:ok, hash}
  end

  def handle_info(:check, prev_hash) do
    {:ok, {page, _snippet, hash}} = Tracker.check(
      {:psn, "https://status.playstation.com/en-US/", {:id, "statusArea"}},
      {:class, "globalMessage"}
    )

    save_page(prev_hash == hash, {page, hash, "psn"})

    Process.send_after(__MODULE__, :check, @check_interval)
    {:noreply, hash}
  end

  def save_page(true, _), do: IO.inspect "No changes"
  def save_page(false, params) do
    IO.inspect "SAVE THIS PAGE!!!"
    Tracker.save(params)
  end

end
