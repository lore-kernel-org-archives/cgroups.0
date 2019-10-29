From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: fix data race in mem_cgroup_select_victim_node
Date: Tue, 29 Oct 2019 11:09:29 -0700
Message-ID: <CALvZod648GRvjd_LqViFzLRwxnzSrLZzjaNBOJju4xkDQkvrXw@mail.gmail.com>
References: <20191029005405.201986-1-shakeelb@google.com> <20191029090347.GG31513@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjPIA2E/5Fq521b+ML0SLUvafFSbqxin1BmVqwTUyt8=;
        b=GEgloQHTa6D4+gvI9CNAFRP6KGQEIM5wYH9xmQxYFJxfmoN/S3HWvbO9fc4WkqwO8K
         MG7DPxKv6o190npOhAGGHq3gCmMduti7dve9KfbZB2DfW36Cuq4+A1E7qa9lGiGGpeP9
         7c3IlpH2WU+nd0YxdB7l0cCemIePL2VcRnTvilGoBfIzq/WNuOI+XckME9mhWzF6B8SQ
         sMHJ5zTJyG6lFU+MIp78cZLi9LgZGLJuBMm8KE6loBZqSPX+OG1Wk01Ac9awzUC9hH9s
         GXfrdcRAhmPUrh/5C6lfXiyTDhZd3J+C3rphT1vV0JR6Zx0HuunJMzyrHMeDp8ZScoWY
         sehw==
In-Reply-To: <20191029090347.GG31513@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com, elver@google.com

+Marco

On Tue, Oct 29, 2019 at 2:03 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 28-10-19 17:54:05, Shakeel Butt wrote:
> > Syzbot reported the following bug:
> >
> > BUG: KCSAN: data-race in mem_cgroup_select_victim_node / mem_cgroup_select_victim_node
> >
> > write to 0xffff88809fade9b0 of 4 bytes by task 8603 on cpu 0:
> >  mem_cgroup_select_victim_node+0xb5/0x3d0 mm/memcontrol.c:1686
> >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> >
> > read to 0xffff88809fade9b0 of 4 bytes by task 7290 on cpu 1:
> >  mem_cgroup_select_victim_node+0x92/0x3d0 mm/memcontrol.c:1675
> >  try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
> >  reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
> >  mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
> >  tracehook_notify_resume include/linux/tracehook.h:197 [inline]
> >  exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
> >  prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
> >  swapgs_restore_regs_and_return_to_usermode+0x0/0x40
> >
> > mem_cgroup_select_victim_node() can be called concurrently which reads
> > and modifies memcg->last_scanned_node without any synchrnonization. So,
> > read and modify memcg->last_scanned_node with READ_ONCE()/WRITE_ONCE()
> > to stop potential reordering.
>
> I am sorry but I do not understand the problem and the fix. Why does the
> race happen and why does _ONCE fixes it? There is still no
> synchronization. Do you want to prevent from memcg->last_scanned_node
> reloading?
>

The problem is memcg->last_scanned_node can read and modified
concurrently. Though to me it seems like a tolerable race and not
worth to add an explicit lock. My aim was to make KCSAN happy here to
look elsewhere for the concurrency bugs. However I see that it might
complain next on memcg->scan_nodes.

Now taking a step back, I am questioning the whole motivation behind
mem_cgroup_select_victim_node(). Since we pass ZONELIST_FALLBACK
zonelist to the reclaimer, the shrink_node will be called for all
potential nodes. Also we don't short circuit the traversal of
shrink_node for all nodes on nr_reclaimed and we scan (size_on_node >>
priority) for all nodes, I don't see the reason behind having round
robin order of node traversal.

I am thinking of removing the whole mem_cgroup_select_victim_node()
heuristic. Please let me know if there are any objections.

thanks,
Shakeel
