#include "lwdriv.h"

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>

static int __init lwdriv_init(void)
{
    return 0;
}

static void __exit lwdriv_exit(void)
{
    return;
}

module_init(lwdriv_init);
module_exit(lwdriv_exit);

MODULE_LICENSE("MIT");
MODULE_AUTHOR("Rin E. Baudelet");
MODULE_DESCRIPTION("LoRa Module Driver for EBYTE E22-900T22S");
MODULE_VERSION("1.0");