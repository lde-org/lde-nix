This is a flake for **installing** [`lde`](https://github.com/lde-org/lde) from its Github releases, not for building it. It can be consumed in your flake as follows:
```nix
{
  # Latest release
  inputs.lde.url = "github:lde-org/lde-nix";
  # Pinned version, here for instance v0.8.1
  inputs.lde.url = "github:lde-org/lde-nix?ref=refs/tags/v0.8.1";
  # Nightly build, may not work depending on the maintainer's reactivity
  inputs.lde.url = "github:lde-org/lde-nix/nightly";
}
```
Then, add `lde.packages.${builtins.currentSystem}.default` wherever you install packages (assuming you added `lde` as an argument to your flake output).
