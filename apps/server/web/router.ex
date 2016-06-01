defmodule Server.Router do
  use Server.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Server do
    pipe_through :browser # Use the default browser stack

    get "/status/:service", StatusController, :index
    get "/status/:service/:id", StatusController, :show
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Server do
  #   pipe_through :api
  # end
end
