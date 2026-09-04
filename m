Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6248C3E9;
	Fri,  4 Sep 2026 12:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525260; cv=none; b=BOqMHZTrrRsyW1ZEsJoIWcU4u3PQ/smfBazfW7d/M1XX1U15bma3xNNJJ4Ns3AwmI2XsHc4SUrE+O7O707koyx8YS9XLYMyQJQ5kRgmBjCOfG+B/9cNeXYqJzhckjEdj04Gaa6BvVOVOvqB825NBMcsKwxz9Km0disFXshJBCRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525260; c=relaxed/simple;
	bh=4c7Krb3S4ZZ17EpNtME83ACwkw+9XKh09GENnHQO7jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VHWDIoOZYIT+pLsSIdBxebHe7KLN861VuKx74WpWdUBgReE3IFY0GoL7AVbIQfKCrJxYUu08DFcAH/8ocovWtQxHCgz/vweUvF5p7lhsqAN00oo2013Mg7nFpmgRljvq6WGH/YQAojvmZdxr86iI3APerExLnKVR5/sQflf81NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=UZhb/9LX; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="UZhb/9LX"
Received: from [192.168.88.20] (91-158-153-178.elisa-laajakaista.fi [91.158.153.178])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D97C92023;
	Fri,  4 Sep 2026 14:32:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1788525162;
	bh=4c7Krb3S4ZZ17EpNtME83ACwkw+9XKh09GENnHQO7jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UZhb/9LXvNGfyCliwic1zTpddMYdYQ5Bq8VoujVhv0Vqnw1KU1Nv6OYSZe20LDG86
	 AXvw0Z4rV6B3HbGm0XsTtBSA1VHiHWCVQnVRHzAPhbXc0WR5qVi8MWpQBHR43V9gXR
	 0twaCkh2lgoqYe45ruy+H2zgqpE/9ojUxCZrorW0=
Message-ID: <a64864e0-3f10-4f81-b304-c45ef932817a@ideasonboard.com>
Date: Fri, 4 Sep 2026 15:34:08 +0300
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] drm: fix typos in comments
To: phasta@kernel.org, Hemanth Selam <hemanth.selam@gmail.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrzej Hajda <andrzej.hajda@intel.com>,
 Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>,
 Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
 Jonas Karlman <jonas@kwiboo.se>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Inki Dae <inki.dae@samsung.com>, Jagan Teki <jagan@amarulasolutions.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
 Lucas Stach <l.stach@pengutronix.de>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, Jianmin Lv <lvjianmin@loongson.cn>,
 Qianhai Wu <wuqianhai@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Mingcong Bai <jeffbai@aosc.io>, Xi Ruoyao <xry111@xry111.site>,
 Icenowy Zheng <zhengxingda@iscas.ac.cn>, Dave Airlie <airlied@redhat.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, Jessica Zhang <jesszhan0024@gmail.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Magnus Damm <magnus.damm@gmail.com>, Matthew Brost
 <matthew.brost@intel.com>, Chen-Yu Tsai <wens@kernel.org>,
 Samuel Holland <samuel@sholland.org>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Dave Stevenson <dave.stevenson@raspberrypi.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Michal Simek
 <michal.simek@amd.com>, Philipp Zabel <p.zabel@pengutronix.de>,
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 nouveau@lists.freedesktop.org, virtualization@lists.linux.dev,
 spice-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
 linux-sunxi@lists.linux.dev, cgroups@vger.kernel.org
References: <20260904120430.17224-1-hemanth.selam@gmail.com>
 <20260904120430.17224-2-hemanth.selam@gmail.com>
 <8b4194fcb6fdb11af10fc81a1a7c915ad71003a0.camel@mailbox.org>
