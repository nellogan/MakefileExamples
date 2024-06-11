_DIR_DUMMY := $(shell mkdir -p ./build)
_DIR_DUMMY := $(shell mkdir -p ./bin)

SRC = ./src
INC = ./include
BUILD = ./build
BIN = ./bin
CFLAGS = -I$(INC) -O3 -Wall -Werror

.PHONY: all clean fresh-start

all: $(BIN)/MainExecutable

$(BUILD)/BestFn.o: $(SRC)/BestFn.c
	$(CC) -I$(INC) -c $(SRC)/BestFn.c -o $(BUILD)/BestFn.o

$(BUILD)/Work.o: $(SRC)/BestFn.c $(SRC)/Work.c
	$(CC) -I$(INC) -c $(SRC)/Work.c -o $(BUILD)/Work.o

$(BUILD)/Support.o: $(SRC)/Support.c
	$(CC) -I$(INC) -c $(SRC)/Support.c -o $(BUILD)/Support.o

$(BUILD)/Main.o: $(SRC)/BestFn.c $(SRC)/Work.c $(SRC)/Support.c $(SRC)/Main.c
	$(CC) -I$(INC) -c $(SRC)/Main.c -o $(BUILD)/Main.o

$(BIN)/MainExecutable: $(BUILD)/BestFn.o $(BUILD)/Work.o $(BUILD)/Support.o $(BUILD)/Main.o
	gcc -I$(INC) -o $(BIN)/MainExecutable $(BUILD)/BestFn.o $(BUILD)/Work.o $(BUILD)/Support.o $(BUILD)/Main.o

clean:
	-rm -f $(BUILD)/*.o

fresh-start:
	-rm -rf ./bin
	-rm -rf ./build