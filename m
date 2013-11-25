From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: use a dedicated workqueue
 for cgroup destruction
Date: Mon, 25 Nov 2013 09:16:39 +0800
Message-ID: <5292A4F7.3030105@huawei.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <20131122221752.GC8981@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131122221752.GC8981-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

> Since be44562613851 ("cgroup: remove synchronize_rcu() from
> cgroup_diput()"), cgroup destruction path makes use of workqueue.  css
> freeing is performed from a work item from that point on and a later
> commit, ea15f8ccdb430 ("cgroup: split cgroup destruction into two
> steps"), moves css offlining to workqueue too.
> 
> As cgroup destruction isn't depended upon for memory reclaim, the
> destruction work items were put on the system_wq; unfortunately, some
> controller may block in the destruction path for considerable duration
> while holding cgroup_mutex.  As large part of destruction path is
> synchronized through cgroup_mutex, when combined with high rate of
> cgroup removals, this has potential to fill up system_wq's max_active
> of 256.
> 
> Also, it turns out that memcg's css destruction path ends up queueing
> and waiting for work items on system_wq through work_on_cpu().  If
> such operation happens while system_wq is fully occupied by cgroup
> destruction work items, work_on_cpu() can't make forward progress
> because system_wq is full and other destruction work items on
> system_wq can't make forward progress because the work item waiting
> for work_on_cpu() is holding cgroup_mutex, leading to deadlock.
> 
> This can be fixed by queueing destruction work items on a separate
> workqueue.  This patch creates a dedicated workqueue -
> cgroup_destroy_wq - for this purpose.  As these work items shouldn't
> have inter-dependencies and mostly serialized by cgroup_mutex anyway,
> giving high concurrency level doesn't buy anything and the workqueue's
> @max_active is set to 1 so that destruction work items are executed
> one by one on each CPU.
> 
> Hugh Dickins: Because cgroup_init() is run before init_workqueues(),
> cgroup_destroy_wq can't be allocated from cgroup_init().  Do it from a
> separate core_initcall().  In the future, we probably want to reorder
> so that workqueue init happens before cgroup_init().
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Link: http://lkml.kernel.org/r/20131111220626.GA7509-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org
> Link: http://lkml.kernel.org/g/alpine.LNX.2.00.1310301606080.2333-fupSdm12i1nKWymIFiNcPA@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v3.9+

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
