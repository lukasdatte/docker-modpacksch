# [FTB StoneBlock 3](https://feed-the-beast.com/modpack/100-ftb_stoneblock_3) By FTB

<!-- toc -->

- [Description](#description)
- [Requirements](#requirements)
- [Options](#options)
  * [Adding Minecraft Operators](#adding-minecraft-operators)
- [Troubleshooting](#troubleshooting)
  * [Accept the EULA](#accept-the-eula)
  * [Permissions of Files](#permissions-of-files)
  * [Resetting](#resetting)
- [Source](#source)

<!-- tocstop -->

## Important
This Repository is primarily for my own use, but feel free to use it if you like.  I will not be providing support for this container, but feel free to open an issue if you find a bug. I thank [Goobaroo](https://github.com/Goobaroo) for the original work on this container.

# Original Description:

## Description

This container is primaryily built to run on an [Unraid](https://unraid.net) server, outside of that your milliage will vary.

The docker on first run will download the same version as tagged of FTB StoneBlock 3 and install it.  This can take a while as the Forge installer can take a bit to complete.  You can watch the logs and it will eventually finish.

After the first run it will simply start the server.

## Requirements

* /data mounted to a persistent disk
* Port 25565/tcp mapped
* environment variable EULA set to "true"

As the end user, you are repsonsible for accepting the EULA from Mojang to run their server, by default in the container it is set to false.

## Options

These environment variables can be set at run time to override their defaults.

* JVM_OPTS "-Xms4096m -Xmx6144m"
* MOTD "FTB StoneBlock 3 Server Powered by Docker"
* LEVEL world

### Adding Minecraft Operators

Set the enviroment variable `OPS` with a comma separated list of players.

example:
`OPS="OpPlayer1,OpPlayer2"`

## Troubleshooting

### Accept the EULA
Did you pass in the environment variable EULA set to `true`?

### Permissions of Files
This container is designed for [Unraid](https://unraid.net) so the user in the container runs on uid 99 and gid 100.  This may cause permission errors on the /data mount on other systems.

### Resetting
If the install is incomplete for some reason.  Deleting the downloaded server file in /data will restart the install/upgrade process.

## Source
Github: https://github.com/Goobaroo/docker-stoneblock3

Docker: https://hub.docker.com/repository/docker/goobaroo/stoneblock3