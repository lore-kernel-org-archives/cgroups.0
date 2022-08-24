From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 05/10] sched/psi: optimize task switch inside shared
 cgroups again
Date: Wed, 24 Aug 2022 10:06:08 -0400
Message-ID: <YwYwUIjAGHLtRGue@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-6-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=WISgtRtj7XAbDMj5crexRB3gKRdBJedqKO8qGlTO7ac=;
        b=T3LH1lzO4KaEX4zn8CgVYuDuv1KauxJR+HLCXKEs3xkm360Emw4hVW/MuvafYZ6sl/
         3JPoNCsUwsH6+piwal7pIV4xPcGk8/LhMhEmlDsIW5wXG1GsuodbK5PAQMitAaN3SklC
         UDZ4VPj9lBpiLtgWK1EICxF2A+N21C/ZEJZAlVolTuMYN7KyxVC3LlArNy48s6WdarRN
         QM7u7L8czZFsRahByWnn++hZx6eXqbmVB8j1Vab8qkWaBUCGWKA7wqQqGZS8B2rDK/6s
         I50j59hZkbewhI7anqmsnrTDwIZg46TVpjej35gDcENEkxdo/tXAd8zJRfrcLqyBaNeq
         DT8A==
Content-Disposition: inline
In-Reply-To: <20220824081829.33748-6-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 24, 2022 at 04:18:24PM +0800, Chengming Zhou wrote:
> commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
> defer prev task sleep handling to psi_task_switch(), so we don't need
> to clear and set TSK_ONCPU state for common cgroups.
> 
>     A
>     |
>     B
>    / \
>   C   D
>  /     \
> prev   next
> 
> After that commit psi_task_switch() do:
> 1. psi_group_change(next, .set=TSK_ONCPU) for D
> 2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C
> 3. psi_group_change(prev, .clear=TSK_RUNNING) for B, A
> 
> But there is a limitation "prev->psi_flags == next->psi_flags" that
> if not satisfied, will make this cgroups optimization unusable for both
> sleep switch or running switch cases. For example:
> 
> prev->in_memstall != next->in_memstall when sleep switch:
> 1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
> 2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C, B, A
> 
> prev->in_memstall != next->in_memstall when running switch:
> 1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
> 2. psi_group_change(prev, .clear=TSK_ONCPU) for C, B, A
> 
> The reason why this limitation exist is that we consider a group is
> PSI_MEM_FULL if the CPU is actively reclaiming and nothing productive
> could run even if it were runnable. So when CPU curr changed from prev
> to next and their in_memstall status is different, we have to change
> PSI_MEM_FULL status for their common cgroups.
> 
> This patch remove this limitation by making psi_group_change() change
> PSI_MEM_FULL status depend on CPU curr->in_memstall status.
> 
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hoo boy, that took me a second.


Way back when PSI_MEM_FULL was accounted from the timer tick, task
switching could simply iterate next and prev to the common ancestor to
update TSK_ONCPU and be done.

Then memstall ticks were replaced with checking curr->in_memstall
directly in psi_group_change(). That meant that now if the task switch
was between a memstall and a !memstall task, we had to iterate through
the common ancestors at least ONCE to fix up their state_masks.

We added the identical_state filter to make sure the common ancestor
elimination was skipped in that case. It seems that was always a
little too eager, because it caused us to walk the common ancestors
*twice* instead of the required once: the iteration for next could
have stopped at the common ancestor; prev could have updated TSK_ONCPU
up to the common ancestor, then finish to the root without changing
any flags, just to get the new curr->in_memstall into the state_masks.

This patch recognizes this and makes it so that we walk to the root
exactly once if state_mask needs updating.


Unless I missed anything, would you mind adding this to the changelog?

I'm not quite sure how 4117cebf1a9f ("psi: Optimize task switch inside
shared cgroups") fits into the picture. That optimized the sleep case,
but the sleep case never had the common ancestor optimization (the dq
would have already cleared TSK_ONCPU up to the root). Let me know if I
am mistaken.

AFAICS I can see, this patch here is simply catching up on a missed
optimization that could have been done in 7fae6c8171d2 ("psi: Use
ONCPU state tracking machinery to detect reclaim") directly already.

So I think it all makes sense. I have just two notes on the diff:

> @@ -820,8 +820,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  	u64 now = cpu_clock(cpu);
>  
>  	if (next->pid) {
> -		bool identical_state;
> -
>  		psi_flags_change(next, 0, TSK_ONCPU);
>  		/*
>  		 * When switching between tasks that have an identical
> @@ -829,11 +827,9 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 * we reach the first common ancestor. Iterate @next's
>  		 * ancestors only until we encounter @prev's ONCPU.
>  		 */

The comment is rather stale now. Could you change it to this?

		/*
		 * Set TSK_ONCPU on @next's cgroups. If @next shares any
		 * ancestors with @prev, those will already have @prev's
		 * TSK_ONCPU bit set, and we can stop the iteration there.
		 */

> -		identical_state = prev->psi_flags == next->psi_flags;
>  		iter = NULL;
>  		while ((group = iterate_groups(next, &iter))) {
> -			if (identical_state &&
> -			    per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
> +			if (per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
>  				common = group;
>  				break;
>  			}
> @@ -880,7 +876,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
>  		 * with dequeuing too, finish that for the rest of the hierarchy.
>  		 */
> -		if (sleep) {
> +		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
>  			clear &= ~TSK_ONCPU;
>  			for (; group; group = iterate_groups(prev, &iter))
>  				psi_group_change(group, cpu, clear, set, now, wake_clock);

Okay, this computes too. But it is somewhat special-cased, without
explaining why the memstall state in particular matters. Instead of
focusing on the exceptions though, can we just generalize this a bit?

		/*
		 * TSK_ONCPU is handled up to the common ancestor. If there are
		 * any other differences between the two tasks (e.g. prev goes
		 * to sleep, or only one task is memstall), finish propagating
		 * those differences all the way up to the root.
		 */
		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
			clear &= ~TSK_ONCPU;
			for (; group; group = iterate_groups(prev, &iter))
				psi_group_change(group, cpu, clear, set, now, wake_clock);
		}

Thanks
Johannes
