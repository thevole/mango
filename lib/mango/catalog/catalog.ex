defmodule Mango.Catalog do
  alias Mango.Catalog.Product
  alias Mango.Repo

  def list_products do
    Product
    |> Repo.all
  end

  def list_seasonal_products do
    list_products()
    |> Enum.filter(&(&1.is_seasonal == true))
  end

  def get_category_products(name) do
    list_products()
    |> Enum.filter(&(&1.category == name))
  end

  def get_product!(id), do: Product |> Repo.get!(id)

end
