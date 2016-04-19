From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Tue, 19 Apr 2016 10:01:21 -0400
Message-ID: <20160419140120.GA4126@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
 <20160418144023.GG6862@pathway.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418144023.GG6862-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 18-04-16 16:40:23, Petr Mladek wrote:
> On Fri 2016-04-15 10:38:15, Tejun Heo wrote:
> > > Anyway, before we go that way, can we at least consider the possibility
> > > of removing the kworker creation dependency on the global rwsem? AFAIU
> > > this locking was added because of the pid controller. Do we even care
> > > about something as volatile as kworkers in the pid controller?
> >
> > It's not just pid controller and the global percpu locking has lower
> > hotpath overhead.  We can try to exclude kworkers out of the locking
> > but that can get really nasty and there are already attempts to add
> > cgroup support to workqueue.  Will think more about it.
> 
> I have played with this idea on Friday. Please, find below a POC.
> The worker detection works and the deadlock is removed. But workers
> do not appear in the root cgroups. I am not familiar with the cgroups
> stuff, so this part is much more difficult for me.
> 
> I send it because it might give you an idea when discussing it
> on LSF. Please, let me know if I should continue on this way or
> if it looks too crazy already now.
> 
> 
> >From ca1420926f990892a914d64046ee8d273b876f30 Mon Sep 17 00:00:00 2001
> From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
> Date: Mon, 18 Apr 2016 14:17:17 +0200
> Subject: [POC PATCH] cgroups/workqueus: Do not block forking workqueues by cgroups
>  lock
> 
> This is a POC how to delay cgroups operations when forking workqueue
> workers.  Workqueues are used by some cgroups operations, for example,
> lru_add_drain_all().  Creating new worker might help to avoid a deadlock.
> 
> This patch adds a way to detect whether a workqueue worker is being
> forked, see detect_wq_worker().  For this it needs to make struct
> kthread_create_info and the main worker_thread public.  As a consequence,
> it renames worker_thread to wq_worker_thread.
> 
> Next, cgroups_fork() just initializes the cgroups fields in task_struct.
> It does not really need to be guarded by cgroup_threadgroup_rwsem.
> 
> cgroup_threadgroup_rwsem is taken later when we check if the fork
> is allowed and when we copy the cgroups setting.  But these two
> operations are skipped for workers.
> 
> The result is that workers are not blocked by any cgroups operation
> but they do not appear in the root cgroups.
> 
> There is a preparation of cgroup_delayed_post_fork() that might put
> the workers into the root cgroups.  It is just a copy of
> cgroup_post_fork() where "kthreadd_task" is hardcoded.  It is not yet
> called.  Also it is not protected against other cgroups operations.
> ---
>  include/linux/kthread.h   | 14 +++++++++++++
>  include/linux/workqueue.h |  1 +
>  kernel/cgroup.c           | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/fork.c             | 36 +++++++++++++++++++++++---------
>  kernel/kthread.c          | 14 -------------
>  kernel/workqueue.c        |  9 ++++----
>  6 files changed, 98 insertions(+), 29 deletions(-)

This feels too overcomplicated. Can we simply drop the locking in
copy_process if the current == ktreadadd? Would something actually
break?
-- 
Michal Hocko
SUSE Labs
