From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v2] sched: cpuset: Don't rebuild sched domains on
 suspend-resume
Date: Wed, 25 Jan 2023 16:35:46 +0000
Message-ID: <20230125163546.pspvigh4groiwjy7@airbuntu>
References: <20230120194822.962958-1-qyousef@layalina.io>
 <c4c2dec6-a72b-d675-fb42-be40e384ea2c@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASFlQvqBFf2+5cfZFM0tnDhN0cmGUnXdcMgd/XrWuzI=;
        b=bFW8Q0SAsCFre+6x3yP+2SyUjrYalHBu1AKf3hNSB3DS1ve3TjqfAiABaHJ5k7x2yg
         Gok2XiNmpaqk4Q9Y4N/bQFHHH/FwypWdbgr1tdGmBsJT6g10gQrO17U9epFhwJ8QHo5O
         VFAE54N8hQmLOeUt2/8ZCAEwHDyGS3SrOoj3rxkt1zQoBmfIZ7wqtBFSRKAyF/tLO9Fv
         pWfsizlSv7z/p7DRtpl/9zp+5P2OLKTeTLNPXQdDSb7x7e6wl/dusiCZlqtUpju+8abF
         3j57gQHnefwvp6xfyjI1y3cAn0Oar1juPv7Fnqzb6fQbvcXsERA1w8EZhEkcOuojnGTZ
         O4YA==
Content-Disposition: inline
In-Reply-To: <c4c2dec6-a72b-d675-fb42-be40e384ea2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 01/20/23 17:16, Waiman Long wrote:
> 
> On 1/20/23 14:48, Qais Yousef wrote:
> > Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
> > enabled rebuilding sched domain on cpuset and hotplug operations to
> > correct deadline accounting.
> > 
> > Rebuilding sched domain is a slow operation and we see 10+ ms delay on
> > suspend-resume because of that.
> > 
> > Since nothing is expected to change on suspend-resume operation; skip
> > rebuilding the sched domains to regain the time lost.
> > 
> > Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> > ---
> > 
> >      Changes in v2:
> >      	* Remove redundant check in update_tasks_root_domain() (Thanks Waiman)
> >      v1 link:
> >      	https://lore.kernel.org/lkml/20221216233501.gh6m75e7s66dmjgo@airbuntu/
> > 
> >   kernel/cgroup/cpuset.c  | 3 +++
> >   kernel/sched/deadline.c | 3 +++
> >   2 files changed, 6 insertions(+)
> > 
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index a29c0b13706b..9a45f083459c 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -1088,6 +1088,9 @@ static void rebuild_root_domains(void)
> >   	lockdep_assert_cpus_held();
> >   	lockdep_assert_held(&sched_domains_mutex);
> > +	if (cpuhp_tasks_frozen)
> > +		return;
> > +
> >   	rcu_read_lock();
> >   	/*
> > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > index 0d97d54276cc..42c1143a3956 100644
> > --- a/kernel/sched/deadline.c
> > +++ b/kernel/sched/deadline.c
> > @@ -2575,6 +2575,9 @@ void dl_clear_root_domain(struct root_domain *rd)
> >   {
> >   	unsigned long flags;
> > +	if (cpuhp_tasks_frozen)
> > +		return;
> > +
> >   	raw_spin_lock_irqsave(&rd->dl_bw.lock, flags);
> >   	rd->dl_bw.total_bw = 0;
> >   	raw_spin_unlock_irqrestore(&rd->dl_bw.lock, flags);
> 
> cpuhp_tasks_frozen is set when thaw_secondary_cpus() or
> freeze_secondary_cpus() is called. I don't know the exact suspend/resume
> calling sequences, will cpuhp_tasks_frozen be cleared at the end of resume
> sequence? Maybe we should make sure that rebuild_root_domain() is called at
> least once at the end of resume operation.

Very good questions. It made me look at the logic again and I realize now that
the way force_build behaves is causing this issue.

I *think* we should just make the call rebuild_root_domains() only if
cpus_updated in cpuset_hotplug_workfn().

cpuset_cpu_active() seems to be the source of force_rebuild in my case; which
seems to be called only after the last cpu is back online (what you suggest).
In this case we can end up with cpus_updated = false, but force_rebuild = true.

Now you added a couple of new users to force_rebuild in 4b842da276a8a; I'm
trying to figure out what the conditions would be there. It seems we can have
corner cases for cpus_update might not trigger correctly?

Could the below be a good cure?

AFAICT we must rebuild the root domains if something has changed in cpuset.
Which should be captured by either having:

	* cpus_updated = true
	* force_rebuild && !cpuhp_tasks_frozen

/me goes to test the patch

--->8---

	diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
	index a29c0b13706b..363e4459559f 100644
	--- a/kernel/cgroup/cpuset.c
	+++ b/kernel/cgroup/cpuset.c
	@@ -1079,6 +1079,8 @@ static void update_tasks_root_domain(struct cpuset *cs)
		css_task_iter_end(&it);
	 }

	+static bool need_rebuild_rd = true;
	+
	 static void rebuild_root_domains(void)
	 {
		struct cpuset *cs = NULL;
	@@ -1088,6 +1090,9 @@ static void rebuild_root_domains(void)
		lockdep_assert_cpus_held();
		lockdep_assert_held(&sched_domains_mutex);

	+       if (!need_rebuild_rd)
	+               return;
	+
		rcu_read_lock();

		/*
	@@ -3627,7 +3632,9 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
		/* rebuild sched domains if cpus_allowed has changed */
		if (cpus_updated || force_rebuild) {
			force_rebuild = false;
	+               need_rebuild_rd = cpus_updated || (force_rebuild && !cpuhp_tasks_frozen);
			rebuild_sched_domains();
	+               need_rebuild_rd = true;
		}

		free_cpumasks(NULL, ptmp);


--->8---

Thanks!
