# The Whiteout Pattern ⬜

A [Nix](https://nix.dev) [flake-parts](https://flake.parts) usage pattern in which _every_ Nix file is a flake-parts module

## Testimonials

> I adore this idea by @mightyiam of every file is a flake parts module and I think I will adopt it everywhere.

—Daniel Firth ([source](https://x.com/locallycompact/status/1909188620038046038))

> Massive, very interesting!

—Pol Dellaiera ([source](https://discourse.nixos.org/t/pattern-every-file-is-a-flake-parts-module/61271/2?u=mightyiam))

> I’ve adopted your method. Really preferring it.

—gerred ([source](https://x.com/devgerred/status/1909206297532117469))

## Description

File paths convey what the contents mean to me, as opposed to adhering to a mechanism's design.
Because each file, being a flake-parts module, can declare any number of nested modules (e.g. NixOS, Home Manager, NixVim).
Thus, a single file can implement cross-cutting concerns.

I have previously threaded `self` once from the flake-parts evaluation through to NixOS evaluation and a second time deeper into Home Manager evaluation.
Instead, in this pattern, the flake-parts `config` can always be in scope when needed.

## Usage in the wild

- [Shahar "Dawn" Or (@mightyiam)](https://github.com/mightyiam/infra) ([adoption commit](https://github.com/mightyiam/infra/commit/b45e9e13759017fe18950ccc3b6deee2347e9175))
- [Victor Borja (@vic)](https://github.com/vic/vix) ([adoption pull request](https://github.com/vic/vix/pull/115))
- [Pol Dellaiera](https://github.com/drupol/nixos-x260) ([adoption pull request](https://github.com/drupol/nixos-x260/pull/83)) ([blog post](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/))
