Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1A1AF0BB
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 02:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787280370; cv=none; b=q10PTvG92ZELAVPvQ7D7IlJMm0xTowxvIjK2ifI1dZxHevKLQoLtjy8+4jeqErxLHCpM6ByBllsnFWZJAF0QbuajnIC88ZGMv/ugKq/WIJCNu9BwGveW0DRFGzCgvmabp+4Kj92o5x5+lNN533sLbZ/N4KJz33i95YH232DAiDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787280370; c=relaxed/simple;
	bh=9rDVrRfzZBCC9jJ3URnpdQEQQOnaj//MJ7Ba1g2oMqc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mUO33JTSoFCZ0mQVmHeVfq+ugI5aPunpaGmg5xpIhk3w22qwKTlkrfTpuYGGsB2PLkzNvBnr+3jZgU0RfIA0MQHE5g0QhjG+2t94uTr4WDYRyTbF1SxJBh55bCL52yGQs1ie40qKELQ2b7q27ztm0PWkfm/2Gq2gMmVgqT1kOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G0UWbhnr; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G0UWbhnr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9rDVrRfzZBCC9jJ3URnpdQEQQOnaj//MJ7Ba1g2oMqc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787280366; v=1; x=1787885166;
 b=G0UWbhnrTkPt/YSv5A0+9VoG3tQUDbENvWAWTITwE7AczNn47I73U7BDFlTjdl6rup+zR8n4
 aS5u902niJDMot7L31f/L4rRvGFIcJek6d0v28hORcGsNW9wlE5Be0uw3uzPZuma35+45xP49E9
 gO6Mb+6aE7P3ZCxROlxFBqMk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id ab17684995f18d63;
	Fri, 21 Aug 2026 02:45:56 +0000
X-Mizu-Trace-ID: ab17684995f18d63
X-Migadu-Flow: FLOW_OUT
Message-ID: <b382ca10-090e-411a-afd9-37d84b6c7281@linux.dev>
Date: Fri, 21 Aug 2026 10:45:48 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: Remove dead check in tg_conf_updated()
To: Tang Yizhou <yizhou.tang@shopee.com>, yukuai@fygo.io, tj@kernel.org,
 axboe@kernel.dk
References: <20260820160547.357682-1-yizhou.tang@shopee.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260820160547.357682-1-yizhou.tang@shopee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/21 00:05, Tang Yizhou 写道:
> From: Tang Yizhou <yizhou.tang@shopee.com>
> 
> The check in tg_conf_updated() was introduced for io.low, so remove it.
> 
> global ? tg->td->queue->root_blkg : tg_to_blkg(tg) was introduced in
> commit 9bb67aeb9678 ("blk-throttle: respect 0 bps/iops settings for
> io.low"). Remove it, too.
> 
> Fixes: bf20ab538c81 ("blk-throttle: remove CONFIG_BLK_DEV_THROTTLING_LOW")
> Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
> ---
>  block/blk-throttle.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index ffc3b70065d4..fa742e63807d 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1267,7 +1267,7 @@ static int tg_print_conf_uint(struct seq_file *sf, void *v)
>  	return 0;
>  }
>  
> -static void tg_conf_updated(struct throtl_grp *tg, bool global)
> +static void tg_conf_updated(struct throtl_grp *tg)
>  {
>  	struct throtl_service_queue *sq = &tg->service_queue;
>  	struct cgroup_subsys_state *pos_css;
> @@ -1286,16 +1286,8 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
>  	 * restrictions in the whole hierarchy and allows them to bypass
>  	 * blk-throttle.
>  	 */
> -	blkg_for_each_descendant_pre(blkg, pos_css,
> -			global ? tg->td->queue->root_blkg : tg_to_blkg(tg)) {
> -		struct throtl_grp *this_tg = blkg_to_tg(blkg);
> -
> -		tg_update_has_rules(this_tg);
> -		/* ignore root/second level */
> -		if (!cgroup_subsys_on_dfl(io_cgrp_subsys) || !blkg->parent ||
> -		    !blkg->parent->parent)
> -			continue;
> -	}
> +	blkg_for_each_descendant_pre(blkg, pos_css, tg_to_blkg(tg))
> +		tg_update_has_rules(blkg_to_tg(blkg));
>  	rcu_read_unlock();
>  
>  	/*
> @@ -1388,7 +1380,7 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
>  	else
>  		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
>  
> -	tg_conf_updated(tg, false);
> +	tg_conf_updated(tg);
>  	ret = 0;
>  
>  unprep:
> @@ -1610,7 +1602,7 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
>  	tg->iops[READ] = v[2];
>  	tg->iops[WRITE] = v[3];
>  
> -	tg_conf_updated(tg, false);
> +	tg_conf_updated(tg);
>  	ret = 0;
>  unprep:
>  	blkg_conf_unprep(&ctx);

Reviewed-by: Tao Cui <cuitao@kylinos.cn>


