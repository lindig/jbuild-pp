
# jbuild-pp

This is a minimal filter for formatting [jbuilder] files in sexpr
syntax. [jbuilder] is a build tool for [OCaml] projects. Many editors
already provide formatting support for s-expressions but I wanted
something that I can tweak and that installs into a simple binary.

```sh
jbuild-pp < jbuild
```

## Building With Opam

```sh
opam pin add .
```

## Depencencies

See [jbuild-pp.opam](./jbuild-pp.opam).

[jbuilder]: https://github.com/janestreet/jbuilder
[OCaml]:		http://www.ocaml.org/

