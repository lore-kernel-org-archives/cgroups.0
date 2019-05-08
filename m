From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 08/16] cpufreq/intel_pstate: remove NULL entry + use match_string()
Date: Wed, 8 May 2019 14:28:34 +0300
Message-ID: <20190508112842.11654-10-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TppapvdTdEWShhGPGCPSH9uz8QgU5Op8E8ytcSMFOwg=;
 b=OQVIVgK5JxJMqIfsuBpJyNhsOscNjrf8QoWcS71HKHv5ECSFl4t6qL8cjbEvHO9onyxqCP7Eiq7Wxh8YLQX/ufSvCV0VABMsC9ZaqNqGS8uuuvsMFWUm0Wa0qvupkiH+emRfafnbKdPIl4OkQQXlSvhfm9OK1pHqR4K81+Fv0Z8=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The change is mostly cosmetic.

The `energy_perf_strings` array is static, so match_string() can be used
(which will implicitly do a ARRAY_SIZE(energy_perf_strings)).

The only small benefit here, is the reduction of the array size by 1
element.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/cpufreq/intel_pstate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 6ed1e705bc05..ab9a0b34b900 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -593,8 +593,7 @@ static const char * const energy_perf_strings[] = {
 	"performance",
 	"balance_performance",
 	"balance_power",
-	"power",
-	NULL
+	"power"
 };
 static const unsigned int epp_values[] = {
 	HWP_EPP_PERFORMANCE,
@@ -680,8 +679,8 @@ static ssize_t show_energy_performance_available_preferences(
 	int i = 0;
 	int ret = 0;
 
-	while (energy_perf_strings[i] != NULL)
-		ret += sprintf(&buf[ret], "%s ", energy_perf_strings[i++]);
+	for (; i < ARRAY_SIZE(energy_perf_strings); i++)
+		ret += sprintf(&buf[ret], "%s ", energy_perf_strings[i]);
 
 	ret += sprintf(&buf[ret], "\n");
 
@@ -701,7 +700,7 @@ static ssize_t store_energy_performance_preference(
 	if (ret != 1)
 		return -EINVAL;
 
-	ret = __match_string(energy_perf_strings, -1, str_preference);
+	ret = match_string(energy_perf_strings, str_preference);
 	if (ret < 0)
 		return ret;
 
-- 
2.17.1

