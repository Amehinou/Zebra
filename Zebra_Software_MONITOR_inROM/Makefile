all:	zebra_monitor.bin

zebra_monitor.bin: zebra_monitor.o
	ld65 -t none -vm -m zebra_monitor.map -o zebra_monitor.bin zebra_monitor.o

zebra_monitor.o:	zebra_monitor.s
	ca65 -g -l zebra_monitor.lst zebra_monitor.s

clean:
	$(RM) *.o *.lst *.map *.bin

distclean: clean
	$(RM) *.mon
