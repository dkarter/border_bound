defmodule BorderBound.Inventory do
  use Boundary,
    deps: [],
    exports: [
      {Schemas, except: []}
    ]
end
