#!/bin/bash

# TortugaLinux ISO Maker
# by https://anw.is-a.dev

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m' # no color (reset)

mkdir -p ./iso

echo -e "${LIGHT_GREEN}====================================${NC}"
echo -e "${LIGHT_GREEN}|${GREEN}      TortugaLinux ISO Maker      ${LIGHT_GREEN}|${NC}"
echo -e "${LIGHT_GREEN}====================================${NC}"
echo ""
echo -e "${RED}NOTE:${NC} If you quit intermittently, the huge downloaded blobs (~10GB) still exist."
echo "      Run 'sudo podman system migrate && sudo podman system prune -a -f' to cleanup."
echo ""
echo -e "${GREEN}Select the flavor you wish to build:${NC}"
echo "+---+------------\ /----------------------------------------------+"
echo "| * | FLAVOR      | INCLUDES                                      |"
echo "+---+-------------+-----------------------------------------------+"
echo "| 1 | Tortuga Max | turtagent and day-to-day applications.        |"
echo "| 2 | Tortuga Min | no turtagent, apps to get you up and running. |"
echo "+---+------------/ \----------------------------------------------+"
echo ""
read -p "Enter selection [1-2]: " choice

case "$choice" in
    1)
        FLAVOR_NAME="Tortuga Max"
        TARGET_IMAGE="ghcr.io/subhrajitsain/tortugalinux:max"
        ;;
    2)
        FLAVOR_NAME="Tortuga Min"
        TARGET_IMAGE="ghcr.io/subhrajitsain/tortugalinux:min"
        ;;
    *)
        echo -e "${RED}Error: Invalid option chosen. Aborting build process.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Flavor: ${LIGHT_GREEN}${FLAVOR_NAME}${NC}"
echo -e "${GREEN}Source: ${LIGHT_GREEN}${TARGET_IMAGE}${NC}"
echo -e "${GREEN}Running pre-download prerequisites...${NC}"

sudo podman system migrate

echo -e "${GREEN}Pulling TortugaLinux image from source...${NC}"
echo -e "${LIGHT_GREEN}-----------------------------------------------${NC}"

if ! sudo podman pull "$TARGET_IMAGE"; then
    echo -e "${RED}Error: Failed to pull image $TARGET_IMAGE. Aborting.${NC}"
    exit 1
fi

echo -e "${LIGHT_GREEN}-----------------------------------------------${NC}"
echo -e "${GREEN}Making your TortugaLinux ISO...${NC}"
echo -e "${LIGHT_GREEN}-----------------------------------------------${NC}"

if sudo podman run --rm -it --privileged -v ./iso:/iso -v /var/lib/containers/storage:/var/lib/containers/storage quay.io/centos-bootc/bootc-image-builder:latest --type iso --rootfs btrfs --output /iso "$TARGET_IMAGE"
then
    echo -e "${LIGHT_GREEN}-----------------------------------------------${NC}"
    echo -e "${GREEN}Cleaning up...${NC}"
    sudo podman system prune -a -f
    echo -e "${GREEN}Finished, check ./iso for your TortugaLinux ISO.${NC}"
else
    echo -e "${LIGHT_GREEN}-----------------------------------------------${NC}"
    echo -e "${RED}Build failed, cache not cleaned.${NC}"
    echo "Run 'sudo podman system prune -a -f' to clean manually and freshen up."
fi
