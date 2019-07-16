From: bsegall@google.com
Subject: Re: [PATCH v5 1/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Tue, 16 Jul 2019 12:58:06 -0700
Message-ID: <xm26ef2pkb01.fsf@bsegall-linux.svl.corp.google.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
        <1561664970-1555-1-git-send-email-chiluk+linux@indeed.com>
        <1561664970-1555-2-git-send-email-chiluk+linux@indeed.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=BvRVByTKtdPiNxfsCeySgYk32g6DkoU4cKl3qk6qMVk=;
        b=qBKuzkwYCRwHvwJn5liGlcD2L84sglQVE5FXCvo+IQv70Uq/MEojS7Kg5S/EDHID12
         pJ7AZbdF/xARsL3yN93QFo5UjfnJsh3V8hCv4XIGmJLF9mpMJnrN34EauKn5kvkob1P4
         OXPW2D85z9yIFaBoe6IOKq6xqwgatDCw0gCTrAsm4MSqzeJdG1nIV2sRkUaoN3satqdy
         3r7ddOP9ZAN5dBl9ASJh37bJiVKi0bznMDEWnqd1hXIgTImiRkLhpgit9myZg8/ywi43
         KS1jpEZHC5yg7C07gRiNUoidsY7Vqi29u3K0EWMm4F2bOKlF0JdTlr9j0yaRWchOoPlB
         c+JA==
In-Reply-To: <1561664970-1555-2-git-send-email-chiluk+linux@indeed.com> (Dave
        Chiluk's message of "Thu, 27 Jun 2019 14:49:30 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Pqhil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

Dave Chiluk <chiluk+linux@indeed.com> writes:

> It has been observed, that highly-threaded, non-cpu-bound applications
> running under cpu.cfs_quota_us constraints can hit a high percentage of
> periods throttled while simultaneously not consuming the allocated
> amount of quota. This use case is typical of user-interactive non-cpu
> bound applications, such as those running in kubernetes or mesos when
> run on multiple cpu cores.
>
> This has been root caused to threads being allocated per cpu bandwidth
> slices, and then not fully using that slice within the period. At which
> point the slice and quota expires. This expiration of unused slice
> results in applications not being able to utilize the quota for which
> they are allocated.
>
> The expiration of per-cpu slices was recently fixed by
> 'commit 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift
> condition")'. Prior to that it appears that this has been broken since
> at least 'commit 51f2176d74ac ("sched/fair: Fix unlocked reads of some
> cfs_b->quota/period")' which was introduced in v3.16-rc1 in 2014. That
> added the following conditional which resulted in slices never being
> expired.
>
> if (cfs_rq->runtime_expires != cfs_b->runtime_expires) {
> 	/* extend local deadline, drift is bounded above by 2 ticks */
> 	cfs_rq->runtime_expires += TICK_NSEC;
>
> Because this was broken for nearly 5 years, and has recently been fixed
> and is now being noticed by many users running kubernetes
> (https://github.com/kubernetes/kubernetes/issues/67577) it is my opinion
> that the mechanisms around expiring runtime should be removed
> altogether.
>
> This allows quota already allocated to per-cpu run-queues to live longer
> than the period boundary. This allows threads on runqueues that do not
> use much CPU to continue to use their remaining slice over a longer
> period of time than cpu.cfs_period_us. However, this helps prevents the
> above condition of hitting throttling while also not fully utilizing
> your cpu quota.
>
> This theoretically allows a machine to use slightly more than its
> allotted quota in some periods. This overflow would be bounded by the
> remaining quota left on each per-cpu runqueueu. This is typically no
> more than min_cfs_rq_runtime=1ms per cpu. For CPU bound tasks this will
> change nothing, as they should theoretically fully utilize all of their
> quota in each period. For user-interactive tasks as described above this
> provides a much better user/application experience as their cpu
> utilization will more closely match the amount they requested when they
> hit throttling. This means that cpu limits no longer strictly apply per
> period for non-cpu bound applications, but that they are still accurate
> over longer timeframes.
>
> This greatly improves performance of high-thread-count, non-cpu bound
> applications with low cfs_quota_us allocation on high-core-count
> machines. In the case of an artificial testcase (10ms/100ms of quota on
> 80 CPU machine), this commit resulted in almost 30x performance
> improvement, while still maintaining correct cpu quota restrictions.
> That testcase is available at https://github.com/indeedeng/fibtest.
>
> Fixes: 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift condition")
> Signed-off-by: Dave Chiluk <chiluk+linux@indeed.com>
> ---
>  Documentation/scheduler/sched-bwc.txt | 73 ++++++++++++++++++++++++++++-------
>  kernel/sched/fair.c                   | 71 +++-------------------------------
>  kernel/sched/sched.h                  |  4 --
>  3 files changed, 65 insertions(+), 83 deletions(-)
>
> [...]
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f35930f..a675c69 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4809,11 +4754,9 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
>  	if (!runtime)
>  		return;
>  
> -	runtime = distribute_cfs_runtime(cfs_b, runtime, expires);
> +	runtime = distribute_cfs_runtime(cfs_b, runtime);
>  
>  	raw_spin_lock_irqsave(&cfs_b->lock, flags);
> -	if (expires == cfs_b->runtime_expires)
> -		lsub_positive(&cfs_b->runtime, runtime);

The lsub_positive is still needed, just get rid of the if.


Other than that,
Reviewed-by: Ben Segall <bsegall@google.com>
