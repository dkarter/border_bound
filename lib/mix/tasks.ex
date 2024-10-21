defmodule Mix.Tasks do
  @moduledoc false

  # we shouldn't care about boundaries for tasks because they are not
  # technically part of our app, just dev tools
  use Boundary, check: [in: false, out: false]
end
