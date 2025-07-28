+++
date = 2025-07-28
title = "MacOS Non-Breaking Character"
description = "A thing that bothered me for a way to long time"

[taxonomies]
tags = [ "macos", "typing" ]
+++

Since using MacOS, I was annoyed by the fact that typing a non-breaking space (NBSP) is way too easy.
Nearly every time I wanted to type a space after a pipe `|` (`opt+7` on MacOS), I accidentally typed a NBSP, as `opt+space` is the shortcut for it.
This resulted in the piped command not being executed, as the NBSP is not recognized as a space, but as first character of the next command.

```sh
cat example.json | jq . | less
```

Running the above command would result in an error, as ` jq` is not recognized as a command because of the leading NBSP.
Instead I always had to type `cat example.json |jq . |less`, which is not only annoying, but also less readable if the oneliners become longer.

To fix this, I updated my `~/Library/KeyBindings/DefaultKeyBinding.dict` file with the following content:

```text
{
"~ " = ("insertText:", " ");
}
```
([Source](https://superuser.com/a/142573))

And after a restart (*Noooo, my precious uptime!*) the NBSP is gone and I can type spaces after pipes again.
What a hassle!
