# Rancher Example

This examples has the following prerequisites:

- [Colima](https://github.com/abiosoft/colima) installed (used a Docker Runtime alternative)
- [Ngrok](https://ngrok.com/) installed (tunnels outside traffic to localhost)
- [K3D](https://k3d.io) (used to create K3S cluster in which Rancher will be installed)

It installs K3S/Rancher with the default password (Welcome123) and opens external accessible HTTPS endpoints forwarding to localhost.

## How to run

```shell
# create Docker environment with enough memory and CPU
$ make colima/start

# Install everything
$ make main/start

$ See help for all available options
$ make
```
