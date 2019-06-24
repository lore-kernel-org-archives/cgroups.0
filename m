From: bsegall@google.com
Subject: Re: [PATCH v4 1/1] sched/fair: Return all runtime when cfs_b has very little remaining.
Date: Mon, 24 Jun 2019 10:33:07 -0700
Message-ID: <xm26tvcex50s.fsf@bsegall-linux.svl.corp.google.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
        <1561391404-14450-1-git-send-email-chiluk+linux@indeed.com>
        <1561391404-14450-2-git-send-email-chiluk+linux@indeed.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=uuOvSo3xWO35Xw+WnNqwoNVTpz5rWeBOf1tHuNaHtmg=;
        b=Y0Q3r//wjPiQUF+B7d4WvR5XQ2zagTAoKeDZai4fbSbgFUD/becgweM6VMPd46p2Y7
         DH0xFNgrwxisO1P7QqqmPDBgLsUTaUqvOa7mLrIvHdl4LS24z5R7nYXHYBAtryF/vBZp
         NgWmZ11HrGhAcgdCiIQSr6tWvRgeOEqLth3h+Z5nrdg4KGEWVGkVEMARpQ5r1mYkJi8V
         LHaIyNjhJKalLIMmtPzNYrOBmlpu+EcEDuiLCdM+jp4DWt4d8FIgSBte3CJUIpGjVbgr
         OA3+kqf/XrFgsiriJIyoypKCsW1lBvRJaaLk0seRXLlu/4RhnsLHrWUX3F1ojU7unjkO
         2vhQ==
In-Reply-To: <1561391404-14450-2-git-send-email-chiluk+linux@indeed.com> (Dave
        Chiluk's message of "Mon, 24 Jun 2019 10:50:04 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Phil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>

Dave Chiluk <chiluk+linux@indeed.com> writes:

> It has been observed, that highly-threaded, user-interactive
> applications running under cpu.cfs_quota_us constraints can hit a high
> percentage of periods throttled while simultaneously not consuming the
> allocated amount of quota. This impacts user-interactive non-cpu bound
> applications, such as those running in kubernetes or mesos when run on
> multiple cores.
>
> This has been root caused to threads being allocated per cpu bandwidth
> slices, and then not fully using that slice within the period. This
> results in min_cfs_rq_runtime remaining on each per-cpu cfs_rq. At the
> end of the period this remaining quota goes unused and expires. This
> expiration of unused time on per-cpu runqueues results in applications
> under-utilizing their quota while simultaneously hitting throttling.
>
> The solution is to return all spare cfs_rq->runtime_remaining when
> cfs_b->runtime nears the sched_cfs_bandwidth_slice. This balances the
> desire to prevent cfs_rq from always pulling quota with the desire to
> allow applications to fully utilize their quota.
>
> Fixes: 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift condition")
> Signed-off-by: Dave Chiluk <chiluk+linux@indeed.com>
> ---
>  kernel/sched/fair.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f35930f..4894eda 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4695,7 +4695,9 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun, u
>  	return 1;
>  }
>  
> -/* a cfs_rq won't donate quota below this amount */
> +/* a cfs_rq won't donate quota below this amount unless cfs_b has very little
> + * remaining runtime.
> + */
>  static const u64 min_cfs_rq_runtime = 1 * NSEC_PER_MSEC;
>  /* minimum remaining period time to redistribute slack quota */
>  static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
> @@ -4743,16 +4745,27 @@ static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
>  static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>  {
>  	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
> -	s64 slack_runtime = cfs_rq->runtime_remaining - min_cfs_rq_runtime;
> +	s64 slack_runtime = cfs_rq->runtime_remaining;
>  
> +	/* There is no runtime to return. */
>  	if (slack_runtime <= 0)
>  		return;
>  
>  	raw_spin_lock(&cfs_b->lock);
>  	if (cfs_b->quota != RUNTIME_INF &&
>  	    cfs_rq->runtime_expires == cfs_b->runtime_expires) {
> -		cfs_b->runtime += slack_runtime;
> +		/* As we near 0 quota remaining on cfs_b start returning all
> +		 * remaining runtime. This avoids stranding and then expiring
> +		 * runtime on per-cpu cfs_rq.
> +		 *
> +		 * cfs->b has plenty of runtime leave min_cfs_rq_runtime of
> +		 * runtime on this cfs_rq.
> +		 */
> +		if (cfs_b->runtime >= sched_cfs_bandwidth_slice() * 3 &&
> +		    slack_runtime > min_cfs_rq_runtime)
> +			slack_runtime -= min_cfs_rq_runtime;
>  
> +		cfs_b->runtime += slack_runtime;
>  		/* we are under rq->lock, defer unthrottling using a timer */
>  		if (cfs_b->runtime > sched_cfs_bandwidth_slice() &&
>  		    !list_empty(&cfs_b->throttled_cfs_rq))


This still has a similar cost as reducing min_cfs_rq_runtime to 0 - we
now take a tg-global lock on every group se dequeue. Setting min=0 means
that we have to take it on both enqueue and dequeue, while baseline
means we take it once per min_cfs_rq_runtime in the worst case.

In addition how much this helps is very dependent on the exact pattern
of sleep/wake - you can still strand all but 15ms of runtime with a
pretty reasonable pattern.

If the cost of taking this global lock across all cpus without a
ratelimit was somehow not a problem, I'd much prefer to just set
min_cfs_rq_runtime = 0. (Assuming it is, I definitely prefer the "lie
and sorta have 2x period 2x runtime" solution of removing expiration)
