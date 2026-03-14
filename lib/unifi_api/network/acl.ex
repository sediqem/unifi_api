defmodule UnifiApi.Network.ACL do
  @moduledoc """
  UniFi Network API — ACL rule management.

  Create, read, update, delete, and reorder access control list rules.

  ## ACL rule fields

    * `type` — `"IPV4"` or `"MAC"`
    * `id`, `name`, `description`, `enabled`, `index`
    * `action` — `"ALLOW"` or `"BLOCK"`
    * `enforcingDeviceFilter`, `sourceFilter`, `destinationFilter`
    * `protocolFilter`, `networkId`, `metadata`
  """

  alias UnifiApi.Client

  @doc """
  Lists all ACL rules on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, rules} = UnifiApi.Network.ACL.list(client, site_id)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules", opts)
  end

  @doc """
  Gets a specific ACL rule.

  ## Examples

      {:ok, rule} = UnifiApi.Network.ACL.get(client, site_id, rule_id)
      rule["action"] # => "BLOCK"
      rule["type"]   # => "IPV4"
  """
  def get(client, site_id, rule_id) do
    Client.get(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules/#{rule_id}")
  end

  @doc """
  Creates a new ACL rule.

  ## Examples

      {:ok, rule} = UnifiApi.Network.ACL.create(client, site_id, %{
        type: "IPV4",
        name: "Block SSH",
        enabled: true,
        action: "BLOCK",
        protocolFilter: %{protocol: "TCP", dstPort: 22}
      })
  """
  def create(client, site_id, body) do
    Client.post(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules", body)
  end

  @doc """
  Updates an existing ACL rule.

  ## Examples

      {:ok, _} = UnifiApi.Network.ACL.update(client, site_id, rule_id, %{enabled: false})
  """
  def update(client, site_id, rule_id, body) do
    Client.put(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules/#{rule_id}", body)
  end

  @doc """
  Deletes an ACL rule.

  ## Examples

      {:ok, _} = UnifiApi.Network.ACL.delete(client, site_id, rule_id)
  """
  def delete(client, site_id, rule_id) do
    Client.delete(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules/#{rule_id}")
  end

  @doc """
  Gets the current ACL rule ordering.

  ## Examples

      {:ok, ordering} = UnifiApi.Network.ACL.get_ordering(client, site_id)
      # => %{"ids" => ["rule-1", "rule-2", "rule-3"]}
  """
  def get_ordering(client, site_id) do
    Client.get(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules/ordering")
  end

  @doc """
  Updates the ACL rule ordering.

  ## Examples

      {:ok, _} = UnifiApi.Network.ACL.update_ordering(client, site_id, %{
        ids: ["rule-3", "rule-1", "rule-2"]
      })
  """
  def update_ordering(client, site_id, body) do
    Client.put(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules/ordering", body)
  end

  @doc """
  Returns a lazy stream that auto-paginates through all ACL rules.

  ## Examples

      UnifiApi.Network.ACL.stream(client, site_id)
      |> Stream.filter(& &1["enabled"])
      |> Enum.to_list()
  """
  def stream(client, site_id, opts \\ []) do
    Client.stream(client, "#{prefix()}/v1/sites/#{site_id}/acl-rules", opts)
  end

  defp prefix, do: Client.network_prefix()
end
