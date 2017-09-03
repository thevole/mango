defmodule Mango.CRM do
  alias Mango.CRM.Customer
  alias Mango.Repo

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer()
    |> Repo.insert
  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: email)
  end

  def get_customer_by_credentials(%{"email" => email, "password" => pass}) do
    customer = get_customer_by_email(email)
    cond do
      customer && Comeonin.Bcrypt.checkpw(pass, customer.password_hash) ->
        customer
      true ->
        :error
    end
  end

  def get_customer(id), do: Repo.get(Customer, id)

  def get_orders_for_customer(customer = %Customer{}) do
    customer
    |> Ecto.assoc(:orders)
    |> Repo.all
  end

  alias Mango.CRM.Ticket

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_customer_tickets(customer)
      [%Ticket{}, ...]

  """
  def list_customer_tickets(customer = %Customer{}) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.all()
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_customer_ticket!(customer, 123)
      %Ticket{}

      iex> get_customer_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_ticket!(customer = %Customer{}, id) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.get!(id)
  end

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_customer_ticket(customer, %{field: value})
      {:ok, %Ticket{}}

      iex> create_customer_ticket(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_ticket(customer = %Customer{}, attrs \\ %{}) do
    build_customer_ticket(customer, attrs)
    |> Repo.insert()
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> build_customer_ticket(customer, %{})
      %Ecto.Changeset{source: %Ticket{}}

  """
  def build_customer_ticket(customer = %Customer{}, attrs \\ %{}) do
    Ecto.build_assoc(customer, :tickets, %{status: "New"})
    |> Ticket.changeset(attrs)
  end
end
