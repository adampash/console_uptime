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
  def check({service, url, selector}, {async_type, async_selector} \\ {nil, nil}) do
    IO.inspect("Checking for #{service}")
    {html, snippet, hash} =
      get_page(url, async_type, async_selector)
      |> get_snippet(selector)
      |> get_hash

    {:ok, {html, snippet, hash}}
  end

  def get_page(url, async_type, async_selector) do
    Hound.start_session

    navigate_to(url)
    :timer.sleep 1000
    if async_type, do: find_element(async_type, async_selector)
    html = page_source

    Hound.end_session
    html
    |> String.replace(~r{<!--.*-->}, "")
    |> String.replace(~r{<input type="button" id="notifyMe".*>}, "")
  end

  def get_snippet(html, selector) do
    snippet =
      html
      |> Floki.find(selector)
      |> Floki.raw_html
    {html, snippet}
  end

  def get_hash({html, snippet}) do
    hash =
      snippet
      |> :crypto.md5
      |> to_string
    IO.inspect(hash)

    {html, snippet, hash}
  end

  def save({html, hash, service}) do
    %Status{id: id} = Repo.insert!(%Status{hash: hash, service: service})

    Path.expand("html/#{id}.html")
    |> IO.inspect
    |> File.write!(html)
  end
end
