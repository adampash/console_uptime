defmodule PsnTracker.Track do
  use GenServer

  @check_interval 1000

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    Process.send_after(__MODULE__, :check, @check_interval)
    IO.inspect "STARTED TRACK"
    {:ok, nil}
  end

  def handle_info(:check, prev_hash) do
    IO.inspect "GOT INFO"
    {:ok, {page, snippet, hash}} = Tracker.check(
      {:psn, "https://status.playstation.com/en-US/", {:id, "statusArea"}},
      {:class, "globalMessage"}
    )

    IO.inspect hash
    save_page(prev_hash == hash, page)

    Process.send_after(__MODULE__, :check, @check_interval)
    {:noreply, hash}
  end

  def save_page(true, page), do: :ok
  def save_page(false, page) do
    IO.inspect "SAVE THIS PAGE!!!"
  end

end
