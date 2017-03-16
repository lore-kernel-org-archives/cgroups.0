From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
 kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 12:07:34 -0400
Message-ID: <20170316160734.GD15810@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
 <20170316150233.GB24478@redhat.com>
 <20170316153925.GA26391@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eqmQ2g7T/FXoSx8sPGGLi3nDxFUQ88w0iJRwBPv4fo4=;
        b=ZDk8Yc80PgM5d9HvYnRRsA/jJi65+gskwEvont+gPc5vrI2VofgRZzBakwDuYeLqFU
         XtI0mN1nBmnxAEwcmky5aAPKoUCHmya+koMJdgGVfDX05LdulI4sAf8hkW/+/52UddQG
         mhprm/0xsmGpANEA3h6MYTusotbsYUXCiqRdSW74hhcE9Wjjixns6PUE0dlyfILPg3QJ
         /SXxR+mHsCIjCo5UdCuleqkF/cUoZUGlhLtjJYBMQBH16KdoSyfc+ysEsdPy/Mwe0KFo
         rGmz7LSfAr8f83t2p09XkCm1d5WFQnaI9/7GPsZrktC9i4m96MNYSdec4hNQIgMGNtgS
         mVOQ==
Content-Disposition: inline
In-Reply-To: <20170316153925.GA26391-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 16, 2017 at 04:39:26PM +0100, Oleg Nesterov wrote:
> Either way, I am wondering if we can do something really trivial like
> the patch below. This way we can also remove the "tsk == kthreadd_task"
> check, and we do not need the barriers.
> 
> Oleg.
> 
> --- x/kernel/kthread.c
> +++ x/kernel/kthread.c
> @@ -226,6 +226,7 @@
>  	ret = -EINTR;
>  	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
>  		__kthread_parkme(self);
> +		current->flags &= ~PF_IDONTLIKECGROUPS;
>  		ret = threadfn(data);
>  	}
>  	do_exit(ret);
> @@ -537,7 +538,7 @@
>  	set_cpus_allowed_ptr(tsk, cpu_all_mask);
>  	set_mems_allowed(node_states[N_MEMORY]);
>  
> -	current->flags |= PF_NOFREEZE;
> +	current->flags |= (PF_NOFREEZE | PF_IDONTLIKECGROUPS);
>  
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> --- x/kernel/cgroup/cgroup.c
> +++ x/kernel/cgroup/cgroup.c
> @@ -2429,7 +2429,7 @@
>  	 * trapped in a cpuset, or RT worker may be born in a cgroup
>  	 * with no rt_runtime allocated.  Just say no.
>  	 */
> -	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
> +	if (tsk->flags & (PF_NO_SETAFFINITY | PF_IDONTLIKECGROUPS)) {
>  		ret = -EINVAL;
>  		goto out_unlock_rcu;
>  	}

Absolutely.  If we're willing to spend a PF flag on it, we can
properly wait for it too instead of failing it.

Thanks.

-- 
tejun
