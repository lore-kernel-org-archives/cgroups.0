Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA063EBF02
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 12:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523508; cv=none; b=ZqVGBguUkLEb1iK86+I9eYMFL4LI3fNDMpr0/u+fU1GaO7tERccjOnkSyhhWxY1P/MTmnWmvDYdEI2qh+hZNSY8zKWkUlqrTtzTyEj3bgwO3F3dgyxmBT5mzYlJG2CEAZqlxqhitz4I/ppqcTIA9leZvUQ8WnB9bw3r1IR2cpYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523508; c=relaxed/simple;
	bh=u6CwvKtKbxGb94KNNInB0ME1wFlLQKJNElP12kgNJLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIyUByiEHfKFtJOw0KKDbvPePmUUg46l5/XrBVI1FzCBKsFCS8HFTBNAgaCWRjOhvPz3fDkRGQp7PExRyKhErHjTkg5zj2vjV/6AxzUaTfbnCp1HilIqayaKOWHPd5vI5+fKPrxl1FsI5KPtEfzpRIDE5dXUNDjgtL2t3WCR9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rKrZaulb; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rKrZaulb"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4a451915d8aso918171b6e.2
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 05:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788523503; x=1789128303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PNNoFm9of+XfonKeu3L8JaVXpKDag7iEGaODT3DaPL4=;
        b=rKrZaulbpQAIiaa0AHIa9ya8s48dImkfZRAGpgyndyVFkLxtfm71GY9x13z8vTGwmK
         //EbV0VTAP8g2tjJD3NqyUB9/qLjO0+B+S5yqoS9pLbMaVOjQ9EUJfrRaymD6b1X05uw
         X3kT5ggbKbFeF2/vxaKLOt0Vk4RpWkm9ToDyZdWsPl7Hx6pc1Elefacx4wKfmoNSLkdj
         9kmJmO1NK+hTfiU4K3aCq1b5KQlkTLWnJK9wy2T2mZy4pKLZQMqlONz3aW0e6Os956oO
         gtweBRhVsQuUD1qd3nYJE7g44sf7d/kXo1g+kehsH4X3Y5U2XAw2FvZ6RF4xHZoTbliV
         FJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788523503; x=1789128303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PNNoFm9of+XfonKeu3L8JaVXpKDag7iEGaODT3DaPL4=;
        b=sytEY79dXl0qWSkTPH08LyMZR6IximpUYJNk9uuNPADQk0+q60bRPC45XOXcfUJJYk
         wXLBkemH4QWovC/zVVsh/NU2A4SQ2WHGBN2vUb2hwIleG8bF7utV8smtkXXpHjO7KPiH
         264Nq4JABR3mgXCKPar7semEe6I4enIq33OallbuJ/aPMzSi0n2ENccWTlXhtTer8zQ/
         c+5VvWY7ZxeF/dU1FlV5uuTnlnA65D1Z8a6TtUIqTnN8CWkI1dzcPRxflDJWMevwLHbf
         FfnuFFVmVTB2nm+dLIN4T823FXRBo3SObsGdJ1s77FS5uHQntSZ3PpPhmwda1NHU5R15
         vCRw==
X-Forwarded-Encrypted: i=1; AKwUvBzbhSFZKPA1tZH/uLYjteuIFhAK3FPjCtC8MWmU3FEITIs9j8rBKtCAv7tvDa3TjTohn/O9JBUT@vger.kernel.org
X-Gm-Message-State: AFuF++nK9zmWVjyYtpgfLXyFT0zK/udTTenG/AcpL5J/ze4cab5fV6fD
	QnqkZyPHEBn0kHWcerpidU+Mh84PgQ5kTA3cq2Y9zAzKFdqOL7rlwGUw
X-Gm-Gg: AYBFou1CzDeGJKfDQq4jtTbXhG/7kteKFMIHPW9UTr6++0rOtq8uHDBUJM7E5YdOZ5L
	HogvOjKBFQNyiL6Rf7wO1MzyIMJBqilaL19oirf5aHEnzjMS3xsy8shMaGlXyTimvFfLC/4fYKm
	e/PwT/hF2SvL054hqYNAS/w65UamR+cpwuY0NZlJS6F0aLdjAYUADO/4iSzNqG6g6B7dqfyVker
	2tf9ItWaFXr/365zwVPBIRSaHS40BPdCbvYU47vmyYitCaQwlrGn/a7lEyn/QjutTz4K/AQD8Q9
	3HWnX8/ep4gkpKl4BTA7YMpRzsawXxybgI6Wyg69sscuTvxbQDgC5aS3NeNQOTwdbqLiey3m6W9
	qQFxk+Cg9dW11Rnh/6dyIYoMZrBb7hmFY7Akp0z8JVlU5Mji65D4mQEHZoWLbDqEqZeeWtsBe/l
	cWEuj5fQwasC7sFmOmCHA6mcKjMrY7Mv23psPkeQfKiAJvEhR0dfiujzKBPmDLMRGABDkbhZLJa
	edvZIO0TehGZh4=
