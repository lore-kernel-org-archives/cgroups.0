Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A53B05A4
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 03:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788491584; cv=none; b=K+EBCG7slYFlkJc0GJphiryRVkF7YnGBPsw2oye7aMYfdcQsY9p045wwwZc8z7u0Q496+A9m0QPo4DNAtD9ju+kfn0DojYPHycAAwxZdTZ/94G3vysIT825SrChh5sFwt4nQ5BecMKL5x7lKq1Dp6qG7yAxtNyvS4Fe7uN3XTNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788491584; c=relaxed/simple;
	bh=7ZYURzTjNpp5Jb3huda0uhTCqkZeMQ88SC6undWpr6s=;
	h=References:Date:Message-Id:In-Reply-To:Cc:From:Subject:To:
	 Mime-Version:Content-Type; b=PEobLGzFwYkV4ZZsrWMQMfeBECRsKFBKpg2Gcxf5TICByToOJEq0i2fJAMXtioXFy4r58vOdz2Kha+YqriUPgkoZ2qNNNgwMUko/BnhXv8lew7LiEsICclpUexIQlT1ekcZZA5P7ugwKOjKJLJ51p0MRFRM9Uik7empH7F7ReeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=SKbpGInE; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="SKbpGInE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788491571;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0eB8FmLlkMeY0eoTlosmEVMIfxb8DfMhD7pOp16Dnzs=;
 b=SKbpGInEy5OHEPdbZ65Xl6TrNqBnUBt0g+LdHz7D41PwG0zGkO9DvFFe3xJwUCWvRvsUL3
 lYV9zHNhNKYFycf+9cxS7jbb4GnrCNPHVFrLUw8zjdPTwpcKKASb5G6qw29oGnuZL5myaf
 P15dLgYERK52rEQayyXVnfbBaSCbn4XuzLpQXcZ9thxQb+exa2c8kILxMcYny85WgUPqn5
 5/xy0mlcnvxEC9F723h8KaRXDArZoEHWFmyf8+lD43mEYQP6YKZoESrWLIZgiSvjgacpdR
 YsYYWvzpNesCh/nBIwwIj6DERCVLGoangKaJ5mW2VTWYOLxRNHh0vSMwz5YiJw==
References: <20260904030607.1193800-1-cui.tao@linux.dev>
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 4 Sep 2026 11:12:45 +0800
Message-Id: <63b0770e-844a-4249-a64e-85b1e1978fab@fygo.io>
In-Reply-To: <20260904030607.1193800-1-cui.tao@linux.dev>
X-Lms-Return-Path: <lba+26a9a3732+d20b5f+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Fri, 04 Sep 2026 03:12:50 +0000
Cc: <tj@kernel.org>, <linux-block@vger.kernel.org>, <josef@toxicpanda.com>, 
	<cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<david.laight.linux@gmail.com>, <haris.iqbal@linux.dev>, 
	<cuitao@kylinos.cn>, "Yu Kuai" <yukuai@huawei.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v5] blk-throttle: fix divide-by-zero on legacy iops limit of 0
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/9/4 11:06, Tao Cui =E5=86=99=E9=81=93:
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
> triggering a divide-by-zero oops.
>
> Fix it in tg_set_conf() by clamping the value to UINT_MAX, consistent
> with tg_set_limit(). This closes the truncation root cause: with 0 no
> longer reachable as a stored limit, the HZ / iops_limit divide is never
> hit.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> Reviewed-by: Yu Kuai <yukuai@huawei.com>
This tag is wrong, please use yukuai@fygo.io.
>
> ---
> Changes in v5:
> - Rebase onto current linux-next head (no code change, context shifted on=
ly).
> - Add the Reviewed-by tag collected on v4.
> - Link to v4: https://lore.kernel.org/r/20260722102459.253189-1-cui.tao@l=
inux.dev
>
> Changes in v4:
> - Drop the defensive "iops_limit =3D=3D 0" check in tg_dispatch_iops_time=
():
>    with the tg_set_conf() clamp in place, 0 can never be stored as a limi=
t,
>    so the runtime check only guards an unreachable state. (Yu Kuai)
> - Drop the Fixes: tag: the unclamped write -- and the iops=3D0 behavior i=
t
>    can produce (calculate_io_allowed() returns 0, so no IO is issued) --
>    long predates the commit that added the HZ / iops_limit divide, so
>    attributing it there was incorrect. (Yu Kuai)
>
> Changes in v3:
> - Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accept=
s
>    two unsigned types of different width (both >=3D 4 bytes), so
>    min(v, UINT_MAX) compiles clean. (David Laight)
>
> Changes in v2:
> - Use a "void *field" local for the config write so the assignment reads
>    *(u64 *)field / *(unsigned int *)field instead of the
>    (type *)((void *)tg + of_cft(of)->private) casts.
> - Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
> ---
>   block/blk-throttle.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index ffc3b70065d4..97ad7959d006 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1383,10 +1383,12 @@ static ssize_t tg_set_conf(struct kernfs_open_fil=
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
