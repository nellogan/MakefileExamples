.PHONY: all lazy Stage0 Stage1 Stage2 Stage3 clean wipe fresh-start

all: lazy

MKFILE_PATH = $(abspath $(MAKEFILE_LIST))
CURRENT_DIR = $(dir $(MKFILE_PATH))
Stage0_DIR = $(addsuffix Stage0,$(CURRENT_DIR))
Stage1_DIR = $(addsuffix Stage1,$(CURRENT_DIR))
Stage2_DIR = $(addsuffix Stage2,$(CURRENT_DIR))
Stage3_DIR = $(addsuffix Stage3,$(CURRENT_DIR))

SILENT_OPTS = --no-print-directory --silent

Stage0:
	$(MAKE) $(SILENT_OPTS) -C Stage0

Stage1:
	$(MAKE) $(SILENT_OPTS) -C Stage1

Stage2:
	$(MAKE) $(SILENT_OPTS) -C Stage2

Stage3:
	$(MAKE) $(SILENT_OPTS) -C Stage3

lazy: Stage0 Stage1 Stage2 Stage3

clean:
	$(MAKE) $(SILENT_OPTS) -C Stage0 clean
	$(MAKE) $(SILENT_OPTS) -C Stage1 clean
	$(MAKE) $(SILENT_OPTS) -C Stage2 clean
	$(MAKE) $(SILENT_OPTS) -C Stage3 clean

wipe: clean
	$(MAKE) $(SILENT_OPTS) -C Stage0 wipe
	$(MAKE) $(SILENT_OPTS) -C Stage1 wipe
	$(MAKE) $(SILENT_OPTS) -C Stage2 wipe
	$(MAKE) $(SILENT_OPTS) -C Stage3 wipe

fresh-start:
	$(MAKE) $(SILENT_OPTS) -C Stage0 fresh-start
	$(MAKE) $(SILENT_OPTS) -C Stage1 fresh-start
	$(MAKE) $(SILENT_OPTS) -C Stage2 fresh-start
	$(MAKE) $(SILENT_OPTS) -C Stage3 fresh-start