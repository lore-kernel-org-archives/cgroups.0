Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499793F1ADB;
	Fri,  4 Sep 2026 12:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524059; cv=none; b=EvKEc6hQRDqgvJiUfjV0aGNRKEkq6bhP0llk/RwVHUeViwRLLjh/YjdVgZ8Sb66U6KKuGpEkdKFG10n74+w38ai00NM/lFZY5z/BbEoLA3bjL10qz8BQx86zhlBM3ZlMapGSXi6loVoB+K/3+7svT0lE2JrJsgiDyfbQuPunknk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524059; c=relaxed/simple;
	bh=3laS6ZZpfGUwO/BUm72vPoPlNir78tFJtVUp7tBN7C0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ChF2P9syruGI9zaig3qVulKx49Lf5NJJrQAfNylrYemhtHCCt3ggbI4mxU8wVFCHpp56WNYjuBz+/OB2uXq68nfs588KLmVVOwSw2ev2DxVpr61/IfloE3gVLb4AEDfQQGLBBRDWY1J7OoK4gdTZEmUEZrLAF7jUxQFiEgpPId4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=mYCKBGT/; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="mYCKBGT/"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hbwPK2fwYzMlCf;
	Fri, 04 Sep 2026 14:14:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788524053; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3laS6ZZpfGUwO/BUm72vPoPlNir78tFJtVUp7tBN7C0=;
	b=mYCKBGT/QJrD1QRugY/cx3YrM1jmw1juS2VQ9EkmTnyfZzii9ry8JjyUxyKzRHhoge8UPe
	dYjnkCB4MFcGtjQzmvsJ7ZYXwivYv6S6mh4gHaUgQX+tD0nbmp+6myGnIQPCA/3QhG/KFS
	zISsvDu3T6zI2V7SsmIjMHRW0Jmi15h2cEKGQ6DZhAQimR3sdzVp+rQ3XMNSantQTBmxtg
	OCbCzp58lZRIVG94nLM6j4sCbbRyX6kR3bxFPdAeFrI7XSAKV1fYy2GRT473rWifAXZnba
	AD2ILjMwwOSWqKZAntnKsGOv/joz7zcuVc6mKOlPv/IKK+qbGpmIAQoSDXpqkQ==
Message-ID: <8b4194fcb6fdb11af10fc81a1a7c915ad71003a0.camel@mailbox.org>
Subject: Re: [PATCH 1/3] drm: fix typos in comments
From: Philipp Stanner <phasta@mailbox.org>
Reply-To: phasta@kernel.org
To: Hemanth Selam <hemanth.selam@gmail.com>, Sumit Semwal	
 <sumit.semwal@linaro.org>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, Andrzej Hajda <andrzej.hajda@intel.com>, Neil
 Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>,
 Laurent Pinchart	 <Laurent.pinchart@ideasonboard.com>, Jonas Karlman
 <jonas@kwiboo.se>, Jernej Skrabec <jernej.skrabec@gmail.com>, Luca Ceresoli
 <luca.ceresoli@bootlin.com>, Maarten Lankhorst	
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Inki Dae	 <inki.dae@samsung.com>, Jagan
 Teki <jagan@amarulasolutions.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Patrik Jakobsson
 <patrik.r.jakobsson@gmail.com>, Laurentiu Palcu	
 <laurentiu.palcu@oss.nxp.com>, Lucas Stach <l.stach@pengutronix.de>, Frank
 Li	 <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix
 Kernel Team <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>,
 Jianmin Lv <lvjianmin@loongson.cn>,  Qianhai Wu <wuqianhai@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Mingcong Bai <jeffbai@aosc.io>,  Xi
 Ruoyao <xry111@xry111.site>, Icenowy Zheng <zhengxingda@iscas.ac.cn>, Dave
 Airlie	 <airlied@redhat.com>, Jocelyn Falempe <jfalempe@redhat.com>, Lyude
 Paul	 <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Tomi
 Valkeinen	 <tomi.valkeinen@ideasonboard.com>, Jessica Zhang
 <jesszhan0024@gmail.com>,  Gerd Hoffmann <kraxel@redhat.com>, Kieran
 Bingham <kieran.bingham+renesas@ideasonboard.com>, Geert Uytterhoeven
 <geert+renesas@glider.be>, Magnus Damm <magnus.damm@gmail.com>, Matthew
 Brost	 <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>,
 Chen-Yu Tsai	 <wens@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Huang Rui	 <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, Dave
 Stevenson	 <dave.stevenson@raspberrypi.com>, =?ISO-8859-1?Q?Ma=EDra?= Canal
	 <mcanal@igalia.com>, Raspberry Pi Kernel Maintenance	
 <kernel-list@raspberrypi.com>, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>,  Gurchetan Singh
 <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, Zack Rusin
 <zack.rusin@broadcom.com>,  Broadcom internal kernel review list	
 <bcm-kernel-feedback-list@broadcom.com>, Michal Simek
 <michal.simek@amd.com>,  Philipp Zabel <p.zabel@pengutronix.de>, Natalie
 Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,  Johannes Weiner
 <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	nouveau@lists.freedesktop.org, virtualization@lists.linux.dev, 
	spice-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, cgroups@vger.kernel.org
