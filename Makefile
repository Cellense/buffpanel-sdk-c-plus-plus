BUILD_DIR = build
DIST_DIR = dist
INCLUDE_DIR = include
REFERENCE_DIR = reference
REFERENCE_INCLUDE_DIR = $(REFERENCE_DIR)/include
REFERENCE_LIBRARY_DIR = $(REFERENCE_DIR)/library
SOURCE_DIR = source

CC = clang++
CXX = clang++
CXXFLAGS = -Wall -std=c++11

OS_NAME = $(shell uname -s)
ifeq ($(OS_NAME),Linux)
  OS_IS_LINUX = 1
  OS_NAME = Linux

  SHARED_LIB_FILE_EXT = .so
  SHARED_LIB_LDFLAGS = -shared
else
ifeq ($(OS_NAME),Darwin)
  OS_IS_DARWIN = 1
  OS_NAME = MacOSX

  SHARED_LIB_FILE_EXT = .dylib
  SHARED_LIB_LDFLAGS = -dynamiclib

  CXXFLAGS += -stdlib=libc++
else
  $(error The platform '$(OS_NAME)' is not supported)
endif
endif

export BUILD_DIR
export DIST_DIR
export INCLUDE_DIR
export REFERENCE_DIR
export REFERENCE_INCLUDE_DIR
export REFERENCE_LIBRARY_DIR
export SOURCE_DIR
export CC
export CXX
export CXXFLAGS
export OS_NAME
export OS_IS_LINUX
export OS_IS_DARWIN
export SHARED_LIB_FILE_EXT
export SHARED_LIB_LDFLAGS

all: BuffPanelSdk BuffPanelSdkDemo

BuffPanelSdk BuffPanelSdkDemo:
# Build the given project for all configurations.
	$(MAKE) -C config/$@ PLATFORM=i386 CONFIGURATION=Debug
	$(MAKE) -C config/$@ PLATFORM=i386 CONFIGURATION=Release
	$(MAKE) -C config/$@ PLATFORM=x86_64 CONFIGURATION=Debug
	$(MAKE) -C config/$@ PLATFORM=x86_64 CONFIGURATION=Release

clean:
# Clear the build and dist directories.
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)
