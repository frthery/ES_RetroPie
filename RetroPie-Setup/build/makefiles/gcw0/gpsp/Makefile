DEBUG=0
HAVE_GRIFFIN=0
FRONTEND_SUPPORTS_RGB565=1
FORCE_32BIT_ARCH=0
HAVE_MMAP=0
HAVE_MMAP_WIN32=0

UNAME=$(shell uname -a)

ifneq ($(EMSCRIPTEN),)
	platform = emscripten
endif

ifeq ($(platform),)
	platform = unix
	ifeq ($(UNAME),)
		platform = win
	else ifneq ($(findstring MINGW,$(UNAME)),)
		platform = win
	else ifneq ($(findstring Darwin,$(UNAME)),)
		platform = osx
		arch = intel
	ifeq ($(shell uname -p),powerpc)
		arch = ppc
		FORCE_32BIT_ARCH = 1
	endif
	else ifneq ($(findstring win,$(UNAME)),)
		platform = win
	endif
endif


ifeq ($(firstword $(filter x86_64,$(UNAME))),x86_64)

else ifeq ($(firstword $(filter amd64,$(UNAME))),amd64)

else ifeq ($(firstword $(filter x86,$(UNAME))),x86)
	FORCE_32BIT_ARCH = 1
endif

FORCE_32BIT :=

ifeq ($(FORCE_32BIT_ARCH),1)
	HAVE_DYNAREC := 1
	FORCE_32BIT := -m32
	CPU_ARCH := x86_32
endif

# system platform
system_platform = unix
ifeq ($(UNAME),)
	EXE_EXT = .exe
	system_platform = win
else ifneq ($(findstring Darwin,$(UNAME)),)
	system_platform = osx
	arch = intel
	ifeq ($(shell uname -p),powerpc)
		arch = ppc
	endif
	else ifneq ($(findstring MINGW,$(UNAME)),)
	system_platform = win
endif

TARGET_NAME	:= gpsp
LIBM		   := -lm
CORE_DIR    := .
LDFLAGS     :=

# Unix
ifeq ($(platform), unix)
	TARGET := $(TARGET_NAME)_libretro.so
	fpic := -fPIC
	SHARED := -shared $(FORCE_32BIT) -Wl,--version-script=link.T
	ifneq ($(findstring Haiku,$(shell uname -a)),)
		LIBM :=
	endif
	CFLAGS += $(FORCE_32BIT)
	LDFLAGS := -Wl,--no-undefined
	ifeq ($(HAVE_DYNAREC),1)
		HAVE_MMAP = 1
	endif

# Linux portable
else ifeq ($(platform), linux-portable)
	TARGET := $(TARGET_NAME)_libretro.so
	fpic := -fPIC -nostdlib
	SHARED := -shared $(FORCE_32BIT) -Wl,--version-script=link.T
	LIBM :=
	CFLAGS += $(FORCE_32BIT)
	ifeq ($(HAVE_DYNAREC),1)
		HAVE_MMAP = 1
	endif

# OS X
else ifeq ($(platform), osx)
	TARGET := $(TARGET_NAME)_libretro.dylib
	fpic := -fPIC
	ifeq ($(arch),ppc)
		CFLAGS += -DMSB_FIRST -D__ppc__
	endif
	OSXVER = `sw_vers -productVersion | cut -d. -f 2`
	OSX_LT_MAVERICKS = `(( $(OSXVER) <= 9)) && echo "YES"`
	fpic += -mmacosx-version-min=10.1
	SHARED := -dynamiclib
	ifeq ($(HAVE_DYNAREC),1)
		HAVE_MMAP = 1
	endif
	ifndef ($(NOUNIVERSAL))
		CFLAGS += $(ARCHFLAGS)
		LDFLAGS += $(ARCHFLAGS)
	endif

# iOS
else ifneq (,$(findstring ios,$(platform)))

	TARGET := $(TARGET_NAME)_libretro_ios.dylib
	fpic := -fPIC
	SHARED := -dynamiclib
	CPU_ARCH := arm

	ifeq ($(IOSSDK),)
		IOSSDK := $(shell xcodebuild -version -sdk iphoneos Path)
	endif

	CC = cc -arch armv7 -isysroot $(IOSSDK)
	CFLAGS += -DIOS -DHAVE_POSIX_MEMALIGN -marm
