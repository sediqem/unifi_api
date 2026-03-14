defmodule UnifiApi.Network.Hotspot do
  @moduledoc """
  UniFi Network API — hotspot voucher management.

  Create, list, and delete guest access vouchers.

  ## Voucher fields

    * `id`, `name`, `code`
    * `createdAt`, `activatedAt`, `expiresAt`, `expired`
    * `authorizedGuestLimit`, `authorizedGuestCount`
    * `timeLimitMinutes`, `dataUsageLimitMBytes`
    * `rxRateLimitKbps`, `txRateLimitKbps`
  """

  alias UnifiApi.Client

  @doc """
  Lists all hotspot vouchers on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, vouchers} = UnifiApi.Network.Hotspot.list_vouchers(client, site_id)
  """
  def list_vouchers(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/hotspot/vouchers", opts)
  end

  @doc """
  Gets a specific voucher by ID.

  ## Examples

      {:ok, voucher} = UnifiApi.Network.Hotspot.get_voucher(client, site_id, voucher_id)
      voucher["code"]    # => "12345-67890"
      voucher["expired"] # => false
  """
  def get_voucher(client, site_id, voucher_id) do
    Client.get(client, "/v1/sites/#{site_id}/hotspot/vouchers/#{voucher_id}")
  end

  @doc """
  Creates one or more vouchers (1-1000 at a time).

  ## Body fields

    * `count` — number of vouchers to create (1-1000, required)
    * `name` — voucher label
    * `timeLimitMinutes` — session duration
    * `authorizedGuestLimit` — max guests per voucher
    * `dataUsageLimitMBytes` — data cap
    * `rxRateLimitKbps` — download speed limit
    * `txRateLimitKbps` — upload speed limit

  ## Examples

      {:ok, vouchers} = UnifiApi.Network.Hotspot.create_vouchers(client, site_id, %{
        count: 10,
        name: "Event Pass",
        timeLimitMinutes: 1440,
        authorizedGuestLimit: 1,
        dataUsageLimitMBytes: 500,
        rxRateLimitKbps: 5000,
        txRateLimitKbps: 1000
      })
  """
  def create_vouchers(client, site_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/hotspot/vouchers", body)
  end

  @doc """
  Deletes all vouchers on a site.

  ## Examples

      {:ok, _} = UnifiApi.Network.Hotspot.delete_vouchers(client, site_id)
  """
  def delete_vouchers(client, site_id) do
    Client.delete(client, "/v1/sites/#{site_id}/hotspot/vouchers")
  end

  @doc """
  Deletes a specific voucher.

  ## Examples

      {:ok, _} = UnifiApi.Network.Hotspot.delete_voucher(client, site_id, voucher_id)
  """
  def delete_voucher(client, site_id, voucher_id) do
    Client.delete(client, "/v1/sites/#{site_id}/hotspot/vouchers/#{voucher_id}")
  end
end
