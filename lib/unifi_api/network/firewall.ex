defmodule UnifiApi.Network.Firewall do
  @moduledoc """
  UniFi Network API — firewall zones and policies.

  Manage firewall zones (groups of networks) and traffic policies
  (allow/block/reject rules between zones).

  ## Zone fields

    * `id` — zone identifier
    * `name` — display name
    * `networkIds` — list of network IDs in this zone
    * `metadata` — additional metadata

  ## Policy fields

    * `id`, `name`, `description`, `enabled`, `index`
    * `action` — `"ALLOW"`, `"BLOCK"`, or `"REJECT"`
    * `source` — `%{zoneId, trafficFilter}`
    * `destination` — `%{zoneId, trafficFilter}`
    * `ipProtocolScope`, `connectionStateFilter`, `ipsecFilter`
    * `loggingEnabled`, `schedule`, `metadata`
  """

  alias UnifiApi.Client

  # --- Zones ---

  @doc """
  Lists all firewall zones on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, zones} = UnifiApi.Network.Firewall.list_zones(client, site_id)
  """
  def list_zones(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/firewall/zones", opts)
  end

  @doc """
  Gets a specific firewall zone.

  ## Examples

      {:ok, zone} = UnifiApi.Network.Firewall.get_zone(client, site_id, zone_id)
      zone["name"]       # => "Internal"
      zone["networkIds"] # => ["net-1", "net-2"]
  """
  def get_zone(client, site_id, zone_id) do
    Client.get(client, "/v1/sites/#{site_id}/firewall/zones/#{zone_id}")
  end

  @doc """
  Creates a new firewall zone.

  ## Examples

      {:ok, zone} = UnifiApi.Network.Firewall.create_zone(client, site_id, %{
        name: "DMZ",
        networkIds: [network_id]
      })
  """
  def create_zone(client, site_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/firewall/zones", body)
  end

  @doc """
  Updates an existing firewall zone.

  ## Examples

      {:ok, _} = UnifiApi.Network.Firewall.update_zone(client, site_id, zone_id, %{
        name: "DMZ-Updated"
      })
  """
  def update_zone(client, site_id, zone_id, body) do
    Client.put(client, "/v1/sites/#{site_id}/firewall/zones/#{zone_id}", body)
  end

  @doc """
  Deletes a firewall zone.

  ## Examples

      {:ok, _} = UnifiApi.Network.Firewall.delete_zone(client, site_id, zone_id)
  """
  def delete_zone(client, site_id, zone_id) do
    Client.delete(client, "/v1/sites/#{site_id}/firewall/zones/#{zone_id}")
  end

  # --- Policies ---

  @doc """
  Lists all firewall policies on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, policies} = UnifiApi.Network.Firewall.list_policies(client, site_id)
  """
  def list_policies(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/firewall/policies", opts)
  end

  @doc """
  Gets a specific firewall policy.

  ## Examples

      {:ok, policy} = UnifiApi.Network.Firewall.get_policy(client, site_id, policy_id)
      policy["action"]  # => "BLOCK"
      policy["enabled"] # => true
  """
  def get_policy(client, site_id, policy_id) do
    Client.get(client, "/v1/sites/#{site_id}/firewall/policies/#{policy_id}")
  end

  @doc """
  Creates a new firewall policy.

  ## Examples

      {:ok, policy} = UnifiApi.Network.Firewall.create_policy(client, site_id, %{
        name: "Block IoT to LAN",
        enabled: true,
        action: "BLOCK",
        source: %{zoneId: iot_zone_id},
        destination: %{zoneId: lan_zone_id}
      })
  """
  def create_policy(client, site_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/firewall/policies", body)
  end

  @doc """
  Updates an existing firewall policy.

  ## Examples

      {:ok, _} = UnifiApi.Network.Firewall.update_policy(client, site_id, policy_id, %{
        enabled: false
      })
  """
  def update_policy(client, site_id, policy_id, body) do
    Client.put(client, "/v1/sites/#{site_id}/firewall/policies/#{policy_id}", body)
  end

  @doc """
  Deletes a firewall policy.

  ## Examples

      {:ok, _} = UnifiApi.Network.Firewall.delete_policy(client, site_id, policy_id)
  """
  def delete_policy(client, site_id, policy_id) do
    Client.delete(client, "/v1/sites/#{site_id}/firewall/policies/#{policy_id}")
  end
end
