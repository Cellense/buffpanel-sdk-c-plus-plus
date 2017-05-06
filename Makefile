OUTPUT_FILES = BuffPanelSdkDemo
OUTPUT_CONFIGURATIONS = debug release

LIBRARY_FILE_NAME = libBuffPanelSdk

INCLUDE_DIR = include
HEADER_FILE_PATHS = $(wildcard $(INCLUDE_DIR)/BuffPanel/*.h)

CXXFLAGS = -Wall -std=c++11 -I$(INCLUDE_DIR)

OS_NAME = $(shell uname -s)
ifeq ($(OS_NAME),Linux)

OS_IS_LINUX = 1

CC = g++
CXX = g++

LIBRARY_FILE_EXT = .so
OUTPUT_TARGETS = linux_i386 linux_x64_86

SHARED_LIB_OPTION = -shared

else

ifeq ($(OS_NAME),Darwin)

OS_IS_DARWIN = 1

CC = clang++
CXX = clang++
LDFLAGS += -arch i386 -arch x86_64
CXXFLAGS += -stdlib=libc++ -arch i386 -arch x86_64

LIBRARY_FILE_EXT = .dylib
OUTPUT_TARGETS = macosx_unilib

SHARED_LIB_OPTION = -dynamiclib

else
-install_name "@loader_path/libBuffPanelSdk.dylib"
all:
	@echo "ERROR: This is not a supported platform" ||:

endif

endif

all: $(foreach OUTPUT_TARGET,$(OUTPUT_TARGETS),\
		$(foreach OUTPUT_CONFIGURATION,$(OUTPUT_CONFIGURATIONS),\
		$(foreach OUTPUT_FILE,$(OUTPUT_FILES),\
		dist/$(OUTPUT_TARGET)_$(OUTPUT_CONFIGURATION)/ \
		dist/$(OUTPUT_TARGET)_$(OUTPUT_CONFIGURATION)/$(LIBRARY_FILE_NAME)$(if $(filter debug,$(OUTPUT_CONFIGURATION)),d,)$(LIBRARY_FILE_EXT) \
		dist/$(OUTPUT_TARGET)_$(OUTPUT_CONFIGURATION)/$(OUTPUT_FILE))))

include config/BuffPanelSdkDemo/BuffPanelSdkDemo.mk
include config/BuffPanelSdk/BuffPanelSdk.mk

build/%/:
# Create the build directory.
	mkdir -p $@

dist/%/:
# Create the dist directory.
	mkdir -p $@

.SECONDARY: $(foreach BUILD_DIR,$(wildcard build/*),$(BUILD_DIR))

clean:
# Clear the build and dist directories.
	rm -rf build
	rm -rf dist
