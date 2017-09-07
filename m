From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 09:28:48 +0200
Message-ID: <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
References: <1504764252-29091-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hVnUiBvDQRcGY4Duc0oHqG6yLwPeFTudTzcF2v1s6ek=; b=sC6v1i5Wsv8XOHQvkvHXPg9UR
        byoaS8Jl1pIqQvNGB0DSpGpB6Cpmey/Om6wc39us7/F6L0a0Y+E3I2OqWTmT5cv+SfNW5ty57rvYR
        Wh+KVLZBI46eQWWcOQ+KU76HYwYXvlXRqBUPaI1THCbIAEPfjO6cp6SdnoxKmwGHNDr9GefFp2b63
        l5/qBzCzG7dUY6m9A+uMFw/7jIxo3DJ/VFJdoBTmpi4oCUldRdksYaWZYZR7q2oMJdSbMj3U7R5tV
        tLLcMmbqr0zcu4OvRt6SIePzQoHBOdluSaFlzF4LvSoA65qdKoyyqDcfGdYr7yogfl2I842VitsbR
    
Content-Disposition: inline
In-Reply-To: <1504764252-29091-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Thu, Sep 07, 2017 at 11:34:12AM +0530, Prateek Sood wrote:
> Remove circular dependency deadlock in a scenario where hotplug of CPU is
> being done while there is updation in cgroup and cpuset triggered from
> userspace.
> 
> Example scenario:
> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
> 
> kworker/0:0 - percpu_down_write(&cpu_hotplug_lock)  [held]
>               flush(work)   [no high prio workqueue available on CPU]
>               wait_for_completion()
> 
> kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
> 
> init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
>               lock(cpuset_mutex)   [waiting]
> 
> init:1      - lock(cpuset_mutex)   [held]
>               percpu_down_read(&cpu_hotplug_lock)   [waiting]

That's both unreadable and useless :/ You want to tell what code paths
that were, not which random tasks happened to run them.



> Eliminate this dependecy by reordering locking of cpuset_mutex
> and cpu_hotplug_lock in following order
> 1. Acquire cpu_hotplug_lock (read)
> 2. Acquire cpuset_mutex
> 
> Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 70 +++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 61 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2f4039b..687be57 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -843,10 +843,41 @@ static void rebuild_sched_domains_locked(void)
>  out:
>  	put_online_cpus();
>  }
> +
> +/*
> + * Rebuild scheduler domains.
> + * Call with following lock held in the order
> + * 1. cpu_hotplug_lock (read)
> + * 2. cpuset_mutex

Do not put that in comments, nobody ever reads comments.

> + */
> +static void rebuild_sched_domains_unlocked(void)

The common postfix for a function called with the cpuhotplug lock held
is: _cpuslocked()

> +{
> +        struct sched_domain_attr *attr;
> +        cpumask_var_t *doms;
> +        int ndoms;

	lockdep_assert_cpus_held();
	lockdep_assert_held(&cpuset_mutex);

> +
> +        /*
> +         * We have raced with CPU hotplug. Don't do anything to avoid
> +         * passing doms with offlined cpu to partition_sched_domains().
> +         * Anyways, hotplug work item will rebuild sched domains.
> +         */
> +        if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> +                return;
> +
> +        /* Generate domain masks and attrs */
> +        ndoms = generate_sched_domains(&doms, &attr);
> +
> +        /* Have scheduler rebuild the domains */
> +        partition_sched_domains(ndoms, doms, attr);
> +}

And you couldn't come up with a way to share _anything_ with the
existing rebuild_sched_domains_locked() function?

*sigh*.. please try again.
