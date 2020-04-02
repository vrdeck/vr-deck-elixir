# Deck

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`https://localhost.vrdeck.live`](https://localhost.vrdeck.live) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Production

### Google Cloud Storage credentials

First get credentials from https://console.cloud.google.com/apis/credentials/serviceaccountkey

Then put them into Heroku with:

```bash
heroku config:set GOOGLE_APPLICATION_CREDENTIALS="$(< credentials.json)"
```
