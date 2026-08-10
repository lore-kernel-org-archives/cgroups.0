Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A6415F2C
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380254; cv=none; b=Un0fqdoXrYXW/JeziJQaOBkFESFmF0mYCKc3qZYrBFi5jFXjDA3a0KOh213BQI6lje3ULARMWbIXydjET4gmIAhgmF9pfiutC/qGpJEQ8qi7NGIT+IQNc6VMnWIZwRQ1CDUQa7S0RucYVnfTYJyzTBJQaepz2WIlYQ145QlwfsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380254; c=relaxed/simple;
	bh=xH2TjijH4L0pZUaO19L4oc/fwZHipDZXW4i/CUti4JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdFWQs+VcidICmjWad/Do1nyL4BgwisYQMnj+ftZnycJr8/tc4QmtWbxC12WqBA6uBXL11FHKH1CnRb7sVOBkRpBo3p6XNlzJmF3DbO0FPz3j/UMV9XhswpLiq9DrQXP9nmQqCjkys6K8zXlP3mOs42eetdZzajtwUTcw5mGeEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eYPHbJ5C; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eYPHbJ5C"
Message-ID: <0326caea-07e7-43bf-8fe9-f2b97186e2ad@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786380249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dvRKUz02zwA8HyH/n0hNXFDDKNnkkQlJlIi+qS6R+7c=;
	b=eYPHbJ5Cg2bGa2NrHt+xPTgN6hhvKRlI94T6nx6BfE9HUEhYLaxWR79Idod5AaH7vUPv+t
	58pAboHnuRPAKW1NtT+vLSsCgDp3QdS9+LI4aevuuqawXsMj+e3IMcZhQw7cQg4fOqbg8M
	2MH7Z34wShqCDedZyQXEtPekt9YpPRU=
Date: Mon, 10 Aug 2026 17:43:59 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] blk-iocost: clear delay state when freeing policy
 data
To: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260806183742.946953-1-usama.arif@linux.dev>
 <20260806183742.946953-3-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260806183742.946953-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 06/08/2026 19:37, Usama Arif wrote:
> iocg_kick_delay() turns sufficiently large debt into an explicit
> block-cgroup delay with blkcg_set_delay(), setting blkg->use_delay to
> -1 and incrementing blkcg->congestion_count.  Clearing it again depends
> on iocg_kick_delay() running from the period timer, the waitq timer or
> the issue path.
> 
> ioc_pd_free() removes the iocg from active_iocgs and cancels its waitq
> timer, and no further bios can arrive, so once it has run nothing is
> left which can reduce the debt and clear the delay.  The blkcg stays
> marked congested for the rest of its life.
> 
> blk_cgroup_congested() then returns true for every task in that cgroup
> and its descendants: page_cache_sync_ra() cuts readahead to a single
> page, page_cache_async_ra() skips it altogether, and
> __folio_throttle_swaprate() takes swap_avail_lock and schedules a
> throttle on anonymous folio allocation.
> 
> Clear it explicitly, after the list removal and the synchronous
> hrtimer_cancel() so that neither timer processing nor an I/O path can
> re-arm it.  The free callback can also see policy data which was never
> attached to a blkg, hence the pd->blkg check.
> 
> Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  block/blk-iocost.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index b60625613e095..64b92aa3e5d48 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3063,6 +3063,7 @@ static void iocg_release(struct rcu_head *rcu)
>  static void ioc_pd_free(struct blkg_policy_data *pd)
>  {
>  	struct ioc_gq *iocg = pd_to_iocg(pd);
> +	struct blkcg_gq *blkg = pd_to_blkg(pd);
>  	struct ioc *ioc = iocg->ioc;
>  	unsigned long flags;
>  
> @@ -3085,6 +3086,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
>  		hrtimer_cancel(&iocg->waitq_timer);
>  	}
>  
> +	/* off ->active_iocgs and timer gone, so nothing can re-arm the delay */
> +	iocg->delay = 0;
> +	iocg->indelay_since = 0;
> +	if (blkg)
> +		blkcg_clear_delay(blkg);
> +


Sashiko reported:

---
[Severity: High]
Does this unconditional call to blkcg_clear_delay() overwrite state managed
by other policies?

Since use_delay is shared among block cgroup policies, if iocost never
actually applied a delay, this might forcefully zero out the delay state
managed by other active policies like blk-iolatency. 

Would it be safer to check if iocost had actually set a delay before clearing
it here?
---


My understanding is that this requires both policies to coexist on the same
device/blkg?

I believe the main problematic sequence would be:

  1. io.latency owns positive use_delay.
  2. io.cost policy data exists but may never have delayed anything.
  3. io.cost policy data is freed while the blkg survives.
  4. Its unconditional clear removes io.latency’s state.

With only one policy, the terminal clear is correct and clearing zero is harmless.

The concern is narrower still: ordinary disk/cgroup destruction removes the whole
blkg, so the main observable case is one-policy activation rollback or deactivation
while the other remains active.

I am not sure if this is something that is done by users? So might not need
to be addressed?

Thanks,
Usama


>  	call_rcu(&pd->rcu_head, iocg_release);
>  }
>  

