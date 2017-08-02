defmodule InstanaPlug.Exit do
  alias Plug.Conn
  import InstanaPlug.Util

  @instana_client Application.get_env(:instana_plug, :instana_client, InstanaPlug.Client)

  def init(opts) do
    trace_name = Keyword.get(opts, :trace_name, "elixir-plug")
    continue_type = Keyword.get(opts, :continue_type, :respond)
    {trace_name, continue_type}
  end

  def call(conn, {trace_name, continue_type}) do
    case continue_type do
      :forward ->
        Conn.register_before_send(conn, &do_call(&1, trace_name, continue_type))
      _ ->
        do_call(conn, trace_name, continue_type)
    end
  end

  defp do_call(conn, trace_name, continue_type) do
    span_id = conn.assigns[:span_id]
    new_span_id = span_id + 1
    trace_id = conn.assigns[:trace_id]
    timestamp = System.system_time(:millisecond)
    duration = if conn.assigns[:entry_timestamp] do
      timestamp - conn.assigns[:entry_timestamp]
    else
      0
    end
    span_data = span(new_span_id, span_id, trace_id, timestamp, trace_name, "EXIT", duration)
    Task.async(fn -> @instana_client.submit_span(span_data) end)
    case continue_type do
      :respond ->
        conn
        |> Conn.put_resp_header("x-instana-s", hex_id(new_span_id))
        |> Conn.put_resp_header("x-instana-t", hex_id(trace_id))
      :forward ->
        conn
        |> Conn.put_req_header("x-instana-s", hex_id(new_span_id))
        |> Conn.put_req_header("x-instana-t", hex_id(trace_id))
      :continue ->
        conn
        |> Conn.assign(:span_id, new_span_id)
        |> Conn.assign(:trace_id, trace_id)
    end
  end
end
