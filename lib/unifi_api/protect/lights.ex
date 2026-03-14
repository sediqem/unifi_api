defmodule UnifiApi.Protect.Lights do
  @moduledoc """
  UniFi Protect API — light management.

  Lists Protect smart floodlight devices.

  ## Response fields

    * `id`, `modelKey`, `name`, `mac`
    * `state` — `"CONNECTED"`, `"CONNECTING"`, or `"DISCONNECTED"`
    * `isDark`, `isLightOn`, `lastMotion`
    * `lightModeSettings` — `%{mode, enableAt}`
    * `lightDeviceSettings` — `%{isIndicatorEnabled, pirDuration, pirSensitivity, ledLevel}`
    * `camera` — associated camera ID
  """

  alias UnifiApi.Client

  @doc """
  Lists all lights.

  ## Examples

      {:ok, lights} = UnifiApi.Protect.Lights.list(client)

      # Find lights that are currently on
      on_lights = Enum.filter(lights, & &1["isLightOn"])
  """
  def list(client) do
    Client.get(client, "/v1/lights")
  end
end
