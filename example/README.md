# Dendritic Example

This example is **intentionally** minimal. It is not a complete, fully working system, nor does it prescribe an opinionated project layout — for those, explore any personal-infra repository linked from dendritic/README.md.

Instead, this sample shows what we mean by _"each file contributing to a cross-cutting concern across different Nix configuration classes"_ in the Dendritic pattern.

## The Dendritic Pattern

`flake.nix` is the entry point: it configures flake inputs and loads all `./modules` files.

The Dendritic pattern _enables_ every `./modules` Nix file to have the same semantic meaning: a **top-level module**.

In this example, which uses [`flake-parts`](https://flake.parts), each file is a [flake-parts module](https://flake.parts/options/flake-parts-modules.html).

A consequence of this is that you no longer have to guess what kind of expression each `.nix` file contains: they are _all_ Nix modules of the same Nix-configuration [`class`](https://nixos.org/manual/nixpkgs/stable/#module-system-lib-evalModules-param-class). In this example, that class is [`flake`](https://github.com/hercules-ci/flake-parts/blob/5635c32d666a59ec9a55cab87e898889869f7b71/lib.nix#L123).

The [groundbreaking discovery](https://github.com/mightyiam/infra/commit/b45e9e13759017fe18950ccc3b6deee2347e9175#diff-206b9ce276ab5971a2489d75eb1b12999d4bf3843b7988cbe8d687cfde61dea0) enabled by this pattern is that you can stop manually importing every Nix file in your repository; because all files are modules of the same class, you can import them from a single location.

The community [extracted](https://github.com/vic/import-tree/blob/222d527b8bf96271808a556b8141d1726f9806eb/default.nix) this "import all files" aspect into a [library](https://github.com/vic/import-tree/tree/222d527b8bf96271808a556b8141d1726f9806eb) that could be used by others to benefit from the same pattern.

You are still free to manually import Nix files if you want, but this pattern enables another often-overlooked benefit: a flexible, evolving file structure. Each top-level module is free to move, be organized into directories as related parts group, and be split when they grow large or complex. Refactoring becomes easy — the file and directory layout can follow your mental model of the project.

This layout flexibility and **module naming independence** [revealed](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/) that we are now organizing files by their meaning to the whole system — the features they provide — instead of by the kind of Nix expression each file contains or the hosts the configurations apply to.

This is what we mean by each module "configures a concern". Now you can think in terms of usability concerns, for example: "Is my configuration intended for geek power-users who avoid the mouse and prefer hundreds of Vim-style shortcuts?" or "Is it designed for people without technical expertise?".

The answers to these questions affect the naming, placement, and number of files/modules. The file structure becomes a _mind map_ of your usability decisions.


This example shows a module [`modules/shell.nix`](modules/shell.nix), that answers the question: "What is my default shell?" Whenever you want to check or change the default shell on any OS supported by this configuration, that file provides the answer.

Our example `shell.nix` contributes to the `shell` aspect across NixOS, Darwin, and Android. It's an example of the same concern (the user's default shell) being configured across different sub-module classes (`nixos`, `darwin`, `nixDroid`).

Anoter example is [`admin.nix`](modules/admin.nix) that configure the user with administrative privileges and and abstracts differences over `nixos` and `darwin` options.

You may have noticed that we haven't discussed instantiating `nixosConfigurations`, `homeManager`, `nix-darwin`, `nix-on-droid`, `terranix`, or any other specific Nix configuration domain. The Dendritic **pattern** is agnostic to _what_ you are configuring; it doesn't generate configurations for you as some frameworks do — it's focused on **how** you organize and structure your configuration.

Some people use `flake-parts` and `nixpkgs.lib.nixosSystem` to build [their] `nixosConfigurations` (see [modules/configurations.nix](modules/configurations.nix) for an example). Others use different libraries and frameworks inspired by the Dendritic pattern that support many users instead of a single-user setup like this example. See the [dendritic/README](https://github.com/mightyiam/dendritic) for more, or ask the community.