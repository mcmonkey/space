
bin/Game.swf : $(shell find src -name '*.as')
	$(AIR_SDK_HOME)/bin/mxmlc -external-library-path+=$(AIR_PLAYER_SWC) -o $@  -default-size=1920,1080 -debug=true src/Game.as