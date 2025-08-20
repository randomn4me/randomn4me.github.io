+++
date = 2024-09-16
title = "Home Manager Garbage Collection gone wrong"
description = "A simple mistake in my NixOS configuration led to a full disk."

[taxonomies]
tags = [ "sysadmin", "nixos", "home-manager", ]
+++

I recently ran into a problem with my NixOS server.
As a proud and convinced NixOS user, I use all the fancy features, like [Home Manager](https://nix-community.github.io/home-manager/) to manage my user configuration.
Unfortunately, I made a mistake in my configuration, which led to a full disk and the inability to update my system any longer.

## The Problem

The NixOS garbage collection is configured to run every day and to just keep the last 14 days of generations.
It worked well, but still the storage was still filling up.
I suspected some services like Mastodon, which I ran at that time, to be the culprit with all the media files and the database.

However, after a short investigation, I found out that the root cause was actually the `/nix/store` directory.
As I use flakes to manage my NixOS configuration, I checked on my laptop as well, and noticed a similar problem with nearly 300 GB of `/nix/store` usage and 295 GB in `/nix/store/.links` 🤯
While this might not be uncommon when installing a lot of packages with a lot of different versions, it still seemed a bit too much for me, as I try to keep my systems as clean as possible.

I checked in with my local [NixOS community](https://www.chaos-darmstadt.de/2023/erstes-nixos-meetup/) (esp. [Atemu](https://darmstadt.social/@atemu)) and they pointed me to the Home Manager garbage collection as this needs to be configured separately from the NixOS garbage collection.
After a `nix-env --list-generations` it confirmed, that I had just 7 NixOS generations on my system.
But a short 
```
nix-store --gc --print-roots | grep -vE "^(/nix/var|/run/\w+-system|\{memory|\{censored|/proc/maps/)"
```
showed a shitload of generations, which I did not expected.

## The Solution

After some hints, I found out that I had not configured the Home Manager garbage collection.
I setup a quick home-manager module, which mirrors my NixOS settings, so that it runs in sync with the NixOS garbage collection and defaults to `true`!

```nix
{
  lib,
  config,
  osConfig,
  ...
}:

with lib;

let
  cfg = config.custom.gc;
in
{
  options.custom.gc.enable = mkOption {
    description = "Enable home-manager-gc based on nixos gc";
    type = types.bool;
    default = true;
  };

  config = mkIf cfg.enable {
    nix.gc = {
      automatic = osConfig.nix.gc.automatic;
      options = osConfig.nix.gc.options;
    };
  };
}
```

After applying this configuration and `nix-collect-garbage --delete-older-than 14d`, I was rewarded with the following output:

```
deleting unused links...
note: currently hard linking saves 29539.49 MiB
476109 store paths deleted, 201139.22 MiB freed
```

I also ran that on my server, and it cleared up some critical space as well.

With the new Home Manager module in place, and in the fashion of NixOS, I will never run into this problem again 🥳
Thanks again to the NixOS community for the help and support!
