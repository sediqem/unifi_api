defmodule UnifiApi.Protect.Chimes do
  @moduledoc """
  UniFi Protect API — chime management.

  Lists Protect chime devices (doorbell chimes).

  ## Response fields

    * `id`, `modelKey`, `name`, `mac`
    * `state` — `"CONNECTED"`, `"CONNECTING"`, or `"DISCONNECTED"`
    * `cameraIds` — list of associated doorbell camera IDs
    * `ringSettings` — list of `%{cameraId, repeatTimes, ringtoneId, volume}`
  """

  alias UnifiApi.Client

  @doc """
  Lists all chimes.

  ## Examples

      {:ok, chimes} = UnifiApi.Protect.Chimes.list(client)
  """
  def list(client) do
    Client.get(client, "/v1/chimes")
  end
end
