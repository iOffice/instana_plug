use Mix.Config

config :instana_plug, 
  instana_client: InstanaPlug.Client,
  instana_url: "http://172.17.0.1:42699/com.instana.plugin.generic.trace"
