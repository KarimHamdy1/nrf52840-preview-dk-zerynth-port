#include "vbl.h"
#include "port.h"
#include "lang.h"


#define NUM_PINS   12

#define PA PORT_A

PinStatus _vhalpinstatus[NUM_PINS];

#include "port.def"

VHAL_PORT_DECLARATIONS();


/* PERIPHERAL MAPS */

BEGIN_PERIPHERAL_MAP(serial) \
PERIPHERAL_ID(1), \
END_PERIPHERAL_MAP(serial);


const SerialPins const _vm_serial_pins[] STORED = {
    {RX0, TX0},
};


const SpiPins const _vm_spi_pins[] STORED = {
    

};

const I2CPins const _vm_i2c_pins[] STORED = {

};

const SdioPins const _vm_sdio_pins[] STORED = {
};

BEGIN_PERIPHERAL_MAP(spi) \

END_PERIPHERAL_MAP(spi);

BEGIN_PERIPHERAL_MAP(i2c) \

END_PERIPHERAL_MAP(i2c);

BEGIN_PERIPHERAL_MAP(adc) \

END_PERIPHERAL_MAP(adc);

BEGIN_PERIPHERAL_MAP(dac) \
END_PERIPHERAL_MAP(dac);

BEGIN_PERIPHERAL_MAP(can) \
END_PERIPHERAL_MAP(can);



BEGIN_PERIPHERAL_MAP(pwm) \

END_PERIPHERAL_MAP(pwm);


BEGIN_PERIPHERAL_MAP(icu) \

END_PERIPHERAL_MAP(icu);


BEGIN_PERIPHERAL_MAP(htm) \

END_PERIPHERAL_MAP(htm);

/* vbl layer */


void *begin_bytecode_storage(int size) {
    uint8_t *cm = codemem;
    // codemem already aligned to vm following sector through vbl_init
    if (vhalFlashErase(cm, size))
        return NULL;
    return cm;
}

void *bytecode_store(void *where, uint8_t *buf, uint16_t len) {
    if (((uint32_t)where)>=0x80000) return NULL; //avoid writing over 512k
    vhalFlashWrite(where, buf, len);
    return ((uint8_t*) where) + len;
}

void *end_bytecode_storage() {
    return 0;
}

void *vbl_get_adjusted_codemem(void *codemem) {
    return vhalFlashAlignToSector(codemem);
}
