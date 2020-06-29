usb_print() {
    devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)
    output=""
    counter=0

    for unmounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == "0") | select(.mountpoint == null) | select(.name != "/dev/sda1") | .name'); do
        unmounted=$(echo "$unmounted" | tr -d "[:digit:]")
        unmounted=$(echo "$devices" | jq -r '.blockdevices[] | select(.name == "'"$unmounted"'") | .vendor')
        unmounted=$(echo "$unmounted" | tr -d ' ')
        if [ $counter -eq 0 ]; then
            space=""
        else
            space="  "
        fi
        counter=$((counter + 1))

        output="$output$space $unmounted"
    done

    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.mountpoint != null) | select(.mountpoint != "/") | select(.mountpoint != "/boot/efi") | .size'); do
    if [ $counter -eq 0 ]; then
            space=""
        else
            space="  "
        fi
        counter=$((counter + 1))

        output="$output$space $mounted"
    done
    echo "$output"
}

path_pid="/tmp/polybar-system-usb-udev.pid"

usb_update() {
    pid=$(cat "$path_pid")

    if [ "$pid" != "" ]; then
        kill -10 "$pid"
    fi
}



case "$1" in
    --update)
        usb_update
        ;;
    --mount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)
	# для монтирования
        for mount in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == "0") | select(.mountpoint == null) | select(.name != "/dev/sda1") | .name'); do 

            # mountpoint=$(udisksctl mount --no-user-interaction -b $mount)
            # mountpoint=$(echo $mountpoint | cut -d " " -f 4 | tr -d ".")
            # terminal -e "bash -lc 'filemanager $mountpoint'"

            mountpoint=$(udisksctl mount --no-user-interaction -b "$mount")
            mountpoint=$(echo "$mountpoint" | cut -d " " -f 4 | tr -d ".")
            termite -e "bash -lc 'mc $mountpoint'" &
        done

        usb_update
        ;;
    --unmount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        # для размонтирования
        for unmount in $(echo "$devices" | jq -r '.blockdevices[] | select(.name != "/dev/sda1") | select(.type == "part") | select(.mountpoint != null) | select(.mountpoint != "/") | select(.mountpoint != "/boot/efi") |.name'); do
            udisksctl unmount --no-user-interaction -b "$unmount"
            udisksctl power-off --no-user-interaction -b "$unmount"
        done

        usb_update
        ;;
    *)
        echo $$ > $path_pid

        trap exit INT
        trap "echo" USR1

        while true; do
            usb_print

            sleep 10 &
            wait
        done
        ;;
esac
