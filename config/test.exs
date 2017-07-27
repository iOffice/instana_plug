use Mix.Config

config :instana_plug, 
  instana_client: InstanaPlug.TestClient,
  instana_url: "http://localhost:42699/com.instana.plugin.generic.trace"
