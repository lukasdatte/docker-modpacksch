#!/bin/bash

set -x

echo "Checking /data directory..."
if ! [[ -w "/data" ]]; then
  echo "Directory is not writable, check permissions for /data/"
  exit 66
fi

echo "Checking and applying Environment Variables..."
if [[ -z "$MODPACK_ID" || -z "$MODPACK_VER" ]]; then
  echo "You must set the Environment Variables MODPACK_ID and MODPACK_VER"
  exit 9
fi

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
  echo "eula=true" > eula.txt
else
  echo "You must set the Environment Variable EULA to true."
  exit 9
fi

if [[ -n "$MOTD" ]]; then
  sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
  sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
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

[[ -f run.sh ]] && chmod 755 run.sh
[[ -f start.sh ]] && chmod 755 start.sh
if [[ -f run.sh || -f start.sh ]]; then
  if [[ -f user_jvm_args.txt ]]; then
    echo "$JVM_OPTS" > user_jvm_args.txt
  fi
  [[ -f run.sh ]] && ./run.sh || ./start.sh
else
  rm -f forge-*-installer.jar
  FORGE_JAR=$(ls forge-*.jar)

  curl -Lo log4j2_112-116.xml "https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml"
  java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm -Dlog4j.configurationFile=log4j2_112-116.xml "$JVM_OPTS" -jar "$FORGE_JAR" nogui
fi