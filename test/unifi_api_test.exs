defmodule UnifiApiTest do
  use ExUnit.Case, async: true

  test "new/0 returns a Req.Request struct" do
    client = UnifiApi.new()
    assert %Req.Request{} = client
  end

  test "new/1 accepts custom options" do
    client = UnifiApi.new(base_url: "https://10.0.0.1", api_key: "test-key")
    assert %Req.Request{} = client
  end
end
