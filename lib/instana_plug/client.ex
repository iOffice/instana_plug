defmodule InstanaPlug.Client do
  @instana_url Application.get_env(:instana_plug, :instana_url)

  def submit_span(span) do
    with {:ok, json} <- Poison.encode([span]),
         {:ok, response} <- HTTPoison.post(@instana_url, json, [{"Content-Type", "application/json"}]),
         do: {:ok, response}
  end
end
