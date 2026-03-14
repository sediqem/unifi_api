# UnifiApi

Elixir HTTP client for **UniFi Dream Machine** APIs, covering both the **Network API** (v10.1.84) and the **Protect API** (v6.2.88). Built on [Req](https://hexdocs.pm/req).

## Installation

Add `unifi_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unifi_api, "~> 0.1.0"}
  ]
end
```

## Configuration

### Application config

```elixir
# config/config.exs
config :unifi_api,
  base_url: "https://192.168.1.1",
  api_key: "your-api-key",
  verify_ssl: false
```

### Environment variables

```elixir
# config/runtime.exs
config :unifi_api,
  base_url: System.get_env("UNIFI_BASE_URL", "https://192.168.1.1"),
  api_key: System.get_env("UNIFI_API_KEY", ""),
  verify_ssl: System.get_env("UNIFI_VERIFY_SSL", "false") == "true"
```

### Runtime override

You can also pass options directly when creating a client, which override application config:

```elixir
client = UnifiApi.new(
  base_url: "https://10.0.0.1",
  api_key: "my-api-key",
  verify_ssl: false
)
```

## Quick Start

```elixir
# Create a client (uses application config)
client = UnifiApi.new()

# Or with explicit options
client = UnifiApi.new(base_url: "https://192.168.1.1", api_key: "my-key")

# Check the controller version
{:ok, info} = UnifiApi.Network.Info.get_info(client)
# => {:ok, %{"applicationVersion" => "10.1.84"}}

# List all sites
{:ok, sites} = UnifiApi.Network.Sites.list(client)

# List devices on a site
{:ok, devices} = UnifiApi.Network.Devices.list(client, "site-uuid")

# List Protect cameras
{:ok, cameras} = UnifiApi.Protect.Cameras.list(client)
```

## Network API

All Network API functions require a `site_id` (except `Info`, `Resources.list_dpi_categories/2`, `Resources.list_dpi_applications/2`, `Resources.list_countries/2`, and `Devices.list_pending/2`).

### Sites

```elixir
{:ok, sites} = UnifiApi.Network.Sites.list(client)
# => {:ok, [%{"id" => "abc-123", "name" => "Default", "internalReference" => "default"}]}
```

### Devices

```elixir
# List all devices on a site
{:ok, devices} = UnifiApi.Network.Devices.list(client, site_id)

# Get a specific device
{:ok, device} = UnifiApi.Network.Devices.get(client, site_id, device_id)

# Get latest device statistics
{:ok, stats} = UnifiApi.Network.Devices.get_statistics(client, site_id, device_id)

# Adopt a new device
{:ok, _} = UnifiApi.Network.Devices.adopt(client, site_id, %{mac: "aa:bb:cc:dd:ee:ff"})

# Execute a device action (restart, locate, etc.)
{:ok, _} = UnifiApi.Network.Devices.execute_action(client, site_id, device_id, %{action: "restart"})

# Execute a port action (PoE cycle, etc.)
{:ok, _} = UnifiApi.Network.Devices.execute_port_action(client, site_id, device_id, 3, %{action: "cycle"})

# Remove a device
{:ok, _} = UnifiApi.Network.Devices.remove(client, site_id, device_id)

# List pending devices (not site-scoped)
{:ok, pending} = UnifiApi.Network.Devices.list_pending(client)
```

### Clients

```elixir
# List connected clients
{:ok, clients} = UnifiApi.Network.Clients.list(client, site_id)
# Each client has: type (WIRED/WIRELESS/VPN/TELEPORT), id, name, connectedAt, ipAddress, access
```

### Networks

```elixir
# List all networks
{:ok, networks} = UnifiApi.Network.Networks.list(client, site_id)

# Get a specific network
{:ok, network} = UnifiApi.Network.Networks.get(client, site_id, network_id)

# Create a network
{:ok, network} = UnifiApi.Network.Networks.create(client, site_id, %{
  name: "Guest VLAN",
  vlanId: 100
})

# Update a network
{:ok, _} = UnifiApi.Network.Networks.update(client, site_id, network_id, %{name: "New Name"})

# Delete a network
{:ok, _} = UnifiApi.Network.Networks.delete(client, site_id, network_id)
```

### WiFi

```elixir
# List WiFi broadcasts (SSIDs)
{:ok, ssids} = UnifiApi.Network.Wifi.list(client, site_id)
```

### Firewall

```elixir
# --- Zones ---
{:ok, zones} = UnifiApi.Network.Firewall.list_zones(client, site_id)
{:ok, zone} = UnifiApi.Network.Firewall.get_zone(client, site_id, zone_id)
{:ok, zone} = UnifiApi.Network.Firewall.create_zone(client, site_id, %{name: "DMZ", networkIds: [net_id]})
{:ok, _} = UnifiApi.Network.Firewall.update_zone(client, site_id, zone_id, %{name: "DMZ-Updated"})
{:ok, _} = UnifiApi.Network.Firewall.delete_zone(client, site_id, zone_id)

# --- Policies ---
{:ok, policies} = UnifiApi.Network.Firewall.list_policies(client, site_id)
{:ok, policy} = UnifiApi.Network.Firewall.get_policy(client, site_id, policy_id)
{:ok, policy} = UnifiApi.Network.Firewall.create_policy(client, site_id, %{
  name: "Block IoT to LAN",
  enabled: true,
  action: "BLOCK",
  source: %{zoneId: iot_zone_id},
  destination: %{zoneId: lan_zone_id}
})
{:ok, _} = UnifiApi.Network.Firewall.update_policy(client, site_id, policy_id, %{enabled: false})
{:ok, _} = UnifiApi.Network.Firewall.delete_policy(client, site_id, policy_id)
```

### Hotspot Vouchers

```elixir
# List all vouchers
{:ok, vouchers} = UnifiApi.Network.Hotspot.list_vouchers(client, site_id)

# Get a specific voucher
{:ok, voucher} = UnifiApi.Network.Hotspot.get_voucher(client, site_id, voucher_id)

# Create vouchers (1-1000 at a time)
{:ok, vouchers} = UnifiApi.Network.Hotspot.create_vouchers(client, site_id, %{
  count: 10,
  name: "Event Pass",
  timeLimitMinutes: 1440,
  authorizedGuestLimit: 1,
  dataUsageLimitMBytes: 500,
  rxRateLimitKbps: 5000,
  txRateLimitKbps: 1000
})

# Delete a specific voucher
{:ok, _} = UnifiApi.Network.Hotspot.delete_voucher(client, site_id, voucher_id)

# Delete all vouchers
{:ok, _} = UnifiApi.Network.Hotspot.delete_vouchers(client, site_id)
```

### ACL Rules

```elixir
# List ACL rules
{:ok, rules} = UnifiApi.Network.ACL.list(client, site_id)

# Create an ACL rule
{:ok, rule} = UnifiApi.Network.ACL.create(client, site_id, %{
  type: "IPV4",
  name: "Block SSH",
  enabled: true,
  action: "BLOCK",
  protocolFilter: %{protocol: "TCP", dstPort: 22}
})

# Update and delete
{:ok, _} = UnifiApi.Network.ACL.update(client, site_id, rule_id, %{enabled: false})
{:ok, _} = UnifiApi.Network.ACL.delete(client, site_id, rule_id)

# Manage rule ordering
{:ok, ordering} = UnifiApi.Network.ACL.get_ordering(client, site_id)
{:ok, _} = UnifiApi.Network.ACL.update_ordering(client, site_id, %{ids: ["rule-1", "rule-2"]})
```

### DNS Policies

```elixir
# List DNS policies
{:ok, policies} = UnifiApi.Network.DNS.list(client, site_id)

# Create a DNS record
{:ok, policy} = UnifiApi.Network.DNS.create(client, site_id, %{
  type: "A_RECORD",
  name: "app.local",
  value: "192.168.1.50"
})

# Supported types: A_RECORD, AAAA_RECORD, CNAME_RECORD, MX_RECORD,
#                  TXT_RECORD, SRV_RECORD, FORWARD_DOMAIN
```

### Traffic Matching

```elixir
{:ok, lists} = UnifiApi.Network.TrafficMatching.list(client, site_id)
# Types: PORTS, IPV4_ADDRESSES, IPV6_ADDRESSES
```

### Supporting Resources

```elixir
# WAN interfaces
{:ok, wans} = UnifiApi.Network.Resources.list_wans(client, site_id)

# VPN
{:ok, tunnels} = UnifiApi.Network.Resources.list_vpn_tunnels(client, site_id)
{:ok, servers} = UnifiApi.Network.Resources.list_vpn_servers(client, site_id)

# RADIUS
{:ok, profiles} = UnifiApi.Network.Resources.list_radius_profiles(client, site_id)

# Device tags
{:ok, tags} = UnifiApi.Network.Resources.list_device_tags(client, site_id)

# DPI (not site-scoped)
{:ok, categories} = UnifiApi.Network.Resources.list_dpi_categories(client)
{:ok, apps} = UnifiApi.Network.Resources.list_dpi_applications(client)

# Countries (not site-scoped)
{:ok, countries} = UnifiApi.Network.Resources.list_countries(client)
```

## Protect API

Protect endpoints are **not** site-scoped.

### Cameras

```elixir
# List all cameras
{:ok, cameras} = UnifiApi.Protect.Cameras.list(client)

# Get a specific camera
{:ok, camera} = UnifiApi.Protect.Cameras.get(client, camera_id)

# Update camera settings
{:ok, _} = UnifiApi.Protect.Cameras.update(client, camera_id, %{
  name: "Front Door",
  micVolume: 80,
  videoMode: "highFps",
  ledSettings: %{isEnabled: false}
})

# Take a snapshot (returns JPEG binary)
{:ok, jpeg} = UnifiApi.Protect.Cameras.snapshot(client, camera_id)
File.write!("snapshot.jpg", jpeg)

# High quality snapshot
{:ok, jpeg} = UnifiApi.Protect.Cameras.snapshot(client, camera_id, high_quality: true)

# PTZ controls
{:ok, _} = UnifiApi.Protect.Cameras.ptz_goto(client, camera_id, 1)           # Go to preset slot 1
{:ok, _} = UnifiApi.Protect.Cameras.ptz_patrol_start(client, camera_id, 0)   # Start patrol slot 0
{:ok, _} = UnifiApi.Protect.Cameras.ptz_patrol_stop(client, camera_id)       # Stop patrol
```

### NVR

```elixir
{:ok, nvr} = UnifiApi.Protect.NVR.get(client)
# => {:ok, %{"id" => "...", "name" => "UNVR", "doorbellSettings" => %{...}}}
```

### Viewers

```elixir
{:ok, viewers} = UnifiApi.Protect.Viewers.list(client)
{:ok, viewer} = UnifiApi.Protect.Viewers.get(client, viewer_id)
{:ok, _} = UnifiApi.Protect.Viewers.update(client, viewer_id, %{liveview: liveview_id})
```

### Liveviews

```elixir
{:ok, liveviews} = UnifiApi.Protect.Liveviews.list(client)
# Each has: id, name, isDefault, isGlobal, owner, layout (1-26), slots
```

### Sensors

```elixir
{:ok, sensors} = UnifiApi.Protect.Sensors.list(client)
# Each has: id, name, state, mountType, batteryStatus, stats,
#           isOpened, isMotionDetected, temperature/humidity/light/leak settings
```

### Lights

```elixir
{:ok, lights} = UnifiApi.Protect.Lights.list(client)
# Each has: id, name, state, isDark, isLightOn, lastMotion,
#           lightModeSettings, lightDeviceSettings, camera
```

### Chimes

```elixir
{:ok, chimes} = UnifiApi.Protect.Chimes.list(client)
# Each has: id, name, state, cameraIds, ringSettings
```

## Pagination & Filtering

List endpoints on the Network API support pagination and filtering:

```elixir
# Paginate
{:ok, page1} = UnifiApi.Network.Devices.list(client, site_id, limit: 50, offset: 0)
{:ok, page2} = UnifiApi.Network.Devices.list(client, site_id, limit: 50, offset: 50)

# Filter (UniFi filter expression syntax)
{:ok, wireless} = UnifiApi.Network.Clients.list(client, site_id,
  filter: "type.eq(WIRELESS)"
)

# Combine
{:ok, results} = UnifiApi.Network.Clients.list(client, site_id,
  filter: "type.eq(WIRED)",
  limit: 10,
  offset: 0
)
```

### Filter syntax

Filters use the format `property.function(args)` and can be combined:

| Function | Example |
|----------|---------|
| `eq` | `name.eq(Office)` |
| `ne` | `type.ne(WIRELESS)` |
| `gt`, `ge`, `lt`, `le` | `connectedAt.gt(1700000000)` |
| `in`, `notIn` | `type.in(WIRED,VPN)` |
| `like` | `name.like(cam*)` |
| `isNull`, `isNotNull` | `ipAddress.isNotNull()` |
| `isEmpty` | `name.isEmpty()` |
| `contains`, `containsAny`, `containsAll`, `containsExactly` | `tags.contains(vip)` |

Combine with `and()`, `or()`, `not()`.

## Data Extraction Recipes

Common patterns for pulling structured data out of your UniFi controller.

### Export all clients to a list of maps

```elixir
client = UnifiApi.new()
{:ok, sites} = UnifiApi.Network.Sites.list(client)

all_clients =
  sites
  |> Enum.flat_map(fn site ->
    {:ok, clients} = UnifiApi.Network.Clients.list(client, site["id"], limit: 200)
    Enum.map(clients, &Map.put(&1, "site", site["name"]))
  end)

# Filter only wireless clients
wireless = Enum.filter(all_clients, &(&1["type"] == "WIRELESS"))
```

### Build a device inventory CSV

```elixir
client = UnifiApi.new()
{:ok, sites} = UnifiApi.Network.Sites.list(client)

rows =
  for site <- sites,
      {:ok, devices} <- [UnifiApi.Network.Devices.list(client, site["id"], limit: 200)],
      device <- devices do
    [site["name"], device["name"], device["mac"], device["model"], device["state"]]
    |> Enum.join(",")
  end

csv = ["site,name,mac,model,state" | rows] |> Enum.join("\n")
File.write!("devices.csv", csv)
```

### Scrape all camera snapshots

```elixir
client = UnifiApi.new()
{:ok, cameras} = UnifiApi.Protect.Cameras.list(client)

for camera <- cameras, camera["state"] == "CONNECTED" do
  case UnifiApi.Protect.Cameras.snapshot(client, camera["id"], high_quality: true) do
    {:ok, jpeg} ->
      name = camera["name"] |> String.replace(~r/[^\w]/, "_")
      File.write!("snapshots/#{name}.jpg", jpeg)

    {:error, reason} ->
      IO.puts("Failed #{camera["name"]}: #{inspect(reason)}")
  end
end
```

### Collect network topology (sites, networks, devices)

```elixir
client = UnifiApi.new()
{:ok, sites} = UnifiApi.Network.Sites.list(client)

topology =
  Enum.map(sites, fn site ->
    sid = site["id"]
    {:ok, networks} = UnifiApi.Network.Networks.list(client, sid, limit: 200)
    {:ok, devices} = UnifiApi.Network.Devices.list(client, sid, limit: 200)

    %{
      site: site["name"],
      networks: Enum.map(networks, &Map.take(&1, ["id", "name", "vlanId", "subnet"])),
      devices: Enum.map(devices, &Map.take(&1, ["id", "name", "mac", "model", "state"]))
    }
  end)
```

### Monitor connected client count over time

```elixir
client = UnifiApi.new()
{:ok, [site | _]} = UnifiApi.Network.Sites.list(client)

# Poll every 60 seconds
Stream.interval(60_000)
|> Stream.map(fn _ ->
  {:ok, clients} = UnifiApi.Network.Clients.list(client, site["id"], limit: 200)

  counts =
    clients
    |> Enum.group_by(& &1["type"])
    |> Map.new(fn {type, list} -> {type, length(list)} end)

  {DateTime.utc_now(), counts}
end)
|> Stream.each(fn {time, counts} ->
  IO.puts("#{time} | WIRED=#{counts["WIRED"] || 0} WIRELESS=#{counts["WIRELESS"] || 0} VPN=#{counts["VPN"] || 0}")
end)
|> Stream.run()
```

### Export firewall rules

```elixir
client = UnifiApi.new()
{:ok, sites} = UnifiApi.Network.Sites.list(client)

for site <- sites do
  sid = site["id"]
  {:ok, zones} = UnifiApi.Network.Firewall.list_zones(client, sid, limit: 200)
  {:ok, policies} = UnifiApi.Network.Firewall.list_policies(client, sid, limit: 200)

  %{
    site: site["name"],
    zones: Enum.map(zones, &Map.take(&1, ["id", "name", "networkIds"])),
    policies:
      Enum.map(policies, &Map.take(&1, ["id", "name", "enabled", "action", "source", "destination"]))
  }
end
```

### Export hotspot voucher codes

```elixir
client = UnifiApi.new()
{:ok, [site | _]} = UnifiApi.Network.Sites.list(client)

{:ok, vouchers} = UnifiApi.Network.Hotspot.list_vouchers(client, site["id"], limit: 200)

active =
  vouchers
  |> Enum.reject(& &1["expired"])
  |> Enum.map(&Map.take(&1, ["code", "name", "timeLimitMinutes", "expiresAt"]))

# Print as a table
for v <- active do
  IO.puts("#{v["code"]}  #{v["name"]}  #{v["timeLimitMinutes"]}min")
end
```

### Dump all Protect device info

```elixir
client = UnifiApi.new()

{:ok, cameras} = UnifiApi.Protect.Cameras.list(client)
{:ok, sensors} = UnifiApi.Protect.Sensors.list(client)
{:ok, lights} = UnifiApi.Protect.Lights.list(client)
{:ok, chimes} = UnifiApi.Protect.Chimes.list(client)
{:ok, nvr} = UnifiApi.Protect.NVR.get(client)

protect_inventory = %{
  nvr: Map.take(nvr, ["id", "name", "modelKey"]),
  cameras: Enum.map(cameras, &Map.take(&1, ["id", "name", "state", "mac", "modelKey"])),
  sensors: Enum.map(sensors, &Map.take(&1, ["id", "name", "state", "batteryStatus"])),
  lights: Enum.map(lights, &Map.take(&1, ["id", "name", "state", "isLightOn"])),
  chimes: Enum.map(chimes, &Map.take(&1, ["id", "name", "state"]))
}
```

## Error Handling

All functions return `{:ok, body}` on success or `{:error, reason}` on failure:

```elixir
case UnifiApi.Network.Devices.get(client, site_id, "bad-id") do
  {:ok, device} ->
    IO.inspect(device)

  {:error, {404, body}} ->
    IO.puts("Not found: #{inspect(body)}")

  {:error, {401, _}} ->
    IO.puts("Invalid API key")

  {:error, reason} ->
    IO.puts("Connection error: #{inspect(reason)}")
end
```

## Generating Docs

```bash
mix deps.get
mix docs
open doc/index.html
```

## License

MIT
