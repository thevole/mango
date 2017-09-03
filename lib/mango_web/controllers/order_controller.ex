defmodule MangoWeb.OrderController do
  use MangoWeb, :controller
  alias Mango.CRM

  def index(conn, _) do
    orders = CRM.get_orders_for_customer(conn.assigns.current_customer)
    render(conn, "index.html", orders: orders)
  end
end
