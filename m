From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 00/16] treewide: fix match_string() helper when array size
Date: Wed, 8 May 2019 14:28:25 +0300
Message-ID: <20190508112842.11654-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mREEcazEV2TFx5JIFnH3pAzE1JX52Mxgf7Nke2hFVA=;
 b=qQfQKlBUhqrL+3Zq0CNfpq26DFQMQ47XeDeoOQghyt8YnFxihdOyu/uqLTp4Va2PKJok0DnLUK74RKCRbvROk2XuKOdS1aEBpBZ7S2HyRHxL7vRH6SPzukskQpsFHAO8LtN/Vyu7cA1xYW8YkqaoD+LlmFfxVsALjqdbrsDXj/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, Alexandru Ardelean <alexandru.ardelean@analog.com>

The intent of this patch series is to make a case for fixing the
match_string() string helper.

The doc-string of the `__sysfs_match_string()` helper mentions that `n`
(the size of the given array) should be:
 * @n: number of strings in the array or -1 for NULL terminated arrays

However, this is not the case.
The helper stops on the first NULL in the array, regardless of whether -1
is provided or not.

There are some advantages to allowing this behavior (NULL elements within
in the array). One example, is to allow reserved registers as NULL in an
array.
One example in the series is patch:
   x86/mtrr: use new match_string() helper + add gaps == minor fix
which uses a "?" string for values that are reserved/don't care.

Since the change is a bit big, the change was coupled with renaming
match_string() -> __match_string().
The new match_string() helper (resulted here) does an ARRAY_SIZE() over the
array, which is useful when the array is static. 

Also, this way of doing things is a way to go through all the users of this
helpers and check that nothing goes wrong, and notify them about the change
to match_string().
It's a way of grouping changes in a manage-able way.

The first patch is important, the others can be dropped.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Alexandru Ardelean (16):
  lib: fix match_string() helper when array size is positive
  treewide: rename match_string() -> __match_string()
  lib,treewide: add new match_string() helper/macro
  powerpc/xmon: use new match_string() helper/macro
  ALSA: oxygen: use new match_string() helper/macro
  x86/mtrr: use new match_string() helper + add gaps == minor fix
  device connection: use new match_string() helper/macro
  cpufreq/intel_pstate: remove NULL entry + use match_string()
  mmc: sdhci-xenon: use new match_string() helper/macro
  pinctrl: armada-37xx: use new match_string() helper/macro
  mm/vmpressure.c: use new match_string() helper/macro
  rdmacg: use new match_string() helper/macro
  drm/edid: use new match_string() helper/macro
  staging: gdm724x: use new match_string() helper/macro
  video: fbdev: pxafb: use new match_string() helper/macro
  sched: debug: use new match_string() helper/macro

 arch/powerpc/xmon/xmon.c                         |  2 +-
 arch/x86/kernel/cpu/mtrr/if.c                    | 10 ++++++----
 drivers/ata/pata_hpt366.c                        |  2 +-
 drivers/ata/pata_hpt37x.c                        |  2 +-
 drivers/base/devcon.c                            |  2 +-
 drivers/base/property.c                          |  2 +-
 drivers/clk/bcm/clk-bcm2835.c                    |  4 +---
 drivers/clk/clk.c                                |  4 ++--
 drivers/clk/rockchip/clk.c                       |  4 ++--
 drivers/cpufreq/intel_pstate.c                   |  9 ++++-----
 drivers/gpio/gpiolib-of.c                        |  2 +-
 drivers/gpu/drm/drm_edid_load.c                  |  2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c   |  2 +-
 drivers/gpu/drm/i915/intel_pipe_crc.c            |  2 +-
 drivers/ide/hpt366.c                             |  2 +-
 drivers/mfd/omap-usb-host.c                      |  2 +-
 drivers/mmc/host/sdhci-xenon-phy.c               | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  2 +-
 drivers/pci/pcie/aer.c                           |  2 +-
 drivers/phy/tegra/xusb.c                         |  2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c      |  4 ++--
 drivers/pinctrl/pinmux.c                         |  2 +-
 drivers/power/supply/ab8500_btemp.c              |  2 +-
 drivers/power/supply/ab8500_charger.c            |  2 +-
 drivers/power/supply/ab8500_fg.c                 |  2 +-
 drivers/power/supply/abx500_chargalg.c           |  2 +-
 drivers/power/supply/charger-manager.c           |  4 ++--
 drivers/staging/gdm724x/gdm_tty.c                |  3 +--
 drivers/usb/common/common.c                      |  4 ++--
 drivers/usb/typec/class.c                        |  8 +++-----
 drivers/usb/typec/tps6598x.c                     |  2 +-
 drivers/vfio/vfio.c                              |  4 +---
 drivers/video/fbdev/pxafb.c                      |  4 ++--
 fs/ubifs/auth.c                                  |  4 ++--
 include/linux/string.h                           | 11 ++++++++++-
 kernel/cgroup/rdma.c                             |  2 +-
 kernel/sched/debug.c                             |  2 +-
 kernel/trace/trace.c                             |  2 +-
 lib/string.c                                     | 13 ++++++++-----
 mm/mempolicy.c                                   |  2 +-
 mm/vmpressure.c                                  |  4 ++--
 security/apparmor/lsm.c                          |  4 ++--
 security/integrity/ima/ima_main.c                |  2 +-
 sound/firewire/oxfw/oxfw.c                       |  2 +-
 sound/pci/oxygen/oxygen_mixer.c                  |  2 +-
 sound/soc/codecs/max98088.c                      |  2 +-
 sound/soc/codecs/max98095.c                      |  2 +-
 sound/soc/soc-dapm.c                             |  2 +-
 48 files changed, 88 insertions(+), 82 deletions(-)

-- 
2.17.1

