defmodule UnifiApi.ClientTest do
  use ExUnit.Case, async: true

  alias UnifiApi.Client

  defp test_client(plug) do
    Req.new(
      base_url: "http://localhost/integration",
      headers: [{"x-api-key", "test-key"}],
      plug: plug,
      retry: false
    )
  end

  describe "new/1" do
    test "returns a Req.Request struct" do
      client = Client.new(base_url: "https://10.0.0.1", api_key: "abc")
      assert %Req.Request{} = client
    end

    test "sends x-api-key header" do
      client =
        Client.new(base_url: "http://localhost", api_key: "secret123")
        |> Req.merge(
          plug: fn conn ->
            [key] = Plug.Conn.get_req_header(conn, "x-api-key")
            Req.Test.json(conn, %{"key" => key})
          end
        )

      assert {:ok, %{"key" => "secret123"}} = Client.get(client, "/v1/info")
    end

    test "sets base_url with /integration path" do
      client =
        Client.new(base_url: "http://localhost", api_key: "k")
        |> Req.merge(
          plug: fn conn ->
            Req.Test.json(conn, %{"path" => conn.request_path})
          end
        )

      assert {:ok, %{"path" => "/integration/v1/info"}} = Client.get(client, "/v1/info")
    end
  end

  describe "get/3" do
    test "returns {:ok, body} on 200" do
      client =
        test_client(fn conn ->
          assert conn.method == "GET"
          Req.Test.json(conn, %{"data" => "hello"})
        end)

      assert {:ok, %{"data" => "hello"}} = Client.get(client, "/v1/test")
    end

    test "returns {:error, {status, body}} on 404" do
      client =
        test_client(fn conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(404, Jason.encode!(%{"error" => "not found"}))
        end)

      assert {:error, {404, %{"error" => "not found"}}} = Client.get(client, "/v1/missing")
    end

    test "returns {:error, {status, body}} on 500" do
      client =
        test_client(fn conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(500, Jason.encode!(%{"error" => "internal"}))
        end)

      assert {:error, {500, _body}} = Client.get(client, "/v1/broken")
    end

    test "passes offset, limit, and filter as query params" do
      client =
        test_client(fn conn ->
          params = Plug.Conn.fetch_query_params(conn).query_params
          Req.Test.json(conn, params)
        end)

      assert {:ok, %{"offset" => "10", "limit" => "50", "filter" => "name.eq(foo)"}} =
               Client.get(client, "/v1/test", offset: 10, limit: 50, filter: "name.eq(foo)")
    end
  end

  describe "post/4" do
    test "sends JSON body and returns {:ok, body}" do
      client =
        test_client(fn conn ->
          assert conn.method == "POST"
          {:ok, raw, conn} = Plug.Conn.read_body(conn)
          body = Jason.decode!(raw)
          Req.Test.json(conn, %{"received" => body})
        end)

      assert {:ok, %{"received" => %{"name" => "test"}}} =
               Client.post(client, "/v1/resource", %{name: "test"})
    end
  end

  describe "put/4" do
    test "sends JSON body and returns {:ok, body}" do
      client =
        test_client(fn conn ->
          assert conn.method == "PUT"
          {:ok, raw, conn} = Plug.Conn.read_body(conn)
          body = Jason.decode!(raw)
          Req.Test.json(conn, %{"received" => body})
        end)

      assert {:ok, %{"received" => %{"name" => "updated"}}} =
               Client.put(client, "/v1/resource/1", %{name: "updated"})
    end
  end

  describe "patch/4" do
    test "sends JSON body and returns {:ok, body}" do
      client =
        test_client(fn conn ->
          assert conn.method == "PATCH"
          {:ok, raw, conn} = Plug.Conn.read_body(conn)
          body = Jason.decode!(raw)
          Req.Test.json(conn, %{"received" => body})
        end)

      assert {:ok, %{"received" => %{"field" => "value"}}} =
               Client.patch(client, "/v1/resource/1", %{field: "value"})
    end
  end

  describe "delete/3" do
    test "returns {:ok, body} on success" do
      client =
        test_client(fn conn ->
          assert conn.method == "DELETE"
          Req.Test.json(conn, %{"deleted" => true})
        end)

      assert {:ok, %{"deleted" => true}} = Client.delete(client, "/v1/resource/1")
    end
  end

  describe "get_raw/3" do
    test "returns raw binary body" do
      client =
        test_client(fn conn ->
          assert conn.method == "GET"

          conn
          |> Plug.Conn.put_resp_content_type("image/jpeg")
          |> Plug.Conn.send_resp(200, <<0xFF, 0xD8, 0xFF>>)
        end)

      assert {:ok, <<0xFF, 0xD8, 0xFF>>} = Client.get_raw(client, "/v1/snapshot")
    end

    test "returns {:error, {status, body}} on failure" do
      client =
        test_client(fn conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(403, Jason.encode!(%{"error" => "forbidden"}))
        end)

      assert {:error, {403, _}} = Client.get_raw(client, "/v1/snapshot")
    end

    test "passes highQuality param" do
      client =
        test_client(fn conn ->
          params = Plug.Conn.fetch_query_params(conn).query_params
          Req.Test.json(conn, params)
        end)

      assert {:ok, %{"highQuality" => "true"}} =
               Client.get_raw(client, "/v1/snapshot", high_quality: true)
    end
  end
end
