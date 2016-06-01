# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "tracker_db",
  username: "aop",
  password: "",
  hostname: "localhost"
