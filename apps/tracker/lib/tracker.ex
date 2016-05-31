defmodule Tracker do
  @moduledoc """
  Naive tracker to track changes on
  on a specific web page
  """
  # use HTTPoison.Base
  use Hound.Helpers
  alias DB.Repo
  alias DB.Status

  @doc """
  Takes a service atom, url string, and CSS
  selector and returns a hash of the HTML string
  and the raw HTML.
  """
  def check({service, url, {type, selector}}, {async_type, async_selector} \\ {nil, nil}) do
    IO.inspect("Checking for #{service}")
    Hound.start_session
    navigate_to(url)

    if async_type, do: find_element(async_type, async_selector)

    element = find_element(type, selector)
    snippet = inner_html(element)
    html = page_source

    Hound.end_session

    hash =
      snippet
      |> :crypto.md5
      |> to_string
    IO.inspect(hash)

    {:ok, {html, snippet, hash}}
  end

  def save({html, hash, service}) do
    %Status{id: id} = Repo.insert!(%Status{hash: hash, service: service})

    Path.expand("html/#{id}.html")
    |> IO.inspect
    |> File.write!(html)
  end
end
