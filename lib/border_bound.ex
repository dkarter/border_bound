defmodule BorderBound do
  @moduledoc """
  BorderBound keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Boundary,
    deps: [
      Ecto,
      # TODO: is this needed?
      Ecto.Changeset
    ],
    exports: [
      # mass exposes everything that Inventory exposes
      {Inventory, []}
    ]
end
