AXIS_USABLE_LIBS = UCLIBC GLIBC
include $(AXIS_TOP_DIR)/tools/build/Rules.axis

PROGS = hellousb_int

all: $(PROGS)
$(PROGS): $(PROGS).o
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -L /lib usb -o $@
clean: 
	rm -f $(PROGS) *.o core
