defmodule ClientTest do
  use ExUnit.Case, async: true
  import InstanaPlug.Util
  import InstanaPlug.Client

  # mix test --include integration
  @moduletag :integration

  describe "submit_span" do
    test "actually sends http request" do
      span = span(2, 1, 0, 0, "fake", "FAKE")
      {:ok, response} = submit_span(span)
      result = 
        response 
        |> Map.get(:body) 
        |> Poison.decode! 
        |> Map.get("json")
      assert result == [span]
    end
  end
end