ifeq ($(platform),ios9)
	CC += -miphoneos-version-min=8.0
	CFLAGS += -miphoneos-version-min=8.0
else
	CC += -miphoneos-version-min=5.0
	CFLAGS += -miphoneos-version-min=5.0
endif

# iOS Theos
else ifeq ($(platform), theos_ios)
	DEPLOYMENT_IOSVERSION = 5.0
	TARGET = iphone:latest:$(DEPLOYMENT_IOSVERSION)
	ARCHS = armv7 armv7s
	TARGET_IPHONEOS_DEPLOYMENT_VERSION=$(DEPLOYMENT_IOSVERSION)
	THEOS_BUILD_DIR := objs
	include $(THEOS)/makefiles/common.mk

	CFLAGS += -DIOS -DHAVE_POSIX_MEMALIGN -marm
	CPU_ARCH := arm
	LIBRARY_NAME = $(TARGET_NAME)_libretro_ios

# QNX
else ifeq ($(platform), qnx)
	TARGET := $(TARGET_NAME)_libretro_qnx.so
	fpic := -fPIC
	SHARED := -shared -Wl,--version-script=link.T
	HAVE_MMAP = 1

	CC = qcc -Vgcc_ntoarmv7le
	AR = qcc -Vgcc_ntoarmv7le
	CFLAGS += -D__BLACKBERRY_QNX_
	HAVE_DYNAREC := 1
	CFLAGS += -DARM -DARM_ARCH -DARM_MEMORY_DYNAREC

# PS3
else ifeq ($(platform), ps3)
	TARGET := $(TARGET_NAME)_libretro_ps3.a
	CC = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-gcc.exe
	AR = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-ar.exe
	CFLAGS += -DMSB_FIRST -D__ppc__
	STATIC_LINKING = 1

# sncps3
else ifeq ($(platform), sncps3)
	TARGET := $(TARGET_NAME)_libretro_ps3.a
	CC = $(CELL_SDK)/host-win32/sn/bin/ps3ppusnc.exe
	AR = $(CELL_SDK)/host-win32/sn/bin/ps3snarl.exe
	CFLAGS += -DMSB_FIRST -D__ppc__
	STATIC_LINKING = 1

# Lightweight PS3 Homebrew SDK
else ifeq ($(platform), psl1ght)
	TARGET := $(TARGET_NAME)_libretro_psl1ght.a
	CC = $(PS3DEV)/ppu/bin/ppu-gcc$(EXE_EXT)
	AR = $(PS3DEV)/ppu/bin/ppu-ar$(EXE_EXT)
	CFLAGS += -DMSB_FIRST -D__ppc__
	STATIC_LINKING = 1

# PSP
else ifeq ($(platform), psp1)
	TARGET := $(TARGET_NAME)_libretro_psp1.a
	CC = psp-gcc$(EXE_EXT)
	AR = psp-ar$(EXE_EXT)
	CFLAGS += -DPSP -G0
	STATIC_LINKING = 1

# Vita
else ifeq ($(platform), vita)
	TARGET := $(TARGET_NAME)_libretro_vita.a
	CC = arm-vita-eabi-gcc$(EXE_EXT)
	AR = arm-vita-eabi-ar$(EXE_EXT)
	CFLAGS += -DVITA
	STATIC_LINKING = 1
	CPU_ARCH := arm

# CTR(3DS)
else ifeq ($(platform), ctr)
	TARGET := $(TARGET_NAME)_libretro_ctr.a
	CC = $(DEVKITARM)/bin/arm-none-eabi-gcc$(EXE_EXT)
	CXX = $(DEVKITARM)/bin/arm-none-eabi-g++$(EXE_EXT)
	AR = $(DEVKITARM)/bin/arm-none-eabi-ar$(EXE_EXT)
	CFLAGS += -DARM11 -D_3DS
	CFLAGS += -march=armv6k -mtune=mpcore -mfloat-abi=hard
	CFLAGS += -Wall -mword-relocations
	CFLAGS += -fomit-frame-pointer -ffast-math
	CXXFLAGS = $(CFLAGS) -fno-rtti -fno-exceptions -std=gnu++11
	CPU_ARCH := arm
	# dynarec unavailable with the HBL on FW > 9.2
	HAVE_DYNAREC = 1
	STATIC_LINKING = 1

