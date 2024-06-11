.PHONY: all unit-test system-test test build clean wipe

all: build

VALGRIND_INSTALLED = $(if $(shell which valgrind),1,0)
PYTHON3_INSTALLED = $(if $(shell which python3),1,0)

_DIR_DUMMY := $(shell mkdir -p ./build)
_DIR_DUMMY := $(shell mkdir -p ./bin)

SRC = ./src
INC = ./include
BUILD = ./build
TEST_BUILD = ./test/build
TEST_BIN = ./test/bin
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

unit-test:
	@if $(MAKE) build-test -C test; then\
		echo "Test section passed!.\n";\
	else\
		echo "Test section failed!. Final executable will not be built, exiting...\n";\
		exit 2;\
	fi

system-test: $(MAIN_EXECUTABLE)
ifeq ($(PYTHON3_INSTALLED),0)
	@echo python3 needed to run system-test, exiting...
	exit 2
endif

ifeq ($(VALGRIND_INSTALLED),0)
	$(warning WARNING: performing system-test without valgrind installed)
else
	$(shell mkdir -p ./test/valgrind_logs)
endif

	$(shell mkdir -p ./test/valgrind_logs)
	@echo $(shell bash ./test/src/system-test.sh $(VALGRIND_INSTALLED))
	@if [ $(.SHELLSTATUS) = 0 ]; then \
		echo "System-test passed!" ; \
		exit 0; \
	else \
		echo "System-test failed, exiting..." ; \
		exit 2; \
	 fi

test: unit-test system-test

build: test $(MAIN_EXECUTABLE)

clean:
	-rm -f $(BUILD)/*.o $(TEST_BUILD)/*.o

wipe: clean
	-rm -f $(BIN)/* $(TEST_BIN)/*

fresh-start:
	-rm -rf ./bin
	-rm -rf ./build
	-rm -rf ./test/bin
	-rm -rf ./test/build
	-rm -rf ./test/valgrind_logs