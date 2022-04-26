
echo "STEP 1 - compile MONITOR"
 cd ./Zebra_Software_MONITOR_inROM
 make
echo "=============================="
echo "STEP 2 - compile MSBASIC "
 cd ../Zebra_Software_MSBASIC_inROM
 make
echo "=============================="
echo "STEP 3 - make Rom "
 cd ..
 dd if='./Zebra_Software_KRUSADER_inROM/zebra_krusader_bin(C000).65b' of='./Zebra_Software_KRUSADER_inROM/KRUSADER_inRom.bin' bs=1024 skip=60
 cat ./Zebra_Software_MSBASIC_inROM/msbasic/tmp/zebra_msbasic.bin ./Zebra_Software_MONITOR_inROM/zebra_monitor.bin ./Zebra_Software_KRUSADER_inROM/KRUSADER_inRom.bin > ./zebra.bin

 xxd -i zebra.bin > rom_image.h
 sed '1d' rom_image.h > rom_image1.h
 sed -i '1i\const uchar BIOS[] PROGMEM = {' rom_image1.h 
 mv rom_image1.h ./Zebra_6502_Core_Arduino/rom_image.h
 rm rom_image.h
 echo "=============================="
 echo "STEP 4 - run py65mon "
 cp ./Zebra_Software_MONITOR_inROM/zebra_monitor.bin ./monitor.bin
 py65mon -i 8001 -o 8002 -r zebra.bin
