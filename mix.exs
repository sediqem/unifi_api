defmodule UnifiApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :unifi_api,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "UnifiApi",
      source_url: "https://github.com/nmaroulis/unifi_api",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UnifiApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      groups_for_modules: [
        "Network API": [
          UnifiApi.Network.Info,
          UnifiApi.Network.Sites,
          UnifiApi.Network.Devices,
          UnifiApi.Network.Clients,
          UnifiApi.Network.Networks,
          UnifiApi.Network.Wifi,
          UnifiApi.Network.Firewall,
          UnifiApi.Network.Hotspot,
          UnifiApi.Network.ACL,
          UnifiApi.Network.DNS,
          UnifiApi.Network.TrafficMatching,
          UnifiApi.Network.Resources
        ],
        "Protect API": [
          UnifiApi.Protect.Cameras,
          UnifiApi.Protect.NVR,
          UnifiApi.Protect.Viewers,
          UnifiApi.Protect.Liveviews,
          UnifiApi.Protect.Sensors,
          UnifiApi.Protect.Lights,
          UnifiApi.Protect.Chimes
        ]
      ]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5"},
      {:plug, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.35", only: :dev, runtime: false}
    ]
  end
end
