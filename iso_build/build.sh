#!/bin/bash

ISO_URL="http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/mini.iso"
ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.9.0-amd64-netinst.iso"

SOURCE_ISO="$(basename "$ISO_URL")"
DEST_ISO="postseed-$SOURCE_ISO"
ISO_FILES='isofiles'

PRESEED="preseed.cfg"


# Extracting the Initrd from an ISO Image

if ! [ -e "$SOURCE_ISO" ]
then
	wget "$ISO_URL" --show-progress -O "$SOURCE_ISO"
fi

rm -rf "$ISO_FILES"

xorriso -osirrox on -indev "$SOURCE_ISO" -extract / "$ISO_FILES"


# Adding a Preseed File to the Initrd

INITRD_PATH="$(find "$ISO_FILES"/install.*/initrd.gz)"
echo "Found initrd at: $INITRD_PATH"
INITRD_DIR="$(dirname "$INITRD_PATH")"

chmod +w -R "$INITRD_DIR"
gunzip "$INITRD_PATH"
echo "$PRESEED" | cpio -H newc -o -A -F "$INITRD_DIR/initrd"
patch isofiles/boot/grub/grub.cfg grub.cfg.patch
patch isofiles/isolinux/isolinux.cfg isolinux.cfg.patch
patch isofiles/isolinux/menu.cfg menu.cfg.patch
patch isofiles/isolinux/gtk.cfg gtk.cfg.patch
gzip "$INITRD_DIR/initrd"
chmod -w -R "$INITRD_DIR"


# Regenerating md5sum.txt

cd "$ISO_FILES"
chmod +w md5sum.txt
find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
chmod -w md5sum.txt
cd ..


# Creating a New Bootable ISO Image

genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat \
            -no-emul-boot -boot-load-size 4 -boot-info-table \
            -o "$DEST_ISO" "$ISO_FILES"

isohybrid "$DEST_ISO"

#xorriso -as mkisofs -r -V "Test 42" \
#	-J -b "$(find "$ISO_FILES" -name "isolinux.bin" | head -n1)" \
#	-c "$(find "$ISO_FILES" -name "boot.cat" | head -n1)" \
#	-no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 -isohybrid-mbr "isohdpfx.bin" -eltorito-alt-boot \
#	-e "$(find "$ISO_FILES" -name "efi.img" | head -n1)" -no-emul-boot -isohybrid-gpt-basdat -o "$DEST_ISO" ./

# Clean

#rm -rfv "$SOURCE_ISO" "$ISO_FILES"
