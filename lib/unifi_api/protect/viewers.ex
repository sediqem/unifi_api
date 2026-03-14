defmodule UnifiApi.Protect.Viewers do
  @moduledoc """
  UniFi Protect API — viewer management.

  List, view, and update Protect viewport devices.

  ## Response fields

    * `id`, `modelKey`, `name`, `mac`
    * `state` — `"CONNECTED"`, `"CONNECTING"`, or `"DISCONNECTED"`
    * `liveview` — the assigned liveview ID
    * `streamLimit` — max concurrent streams
  """

  alias UnifiApi.Client

  @doc """
  Lists all viewers.

  ## Examples

      {:ok, viewers} = UnifiApi.Protect.Viewers.list(client)
  """
  def list(client) do
    Client.get(client, "/v1/viewers")
  end

  @doc """
  Gets a specific viewer by ID.

  ## Examples

      {:ok, viewer} = UnifiApi.Protect.Viewers.get(client, viewer_id)
      viewer["name"]  # => "Office Display"
      viewer["state"] # => "CONNECTED"
  """
  def get(client, id) do
    Client.get(client, "/v1/viewers/#{id}")
  end

  @doc """
  Updates viewer settings.

  ## Examples

      {:ok, _} = UnifiApi.Protect.Viewers.update(client, viewer_id, %{
        liveview: liveview_id
      })
  """
  def update(client, id, body) do
    Client.patch(client, "/v1/viewers/#{id}", body)
  end
end
