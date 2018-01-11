# CloudFormation Opinionated Make : "Cake"

There are many AWS CloudFormation DSLs, direct alternatives, and AWS orchestration and management framework. `Cake` is different. The approach accepts that AWS is constantly iterating on CloudFormation, adding new features and functionality regularly. We accept the premise that CloudFormation is the AWS native management solution, and strive to build as thin a layer as possible to make life easier without getting in the way.

Many tools make the simple easy, and hard impossible. We intend to keep the simple simple, and offer an approach that makes the hard understandable.

The core of `Cake` is just that... a make file. To be explicit, we actually leverage MMake for some helpful capabilities of `imports` from other sources. Allowing us to easily share dependencies across teams and projects.

## What it DOES NOT do

- Add "magic" layers on top of CloudFormation
- Remove the need to be familiar with AWS or have a solid grasp CloudFormation
- A self contained deployment utility (`aws cloudformation stack` is great on itself!)

## What it DOES do

- Offers a highly opinionated structure, but keep only what you want
- Helps manage large templates in an elegant file structure
- Offers simple pipelining transformation operations
- Offers some libraries of pre-built transforms
- Examples of packaging and deployment

# Installing

Trick question! `Cake` is an opinionated structure, spec, and some modules. We rely entirely on `MMake` and `yq` (yaml command line query) and the `aws`  cli and require no other dependencies. Your own "pieces" (module includes) may require deps, and it's own you to handle them. We want to stay as light weight as possible.

```bash
# OSX setup
# mmake: https://github.com/tj/mmake/releases (get binary for your system, drop it somewhere in your path /usr/local/bin/mmake for example)
# alias make="mmake"

brew install yq
```

# Using

The quickest way to get started is to check some examples...
In any `cake` enabled project you can always run `cake help` to see what is available to you, including all commands in recursively included `pieces`.

For example, the `github.com/trek10inc/cake/pieces/basic/default.mk` include, with `cake help` will show the following.

```
➜ cake help
  clean                removes any build and packaging artifacts
  compile              compiles the template by merging all .yml files
  deploy               Simple deploy or update (args: region=)
  deploy-all-regions   Quickly deploy to a list of regions defined in cake.yml
  pre-transform        pre-ransform pipeline
  validate             compiles and validates the template
  watch                watches all files, rebuilds, and validates on change
```

`cake help -v` will expose more verbose details.

# Local Development

Clone the repository, the simplest thing to do to make dev easy, and compatible with `mmake` github includes, is to run the below command while in the root of the repository. `mmake` will not go fetch those files then, it will see the includes as already existing locally!

`ln -s $PWD/pieces /usr/local/include/github.com/trek10inc/cake/`

# TODO

- Default modules as includes
- quick "install" script (install yq, mmake, cake init, etc) (good for CI?)
- Testing harness against all examples