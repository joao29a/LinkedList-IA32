CC=as
LD=ld
FLAGS=-g --32
LDFLAGS=-lc -dynamic-linker
LIB=/lib/ld-linux.so.2
OFLAG=-o
SRC=RONALD/RONALDO
EMULADOR=-m elf_i386
EXE=RONALDO

all: assembler linker

assembler:
	$(CC) $(FLAGS) $(SRC).s $(OFLAG) $(SRC).o

linker:
	$(LD) $(SRC).o $(LDFLAGS) $(LIB) $(OFLAG) $(EXE) $(EMULADOR)
