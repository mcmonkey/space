
bin/Game.swf : $(shell find src -name '*.as') makefile
	$(AIR_SDK_HOME)/bin/mxmlc -external-library-path+=$(AIR_PLAYER_SWC) -o $@  -default-size=1024,768 -debug=true src/Game.as