# Xbox 360
else ifeq ($(platform), xenon)
	TARGET := $(TARGET_NAME)_libretro_xenon360.a
	CC = xenon-gcc$(EXE_EXT)
	AR = xenon-ar$(EXE_EXT)
	CFLAGS += -D__LIBXENON__ -m32 -D__ppc__
	STATIC_LINKING = 1

# Nintendo Game Cube
else ifeq ($(platform), ngc)
	TARGET := $(TARGET_NAME)_libretro_ngc.a
	CC = $(DEVKITPPC)/bin/powerpc-eabi-gcc$(EXE_EXT)
	AR = $(DEVKITPPC)/bin/powerpc-eabi-ar$(EXE_EXT)
	CFLAGS += -DGEKKO -DHW_DOL -mrvl -mcpu=750 -meabi -mhard-float -DMSB_FIRST -D__ppc__
	STATIC_LINKING = 1

# Nintendo Wii
else ifeq ($(platform), wii)
	TARGET := $(TARGET_NAME)_libretro_wii.a
	CC = $(DEVKITPPC)/bin/powerpc-eabi-gcc$(EXE_EXT)
	AR = $(DEVKITPPC)/bin/powerpc-eabi-ar$(EXE_EXT)
	CFLAGS += -DGEKKO -DHW_RVL -mrvl -mcpu=750 -meabi -mhard-float -DMSB_FIRST -D__ppc__
	STATIC_LINKING = 1

# ARM
else ifneq (,$(findstring armv,$(platform)))
	TARGET := $(TARGET_NAME)_libretro.so
	SHARED := -shared -Wl,--version-script=link.T
	CPU_ARCH := arm
	fpic := -fPIC
	ifneq (,$(findstring cortexa5,$(platform)))
		CFLAGS += -marm -mcpu=cortex-a5
		ASFLAGS += -mcpu=cortex-a5
	else ifneq (,$(findstring cortexa8,$(platform)))
		CFLAGS += -marm -mcpu=cortex-a8
		ASFLAGS += -mcpu=cortex-a8
	else ifneq (,$(findstring cortexa9,$(platform)))
		CFLAGS += -marm -mcpu=cortex-a9
		ASFLAGS += -mcpu=cortex-a9
	else ifneq (,$(findstring cortexa15a7,$(platform)))
		CFLAGS += -marm -mcpu=cortex-a15.cortex-a7
		ASFLAGS += -mcpu=cortex-a15.cortex-a7
	else
		CFLAGS += -marm
	endif
	ifneq (,$(findstring softfloat,$(platform)))
		CFLAGS += -mfloat-abi=softfp
		ASFLAGS += -mfloat-abi=softfp
	else ifneq (,$(findstring hardfloat,$(platform)))
		CFLAGS += -mfloat-abi=hard
		ASFLAGS += -mfloat-abi=hard
	endif
	CFLAGS += -DARM -DARM_ARCH
	# Dynarec works at least in rpi, take a look at issue #11
	ifeq (,$(findstring no-dynarec,$(platform)))
		HAVE_DYNAREC := 1
		CFLAGS += -DARM_MEMORY_DYNAREC
	endif
	LDFLAGS := -Wl,--no-undefined	

# emscripten
else ifeq ($(platform), emscripten)
	TARGET := $(TARGET_NAME)_libretro_emscripten.bc

# GCW0
else ifeq ($(platform), gcw0)
	TARGET := $(TARGET_NAME)_libretro.so
	CC = /opt/gcw0-toolchain/usr/bin/mipsel-linux-gcc
	CXX = /opt/gcw0-toolchain/usr/bin/mipsel-linux-g++
	AR = /opt/gcw0-toolchain/usr/bin/mipsel-linux-ar
	SHARED := -shared -nostdlib
	fpic := -fPIC
	LIBM :=
	DONT_COMPILE_IN_ZLIB = 1
	CFLAGS += -DFAMEC_NO_GOTOS

	asm_memory = 0
	asm_render = 0
	asm_ym2612 = 0
	asm_misc = 0
	asm_cdpico = 0
	asm_cdmemory = 0
	asm_mix = 0
	use_cyclone = 0
	use_fame = 1
	use_drz80 = 0
	use_cz80 = 1

