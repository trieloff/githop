# githop – Hop into your Development Environment from Git

What if you could just hop into a ready-made development environment with all your favorite tools simply by providing a Git Remote URL?

*githop* uses Git, Docker, and ZSH to do this for you. All you need is a running Docker, and the `githop` shell script.

## Features

* Works on macOS and Linux
* (on macOS only) mounts your working directory from the container
* supports Java, Node, Clojure and ClojureScript development

## Usage

```bash
$ githop <origin> <upstream> <other> <other>
```

```
$ githop :java <origin> <upstream> <other> <other>
```

Following tags are supported:

- `:java` for Java and Maven
- `:node` for Node and NPM
- `:clojure` for Java, Maven, Clojure, Leiningen
- `:clojurescript` for Java, Maven, Clojure, Leiningen, Node, NPM, Lumo

## Installation

Just copy the `githop` script into your `$PATH` and make it executable.

- [ ] write an auto-install script that can be curl-piped

## License

Apache 2.0

## Contributions

Welcome, just open a PR. Ideas:

- mounting under Linux
- more Docker images
- autocompletion
