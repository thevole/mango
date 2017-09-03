defmodule MangoWeb.Acceptance.OrdersTest do
  use Mango.DataCase
  use Hound.Helpers

  import MangoWeb.LoginHelpers, only: [login: 2]

  hound_session()

  setup do
    ## GIVEN ##
    # There is a valid registered user
    alias Mango.CRM
    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    {:ok, customer} = CRM.create_customer(valid_attrs)

    customer
    |> Ecto.build_assoc(:orders, %{
      status: "sold",
      total: Decimal.new(123.00),
      customer_name: customer.name,
      email: customer.email,
      residence_area: customer.residence_area
    })
    |> Repo.insert


    :ok
  end

  test "there should be a my orders link when user logged in" do
    navigate_to "/"
    refute page_source() =~ "My Orders"

    login("john@example.com", "secret")
    navigate_to "/"
    assert page_source() =~ "My Orders"
  end

  test "view a list of orders" do
    login("john@example.com", "secret")
    navigate_to "/orders"

    page_title = find_element(:css, ".page-title") |> visible_text()
    assert page_title == "My Orders"

    order_rows = find_all_elements(:css, ".order-row")
    assert Enum.count(order_rows) == 1
  end
end
