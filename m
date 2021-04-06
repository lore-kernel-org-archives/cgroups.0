From: Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Tue, 6 Apr 2021 12:10:41 +0000
Message-ID: <YGxPwTVvpqYkkIMI@google.com>
References: <1617706753-25349-1-git-send-email-pkondeti@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3UA2QLgE5D0ijsyIx8P+uuJ+qKQ15FjapR/N/wkS3FM=;
        b=HF72u0MOJvcyb2iO031+3c68hjNTeovFQNLtmtnt5xqUF1rnl9HuJPHYt5suzoXNS0
         XGZaD4/jxQsphiOqCQ7iwY+xVYPkdS/lkbMeDHiHVVsO2ZhBbaxKz/R9tJcLJVw5qyKg
         wH8RjFs6SbFvit+GIlaly8tMXLlJxWDnkFGCOo1q9cvbp0r9VqQzi3KqtUC3Bzf4Hp+9
         7rCvU/b58AauosJJ+qvqsWEZBDrc1Rk7er7tyPgLkisjbxAqgRi6V4Xn54K4K5lpuQtr
         dkJWd0eWbKIhUf7hs+Ch4z2XyTMWUK86+nbI/TqALTF24exGJ9lnQmaju2WAqmH0rAof
         qZ8g==
Content-Disposition: inline
In-Reply-To: <1617706753-25349-1-git-send-email-pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavankumar Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Pavan,

On Tuesday 06 Apr 2021 at 16:29:13 (+0530), Pavankumar Kondeti wrote:
> In Android GKI, CONFIG_FAIR_GROUP_SCHED is enabled [1] to help prioritize
> important work. Given that CPU shares of root cgroup can't be changed,
> leaving the tasks inside root cgroup will give them higher share
> compared to the other tasks inside important cgroups. This is mitigated
> by moving all tasks inside root cgroup to a different cgroup after
> Android is booted. However, there are many kernel tasks stuck in the
> root cgroup after the boot.
> 
> We see all kworker threads are in the root cpu cgroup. This is because,
> tasks with PF_NO_SETAFFINITY flag set are forbidden from cgroup migration.
> This restriction is in place to avoid kworkers getting moved to a cpuset
> which conflicts with kworker affinity. Relax this restriction by explicitly
> checking if the task is moving out of a cpuset cgroup. This allows kworkers
> to be moved out root cpu cgroup.
> 
> We also see kthreadd_task and any kernel thread created after the Android boot
> also stuck in the root cgroup. The current code prevents kthreadd_task moving
> out root cgroup to avoid the possibility of creating new RT kernel threads
> inside a cgroup with no RT runtime allocated. Apply this restriction when tasks
> are moving out of cpu cgroup under CONFIG_RT_GROUP_SCHED. This allows all
> kernel threads to be moved out of root cpu cgroup if the kernel does not
> enable RT group scheduling.

OK, so IIUC this only works with cgroup v1 -- the unified hierarchy in
v2 forces you to keep cpu and cpuset in 'sync'. But that should be fine,
so this looks like a nice improvement to me.

> [1] https://android.googlesource.com/kernel/common/+/f08f049de11c15a4251cb1db08cf0bee20bd9b59
> 
> Signed-off-by: Pavankumar Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  kernel/cgroup/cgroup-internal.h |  3 ++-
>  kernel/cgroup/cgroup-v1.c       |  2 +-
>  kernel/cgroup/cgroup.c          | 24 +++++++++++++++++++-----
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index bfbeabc..a96ed9a 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -232,7 +232,8 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
>  int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
>  		       bool threadgroup);
>  struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
> -					     bool *locked)
> +					     bool *locked,
> +					     struct cgroup *dst_cgrp)
>  	__acquires(&cgroup_threadgroup_rwsem);
>  void cgroup_procs_write_finish(struct task_struct *task, bool locked)
>  	__releases(&cgroup_threadgroup_rwsem);
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index a575178..d674a6c 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -497,7 +497,7 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
>  	if (!cgrp)
>  		return -ENODEV;
>  
> -	task = cgroup_procs_write_start(buf, threadgroup, &locked);
> +	task = cgroup_procs_write_start(buf, threadgroup, &locked, cgrp);
>  	ret = PTR_ERR_OR_ZERO(task);
>  	if (ret)
>  		goto out_unlock;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 9153b20..41864a8 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2744,7 +2744,8 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
>  }
>  
>  struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
> -					     bool *locked)
> +					     bool *locked,
> +					     struct cgroup *dst_cgrp)
>  	__acquires(&cgroup_threadgroup_rwsem)
>  {
>  	struct task_struct *tsk;
> @@ -2784,15 +2785,28 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
>  		tsk = tsk->group_leader;
>  
>  	/*
> +	 * RT kthreads may be born in a cgroup with no rt_runtime allocated.
> +	 * Just say no.
> +	 */
> +#ifdef CONFIG_RT_GROUP_SCHED
> +	if (tsk->no_cgroup_migration && (dst_cgrp->root->subsys_mask & (1U << cpu_cgrp_id))) {
> +		tsk = ERR_PTR(-EINVAL);
> +		goto out_unlock_threadgroup;
> +	}
> +#endif
> +
> +	/*
>  	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
>  	 * If userland migrates such a kthread to a non-root cgroup, it can
> -	 * become trapped in a cpuset, or RT kthread may be born in a
> -	 * cgroup with no rt_runtime allocated.  Just say no.
> +	 * become trapped in a cpuset. Just say no.
>  	 */
> -	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
> +#ifdef CONFIG_CPUSETS
> +	if ((tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) &&
> +			(dst_cgrp->root->subsys_mask & (1U << cpuset_cgrp_id))) {
>  		tsk = ERR_PTR(-EINVAL);
>  		goto out_unlock_threadgroup;
>  	}
> +#endif

Nit: maybe move this #ifdefery out to a header?

Thanks,
Quentin
