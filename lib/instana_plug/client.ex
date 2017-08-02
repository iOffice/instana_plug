defmodule InstanaPlug.Client do
  defp instana_url do
    Application.get_env(:instana_plug, :instana_url)
  end

  def submit_span(span) do
    with {:ok, json} <- Poison.encode([span]),
         {:ok, response} <- HTTPoison.post(instana_url(), json, [{"Content-Type", "application/json"}]),
         do: {:ok, response}
  end
end
