# Windows Add-on for Home Assistant

This add-on allows you to run a lightweight Windows environment inside Home Assistant using [Dockur Windows](https://github.com/dockur/windows) with noVNC access.

## Features

- Windows-in-Docker with QEMU
- Web-based access via Home Assistant Ingress (noVNC)
- Optional external port exposure

## Usage

- Open from the Home Assistant Add-on panel
- Or access externally at `http://<HA-IP>:<port>/vnc.html` (if ingress is disabled)

## Configuration

```yaml
custom_port: 6080
