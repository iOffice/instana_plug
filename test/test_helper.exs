ExUnit.start()

defmodule InstanaPlug.TestClient do
  def submit_span(span) do
    Process.register(self(), InstanaPlug.TestClient)
    receive do
      {:gimme, sender} -> send(sender, span)
    end
    %{body: %{}}
  end
end
