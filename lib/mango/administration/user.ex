defmodule Mango.Administration.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.Administration.User


  schema "users" do
    field :email, :string
    field :home, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :home])
    |> validate_required([:name, :email, :home])
    |> unique_constraint(:email)
  end
end
