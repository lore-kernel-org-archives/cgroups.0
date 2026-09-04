Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEED3E9C17;
	Fri,  4 Sep 2026 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527998; cv=none; b=AbRua/CELStt1ExENrWyvw+6mqXeQSPNsuTN+hEMaYUTZGzF0yJALDPSWP67QOJw0OcHiQYWTnYjSu9o9k77OEt4Ek/4i29pjwZneQ/esmHgrqgCju0MSwDf+53eUKuOecfjMT5WcQ1tTKwWNP6vzh7dyqODhXtisZh+qcxY0OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527998; c=relaxed/simple;
	bh=kX2Hhn1yZ5LYC7Vu21MGJ+VxU5SYwZaB4szMoUuUu8w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=B88M+2FIyiXSiz8n87nwb5YVBr6xs9HkUEGI4oRFhkByuf9zeme2XlvMc/owSCKtp0VBOuX4B+RJONzcZWPUP0iCTIfWEn+58EizgCrKTC8OHaAhLVaCU5w52nJisZAjMHLvJghhQ6porxdgOtaeu9w5gYZXmfWBuYo04bfqwFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=2642HDYe; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="2642HDYe"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 2B6F34E4150D;
	Fri,  4 Sep 2026 13:19:47 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DA2A860580;
	Fri,  4 Sep 2026 13:19:46 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8738D11C7ACEC;
	Fri,  4 Sep 2026 15:19:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788527979; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=eKdsKrjP8I//pYngbU84Hx6Mj3qol3bXMUhsukU9fBU=;
	b=2642HDYeLffHlkgB9z2+TQ+SSTVjdieJldjZdhT2KdVmbGlCSxt4KomKKeZSTuwyx4GNyd
	48mlM1abkyZgzXNKlCjdwF4XdQYpfbG9DTu96mOnbhP16IevUntbM9O7JEFLz/wKXS1qjH
	40w53YGR8WRxzpsdG8EparhTB9a96ZFIBeTFeVAsGGu4J/gDWSKCXKS1TpVDXwBLFRmqTx
	7v9y8wljVv0E2Z63CtT1qBmaHC9S0UaMpF1re16G8SU0nXMTAnSEp0IfjVBg8hggkv6A6P
	ZKqCFYoCDQ2ecsSaFY4XQhf/7QZUGc/XonUx0uHl+O7uAi7zR7Zk50/VsPSNAA==
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 15:19:15 +0200
Message-Id: <DL6K8VPR37C3.2LQJ8ZM6PIZTS@bootlin.com>
Subject: Re: [PATCH 1/3] drm: fix typos in comments
Cc: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
 <imx@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <nouveau@lists.freedesktop.org>, <virtualization@lists.linux.dev>,
 <spice-devel@lists.freedesktop.org>, <linux-renesas-soc@vger.kernel.org>,
 <linux-sunxi@lists.linux.dev>, <cgroups@vger.kernel.org>
To: "Tomi Valkeinen" <tomi.valkeinen@ideasonboard.com>, <phasta@kernel.org>,
 "Hemanth Selam" <hemanth.selam@gmail.com>, "Sumit Semwal"
 <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, "Andrzej Hajda" <andrzej.hajda@intel.com>,
 "Neil Armstrong" <neil.armstrong@linaro.org>, "Robert Foss"
 <rfoss@kernel.org>, "Laurent Pinchart" <Laurent.pinchart@ideasonboard.com>,
 "Jonas Karlman" <jonas@kwiboo.se>, "Jernej Skrabec"
 <jernej.skrabec@gmail.com>, "Luca Ceresoli" <luca.ceresoli@bootlin.com>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard"
 <mripard@kernel.org>, "Thomas Zimmermann" <tzimmermann@suse.de>, "David
 Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Inki Dae"
 <inki.dae@samsung.com>, "Jagan Teki" <jagan@amarulasolutions.com>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Patrik Jakobsson"
 <patrik.r.jakobsson@gmail.com>, "Laurentiu Palcu"
 <laurentiu.palcu@oss.nxp.com>, "Lucas Stach" <l.stach@pengutronix.de>,
 "Frank Li" <Frank.Li@nxp.com>, "Sascha Hauer" <s.hauer@pengutronix.de>,
 "Pengutronix Kernel Team" <kernel@pengutronix.de>, "Fabio Estevam"
 <festevam@gmail.com>, "Jianmin Lv" <lvjianmin@loongson.cn>, "Qianhai Wu"
 <wuqianhai@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>, "Mingcong
 Bai" <jeffbai@aosc.io>, "Xi Ruoyao" <xry111@xry111.site>, "Icenowy Zheng"
 <zhengxingda@iscas.ac.cn>, "Dave Airlie" <airlied@redhat.com>, "Jocelyn
 Falempe" <jfalempe@redhat.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jessica Zhang" <jesszhan0024@gmail.com>,
 "Gerd Hoffmann" <kraxel@redhat.com>, "Kieran Bingham"
 <kieran.bingham+renesas@ideasonboard.com>, "Geert Uytterhoeven"
 <geert+renesas@glider.be>, "Magnus Damm" <magnus.damm@gmail.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Chen-Yu Tsai" <wens@kernel.org>, "Samuel
 Holland" <samuel@sholland.org>, "Huang Rui" <ray.huang@amd.com>, "Matthew
 Auld" <matthew.auld@intel.com>, "Dave Stevenson"
 <dave.stevenson@raspberrypi.com>, =?utf-8?q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, "Raspberry Pi Kernel Maintenance"
 <kernel-list@raspberrypi.com>, "Dmitry Osipenko"
 <dmitry.osipenko@collabora.com>, "Gurchetan Singh"
 <gurchetansingh@chromium.org>, "Chia-I Wu" <olvaffe@gmail.com>, "Zack
 Rusin" <zack.rusin@broadcom.com>, "Broadcom internal kernel review list"
 <bcm-kernel-feedback-list@broadcom.com>, "Michal Simek"
 <michal.simek@amd.com>, "Philipp Zabel" <p.zabel@pengutronix.de>, "Natalie
 Vock" <nat@pixelcluster.dev>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
