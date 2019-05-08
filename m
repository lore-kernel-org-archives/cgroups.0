From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 11/16] mm/vmpressure.c: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:37 +0300
Message-ID: <20190508112842.11654-13-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ANUS/cN4JJVZq6SdOb8BTq0Q8zTyuGFxo7xS+ekZas=;
 b=YAlgegs92dk0EBLrPaSAvAEoW+a6ILmnKzEUjwH9tQEsaafIGj/Jbgvg9FfspO4AAB0mHpi+xLxqThyb3jNrDhjwFUrYCAkX4mmKxh0huvawVaQ4qJsf1twnbtqNI/QY/ocFBuZ92YZHpWBwOZalU5NYJYyYwmli40Iiko9jix8=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

__match_string() is called on 2 static array of strings in this file. For
this reason, the conversion to the new match_string() macro/helper, was
done in this separate commit.

Using the new match_string() helper is mostly a cosmetic change (at this
point in time). The sizes of the arrays will be computed automatically,
which would only help if they ever get expanded.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 mm/vmpressure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d43f33139568..b8149924f078 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -378,7 +378,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 
 	/* Find required level */
 	token = strsep(&spec, ",");
-	level = __match_string(vmpressure_str_levels, VMPRESSURE_NUM_LEVELS, token);
+	level = match_string(vmpressure_str_levels, token);
 	if (level < 0) {
 		ret = level;
 		goto out;
@@ -387,7 +387,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 	/* Find optional mode */
 	token = strsep(&spec, ",");
 	if (token) {
-		mode = __match_string(vmpressure_str_modes, VMPRESSURE_NUM_MODES, token);
+		mode = match_string(vmpressure_str_modes, token);
 		if (mode < 0) {
 			ret = mode;
 			goto out;
-- 
2.17.1

