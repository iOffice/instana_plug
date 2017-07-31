use Mix.Config

Code.load_file("test/instana_plug/test_client.ex")

config :instana_plug, 
  instana_client: InstanaPlug.TestClient,
  instana_url: "http://localhost:42699/com.instana.plugin.generic.trace"
