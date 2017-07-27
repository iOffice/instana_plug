defmodule EntryTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "call" do
    test "should assign id values from header" do
      result = 
        :get 
        |> conn("localhost") 
        |> put_req_header("x-instana-s", "A") 
        |> put_req_header("x-instana-t", "C")
        |> InstanaPlug.Entry.call("elixir-plug")
      assert result.assigns[:span_id] == 11
      assert result.assigns[:trace_id] == 12
    end

    test "should handle missing headers" do
      result = 
        :get 
        |> conn("localhost") 
        |> InstanaPlug.Entry.call("elixir-plug")
      assert result.assigns[:span_id] != nil
      assert result.assigns[:trace_id] != nil
    end

    test "should send a span with the type ENTRY" do
      result = 
        :get 
        |> conn("localhost") 
        |> put_req_header("x-instana-s", "A") 
        |> put_req_header("x-instana-t", "C")
        |> InstanaPlug.Entry.call("elixir-plug")
      Process.send_after(InstanaPlug.TestClient, {:gimme, self()}, 0)
      assert_receive %{:type => "ENTRY"}
    end
  end
end
