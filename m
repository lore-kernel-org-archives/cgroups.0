From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 04/16] powerpc/xmon: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:30 +0300
Message-ID: <20190508112842.11654-6-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+Io6nQDgXXj6vWzapFXKhuWEwCuQ7uYG1o8foVltUs=;
 b=OsAPAAdKA72ag6WEgtGuMxKaWxQ0gZIzCPsuAtgnnj/oFA0fbDHMGodRBcRefG9XbOE2g+Aq3eXHAUOgRsxbe9OUern7w4ZEKU1MFVRM944jQ4MmmTvJjEX5JVN0ZStKQwnZjTEaE6iWfqxBEGLRi5kjF9g1i+IhSA13dB4Oi0w=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>, 
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>, 
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, alsa-devel@alsa-project.org
Cc: gregkh@linuxfoundation.org, Alexandru Ardelean <alexandru.ardelean@analog.com>, andriy.shevchenko@linux.intel.com

The change is purely cosmetic at this point in time, but it does highlight
the change done in lib/string.c for match_string().

Particularly for this change, if a regname is removed (replaced with NULL)
in the list, the match_string() helper will continue until the end of the
array and ignore the NULL.
This would technically allow for "reserved" regs, though here it's not the
case.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 arch/powerpc/xmon/xmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index efca104ac0cb..b84a7fc1112b 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3231,7 +3231,7 @@ scanhex(unsigned long *vp)
 			regname[i] = c;
 		}
 		regname[i] = 0;
-		i = __match_string(regnames, N_PTREGS, regname);
+		i = match_string(regnames, regname);
 		if (i < 0) {
 			printf("invalid register name '%%%s'\n", regname);
 			return 0;
-- 
2.17.1
