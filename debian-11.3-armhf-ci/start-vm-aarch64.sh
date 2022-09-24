#!/bin/sh

qemu-system-aarch64 \
 -display none \
 -cpu cortex-a15 \
 -smp cpus=4,sockets=1,cores=4,threads=1 \
 -machine virt \
 -accel tcg,tb-size=1024 \
 -drive if=pflash,format=raw,unit=0,file=AAVMF32_CODE.fd,readonly=on \
 -drive "if=pflash,unit=1,file=efi_vars.fd" \
 -boot menu=on \
 -m 2048 \
 -device intel-hda \
 -device hda-duplex \
 -device nec-usb-xhci,id=usb-bus \
 -device usb-tablet,bus=usb-bus.0 \
 -device usb-mouse,bus=usb-bus.0 \
 -device usb-kbd,bus=usb-bus.0 \
 -device ich9-usb-ehci1,id=usb-controller-0 \
 -device ich9-usb-uhci1,masterbus=usb-controller-0.0,firstport=0,multifunction=on \
 -device ich9-usb-uhci2,masterbus=usb-controller-0.0,firstport=2,multifunction=on \
 -device ich9-usb-uhci3,masterbus=usb-controller-0.0,firstport=4,multifunction=on \
 -device usb-storage,drive=cdrom0,removable=true,bootindex=0,bus=usb-bus.0 \
 -drive if=none,media=cdrom,id=cdrom0 \
 -device virtio-blk-pci,drive=drive0,bootindex=1 \
 -drive "if=none,media=disk,id=drive0,file=data.qcow2,cache=writethrough" \
 -device virtio-net-pci,netdev=net0 \
 -netdev user,id=net0,hostfwd=tcp::8022-:22,hostfwd=tcp::7001-:7001 \
 -rtc base=localtime \
 -monitor telnet:localhost:7100,server,nowait,nodelay &
