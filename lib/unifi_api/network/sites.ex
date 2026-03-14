defmodule UnifiApi.Network.Sites do
  @moduledoc """
  UniFi Network API — site management.

  Sites are the top-level organizational unit. Most Network API endpoints
  require a `site_id` obtained from this module.
  """

  alias UnifiApi.Client

  @doc """
  Lists all sites on the controller.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, sites} = UnifiApi.Network.Sites.list(client)
      # => [%{"id" => "abc-123", "name" => "Default", "internalReference" => "default"}]

      # Get the default site ID
      {:ok, [site | _]} = UnifiApi.Network.Sites.list(client)
      site_id = site["id"]
  """
  def list(client, opts \\ []) do
    Client.get(client, "/v1/sites", opts)
  end
end
