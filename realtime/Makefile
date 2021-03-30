# Makefile based on "Recursive Make Considered Harmful" by Peter Miller

# linux stuff
	CXX = g++
	CXXFLAGS = -g -I.
	LD = $(CC)
	LDFLAGS = -lstdc++ -lm -lpthread

.PHONY: default all clean

MODULES :=

# look for include files in each of the modules
CXXFLAGS += $(patsubst %,-I%, $(MODULES))

# All the non-main source files.
SRC :=

# Names of all the executables that we build.  each executable foo is assumed
# to have a foo.cc main program (not listed in SRC.)
EXECUTABLES := ilemt_server

# Names of other default targets such as explicitly built executables.
DEFAULT_TARGETS :=

# This rule forward references the default target which we can't 
# actually give until the module includes are processed.
default: all

# include the description for each module
include $(patsubst %,%/module.mk,$(MODULES))

all: $(EXECUTABLES) $(DEFAULT_TARGETS)

# determine the object files  OBJS is the non-main object files, and
# ALL_OBJS is all of the object tiles.
OBJS := $(patsubst %.cc,%.o, $(filter %.cc,$(SRC)))
ALL_OBJS := $(OBJS) $(patsubst %, %.o, $(EXECUTABLES))

# include the c++ include dependencies
include $(ALL_OBJS:.o=.d)

# calculate c++ include dependencies
%.d: %.cc
	./depend.sh $(CXXFLAGS) $< > $@

clean:
	rm -f $(ALL_OBJS) $(EXECUTABLES) $(ALL_OBJS:.o=.d)

# build the executables
$(EXECUTABLES) : $(ALL_OBJS)
	$(LD) $@.o $(OBJS) -o $@ $(LDFLAGS)
