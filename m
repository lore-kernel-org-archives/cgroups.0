From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 07/16] device connection: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:33 +0300
Message-ID: <20190508112842.11654-9-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjcT89AhZdKkG8M5isLXr+VAVcRFhlBYogTm1g/4pg8=;
 b=q7IP+9NQa5EDYubf+Njn1bcwKqmHVEVEGwgvxF4CCCebgPyhKgL87yUmH6oKqvITyTy7ly7BzqJF9CuibfYxh1CD7eVrjMoC5DQyzQjqpnGGsZvQUhXfV78CE1aOuzWdCyhisJf3G2Zqgl4Qabaoo9JYILLYMMWBWRQ5g29Xp+w=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The `device_connection` struct is defined as:
struct device_connection {
        struct fwnode_handle    *fwnode;
        const char              *endpoint[2];
        const char              *id;
        struct list_head        list;
};

The `endpoint` member is a static array of strings (on the struct), so
using the match_string() (which does an ARRAY_SIZE((con->endpoint)) should
be fine.

The recent change to match_string() (to ignore NULL entries up to the size
of the array) shouldn't affect this.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/base/devcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devcon.c b/drivers/base/devcon.c
index 7bc1c619b721..4a2338665585 100644
--- a/drivers/base/devcon.c
+++ b/drivers/base/devcon.c
@@ -70,7 +70,7 @@ void *device_connection_find_match(struct device *dev, const char *con_id,
 	mutex_lock(&devcon_lock);
 
 	list_for_each_entry(con, &devcon_list, list) {
-		ep = __match_string(con->endpoint, 2, devname);
+		ep = match_string(con->endpoint, devname);
 		if (ep < 0)
 			continue;
 
-- 
2.17.1