From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Content-Language: en-US
In-Reply-To: <8b4194fcb6fdb11af10fc81a1a7c915ad71003a0.camel@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 04/09/2026 15:13, Philipp Stanner wrote:
> On Fri, 2026-09-04 at 17:34 +0530, Hemanth Selam wrote:
>> Fix typos in comments, reported by scripts/checkpatch.pl using the
>> misspelling list in scripts/spelling.txt.  Only touches comments, no code
>> changes.
>>
>> Assisted-by: Cursor:claude-opus-5
>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
>> ---
>>   drivers/dma-buf/sync_debug.h                           | 2 +-
>>   drivers/gpu/drm/bridge/parade-ps8622.c                 | 2 +-
>>   drivers/gpu/drm/bridge/samsung-dsim.c                  | 2 +-
>>   drivers/gpu/drm/bridge/tc358767.c                      | 6 +++---
>>   drivers/gpu/drm/display/drm_dp_mst_topology.c          | 2 +-
>>   drivers/gpu/drm/drm_drv.c                              | 2 +-
>>   drivers/gpu/drm/gma500/oaktrail_lvds.c                 | 2 +-
>>   drivers/gpu/drm/gma500/power.c                         | 2 +-
>>   drivers/gpu/drm/gma500/psb_drv.h                       | 4 ++--
>>   drivers/gpu/drm/imx/dcss/dcss-ctxld.c                  | 2 +-
>>   drivers/gpu/drm/loongson/lsdc_drv.c                    | 2 +-
>>   drivers/gpu/drm/mgag200/mgag200_g200se.c               | 2 +-
>>   drivers/gpu/drm/nouveau/dispnv50/tile.h                | 2 +-
>>   drivers/gpu/drm/nouveau/nouveau_bios.c                 | 2 +-
>>   drivers/gpu/drm/nouveau/nouveau_exec.c                 | 2 +-
>>   drivers/gpu/drm/nouveau/nouveau_led.c                  | 2 +-
>>   drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c       | 2 +-
>>   drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c         | 2 +-
>>   drivers/gpu/drm/omapdrm/dss/dispc.c                    | 4 ++--
>>   drivers/gpu/drm/omapdrm/omap_gem.c                     | 2 +-
>>   drivers/gpu/drm/panel/panel-novatek-nt36672a.c         | 2 +-
>>   drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c       | 2 +-
>>   drivers/gpu/drm/qxl/qxl_gem.c                          | 2 +-
>>   drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c            | 2 +-
>>   drivers/gpu/drm/scheduler/sched_main.c                 | 4 ++--
>>   drivers/gpu/drm/sun4i/sun4i_tcon.c                     | 2 +-
>>   drivers/gpu/drm/tiny/panel-mipi-dbi.c                  | 2 +-
>>   drivers/gpu/drm/ttm/ttm_pool.c                         | 2 +-
>>   drivers/gpu/drm/vc4/vc4_hdmi.c                         | 2 +-
>>   drivers/gpu/drm/vc4/vc4_regs.h                         | 2 +-
>>   drivers/gpu/drm/virtio/virtgpu_ioctl.c                 | 2 +-
>>   drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h | 2 +-
>>   drivers/gpu/drm/vmwgfx/ttm_object.c                    | 2 +-
>>   drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                    | 6 +++---
>>   drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                | 2 +-
>>   drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                    | 2 +-
>>   drivers/gpu/drm/vmwgfx/vmwgfx_so.h                     | 2 +-
>>   drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                | 2 +-
>>   drivers/gpu/drm/xlnx/zynqmp_dp.c                       | 2 +-
>>   drivers/gpu/ipu-v3/ipu-prg.c                           | 2 +-
>>   include/drm/drm_framebuffer.h                          | 4 ++--
>>   include/drm/drm_plane.h                                | 2 +-
>>   include/uapi/drm/nouveau_drm.h                         | 2 +-
>>   include/uapi/drm/vmwgfx_drm.h                          | 2 +-
>>   kernel/cgroup/dmem.c                                   | 2 +-
>>   45 files changed, 53 insertions(+), 53 deletions(-)
> 
> That's a lot of churn
> 
>>
>> diff --git a/drivers/dma-buf/sync_debug.h b/drivers/dma-buf/sync_debug.h
>>
> 
> […]
> 
> 
>> -	/* DPI interface clock limitation: upto 100 MHz */
>> +	/* DPI interface clock limitation: up to 100 MHz */
>>   	if (mode->clock > 100000)
>>   		return MODE_CLOCK_HIGH;
>>
> 
> […]
> 
>>   
>> -/* For multiple GPU driver instance co-exixt in the system */
>> +/* For multiple GPU driver instance co-exist in the system */
>>   
>>
> 
> […]
> 
>>   
>> -	/* set ltps timming 0, 1 */
>> +	/* set ltps timing 0, 1 */
> 
> 
> Places like these are certainly candidates that one might want to git-
> blame to figure out more about the background.
> 
> Not sure if the cost-benefit-ratio would then pay off?
I would skip these. Fixing a typo in a key-word (say, a register name) 
would be useful, but I'm not sure if any of these count.

  Tomi

