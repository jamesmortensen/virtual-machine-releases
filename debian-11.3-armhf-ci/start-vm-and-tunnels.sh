echo "Starting Debian 11.3 armhf virtual machine and waiting for boot success..."
SSH_PORT="${1:-8022}"
sh start-vm.sh
bash wait-for-vm.sh
VM_STATUS=$(echo $?)

if [ "$VM_STATUS" -eq 0 ]; then
	echo "Boot success...Connect Docker socket via SSH..."
	if [ -S "/tmp/docker-on-debianhf.sock" ]; then
		rm /tmp/docker-on-debianhf.sock
	fi
        ssh -p $SSH_PORT debianhf@127.0.0.1 -N -f -L/tmp/docker-on-debianhf.sock:/var/run/docker.sock ssh://debianhf@127.0.0.1
	export DOCKER_HOST=unix:///tmp/docker-on-debianhf.sock
	echo "To terminate the VM, run 'sh stop-vm.sh'"
	echo "To open SSH port tunnels, such as port 4444, run 'ssh -p $SSH_PORT debianhf@127.0.0.1 -N -f -L4444:127.0.0.1:4444'"
	echo "VM ready and SSH server listening on port $SSH_PORT. Run 'ssh -p $SSH_PORT debianhf@127.0.0.1' to connect..."
else
	echo "VM not up."
	exit 1
fi

