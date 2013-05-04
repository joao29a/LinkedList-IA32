CC=as
LD=ld
FLAGS=-g --32
LDFLAGS=-lc -dynamic-linker
LIB=/lib/ld-linux.so.2
OFLAG=-o
SRC=src/linkedList
EMULADOR=-m elf_i386
EXE=linkedList

all: 64bits

32bits: linker32

assembler32:
	$(CC) $(SRC).s $(OFLAG) $(SRC).o

linker32: assembler32
	$(LD) $(SRC).o $(LDFLAGS) $(LIB) $(OFLAG) $(EXE)

64bits: linker

assembler:
	$(CC) $(FLAGS) $(SRC).s $(OFLAG) $(SRC).o

linker: assembler
	$(LD) $(SRC).o $(LDFLAGS) $(LIB) $(OFLAG) $(EXE) $(EMULADOR)

install-lc:
	sudo apt-get install gcc-multilib

clean:
	rm -rf $(SRC).o
	rm -rf $(EXE)
