defmodule UnifiApi.Protect.Sensors do
  @moduledoc """
  UniFi Protect API — sensor management.

  Lists Protect sensor devices (door/window, motion, leak, etc.).

  ## Response fields

    * `id`, `modelKey`, `name`, `mac`
    * `state` — `"CONNECTED"`, `"CONNECTING"`, or `"DISCONNECTED"`
    * `mountType`, `batteryStatus`, `stats`
    * `lightSettings`, `humiditySettings`, `temperatureSettings`
    * `isOpened`, `isMotionDetected`
    * `alarmSettings`, `leakSettings`
  """

  alias UnifiApi.Client

  defp prefix, do: Client.protect_prefix()

  @doc """
  Lists all sensors.

  ## Examples

      {:ok, sensors} = UnifiApi.Protect.Sensors.list(client)

      # Find open doors/windows
      open = Enum.filter(sensors, & &1["isOpened"])

      # Check battery levels
      low_battery = Enum.filter(sensors, fn s ->
        s["batteryStatus"]["percentage"] < 20
      end)
  """
  def list(client) do
    Client.get(client, "#{prefix()}/v1/sensors")
  end
end
