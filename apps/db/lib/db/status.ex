defmodule DB.Status do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias DB.Repo

  schema "status" do
    field(:hash, :binary)
    field(:service, :string)

    timestamps
  end

  def all_updates(service) do
    query = from s in DB.Status,
            where: s.service == ^service,
            order_by: [desc: s.updated_at]
    Repo.all(query)
  end

  def latest(service) do
    query = from s in DB.Status,
            where: s.service == ^service,
            order_by: [desc: s.updated_at],
            limit: 1

    Repo.all(query)
  end

  def format_date(date) do
    {:ok, date} = Ecto.DateTime.dump(date)
    
    Timex.DateTime.from(date)
    |> Timex.format!("%B %e, %Y %I:%M%P", :strftime)
  end

end
