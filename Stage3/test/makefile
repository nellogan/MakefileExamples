.PHONY: all build-test clean c-tests cuda-tests wipe

all: build-test clean

VALGRIND_LOGS = $(addsuffix valgrind_logs,$(TEST_DIR))
COMPUTE_SANITIZER_LOGS = $(addsuffix compute-sanitizer_logs,$(TEST_DIR))
LOGSUFFIX = .txt

_DIR_DUMMY := $(shell mkdir -p ./build)
_DIR_DUMMY := $(shell mkdir -p ./bin)
_DIR_DUMMY := $(shell mkdir -p ./valgrind_logs)

UNIT_TEST_MACRO = -DUNIT_TEST
CFLAGS += -I$(TEST_INC)

# Assuming each cuda file has a corresponding unit test with similar name ($(SRC)/ABC.cu, $(TEST_SRC)/Test_ABC.c),
# if not filter-out those that do not. If many source files do not have associated unit tests, consider using a separate
# directory to hold such files, e.g., -> CUDA_NO_UNIT_TEST_SOURCES = $(wildcard $(SRC_NO_TESTS)/*.cu)
CUDA_NO_UNIT_TEST_SOURCES = $(SRC)/CUDANoUnitTest.cu
CUDA_UNIT_TEST_SOURCES = $(filter-out $(CUDA_NO_UNIT_TEST_SOURCES),$(CUDA_SOURCES))
CUDA_UNIT_TEST_NAMES = $(basename $(notdir $(CUDA_UNIT_TEST_SOURCES)))
CUDA_UNIT_TEST_NAMES := $(foreach unit_test,$(CUDA_UNIT_TEST_NAMES),Test_$(unit_test))
CUDA_UNIT_TEST_OBJECTS = $(addprefix $(TEST_BUILD)/,$(notdir $(addsuffix .o,$(CUDA_UNIT_TEST_NAMES))))

UNIT_TEST_SOURCES = $(wildcard $(TEST_SRC)/*.c)
UNIT_TEST_OBJECTS = $(addprefix $(TEST_BUILD)/,$(notdir $(patsubst %.c,%.o,$(UNIT_TEST_SOURCES))))
ifeq ($(NVCC_INSTALLED), 0)
	UNIT_TEST_OBJECTS := $(filter-out $(CUDA_UNIT_TEST_OBJECTS),$(UNIT_TEST_OBJECTS))
else
	# CUDA toolkit includes nvcc and compute-sanitizer, if nvcc is found assume compute-sanitizer as well.
	_DIR_DUMMY := $(shell mkdir -p ./compute-sanitizer_logs)
endif
ALL_UNIT_TEST_NAMES = $(basename $(notdir $(UNIT_TEST_SOURCES)))
UNIT_TEST_BESTFN = $(TEST_BIN)/Test_BestFn
UNIT_TEST_WORK = $(TEST_BIN)/Test_Work
UNIT_TEST_SUPPORT = $(TEST_BIN)/Test_Support
UNIT_TEST_GPUHADAMARDPRODUCTREDUCTION = $(TEST_BIN)/Test_GPUHadamardProductReduction
UNIT_TEST_NAMES = $(filter-out $(CUDA_UNIT_TEST_NAMES),$(ALL_UNIT_TEST_NAMES))

UNIT_TEST_EXECUTABLES = $(UNIT_TEST_BESTFN) $(UNIT_TEST_WORK) $(UNIT_TEST_SUPPORT)
CUDA_UNIT_TEST_EXECUTABLES = $(UNIT_TEST_GPUHADAMARDPRODUCTREDUCTION)

$(CUDA_OBJECTS): $(BUILD)/%.o : $(SRC)/%.cu
	nvcc -I$(INC) -arch=native -c $< -o $(BUILD)/$(notdir $@)

$(OBJECTS): $(BUILD)/%.o : $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/$(notdir $@)

$(UNIT_TEST_OBJECTS):  $(TEST_BUILD)/%.o : $(TEST_SRC)/%.c
	$(CC) $(CFLAGS) $(UNIT_TEST_MACRO) -c $< -o $(TEST_BUILD)/$(notdir $@)

$(UNIT_TEST_BESTFN): $(BUILD)/BestFn.o $(TEST_BUILD)/Test_BestFn.o
	$(CC) $(CFLAGS) -o $@ $^

$(UNIT_TEST_WORK): $(BUILD)/BestFn.o $(BUILD)/Work.o $(TEST_BUILD)/Test_Work.o
	$(CC) $(CFLAGS) -o $@ $^

$(UNIT_TEST_SUPPORT): $(BUILD)/Support.o $(TEST_BUILD)/Test_Support.o
	$(CC) $(CFLAGS) -o $@ $^

$(UNIT_TEST_GPUHADAMARDPRODUCTREDUCTION): $(BUILD)/GPUHadamardProductReduction.o $(TEST_BUILD)/Test_GPUHadamardProductReduction.o
	$(CC) $(CFLAGS) -o $@ $^ $(LIB_DIR_FLAGS) $(LIB_FLAGS)

c-tests: $(UNIT_TEST_EXECUTABLES)
	@echo $(shell \
	for unit_test in $(UNIT_TEST_NAMES) ; do \
		LOGFILE=$(VALGRIND_LOGS)/$$unit_test$(LOGSUFFIX) ; \
		TEST_EXE=$(TEST_BIN)/$$unit_test ; \
		valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=2 --track-origins=yes --verbose\
		--fair-sched=yes --log-file=$$LOGFILE $$TEST_EXE ; \
		if [ $$? -ne 0 ]; then \
			${ERROR_FLASH} "valgrind has encountered leaks and/or errors in $$TEST_EXE,
			exiting..." ${END_FLAVOR_TEXT} ; echo '\n' ; \
			exit 2; \
		fi ; \
		${SUCCESS_FLASH} "$$unit_test unit test passed!" ${END_FLAVOR_TEXT} ; \
		printf "\n" ; \
    done ; \
	)

	if [ $(.SHELLSTATUS) -ne 0 ]; then \
		exit 2; \
	fi

ifeq ($(NVCC_INSTALLED), 1)
cuda-tests: $(CUDA_UNIT_TEST_EXECUTABLES)
	@echo $(shell \
	for cuda_unit_test in $(CUDA_UNIT_TEST_NAMES) ; do \
		LOGFILE=$(COMPUTE_SANITIZER_LOGS)/$$cuda_unit_test$(LOGSUFFIX) ; \
		TEST_EXE=$(TEST_BIN)/$$cuda_unit_test ; \
		compute-sanitizer --error-exitcode 2 --tool memcheck --leak-check full  \
		--log-file $$LOGFILE $$TEST_EXE ; \
		if [ $$? -ne 0 ]; then \
			${ERROR_FLASH} "compute-sanitizer has encountered leaks and/or errors in $$TEST_EXE,
			exiting..." ${END_FLAVOR_TEXT} ; \
			exit 2; \
		fi ; \
		${SUCCESS_FLASH} "$$cuda_unit_test unit test passed!" ${END_FLAVOR_TEXT} ; \
    done ; \
	)

	if [ $(.SHELLSTATUS) -ne 0 ]; then \
		exit 2; \
	fi
else
cuda-tests:
	@${WARNING_FLASH} "nvcc not found in PATH, build-test will not use CUDA files!" ${END_FLAVOR_TEXT}

endif

.ONESHELL:
build-test: c-tests cuda-tests

clean:
	-rm -f $(TEST_BUILD)/*.o

wipe: clean
	-rm -f $(TEST_BIN)/*