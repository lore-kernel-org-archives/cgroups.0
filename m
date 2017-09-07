From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 19:51:07 +0200
Message-ID: <20170907175107.GG17526@worktop.programming.kicks-ass.net>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zPa8HsBFJFZiflXSsVYXbJV9mUiKDEqy0sNq9tS2kLc=; b=ZT+2YDFGUG7QS6Fs2qk0uRO+/
        C831pQ4r2DvdxrNZfpClHdDYn/93OqMnaKBtkWUbT2N9bUASfP1SE9k2MumZqaekW3j0HpHaIdvSt
        oI+YifgtpX8Hd13PmR9NbRRCmqnjxKtSbsGXEOetK0kLMp5CSnDEdseeMseDexBQDCAOfpjWaYmBB
        aGQPoKnCW+qgg9LK0iO4X6SKCHUk5ZI79Y2aoxI0SSGTQNjp/71TbZrE4vwyg7NEIis6MShVnbCwH
        rnnh6KbCvXzG3i2N0lGipwHP3Ev5NZaarkNqZhMADkjG6k4ImhDZqAeQqZ0EPTc6nzDel8wH2mGEu
    
Content-Disposition: inline
In-Reply-To: <1504792583-10424-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Thu, Sep 07, 2017 at 07:26:23PM +0530, Prateek Sood wrote:
> Remove circular dependency deadlock in a scenario where hotplug of CPU is
> being done while there is updation in cgroup and cpuset triggered from
> userspace.

You've forgotten to mention your solution to the deadlock, namely
inverting cpuset_mutex and cpu_hotplug_lock.

> Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2f4039b..60dc0ac 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -816,16 +816,15 @@ static int generate_sched_domains(cpumask_var_t **domains,
>   * 'cpus' is removed, then call this routine to rebuild the
>   * scheduler's dynamic sched domains.
>   *
> - * Call with cpuset_mutex held.  Takes get_online_cpus().
>   */
> -static void rebuild_sched_domains_locked(void)
> +static void rebuild_sched_domains_cpuslocked(void)
>  {
>  	struct sched_domain_attr *attr;
>  	cpumask_var_t *doms;
>  	int ndoms;
>  
> +	lockdep_assert_cpus_held();
>  	lockdep_assert_held(&cpuset_mutex);
> -	get_online_cpus();
>  
>  	/*
>  	 * We have raced with CPU hotplug. Don't do anything to avoid
> @@ -833,27 +832,27 @@ static void rebuild_sched_domains_locked(void)
>  	 * Anyways, hotplug work item will rebuild sched domains.
>  	 */
>  	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> -		goto out;
> +		return;
>  
>  	/* Generate domain masks and attrs */
>  	ndoms = generate_sched_domains(&doms, &attr);
>  
>  	/* Have scheduler rebuild the domains */
>  	partition_sched_domains(ndoms, doms, attr);
> -out:
> -	put_online_cpus();
>  }
>  #else /* !CONFIG_SMP */
> -static void rebuild_sched_domains_locked(void)
> +static void rebuild_sched_domains_cpuslocked(void)
>  {
>  }
>  #endif /* CONFIG_SMP */
>  
>  void rebuild_sched_domains(void)
>  {
> +	get_online_cpus();
>  	mutex_lock(&cpuset_mutex);
> -	rebuild_sched_domains_locked();
> +	rebuild_sched_domains_cpuslocked();
>  	mutex_unlock(&cpuset_mutex);
> +	put_online_cpus();
>  }

But if you invert these locks, the need for cpuset_hotplug_workfn() goes
away, at least for the CPU part, and we can make in synchronous again.
Yay!!

Also, I think new code should use cpus_read_lock() instead of
get_online_cpus().
