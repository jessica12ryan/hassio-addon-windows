# Windows Add-on for Home Assistant

This add-on allows you to run a lightweight Windows environment inside Home Assistant using [Dockur Windows](https://github.com/dockur/windows) with noVNC access.

## Features

- Windows-in-Docker with QEMU
- Web-based access via Home Assistant Ingress (noVNC)
- Optional external port exposure

## Requirements

- AMD64 Based System
- Home Assistant Operating System
- 64GB Free Space (Dedicated)

## Installation

[![Add repository to Home Assistant][repository-badge]][repository-url]

If you want to do add the repository manually, please follow the procedure highlighted in the [Home Assistant website](https://home-assistant.io/hassio/installing_third_party_addons). Use the following URL to add this repository: https://github.com/jessica12ryan/homesync-addons

Once the repository is added, select the addon from the addon store, and then click install. The install wheel will spin for about 15-20 minutes. Stay on this page as the install is about 15GB and takes some time to download and install.

## Usage

- Open from the Home Assistant Add-on panel
- Or access externally at `http://<HA-IP>:8006/vnc.html` (if ingress is disabled)

## Troubleshooting

- Ensure VT-x (Virtualization) is enabled in the BIOS
- Ensure that you are using an AMD64 based system
- ARCH64 based systems are not supported (e.g. raspberry pi)
- If running HAOS inside Proxmox, ensure CPU is set to Host, and the AES flag is ON

![Supports amd64 Architecture][amd64-shield]
![Supports aarch64 Architecture][aarch64-shield]


[aarch64-shield]: https://img.shields.io/badge/aarch64-no-red.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fjessica12ryan%2Fhomesync-addons
