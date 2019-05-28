From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/3][V2] lib: fix match_string() helper on -1 array size
Date: Tue, 28 May 2019 10:39:30 +0300
Message-ID: <20190528073932.25365-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWdImhCfyTIUCYzNfD1iIQYARnPSsxhTsT74g8CuXY0=;
 b=Hq4eM0+YUiVIoYHYAGGuEpOyjhWPdcPFHxn0lkng78s7kuN0jDXksfvZQE0kEOvNPTuar+4Cwfyt9c47tyog14C+ba401xryJ9s5hnJiPDekCnghCGKZj4HeQKs4EbPbnH2B4kKA0p9wn6It0lmbB4CJ95H2YYd7PUpoLM2vyVQ=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The documentation the `_match_string()` helper mentions that `n`
should be:
 * @n: number of strings in the array or -1 for NULL terminated arrays

The behavior of the function is different, in the sense that it exits on
the first NULL element in the array, regardless of whether `n` is -1 or a
positive number.

This patch changes the behavior, to exit the loop when a NULL element is
found and n == -1. Essentially, this aligns the behavior with the
doc-string.

There are currently many users of `match_string()`, and so, in order to go
through them, the next patches in the series will focus on doing some
cosmetic changes, which are aimed at grouping the users of
`match_string()`.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v1 -> v2:
* split the initial series into just 3 patches that fix the
  `match_string()` helper and start introducing a new version of this
  helper, which computes array-size of static arrays

 lib/string.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 6016eb3ac73d..e2cf5acc83bd 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -681,8 +681,11 @@ int match_string(const char * const *array, size_t n, const char *string)
 
 	for (index = 0; index < n; index++) {
 		item = array[index];
-		if (!item)
+		if (!item) {
+			if (n != (size_t)-1)
+				continue;
 			break;
+		}
 		if (!strcmp(item, string))
 			return index;
 	}
-- 
2.20.1

