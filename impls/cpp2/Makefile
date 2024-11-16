CXX=g++

LD=$(CXX)
AR=ar

INCPATHS=-I$(CPPFRONT_INCLUDE)

DEBUG=-ggdb
CXXFLAGS=-O2 -Wall -Werror $(DEBUG) $(INCPATHS) -std=c++20
LDFLAGS=-O2 $(DEBUG) -L. -lreadline -lhistory

# LIBSOURCES=
LIBOBJS=$(LIBSOURCES:%.cpp2=%.o)

MAINS=$(wildcard step*.cpp2)
TARGETS=$(MAINS:%.cpp2=%)

.PHONY:	all dist clean

all: $(TARGETS)

dist: mal

mal: stepA_mal
	cp $< $@

.deps: *.cpp2 *.h2
	$(CXX) $(CXXFLAGS) -MM -x c++ *.cpp2 > .deps
	sed -i -e 's/\.cpp2/\.cpp/g' -e 's/\.h2/\.h/g' .deps

$(TARGETS): %: %.o libmal.a
	$(LD) $^ -o $@ $(LDFLAGS)

libmal.a: $(LIBOBJS)
	$(AR) rcs $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.cpp: %.cpp2
	cppfront $< -p

%.h: %.h2
	cppfront $<

clean:
	rm -rf *.cpp *.h *.o $(TARGETS) libmal.a .deps mal

.SECONDARY:

ifeq (,$(filter clean,$(MAKECMDGOALS)))
-include .deps
endif
