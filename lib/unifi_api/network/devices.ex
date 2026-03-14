defmodule UnifiApi.Network.Devices do
  @moduledoc """
  UniFi Network API — device management.

  Manage adopted UniFi devices (APs, switches, gateways), view statistics,
  execute device and port actions, and list pending adoption requests.
  """

  alias UnifiApi.Client

  @doc """
  Lists all devices on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, devices} = UnifiApi.Network.Devices.list(client, site_id)
      {:ok, devices} = UnifiApi.Network.Devices.list(client, site_id, limit: 100)
  """
  def list(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/devices", opts)
  end

  @doc """
  Gets a specific device by ID.

  ## Examples

      {:ok, device} = UnifiApi.Network.Devices.get(client, site_id, "device-uuid")
      device["name"]   # => "US-24-250W"
      device["state"]  # => "CONNECTED"
  """
  def get(client, site_id, device_id) do
    Client.get(client, "/v1/sites/#{site_id}/devices/#{device_id}")
  end

  @doc """
  Adopts a new device into the site.

  ## Examples

      {:ok, _} = UnifiApi.Network.Devices.adopt(client, site_id, %{mac: "aa:bb:cc:dd:ee:ff"})
  """
  def adopt(client, site_id, body, opts \\ []) do
    Client.post(client, "/v1/sites/#{site_id}/devices", body, opts)
  end

  @doc """
  Removes a device from the site.

  ## Examples

      {:ok, _} = UnifiApi.Network.Devices.remove(client, site_id, device_id)
  """
  def remove(client, site_id, device_id) do
    Client.delete(client, "/v1/sites/#{site_id}/devices/#{device_id}")
  end

  @doc """
  Gets the latest statistics for a device.

  ## Examples

      {:ok, stats} = UnifiApi.Network.Devices.get_statistics(client, site_id, device_id)
  """
  def get_statistics(client, site_id, device_id) do
    Client.get(client, "/v1/sites/#{site_id}/devices/#{device_id}/statistics/latest")
  end

  @doc """
  Executes an action on a device (e.g. restart, locate).

  ## Examples

      {:ok, _} = UnifiApi.Network.Devices.execute_action(client, site_id, device_id, %{action: "restart"})
      {:ok, _} = UnifiApi.Network.Devices.execute_action(client, site_id, device_id, %{action: "locate"})
  """
  def execute_action(client, site_id, device_id, body) do
    Client.post(client, "/v1/sites/#{site_id}/devices/#{device_id}/actions", body)
  end

  @doc """
  Executes an action on a specific device port (e.g. PoE cycle).

  ## Examples

      # Cycle PoE on port 3
      {:ok, _} = UnifiApi.Network.Devices.execute_port_action(client, site_id, device_id, 3, %{action: "cycle"})
  """
  def execute_port_action(client, site_id, device_id, port_idx, body) do
    Client.post(
      client,
      "/v1/sites/#{site_id}/devices/#{device_id}/interfaces/ports/#{port_idx}/actions",
      body
    )
  end

  @doc """
  Lists devices pending adoption (not site-scoped).

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, pending} = UnifiApi.Network.Devices.list_pending(client)
  """
  def list_pending(client, opts \\ []) do
    Client.get(client, "/v1/pending-devices", opts)
  end

  @doc """
  Returns a lazy stream that auto-paginates through all devices on a site.

  ## Options

    * `:limit` — items per page (default: 200)
    * `:filter` — UniFi filter expression

  ## Examples

      UnifiApi.Network.Devices.stream(client, site_id)
      |> Stream.filter(& &1["state"] == "CONNECTED")
      |> Enum.to_list()
  """
  def stream(client, site_id, opts \\ []) do
    Client.stream(client, "/v1/sites/#{site_id}/devices", opts)
  end

  @doc """
  Returns a lazy stream that auto-paginates through pending devices.

  ## Examples

      UnifiApi.Network.Devices.stream_pending(client)
      |> Enum.to_list()
  """
  def stream_pending(client, opts \\ []) do
    Client.stream(client, "/v1/pending-devices", opts)
  end
end
