![logo](./logo.jpg)

# The Dendritic Pattern

A [Nix](https://nix.dev) [flake-parts](https://flake.parts) usage pattern in which _every_ Nix file is a flake-parts module

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

The dendritic pattern reconciles these factors using yet another application of the Nixpkgs module system: [flake-parts](https://flake.parts).
Especially its option [`flake.modules`](https://flake.parts/options/flake-parts-modules.html).

Each and every file:
- is a flake-parts module
- implements a single feature
- ...across all module classes it applies to
- is at a path that serves to name the feature

## Usage in the wild

- [Shahar "Dawn" Or (@mightyiam)](https://github.com/mightyiam/infra) ([adoption commit](https://github.com/mightyiam/infra/commit/b45e9e13759017fe18950ccc3b6deee2347e9175))
- [Victor Borja (@vic)](https://github.com/vic/vix) ([adoption pull request](https://github.com/vic/vix/pull/115))
- Pol Dellaiera ([blog post](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/))
- [Horizon Haskell](https://gitlab.horizon-haskell.net/nix/gitlab-ci)

## Anti patterns

Some aches the dendritic user is spared from:

- Threading the flake `self` once from the flake-parts evaluation through to NixOS evaluation and a second time deeper into Home Manager evaluation.
Instead, in this pattern, the flake-parts `config` can always be in scope when needed.
