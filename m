From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC 1/5] ns: Introduce CPU Namespace
Date: Sun, 10 Oct 2021 00:37:39 +0200
Message-ID: <20211009223739.GY174703@worktop.programming.kicks-ass.net>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211009151243.8825-2-psampat@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hPKAcZK5izPuDfWh8AAW5OoknbBIjrsDsl4cSr/xTWk=; b=qmgd5RoIVCBNZUjd7+fltt0qg3
        vAD6cLLr91kNcKSvgMFgaGmncnqOXqJWzSthinZwzI6PVrGfBvHMCYaf6mq2RBJ9rRqyJQq1ZU3+p
        tkn9+Vk7uw8s+hneNDkMNqSgnJPfsz19O2ad46wSeRuzqF1dsnCB26873MpSrLz9UENnyWMeremWS
        FC52qqbE2BgTUia5i1q1XmLKAKRzbt9VpbLmVw2lXvqNLK7iQ+PwnG0Z05UUlb6jKJUolPj4KdEZW
        7nnRANZxbiJykY2+Lj46fB1yEZmpH4siJpkmtJESYo+JO3Ux0r0StFPhTIc93Ob56diWrKRjc/7RE
        3hEDqCzg==;
Content-Disposition: inline
In-Reply-To: <20211009151243.8825-2-psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Pratik R. Sampat" <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, Oct 09, 2021 at 08:42:39PM +0530, Pratik R. Sampat wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d9ff40f4661..0413175e6d73 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -27,6 +27,8 @@
>  #include "pelt.h"
>  #include "smp.h"
>  
> +#include <linux/cpu_namespace.h>
> +
>  /*
>   * Export tracepoints that act as a bare tracehook (ie: have no trace event
>   * associated with them) to allow external modules to probe them.
> @@ -7559,6 +7561,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  {
>  	cpumask_var_t cpus_allowed, new_mask;
>  	struct task_struct *p;
> +	cpumask_t temp;
>  	int retval;
>  
>  	rcu_read_lock();

You're not supposed to put a cpumask_t on stack. Those things can be
huge.

> @@ -7682,8 +7686,9 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
>  long sched_getaffinity(pid_t pid, struct cpumask *mask)
>  {
>  	struct task_struct *p;
> +	cpumask_var_t temp;
>  	unsigned long flags;
> -	int retval;
> +	int retval, cpu;
>  
>  	rcu_read_lock();
>  
> @@ -7698,6 +7703,13 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
>  
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
>  	cpumask_and(mask, &p->cpus_mask, cpu_active_mask);
> +	cpumask_clear(temp);

There's a distinct lack of allocating temp before use. Are you sure you
actually tested this?

