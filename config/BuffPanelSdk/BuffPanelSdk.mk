MODULES = Client

BUILD_DIR = build/%/BuffPanelSdk/
SOURCE_DIR = source/BuffPanelSdk/

REFERENCE_LIBRARIES = PocoUtil PocoJSON PocoNet PocoXML PocoFoundation
OBJECT_FILE_PATHS = $(patsubst %,build/\%/BuffPanelSdk/%.o,$(MODULES))

BuffPanelSdkCXXFLAGS = $(CXXFLAGS) -Ireference/include -fPIC

BuffPanelSdkLINK_RECEPIE = $(CC) $(LDFLAGS) -pthread $^ -o $@ $(SHARED_LIB_OPTION)
BuffPanelSdkCOMPILE_RECEPIE = $(CXX) $(CPPFLAGS) $(BuffPanelSdkCXXFLAGS) -c -o $@ $<

dist/%_debug/$(LIBRARY_FILE_NAME)d$(LIBRARY_FILE_EXT): $(OBJECT_FILE_PATHS)
	$(BuffPanelSdkLINK_RECEPIE) $(if $(OS_IS_DARWIN)) -Lreference/library/$(if $(OS_IS_LINUX),$(if $(findstring x64_86,$@),x64_86,i386),) $(patsubst %,-l%d,$(REFERENCE_LIBRARIES))

dist/%_release/$(LIBRARY_FILE_NAME)$(LIBRARY_FILE_EXT): $(OBJECT_FILE_PATHS)
	$(BuffPanelSdkLINK_RECEPIE) $(patsubst %,-l%,$(REFERENCE_LIBRARIES))

$(BUILD_DIR)Client.o: $(SOURCE_DIR)Client.cpp $(HEADER_FILE_PATHS) $(BUILD_DIR)
	$(BuffPanelSdkCOMPILE_RECEPIE) $(if $(findstring debug,$@),-g -DDEBUG,-g0) $(if $(findstring x64_86,$@),-m64,-m32),)
