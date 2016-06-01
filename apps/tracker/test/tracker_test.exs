defmodule TrackerTest do
  use ExUnit.Case
  # doctest Tracker

  test "Tracker.check grabs a URL, hashes it, and returns the raw HTML string" do
    {:ok, {html, snippet, _hash}} = Tracker.check(
      {:xbl, "http://support.xbox.com/en-US/xbox-live-status", ".core"}
    )

    IO.inspect String.match?(html, ~r{<!--.*-->})

    assert is_binary(html)
    assert is_binary(snippet)
  end

  test "Tracker.check works with an async selector" do
    {:ok, {html, snippet, _hash}} =   Tracker.check(
      {:psn, "https://status.playstation.com/en-US/", "#statusArea"}, {:class, "globalMessage"}
    )

    assert is_binary(html)
    assert is_binary(snippet)
  end

  # @tag :focus
  # test "Tracker returns the same hash for these two pages" do
  #   page1 = File.read!(Path.expand("../../html/133.html"))
  #   page2 = File.read!(Path.expand("../../html/136.html"))
  #
  #   {_, snippet1, hash1} =
  #     Tracker.get_snippet(page1, ".core")
  #     |> Tracker.get_hash
  #   {_, snippet2, hash2} =
  #     Tracker.get_snippet(page2, ".core")
  #     |> Tracker.get_hash
  #
  #   assert snippet1 == snippet2
  #   assert hash1 == hash2
  # end
end
