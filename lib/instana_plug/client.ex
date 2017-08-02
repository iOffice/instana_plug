defmodule InstanaPlug.Client do
  @instana_url Application.get_env(:instana_plug, :instana_url)

  def submit_span(span) do
    with {:ok, json} <- Poison.encode(span),
         IO.puts(json),
         {:ok, response} <- HTTPoison.post(@instana_url, json, [{"Content-Type", "application/json"}]),
         {:ok, json_body} <- Poison.decode(response.body),
         do: {:ok, Map.put(response, :body, json_body)}
  end
end
