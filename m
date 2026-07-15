Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857FB3B1016
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132016; cv=none; b=cRNVzJSVBhmZUmWv1Gc9kYz4i8Y1eBqqoyAB/LkTydtyKGG5EIwZzoGtMjRjRd1dGXzoRFqfop3KBbkFDXEBRLZU/6mdrpNfRwB0KqkCHs5kMd/cfeS8/fN4ahgLStxtC1EO3UOBBKn8bk1/OTHfdXWHsPXTUMliuP6FZ4cPux8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132016; c=relaxed/simple;
	bh=zSVAMJaQUDsFciFJg16/GmBBW9Wmrg9p11I0eoysN8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8L6rE0RRAaIY1Av1aAtd5NOFIB4RlpQs1G0ctLvLc8p3nvqYegVb8gU2BTpnvyUd+qYZRqMDsC4r3Vcwso7aK2p9VpsBdydczCVSjUtT3VMTFG+6mW8q0v8ir+SIb1llaRzCayc1ymLpfQVphupsulemNe+Urs7NzNRPXOAJxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=roc/xdTy; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="roc/xdTy"
Message-ID: <d7d251c8-c0a7-493d-ab7a-386d441b93cb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784131997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuYmew9g9h1Lk97Vz/1tfuW0aB6gC3MArV36HTaSGi8=;
	b=roc/xdTySo+nrg9PSt4WT8U1UwJT0JrEhJbfLQzJh57hdA4VQVNgVWX6YbUwVOAY77ylBF
	RrKlhtVrExzt5yAefTZrtuaRwQ1WGRqrbJzCu0iiWqNDUz0F0KX3dPC+IDCrDrOaexmv/v
	HkN16fFiVtHCv3jsAIw/oBa0U/oQ5do=
Date: Wed, 15 Jul 2026 18:13:06 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] blk-throttle: fix divide-by-zero on legacy iops limit of
 0
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk, tj@kernel.org,
 josef@toxicpanda.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260714103552.1335658-1-cui.tao@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Haris Iqbal <haris.iqbal@linux.dev>
In-Reply-To: <20260714103552.1335658-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/14/26 12:35, Tao Cui wrote:
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
>      jiffy_wait = max(jiffy_wait, HZ / iops_limit + 1);
> 
> triggering a divide-by-zero oops.
> 
> Fix it in two places:
> 
>    * tg_set_conf(): clamp the value to UINT_MAX, consistent with
>      tg_set_limit(). This closes the truncation root cause (and the
>      general silent truncation for any value above UINT_MAX).
> 
>    * tg_dispatch_iops_time(): treat iops_limit == 0 as unlimited so the
>      divide in tg_within_iops_limit() is never reached, defending
>      against any future path that could produce a zero limit.
> 

Does this need a "Fixes:" tag.

> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>   block/blk-throttle.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index ffc3b70065d4..3f3c1374f4b2 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -883,7 +883,12 @@ static unsigned long tg_dispatch_iops_time(struct throtl_grp *tg, struct bio *bi
>   	u32 iops_limit = tg_iops_limit(tg, rw);
>   	unsigned long iops_wait;
>   
> -	if (iops_limit == UINT_MAX || tg->flags & THROTL_TG_CANCELING)
> +	/*
> +	 * iops_limit == 0 is not a valid limit. Treat it as unlimited so we
> +	 * never reach the HZ / iops_limit divide in tg_within_iops_limit().
> +	 */
> +	if (iops_limit == UINT_MAX || iops_limit == 0 ||
> +	    tg->flags & THROTL_TG_CANCELING)
>   		return 0;
>   
>   	tg_update_slice(tg, rw);
> @@ -1386,7 +1391,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
>   	if (is_u64)
>   		*(u64 *)((void *)tg + of_cft(of)->private) = v;
>   	else
> -		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
> +		*(unsigned int *)((void *)tg + of_cft(of)->private) =
> +			min_t(u64, v, UINT_MAX);
>   
>   	tg_conf_updated(tg, false);
>   	ret = 0;

