![logo](./logo.jpg)

# The Dendritic Pattern

A [Nix](https://nix.dev) [module-system](https://nix.dev/tutorials/module-system/deep-dive.html) usage pattern in which _every_ Nix file is a [deferred-module](https://nixos.org/manual/nixos/stable/#sec-option-types-submodule)

## Testimonials

> I adore this idea by @mightyiam of every file is a flake parts module and I think I will adopt it everywhere.

—Daniel Firth ([source](https://x.com/locallycompact/status/1909188620038046038))

> Massive, very interesting!

—Pol Dellaiera ([source](https://discourse.nixos.org/t/pattern-every-file-is-a-flake-parts-module/61271/2?u=mightyiam))

> I’ve adopted your method. Really preferring it.

—gerred ([source](https://x.com/devgerred/status/1909206297532117469))

## Background

[NixOS](https://nixos.org/manual/nixos/unstable/),
[home-manager](https://github.com/nix-community/home-manager) and
[nix-darwin](https://github.com/nix-darwin/nix-darwin)
are popular projects that allow the user to produce [derivations](https://nix.dev/tutorials/nix-language.html#derivations)
that can be customized by evaluating a [Nixpkgs module system](https://nix.dev/tutorials/module-system/) configuration.

Figuring out a practical and expressive architecture for a codebase that provides configurations had proven to cost many a Nix user protracted periods and multiple refactorings.

Factors contributing to the complexity of such an architecture:

- Multiple configurations
- Sharing of some modules across some configurations
- Multiple configuration classes (NixOS & home-manager)
- Configuration nesting such as home-manager [within NixOS](https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module) or [within nix-darwin](https://nix-community.github.io/home-manager/index.xhtml#sec-install-nix-darwin-module)
- Existence of concerns that span multiple configuration classes ("cross-cutting concerns")
- Accessing values such as functions, constants and packages across files

## The Pattern

The dendritic pattern is fundamentally about **deferred modules**—modules that can be instantiated multiple times with different configurations. This leverages the Nixpkgs module system's ability to delay module evaluation until all configuration is available.

### Core Concept: Deferred Modules

A deferred module is a function that returns a module. Instead of being evaluated immediately, it waits to be instantiated with specific configuration. This allows the same module definition to be reused across different contexts (NixOS, home-manager, nix-darwin) while maintaining type safety and proper option merging.

Key properties:
- Each file is a **deferred module** (A module evaluated later)
- Implements a single feature across all module classes it applies to
- Path serves as the feature name
- Can be instantiated multiple times with different configurations

### Example application of the pattern

The dendritic pattern reconciles these factors using yet another application of the Nixpkgs module system: [flake-parts](https://flake.parts).
Especially its option [`flake.modules`](https://flake.parts/options/flake-parts-modules.html). (`type = lazyAttrsOf (lazyAttrsOf deferredModule)`)

Each and every file:
- is a flake-parts module
- implements a single feature
- ...across all module classes it applies to
- is at a path that serves to name the feature

### Important Notes

⚠️ **Understanding deferred modules is essential before adopting this pattern.** Flake-parts is not required — it simply offers more ergonomic integration with flakes. You can implement the dendritic pattern using plain `lib.evalModules` with deferred modules.

⚠️ **This is not about flake-parts specifically.** The pattern is about architectural principles using deferred modules.

Resources for understanding deferred modules:
- [NixOS Manual: Submodule type](https://nixos.org/manual/nixos/stable/#sec-option-types-submodule)
- [Nix module system deep dive](https://nix.dev/tutorials/module-system/deep-dive.html)

[The `vic/dendrix/dendritic` article](https://vic.github.io/dendrix/Dendritic.html) explains it further.

## Usage in the wild

- [Shahar "Dawn" Or (@mightyiam)](https://github.com/mightyiam/infra) ([adoption commit](https://github.com/mightyiam/infra/commit/b45e9e13759017fe18950ccc3b6deee2347e9175))
- [Victor Borja (@vic)](https://github.com/vic/vix) ([adoption pull request](https://github.com/vic/vix/pull/115)) ([forum answer](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851/8))
- [Pol Dellaiera](https://github.com/drupol/nixos-x260) ([adoption pull request](https://github.com/drupol/nixos-x260/pull/83)) ([blog post](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/))
- [Horizon Haskell](https://gitlab.horizon-haskell.net/nix/gitlab-ci)
- [Gaétan Lepage](https://github.com/GaetanLepage/nix-config) ([acknowledgment commit](https://github.com/GaetanLepage/nix-config/commit/3ed89eae1a8e13c1910eac5f89f2cdb4f48756ff))
- [bivsk](https://github.com/bivsk/nix-iv) ([adoption pull request](https://github.com/bivsk/nix-iv/pull/2))

## Community

- [GitHub Discussions](https://github.com/mightyiam/dendritic/discussions)

- [Matrix room: `#dendritic:matrix.org`](https://matrix.to/#/#dendritic:matrix.org)

## Anti patterns

### `specialArgs` pass-thru

In a non-dendritic pattern some Nix files may be modules that are other than flake-parts
(such as NixOS or home-manager).
Often they require access to values that are defined outside of their config evaluation.
Those values are often passed through to such evaluations
via the `specialArgs` argument of `lib.evalModules` wrappers like `lib.nixosSystem`.

For example, `scripts/foo.nix` defines a script called `script-foo`
which is then included in `environment.systemPackages` in `nixos/laptop.nix`.
`script-foo` is made available in `nixos/laptop.nix` by injecting it
(or a superset of it, such as the flake `self` may be) via `specialArgs`.
This might occur even once deeper from the NixOS evaluation into a nested home-manager evaluation
(this time via `extraSpecialArgs`).

In the dendritic pattern
every file is a deferred module and can therefore participate in the module system evaluation.
This allows files to add values to and read from the shared configuration scope,
making the sharing of values between files trivial in comparison.
