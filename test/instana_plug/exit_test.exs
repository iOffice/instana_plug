defmodule ExitTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "call" do
    test "should respond with correct hex headers by default" do
      conn = 
        :get
        |> conn("localhost")
        |> assign(:span_id, 10)
        |> assign(:trace_id, 9)
        |> InstanaPlug.Exit.call(InstanaPlug.Exit.init([]))
      assert ["B"] == get_resp_header(conn, "x-instana-s")
      assert ["9"] == get_resp_header(conn, "x-instana-t")
    end

    test "should put request headers if using forward type" do
      conn = 
        :get
        |> conn("localhost")
        |> assign(:span_id, 11)
        |> assign(:trace_id, 10)
        |> InstanaPlug.Exit.call(InstanaPlug.Exit.init(continue_type: :forward))
      assert ["C"] == get_req_header(conn, "x-instana-s")
      assert ["A"] == get_req_header(conn, "x-instana-t")
    end

    test "should assign ids if using continue type" do
      conn = 
        :get
        |> conn("localhost")
        |> assign(:span_id, 12)
        |> assign(:trace_id, 11)
        |> InstanaPlug.Exit.call(InstanaPlug.Exit.init(continue_type: :continue))
      assert 13 == conn.assigns[:span_id]
      assert 11 == conn.assigns[:trace_id]
    end
  end
end
