.PHONY:	all install
CC=g++
CXX=g++
CFLAGS += -O3 -g
CXXFLAGS += -Ijson11 -DUSE_CAFFE=1 -std=c++11 -O3 -fopenmp -g -I/usr/include/python2.7 -I/usr/local/cuda/include -DCPU_ONLY=1
#CXXFLAGS += -DUSE_PYTHON=1
LDFLAGS += -fopenmp -L/usr/lib64 
# add -lmxnet for mxnet
# add -lpython2.7 for python
# add those for Torch:  -lTH -lluaT -lluajit -llapack -lopenblas·
LDLIBS = libxnn.a -lcaffe -lpicpac $(shell pkg-config --libs opencv) \
	 -lboost_timer -lboost_chrono -lboost_thread -lboost_filesystem -lboost_system -lboost_program_options -lprotoc -lprotobuf -lglog #-lpython2.7

COMMON = libxnn.a json11.o
PROGS = predict xnn-roc #test_python # visualize predict #caffex-extract	caffex-predict batch-resize import-images

all:	$(COMMON) $(PROGS)

libxnn.a:	xnn.o caffe.o # python.o # mxnet.o python.o
	ar rvs $@ $^

json11.o:	json11/json11.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $^


$(PROGS):	%:	%.o $(COMMON) 

clean:
	rm $(PROGS) *.o

install:	libxnn.a
	cp libxnn.a /usr/local/lib
	cp xnn.h /usr/local/include
