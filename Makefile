Makefile = Makefile
Project  = LW-Driver EByte E22-900T22S
Chipset	 = SX1262 (SemTech)

Target-OS	= Raspberry PI OS

.PHONY: clean mrproper
first: all


#### COMPILER CONFIG ####

CC 		= gcc
AS		= as
CXX		= g++
LINKER	= ld
STATIC 	= ar
KO		= /lib/modules/$(shell uname -r)/build
PWD		= $(shell pwd)

ROOT 			=
TARGET			= lwdriv_ebyte_e22-900t22s
BUILD_DIR		= build
BUILD_DIR_OBJ	= $(BUILD_DIR)/obj
BUILD_DIR_OUT	= $(BUILD_DIR)/out
VPATH			= src/ include/

LIBS =

#### COMPILER SETTINS ####

CSTD	= c11
CXXSTD	= c++11

INCPATH	 = -Iinclude/ \
			-I/lib/modules/$(shell uname -r)/build/include/

LFLAGS 	 := $(LFLAGS)
AFLAGS	 := $(AFLAGS)
CFLAGS	 := -std=$(CSTD) -Wall -Wextra -pipe $(CFLAGS) $(DEFINES) $(INCPATH)
CXXFLAGS := -std=$(CXXSTD) -Wall -Wextra -pipe $(CXXSTD) $(DEFINES) $(INCPATH)

#### FILES ####

INCLUDES = include/lwdriv.h

SOURCES  = src/entry.c

OBJECTS = $(patsubst %.c, %.o, $(SOURCES)) \
			$(patsubst %.S, %.o, $(SOURCES))

#### MODULES ####

# Target
obj-m := $(TARGET).o

# Objects
$(TARGET)-y := \
		src/entry.o

# CC Flags
ccflags-y := -I$(src)/include


#### OBJECTS ####
.SUFFIXES: .c .S

.S.o:
	$(AS) $(AFLAGS) -c $< -o $(BUILD_DIR_OBJ)/$@

.c.o:
	$(CC) -c $(CFLAGS) $< -o $(BUILD_DIR_OBJ)/$@

#### INSTRUCTIONS ####

all: mkdir $(TARGET)
$(TARGET): $(OBJECTS)
	$(LINKER) -g $(LFLAGS) -o $(TARGET).ko $(patsubst %.o, $(BUILD_DIR_OBJ)/%.o, $(OBJECTS))

module: get-ready
	$(MAKE) -C $(KO) M=$(shell pwd)/$(BUILD_DIR) modules
	mv $(BUILD_DIR)/*.ko $(BUILD_DIR_OUT)/

get-ready: mkdir
	cp Makefile	    $(BUILD_DIR)/Makefile
	cp $(TARGET).c	$(BUILD_DIR)/$(TARGET).c
	cp -r include	$(BUILD_DIR)
	cp -r src 		$(BUILD_DIR)


#### UTILITIES ####

clean:
	$(MAKE) -C $(KO) M=$(shell pwd)/build clean
	@rm -f -r $(BUILD_DIR)/*.o
	@rm -f $(BUILD_DIR)/*.c
	@rm -r $(BUILD_DIR)/include
	@rm -r $(BUILD_DIR)/src
mrproper: clean
	@rm -f $(BUILD_DIR_OUT)/*
mkdir:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR_OUT)
	@mkdir -p $(BUILD_DIR_OBJ)


#### INSTALL ####

load:
	insmod ./$(TARGET)
unload:
	rmmod ./$(TARGET)