From: "Luca Ceresoli" <luca.ceresoli@bootlin.com>
X-Mailer: aerc 0.22.0
References: <20260904120430.17224-1-hemanth.selam@gmail.com>
 <20260904120430.17224-2-hemanth.selam@gmail.com>
 <8b4194fcb6fdb11af10fc81a1a7c915ad71003a0.camel@mailbox.org>
 <a64864e0-3f10-4f81-b304-c45ef932817a@ideasonboard.com>
In-Reply-To: <a64864e0-3f10-4f81-b304-c45ef932817a@ideasonboard.com>
X-Last-TLS-Session-Version: TLSv1.3

On Fri Sep 4, 2026 at 2:34 PM CEST, Tomi Valkeinen wrote:
> Hi,
>
> On 04/09/2026 15:13, Philipp Stanner wrote:
>> On Fri, 2026-09-04 at 17:34 +0530, Hemanth Selam wrote:
>>> Fix typos in comments, reported by scripts/checkpatch.pl using the
>>> misspelling list in scripts/spelling.txt.=C2=A0 Only touches comments, =
no code
>>> changes.
>>>
>>> Assisted-by: Cursor:claude-opus-5
>>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
>>> ---
>>>  =C2=A0drivers/dma-buf/sync_debug.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/bridge/parade-ps8622.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0drivers/gpu/drm/bridge/samsung-dsim.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 2 +-
>>>  =C2=A0drivers/gpu/drm/bridge/tc358767.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 6 +++---
>>>  =C2=A0drivers/gpu/drm/display/drm_dp_mst_topology.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/drm_drv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/gma500/oaktrail_lvds.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0drivers/gpu/drm/gma500/power.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/gma500/psb_drv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 4 ++--
>>>  =C2=A0drivers/gpu/drm/imx/dcss/dcss-ctxld.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 2 +-
>>>  =C2=A0drivers/gpu/drm/loongson/lsdc_drv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/mgag200/mgag200_g200se.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/dispnv50/tile.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/nouveau_bios.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/nouveau_exec.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/nouveau_led.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxnv50.c=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/omapdrm/dss/dispc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 4 ++--
>>>  =C2=A0drivers/gpu/drm/omapdrm/omap_gem.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/panel/panel-novatek-nt36672a.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/qxl/qxl_gem.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/renesas/rcar-du/rcar_lvds.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/scheduler/sched_main.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
4 ++--
>>>  =C2=A0drivers/gpu/drm/sun4i/sun4i_tcon.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/tiny/panel-mipi-dbi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 2 +-
>>>  =C2=A0drivers/gpu/drm/ttm/ttm_pool.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vc4/vc4_hdmi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vc4/vc4_regs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/virtio/virtgpu_ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/device_include/vm_basic_types.h | 2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/ttm_object.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_drv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 6 +++---
>>>  =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_kms.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_so.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_surface.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/drm/xlnx/zynqmp_dp.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0drivers/gpu/ipu-v3/ipu-prg.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0include/drm/drm_framebuffer.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 4 ++--
>>>  =C2=A0include/drm/drm_plane.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
2 +-
>>>  =C2=A0include/uapi/drm/nouveau_drm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0include/uapi/drm/vmwgfx_drm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
>>>  =C2=A0kernel/cgroup/dmem.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 2 +-
>>>  =C2=A045 files changed, 53 insertions(+), 53 deletions(-)

[...]

>> Not sure if the cost-benefit-ratio would then pay off?
> I would skip these. Fixing a typo in a key-word (say, a register name)
> would be useful, but I'm not sure if any of these count.

I agree, and a patch touching so many files will be annoying to cherry-pick
due to conflicts.

I'd save LLM water and energy consumption for more valuable changes.

Luca

--
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
