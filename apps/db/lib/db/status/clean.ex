defmodule DB.Status.Clean do
  def clean_all do
    # Clean every five minutes
    # Process.sleep(1_000 * 60 * 5)
    # Using :timer for older Elixir
    :timer.sleep(1_000 * 60 * 5)

    ["psn", "xbl"]
    |> Enum.map(&clean/1)

    clean_all
  end

  def clean(service) do
    DB.Status.all_updates(service)
    |> Enum.map(fn %{id: id} -> id end)
    |> Enum.map(&delete_if_missing_file/1)
  end

  def delete_if_missing_file(id) do
    unless File.exists?(Path.expand("html/#{id}.html")) do
      DB.Status.ignore(id)
    end
  end
end
