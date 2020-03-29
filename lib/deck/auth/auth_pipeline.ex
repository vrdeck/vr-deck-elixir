defmodule Deck.Auth.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :deck,
    module: Deck.Auth.Guardian,
    error_handler: Deck.Auth.ErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true
end
