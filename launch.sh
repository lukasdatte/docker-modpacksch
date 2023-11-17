#!/bin/bash

# Set script to fail on any errors
set -e

echo "Checking /data directory..."
if ! [[ -w "/data" ]]; then
  echo "Directory is not writable, check permissions for /data/"
  exit 1
fi

echo "Checking and applying Environment Variables..."
if [[ -z "$MODPACK_ID" || -z "$MODPACK_VER" ]]; then
  echo "You must set the Environment Variables MODPACK_ID and MODPACK_VER"
  exit 2
fi

cd /data

# EULA check logic
if [[ "${EULA,,}" != "true" ]]; then
  if grep -iq "true" eula.txt; then
    echo "eula=true found in eula.txt, proceeding..."
  else
    echo "You must set the Environment Variable EULA to true."
    exit 3
  fi
else
  echo "eula=true" > eula.txt
fi

# Ensure server.properties exists, create if not
if [[ ! -f server.properties ]]; then
  echo "Creating empty server.properties file..."
  touch server.properties
fi

# Update server properties
if [[ -n "$MOTD" ]]; then
  sed -i "/motd\s*=/ c motd=$MOTD" server.properties
fi
if [[ -n "$LEVEL" ]]; then
  sed -i "/level-name\s*=/ c level-name=$LEVEL" server.properties
fi

# Generate ops.txt and white-list.txt
if [[ -n "$OPS" ]]; then
  echo "$OPS" | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
  echo "$ALLOWLIST" | awk -v RS=, '{print}' > white-list.txt
fi

echo "Downloading server files..."
if ! [[ -f "serverinstall_${MODPACK_ID}_${MODPACK_VER}" ]]; then
  rm -f serverinstall_${MODPACK_ID}* forge-*.jar run.sh start.sh
  curl -Lo "serverinstall_${MODPACK_ID}_${MODPACK_VER}" "https://api.modpacks.ch/public/modpack/${MODPACK_ID}/${MODPACK_VER}/server/linux"
  chmod +x "serverinstall_${MODPACK_ID}_${MODPACK_VER}"
  "./serverinstall_${MODPACK_ID}_${MODPACK_VER}" --path /data --nojava
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

# Set execute permissions and run scripts
if [[ -f run.sh ]] || [[ -f start.sh ]]; then
  [[ -f run.sh ]] && chmod 755 run.sh
  [[ -f start.sh ]] && chmod 755 start.sh
  if [[ -f user_jvm_args.txt ]]; then
    echo "$JVM_OPTS" > user_jvm_args.txt
  fi
  [[ -f run.sh ]] && ./run.sh || ./start.sh
else
  echo "Neither run.sh nor start.sh found, proceeding with default setup..."
  rm -f forge-*-installer.jar
  FORGE_JAR=$(ls forge-*.jar)

  curl -Lo log4j2_112-116.xml "https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml"
  java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm -Dlog4j.configurationFile=log4j2_112-116.xml "$JVM_OPTS" -jar "$FORGE_JAR" nogui
fi
