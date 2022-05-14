all:	zMusic.bin

zMusic.bin: zMusic.o
	ld65 -t none -vm -m zMusic.map -o zMusic.bin zMusic.o

zMusic.o:	zMusic.s
	ca65 -g -l zMusic.lst zMusic.s

clean:
	$(RM) *.o *.lst *.map *.bin

distclean: clean
	$(RM) *.mon
