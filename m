Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1125E14884C
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784266586; cv=none; b=MCkEwEKdCQiyxjaqZKUwx/z3DWkafPSVnhZv5klT4jWCH8m5FEx5TXlzbnUfuyfwzjMfCUB1O2iF1w4hp4S4GqqmjSMLJHvk8HzaadCGyyPiw8VZXxrCL2OBPqSxSWuLmcFLg9JZi8reVKH3n/jh3U36rma0rvAmOAVI7dd8NYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784266586; c=relaxed/simple;
	bh=FNq0Elant24kkiYtnQs2TKCca1NZM8i9Ij80pV5k4Eo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AHVbS86yTCTdHipweo5d+86gsQEDuOVDvTHmHUWZ9XNQABfD+FKd/c2pw1Ccg4zG5L5/EIAw8C6PtlWd2fDJ+ILplL0fgKiQHRiEwMuyW86xIKv53TtMNb3lItJ1jXcrqYorzFe83fOB1PFA6q7h84RNTB/+xmbQG7LxmufGFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CWVyQH+N; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CWVyQH+N"
Message-ID: <418d9e2a-30b8-47d8-b919-6a777e0993f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784266573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcRB4Avd0MbFgOFriFB0XK0icO6elvADBhLdoUkMupE=;
	b=CWVyQH+NmDQKF1EsqZ1/zgWEqgi8EVoB2by/y8LnnlK0JQYL5++79WAxSMXVwt5PwNT3xa
	t8aB84wDxLPk8hLAdzEEfX5mpuPgeuP+cmFzu6ipIJFnht04OCr50jc5zLf+8YxWEJqNqf
	YveJ9qwCg6GFG4JEU7qeYo9oiu5hf3Y=
Date: Fri, 17 Jul 2026 13:36:05 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] blk-iolatency: use spin_lock_irqsave() in
 iolatency_clear_scaling()
To: Tao Cui <cui.tao@linux.dev>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
References: <20260717040653.1999364-1-cui.tao@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <20260717040653.1999364-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 17/7/26 12:06, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> child_lat.lock is acquired with spin_lock_irqsave() in both
> iolatency_check_latencies() (called from the blkcg_iolatency_done_bio()
> softirq path) and blkiolatency_timer_fn() (timer softirq).
> iolatency_clear_scaling() instead uses a plain spin_lock(), which only
> happens to be safe because both of its callers enter with interrupts
> already disabled:
> 
>   * iolatency_set_limit() runs under queue_lock via blkg_conf_prep(),
>     which returns with the lock held and interrupts disabled;
>   * iolatency_pd_offline() runs under queue_lock from blkg_destroy() and
>     blkcg_deactivate_policy(), both of which take it with spin_lock_irq().
> 
> Take the lock with spin_lock_irqsave()/spin_unlock_irqrestore() so the
> locking is self-contained and consistent with the other two sites, instead
> of relying on an undocumented caller precondition. No functional change.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-iolatency.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index cef02b6c5fa9..68b74258cd95 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -811,16 +811,17 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
>  	if (blkg->parent) {
>  		struct iolatency_grp *iolat = blkg_to_lat(blkg->parent);
>  		struct child_latency_info *lat_info;
> +		unsigned long flags;
>  		if (!iolat)
>  			return;
>  
>  		lat_info = &iolat->child_lat;
> -		spin_lock(&lat_info->lock);
> +		spin_lock_irqsave(&lat_info->lock, flags);

Better to use guard(spinlock_irqsave)(&lat_info->lock).

Thanks,
Leon

>  		atomic_set(&lat_info->scale_cookie, DEFAULT_SCALE_COOKIE);
>  		lat_info->last_scale_event = 0;
>  		lat_info->scale_grp = NULL;
>  		lat_info->scale_lat = 0;
> -		spin_unlock(&lat_info->lock);
> +		spin_unlock_irqrestore(&lat_info->lock, flags);
>  	}
>  }
>  

