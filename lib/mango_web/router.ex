defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :frontend do
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart
  end

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

  # Unauthenticated scope
  scope "/", MangoWeb do
    pipe_through [:browser, :frontend]

    get "/", PageController, :index
    get "/categories/:name", CategoryController, :show

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    post "/cart", CartController, :add
    get "/cart", CartController, :show
    put "/cart", CartController, :update
    patch "/cart", CartController, :update

  end

  # Authenticated scope
  scope "/", MangoWeb do
    pipe_through [:browser, :frontend, MangoWeb.Plugs.AuthenticateCustomer]

    get "/logout", SessionController, :delete
    get "/checkout", CheckoutController, :edit
    put "/checkout/confirm", CheckoutController, :update
  end
end
