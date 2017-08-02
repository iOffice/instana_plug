defmodule InstanaPlug.Entry do
  alias Plug.Conn
  import InstanaPlug.Util

  defp instana_client do
    Application.get_env(:instana_plug, :instana_client, InstanaPlug.Client)
  end

  def init(opts) do
    Keyword.get(opts, :trace_name, "elixir-plug")
  end

  def call(conn, trace_name) do
    span_id = get_hex_header(conn, "x-instana-s")
    new_span_id = span_id + 1
    trace_id = get_hex_header(conn, "x-instana-t")
    timestamp = System.system_time(:millisecond)
    span_data = span(new_span_id, span_id, trace_id, timestamp, trace_name, "ENTRY")
    Task.async(fn -> instana_client().submit_span(span_data) end)
    conn
    |> Conn.assign(:span_id, new_span_id)
    |> Conn.assign(:trace_id, trace_id)
    |> Conn.assign(:entry_timestamp, timestamp)
  end
end
