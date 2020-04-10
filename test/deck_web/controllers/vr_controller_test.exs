defmodule DeckWeb.VrControllerTest do
  use DeckWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ ~s(<div id="app"></div>))
  end
end
