From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH for-4.6] cgroup: ignore css_sets associated with dead
 cgroups during migration
Date: Wed, 16 Mar 2016 13:29:45 -0700
Message-ID: <20160316202945.GE21104@mtj.duckdns.org>
References: <20160316004304.GC3447@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KkyAzJsAtI71LBDc2zGfuT2hjZv5iScPiGlCGvMnFA8=;
        b=NwmXQTPhrXAKewYFsibM4qgb93mwq+5e58tr4tXcACDU1uruFnqSCNUTQ2QdR9Wl3H
         R/cjQMGDsTOCc9s/sM0e8V6zNQJFOVr6xN/zkcrwdh5G21ArB9hMBYYSbnEXWmaAGSXk
         mGlDZ58pfzNHsnWzW8PnhOLYtLxArDwMqx314loehPRwCSWqJhUs97nxVOTGr8pCKikn
         0kNhzMRMZjS2FItr8rrVgSw2Ew7nwr2kYr2VqkDdjRxbFl2f9pXguRPA7dytkQ2Tz8W+
         W3z0TkCxb10tql6izcawRpZ58hvrSXIXstIT5xGcYJEPtDg9fyGyxaSgCPs9I7LO57CC
         CIxw==
Content-Disposition: inline
In-Reply-To: <20160316004304.GC3447@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

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
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: 2e91fa7f6d45 ("cgroup: keep zombies associated with their original cgroups")
> Cc: stable@vger.kernel.org # v4.4+

Applying to cgroup/for-4.6.

Thanks.

-- 
tejun
