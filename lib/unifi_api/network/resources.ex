defmodule UnifiApi.Network.Resources do
  @moduledoc """
  UniFi Network API — supporting resources.

  Read-only endpoints for WANs, VPN tunnels/servers, RADIUS profiles,
  device tags, DPI data, and country lists. These are typically used
  as reference data when building firewall rules, ACLs, or network configs.
  """

  alias UnifiApi.Client

  @doc """
  Lists WAN interfaces on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, wans} = UnifiApi.Network.Resources.list_wans(client, site_id)
  """
  def list_wans(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/wans", opts)
  end

  @doc """
  Lists site-to-site VPN tunnels.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, tunnels} = UnifiApi.Network.Resources.list_vpn_tunnels(client, site_id)
  """
  def list_vpn_tunnels(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/vpn/site-to-site-tunnels", opts)
  end

  @doc """
  Lists VPN servers on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, servers} = UnifiApi.Network.Resources.list_vpn_servers(client, site_id)
  """
  def list_vpn_servers(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/vpn/servers", opts)
  end

  @doc """
  Lists RADIUS profiles on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, profiles} = UnifiApi.Network.Resources.list_radius_profiles(client, site_id)
  """
  def list_radius_profiles(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/radius/profiles", opts)
  end

  @doc """
  Lists device tags on a site.

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, tags} = UnifiApi.Network.Resources.list_device_tags(client, site_id)
  """
  def list_device_tags(client, site_id, opts \\ []) do
    Client.get(client, "/v1/sites/#{site_id}/device-tags", opts)
  end

  @doc """
  Lists DPI categories (not site-scoped).

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, categories} = UnifiApi.Network.Resources.list_dpi_categories(client)
  """
  def list_dpi_categories(client, opts \\ []) do
    Client.get(client, "/v1/dpi/categories", opts)
  end

  @doc """
  Lists DPI applications (not site-scoped).

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, apps} = UnifiApi.Network.Resources.list_dpi_applications(client)
  """
  def list_dpi_applications(client, opts \\ []) do
    Client.get(client, "/v1/dpi/applications", opts)
  end

  @doc """
  Lists countries (not site-scoped).

  ## Options

  Supports pagination: `:offset`, `:limit`, `:filter`.

  ## Examples

      {:ok, countries} = UnifiApi.Network.Resources.list_countries(client)
  """
  def list_countries(client, opts \\ []) do
    Client.get(client, "/v1/countries", opts)
  end
end
