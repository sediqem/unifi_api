defmodule UnifiApi.Network.Wifi do
  @moduledoc """
  UniFi Network API — WiFi broadcasts.

  Lists WiFi SSID configurations on a site.
  """

  alias UnifiApi.Client

  @doc """
  Lists all WiFi broadcasts (SSIDs) on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, ssids} = UnifiApi.Network.Wifi.list(client, site_id)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/wifi/broadcasts", opts)
  end

  @doc """
  Returns a lazy stream that auto-paginates through all WiFi broadcasts.

  ## Options

    * `:limit` — items per page (default: 200)
    * `:filter` — UniFi filter expression

  ## Examples

      UnifiApi.Network.Wifi.stream(client, site_id)
      |> Enum.to_list()
  """
  def stream(client, site_id, opts \\ []) do
    Client.stream(client, "/v1/sites/#{site_id}/wifi/broadcasts", opts)
  end
end
