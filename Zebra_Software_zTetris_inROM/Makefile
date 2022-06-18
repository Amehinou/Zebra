all:	zTetris.bin

zTetris.bin: zTetris.o
	ld65 -t none -vm -m zTetris.map -o zTetris.bin zTetris.o

zTetris.o:	zTetris.s
	ca65 -g -l zTetris.lst zTetris.s

clean:
	$(RM) *.o *.lst *.map *.bin

distclean: clean
	$(RM) *.mon
