From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
        kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 16:02:34 +0100
Message-ID: <20170316150233.GB24478@redhat.com>
References: <20170315231827.GA13656@htj.duckdns.org> <20170315231920.GB13656@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B609E6445B
Content-Disposition: inline
In-Reply-To: <20170315231920.GB13656@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 03/15, Tejun Heo wrote:
>
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2425,11 +2425,13 @@ ssize_t __cgroup_procs_write(struct kern
>  		tsk = tsk->group_leader;
>  
>  	/*
> -	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
> -	 * trapped in a cpuset, or RT worker may be born in a cgroup
> -	 * with no rt_runtime allocated.  Just say no.
> +	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
> +	 * If userland migrates such kthread to a non-root cgroup, it can
> +	 * become trapped in a cpuset, or RT kthread may be born in a
> +	 * cgroup with no rt_runtime allocated.  Just say no.
>  	 */
> -	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
> +	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY) ||
> +	    ((tsk->flags & PF_KTHREAD) && !kthread_initialized(tsk))) {
>  		ret = -EINVAL;

...

> +bool kthread_initialized(struct task_struct *k)
> +{
> +	struct kthread *kthread = to_kthread(k);
> +
> +	return kthread && test_bit(KTHREAD_INITIALIZED, &kthread->flags);
> +}

Not sure I understand...

With this patch you can no longer migrate a kernel thread created by
kernel_thread() ? Note that to_kthread() is NULL unless it was created
by kthread_create().

Oleg.

