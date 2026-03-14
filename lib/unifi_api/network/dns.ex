defmodule UnifiApi.Network.DNS do
  @moduledoc """
  UniFi Network API — DNS policy management.

  Create and manage DNS records and forwarding rules.

  ## Supported record types

    * `A_RECORD` — IPv4 address mapping
    * `AAAA_RECORD` — IPv6 address mapping
    * `CNAME_RECORD` — canonical name alias
    * `MX_RECORD` — mail exchange
    * `TXT_RECORD` — text record
    * `SRV_RECORD` — service locator
    * `FORWARD_DOMAIN` — domain forwarding
  """

  alias UnifiApi.Client

  @doc """
  Lists all DNS policies on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, policies} = UnifiApi.Network.DNS.list(client, site_id)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/dns/policies", opts)
  end

  @doc """
  Gets a specific DNS policy.

  ## Examples

      {:ok, policy} = UnifiApi.Network.DNS.get(client, site_id, policy_id)
  """
  def get(client, site_id, policy_id) do
    Client.get(client, "/v1/sites/#{site_id}/dns/policies/#{policy_id}")
  end

  @doc """
  Creates a new DNS policy.

  ## Examples

      # A record
      {:ok, _} = UnifiApi.Network.DNS.create(client, site_id, %{
        type: "A_RECORD",
        name: "app.local",
        value: "192.168.1.50"
      })

      # CNAME record
      {:ok, _} = UnifiApi.Network.DNS.create(client, site_id, %{
        type: "CNAME_RECORD",
        name: "www.local",
        value: "app.local"
      })
  """
  def create(client, site_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/dns/policies", body)
  end

  @doc """
  Updates an existing DNS policy.

  ## Examples

      {:ok, _} = UnifiApi.Network.DNS.update(client, site_id, policy_id, %{
        value: "192.168.1.51"
      })
  """
  def update(client, site_id, policy_id, body) do
    Client.put(client, "/v1/sites/#{site_id}/dns/policies/#{policy_id}", body)
  end

  @doc """
  Deletes a DNS policy.

  ## Examples

      {:ok, _} = UnifiApi.Network.DNS.delete(client, site_id, policy_id)
  """
  def delete(client, site_id, policy_id) do
    Client.delete(client, "/v1/sites/#{site_id}/dns/policies/#{policy_id}")
  end
end
