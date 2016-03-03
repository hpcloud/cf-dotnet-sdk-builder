# CF SDK Builder

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [CF SDK Builder](#cf-sdk-builder)
	- [Running the SDK builder](#running-the-sdk-builder)
- [You will be dropped in a shell](#you-will-be-dropped-in-a-shell)
	- [Building the Docker image](#building-the-docker-image)
	- [Writing extra output languages](#writing-extra-output-languages)
	- [Upgrading the target API version](#upgrading-the-target-api-version)

<!-- /TOC -->

## Running the SDK builder

Run the following (note that if you're generating `csharp` output, you can
omit the `language` variable).
After the `docker run`, you'll be dropped in a shell.

```bash
docker run -v ${PWD}:/root/cf-dotnet-sdk-builder -it helioncf/hcf-sdk-builder
language=lisp ./cf-doc-generation/update-code.sh
```

You'll find your output (on your dev box): `./Generated` and `tests`

It's best to keep the container around - it runs a mysql server, and it also
makes your dev cycle shorter, since you don't need to re-install gems every time
you want to run `update-code.sh`. Installing gems takes a really long time ...

> NOTE: the generation creates some junk in cloud_controller_ng.
> It's safe to ignore that.

## Building the Docker image

```bash
docker build -t helioncf/hcf-sdk-builder .
```
> If you need more rubies, add them to `versions.txt`.

## Writing extra output languages

1. Defining the new language: make a copy of the `lib/languages/csharp` directory
2. Rename the `csharp_types.rb` and `csharp.rb` files
3. Include your new language in:
  - `bin/codegen`: you need to require the files and modify parameter validation
  - `lib/config.rb`: mention it in the `self.language` function
4. Update the type definitions, file extensions, etc. for your new language
5. Run

## Upgrading the target API version

TBD
