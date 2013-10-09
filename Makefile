TARGET	=	kexploit
SDK	?=	iphoneos
CC	=	xcrun -sdk $(SDK) clang
SRCFILES	= arm/kernel_entry.S user/kexploit.c
LDFLAGS		= -miphoneos-version-min=4.0 -Wl,-no_pie -Wl,-sectalign,__TEXT,__text,0x8000
ARCHFLAGS	?= -arch armv7
CPPFLAGS	= -I.

all: $(TARGET)

$(TARGET):
	$(CC) $(CPPFLAGS) $(LDFLAGS) $(SRCFILES) $(ARCHFLAGS) -o $(TARGET)

clean:
	rm -f $(TARGET)
