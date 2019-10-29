From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: fix data race in mem_cgroup_select_victim_node
Date: Tue, 29 Oct 2019 11:46:46 -0700
Message-ID: <CALvZod7npAH0okM5HnsR-F6N6EF5eT6sfX-XVusrXVuBgZfh6Q@mail.gmail.com>
References: <20191029005405.201986-1-shakeelb@google.com> <20191029090347.GG31513@dhcp22.suse.cz>
 <CALvZod648GRvjd_LqViFzLRwxnzSrLZzjaNBOJju4xkDQkvrXw@mail.gmail.com> <20191029182802.GA193152@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ReWNXiQSJHk1Ohmt4ko0ZYhBstNAojS1cH/ggSlVoAI=;
        b=Kn3CZE3xBzziKVWaQmk/w5rlpZO2GbLA16umwkgVooj88NX/DmIyNIa6Isn2UqLS3F
         Fm+cD+GDopHSMsxgxlBeiPULD6tNKXBO67r0TMwCr/VOs30OEn5etwD5cMzd76l9ADJv
         bEPEN4IhS26FRzf4+PXqg5MERXrdSITqMRw5E2dC1/uboYjloD56iI96ELRsUrcpxLP5
         yc1s6tD8CjoBQyxKweBAhpoGiE7mzUtYafmLLspCafldR8G622VHkePlx/x8soweCzFX
         PCQ7ktRLpjSRRT04ctRSkLGV/puDZijKegMjGo+KDZNPPwCZYRTuI5e1XHQlrNwIo8QJ
         DbXg==
In-Reply-To: <20191029182802.GA193152@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

On Tue, Oct 29, 2019 at 11:28 AM Marco Elver <elver@google.com> wrote:
>
>
>
> On Tue, 29 Oct 2019, Shakeel Butt wrote:
>
> > +Marco
> >
> > On Tue, Oct 29, 2019 at 2:03 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 28-10-19 17:54:05, Shakeel Butt wrote:
> > > > Syzbot reported the following bug:
> > > >
> > > > BUG: KCSAN: data-race in mem_cgroup_select_victim_node / mem_cgroup_select_victim_node
> > > >
> > > > write to 0xffff88809fade9b0 of 4 bytes by task 8603 on cpu 0:
> > > >  mem_cgroup_select_victim_node+0xb5/0x3d0 mm/memcontrol.c:1686
> > > >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> > > >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> > > >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> > > >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> > > >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> > > >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> > > >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> > > >
> > > > read to 0xffff88809fade9b0 of 4 bytes by task 7290 on cpu 1:
> > > >  mem_cgroup_select_victim_node+0x92/0x3d0 mm/memcontrol.c:1675
> > > >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> > > >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> > > >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> > > >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> > > >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> > > >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> > > >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> > > >
> > > > mem_cgroup_select_victim_node() can be called concurrently which reads
> > > > and modifies memcg->last_scanned_node without any synchrnonization. So,
> > > > read and modify memcg->last_scanned_node with READ_ONCE()/WRITE_ONCE()
> > > > to stop potential reordering.
>
> Strictly speaking, READ_ONCE/WRITE_ONCE alone avoid various bad compiler
> optimizations, including store tearing, load tearing, etc. This does not
> add memory barriers to constrain memory ordering.  (If this code needs
> some memory ordering guarantees w.r.t. previous loads/stores then this
> alone is not enough.)
>
> > > I am sorry but I do not understand the problem and the fix. Why does the
> > > race happen and why does _ONCE fixes it? There is still no
> > > synchronization. Do you want to prevent from memcg->last_scanned_node
> > > reloading?
> > >
> >
> > The problem is memcg->last_scanned_node can read and modified
> > concurrently. Though to me it seems like a tolerable race and not
> > worth to add an explicit lock. My aim was to make KCSAN happy here to
> > look elsewhere for the concurrency bugs. However I see that it might
> > complain next on memcg->scan_nodes.
>
> The plain concurrent reads/writes are a data race, which may manifest in
> various undefined behaviour due to compiler optimizations. The _ONCE
> will prevent these (KCSAN only reports data races).  Note that, "data
> race" does not necessarily imply "race condition"; some data races are
> race conditions (usually the more interesting bugs) -- but not *all*
> data races are race conditions. If there is no race condition here that
> warrants heavier synchronization (locking etc.), then this patch is all
> that should be needed.
>
> I can't comment on the rest.
>

Thanks Marco for the explanation.
