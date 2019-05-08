From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 10/16] pinctrl: armada-37xx: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:36 +0300
Message-ID: <20190508112842.11654-12-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1chwJ3hc4UTJ3blAlYUngE824WdNkP//hIXWmk1Ja8A=;
 b=DrUwW+HfBrwsEl2in+cz4S+PdeJEOhXU7fVfQQf7K1/7Bu4CQyX95NdYXd/oxxKLzmfA94Sp9RgysVQgxHHyK+aXVQgutw8CgBlEx5J1hG33ICxZPO0+0bHw7kb6PXGJmCSPuSxrDr+dHRaQH2ilSb5oPUIKVnknHgETTrV7qvg=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The change is mostly cosmetic.

The `armada_37xx_pin_group` struct is defined as.
struct armada_37xx_pin_group {
        const char      *name;
        unsigned int    start_pin;
        unsigned int    npins;
        u32             reg_mask;
        u32             val[NB_FUNCS];
        unsigned int    extra_pin;
        unsigned int    extra_npins;
        const char      *funcs[NB_FUNCS];
        unsigned int    *pins;
};

The `funcs` field is a static array of strings, so using the
new `match_string()` helper (which does an implicit ARRAY_SIZE(gp->funcs))
should be fine.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 07a5bcaa0067..68b0db5ef5e9 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -348,7 +348,7 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 	dev_dbg(info->dev, "enable function %s group %s\n",
 		name, grp->name);
 
-	func = __match_string(grp->funcs, NB_FUNCS, name);
+	func = match_string(grp->funcs, name);
 	if (func < 0)
 		return -ENOTSUPP;
 
@@ -938,7 +938,7 @@ static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 			struct armada_37xx_pin_group *gp = &info->groups[g];
 			int f;
 
-			f = __match_string(gp->funcs, NB_FUNCS, name);
+			f = match_string(gp->funcs, name);
 			if (f < 0)
 				continue;
 
-- 
2.17.1

