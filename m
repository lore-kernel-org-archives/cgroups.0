From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v3 05/10] sched/psi: optimize task switch inside shared
 cgroups again
Date: Wed, 24 Aug 2022 23:30:44 +0800
Message-ID: <7faa16c2-0488-e9df-da65-94265444b28d@bytedance.com>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-6-zhouchengming@bytedance.com>
 <YwYwUIjAGHLtRGue@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Nr6VDxQ+9Z3MRjk/tSo9PTiJ5/YnHSGlAbzSQvtKymc=;
        b=qmjOD5wPUNDa8iTubLMf8v2s9M6JFSV1346e97d8+/FNWBwZ2rxbX0DX6lGi4Rhsim
         9Jju7OGBeF35kUbBqdgzumB8y0J0rYYdHqGts5j2+GE56XmLVT+6nI7SY9al0GMs0x62
         OTM6yf8WgWUY7pPvvb9P+GRM3OXq1+JGe3wJDAvEjFWB2YuetvY8J7IFCxhQckNs0rk9
         tGYYH2zB6V0VEe528zfagh6OLsIomAMjIY63L/i+/4dhst6HTC5iuV1mGz2MRe966WtE
         8r0Qx8bJLjfLSbtP88LDHqKAFr0whNygXd7u67EK7O8Hc/4BvDsDfila4lT8Yuf3g8K2
         OUVw==
Content-Language: en-US
In-Reply-To: <YwYwUIjAGHLtRGue@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: tj@kernel.org, mkoutny@suse.com, surenb@google.com, gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 2022/8/24 22:06, Johannes Weiner wrote:
> On Wed, Aug 24, 2022 at 04:18:24PM +0800, Chengming Zhou wrote:
>> commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
>> defer prev task sleep handling to psi_task_switch(), so we don't need
>> to clear and set TSK_ONCPU state for common cgroups.
>>
>>     A
>>     |
>>     B
>>    / \
>>   C   D
>>  /     \
>> prev   next
>>
>> After that commit psi_task_switch() do:
>> 1. psi_group_change(next, .set=TSK_ONCPU) for D
>> 2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C
>> 3. psi_group_change(prev, .clear=TSK_RUNNING) for B, A
>>
>> But there is a limitation "prev->psi_flags == next->psi_flags" that
>> if not satisfied, will make this cgroups optimization unusable for both
>> sleep switch or running switch cases. For example:
>>
>> prev->in_memstall != next->in_memstall when sleep switch:
>> 1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
>> 2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C, B, A
>>
>> prev->in_memstall != next->in_memstall when running switch:
>> 1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
>> 2. psi_group_change(prev, .clear=TSK_ONCPU) for C, B, A
>>
>> The reason why this limitation exist is that we consider a group is
>> PSI_MEM_FULL if the CPU is actively reclaiming and nothing productive
>> could run even if it were runnable. So when CPU curr changed from prev
>> to next and their in_memstall status is different, we have to change
>> PSI_MEM_FULL status for their common cgroups.
>>
>> This patch remove this limitation by making psi_group_change() change
>> PSI_MEM_FULL status depend on CPU curr->in_memstall status.
>>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> Hoo boy, that took me a second.
> 

Thanks for your time. :-)

> 
> Way back when PSI_MEM_FULL was accounted from the timer tick, task
> switching could simply iterate next and prev to the common ancestor to
> update TSK_ONCPU and be done.
> 
> Then memstall ticks were replaced with checking curr->in_memstall
> directly in psi_group_change(). That meant that now if the task switch
> was between a memstall and a !memstall task, we had to iterate through
> the common ancestors at least ONCE to fix up their state_masks.
> 
> We added the identical_state filter to make sure the common ancestor
> elimination was skipped in that case. It seems that was always a
> little too eager, because it caused us to walk the common ancestors
> *twice* instead of the required once: the iteration for next could
> have stopped at the common ancestor; prev could have updated TSK_ONCPU
> up to the common ancestor, then finish to the root without changing
> any flags, just to get the new curr->in_memstall into the state_masks.
> 
> This patch recognizes this and makes it so that we walk to the root
> exactly once if state_mask needs updating.
> 
> 
> Unless I missed anything, would you mind adding this to the changelog?

