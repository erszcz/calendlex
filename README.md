# Calendlex

This repo follows the [_Building a simple Calendly clone with Phoenix LiveView_][tutorial],
but with Phoenix 1.7.11, which is a little bit more recent than the original tutorial.
This means some bits and bobs have to be adjusted here and there:

  - [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html)
    are now used instead of autogenerated route helpers,
  - [Tailwind CSS](https://tailwindcss.com/) is now included out of the
    box with Phoenix.

[tutorial]: https://bigardone.dev/blog/2021/11/06/building-a-simple-calendly-clone-with-phoenix-live-view-pt-1

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
