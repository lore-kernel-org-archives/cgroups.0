From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-4.6] cgroup: ignore css_sets associated with dead
 cgroups during migration
Date: Wed, 16 Mar 2016 11:45:27 +0100
Message-ID: <20160316104527.GG25010@twins.programming.kicks-ass.net>
References: <20160316004304.GC3447@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160316004304.GC3447-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Mar 15, 2016 at 08:43:04PM -0400, Tejun Heo wrote:
> Before 2e91fa7f6d45 ("cgroup: keep zombies associated with their
> original cgroups"), all dead tasks were associated with init_css_set.
> If a zombie task is requested for migration, while migration prep
> operations would still be performed on init_css_set, the actual
> migration would ignore zombie tasks.  As init_css_set is always valid,
> this worked fine.
> 
> However, after 2e91fa7f6d45, zombie tasks stay with the css_set it was
> associated with at the time of death.  Let's say a task T associated
> with cgroup A on hierarchy H-1 and cgroup B on hiearchy H-2.  After T
> becomes a zombie, it would still remain associated with A and B.  If A
> only contains zombie tasks, it can be removed.  On removal, A gets
> marked offline but stays pinned until all zombies are drained.  At
> this point, if migration is initiated on T to a cgroup C on hierarchy
> H-2, migration path would try to prepare T's css_set for migration and
> trigger the following.
> 
>  WARNING: CPU: 0 PID: 1576 at kernel/cgroup.c:474 cgroup_get+0x121/0x160()
>  CPU: 0 PID: 1576 Comm: bash Not tainted 4.4.0-work+ #289
>  ...
>  Call Trace:
>   [<ffffffff8127e63c>] dump_stack+0x4e/0x82
>   [<ffffffff810445e8>] warn_slowpath_common+0x78/0xb0
>   [<ffffffff810446d5>] warn_slowpath_null+0x15/0x20
>   [<ffffffff810c33e1>] cgroup_get+0x121/0x160
>   [<ffffffff810c349b>] link_css_set+0x7b/0x90
>   [<ffffffff810c4fbc>] find_css_set+0x3bc/0x5e0
>   [<ffffffff810c5269>] cgroup_migrate_prepare_dst+0x89/0x1f0
>   [<ffffffff810c7547>] cgroup_attach_task+0x157/0x230
>   [<ffffffff810c7a17>] __cgroup_procs_write+0x2b7/0x470
>   [<ffffffff810c7bdc>] cgroup_tasks_write+0xc/0x10
>   [<ffffffff810c4790>] cgroup_file_write+0x30/0x1b0
>   [<ffffffff811c68fc>] kernfs_fop_write+0x13c/0x180
>   [<ffffffff81151673>] __vfs_write+0x23/0xe0
>   [<ffffffff81152494>] vfs_write+0xa4/0x1a0
>   [<ffffffff811532d4>] SyS_write+0x44/0xa0
>   [<ffffffff814af2d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
> 
> It doesn't make sense to prepare migration for css_sets pointing to
> dead cgroups as they are guaranteed to contain only zombies which are
> ignored later during migration.  This patch makes cgroup destruction
> path mark all affected css_sets as dead and updates the migration path
> to ignore them during preparation.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 2e91fa7f6d45 ("cgroup: keep zombies associated with their original cgroups")

This doesn't fix the problem that those zombies might actually still
want to use the cgroups they're tied to, as reported here:

  lkml.kernel.org/r/20160314112057.GT6356-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org

I would strongly suggest to revert 2e91fa7f6d45 wholesale (and mark for
stable) and try again later.
