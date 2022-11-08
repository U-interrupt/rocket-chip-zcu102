JOBS = 4
BOARD ?= zcu102
TOP_MODULE ?= RocketChip
CONFIG ?= RocketConfig

BASE_DIR = $(abspath .)
BUILD = $(BASE_DIR)/build
SRC = $(BASE_DIR)/src

SHELL := /bin/bash

MILL ?= mill

DTB = $(BUILD)/$(BOARD).$(CONFIG).dtb
DTS = $(BUILD)/$(BOARD).$(CONFIG).dts

all: $(BUILD)/$(BOARD).$(CONFIG).v $(DTB)

LOOKUP_SCALA_SRCS = $(shell find $(1)/. -iname "*.scala" 2> /dev/null)
BOOTROM := $(shell find bootrom -iname "*.img" 2> /dev/null)

$(BUILD)/$(BOARD).$(CONFIG).fir: $(call LOOKUP_SCALA_SRCS,$(SRC)) $(BOOTROM)
	mkdir -p $(@D)
	$(MILL) $(BOARD).runMain freechips.rocketchip.system.Generator -td $(BUILD) -T $(BOARD).$(TOP_MODULE) -C $(BOARD).$(CONFIG)

$(BUILD)/$(BOARD).$(CONFIG).v: $(BUILD)/$(BOARD).$(CONFIG).fir
	$(MILL) $(BOARD).runMain firrtl.stage.FirrtlMain -i $< -o $@ -X verilog
	cp $@ $@.bak
	cp prologue.v $@
	sed 's/wire \[..:0\] coreMonitorBundle/(* mark_debug="true" *) \0/g' $@.bak >> $@

$(DTB): $(DTS)
	dtc -I dts -O dtb -o $@ $<
	

clean:
	rm -rf build/*

.PHONY:  all clean
