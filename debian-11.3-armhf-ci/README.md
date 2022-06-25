# debian-11.3-armhf-ci-v1.0

This virtual machine is used to test Docker container images built for armhf (armv7l) on either GitHub Actions or CircleCI. 

## Setup

By default, this VM is passwordless for the user debianhf and for sudo, as well as for ssh access. If you need security, boot the VM using the below script, and add your private key and change the user password.

- Boot the VM using the term-start-vm-rw.sh script.

## Usage

To boot the virtual machine with QEMU, run the following command:

```
$ bash start-vm-and-tunnels.sh
```

Two ports are open and port forwarded to the guest:
- 8022 -> 22   - For SSH
- 7001 -> 7001 - For initial health check and confirmation VM is booted

start-vm-and-tunnels.sh performs the following operations:
- Begin booting the Debian 11.3 armhf virtual machine
- Periodically ping http://127.0.0.1:7001/status as a health check
- Once the /status endpoint returns 200 OK, connect the host Docker CLI to the Docker socket in the VM.

Docker CLI on the host now connects to an armhf Docker Engine. However, we must open additional ports to use with Docker. There are two ways to do this:

1. Prior to booting the VM, modify start-vm.sh to add additional hostfwd rules to open more ports.
2. Use SSH port forwarding to tunnel into the VM and open additional ports. Below is an example to open ports 4444 and 5555:

```
$ ssh -p 8022 debianhf@127.0.0.1 -N -f -L4444:127.0.0.1:4444 -L5555:127.0.0.1:5555
```
