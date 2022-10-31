sgdisk --zap-all /dev/sdb
sgdisk --new=1:0:+4096M /dev/sdb
sgdisk --new=2:0:+2M /dev/sdb
sgdisk --new=3:0:+128M /dev/sdb
sgdisk --new=4:0:+8192M /dev/sdb
sgdisk --new=5:0:0 /dev/sdb
sgdisk --typecode=1:8301 --typecode=2:ef02 --typecode=3:ef00 --typecode=4:8200 --typecode=5:8300 /dev/sdb
sgdisk --change-name=1:/boot --change-name=2:GRUB --change-name=3:EFI-SP --change-name=4:swap --change-name=5:rootfs /dev/sdb
sgdisk --hybrid 1:2:3 /dev/sdb
sgdisk --print /dev/sdb

cryptsetup luksFormat --type=luks1 /dev/sdb1
cryptsetup luksFormat /dev/sdb4
cryptsetup luksFormat /dev/sdb5

cryptsetup open /dev/sdb1 LUKS_BOOT
cryptsetup open /dev/sdb4 LUKS_SWAP
cryptsetup open /dev/sdb5 LUKS_ROOT

mkfs.ext4 -L boot /dev/mapper/LUKS_BOOT
mkfs.vfat -F 16 -n EFI-SP /dev/sdb3
mkswap -L swap /dev/mapper/LUKS_SWAP
mkfs.btrfs -L root /dev/mapper/LUKS_ROOT

cryptsetup close LUKS_BOOT
cryptsetup close LUKS_SWAP
cryptsetup close LUKS_ROOT
