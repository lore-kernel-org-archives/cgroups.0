Received: from smtpout6.mo540.mail-out.ovh.net (smtpout6.mo540.mail-out.ovh.net [51.210.91.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51AF3932FF;
	Fri,  4 Sep 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525544; cv=none; b=X/BC8PbNy9vUdpGmWz99w/2EypZk5IoNQr/ym94YOQ8Y1v9qXypIgIe7JRrZuP+caUMZBpzShfe83cjPTRL1rfd8rmBEI1D0KZ6daywSJ6BTTjJE5tZ18dcyJNO8YOmHoazk7jbKY8QkWvS6xBWYyaz3aZNRYez0fDdZxPzu5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525544; c=relaxed/simple;
	bh=8i8MZ1/qFS2P05wCZtYgTfRY3mt6gpItpqxFbtVyYvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gcjDVHuR1FipgSSjWESidqPvlt2rwr6MypPn7kRumMlnz/IPtlunWRGLH1Mp/OMce7QeTWxyIdGyP8SH0w72dynwO0ZcFaL1BNm1jblZNepS3pmbj1lOhbJ6hnrOdPqTist3kV8I9pMNx4mHZnk3gVZPgwsBopCDaI7sTlZloIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev; spf=pass smtp.mailfrom=pixelcluster.dev; dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b=otHiJ7iQ; arc=none smtp.client-ip=51.210.91.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b="otHiJ7iQ"
Received: from director4.derp.mail-out.ovh.net (director4.derp.mail-out.ovh.net [79.137.60.37])
	by mo540.mail-out.ovh.net (Postfix) with ESMTPS id 4hbwpV2Pp2z455h;
	Fri,  4 Sep 2026 12:32:34 +0000 (UTC)
Received: from director4.derp.mail-out.ovh.net (director4.derp.mail-out.ovh.net. [127.0.0.1])
        by director4.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <Frank.Li@nxp.com>; Fri,  4 Sep 2026 12:32:34 +0000 (UTC)
Received: from mta7.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.43.121])
	by director4.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4hbwpV1HgYz1xtR;
	Fri,  4 Sep 2026 12:32:34 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.8])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta7.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id 4B2A6B81BAB;
	Fri,  4 Sep 2026 12:32:26 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-113S0071d6b9e02-16db-4ca9-b72a-504493c0eed8,
                    CD084BC5FAE4C285338CA88E85805D4DC0D096A2) smtp.auth=nat@pixelcluster.dev
X-OVh-ClientIp:88.133.252.134
Message-ID: <096f0b17-c3b1-4e21-9c4c-19d4d54ed5c4@pixelcluster.dev>
Date: Fri, 4 Sep 2026 14:32:25 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] drm: fix typos in comments
To: Hemanth Selam <hemanth.selam@gmail.com>,
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
 Danilo Krummrich <dakr@kernel.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Jessica Zhang <jesszhan0024@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Magnus Damm <magnus.damm@gmail.com>, Matthew Brost
 <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>,
 Chen-Yu Tsai <wens@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Dave Stevenson <dave.stevenson@raspberrypi.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Michal Simek
 <michal.simek@amd.com>, Philipp Zabel <p.zabel@pengutronix.de>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 nouveau@lists.freedesktop.org, virtualization@lists.linux.dev,
 spice-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
 linux-sunxi@lists.linux.dev, cgroups@vger.kernel.org
References: <20260904120430.17224-1-hemanth.selam@gmail.com>
 <20260904120430.17224-2-hemanth.selam@gmail.com>
Content-Language: en-US
From: Natalie Vock <nat@pixelcluster.dev>
In-Reply-To: <20260904120430.17224-2-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 13430297040255017248
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFa11X8MPefyVz0W+xYT6McySc8M1OGEC5um2de++lWDaODldo4x5c1SmsZgl7ab6s5BOAJBQMO7FEaMTLxk5ICKWBvH3aPaWyyyDzQ3TdZxPU1pHM6eVxT37jzPKjpHYa+vnLUA7Fp1H6WCDiKnKNaQkpBLV5TDLdb/WrYoAQzy3di5DV+yD1CEurw2PE52a5VIbw6dbtz2WwOc0ZeFb/8Efb8itrqt5uOAHjqX7iMI6+H8HX/8lYqq7G2fSt3pDt3qzjjbRa748f+2ytsmg6BgbyZsyWnco1edUpeARWXPm5pNwap6ItF+er4QWsnPNFi6D9vFRv/qAxc7SDmfv5aTPMHRd6ypyEmWu6EDqLYkIyXC/slEdCy7Mlhk0FaYWe2eFjmQWIA2WCnUnRDzGLdivJxZd6x4e1D4UaJBGT0CbU0QaDxn/A+LpM2nvLYTFhzY8aFizRd/nZ3Sg9gIhcsUcFTbZa3OtUI0+p0fEdbKTZY4vcAEHxsFrcgcipVsVFVVR7CbwrXQKlmCue+QRupJiu3rx+H2oA1mpXISoNYShKSMLkO0hm6hhqw0pGlxnNLIg5cFOsxAfyDR4pXw1/2Md3YJRXPShyP/65abvwvny2dswWE5iCGYWWt5lr5NBImQsaeS9nMjLcehvwGxgag3dvRVNhUVvFec3y2OBvzYg
DKIM-Signature: a=rsa-sha256; bh=KQWwePkaHLWrGVdQ/nUAn7Kxj2ie0pdYpRD+7um6kDk=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1788525155; v=1;
 b=otHiJ7iQOh8QmHTRjLZWC6T4+VxPZVpX9WLmC8Ohbxwk3K3It+9g6DFzKCum9ohphxPS5llF
 6qXo0g6fvbpaXGTtZxCI5zB4dyvq4QabCpRGCpBnt9l7W2IjgFUbdOpnBLAdsxJE6Os+QD7aRWf
 7sQDx1KRlt9nqBpSxjEzZqQbE2XhaLJVz9sP1cCBidfd4xRFgmJw/YXgmam4KLeqbrpHVbCu/Ar
 wREKlAzZ66Gm1WJ6S3D/RHrDktOqb07u8aH7qQNFwUrgoQTHnUCP+6Irek83qa+V2maXATnjDIz
 9ooScVq46U+zTcyj3/4q0XUesxV2I9iVQzxga+nUqZkcw==

On 9/4/26 14:04, Hemanth Selam wrote:
[snip]
> diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
> index 4683f3d68022..efbbf3100052 100644
> --- a/kernel/cgroup/dmem.c
> +++ b/kernel/cgroup/dmem.c
> @@ -28,7 +28,7 @@ DEFINE_STATIC_SRCU(dmemcg_srcu);
>   struct dmem_cgroup_region {
>   	/**
>   	 * @ref: References keeping the region alive.
> -	 * Keeps the region reference alive after a succesful RCU lookup.
> +	 * Keeps the region reference alive after a successful RCU lookup.
>   	 */
>   	struct kref ref;
>   

This is already fixed by commit 23df2e995df85 ("cgroup/dmem: fix comment 
typos in dmem.c") in drm-misc-next.

Regards,
Natalie

