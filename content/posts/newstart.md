+++
title = "Switching to MacOS for now"
description = "How to setup MacOS while staying productive"
date = 2024-12-30

[taxonomies]
tags = [ "tech", "macos", "nix" ]
+++

A while ago the display of my ThinkPad T490 started to flicker.
It seemed to stopped after a short while, but twice it even persisted for more than 30 minutes.
While working docked I didn't notice it, but while giving lectures or working during a train ride this sucked.
It distracted me really hard, and I fear that it will break sooner or later.
And because this device is from 2019 and the processing unit is even older I decided it is time for a new device.

On my NixOS T490 I knew, I will not get through a whole 8-hour workday without ending up with a plastic brick at the end of a day.
Even with low backlight settings, while [`nvim`ing](https://neovim.io/) (with a pretty light [config](https://github.com/randomn4me/nix-flakes/blob/main/modules/home-manager/nvim/default.nix)) on LaTeX or markdown with some LSP actions, Firefox, and light background services[^1].
And once in a while I need to do some heavy lifting by compiling code, playing with LLMs, but then I am usually near a power outlet.
There might be another efficiency tweaks in NixOS, but I don't want to spend an uncertain amount of hours to find the right knob and maybe get 30 minutes.
Thanks to a colleague I came around this nice graphic from xkcd.

[![This is a chart titled "How long can you work on making a routine task more efficient before you're spending more time than you save? (across five years)." The chart uses a grid format, with rows representing how much time you shave off a task (ranging from 1 second to 1 day), and columns representing how often the task is performed (from 50 times per day to yearly). Each cell indicates the maximum time you can spend optimizing the task without exceeding the time saved over five years. For example, if you perform a task daily and save 1 minute, you can spend up to 6 days optimizing it. The chart is designed to help prioritize efforts in optimizing repetitive tasks.](/img/is_it_worth_the_time.png "Be aware of timesinks")](https://xkcd.com/1205/)

Don't get me wrong!
I love tweaking my systems.
Just today I revived my system config, [most prominently my nvim config](https://github.com/randomn4me/dotfiles/tree/master/nvim/.config/nvim) and added new plugins I discovered while working with NixOS and installed all the necessary terminal tools.
But scouring the documentation just to realize my system is running 30 minutes longer than before is not worth the time.

Another colleague of mine spoke of his on-battery times with his MacBook, which exceed usually two full days, and this got me hooked.
It sounded insane for me, to get more than a day out of my laptop, which surpasses even my phone.
Not only does this allow you to go on tour without a charger and and the next power outlet in the back of my mind, but it actually consumes less energy and is much more efficient and environmental friendly[^2].
I didn't use a MacBook since 2013, and I guess, a lot have changed (not just the OS, but also my usage).

So now, here I am with a M4 MacBook Pro in front of me, charge it once in two or three days and just let it sleep while it is not used.
It needs some more tweaking to really make it *mine* by setting up my `isync` and `neomutt` as I noticed Mail and I will not be friends in the near future but besides that, it seems really nice.
It just works the way I expect it to work.
I also looked into using [Nix-Darwin](https://daiderd.com/nix-darwin/), but for now, I want to maintain a mainly stock experience and just do small adjustments here and there.



[^1]: I ran [`isync`](https://isync.sourceforge.io/) for my [`neomutt`](https://neomutt.org/guide/gettingstarted.html) mail setup, regular backups with [`borgmatic`](https://torsion.org/borgmatic/), and a Python session in [`tmux`](https://github.com/tmux/tmux/wiki).
[^2]: Newer x86 AMD or Intel processors do claim similar runtimes, but I'm not sure, if this is the case when running Linux. And I know of the [Rebound effect](https://en.wikipedia.org/wiki/Rebound_effect_(conservation))
