defmodule UnifiApi.Client do
  @moduledoc """
  HTTP client wrapper for UniFi API requests.

  This module handles authentication, base URL construction, SSL settings,
  pagination parameters, and response normalization. All API modules delegate
  to this client for HTTP operations.

  Typically you create a client via `UnifiApi.new/1` and pass it to API functions:

      client = UnifiApi.new(base_url: "https://192.168.1.1", api_key: "my-key")
      UnifiApi.Network.Sites.list(client)
  """

  @base_path "/integration"

  @doc """
  Creates a new API client.

  See `UnifiApi.new/1` for options and examples.
  """
  def new(opts \\ []) do
    base_url = opts[:base_url] || Application.get_env(:unifi_api, :base_url)
    api_key = opts[:api_key] || Application.get_env(:unifi_api, :api_key)

    verify_ssl =
      Keyword.get(opts, :verify_ssl, Application.get_env(:unifi_api, :verify_ssl, false))

    connect_opts =
      if verify_ssl,
        do: [],
        else: [transport_opts: [verify: :verify_none]]

    Req.new(
      base_url: base_url <> @base_path,
      headers: [{"x-api-key", api_key}],
      connect_options: connect_opts
    )
  end

  @doc """
  Performs a GET request.

  ## Options

    * `:offset` — pagination offset (default: 0)
    * `:limit` — page size (default: 25, max: 200)
    * `:filter` — UniFi filter expression (e.g. `"type.eq(WIRELESS)"`)

  ## Examples

      Client.get(client, "/v1/sites")
      Client.get(client, "/v1/sites/abc/clients", limit: 50, offset: 100)
      Client.get(client, "/v1/sites/abc/clients", filter: "type.eq(WIRED)")
  """
  def get(client, path, opts \\ []) do
    params = build_params(opts)

    client
    |> Req.get(url: path, params: params)
    |> handle_response()
  end

  @doc """
  Performs a POST request with a JSON body.

  ## Examples

      Client.post(client, "/v1/sites/abc/networks", %{name: "Guest"})
  """
  def post(client, path, body, opts \\ []) do
    params = build_params(opts)

    client
    |> Req.post(url: path, json: body, params: params)
    |> handle_response()
  end

  @doc """
  Performs a PUT request with a JSON body.

  ## Examples

      Client.put(client, "/v1/sites/abc/networks/net-1", %{name: "Updated"})
  """
  def put(client, path, body, opts \\ []) do
    params = build_params(opts)

    client
    |> Req.put(url: path, json: body, params: params)
    |> handle_response()
  end

  @doc """
  Performs a PATCH request with a JSON body.

  ## Examples

      Client.patch(client, "/v1/cameras/cam-1", %{name: "Front Door"})
  """
  def patch(client, path, body, opts \\ []) do
    params = build_params(opts)

    client
    |> Req.patch(url: path, json: body, params: params)
    |> handle_response()
  end

  @doc """
  Performs a DELETE request.

  ## Examples

      Client.delete(client, "/v1/sites/abc/networks/net-1")
  """
  def delete(client, path, opts \\ []) do
    params = build_params(opts)

    client
    |> Req.delete(url: path, params: params)
    |> handle_response()
  end

  @doc """
  Performs a GET request returning the raw (non-JSON-decoded) body.

  Used for binary responses like camera snapshots.

  ## Options

    * `:high_quality` — request high-quality snapshot (boolean)

  ## Examples

      {:ok, jpeg_binary} = Client.get_raw(client, "/v1/cameras/cam-1/snapshot")
      {:ok, jpeg_binary} = Client.get_raw(client, "/v1/cameras/cam-1/snapshot", high_quality: true)
  """
  def get_raw(client, path, opts \\ []) do
    params = build_params(opts)

    case Req.get(client, url: path, params: params) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Creates a lazy stream that automatically paginates through results.

  Uses `Stream.resource/3` to fetch pages on demand. Each page requests
  up to `:limit` items (default 200, the API maximum). The stream halts
  when a page returns fewer items than the limit.

  Raises on API errors.

  ## Options

    * `:limit` — items per page (default: 200)
    * `:filter` — UniFi filter expression

  ## Examples

      # Stream all items
      Client.stream(client, "/v1/sites/abc/devices")
      |> Enum.to_list()

      # Stream with filter, take first 10
      Client.stream(client, "/v1/sites/abc/clients", filter: "type.eq(WIRELESS)")
      |> Enum.take(10)

      # Count all wireless clients across pages
      Client.stream(client, "/v1/sites/abc/clients", filter: "type.eq(WIRELESS)")
      |> Enum.count()
  """
  def stream(client, path, opts \\ []) do
    page_size = opts[:limit] || 200
    base_opts = Keyword.take(opts, [:filter])

    Stream.resource(
      fn -> 0 end,
      fn
        :halt ->
          {:halt, :done}

        offset ->
          request_opts = Keyword.merge(base_opts, limit: page_size, offset: offset)

          case get(client, path, request_opts) do
            {:ok, items} when is_list(items) ->
              if length(items) < page_size,
                do: {items, :halt},
                else: {items, offset + page_size}

            {:error, reason} ->
              raise "UnifiApi.Client.stream failed: #{inspect(reason)}"
          end
      end,
      fn _state -> :ok end
    )
  end

  defp build_params(opts) do
    []
    |> maybe_add(:offset, opts[:offset])
    |> maybe_add(:limit, opts[:limit])
    |> maybe_add(:filter, opts[:filter])
    |> maybe_add(:highQuality, opts[:high_quality])
  end

  defp maybe_add(params, _key, nil), do: params
  defp maybe_add(params, key, value), do: [{key, value} | params]

  defp handle_response({:ok, %Req.Response{status: status, body: body}})
       when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
