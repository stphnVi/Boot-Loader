# Variables
ASM=nasm
ASMFLAGS=-f bin
BIN=boot.bin
IMG=disk.img
QEMU=qemu-system-x86_64
QEMUFLAGS=-drive file=$(IMG),format=raw

# Objetivos
all: $(IMG)

$(IMG): $(BIN)
dd if=$(BIN) of=$(IMG) bs=512 count=1

$(BIN): boot.asm
$(ASM) $(ASMFLAGS) -o $(BIN) boot.asm

run: $(IMG)
$(QEMU) $(QEMUFLAGS)

clean:
rm -f $(BIN) $(IMG)