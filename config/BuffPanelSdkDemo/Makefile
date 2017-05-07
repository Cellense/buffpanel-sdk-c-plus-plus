PROJECT_NAME = BuffPanelSdkDemo
PROJECT_MODULES = Main
LIBRARY_NAMES = BuffPanelSdk

BUILD_NAME = $(OS_NAME)_$(PLATFORM)_$(CONFIGURATION)
IS_DEBUG = $(filter Debug,$(CONFIGURATION))

ROOT_DIR = ../..
PROJECT_BUILD_DIR = $(ROOT_DIR)/$(BUILD_DIR)/$(BUILD_NAME)/$(PROJECT_NAME)
PROJECT_DIST_DIR = $(ROOT_DIR)/$(DIST_DIR)/$(BUILD_NAME)
PROJECT_INCLUDE_DIR = $(ROOT_DIR)/$(INCLUDE_DIR)
PROJECT_SOURCE_DIR = $(ROOT_DIR)/$(SOURCE_DIR)/$(PROJECT_NAME)

BINARY_FILE_NAME = $(PROJECT_NAME)$(if $(IS_DEBUG),d,)
OBJECT_FILE_PATHS = $(patsubst %,$(PROJECT_BUILD_DIR)/%.o,$(PROJECT_MODULES))
HEADER_FILE_PATHS = $(wildcard $(PROJECT_INCLUDE_DIR)/BuffPanel/*.h)

CXXFLAGS += $(if $(IS_DEBUG),-g -DDEBUG,-g0)
CXXFLAGS += $(if $(filter i386,$(PLATFORM)),$(if $(OS_IS_DARWIN),-arch i386,-m32),)
CXXFLAGS += $(if $(filter x86_64,$(PLATFORM)),$(if $(OS_IS_DARWIN),-arch x86_64,-m64),)
CXXFLAGS += -I$(PROJECT_INCLUDE_DIR)

LDFLAGS += -L$(PROJECT_DIST_DIR)
LDFLAGS += $(if $(filter i386,$(PLATFORM)),$(if $(OS_IS_DARWIN),-arch i386,-m32),)
LDFLAGS += $(if $(filter x86_64,$(PLATFORM)),$(if $(OS_IS_DARWIN),-arch x86_64,-m64),)

LDLIBS += $(patsubst %,-l%$(if $(IS_DEBUG),d,),$(LIBRARY_NAMES))

ifdef OS_IS_LINUX
  LD_RUN_PATH = $ORIGIN
  export LD_RUN_PATH
endif

all: $(PROJECT_DIST_DIR)/$(BINARY_FILE_NAME)

$(PROJECT_DIST_DIR)/$(BINARY_FILE_NAME): $(OBJECT_FILE_PATHS) $(PROJECT_DIST_DIR)
# Link the object files into the shared library.
	$(CC) $(LDFLAGS) $(OBJECT_FILE_PATHS) $(LDLIBS) -o $@

$(PROJECT_BUILD_DIR)/%.o: $(PROJECT_SOURCE_DIR)/%.cpp $(HEADER_FILE_PATHS) $(PROJECT_BUILD_DIR)
# Build the object files from the source files.
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(PROJECT_DIST_DIR):
# Create the dist directory.
	mkdir -p $@

$(PROJECT_BUILD_DIR):
# Create the build directory.
	mkdir -p $@
