![logo](./logo.jpg)

# The Dendritic Pattern

A [Nixpkgs module system](https://nix.dev/tutorials/module-system/) usage pattern
in which _every_ Nix file is a *top-level module*

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

## The pattern

The dendritic pattern reconciles these factors using yet another application of the Nixpkgs module system—a *top-level configuration*.
Commonly, this top-level configuration is a [flake-parts](https://flake.parts) one.

Each and every file, in addition to being a top-level module:
- implements a single feature
- ...across all module classes it applies to
- is at a path that serves to name the feature

The pattern typically involves pervasive use of *deferred modules*,
leveraging the module system's built-in type `deferredModule`,
to store modules as values with merge semantics.
A diferred module takes part in the evaluation of any number of configurations of its own class.
In flake-parts, this is commonly achieved via the [`flake.modules` option](https://flake.parts/options/flake-parts-modules.html).

Further documetation of the pattern can be found in [the `vic/dendrix/dendritic` article](https://vic.github.io/dendrix/Dendritic.html).

## Required skills

- [Nix language](https://nix.dev/tutorials/nix-language)
- [Nixpkgs module system](https://nix.dev/tutorials/module-system/)
- [The `deferredModule` type](https://nixos.org/manual/nixos/stable/#sec-option-types-submodule)

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

In a non-dendritic pattern some Nix files may be modules that are lower-level
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
every file is a top-level module and can therefore add values to the top-level `config`.
In turn, every file can also read from the top-level `config`.
This makes the sharing of values between files seem trivial in comparison.
