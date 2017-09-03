defmodule MangoWeb.LoginHelpers do
  use Hound.Helpers

  def login(email, password) do
    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field(email)

    find_within_element(form, :name, "session[password]")
    |> fill_field(password)

    find_within_element(form, :tag, "button")
    |> click
  end
end
