From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 06/16] x86/mtrr: use new match_string() helper + add gaps == minor fix
Date: Wed, 8 May 2019 14:28:32 +0300
Message-ID: <20190508112842.11654-8-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peJzb31cm17ABrXFyc+VL8b8kWU6z5UpeWBKRx5iGOY=;
 b=Ht8Fm6RXFzi+Mh2C7TtDBrevghDIkKBBrf5hR26HEMHT3clXH+auLpcCAPlBDjunidMIf2KlMCOrIihkOj8RRHLgWzEWMMKXr0g4KWNemLVVhqUlyEjNr2yadJK+HpBmin3dfirgmdsGRBLIe+wQFsopNOyElR+2pj8AJZVAfxw=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

This change is a bit more than cosmetic.

It replaces 2 values in mtrr_strings with NULL. Previously, they were
defined as "?", which is not great because you could technically pass "?",
and you would get value 2.
It's not sure whether that was intended (likely it wasn't), but this fixes
that.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 arch/x86/kernel/cpu/mtrr/if.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 4ec7a5f7b94c..e67820a044cc 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -20,8 +20,8 @@ static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 {
 	"uncachable",		/* 0 */
 	"write-combining",	/* 1 */
-	"?",			/* 2 */
-	"?",			/* 3 */
+	NULL,			/* 2 */
+	NULL,			/* 3 */
 	"write-through",	/* 4 */
 	"write-protect",	/* 5 */
 	"write-back",		/* 6 */
@@ -29,7 +29,9 @@ static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 
 const char *mtrr_attrib_to_str(int x)
 {
-	return (x <= 6) ? mtrr_strings[x] : "?";
+	if ((x >= ARRAY_SIZE(mtrr_strings)) || (mtrr_strings[x] == NULL))
+		return "?";
+	return mtrr_strings[x];
 }
 
 #ifdef CONFIG_PROC_FS
@@ -142,7 +144,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 	ptr = skip_spaces(ptr + 5);
 
-	i = __match_string(mtrr_strings, MTRR_NUM_TYPES, ptr);
+	i = match_string(mtrr_strings, ptr);
 	if (i < 0)
 		return i;
 
-- 
2.17.1

