.PHONY: all test build clean

all: build

_DIR_DUMMY := $(shell mkdir -p ./build)
_DIR_DUMMY := $(shell mkdir -p ./bin)

SRC = ./src
INC = ./include
BUILD = ./build
TEST_BUILD = ./test/build
BIN = ./bin
OPTIMIZATION_FLAGS = -O3
WARNING_FLAGS = -Wall -Werror
CFLAGS = -I$(INC) $(OPTIMIZATION_FLAGS) $(WARNING_FLAGS)

SOURCES = $(wildcard $(SRC)/*.c)
OBJECTS = $(addprefix $(BUILD)/,$(notdir $(patsubst %.c,%.o,$(SOURCES))))

MAIN_EXECUTABLE = $(BIN)/MainExecutable

$(MAIN_EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

$(OBJECTS): $(BUILD)/%.o : $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/$(notdir $@)

test:
	@if $(MAKE) -C test; then\
		echo "Test section passed!.\n";\
	else\
		echo "Test section failed!. Final executable will not be built, exiting...\n";\
		exit 2;\
	fi

build: test $(MAIN_EXECUTABLE)

clean:
	-rm -f $(BUILD)/*.o $(TEST_BUILD)/*.o

fresh-start:
	-rm -rf ./bin
	-rm -rf ./build
	-rm -rf ./test/bin
	-rm -rf ./test/build