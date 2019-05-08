From: Alexandru Ardelean <alexandru.ardelean-OyLXuOCK7orQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Date: Wed, 8 May 2019 14:28:29 +0300
Message-ID: <20190508112842.11654-5-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h8/OM7WIJ2+B7PQh5VU5won9TYo5K6loDOmlI1d0MY=;
 b=QfgnDHDVF0bpE3Lq1ne8goyHiQYLwG2dRTorIyjw235b+zmgtG2P71WpCb6/Klt10mquueyrN4BIY6989T4HneNxSCuLAVuL5tZEncHFbK/hLHSChzZsF3poHMTjUMp/nL0EVqhd2ixDaQizNevQAl7+Prw0KvOZ4UOnrvnMQ3o=
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean-OyLXuOCK7orQT0dZR+AlfA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-clk-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rpi-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Alexandru Ardelean <alexandru.ardelean-OyLXuOCK7orQT0dZR+AlfA@public.gmane.org>

This change re-introduces `match_string()` as a macro that uses
ARRAY_SIZE() to compute the size of the array.
The macro is added in all the places that do
`match_string(_a, ARRAY_SIZE(_a), s)`, since the change is pretty
straightforward.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean-OyLXuOCK7orQT0dZR+AlfA@public.gmane.org>
---
 drivers/clk/bcm/clk-bcm2835.c                    | 4 +---
 drivers/gpio/gpiolib-of.c                        | 2 +-
 drivers/gpu/drm/i915/intel_pipe_crc.c            | 2 +-
 drivers/mfd/omap-usb-host.c                      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
 drivers/pci/pcie/aer.c                           | 2 +-
 drivers/usb/common/common.c                      | 4 ++--
 drivers/usb/typec/class.c                        | 8 +++-----
 drivers/usb/typec/tps6598x.c                     | 2 +-
 drivers/vfio/vfio.c                              | 4 +---
 include/linux/string.h                           | 9 +++++++++
 sound/firewire/oxfw/oxfw.c                       | 2 +-
 sound/soc/codecs/max98088.c                      | 2 +-
 sound/soc/codecs/max98095.c                      | 2 +-
 14 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index a775f6a1f717..1ab388590ead 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1390,9 +1390,7 @@ static struct clk_hw *bcm2835_register_clock(struct bcm2835_cprman *cprman,
 	for (i = 0; i < data->num_mux_parents; i++) {
 		parents[i] = data->parents[i];
 
-		ret = __match_string(cprman_parent_names,
-				     ARRAY_SIZE(cprman_parent_names),
-				     parents[i]);
+		ret = match_string(cprman_parent_names, parents[i]);
 		if (ret >= 0)
 			parents[i] = cprman->real_parent_names[ret];
 	}
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 27d6f04ab58e..71e886869d78 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -279,7 +279,7 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
 	if (!con_id)
 		return ERR_PTR(-ENOENT);
 
-	i = __match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
+	i = match_string(whitelist, con_id);
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
index 286fad1f0e08..6fc4f3d3d1f6 100644
--- a/drivers/gpu/drm/i915/intel_pipe_crc.c
+++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
@@ -449,7 +449,7 @@ display_crc_ctl_parse_source(const char *buf, enum intel_pipe_crc_source *s)
 		return 0;
 	}
 
