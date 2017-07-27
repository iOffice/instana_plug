defmodule UtilTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import InstanaPlug.Util

  describe "get_hex_header" do
    test "returns random if header isn't there" do
      result = :get |> conn("localhost") |> get_hex_header("x-test")
      assert result != nil
    end

    test "correctly parsed hex id from header" do
      result = :get |> conn("localhost") |> put_req_header("x-test", "abcd") |> get_hex_header("x-test")
      assert result == 43981
    end
  end
end
