From: Marco Elver <elver@google.com>
Subject: Re: [PATCH] mm: memcontrol: fix data race in
 mem_cgroup_select_victim_node
Date: Tue, 29 Oct 2019 19:28:02 +0100
Message-ID: <20191029182802.GA193152@google.com>
References: <20191029005405.201986-1-shakeelb@google.com>
 <20191029090347.GG31513@dhcp22.suse.cz>
 <CALvZod648GRvjd_LqViFzLRwxnzSrLZzjaNBOJju4xkDQkvrXw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lc0YR6zDkvJBR1Lmyr78EIEUjbyCrD4ENhnxzUSJhcA=;
        b=iHFxJvYuZq4G9qaQCdumXteszLysWMaL+ueo6DBsLBl3z9HNC1yqtPLD6gCDJbLYqM
         miI2K6+47J3PmvgsRFG+XsCPP09qOfnRSZ2o3fVAQcL6IWq+F0Lb0IVuNVN6LyDMuhWN
         QcyjxJQ5J6fHF0BExW1H737h62yFQrOyNhixlBx7jo+y1a/HGWvG4vsHMkcFzQIBku2c
         nvCLr73gax20ZKvuzP5i84oLfymNJYCk27XQapnmXlrGUYsZcnZvJesVN6wyDdLWfTnh
         vCGc+KlD3c16A7xbdM6tQ4F2q90fB2FvGO2/z2ROvny0qvzWII8MwF+O73vO3S3lMpkR
         WOYQ==
Content-Disposition: inline
In-Reply-To: <CALvZod648GRvjd_LqViFzLRwxnzSrLZzjaNBOJju4xkDQkvrXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com



On Tue, 29 Oct 2019, Shakeel Butt wrote:

> +Marco
> 
> On Tue, Oct 29, 2019 at 2:03 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 28-10-19 17:54:05, Shakeel Butt wrote:
> > > Syzbot reported the following bug:
> > >
> > > BUG: KCSAN: data-race in mem_cgroup_select_victim_node / mem_cgroup_select_victim_node
> > >
> > > write to 0xffff88809fade9b0 of 4 bytes by task 8603 on cpu 0:
> > >  mem_cgroup_select_victim_node+0xb5/0x3d0 mm/memcontrol.c:1686
> > >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> > >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> > >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> > >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> > >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> > >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> > >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> > >
> > > read to 0xffff88809fade9b0 of 4 bytes by task 7290 on cpu 1:
> > >  mem_cgroup_select_victim_node+0x92/0x3d0 mm/memcontrol.c:1675
> > >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> > >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> > >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> > >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> > >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> > >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> > >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> > >
> > > mem_cgroup_select_victim_node() can be called concurrently which reads
> > > and modifies memcg->last_scanned_node without any synchrnonization. So,
> > > read and modify memcg->last_scanned_node with READ_ONCE()/WRITE_ONCE()
> > > to stop potential reordering.

Strictly speaking, READ_ONCE/WRITE_ONCE alone avoid various bad compiler
optimizations, including store tearing, load tearing, etc. This does not
add memory barriers to constrain memory ordering.  (If this code needs
some memory ordering guarantees w.r.t. previous loads/stores then this
alone is not enough.)

> > I am sorry but I do not understand the problem and the fix. Why does the
> > race happen and why does _ONCE fixes it? There is still no
> > synchronization. Do you want to prevent from memcg->last_scanned_node
> > reloading?
> >
> 
> The problem is memcg->last_scanned_node can read and modified
> concurrently. Though to me it seems like a tolerable race and not
> worth to add an explicit lock. My aim was to make KCSAN happy here to
> look elsewhere for the concurrency bugs. However I see that it might
> complain next on memcg->scan_nodes.

The plain concurrent reads/writes are a data race, which may manifest in
various undefined behaviour due to compiler optimizations. The _ONCE
will prevent these (KCSAN only reports data races).  Note that, "data
race" does not necessarily imply "race condition"; some data races are
race conditions (usually the more interesting bugs) -- but not *all*
data races are race conditions. If there is no race condition here that
warrants heavier synchronization (locking etc.), then this patch is all
that should be needed.

I can't comment on the rest.

Thanks,
-- Marco
