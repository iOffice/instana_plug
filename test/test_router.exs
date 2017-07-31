defmodule TestRouter do
  use Plug.Router

  plug InstanaPlug.Entry
  plug InstanaPlug.Exit
  plug :match
  plug :dispatch

  get "/test" do
    send_resp(conn, 200, "worked")
  end

  match _ do
    send_resp(conn, 404, "")
  end
end
