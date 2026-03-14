defmodule UnifiApi.Protect.Liveviews do
  @moduledoc """
  UniFi Protect API — liveview management.

  Lists configured liveview layouts for Protect viewports.

  ## Response fields

    * `id`, `modelKey`, `name`
    * `isDefault`, `isGlobal`, `owner`
    * `layout` — grid layout (1-26)
    * `slots` — list of `%{cameras, cycleMode, cycleInterval}`
  """

  alias UnifiApi.Client

  defp prefix, do: Client.protect_prefix()

  @doc """
  Lists all liveviews.

  ## Examples

      {:ok, liveviews} = UnifiApi.Protect.Liveviews.list(client)

      # Find the default liveview
      default = Enum.find(liveviews, & &1["isDefault"])
  """
  def list(client) do
    Client.get(client, "#{prefix()}/v1/liveviews")
  end
end