# Windows
else
	TARGET := $(TARGET_NAME)_libretro.dll
	CC = gcc
	SHARED := -shared -static-libgcc -static-libstdc++ -s -Wl,--version-script=link.T
	CFLAGS += -D__WIN32__ -D__WIN32_LIBRETRO__
	ifeq ($(HAVE_DYNAREC),1)
		HAVE_MMAP = 1
		HAVE_MMAP_WIN32 = 1
	endif

endif

ifeq ($(HAVE_MMAP), 1)
CFLAGS += -DHAVE_MMAP
endif

ifeq ($(FORCE_32BIT_ARCH), 1)
# Forcibly disable PIC
fpic :=
endif

ifeq ($(DEBUG), 1)
	OPTIMIZE_SAFE := -O0 -g
	OPTIMIZE      := -O0 -g
else
	OPTIMIZE_SAFE := -O2 -DNDEBUG
	OPTIMIZE      := -O3 -DNDEBUG
endif


include Makefile.common

OBJECTS := $(SOURCES_C:.c=.o) $(SOURCES_ASM:.S=.o)

DEFINES := -DHAVE_STRINGS_H -DHAVE_STDINT_H -DHAVE_INTTYPES_H -D__LIBRETRO__ -DINLINE=inline -Wall

ifeq ($(HAVE_DYNAREC), 1)
DEFINES += -DHAVE_DYNAREC
endif

ifeq ($(CPU_ARCH), arm)
DEFINES += -DARM_ARCH
endif


WARNINGS_DEFINES =
CODE_DEFINES =

COMMON_DEFINES += $(CODE_DEFINES) $(WARNINGS_DEFINES) -DNDEBUG=1 $(fpic)

CFLAGS += $(DEFINES) $(COMMON_DEFINES) -Werror=implicit-function-declaration

ifeq ($(FRONTEND_SUPPORTS_RGB565), 1)
	CFLAGS += -DFRONTEND_SUPPORTS_RGB565
endif


ifeq ($(platform), ctr)
ifeq ($(HAVE_DYNAREC), 1)
OBJECTS += 3ds/3ds_utils.o

ifeq ($(strip $(CTRULIB)),)
$(error "Please set CTRULIB in your environment. export CTRULIB=<path to>ctrulib")
endif

CFLAGS  += -I$(CTRULIB)/include

endif
endif


ifeq ($(platform), theos_ios)
COMMON_FLAGS := -DIOS $(COMMON_DEFINES) $(INCFLAGS) -I$(THEOS_INCLUDE_PATH) -Wno-error
$(LIBRARY_NAME)_CFLAGS += $(COMMON_FLAGS) $(CFLAGS)
${LIBRARY_NAME}_FILES = $(SOURCES_C) $(SOURCES_ASM)
include $(THEOS_MAKE_PATH)/library.mk
else
all: $(TARGET)

$(TARGET): $(OBJECTS)
ifeq ($(STATIC_LINKING), 1)
	$(AR) rcs $@ $(OBJECTS)
else
	$(CC) $(fpic) $(SHARED) $(INCFLAGS) $(OPTIMIZE) -o $@ $(OBJECTS) $(LIBM) $(LDFLAGS)
endif

cpu_threaded.o: cpu_threaded.c
	$(CC) $(CFLAGS) -Wno-unused-variable -Wno-unused-label $(OPTIMIZE_SAFE) $(INCDIRS) -c -o $@ $<

libco/libco.o: libco/libco.c
	$(CC) $(INCFLAGS) $(CFLAGS) -O3 -DNDEBUG -c  -o $@ $<

%.o: %.S
	$(CC) $(ASFLAGS) $(CFLAGS) $(OPTIMIZE) -c -o $@ $<

%.o: %.c
	$(CC) $(INCFLAGS) $(CFLAGS) $(OPTIMIZE) -c  -o $@ $<

%.o: %.cpp
	$(CXX) $(INCFLAGS) $(CXXFLAGS) $(OPTIMIZE) -c  -o $@ $<

clean-objs:
	rm -rf $(OBJECTS)

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: clean
endif
