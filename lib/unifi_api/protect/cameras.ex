defmodule UnifiApi.Protect.Cameras do
  @moduledoc """
  UniFi Protect API — camera management.

  List, view, update cameras, capture snapshots, and control PTZ.

  ## Camera fields

    * `id`, `modelKey`, `name`, `mac`
    * `state` — `"CONNECTED"`, `"CONNECTING"`, or `"DISCONNECTED"`
    * `isMicEnabled`, `micVolume`
    * `osdSettings`, `ledSettings`, `lcdMessage`
    * `activePatrolSlot`, `videoMode`, `hdrType`
    * `featureFlags`, `smartDetectSettings`

  ## Updatable fields

    * `name`, `osdSettings`, `ledSettings`, `lcdMessage`
    * `micVolume`, `videoMode`, `hdrType`, `smartDetectSettings`
  """

  alias UnifiApi.Client

  @doc """
  Lists all cameras.

  ## Examples

      {:ok, cameras} = UnifiApi.Protect.Cameras.list(client)
  """
  def list(client) do
    Client.get(client, "/v1/cameras")
  end

  @doc """
  Gets a specific camera by ID.

  ## Examples

      {:ok, camera} = UnifiApi.Protect.Cameras.get(client, camera_id)
      camera["name"]  # => "Front Door"
      camera["state"] # => "CONNECTED"
  """
  def get(client, id) do
    Client.get(client, "/v1/cameras/#{id}")
  end

  @doc """
  Updates camera settings.

  ## Examples

      {:ok, _} = UnifiApi.Protect.Cameras.update(client, camera_id, %{
        name: "Front Door",
        micVolume: 80,
        videoMode: "highFps",
        ledSettings: %{isEnabled: false}
      })
  """
  def update(client, id, body) do
    Client.patch(client, "/v1/cameras/#{id}", body)
  end

  @doc """
  Takes a camera snapshot. Returns JPEG binary data.

  ## Options

    * `:high_quality` — request a high-quality snapshot (boolean)

  ## Examples

      # Standard quality
      {:ok, jpeg} = UnifiApi.Protect.Cameras.snapshot(client, camera_id)
      File.write!("snapshot.jpg", jpeg)

      # High quality
      {:ok, jpeg} = UnifiApi.Protect.Cameras.snapshot(client, camera_id, high_quality: true)
  """
  def snapshot(client, id, opts \\ []) do
    Client.get_raw(client, "/v1/cameras/#{id}/snapshot", opts)
  end

  @doc """
  Starts a PTZ patrol on the given slot.

  ## Examples

      {:ok, _} = UnifiApi.Protect.Cameras.ptz_patrol_start(client, camera_id, 0)
  """
  def ptz_patrol_start(client, id, slot) do
    Client.post(client, "/v1/cameras/#{id}/ptz/patrol/start/#{slot}", %{})
  end

  @doc """
  Stops the current PTZ patrol.

  ## Examples

      {:ok, _} = UnifiApi.Protect.Cameras.ptz_patrol_stop(client, camera_id)
  """
  def ptz_patrol_stop(client, id) do
    Client.post(client, "/v1/cameras/#{id}/ptz/patrol/stop", %{})
  end

  @doc """
  Moves the camera to a PTZ preset slot.

  ## Examples

      {:ok, _} = UnifiApi.Protect.Cameras.ptz_goto(client, camera_id, 1)
  """
  def ptz_goto(client, id, slot) do
    Client.post(client, "/v1/cameras/#{id}/ptz/goto/#{slot}", %{})
  end
end
