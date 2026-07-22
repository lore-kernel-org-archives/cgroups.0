Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE94071E4
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 07:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784705125; cv=none; b=DN5tdHTubC5bVEYzhN7PR1nS50p2NohiDT7J3oX6Bl/SNYLj1p2rUS4Hzhfp1gXjp5GILaIguJdg5hHIWWaDrfQ/SG3DTYR2IdydoJc2K3nBikBq5ABDEOAqfwYTLSXpjyHKm3DEwcPUmmAVz9qrsuHl+yWTroWa15ExFpu+2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784705125; c=relaxed/simple;
	bh=zB7U2ir+JJuCSEgAyWkNgy3e7Zs1/My/cXM8Kax0PVc=;
	h=In-Reply-To:Cc:Message-Id:References:From:Mime-Version:
	 Content-Type:To:Subject:Date; b=j/QP/yGlImqBYD84OIyF/HUkjmqWLcLM1iP4/WlRhIR4/0QM6NcHAjkB4kcFiB+F9OwAPasmjGBULx4eS+vOLYc1Jphnb4xF/hatKDVKsG/geDmrFIZyZ8qNJM0eMv1peBLZk+VuZzP1HlRxhhtaXq/TWdjrHA7c9CuY4VXVPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=E3kFPVMc; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="E3kFPVMc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784705107;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=zx6TxZ6zM2UF5uSkDFusmCwpUxnBAKsbCIx5qZSDSh4=;
 b=E3kFPVMcGMIgwMBmt2pJkL/sRcwSPjGtT2eTuZjDDKH5ev+gprmtSdDp6IuDxZxaRNnQVB
 3JL9gdKzYZTdHn2WQn8Bu8SFc35zXOzq8wHepDYaHNNQgZizafcNFaP54xV3niROQJ+ql8
 dYNJ8W5BCQKrvF8xcV6SZvLd6u8E79Xm3BkP3Lv3iEAwsdUcGIeLiYAhRTIxS3SVpS9Xat
 vCNZUisvD23g3HjlnJqnmWKgUltpapewLUUghZljadgTc6u20hbwuO3xdCeusbsKF+s4id
 sZunxtZCcZM8O8WWwuOkGvwezAVJAUK/J+ByHKQrW/DsdXS56v0IQ1WDbjoYLQ==
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260721040850.90544-1-cui.tao@linux.dev>
Reply-To: yukuai@fygo.io
Cc: <linux-block@vger.kernel.org>, <josef@toxicpanda.com>, 
	<cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<david.laight.linux@gmail.com>, <haris.iqbal@linux.dev>, 
	"Tao Cui" <cuitao@kylinos.cn>
Message-Id: <3e1616f1-1dc1-4912-8404-4f53b2d1205c@fygo.io>
References: <20260721040850.90544-1-cui.tao@linux.dev>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 22 Jul 2026 07:25:05 +0000
X-Lms-Return-Path: <lba+26a607052+bbbe3f+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Tao Cui" <cui.tao@linux.dev>, <tj@kernel.org>, <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] blk-throttle: fix divide-by-zero on legacy iops limit of 0
Date: Wed, 22 Jul 2026 15:25:02 +0800

Hi,

=E5=9C=A8 2026/7/21 12:08, Tao Cui =E5=86=99=E9=81=93:
> From: Tao Cui <cuitao@kylinos.cn>
>
> Writing a multiple of 2^32 (e.g. 4294967296) to a legacy cgroup v1
> throttle iops file (blkio.throttle.{read,write}_iops_device) silently
> truncates to 0: tg_set_conf() stores the sscanf-parsed u64 value into
> an unsigned int field with no clamping. The cgroup v2 path,
> tg_set_limit(), already clamps the same kind of value with
> min_t(u64, val, UINT_MAX), but the legacy path never did. Note that
> the "!v -> U64_MAX" mapping only catches an explicit zero and does not
> catch a value that truncates to zero.
>
> With iops stored as 0, tg_update_has_rules() sets has_rules_iops[] and
> the next IO reaches tg_within_iops_limit(), which computes
>
>      jiffy_wait =3D max(jiffy_wait, HZ / iops_limit + 1);
>
> triggering a divide-by-zero oops. The unclamped write in tg_set_conf()
> is long-standing, but it only became a crash once the HZ / iops_limit
> divide was added.
>
> Fix it in two places:
>
>    * tg_set_conf(): clamp the value to UINT_MAX, consistent with
>      tg_set_limit(). This closes the truncation root cause (and the
>      general silent truncation for any value above UINT_MAX).
>
>    * tg_dispatch_iops_time(): treat iops_limit =3D=3D 0 as unlimited so t=
he
>      divide in tg_within_iops_limit() is never reached, defending
>      against any future path that could produce a zero limit.
>
> Fixes: 1beabab88ece ("blk-throttle: fix lower control under super low iop=
s limit")

I think the root cause is that iops_limit set to 0, and what's the behavior=
 of throttle
with iops=3D0? Since calculate_io_allowed() will always return 0, it's like=
ly that no IO
can be issued.

> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>
> ---
> Changes in v3:
> - Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accept=
s
>    two unsigned types of different width (both >=3D 4 bytes), so
>    min(v, UINT_MAX) compiles clean. (David Laight)
> - Add a Fixes: tag pointing at the commit that introduced the
>    HZ / iops_limit divide, which is also where the oops became reachable.
>
> Changes in v2:
> - Use a "void *field" local for the config write so the assignment reads
>    *(u64 *)field / *(unsigned int *)field instead of the
>    (type *)((void *)tg + of_cft(of)->private) casts.
> - Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
> ---
>   block/blk-throttle.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index ffc3b70065d4..e894852c3142 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -883,7 +883,12 @@ static unsigned long tg_dispatch_iops_time(struct th=
rotl_grp *tg, struct bio *bi
>   	u32 iops_limit =3D tg_iops_limit(tg, rw);
>   	unsigned long iops_wait;
>  =20
> -	if (iops_limit =3D=3D UINT_MAX || tg->flags & THROTL_TG_CANCELING)
> +	/*
> +	 * iops_limit =3D=3D 0 is not a valid limit. Treat it as unlimited so w=
e
> +	 * never reach the HZ / iops_limit divide in tg_within_iops_limit().
> +	 */
> +	if (iops_limit =3D=3D UINT_MAX || iops_limit =3D=3D 0 ||
> +	    tg->flags & THROTL_TG_CANCELING)
>   		return 0;

Is the above still needed with the tg_set_conf() changes? 0 is not a valid =
limit, and
it should not exist in the first place, so I don't like the above new check=
ing.

>  =20
>   	tg_update_slice(tg, rw);
> @@ -1383,10 +1388,12 @@ static ssize_t tg_set_conf(struct kernfs_open_fil=
e *of,
>   	tg =3D blkg_to_tg(ctx.blkg);
>   	tg_update_carryover(tg);
>  =20
> +	void *field =3D (void *)tg + of_cft(of)->private;
> +
>   	if (is_u64)
> -		*(u64 *)((void *)tg + of_cft(of)->private) =3D v;
> +		*(u64 *)field =3D v;
>   	else
> -		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D v;
> +		*(unsigned int *)field =3D min(v, UINT_MAX);
>  =20
>   	tg_conf_updated(tg, false);
>   	ret =3D 0;

--=20
Thanks,
Kuai
