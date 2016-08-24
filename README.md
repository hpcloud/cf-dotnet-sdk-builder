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
docker run -v ${PWD}:/root/cf-dotnet-sdk-builder -it helioncf/hcf-ge-work
cd cloud_controller_ng
bundle install --no-deployment
bundle exec rake tmp:clear db:drop db:create db:dev:migrate
./bin/console
```

You'll find your output (on your dev box): `./Generated` and `tests`

It's best to keep the container around - it runs a mysql server, and it also
makes your dev cycle shorter, since you don't need to re-install gems every time.
Installing gems takes a really long time ...

> NOTE: the generation creates some junk in cloud_controller_ng.
> It's safe to ignore that.

## Building the Docker image

```bash
docker build -t helioncf/hcf-ge-work .
```
> If you need more rubies, add them to `versions.txt`.

## Upgrading the target API version

1. Find the commit you need

  - go to https://apidocs.cloudfoundry.org/
  - lookup the second version in the drop down (that's the CC version you care about)
	- note the first version number in the list
	- next, go here: https://github.com/cloudfoundry/cf-release
  - pick the correct tag that matches the first version number you noted, then go to the `src/` dir for that tag
	- you'll find a `cloud_controller_ng` submodule that's at a specific commit (that's the commit you need)

2. Bump the submodule to the desired commit

3. Generate and test
