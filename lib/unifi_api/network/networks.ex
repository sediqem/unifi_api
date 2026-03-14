defmodule UnifiApi.Network.Networks do
  @moduledoc """
  UniFi Network API — network configuration.

  Create, read, update, and delete network configurations (VLANs, subnets, etc.)
  on a site.
  """

  alias UnifiApi.Client

  @doc """
  Lists all networks on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, networks} = UnifiApi.Network.Networks.list(client, site_id)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/networks", opts)
  end

  @doc """
  Gets a specific network by ID.

  ## Examples

      {:ok, network} = UnifiApi.Network.Networks.get(client, site_id, network_id)
      network["name"]   # => "LAN"
      network["vlanId"] # => 1
  """
  def get(client, site_id, network_id) do
    Client.get(client, "/v1/sites/#{site_id}/networks/#{network_id}")
  end

  @doc """
  Creates a new network on a site.

  ## Examples

      {:ok, network} = UnifiApi.Network.Networks.create(client, site_id, %{
        name: "Guest VLAN",
        vlanId: 100
      })
  """
  def create(client, site_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/networks", body)
  end

  @doc """
  Updates an existing network.

  ## Examples

      {:ok, _} = UnifiApi.Network.Networks.update(client, site_id, network_id, %{
        name: "Updated Network Name"
      })
  """
  def update(client, site_id, network_id, body) do
    Client.put(client, "/v1/sites/#{site_id}/networks/#{network_id}", body)
  end

  @doc """
  Deletes a network.

  ## Examples

      {:ok, _} = UnifiApi.Network.Networks.delete(client, site_id, network_id)
  """
  def delete(client, site_id, network_id, opts \\ []) do
    Client.delete(client, "/v1/sites/#{site_id}/networks/#{network_id}", opts)
  end
end
