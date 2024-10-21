defmodule BorderBound.Repo do
  use Ecto.Repo,
    otp_app: :border_bound,
    adapter: Ecto.Adapters.Postgres
end
