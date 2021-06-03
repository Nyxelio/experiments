CC=g++
CFLAGS=-W -Wall
LDFLAGS= -lusbpp
PROG = testusb

all: $(PROG)

$(PROG): $(PROG).o
	$(CC) -o $@ $^ $(LDFLAGS)

#hello.o: hello.c
#	$(CC) -o $@ $< $(CFLAGS)

#main.o: main.c hello.h
#	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o

mrproper: clean
	rm -rf $(PROG)
