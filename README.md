This is a flake for **installing** [`lde`](https://github.com/lde-org/lde) from its Github releases, not for building it. It can be consumed in your flake as follows:
```nix
{
  # Latest release
  inputs.lde.url = "github:lde-org/lde-nix";
  # Pinned version, here for instance v0.11.1
  inputs.lde.url = "github:lde-org/lde-nix?ref=refs/tags/v0.11.1";
  # Nightly build, refreshed daily from the upstream `nightly` prerelease
  inputs.lde.url = "github:lde-org/lde-nix/nightly";
}
```
Then, add `lde.packages.${your-system}.default` wherever you install packages (assuming you added `lde` as an argument to your flake output), `your-system` being the architecture you run on.
