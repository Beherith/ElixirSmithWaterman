defmodule SmithWaterman.MixProject do
  use Mix.Project

  @source_url "https://github.com/Beherith/ElixirSmithWaterman"
  @version "0.0.1"

  def project do
    [
      app: :smith_waterman,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        bench: :test,
        "test.ci": :test,
        "test.reset": :test,
        "test.setup": :test
      ],

      # Hex
      description: "Hex PM description goes here",
      package: package(),

      # Docs
      name: "Smith Watermann",
      docs: [
        main: "Smith Watermann",
        api_reference: false,
        source_ref: "v#{@version}",
        source_url: @source_url,
        formatters: ["html"],
        skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def description do
    """
    Weng-Lin Bayesian approximation method for online skill-ranking.

    Orders of magnitude faster over Microsoft TrueSkill, with better prediction, and commercial usage does not require a license.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.13", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Peter Sarkozy", "Teifion Jordan"],
      licenses: ["Apache-2.0"],
      files: ~w(lib .formatter.exs mix.exs README* CHANGELOG* LICENSE*),
      links: %{
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md",
        "GitHub" => @source_url
      }
    ]
  end

  defp aliases do
    [
      benchmark: [
        "run benchmark/benchmark.exs"
      ],
      release: [
        "cmd git tag v#{@version}",
        "cmd git push",
        "cmd git push --tags",
        "hex.publish --yes"
      ],
      "test.ci": [
        "format --check-formatted",
        "deps.unlock --check-unused",
        # "credo --strict",
        "test --raise"
      ]
    ]
  end
end
