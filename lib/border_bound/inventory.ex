defmodule BorderBound.Inventory do
  @moduledoc """
  Context for inventory
  """

  use Boundary,
    deps: [],
    exports: [
      {Schemas, except: []}
    ]
end
