.PHONY: all build-test clean

all: build-test

_DIR_DUMMY := $(shell mkdir -p ./build)
_DIR_DUMMY := $(shell mkdir -p ./bin)

SRC = ../src
INC = ../include
BUILD = ../build

SOURCES = $(wildcard $(SRC)/*.c)
OBJECTS = $(addprefix $(BUILD)/,$(notdir $(patsubst %.c,%.o,$(SOURCES))))

TEST_SRC = ./src
TEST_INC = ./include
TEST_BUILD = ./build
TEST_BIN = ./bin
OPTIMIZATION_FLAGS = -O3
WARNING_FLAGS = -Wall -Werror
TEST_CFLAGS = -I$(TEST_INC) -I$(INC) $(OPTIMIZATION_FLAGS) $(WARNING_FLAGS)

UNIT_TEST_SOURCES = $(wildcard $(TEST_SRC)/*.c)
UNIT_TEST_OBJECTS = $(addprefix $(TEST_BUILD)/,$(notdir $(patsubst %.c,%.o,$(UNIT_TEST_SOURCES))))
OBJECTS_NO_MAIN = $(filter-out $(BUILD)/MainExecutable.o,$(OBJECTS))
UNIT_TEST_NAMES = $(basename $(notdir $(UNIT_TEST_SOURCES)))

$(OBJECTS): $(BUILD)/%.o : $(SRC)/%.c
	$(CC) $(TEST_CFLAGS) -c $< -o $(BUILD)/$(notdir $@)

UNITTESTRUNNER_EXECUTABLE = $(TEST_BIN)/UnitTestRunner

$(UNITTESTRUNNER_EXECUTABLE): $(UNIT_TEST_OBJECTS) $(OBJECTS_NO_MAIN)
	$(CC) $(TEST_CFLAGS) -o $@ $(OBJECTS_NO_MAIN) $(UNIT_TEST_OBJECTS)


$(UNIT_TEST_OBJECTS): $(TEST_BUILD)/%.o : $(TEST_SRC)/%.c
	$(CC) $(TEST_CFLAGS) -c $< -o $(TEST_BUILD)/$(notdir $@)

build-test: $(UNITTESTRUNNER_EXECUTABLE)
	$(UNITTESTRUNNER_EXECUTABLE)

clean:
	-rm -f $(TEST_BUILD)/*.o