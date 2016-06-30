defmodule DB.Status do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias DB.Repo

  schema "status" do
    field(:hash, :binary)
    field(:service, :string)
    # field(:ignore, :boolean)

    timestamps
  end

  def all_updates(service) do
    query = from s in DB.Status,
            where: s.service == ^service,
            where: s.ignore == false,
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

    Timex.DateTime.from(date, :local)
    |> Timex.format!("%B %e, %Y %I:%M%P", :strftime)
  end

  def ignore(id) do
    status =
      Repo.get!(DB.Status, id)
      |> Ecto.Changeset.change(ignore: true)

    Repo.update!(status)
  end

  def delete(id) do
    status = Repo.get!(DB.Status, id)
    Repo.delete(status)
  end

end
