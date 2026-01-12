# Windows Add-on for Home Assistant

This add-on allows you to run a lightweight Windows environment inside Home Assistant using [Dockur Windows](https://github.com/dockur/windows) with noVNC access.

## Features

- Windows-in-Docker with QEMU
- Web-based access via Home Assistant Ingress (noVNC)
- Optional external port exposure

## Installation

[![Add repository to Home Assistant][repository-badge]][repository-url]

If you want to do add the repository manually, please follow the procedure highlighted in the [Home Assistant website](https://home-assistant.io/hassio/installing_third_party_addons). Use the following URL to add this repository: https://github.com/jessica12ryan/hassio-addon-windows

## Usage

- Open from the Home Assistant Add-on panel
- Or access externally at `http://<HA-IP>:<port>/vnc.html` (if ingress is disabled)

## Configuration

```yaml
custom_port: 6080
```

[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fjessica12ryan%2Fhassio-addon-windows

## Troubleshooting

Ensure VT-x (Virtualization) is enabled in the BIOS
