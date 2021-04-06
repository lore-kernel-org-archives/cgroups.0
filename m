From: Pavan Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Tue, 6 Apr 2021 18:30:23 +0530
Message-ID: <20210406130023.GA21941@codeaurora.org>
References: <1617706753-25349-1-git-send-email-pkondeti@codeaurora.org>
 <YGxPwTVvpqYkkIMI@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617714049; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=sX/dPEAAoi06drO8Jv2y6lJBxs4XsNAHD4nrwcIcUQw=; b=OLQtrVJa/kiYtZFE3YAKKB77DPYfXzssP8OeS+a7LQ6ymrBqx7EgjIMJrzGTh+jWwEObMEz0
 8qX2cAXZl14CTwEBPE94P8065YBOo06oFdHe9dkpeyJ/esPKNAwJYtrboZ4vRsg7mi1jmLXr
 Tp+chRhf0mF4ryyOjI5HESdgVMo=
Sender: pkondeti=codeaurora.org-qLvOmUbifpzLzYW4gMljz9i2O/JbrIOy@public.gmane.org
Content-Disposition: inline
In-Reply-To: <YGxPwTVvpqYkkIMI-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Quentin,

On Tue, Apr 06, 2021 at 12:10:41PM +0000, Quentin Perret wrote:
> Hi Pavan,
> 
> On Tuesday 06 Apr 2021 at 16:29:13 (+0530), Pavankumar Kondeti wrote:
> > In Android GKI, CONFIG_FAIR_GROUP_SCHED is enabled [1] to help prioritize
> > important work. Given that CPU shares of root cgroup can't be changed,
> > leaving the tasks inside root cgroup will give them higher share
> > compared to the other tasks inside important cgroups. This is mitigated
> > by moving all tasks inside root cgroup to a different cgroup after
> > Android is booted. However, there are many kernel tasks stuck in the
> > root cgroup after the boot.
> > 
> > We see all kworker threads are in the root cpu cgroup. This is because,
> > tasks with PF_NO_SETAFFINITY flag set are forbidden from cgroup migration.
> > This restriction is in place to avoid kworkers getting moved to a cpuset
> > which conflicts with kworker affinity. Relax this restriction by explicitly
> > checking if the task is moving out of a cpuset cgroup. This allows kworkers
> > to be moved out root cpu cgroup.
> > 
> > We also see kthreadd_task and any kernel thread created after the Android boot
> > also stuck in the root cgroup. The current code prevents kthreadd_task moving
> > out root cgroup to avoid the possibility of creating new RT kernel threads
> > inside a cgroup with no RT runtime allocated. Apply this restriction when tasks
> > are moving out of cpu cgroup under CONFIG_RT_GROUP_SCHED. This allows all
> > kernel threads to be moved out of root cpu cgroup if the kernel does not
> > enable RT group scheduling.
> 
> OK, so IIUC this only works with cgroup v1 -- the unified hierarchy in
> v2 forces you to keep cpu and cpuset in 'sync'. But that should be fine,
> so this looks like a nice improvement to me.
> 
Yes. I will mention this in commit description.

> >  
> >  struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
> > -					     bool *locked)
> > +					     bool *locked,
> > +					     struct cgroup *dst_cgrp)
> >  	__acquires(&cgroup_threadgroup_rwsem)
> >  {
> >  	struct task_struct *tsk;
> > @@ -2784,15 +2785,28 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
> >  		tsk = tsk->group_leader;
> >  
> >  	/*
> > +	 * RT kthreads may be born in a cgroup with no rt_runtime allocated.
> > +	 * Just say no.
> > +	 */
> > +#ifdef CONFIG_RT_GROUP_SCHED
> > +	if (tsk->no_cgroup_migration && (dst_cgrp->root->subsys_mask & (1U << cpu_cgrp_id))) {
> > +		tsk = ERR_PTR(-EINVAL);
> > +		goto out_unlock_threadgroup;
> > +	}
> > +#endif
> > +
> > +	/*
> >  	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
> >  	 * If userland migrates such a kthread to a non-root cgroup, it can
> > -	 * become trapped in a cpuset, or RT kthread may be born in a
> > -	 * cgroup with no rt_runtime allocated.  Just say no.
> > +	 * become trapped in a cpuset. Just say no.
> >  	 */
> > -	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
> > +#ifdef CONFIG_CPUSETS
> > +	if ((tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) &&
> > +			(dst_cgrp->root->subsys_mask & (1U << cpuset_cgrp_id))) {
> >  		tsk = ERR_PTR(-EINVAL);
> >  		goto out_unlock_threadgroup;
> >  	}
> > +#endif
> 
> Nit: maybe move this #ifdefery out to a header?
> 
Agreed.

Thanks,
Pavan
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