X-Received: by 2002:a05:6820:1622:b0:6b3:5475:4855 with SMTP id 006d021491bc7-6b6fcfddf2dmr4016086eaf.31.1788523502822;
        Fri, 04 Sep 2026 05:05:02 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f787esm5770422eec.23.2026.09.04.05.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:05:02 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Inki Dae <inki.dae@samsung.com>,
	Jagan Teki <jagan@amarulasolutions.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Mingcong Bai <jeffbai@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Samuel Holland <samuel@sholland.org>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Michal Simek <michal.simek@amd.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	nouveau@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	spice-devel@lists.freedesktop.org,
	linux-renesas-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	cgroups@vger.kernel.org
Subject: [PATCH 1/3] drm: fix typos in comments
Date: Fri,  4 Sep 2026 17:34:16 +0530
Message-ID: <20260904120430.17224-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904120430.17224-1-hemanth.selam@gmail.com>
References: <20260904120430.17224-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/dma-buf/sync_debug.h                           | 2 +-
 drivers/gpu/drm/bridge/parade-ps8622.c                 | 2 +-
 drivers/gpu/drm/bridge/samsung-dsim.c                  | 2 +-
 drivers/gpu/drm/bridge/tc358767.c                      | 6 +++---
 drivers/gpu/drm/display/drm_dp_mst_topology.c          | 2 +-
 drivers/gpu/drm/drm_drv.c                              | 2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c                 | 2 +-
 drivers/gpu/drm/gma500/power.c                         | 2 +-
 drivers/gpu/drm/gma500/psb_drv.h                       | 4 ++--
 drivers/gpu/drm/imx/dcss/dcss-ctxld.c                  | 2 +-
 drivers/gpu/drm/loongson/lsdc_drv.c                    | 2 +-
 drivers/gpu/drm/mgag200/mgag200_g200se.c               | 2 +-
 drivers/gpu/drm/nouveau/dispnv50/tile.h                | 2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c                 | 2 +-
 drivers/gpu/drm/nouveau/nouveau_exec.c                 | 2 +-
 drivers/gpu/drm/nouveau/nouveau_led.c                  | 2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c       | 2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c         | 2 +-
 drivers/gpu/drm/omapdrm/dss/dispc.c                    | 4 ++--
 drivers/gpu/drm/omapdrm/omap_gem.c                     | 2 +-
 drivers/gpu/drm/panel/panel-novatek-nt36672a.c         | 2 +-
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c       | 2 +-
 drivers/gpu/drm/qxl/qxl_gem.c                          | 2 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c            | 2 +-
 drivers/gpu/drm/scheduler/sched_main.c                 | 4 ++--
 drivers/gpu/drm/sun4i/sun4i_tcon.c                     | 2 +-
 drivers/gpu/drm/tiny/panel-mipi-dbi.c                  | 2 +-
 drivers/gpu/drm/ttm/ttm_pool.c                         | 2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                         | 2 +-
 drivers/gpu/drm/vc4/vc4_regs.h                         | 2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                 | 2 +-
 drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h | 2 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                    | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                    | 6 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                    | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_so.h                     | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                | 2 +-
 drivers/gpu/drm/xlnx/zynqmp_dp.c                       | 2 +-
 drivers/gpu/ipu-v3/ipu-prg.c                           | 2 +-
 include/drm/drm_framebuffer.h                          | 4 ++--
 include/drm/drm_plane.h                                | 2 +-
 include/uapi/drm/nouveau_drm.h                         | 2 +-
 include/uapi/drm/vmwgfx_drm.h                          | 2 +-
 kernel/cgroup/dmem.c                                   | 2 +-
 45 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/dma-buf/sync_debug.h b/drivers/dma-buf/sync_debug.h
index c49324505b20..1ab25d323da4 100644
--- a/drivers/dma-buf/sync_debug.h
+++ b/drivers/dma-buf/sync_debug.h
@@ -1,5 +1,5 @@
 /*
- * Sync File validation framework and debug infomation
+ * Sync File validation framework and debug information
  *
  * Copyright (C) 2012 Google, Inc.
  *
diff --git a/drivers/gpu/drm/bridge/parade-ps8622.c b/drivers/gpu/drm/bridge/parade-ps8622.c
index 3a2ec482037d..709f67f7009b 100644
--- a/drivers/gpu/drm/bridge/parade-ps8622.c
+++ b/drivers/gpu/drm/bridge/parade-ps8622.c
@@ -360,7 +360,7 @@ static void ps8622_pre_enable(struct drm_bridge *bridge,
 	 * enable the lcd/ps8622 fet. T2 is the range of time in which the
 	 * data sheet specifies we should deassert the reset pin.
 	 *
-	 * If it takes T1.max for the power to rise, we need to wait atleast
+	 * If it takes T1.max for the power to rise, we need to wait at least
 	 * T2.min before deasserting the reset pin. If it takes T1.min for the
 	 * power to rise, we need to wait at most T2.max before deasserting the
 	 * reset pin.
diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index e2fc69fc51b6..76c81c10411e 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -1116,7 +1116,7 @@ static int samsung_dsim_init_link(struct samsung_dsim *dsi)
 	 * Use non-continuous clock mode if the periparal wants and
 	 * host controller supports
 	 *
-	 * In non-continous clock mode, host controller will turn off
+	 * In non-continuous clock mode, host controller will turn off
 	 * the HS clock between high-speed transmissions to reduce
 	 * power consumption.
 	 */
diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index e3a57f8228da..38323fc2a86e 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1640,7 +1640,7 @@ static int tc_dpi_atomic_check(struct drm_bridge *bridge,
 
 	crtc_state->adjusted_mode.clock = adjusted_clock / 1000;
 
-	/* DSI->DPI interface clock limitation: upto 100 MHz */
+	/* DSI->DPI interface clock limitation: up to 100 MHz */
 	if (crtc_state->adjusted_mode.clock > 100000)
 		return -EINVAL;
 
@@ -1664,7 +1664,7 @@ static int tc_edp_atomic_check(struct drm_bridge *bridge,
 
 	crtc_state->adjusted_mode.clock = adjusted_clock / 1000;
 
-	/* DPI->(e)DP interface clock limitation: upto 154 MHz */
+	/* DPI->(e)DP interface clock limitation: up to 154 MHz */
 	if (crtc_state->adjusted_mode.clock > 154000)
 		return -EINVAL;
 
@@ -1676,7 +1676,7 @@ tc_dpi_mode_valid(struct drm_bridge *bridge,
 		  const struct drm_display_info *info,
 		  const struct drm_display_mode *mode)
 {
-	/* DPI interface clock limitation: upto 100 MHz */
+	/* DPI interface clock limitation: up to 100 MHz */
 	if (mode->clock > 100000)
 		return MODE_CLOCK_HIGH;
 
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 7ce9e212770a..32f015eedb36 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -6134,7 +6134,7 @@ struct drm_dp_aux *drm_dp_mst_dsc_aux_for_port(struct drm_dp_mst_port *port)
 					  DP_DSC_SUPPORT, &upstream_dsc, 1) < 0)
 			return NULL;
 
-		/* Enpoint decompression with DP-to-DP peer device */
+		/* Endpoint decompression with DP-to-DP peer device */
 		if ((endpoint_dsc & DP_DSC_DECOMPRESSION_IS_SUPPORTED) &&
 		    (endpoint_fec & DP_FEC_CAPABLE) &&
 		    (upstream_dsc & DP_DSC_PASSTHROUGH_IS_SUPPORTED)) {
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index c808958a2188..793adaf5b549 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -230,7 +230,7 @@ static void drm_minor_unregister(struct drm_device *dev, enum drm_minor_type typ
 
 /*
  * Looks up the given minor-ID and returns the respective DRM-minor object. The
- * refence-count of the underlying device is increased so you must release this
+ * reference-count of the underlying device is increased so you must release this
  * object with drm_minor_release().
  *
  * As long as you hold this minor, it is guaranteed that the object and the
diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 425796d8d6c3..4b7127f4c25b 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -405,7 +405,7 @@ void oaktrail_lvds_init(struct drm_device *dev,
 	} else
 		dev_err(dev->dev, "No ddc adapter available!\n");
 	/*
-	 * If we didn't get EDID, try geting panel timing
+	 * If we didn't get EDID, try getting panel timing
 	 * from configuration data
 	 */
 	oaktrail_lvds_get_configuration_mode(dev, mode_dev);
diff --git a/drivers/gpu/drm/gma500/power.c b/drivers/gpu/drm/gma500/power.c
index 186af29bea6f..8893c01c947b 100644
--- a/drivers/gpu/drm/gma500/power.c
+++ b/drivers/gpu/drm/gma500/power.c
@@ -224,7 +224,7 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
  *	@dev: Our DRM device
  *
  *	Indicate that one of our gma_power_begin() requested periods when
- *	the diplay island power is needed has completed.
+ *	the display island power is needed has completed.
  */
 void gma_power_end(struct drm_device *dev)
 {
diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
index db197b865b90..4a884b1af5d6 100644
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@ -247,7 +247,7 @@ struct psb_offset {
 /*
  *	Register save state. This is used to hold the context when the
  *	device is powered off. In the case of Oaktrail this can (but does not
- *	yet) include screen blank. Operations occuring during the save
+ *	yet) include screen blank. Operations occurring during the save
  *	update the register cache instead.
  */
 
@@ -408,7 +408,7 @@ struct drm_psb_private {
 	/* Register base */
 	uint8_t __iomem *sgx_reg;
 	uint8_t __iomem *vdc_reg;
-	uint8_t __iomem *aux_reg; /* Auxillary vdc pipe regs */
+	uint8_t __iomem *aux_reg; /* Auxiliary vdc pipe regs */
 	uint16_t lpc_gpio_base;
 	uint32_t gatt_free_offset;
 
diff --git a/drivers/gpu/drm/imx/dcss/dcss-ctxld.c b/drivers/gpu/drm/imx/dcss/dcss-ctxld.c
index e41d5c2a3ea4..8a4375af6cae 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-ctxld.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-ctxld.c
@@ -82,7 +82,7 @@ struct dcss_ctxld {
 	bool in_use;
 	bool armed;
 
-	spinlock_t lock; /* protects concurent access to private data */
+	spinlock_t lock; /* protects concurrent access to private data */
 };
 
 static irqreturn_t dcss_ctxld_irq_handler(int irq, void *data)
diff --git a/drivers/gpu/drm/loongson/lsdc_drv.c b/drivers/gpu/drm/loongson/lsdc_drv.c
index 3fd828d23271..50450c2da34f 100644
--- a/drivers/gpu/drm/loongson/lsdc_drv.c
+++ b/drivers/gpu/drm/loongson/lsdc_drv.c
@@ -252,7 +252,7 @@ lsdc_create_device(struct pci_dev *pdev,
 	return ldev;
 }
 
-/* For multiple GPU driver instance co-exixt in the system */
+/* For multiple GPU driver instance co-exist in the system */
 
 static unsigned int lsdc_vga_set_decode(struct pci_dev *pdev, bool state)
 {
diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c b/drivers/gpu/drm/mgag200/mgag200_g200se.c
index 349ec36f6d49..1577978cc972 100644
--- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
@@ -228,7 +228,7 @@ static int mgag200_g200se_04_pixpllc_atomic_check(struct drm_crtc *crtc,
 		clock = 25000;
 	clock = clock * 2;
 
-	/* Permited delta is 0.5% as VESA Specification */
+	/* Permitted delta is 0.5% as VESA Specification */
 	permitteddelta = clock * 5 / 1000;
 
 	for (i = 0 ; i < ARRAY_SIZE(pvalues_e4); i++) {
diff --git a/drivers/gpu/drm/nouveau/dispnv50/tile.h b/drivers/gpu/drm/nouveau/dispnv50/tile.h
index e2be82830cf7..9ad2d1051f0d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/tile.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/tile.h
@@ -32,7 +32,7 @@ static inline u32 nouveau_get_gob_height(u16 family)
 		return NV_TILE_GOB_HEIGHT;
 }
 
-/* Number of blocks to cover the heigth of the framebuffer */
+/* Number of blocks to cover the height of the framebuffer */
 static inline u32 nouveau_get_height_in_blocks(u32 height, u32 gobs_in_block, u16 family)
 {
 	return DIV_ROUND_UP(height, nouveau_get_gob_height(family) * gobs_in_block);
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 38032bb95826..10cd606d01b9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -323,7 +323,7 @@ get_fp_strap(struct drm_device *dev, struct nvbios *bios)
 	/*
 	 * The fp strap is normally dictated by the "User Strap" in
 	 * PEXTDEV_BOOT_0[20:16], but on BMP cards when bit 2 of the
-	 * Internal_Flags struct at 0x48 is set, the user strap gets overriden
+	 * Internal_Flags struct at 0x48 is set, the user strap gets overridden
 	 * by the PCI subsystem ID during POST, but not before the previous user
 	 * strap has been committed to CR58 for CR57=0xf on head A, which may be
 	 * read and used instead
diff --git a/drivers/gpu/drm/nouveau/nouveau_exec.c b/drivers/gpu/drm/nouveau/nouveau_exec.c
index a08ab1cfea9b..eea6619cffaa 100644
--- a/drivers/gpu/drm/nouveau/nouveau_exec.c
+++ b/drivers/gpu/drm/nouveau/nouveau_exec.c
@@ -23,7 +23,7 @@
  * should be managed by the kernel and which by the UMD.
  *
  * The DRM_NOUVEAU_VM_BIND ioctl provides clients an interface to manage the
- * userspace-managable portion of the VA space. It provides operations to map
+ * userspace-manageable portion of the VA space. It provides operations to map
  * and unmap memory. Mappings may be flagged as sparse. Sparse mappings are not
  * backed by a GEM object and the kernel will ignore GEM handles provided
  * alongside a sparse mapping.
diff --git a/drivers/gpu/drm/nouveau/nouveau_led.c b/drivers/gpu/drm/nouveau/nouveau_led.c
index 19e2110904d1..67088a71f6d1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_led.c
+++ b/drivers/gpu/drm/nouveau/nouveau_led.c
@@ -65,7 +65,7 @@ nouveau_led_set_brightness(struct led_classdev *led, enum led_brightness value)
 	duty = value * div / LED_FULL;
 
 	/* for now, this is safe to directly poke those registers because:
-	 *  - A: nvidia never puts the logo led to any other PWM controler
+	 *  - A: nvidia never puts the logo led to any other PWM controller
 	 *       than PDISPLAY.SOR[1].PWM.
 	 *  - B: nouveau does not touch these registers anywhere else
 	 */
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c
index c8bb9191f9a2..e9db5eed574e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c
@@ -139,7 +139,7 @@
  * The ctxprog is written in its own kind of microcode, with very small and
  * crappy set of available commands. You upload it to a small [512 insns]
  * area of memory on PGRAPH, and it'll be run when PFIFO wants PGRAPH to
- * switch channel. or when the driver explicitely requests it. Stuff visible
+ * switch channel. or when the driver explicitly requests it. Stuff visible
  * to ctxprog consists of: PGRAPH MMIO registers, PGRAPH context strands,
  * the per-channel context save area in VRAM [known as ctxvals or grctx],
  * 4 flags registers, a scratch register, two grctx pointers, plus many
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
index c2a9dd9018b8..b8d847101b13 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
@@ -2080,7 +2080,7 @@ gf100_gr_init_(struct nvkm_gr *base)
 	 *
 	 * A workaround was discovered by Karol, whereby putting GR into
 	 * reset for an extended period right before initialisation
-	 * prevents the problem from occuring.
+	 * prevents the problem from occurring.
 	 *
 	 * XXX: As RM does not require any such workaround, this is more
 	 *      of a hack than a true fix.
diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index 78b74217f952..aa2776140cf8 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -2127,7 +2127,7 @@ static int check_horiz_timing_omap3(unsigned long pclk, unsigned long lclk,
 
 	/*
 	 * Pixel data should be prepared before visible display point starts.
-	 * So, atleast DS-2 lines must have already been fetched by DISPC
+	 * So, at least DS-2 lines must have already been fetched by DISPC
 	 * during nonactive - pos_x period.
 	 */
 	val = div_u64((u64)(nonactive - pos_x) * lclk, pclk);
@@ -2138,7 +2138,7 @@ static int check_horiz_timing_omap3(unsigned long pclk, unsigned long lclk,
 
 	/*
 	 * All lines need to be refilled during the nonactive period of which
-	 * only one line can be loaded during the active period. So, atleast
+	 * only one line can be loaded during the active period. So, at least
 	 * DS - 1 lines should be loaded during nonactive period.
 	 */
 	val =  div_u64((u64)nonactive * lclk, pclk);
diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index fb0e6f556b31..e4c71afbcee8 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -928,7 +928,7 @@ int omap_gem_tiled_stride(struct drm_gem_object *obj, u32 orient)
  * because we don't support swapping pages back out).  And 'remap'
  * might not be quite the right name, but I wanted to keep it working
  * similarly to omap_gem_pin().  Note though that mutex is not
- * aquired if !remap (because this can be called in atomic ctxt),
+ * acquired if !remap (because this can be called in atomic ctxt),
  * but probably omap_gem_unpin() should be changed to work in the
  * same way.  If !remap, a matching omap_gem_put_pages() call is not
  * required (and should not be made).
diff --git a/drivers/gpu/drm/panel/panel-novatek-nt36672a.c b/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
index 464d9ce47d87..3837605d7b5e 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt36672a.c
@@ -122,7 +122,7 @@ static int nt36672a_panel_power_on(struct nt36672a_panel *pinfo)
 	/*
 	 * As per downstream kernel, Reset sequence of Tianma FHD panel requires the panel to
 	 * be out of reset for 10ms, followed by being held in reset for 10ms. But for Android
-	 * AOSP, we needed to bump it upto 200ms otherwise we get white screen sometimes.
+	 * AOSP, we needed to bump it up to 200ms otherwise we get white screen sometimes.
 	 * FIXME: Try to reduce this 200ms to a lesser value.
 	 */
 	gpiod_set_value(pinfo->reset_gpio, 1);
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
index e05199ce14ee..661cb7fe21c4 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
@@ -283,7 +283,7 @@ static int s6e63j0x03_panel_init(struct s6e63j0x03 *ctx)
 	if (ret < 0)
 		return ret;
 
-	/* set ltps timming 0, 1 */
+	/* set ltps timing 0, 1 */
 	ret = s6e63j0x03_dcs_write_seq_static(ctx, 0xf8, 0x08, 0x08, 0x08, 0x17,
 		0x00, 0x2a, 0x02, 0x26, 0x00, 0x00, 0x02, 0x00, 0x00);
 	if (ret < 0)
diff --git a/drivers/gpu/drm/qxl/qxl_gem.c b/drivers/gpu/drm/qxl/qxl_gem.c
index 4939b57a2a48..78562357e55d 100644
--- a/drivers/gpu/drm/qxl/qxl_gem.c
+++ b/drivers/gpu/drm/qxl/qxl_gem.c
@@ -75,7 +75,7 @@ int qxl_gem_object_create(struct qxl_device *qdev, int size,
 
 /*
  * If the caller passed a valid gobj pointer, it is responsible to call
- * drm_gem_object_put() when it no longer needs to acess the object.
+ * drm_gem_object_put() when it no longer needs to access the object.
  *
  * If gobj is NULL, it is handled internally.
  */
diff --git a/drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c b/drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c
index 9527d3637e6c..5ac0bceae517 100644
--- a/drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c
@@ -234,7 +234,7 @@ static void rcar_lvds_d3_e3_pll_calc(struct rcar_lvds *lvds, struct clk *clk,
 				unsigned int div;
 
 				/*
-				 * Finally we have a programable divider after
+				 * Finally we have a programmable divider after
 				 * the PLL, followed by a an optional fixed /7
 				 * divider.
 				 */
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 6cb6f9546493..c7ccf3f7e438 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -413,7 +413,7 @@ void drm_sched_stop(struct drm_gpu_scheduler *sched, struct drm_sched_job *bad)
 		list_add(&bad->list, &sched->pending_list);
 
 	/*
-	 * Iterate the job list from later to  earlier one and either deactive
+	 * Iterate the job list from later to  earlier one and either deactivate
 	 * their HW callbacks or remove them from pending list if they already
 	 * signaled.
 	 * This iteration is thread safe as the scheduler's work items have been
@@ -558,7 +558,7 @@ void drm_sched_resubmit_jobs(struct drm_gpu_scheduler *sched)
 
 			s_job->s_fence->parent = dma_fence_get(fence);
 
-			/* Drop for orignal kref_init */
+			/* Drop for original kref_init */
 			dma_fence_put(fence);
 		}
 	}
diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index bf405a2aa324..675f050a6043 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -875,7 +875,7 @@ static int sun4i_tcon_init_regmap(struct device *dev,
  *
  * We can either identify backends from their compatible strings, which
  * means maintaining a large list of them. Or, since the backend is
- * registered and binded before the TCON, we can just go through the
+ * registered and bound before the TCON, we can just go through the
  * list of registered backends and compare the device node.
  *
  * As the structures now store engines instead of backends, here this
diff --git a/drivers/gpu/drm/tiny/panel-mipi-dbi.c b/drivers/gpu/drm/tiny/panel-mipi-dbi.c
index 60cd65cae41d..6af4d698bfd0 100644
--- a/drivers/gpu/drm/tiny/panel-mipi-dbi.c
+++ b/drivers/gpu/drm/tiny/panel-mipi-dbi.c
@@ -96,7 +96,7 @@ struct panel_mipi_dbi_config {
 	 *
 	 * Some commands require a pause before the next command can be received.
 	 * Inserting a delay in the command sequence is done by using the NOP command with one
-	 * parameter: delay in miliseconds (the No Operation command is part of the MIPI Display
+	 * parameter: delay in milliseconds (the No Operation command is part of the MIPI Display
 	 * Command Set where it has no parameters).
 	 *
 	 * Example:
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 1bf37023fed6..20467d17582f 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -169,7 +169,7 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
 	void *vaddr;
 
 	/* Don't set the __GFP_COMP flag for higher order allocations.
-	 * Mapping pages directly into an userspace process and calling
+	 * Mapping pages directly into a userspace process and calling
 	 * put_page() on a TTM allocated page is illegal.
 	 */
 	if (order)
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 17c8635c5afa..c6ea2e607ad2 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -365,7 +365,7 @@ static void vc4_hdmi_handle_hotplug(struct vc4_hdmi *vc4_hdmi,
 	 * NOTE: This function should really be called with vc4_hdmi->mutex
 	 * held, but doing so results in reentrancy issues since
 	 * cec_s_phys_addr() might call .adap_enable, which leads to that
-	 * funtion being called with our mutex held.
+	 * function being called with our mutex held.
 	 *
 	 * A similar situation occurs with vc4_hdmi_reset_link() that
 	 * will call into our KMS hooks if the scrambling was enabled.
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index 27158be19952..65e39b854721 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -882,7 +882,7 @@ enum {
 # define VC4_HDMI_CEC_TX_CONTINUE		BIT(22)
 /* Set this after a CEC interrupt. */
 # define VC4_HDMI_CEC_CLEAR_RECEIVE_OFF		BIT(21)
-/* Starts a TX.  Will wait for appropriate idel time before CEC
+/* Starts a TX.  Will wait for appropriate idle time before CEC
  * activity. Must be cleared in between transmits.
  */
 # define VC4_HDMI_CEC_START_XMIT_BEGIN		BIT(20)
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 3d8e4ccdb7c1..7a08ec7955c5 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -189,7 +189,7 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		return ret;
 	}
 
-	rc->res_handle = qobj->hw_res_handle; /* similiar to a VM address */
+	rc->res_handle = qobj->hw_res_handle; /* similar to a VM address */
 	rc->bo_handle = handle;
 
 	/*
diff --git a/drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h b/drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h
index f84376718086..d4cdd9f14294 100644
--- a/drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h
+++ b/drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h
@@ -125,7 +125,7 @@ typedef __attribute__((aligned(32))) struct MKSGuestStatInfoEntry {
  * interpret the pointers.
  *
  * Because the host side code never acknowledges anything back to the
- * guest there is no strict requirement to maintain compatability
+ * guest there is no strict requirement to maintain compatibility
  * across releases.  If the interface changes the host might not be
  * able to log stats, but the guest will continue to run normally.
  */
diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.c b/drivers/gpu/drm/vmwgfx/ttm_object.c
index f9042bafdc93..38b6a1787865 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -431,7 +431,7 @@ ttm_object_device_init(const struct dma_buf_ops *ops)
 
 	/*
 	 * Our base is at VMWGFX_NUM_MOB + 1 because we want to create
-	 * a seperate namespace for GEM handles (which are
+	 * a separate namespace for GEM handles (which are
 	 * 1..VMWGFX_NUM_MOB) and the surface handles. Some ioctl's
 	 * can take either handle as an argument so we want to
 	 * easily be able to tell whether the handle refers to a
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 38bea8abab84..ee31f8170a96 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -446,8 +446,8 @@ enum {
 /**
  * enum vmw_sm_type - Graphics context capability supported by device.
  * @VMW_SM_LEGACY: Pre DX context.
- * @VMW_SM_4: Context support upto SM4.
- * @VMW_SM_4_1: Context support upto SM4_1.
+ * @VMW_SM_4: Context support up to SM4.
+ * @VMW_SM_4_1: Context support up to SM4_1.
  * @VMW_SM_5: Context support up to SM5.
  * @VMW_SM_5_1X: Adds support for sm5_1 and gl43 extensions.
  * @VMW_SM_MAX: Should be the last.
@@ -1011,7 +1011,7 @@ extern int vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 bool vmw_cmd_describe(const void *buf, u32 *size, char const **cmd);
 
 /*
- * IRQs and wating - vmwgfx_irq.c
+ * IRQs and waiting - vmwgfx_irq.c
  */
 
 extern int vmw_irq_install(struct vmw_private *dev_priv);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index a9136a6523cb..6dfb45592d74 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1052,7 +1052,7 @@ static int vmw_query_bo_switch_prepare(struct vmw_private *dev_priv,
  * object following that query wait has signaled, we are sure that all preceding
  * queries have finished, and the old query buffer can be unpinned. However,
  * since both the new query buffer and the old one are fenced with that fence,
- * we can do an asynchronus unpin now, and be sure that the old query buffer
+ * we can do an asynchronous unpin now, and be sure that the old query buffer
  * won't be moved until the fence has signaled.
  *
  * As mentioned above, both the new - and old query buffers need to be fenced
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 2224d7d91d1b..95817e054d66 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -305,7 +305,7 @@ struct vmw_display_unit {
 	unsigned unit;
 
 	/*
-	 * Prefered mode tracking.
+	 * Preferred mode tracking.
 	 */
 	unsigned pref_width;
 	unsigned pref_height;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_so.h b/drivers/gpu/drm/vmwgfx/vmwgfx_so.h
index 01c701e7466e..d23c5f1b838a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_so.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_so.h
@@ -109,7 +109,7 @@ static inline enum vmw_view_type vmw_view_cmd_to_type(u32 id)
  * @id: The SVGA3D command id.
  *
  * For a given state object create or destroy command id,
- * return the corresponding enum vmw_so_type. If the command is uknown,
+ * return the corresponding enum vmw_so_type. If the command is unknown,
  * return vmw_so_max. We should perhaps optimize this function using
  * a similar strategy as vmw_view_cmd_to_type().
  */
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index bd0563741e89..7bf128edfd4a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -445,7 +445,7 @@ static int vmw_legacy_srf_create(struct vmw_resource *res)
  *                  vmw_surface.
  * @val_buf:        Pointer to a struct ttm_validate_buffer containing
  *                  information about the backup buffer.
- * @bind:           Boolean wether to DMA to the surface.
+ * @bind:           Boolean whether to DMA to the surface.
  *
  * Transfer backup data to or from a legacy surface as part of the
  * validation process.
diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index b209582bc130..543d9111b3ef 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -1061,7 +1061,7 @@ static int zynqmp_dp_aux_cmd_submit(struct zynqmp_dp *dp, u32 cmd, u16 addr,
 		reg |= (bytes - 1) << ZYNQMP_DP_AUX_COMMAND_BYTES_SHIFT;
 	zynqmp_dp_write(dp, ZYNQMP_DP_AUX_COMMAND, reg);
 
-	/* Wait for reply to be delivered upto 2ms */
+	/* Wait for reply to be delivered up to 2ms */
 	time_left = wait_for_completion_timeout(&dp->aux_done,
 						msecs_to_jiffies(2));
 	if (!time_left)
diff --git a/drivers/gpu/ipu-v3/ipu-prg.c b/drivers/gpu/ipu-v3/ipu-prg.c
index d38d3ba54d72..64729aaab392 100644
--- a/drivers/gpu/ipu-v3/ipu-prg.c
+++ b/drivers/gpu/ipu-v3/ipu-prg.c
@@ -163,7 +163,7 @@ void ipu_prg_disable(struct ipu_soc *ipu)
 EXPORT_SYMBOL_GPL(ipu_prg_disable);
 
 /*
- * The channel configuartion functions below are not thread safe, as they
+ * The channel configuration functions below are not thread safe, as they
  * must be only called from the atomic commit path in the DRM driver, which
  * is properly serialized.
  */
diff --git a/include/drm/drm_framebuffer.h b/include/drm/drm_framebuffer.h
index 38b24fc8978d..e45a9159ad1b 100644
--- a/include/drm/drm_framebuffer.h
+++ b/include/drm/drm_framebuffer.h
@@ -59,7 +59,7 @@ struct drm_framebuffer_funcs {
 	 * Create a buffer handle in the driver-specific buffer manager (either
 	 * GEM or TTM) valid for the passed-in &struct drm_file. This is used by
 	 * the core to implement the GETFB IOCTL, which returns (for
-	 * sufficiently priviledged user) also a native buffer handle. This can
+	 * sufficiently privileged user) also a native buffer handle. This can
 	 * be used for seamless transitions between modesetting clients by
 	 * copying the current screen contents to a private buffer and blending
 	 * between that and the new contents.
@@ -164,7 +164,7 @@ struct drm_framebuffer {
 	 * @offsets must at least be tile-size aligned, but hardware often has
 	 * stricter requirements.
 	 *
-	 * This should not be used to specifiy x/y pixel offsets into the buffer
+	 * This should not be used to specify x/y pixel offsets into the buffer
 	 * data (even for linear buffers). Specifying an x/y pixel offset is
 	 * instead done through the source rectangle in &struct drm_plane_state.
 	 */
diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
index 2c5a5a70a71b..a89207293faf 100644
--- a/include/drm/drm_plane.h
+++ b/include/drm/drm_plane.h
@@ -303,7 +303,7 @@ struct drm_plane_funcs {
 	 *
 	 * This is the legacy entry point to enable and configure the plane for
 	 * the given CRTC and framebuffer. It is never called to disable the
-	 * plane, i.e. the passed-in crtc and fb paramters are never NULL.
+	 * plane, i.e. the passed-in crtc and fb parameters are never NULL.
 	 *
 	 * The source rectangle in frame buffer memory coordinates is given by
 	 * the src_x, src_y, src_w and src_h parameters (as 16.16 fixed point
diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_drm.h
index c4905b3e4e91..a2a71c69a844 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -552,7 +552,7 @@ struct drm_nouveau_svm_bind {
 
 /*
  * NOUVEAU_BIND_COMMAND__MIGRATE: synchronous migrate to target memory.
- * result: number of page successfuly migrate to the target memory.
+ * result: number of page successfully migrate to the target memory.
  */
 #define NOUVEAU_SVM_BIND_COMMAND__MIGRATE               0
 
diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
index 7d786a0cc835..364dd4282385 100644
--- a/include/uapi/drm/vmwgfx_drm.h
+++ b/include/uapi/drm/vmwgfx_drm.h
@@ -454,7 +454,7 @@ union drm_vmw_alloc_bo_arg {
  *
  * This IOCTL controls the overlay units of the svga device.
  * The SVGA overlay units does not work like regular hardware units in
- * that they do not automaticaly read back the contents of the given dma
+ * that they do not automatically read back the contents of the given dma
  * buffer. But instead only read back for each call to this ioctl, and
  * at any point between this call being made and a following call that
  * either changes the buffer or disables the stream.
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d68022..efbbf3100052 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -28,7 +28,7 @@ DEFINE_STATIC_SRCU(dmemcg_srcu);
 struct dmem_cgroup_region {
 	/**
 	 * @ref: References keeping the region alive.
-	 * Keeps the region reference alive after a succesful RCU lookup.
+	 * Keeps the region reference alive after a successful RCU lookup.
 	 */
 	struct kref ref;
 
-- 
2.48.1

