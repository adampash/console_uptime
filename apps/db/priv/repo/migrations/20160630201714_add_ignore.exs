defmodule DB.Repo.Migrations.AddIgnore do
  use Ecto.Migration

  def change do
    alter table(:status) do
      add :ignore, :boolean, default: false
    end
  end
end
