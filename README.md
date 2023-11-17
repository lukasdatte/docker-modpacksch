## Important
This Repository is primarily for my own use, but feel free to use it if you like.  I will not be providing support for this container, but feel free to open an issue if you find a bug. I thank [Goobaroo](https://github.com/Goobaroo) for the original work on this container.

# Docker Container for Modpack.ch Modpacks

This repository, originally created for FTB StoneBlock 3, has been adapted to run any Minecraft modpack from Modpack.ch using Docker.

## Description

This Docker container dynamically downloads and runs Minecraft modpacks from Modpack.ch. It is designed to be flexible and user-friendly, allowing for easy setup and customization of Minecraft servers with various modpacks. Please beware that the modpack connot be easily changed after the first run.

## Requirements

- A persistent disk mounted to `/data`.
- Environment variables `MODPACK_ID` and `MODPACK_VER` set to specify the modpack.
- Acceptance of Mojang's EULA by setting the environment variable `EULA` to "true".
- Port 25565/tcp mapped.

## How It Works

The Docker container is configured via the `Dockerfile` and the inner workings are managed by the `launch.sh` script:

- **Dockerfile**: Sets up the base environment using `openjdk:17.0.2-jdk-buster`, installs necessary tools like `curl`, and prepares the user and working directory.
- **launch.sh**: Handles the server setup, including checking permissions, setting server properties based on environment variables, and downloading the specified modpack.

## Usage

1. Set the `MODPACK_ID` and `MODPACK_VER` environment variables to the desired modpack's ID and version from Modpack.ch.
2. Ensure the `EULA` environment variable is set to "true".
3. Additional customization can be done through environment variables like `MOTD` (Message of the Day), `LEVEL` (world name), `OPS` (server operators), and `ALLOWLIST` (whitelisted players).
4. Run the Docker container using the following command. You can also use a `docker-compose.yml` file to run the container:

   ```bash
   docker run -d \
     -p 25565:25565 \
     -e MODPACK_ID=<your_modpack_id> \
     -e MODPACK_VER=<your_modpack_version> \
     -e EULA=true \
     -e MOTD="Your Custom Server Message" \
     -e LEVEL=world \
     -e OPS="OpPlayer1,OpPlayer2" \
     -e ALLOWLIST="Player1,Player2" \
     -v </path/to/your/data:/data> \
     ghcr.io/lukasdatte/docker-modpacksch:main

## Options

These environment variables can be set at run time to override their defaults.

- `JVM_OPTS` (e.g., "-Xms4096m -Xmx6144m")
- `MOTD` (e.g., "Your Custom Server Message")
- `LEVEL` (e.g., world name)
- `OPS` (comma-separated list of server operators)
- `ALLOWLIST` (comma-separated list of whitelisted players)
- `MODPACK_ID` (ID of the modpack from Modpack.ch)
- `MODPACK_VER` (Version of the modpack)

## Troubleshooting

### Accept the EULA
Ensure you have set the environment variable `EULA` to `true`.

### MODPACK_ID and MODPACK_VER
Verify that `MODPACK_ID` and `MODPACK_VER` are correctly set to the desired modpack's ID and version.

### Permissions of Files
This container is designed for various systems. Ensure correct permissions for the `/data` mount.

### Resetting
If the install is incomplete, deleting the downloaded server file in `/data` will restart the install/upgrade process. Please note that this will delete all worlds and other data.

## Contributing

Contributions to extend the functionality and support more modpacks are welcome.
