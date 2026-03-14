defmodule UnifiApi.Network.Clients do
  @moduledoc """
  UniFi Network API — connected clients.

  Lists currently connected clients with their connection type, IP address,
  and other details.
  """

  alias UnifiApi.Client

  @doc """
  Lists all connected clients on a site.

  Each client includes `type` (WIRED, WIRELESS, VPN, or TELEPORT),
  `id`, `name`, `connectedAt`, `ipAddress`, and `access`.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, clients} = UnifiApi.Network.Clients.list(client, site_id)

      # Filter by connection type
      {:ok, wireless} = UnifiApi.Network.Clients.list(client, site_id,
        filter: "type.eq(WIRELESS)"
      )

      # Paginate through all clients
      {:ok, page} = UnifiApi.Network.Clients.list(client, site_id, limit: 50, offset: 0)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/clients", opts)
  end
end
