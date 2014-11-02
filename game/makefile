
bin/Game.swf : $(shell find src -name '*.as')
	$(AIR_SDK_HOME)/bin/mxmlc -external-library-path+=$(AIR_PLAYER_SWC) -o $@ src/Game.as -default-size=1024,768