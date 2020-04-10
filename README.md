# VR Deck Elixir

VR Deck is a tool for presenting and viewing short talks in virtual reality.

This is an Elixir backend for saving talks.

## Development

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`https://localhost.vrdeck.live`](https://localhost.vrdeck.live) from your browser.

## Production

This app is auto-deploying on [Heroku](https://dashboard.heroku.com/) on every push to `master`.

### Google Cloud Storage credentials

First get credentials from https://console.cloud.google.com/apis/credentials/serviceaccountkey

Then put them into Heroku with:

```bash
heroku config:set GOOGLE_APPLICATION_CREDENTIALS="$(< credentials.json)"
```
