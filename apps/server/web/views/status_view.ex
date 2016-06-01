defmodule Server.StatusView do
  use Server.Web, :view
  alias DB.Status

  def format_date(date) do
    Status.format_date(date)
  end
end
