defmodule DB.Status do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]

  schema "status" do
    field(:hash, :binary)
    field(:service, :string)

    timestamps
  end

  def latest(service) do
    query = from s in Status,
            where: s.service == ^service,
            order_by: [desc: s.updated_at],
            limit: 1

    Repo.all(query)
  end
end
