defmodule InstanaPlug.Util do
  alias Plug.Conn

  @instana_long_max 9223372036854775807

  def get_hex_header(conn, header) do
    case Conn.get_req_header(conn, header) do
      [] -> :rand.uniform(@instana_long_max * 2) - @instana_long_max
      [headerHex | _] -> String.to_integer(headerHex, 16)
    end
  end

  def span(span_id, parent_id, trace_id, timestamp, name, type) do
    # span_id_hex = Integer.to_string(span_id, 16)
    # parent_id_hex = Integer.to_string(parent_id, 16)
    # trace_id_hex = Integer.to_string(trace_id, 16)
    %{
      "spanId" => span_id,
      "parentId" => parent_id,
      "traceId" => trace_id,
      "timestamp": timestamp,
      "name": name,
      "type": type
    }
  end
end