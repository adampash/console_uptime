defmodule DB.Repo.Migrations.AddStatus do
  use Ecto.Migration

  def change do
    create table(:status) do
      add :hash, :binary
      add :service, :string

      timestamps
    end
  end
end
