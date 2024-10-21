defmodule TestKit do
  @moduledoc false
  use Boundary,
    check: [in: true, out: false],
    exports: [
      ConnCase,
      DataCase
    ]
end