-	i = __match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
+	i = match_string(pipe_crc_sources, buf);
 	if (i < 0)
 		return i;
 
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9aaacb5bdb26..53dff34c0afc 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -509,7 +509,7 @@ static int usbhs_omap_get_dt_pdata(struct device *dev,
 			continue;
 
 		/* get 'enum usbhs_omap_port_mode' from port mode string */
-		ret = __match_string(port_modes, ARRAY_SIZE(port_modes), mode);
+		ret = match_string(port_modes, mode);
 		if (ret < 0) {
 			dev_warn(dev, "Invalid port%d-mode \"%s\" in device tree\n",
 					i, mode);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 59ce3ff35553..778b4dfd8b75 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -667,7 +667,7 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	};
 	int ret, bt_force_ant_mode;
 
-	ret = __match_string(modes_str, ARRAY_SIZE(modes_str), buf);
+	ret = match_string(modes_str, buf);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 41a0773a1cbc..2278caba109c 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -203,7 +203,7 @@ void pcie_ecrc_get_policy(char *str)
 {
 	int i;
 
-	i = __match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
+	i = match_string(ecrc_policy_str, str);
 	if (i < 0)
 		return;
 
diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index bca0c404c6ca..5a651d311d38 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -68,7 +68,7 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = __match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = match_string(speed_names, maximum_speed);
 
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
@@ -106,7 +106,7 @@ static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
 {
 	int ret;
 
-	ret = __match_string(usb_dr_modes, ARRAY_SIZE(usb_dr_modes), str);
+	ret = match_string(usb_dr_modes, str);
 	return (ret < 0) ? USB_DR_MODE_UNKNOWN : ret;
 }
 
diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 4abc5a76ec51..38ac776cba8a 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1409,8 +1409,7 @@ EXPORT_SYMBOL_GPL(typec_set_pwr_opmode);
  */
 int typec_find_port_power_role(const char *name)
 {
-	return __match_string(typec_port_power_roles,
-			      ARRAY_SIZE(typec_port_power_roles), name);
+	return match_string(typec_port_power_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_power_role);
 
@@ -1424,7 +1423,7 @@ EXPORT_SYMBOL_GPL(typec_find_port_power_role);
  */
 int typec_find_power_role(const char *name)
 {
-	return __match_string(typec_roles, ARRAY_SIZE(typec_roles), name);
+	return match_string(typec_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_power_role);
 
@@ -1438,8 +1437,7 @@ EXPORT_SYMBOL_GPL(typec_find_power_role);
  */
 int typec_find_port_data_role(const char *name)
 {
-	return __match_string(typec_port_data_roles,
-			      ARRAY_SIZE(typec_port_data_roles), name);
+	return match_string(typec_port_data_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_data_role);
 
diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index 0389e4391faf..0c4e47868590 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -423,7 +423,7 @@ static int tps6598x_check_mode(struct tps6598x *tps)
 	if (ret)
 		return ret;
 
-	switch (__match_string(modes, ARRAY_SIZE(modes), mode)) {
+	switch (match_string(modes, mode)) {
 	case TPS_MODE_APP:
 		return 0;
 	case TPS_MODE_BOOT:
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b31585ecf48f..fe8283d3781b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -637,9 +637,7 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
 			return true;
 	}
 
-	return __match_string(vfio_driver_whitelist,
-			      ARRAY_SIZE(vfio_driver_whitelist),
-			      drv->name) >= 0;
+	return match_string(vfio_driver_whitelist, drv->name) >= 0;
 }
 
 /*
diff --git a/include/linux/string.h b/include/linux/string.h
index 531d04308ff9..07e9f89088df 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -194,6 +194,15 @@ static inline int strtobool(const char *s, bool *res)
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
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 9ec5316f3bb5..433fc84c4f90 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -57,7 +57,7 @@ static bool detect_loud_models(struct fw_unit *unit)
 	if (err < 0)
 		return false;
 
-	return __match_string(models, ARRAY_SIZE(models), model) >= 0;
+	return match_string(models, model) >= 0;
 }
 
 static int name_card(struct snd_oxfw *oxfw)
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 3ef743075bda..911ffe84c37e 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1405,7 +1405,7 @@ static int max98088_get_channel(struct snd_soc_component *component, const char
 {
 	int ret;
 
-	ret = __match_string(eq_mode_name, ARRAY_SIZE(eq_mode_name), name);
+	ret = match_string(eq_mode_name, name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad EQ channel name '%s'\n", name);
 	return ret;
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index cd69916d5dcb..d182d45d0c83 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1636,7 +1636,7 @@ static int max98095_get_bq_channel(struct snd_soc_component *component,
 {
 	int ret;
 
-	ret = __match_string(bq_mode_name, ARRAY_SIZE(bq_mode_name), name);
+	ret = match_string(bq_mode_name, name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad biquad channel name '%s'\n", name);
 	return ret;
-- 
2.17.1

