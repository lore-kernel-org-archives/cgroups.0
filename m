From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 09/16] mmc: sdhci-xenon: use new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:35 +0300
Message-ID: <20190508112842.11654-11-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2kUTxOBDW7W13uwOdmuJPQDQWhKkMs+dI0VfMHNhcs=;
 b=HmsHAFljmcbaN1BpAlIGHCpGcJ5jk39AUEqf/6w5Fch3rgS9LrOHdDkTRid4twIc316F2MrfuNLVkUGQ1NWLbgumQMbITyYa+XILsOarTTI+P/wjFyGQgnt0YjzNFAD0f6jVnTLQ0U3CRal0YHtfYbnJ7fVybRtPPhSGo+MDAbc=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The change is also cosmetic, but it also does a tighter coupling between
the enums & the string values. This way, the ARRAY_SIZE(phy_types) that is
implicitly done in the match_string() macro is also a bit safer.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/mmc/host/sdhci-xenon-phy.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci-xenon-phy.c b/drivers/mmc/host/sdhci-xenon-phy.c
index 59b7a6cac995..2a9206867fe1 100644
--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -135,17 +135,17 @@ struct xenon_emmc_phy_regs {
 	u32 logic_timing_val;
 };
 
-static const char * const phy_types[] = {
-	"emmc 5.0 phy",
-	"emmc 5.1 phy"
-};
-
 enum xenon_phy_type_enum {
 	EMMC_5_0_PHY,
 	EMMC_5_1_PHY,
 	NR_PHY_TYPES
 };
 
+static const char * const phy_types[NR_PHY_TYPES] = {
+	[EMMC_5_0_PHY] = "emmc 5.0 phy",
+	[EMMC_5_1_PHY] = "emmc 5.1 phy"
+};
+
 enum soc_pad_ctrl_type {
 	SOC_PAD_SD,
 	SOC_PAD_FIXED_1_8V,
@@ -821,7 +821,7 @@ static int xenon_add_phy(struct device_node *np, struct sdhci_host *host,
 	struct xenon_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
-	priv->phy_type = __match_string(phy_types, NR_PHY_TYPES, phy_name);
+	priv->phy_type = match_string(phy_types, phy_name);
 	if (priv->phy_type < 0) {
 		dev_err(mmc_dev(host->mmc),
 			"Unable to determine PHY name %s. Use default eMMC 5.1 PHY\n",
-- 
2.17.1

