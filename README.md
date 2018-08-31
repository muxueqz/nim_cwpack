# nim_cwpack
Nim_cwpack is a [Nim](https://nim-lang.org/) wrapper for the [CWPack](https://github.com/clwi/CWPack) library

CWPack is a lightweight and yet complete implementation of the MessagePack serialization format version 5.

Nim_cwpack is distributed as a [Nimble](https://github.com/nim-lang/nimble) package and depends on [nimgen](https://github.com/genotrance/nimgen) and [c2nim](https://github.com/nim-lang/c2nim/) to generate the wrappers. The rax source code is downloaded using git.

__Installation__

Nim_cwpack can be installed via [Nimble](https://github.com/nim-lang/nimble):

```
> nimble install nimgen

> git clone https://github.com/muxueqz/Nim_cwpack
> cd nim_cwpack
> nimble install -y
```

This will download, wrap and install nim_cwpack in the standard Nimble package location, typically ~/.nimble. Once installed, it can be imported into any Nim program.
