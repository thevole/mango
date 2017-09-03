defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :frontend do
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart
    plug MangoWeb.Plugs.Locale
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

  pipeline :admin do
    plug MangoWeb.Plugs.AdminLayout
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

    get "/orders", OrderController, :index

    get "/logout", SessionController, :delete
    get "/checkout", CheckoutController, :edit
    put "/checkout/confirm", CheckoutController, :update

    resources "/tickets", TicketController, except: [:edit, :update, :delete]
  end

  scope "/admin", MangoWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]
    
    resources "/users", UserController
    get "/login", SessionController, :new
    post "/sendlink", SessionController, :send_link
    get "/magiclink", SessionController, :create
  end
end
