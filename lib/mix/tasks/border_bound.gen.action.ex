defmodule Mix.Tasks.BorderBound.Gen.Action do
  @shortdoc "Generates an action"
  @moduledoc """
  #{@shortdoc}

  Generates a business logic "private" module and exposes it on the context

  ## Example

  ```bash
  mix border_bound.gen.action -n CreateDevice -c Inventory -s Devices
  ```

  ## Options

  * `--name` or `-n` - name for the action
  * `--context` or `-c` - context to put the action under
  """

  use Igniter.Mix.Task

  @example "mix border_bound.gen.action -n CreateDevice -c Inventory -s Devices"

  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      # Groups allow for overlapping arguments for tasks by the same author
      # See the generators guide for more.
      group: :border_bound,
      # dependencies to add
      adds_deps: [],
      # dependencies to add and call their associated installers, if they exist
      installs: [],
      # An example invocation
      example: @example,
      # a list of positional arguments, i.e `[:file]`
      positional: [],
      # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
      # This ensures your option schema includes options from nested tasks
      composes: [],
      # `OptionParser` schema
      schema: [
        name: :string,
        context: :string,
        subcontext: :string
      ],
      # Default values for the options in the `schema`.
      defaults: [],
      # CLI aliases
      aliases: [n: :name, c: :context, s: :subcontext],
      # A list of options in the schema that are required
      required: [:name, :context]
    }
  end

  def igniter(igniter, argv) do
    # extract options according to `schema` and `aliases` above
    options = options!(argv)

    context_module =
      [
        Igniter.Project.Module.module_name_prefix(igniter),
        options[:context]
      ]
      |> Enum.join(".")
      |> Igniter.Project.Module.parse()

    subcontext_prefix =
      [
        inspect(context_module),
        options[:subcontext]
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.join(".")
      |> Igniter.Project.Module.parse()

    module_name =
      [
        inspect(subcontext_prefix),
        "Actions",
        options[:name]
      ]
      |> Enum.join(".")
      |> Igniter.Project.Module.parse()

    path = Igniter.Project.Module.proper_location(igniter, module_name)

    action_name = Macro.underscore(options[:name])

    igniter
    |> Igniter.Project.Module.find_and_update_module!(BorderBound.Inventory, fn zipper ->
      delegate = """
      @behaviour #{inspect(module_name)}
      @impl #{inspect(module_name)}
      defdelegate #{action_name}(organization_id, opts), to: #{inspect(module_name)}
      """

      {:ok, Igniter.Code.Common.add_code(zipper, delegate)}
    end)
    |> Igniter.create_new_file(path, ~s<
    defmodule #{inspect(module_name)} do
      @moduledoc false

      @typep ok_t :: :ok
      @typep err_t :: {:error, Ecto.Changeset.t()}
      @type return_t :: ok_t() | err_t()

      @doc"""
      Does things

      Returns `:ok` when successful
      Otherwise returns an error containing the changeset:
      `{:error, %Ecto.Changeset{errors: [...]}}`
      """
      @callback #{action_name}(binary(), map(), keyword()) :: return_t()
      def #{action_name}(organization_id, params, opts) do
        raise "Not implemented... yet!"
      end
    end
    >)
  end
end
