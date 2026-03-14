defmodule UnifiApi do
  @moduledoc """
  Elixir client for UniFi Dream Machine APIs (Network & Protect).

  ## Quick start

      # Using application config
      client = UnifiApi.new()

      # Using explicit options
      client = UnifiApi.new(base_url: "https://192.168.1.1", api_key: "my-key")

      # Network API
      {:ok, sites} = UnifiApi.Network.Sites.list(client)
      {:ok, devices} = UnifiApi.Network.Devices.list(client, "site-uuid")

      # Protect API
      {:ok, cameras} = UnifiApi.Protect.Cameras.list(client)

  ## Configuration

  Configure via application environment or pass options to `new/1`:

      # config/config.exs
      config :unifi_api,
        base_url: "https://192.168.1.1",
        api_key: "your-api-key",
        verify_ssl: false

  Options passed to `new/1` override application config.
  """

  @doc """
  Creates a new API client.

  ## Options

    * `:base_url` — UniFi controller URL (e.g. `"https://192.168.1.1"`)
    * `:api_key` — API key for authentication
    * `:verify_ssl` — whether to verify SSL certificates (default: `false`)

  ## Examples

      # From application config
      client = UnifiApi.new()

      # With explicit options
      client = UnifiApi.new(base_url: "https://10.0.0.1", api_key: "abc123")

      # With SSL verification enabled
      client = UnifiApi.new(base_url: "https://unifi.example.com", api_key: "key", verify_ssl: true)
  """
  defdelegate new(opts \\ []), to: UnifiApi.Client
end
