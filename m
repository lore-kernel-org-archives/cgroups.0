From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 14/16] staging: gdm724x: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:40 +0300
Message-ID: <20190508112842.11654-16-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onHX/dH28+rcBydCYnxXPPy3B5aZvm8nUVopYvgTR/U=;
 b=TRWzaKL5QJNYiXbG+2Oe8fjWtJL+uaSZN7I1Y1mLvIYHbJGfd+k3GEWsuHa6f8MH3o5FyiU8BEW81HV8R20GJd4CjUz2a3wrhgxNZAp7on9a1AKqAYFUNkner8pEKTAQX+E2T5W2P3Av5RpjeoV1wIG/TVCkFL8QTjk7xwoghyE=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The `DRIVER_STRING` array is a static array of strings.
Using match_string() (which computes the array size via ARRAY_SIZE())
is possible.

The change is mostly cosmetic.
No functionality change.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/staging/gdm724x/gdm_tty.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index 6e147a324652..81dd6795599f 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -56,8 +56,7 @@ static int gdm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 	struct gdm *gdm = NULL;
 	int ret;
 
-	ret = __match_string(DRIVER_STRING, TTY_MAX_COUNT,
-			     tty->driver->driver_name);
+	ret = match_string(DRIVER_STRING, tty->driver->driver_name);
 	if (ret < 0)
 		return -ENODEV;
 
-- 
2.17.1

