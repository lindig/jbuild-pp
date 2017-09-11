
# jbuild-pp

This is a minimal filter for formatting [jbuilder] files in sexpr
syntax. [jbuilder] is a build tool for [OCaml] projects. Many editors
already provide formatting support for s-expressions but I wanted
something that I can tweak and that installs into a simple binary.

## Example

```
$ jbuild-pp jbuild

(jbuild_version 1)

(executables
 ((names
   (run))
  (libraries
   (unix))))

(alias
 ((name runtest)
  (deps
   ((files_recursively_in workspaces/redirections)))
  (action
   (chdir workspaces/redirections
    (run ${exe:run.exe} -- ${bin:jbuilder} runtest -j1 --root .)))))

(alias
 ((name runtest)
  (deps
   ((files_recursively_in workspaces/misc)))
  (action
   (chdir workspaces/misc
    (run ${exe:run.exe} -- ${bin:jbuilder} runtest -j1 --root .)))))

(alias
 ((name runtest)
  (deps
   ((files_recursively_in workspaces/github20)))
  (action
   (chdir workspaces/github20
    (run ${exe:run.exe} -- ${bin:jbuilder} build -j1 .merlin --root .)))))

(alias
 ((name runtest-js)
  (deps
   ((files_recursively_in workspaces/js_of_ocaml)))
  (action
   (chdir workspaces/js_of_ocaml
    (progn
     (run ${exe:run.exe} -log log.build1 -- ${bin:jbuilder} build --verbose
      -j1 --root . --dev bin/technologic.bc.js @install lib/x.cma.js
      lib/x__Y.cmo.js bin/z.cmo.js)
     (run ${exe:run.exe} -log log.run1 -- ${bin:node}
      ./_build/default/bin/technologic.bc.js)
     (run ${exe:run.exe} -log log.build2 -- ${bin:jbuilder} build --verbose
      -j1 --root . bin/technologic.bc.js @install)
     (run ${exe:run.exe} -log log.run2 -- ${bin:node}
      ./_build/default/bin/technologic.bc.js))))))
```

## Building With Opam

```sh
opam pin add .
```

## Documentation

```sh
jbuild-pp --help
```

## Depencencies

See [jbuild-pp.opam](./jbuild-pp.opam).

[jbuilder]: https://github.com/janestreet/jbuilder
[OCaml]:    http://www.ocaml.org/


