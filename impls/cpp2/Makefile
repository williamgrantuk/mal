CXX=g++

LD=$(CXX)
AR=ar

INCPATHS=-I$(CPPFRONT_INCLUDE)

DEBUG=-ggdb
CXXFLAGS=-O2 -Wall -Werror $(DEBUG) $(INCPATHS) -std=c++20
LDFLAGS=-O2 $(DEBUG) -L. # -lreadline -lhistory

# LIBSOURCES=
LIBOBJS=$(LIBSOURCES:%.cpp2=%.o)

MAINS=$(wildcard step*.cpp2)
TARGETS=$(MAINS:%.cpp2=%)

SOURCES=$(MAINS) $(LIBSOURCES)
-include $(SOURCES:%.cpp2=%.cpp2.d)

.PHONY:	all dist clean

all: $(TARGETS)

dist: mal

mal: stepA_mal
	cp $< $@

$(TARGETS): %: %.o libmal.a
	$(LD) $^ -o $@ $(LDFLAGS)

libmal.a: $(LIBOBJS)
	$(AR) rcs $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.cpp: %.cpp2
	cppfront $< -p
	$(CXX) $(CXXFLAGS) -MM -MG $< > $<.d

clean:
	rm -rf *.cpp *.o $(TARGETS) libmal.a .deps mal