Date: Fri, 04 Sep 2026 14:13:48 +0200
In-Reply-To: <20260904120430.17224-2-hemanth.selam@gmail.com>
References: <20260904120430.17224-1-hemanth.selam@gmail.com>
	 <20260904120430.17224-2-hemanth.selam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: zf7yfabkcpirabg1gmuxkipyi6aabu79
X-MBO-RS-ID: 16637102b3b78a827a3

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDE3OjM0ICswNTMwLCBIZW1hbnRoIFNlbGFtIHdyb3RlOgo+
IEZpeCB0eXBvcyBpbiBjb21tZW50cywgcmVwb3J0ZWQgYnkgc2NyaXB0cy9jaGVja3BhdGNoLnBs
IHVzaW5nIHRoZQo+IG1pc3NwZWxsaW5nIGxpc3QgaW4gc2NyaXB0cy9zcGVsbGluZy50eHQuwqAg
T25seSB0b3VjaGVzIGNvbW1lbnRzLCBubyBjb2RlCj4gY2hhbmdlcy4KPiAKPiBBc3Npc3RlZC1i
eTogQ3Vyc29yOmNsYXVkZS1vcHVzLTUKPiBTaWduZWQtb2ZmLWJ5OiBIZW1hbnRoIFNlbGFtIDxo
ZW1hbnRoLnNlbGFtQGdtYWlsLmNvbT4KPiAtLS0KPiDCoGRyaXZlcnMvZG1hLWJ1Zi9zeW5jX2Rl
YnVnLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL2JyaWRnZS9wYXJhZGUtcHM4NjIyLmPCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9icmlk
Z2Uvc2Ftc3VuZy1kc2ltLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiAr
LQo+IMKgZHJpdmVycy9ncHUvZHJtL2JyaWRnZS90YzM1ODc2Ny5jwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNiArKystLS0KPiDCoGRyaXZlcnMvZ3B1L2RybS9k
aXNwbGF5L2RybV9kcF9tc3RfdG9wb2xvZ3kuY8KgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDC
oGRyaXZlcnMvZ3B1L2RybS9kcm1fZHJ2LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL2dt
YTUwMC9vYWt0cmFpbF9sdmRzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIg
Ky0KPiDCoGRyaXZlcnMvZ3B1L2RybS9nbWE1MDAvcG93ZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9n
bWE1MDAvcHNiX2Rydi5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfCA0ICsrLS0KPiDCoGRyaXZlcnMvZ3B1L2RybS9pbXgvZGNzcy9kY3NzLWN0eGxkLmPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJt
L2xvb25nc29uL2xzZGNfZHJ2LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfZzIwMHNlLmPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL25vdXZl
YXUvZGlzcG52NTAvdGlsZS5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+
IMKgZHJpdmVycy9ncHUvZHJtL25vdXZlYXUvbm91dmVhdV9iaW9zLmPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9ub3V2ZWF1L25vdXZl
YXVfZXhlYy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBkcml2
ZXJzL2dwdS9kcm0vbm91dmVhdS9ub3V2ZWF1X2xlZC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9ub3V2ZWF1L252a20vZW5naW5l
L2dyL2N0eG52NTAuY8KgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9ub3V2
ZWF1L252a20vZW5naW5lL2dyL2dmMTAwLmPCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJp
dmVycy9ncHUvZHJtL29tYXBkcm0vZHNzL2Rpc3BjLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB8IDQgKystLQo+IMKgZHJpdmVycy9ncHUvZHJtL29tYXBkcm0vb21hcF9n
ZW0uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBk
cml2ZXJzL2dwdS9kcm0vcGFuZWwvcGFuZWwtbm92YXRlay1udDM2NjcyYS5jwqDCoMKgwqDCoMKg
wqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9wYW5lbC9wYW5lbC1zYW1zdW5nLXM2ZTYz
ajB4MDMuY8KgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9xeGwvcXhsX2dl
bS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAy
ICstCj4gwqBkcml2ZXJzL2dwdS9kcm0vcmVuZXNhcy9yY2FyLWR1L3JjYXJfbHZkcy5jwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS9zY2hlZHVsZXIvc2No
ZWRfbWFpbi5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA0ICsrLS0KPiDCoGRy
aXZlcnMvZ3B1L2RybS9zdW40aS9zdW40aV90Y29uLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL3RpbnkvcGFuZWwtbWlw
aS1kYmkuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBkcml2
ZXJzL2dwdS9kcm0vdHRtL3R0bV9wb29sLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBkcml2ZXJzL2dwdS9kcm0vdmM0L3ZjNF9oZG1p
LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICst
Cj4gwqBkcml2ZXJzL2dwdS9kcm0vdmM0L3ZjNF9yZWdzLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBkcml2ZXJzL2dwdS9kcm0vdmly
dGlvL3ZpcnRncHVfaW9jdGwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiAr
LQo+IMKgZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC9kZXZpY2VfaW5jbHVkZS92bV9iYXNpY190eXBl
cy5oIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC90dG1fb2JqZWN0LmPCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2Ry
bS92bXdnZngvdm13Z2Z4X2Rydi5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfCA2ICsrKy0tLQo+IMKgZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJt
L3Ztd2dmeC92bXdnZnhfa21zLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X3NvLmjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9ncHUvZHJt
L3Ztd2dmeC92bXdnZnhfc3VyZmFjZS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwg
MiArLQo+IMKgZHJpdmVycy9ncHUvZHJtL3hsbngvenlucW1wX2RwLmPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGRyaXZlcnMvZ3B1L2lwdS12
My9pcHUtcHJnLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHwgMiArLQo+IMKgaW5jbHVkZS9kcm0vZHJtX2ZyYW1lYnVmZmVyLmjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDQgKystLQo+IMKgaW5j
bHVkZS9kcm0vZHJtX3BsYW5lLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0KPiDCoGluY2x1ZGUvdWFwaS9kcm0vbm91
dmVhdV9kcm0uaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8IDIgKy0KPiDCoGluY2x1ZGUvdWFwaS9kcm0vdm13Z2Z4X2RybS5owqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4gwqBrZXJuZWwvY2dy
b3VwL2RtZW0uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgNDUgZmlsZXMgY2hhbmdlZCwgNTMgaW5z
ZXJ0aW9ucygrKSwgNTMgZGVsZXRpb25zKC0pCgpUaGF0J3MgYSBsb3Qgb2YgY2h1cm4KCj4gCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hLWJ1Zi9zeW5jX2RlYnVnLmggYi9kcml2ZXJzL2RtYS1i
dWYvc3luY19kZWJ1Zy5oCj4gCgpb4oCmXQoKCj4gLQkvKiBEUEkgaW50ZXJmYWNlIGNsb2NrIGxp
bWl0YXRpb246IHVwdG8gMTAwIE1IeiAqLwo+ICsJLyogRFBJIGludGVyZmFjZSBjbG9jayBsaW1p
dGF0aW9uOiB1cCB0byAxMDAgTUh6ICovCj4gwqAJaWYgKG1vZGUtPmNsb2NrID4gMTAwMDAwKQo+
IMKgCQlyZXR1cm4gTU9ERV9DTE9DS19ISUdIOwo+IAoKW+KApl0KCj4gwqAKPiAtLyogRm9yIG11
bHRpcGxlIEdQVSBkcml2ZXIgaW5zdGFuY2UgY28tZXhpeHQgaW4gdGhlIHN5c3RlbSAqLwo+ICsv
KiBGb3IgbXVsdGlwbGUgR1BVIGRyaXZlciBpbnN0YW5jZSBjby1leGlzdCBpbiB0aGUgc3lzdGVt
ICovCj4gwqAKPiAKClvigKZdCgo+IMKgCj4gLQkvKiBzZXQgbHRwcyB0aW1taW5nIDAsIDEgKi8K
PiArCS8qIHNldCBsdHBzIHRpbWluZyAwLCAxICovCgoKUGxhY2VzIGxpa2UgdGhlc2UgYXJlIGNl
cnRhaW5seSBjYW5kaWRhdGVzIHRoYXQgb25lIG1pZ2h0IHdhbnQgdG8gZ2l0LQpibGFtZSB0byBm
aWd1cmUgb3V0IG1vcmUgYWJvdXQgdGhlIGJhY2tncm91bmQuCgpOb3Qgc3VyZSBpZiB0aGUgY29z
dC1iZW5lZml0LXJhdGlvIHdvdWxkIHRoZW4gcGF5IG9mZj8KCgpQLgo=

