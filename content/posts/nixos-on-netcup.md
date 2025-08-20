+++
date = 2025-08-20
title = "NixOS on Netcup"
description = "I just moved my NixOS server to Netcup."

[taxonomies]
tags = [ "sysadmin", "nixos", ]
+++

NetCup is a German hosting provider, which offers affordable virtual private servers (VPS) and dedicated servers.
It offers way more storage than other providers, like Hetzner, which I used before (and still have a server for now).
This increased storage capacity allows me to run other services, and not having to worry about running out of space (which I did with Hetzner and a [wrong configuration for the Home Manager Garbage Collection](/posts/wrong-homemanager-garbage-collection)).

## Installing NixOS on Netcup

The installation on Netcup is straightforward:
1. Wait for a [deal on NetCup](https://www.netcup.com/en/deals) you are interested in and order it.
2. Log in to the Netcup server control panel and open the server management page.
3. Download the current NixOS ISO image from the [NixOS download page](https://nixos.org/download.html).
4. Go to "Media", "DVD Drive", upload the NixOS ISO image at Custom ISOs.
5. Restart the server.

Now you can open the Screen Console in the Netcup server management page and proceed with the NixOS installation instructions.
I went with setting up the keymap via `loadkeys de-latin1`, setting the password, connecting via `ssh` (because I hate the web console), partitioning the disk using [disko](https://github.com/nix-community/disko/) with `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko [disko-config]`, generating the NixOS configuration using `sudo nixos-generate-config --root /mnt`, configuring a basic NixOS configuration which includes a user with authenticated ssh key, and installing NixOS using `sudo nixos-install --root /mnt`.
While I use a flake for my NixOS configuration, it did not work for the NixOS installation, as I was not able to log into the system when installing it like this: `sudo nixos-install --root /mnt --flake .#netcup`, but I am going to investigate this further, as it worked on a desktop like a charm.

## Post-Installation

After the installation, I checked if all was working, adjusted my flake to include the new server, and rebuild the system using `nixos-rebuild switch --flake .#netcup`, which included all my configurations, like the Home Manager configuration and services like [taskserver](https://taskwarrior.org/).

