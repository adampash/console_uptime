defmodule TrackerTest do
  use ExUnit.Case
  # doctest Tracker

  test "Tracker.check grabs a URL, hashes it, and returns the raw HTML string" do
    {:ok, {html, snippet, _hash}} = Tracker.check(
      {:xbl, "http://support.xbox.com/en-US/xbox-live-status", {:class, "core"}}
    )

    assert is_binary(html)
    assert is_binary(snippet)
  end

  test "Tracker.check works with an async selector" do
    {:ok, {html, snippet, _hash}} =   Tracker.check(
      {:psn, "https://status.playstation.com/en-US/", {:id, "statusArea"}}, {:class, "globalMessage"}
    )

    assert is_binary(html)
    assert is_binary(snippet)
  end
end
