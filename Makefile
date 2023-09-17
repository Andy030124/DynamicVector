PROJECT_NAME=vector

CXX:=ccache
FLAGS:=-Wall -pedantic -Iincludes

ifdef STD_11
	FLAGS+= -std=c++11
else
	ifdef STD_17
		FLAGS+= -std=c++17
	else
		ifdef STD_20
			FLAGS+= -std=c++20
		else
			FLAGS+= -std=c++23
		endif
	endif
endif

ifdef RELEASE
	FLAGS+= -O3
else
	FLAGS+= -g -ggdb
endif

ifdef RAW_CXX
	CXX:=
endif

ifdef CXX_CLANG
	CXX+= clang++
else
	CXX+= g++
endif

ifndef NASAN
	SANITIZER := -fsanitize=address,undefined
endif

# $1: directories
# $2: extension files
define FIND_FILES
$(foreach DIR,$1,$(wildcard $(DIR)/*.$2))
endef

SRCDIR=src
OBJDIR=obj

SOURCES_DIRS:=$(filter-out .,$(shell find $(SRCDIR) -type d))
OBJECTS_DIRS:=$(patsubst $(SRCDIR)%,$(OBJDIR)%,$(SOURCES_DIRS))

SRC_FILES:=$(call FIND_FILES,$(SOURCES_DIRS),cpp)
OBJ_FILES:=$(patsubst $(SRCDIR)%,$(OBJDIR)%,$(patsubst %.cpp,%.o,$(SRC_FILES)))

BUILD_DIR=build

APP:=$(BUILD_DIR)/$(PROJECT_NAME)

.PHONY: clean cleanall copy exe info

$(APP): $(BUILD_DIR) $(OBJECTS_DIRS) $(OBJ_FILES)
	$(CXX) $(FLAGS) $(OBJ_FILES) $(LDFLAGS) -o $(APP)
	$(CXX) $(FLAGS) $(SANITIZER) $(OBJ_FILES) $(LDFLAGS) -o $(APP).safe

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) $(FLAGS) -c $< -o $@

exe:
	./$(BUILD_DIR)/$(PROJECT_NAME)

test-fast:
	./$(BUILD_DIR)/$(PROJECT_NAME).safe

test-e2e:
	valgrind --leak-check=full --show-leak-kinds=all ./$(BUILD_DIR)/$(PROJECT_NAME)

$(BUILD_DIR):
	$(shell mkdir -p $@)

$(OBJECTS_DIRS):
	$(foreach D,$(OBJECTS_DIRS),$(shell mkdir -p $(D)))

info:
	$(info $(SOURCES_DIRS))
	$(info $(OBJECTS_DIRS))
	$(info $(SRC_FILES))
	$(info $(OBJ_FILES))

clean:
	rm -rf $(OBJDIR)

cleanall: clean
	rm -rf $(BUILD_DIR)