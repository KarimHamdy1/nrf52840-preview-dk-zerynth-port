
#### Compiler options
ifeq ($(USE_OPT),)
#   USE_OPT = -O0 -ggdb -fomit-frame-pointer -falign-functions=16 -mno-unaligned-access
  USE_OPT = -Os -ggdb -fomit-frame-pointer -falign-functions=16 -mno-unaligned-access
endif

# C specific options here (added to USE_OPT).
ifeq ($(USE_COPT),)
  USE_COPT =
endif

# C++ specific options here (added to USE_OPT).
ifeq ($(USE_CPPOPT),)
  USE_CPPOPT = -fno-rtti
endif

# Enable this if you want the linker to remove unused code and data
ifeq ($(USE_LINK_GC),)
  USE_LINK_GC = yes
endif

# Linker extra options here.
ifeq ($(USE_LDOPT),)
  USE_LDOPT =
endif

# Enable this if you want link time optimizations (LTO)
ifeq ($(USE_LTO),)
  USE_LTO = no
endif

# If enabled, this option allows to compile the application in THUMB mode.
ifeq ($(USE_THUMB),)
  USE_THUMB = yes
endif

# Enable this if you want to see the full log while compiling.
ifeq ($(USE_VERBOSE_COMPILE),)
  USE_VERBOSE_COMPILE = no
endif

# Enable this if you want link time optimizations (LTO)
ifeq ($(USE_FPU),)
  USE_FPU = no
endif




#### Compiler Settings

MCU  = cortex-m4

TRGT = $(CCPATH)arm-none-eabi-
CC   = $(TRGT)gcc
CPPC = $(TRGT)g++
# Enable loading with g++ only if you need C++ runtime support.
# NOTE: You can use C++ even without C++ support if you are careful. C++
#       runtime support makes code size explode.
LD   = $(TRGT)gcc
#LD   = $(TRGT)g++
CP   = $(TRGT)objcopy
AS   = $(TRGT)gcc -x assembler-with-cpp
OD   = $(TRGT)objdump
SZ   = $(TRGT)size
HEX  = $(CP) -O ihex
BIN  = $(CP) -O binary

# ARM-specific options here
AOPT =

# THUMB-specific options here
TOPT = -mthumb -DTHUMB -mfloat-abi=hard -mfpu=fpv4-sp-d16 -mabi=aapcs --std=gnu99  -DNRF52

# Define C warning options here
CWARN = -Wall -Wextra -Wstrict-prototypes -Werror

# Define C++ warning options here
CPPWARN = -Wall -Wextra


#####
VHAL_PLATFORM=ARMCMx/nrf52
BOARD_CONFIG_DIR=boards/$(BOARD)/config
BOARD_LINKER_SCRIPT:=$(BOARD_CONFIG_DIR)/$(RTOS)/linker_script.ld

#include BOARD makefile

BOARD_SRC = boards/$(BOARD)/port.c
BOARD_INC = boards/$(BOARD)/ $(BOARD_CONFIG_DIR)/$(RTOS)

include $(BOARD_CONFIG_DIR)/$(RTOS)/custom.mk
BOARD_DEFS:=

BOARD_DRIVERS = $(foreach r,$(BOARD_EXT_DRIVERS),DRV_$(r))

BOARD_DEFS+= $(foreach df,$(BOARD_DRIVERS),-D$(df))
BOARD_DEFS+= $(foreach df,$(BOARD_DEFINES),-D$(df))

RTOS_AVAILABLE="NO"


######### FREERTOS 9
ifeq ($(RTOS),freertos9)

RTOS_AVAILABLE="YES"


OS_PLATFORM=nrf52
OS_HAL=nrf52
BOARD_DEFS+= -D__START=main -DVHAL_SYSTEM_INIT -DRTOS_IRQ_PROLOGUE -D__STARTUP_CLEAR_BSS -DUSE_APP_CONFIG=1 -DNRF52840_VHAL -DNRF52_RESET_PIN=18
FEAT_INC= $(BOARD_CONFIG_DIR)/$(RTOS)/standard

ifneq (,$(findstring nrf52_ble,$(VM_FEATURES)))
	FEAT_INC= $(BOARD_CONFIG_DIR)/$(RTOS)/nrf52_ble
	# ble basic support - s132
	BOARD_LINKER_SCRIPT:=$(BOARD_CONFIG_DIR)/$(RTOS)/linker_script_s132.ld
	BOARD_DEFS += -DMCU_FIXED_VTOR
	BOARD_DEFS += -D__STACK_SIZE=2048
	BOARD_DEFS += -DNRF52
	BOARD_DEFS += -DNRF52_PAN_64
	BOARD_DEFS += -DSOFTDEVICE_PRESENT
	BOARD_DEFS += -DBOARD_PCA10040
	BOARD_DEFS += -DNRF52840
	BOARD_DEFS += -D__HEAP_SIZE=1024
	BOARD_DEFS += -DNRF52_PAN_12
	BOARD_DEFS += -DNRF52_PAN_58
	BOARD_DEFS += -DNRF52_PAN_54
	BOARD_DEFS += -DNRF52_PAN_31
	BOARD_DEFS += -DNRF52_PAN_51
	BOARD_DEFS += -DNRF52_PAN_36
	BOARD_DEFS += -DFREERTOS
	BOARD_DEFS += -DCONFIG_GPIO_AS_PINRESET
	BOARD_DEFS += -DBLE_STACK_SUPPORT_REQD
	BOARD_DEFS += -DNRF52_PAN_15
	BOARD_DEFS += -DNRF_SD_BLE_API_VERSION=3
	BOARD_DEFS += -DNRF52_PAN_55
	BOARD_DEFS += -DNRF52_PAN_20
	BOARD_DEFS += -DS132
endif

BOARD_INC += $(FEAT_INC)

endif


ifeq ($(RTOS_AVAILABLE), NO)

$(error $(RTOS) not supported!)

endif
