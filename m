From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 3/3][V2] lib: re-introduce new match_string() helper/macro
Date: Tue, 28 May 2019 10:39:32 +0300
Message-ID: <20190528073932.25365-3-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190528073932.25365-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVygfSY8hqy/DBUvsHRCgGvieeoiCENlb8QcgTW8Qa0=;
 b=ug3p+80+pta3QSOyYVopWCIPknnTa/9XApeIFW+44+SXRahs8pvbg98CvxDZWD2q7UoHIhgUD6Sn7ZbGyOWHdj4WAzkhg9cumlMLts6dyltoEMjlw9eglOAVG8lj96mIW2ArwyzQcb/gVfwCJxWUUom9Q8RHLT+KaOaucx79tQQ=
In-Reply-To: <20190528073932.25365-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

This change re-introduces `match_string()` as a macro that uses
ARRAY_SIZE() to compute the size of the array.

After this change, work can start on migrating subsystems to use this new
helper. Since the original helper is pretty used, migrating to this new one
will take a while, and will be reviewed by each subsystem.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 include/linux/string.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 7149fcdf62df..34491b075449 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -198,6 +198,15 @@ static inline int strtobool(const char *s, bool *res)
 int __match_string(const char * const *array, size_t n, const char *string);
 int __sysfs_match_string(const char * const *array, size_t n, const char *s);
 
+/**
+ * match_string - matches given string in an array
+ * @_a: array of strings
+ * @_s: string to match with
+ *
+ * Helper for __match_string(). Calculates the size of @a automatically.
+ */
+#define match_string(_a, _s) __match_string(_a, ARRAY_SIZE(_a), _s)
+
 /**
  * sysfs_match_string - matches given string in an array
  * @_a: array of strings
-- 
2.20.1

