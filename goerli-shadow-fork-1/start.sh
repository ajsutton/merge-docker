#!/bin/bash
set -euo pipefail
SCRIPTDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

mkdir -p "${SCRIPTDIR}/data/jwt" "${SCRIPTDIR}/data/teku" "${SCRIPTDIR}/data/eth1" "${SCRIPTDIR}/data/grafana/data" "${SCRIPTDIR}/grafana/log" "${SCRIPTDIR}/data/geth"

openssl rand -hex 32 -out "${SCRIPTDIR}/data/jwt/secret.hex"

cd "$SCRIPTDIR"
docker pull consensys/teku:develop
#docker pull hyperledger/besu:develop-openjdk-latest
docker pull ethereum/client-go:latest

if [ ! -e "${SCRIPTDIR}/data/geth/geth" ]
then
    docker run -v "${SCRIPTDIR}/data/geth:/data" -v "${SCRIPTDIR}/../merge-testnets/goerli-shadow-fork-1:/config" ethereum/client-go:latest init /config/genesis.json --datadir /data
fi

docker compose up -d --remove-orphans
