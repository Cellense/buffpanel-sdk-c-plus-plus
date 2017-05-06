MODULES = Main

BUILD_DIR = build/%/BuffPanelSdkDemo/
SOURCE_DIR = source/BuffPanelSdkDemo/

BuffPanelSdkDemoLINK_RECEPIE = $(if $(OS_IS_LINUX),LD_RUN_PATH='$$ORIGIN',) $(CC) $(LDFLAGS) -L$(dir $@) $^ -o $@
BuffPanelSdkDemoCOMPILE_RECEPIE = $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

dist/%_debug/BuffPanelSdkDemo: $(patsubst %,build/\%_debug/BuffPanelSdkDemo/%.o,$(MODULES))
	$(BuffPanelSdkDemoLINK_RECEPIE) -lBuffPanelSdkd

dist/%_release/BuffPanelSdkDemo: $(patsubst %,build/\%_release/BuffPanelSdkDemo/%.o,$(MODULES))
	$(BuffPanelSdkDemoLINK_RECEPIE) -lBuffPanelSdk

$(BUILD_DIR)Main.o: $(SOURCE_DIR)Main.cpp $(HEADER_FILE_PATHS) $(BUILD_DIR)
	$(BuffPanelSdkDemoCOMPILE_RECEPIE) $(if $(findstring debug,$@),-g -DDEBUG,-g0) $(if $(OS_IS_LINUX),$(if $(findstring x64_86,$@),-m64,-m32),)
