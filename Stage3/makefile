.PHONY: all test unit-test system-test untested-build build clean wipe

all: build

# tput equivalents
#DEFAULT_START = printf "\033[m"
# single quotes solves '(' from being returned by tput sgr0
#DEFAULT_START = '$(shell tput sgr0)'
#BLACK_BACKGROUND_START = \033[40m
#BLACK_BACKGROUND_START := $(shell tput setab 0)
#FLASHING_TEXT_START = \033[5m
#FLASHING_TEXT_START = tput blink
#RED_TEXT_START = \033[0;31m
#RED_TEXT_START = tput setaf 1

# Octal ascii and ANSI color codes
SUCCESS_FLASH = printf "\033[5m\033[32m\033[40m" ; printf "SUCCESS:" ; printf "\033[m\033[32m\40" ; printf
WARNING_FLASH = printf "\033[5m\033[33m\033[40m" ; printf "WARNING:" ; printf "\033[m\033[33m\40" ; printf
ERROR_FLASH = printf "\033[5m\033[31m\033[40m""ERROR:""\033[m\033[31m\40" ; printf
END_FLAVOR_TEXT = ; printf "\033[0m\n"

# Check for optional and required executables on $PATH.
VALGRIND_INSTALLED = $(if $(shell which valgrind),1,0)
PYTHON3_INSTALLED = $(if $(shell which python3),1,0)
NVCC_INSTALLED = $(if $(shell which nvcc),1,0)
COMPUTESANITIZER_INSTALLED = $(if $(shell which compute-sanitizer),1,0)

MKFILE_PATH = $(abspath $(MAKEFILE_LIST))
CURRENT_DIR = $(dir $(MKFILE_PATH))
_DIR_DUMMY := $(shell mkdir -p $(CURRENT_DIR)/build)
_DIR_DUMMY := $(shell mkdir -p $(CURRENT_DIR)/bin)
SILENT_OPTS = --no-print-directory --silent

CUDA_SOURCES = $(wildcard $(SRC)/*.cu)
ifeq ($(NVCC_INSTALLED),1)
	CUDA_CAPABLE_MACRO = -DCUDA_CAPABLE
	LIB_DIR_FLAGS = -L$(subst bin/,lib64/,$(dir $(shell which nvcc)))
	LIB_FLAGS = -lcudart
    CUDA_OBJECTS = $(addprefix $(BUILD)/,$(notdir $(patsubst %.cu,%.o,$(CUDA_SOURCES))))
endif

SRC = $(addsuffix src,$(CURRENT_DIR))
INC = $(addsuffix include,$(CURRENT_DIR))
BUILD = $(addsuffix build,$(CURRENT_DIR))
BIN = $(addsuffix bin,$(CURRENT_DIR))

TEST_DIR = $(addsuffix test/,$(CURRENT_DIR))
TEST_SRC = $(addsuffix src,$(TEST_DIR))
TEST_INC = $(addsuffix include,$(TEST_DIR))
TEST_BUILD = $(addsuffix build,$(TEST_DIR))
TEST_BIN = $(addsuffix bin,$(TEST_DIR))

OPTIMIZATION_FLAGS = -O0
WARNING_FLAGS = -Wall -Werror
CFLAGS = -I$(INC) $(OPTIMIZATION_FLAGS) $(WARNING_FLAGS)

SOURCES = $(wildcard $(SRC)/*.c)
OBJECTS = $(addprefix $(BUILD)/,$(notdir $(patsubst %.c,%.o,$(SOURCES))))

MAIN_EXECUTABLE = $(BIN)/MainExecutable
export

$(CUDA_OBJECTS): $(BUILD)/%.o : $(SRC)/%.cu
	nvcc -I$(INC) -arch=native -c $< -o $(BUILD)/$(notdir $@)

$(OBJECTS): $(BUILD)/%.o : $(SRC)/%.c
ifeq ($(NVCC_INSTALLED),1)
	$(CC) $(CFLAGS) $(CUDA_CAPABLE_MACRO) -c $< -o $(BUILD)/$(notdir $@)
else
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/$(notdir $@)
endif

$(MAIN_EXECUTABLE): $(OBJECTS) $(CUDA_OBJECTS)
ifeq ($(NVCC_INSTALLED),1)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(CUDA_OBJECTS) $(LIB_DIR_FLAGS) $(LIB_FLAGS)
else
	@${WARNING_FLASH} "nvcc not found in PATH, MainExecutable will not use CUDA files!" ${END_FLAVOR_TEXT}
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)
endif

unit-test:
	@if $(MAKE) --no-print-directory --silent build-test -C test; then\
		${SUCCESS_FLASH} "Unit test section passed!" ${END_FLAVOR_TEXT} ; \
	else\
		${ERROR_FLASH} "Unit test section failed! Final executable will not be built. Exiting..." ${END_FLAVOR_TEXT} ; \
		exit 2;\
	fi

system-test: $(MAIN_EXECUTABLE)
ifeq ($(PYTHON3_INSTALLED),0)
	@${ERROR_FLASH} "Python3 required for system-test, exiting..." ${END_FLAVOR_TEXT}
	@exit 2
endif

ifeq ($(VALGRIND_INSTALLED),0)
	@${WARNING_FLASH} "Performing system-test without Valgrind!" ${END_FLAVOR_TEXT}
else
	$(shell mkdir -p $(CURRENT_DIR)/test/valgrind_logs)
endif

ifeq ($(NVCC_INSTALLED),1)
ifeq ($(COMPUTESANITIZER_INSTALLED),0)
	@${WARNING_FLASH} "Performing system-test without compute-sanitizer!" ${END_FLAVOR_TEXT}
else
	$(shell mkdir -p $(CURRENT_DIR)/test/compute-sanitizer_logs)
endif
endif

#add exe rights e.g., chmod +x $(TEST_SRC)/system-test.sh in lieu of bash $(TEST_SRC)/system-test.sh then call script
#@echo $(shell bash $(TEST_SRC)/system-test.sh $(VALGRIND_INSTALLED) $(COMPUTESANITIZER_INSTALLED))
	$(shell bash $(TEST_SRC)/system-test.sh $(VALGRIND_INSTALLED) $(COMPUTESANITIZER_INSTALLED) > /dev/null)
	@if [ $(.SHELLSTATUS) = 0 ]; then \
		${SUCCESS_FLASH} "System test passed!" ${END_FLAVOR_TEXT} ; \
		exit 0; \
	elif [ $(.SHELLSTATUS) = 2 ]; then \
		${ERROR_FLASH} "System test valgrind failed, exiting..." ${END_FLAVOR_TEXT} ; \
		exit 2; \
	elif [ $(.SHELLSTATUS) = 3 ]; then \
		${ERROR_FLASH} "System test compute-sanitizer failed, exiting..." ${END_FLAVOR_TEXT} ; \
		exit 3; \
	elif [ $(.SHELLSTATUS) = 4 ]; then \
		${ERROR_FLASH} "System test both valgrind and compute-sanitizer failed, exiting..." ${END_FLAVOR_TEXT} ; \
		exit 4; \
	fi

test: unit-test system-test

build: test $(MAIN_EXECUTABLE)
	@${SUCCESS_FLASH} "$(notdir $(MAIN_EXECUTABLE)) passed all tests and compiled successfully!" ${END_FLAVOR_TEXT}

untested-build: $(MAIN_EXECUTABLE)
	@${SUCCESS_FLASH} "$(notdir MAIN_EXECUTABLE) compiled successfully!" ${END_FLAVOR_TEXT}

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
	-rm -rf ./test/compute-sanitizer_logs