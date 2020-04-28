defmodule DeckWeb.UserSocket do
  use Phoenix.Socket

  alias Deck.Chat.User

  @type socket :: Phoenix.Socket.t()

  ## Channels
  channel "room:*", DeckWeb.RoomChannel

  @spec connect(map, socket) :: {:ok, socket}
  def connect(%{"token" => token}, socket) do
    case User.verify_token(socket, token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Socket id's are topics that allow you to identify all sockets for a given user:
  """
  @spec id(socket) :: String.t()
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
