all:	zPixel.bin

zPixel.bin: zPixel.o
	ld65 -t none -vm -m zPixel.map -o zPixel.bin zPixel.o

zPixel.o:	zPixel.s
	ca65 -g -l zPixel.lst zPixel.s

clean:
	$(RM) *.o *.lst *.map *.bin

distclean: clean
	$(RM) *.mon