Your explanation is very clear and accurate, will add it.

> 
> I'm not quite sure how 4117cebf1a9f ("psi: Optimize task switch inside
> shared cgroups") fits into the picture. That optimized the sleep case,
> but the sleep case never had the common ancestor optimization (the dq
> would have already cleared TSK_ONCPU up to the root). Let me know if I
> am mistaken.

That commit skiped clearing TSK_ONCPU in dequeue when sleep, so also have
the common ancestor optimization.

> 
> AFAICS I can see, this patch here is simply catching up on a missed
> optimization that could have been done in 7fae6c8171d2 ("psi: Use
> ONCPU state tracking machinery to detect reclaim") directly already.

Yes, apart from catching on a missed optimization, I later found in testing
this patch is necessary for the next patch 06/10.

Imaging we walk the common ancestors twice:
(1) psi_group_change(.clear = 0, .set = TSK_ONCPU)
(2) psi_group_change(.clear = TSK_ONCPU, .set = 0)

We previously used tasks[NR_ONCPU] to record TSK_ONCPU, so tasks[NR_ONCPU]++
in (1) then tasks[NR_ONCPU]-- in (2), tasks[NR_ONCPU] still be correct.

The patch 06/10 change to use one bit in state mask to record TSK_ONCPU,
so PSI_ONCPU bit will be set in (1), but then be cleared in (2), which
cause the psi_group_cpu has task running but without PSI_ONCPU bit set!

With this patch, we will never walk the common ancestors twice, so don't
have above problem anymore.

> 
> So I think it all makes sense. I have just two notes on the diff:
> 
>> @@ -820,8 +820,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>>  	u64 now = cpu_clock(cpu);
>>  
>>  	if (next->pid) {
>> -		bool identical_state;
>> -
>>  		psi_flags_change(next, 0, TSK_ONCPU);
>>  		/*
>>  		 * When switching between tasks that have an identical
>> @@ -829,11 +827,9 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>>  		 * we reach the first common ancestor. Iterate @next's
>>  		 * ancestors only until we encounter @prev's ONCPU.
>>  		 */
> 
> The comment is rather stale now. Could you change it to this?

Good, will update the comment.

> 
> 		/*
> 		 * Set TSK_ONCPU on @next's cgroups. If @next shares any
> 		 * ancestors with @prev, those will already have @prev's
> 		 * TSK_ONCPU bit set, and we can stop the iteration there.
> 		 */
> 
>> -		identical_state = prev->psi_flags == next->psi_flags;
>>  		iter = NULL;
>>  		while ((group = iterate_groups(next, &iter))) {
>> -			if (identical_state &&
>> -			    per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
>> +			if (per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
>>  				common = group;
>>  				break;
>>  			}
>> @@ -880,7 +876,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>>  		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
>>  		 * with dequeuing too, finish that for the rest of the hierarchy.
>>  		 */
>> -		if (sleep) {
>> +		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
>>  			clear &= ~TSK_ONCPU;
>>  			for (; group; group = iterate_groups(prev, &iter))
>>  				psi_group_change(group, cpu, clear, set, now, wake_clock);
> 
> Okay, this computes too. But it is somewhat special-cased, without
> explaining why the memstall state in particular matters. Instead of
> focusing on the exceptions though, can we just generalize this a bit?
> 
> 		/*
> 		 * TSK_ONCPU is handled up to the common ancestor. If there are
> 		 * any other differences between the two tasks (e.g. prev goes
> 		 * to sleep, or only one task is memstall), finish propagating
> 		 * those differences all the way up to the root.
> 		 */
> 		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
> 			clear &= ~TSK_ONCPU;
> 			for (; group; group = iterate_groups(prev, &iter))
> 				psi_group_change(group, cpu, clear, set, now, wake_clock);
> 		}

I think this is much better and the comment is very clear!

Thanks.

