From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix blocking rstat function called from
 atomic cgroup1 thresholding code
Date: Tue, 27 Jul 2021 09:59:57 -0700
Message-ID: <CALvZod434VzPru+wcO=PgMDeCs6KPgR06MuGVttaDD64_z3QMw@mail.gmail.com>
References: <20210726150019.251820-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kvve0PvD+BG/Fg4YS9gRmkOVtrJzBbhe3AaQP2JrJi8=;
        b=BamPGKxkayrhztUhyIbCPdfJ8zOowXYiQvF4Ibi4hR0BXtMIs0NGaC5lPTvZHBn0Bj
         mzTVS882/CQo5XFnXL+kJORZmjlCxYKwnGheT0Mr4xI5I3Yz7pWttn2GW7k6ri8BGFj4
         /tuUI5A98uxjuAqFl1H6Cg6ALu6Gctc66YS0ZJ2uTIrJXzhfOvU5KfgqpqJhu7maJu/a
         NVk17jZ4yzeksCWzllgFbNe9pAgPx0k9n0jdpRhENWB/kHvVMJT0VhWqYjXiQR6GW3yz
         Y5xlnUlSP02eTGvm9lLHUxGDrXWl29SGfFf709MaMb2bdgYobYPeSAp+9ixsNYkmIs2a
         3dOQ==
In-Reply-To: <20210726150019.251820-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Mon, Jul 26, 2021 at 8:01 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Dan Carpenter reports:
>
>     The patch 2d146aa3aa84: "mm: memcontrol: switch to rstat" from Apr
>     29, 2021, leads to the following static checker warning:
>
>             kernel/cgroup/rstat.c:200 cgroup_rstat_flush()
>             warn: sleeping in atomic context
>
>     mm/memcontrol.c
>       3572  static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>       3573  {
>       3574          unsigned long val;
>       3575
>       3576          if (mem_cgroup_is_root(memcg)) {
>       3577                  cgroup_rstat_flush(memcg->css.cgroup);
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>     This is from static analysis and potentially a false positive.  The
>     problem is that mem_cgroup_usage() is called from __mem_cgroup_threshold()
>     which holds an rcu_read_lock().  And the cgroup_rstat_flush() function
>     can sleep.
>
>       3578                  val = memcg_page_state(memcg, NR_FILE_PAGES) +
>       3579                          memcg_page_state(memcg, NR_ANON_MAPPED);
>       3580                  if (swap)
>       3581                          val += memcg_page_state(memcg, MEMCG_SWAP);
>       3582          } else {
>       3583                  if (!swap)
>       3584                          val = page_counter_read(&memcg->memory);
>       3585                  else
>       3586                          val = page_counter_read(&memcg->memsw);
>       3587          }
>       3588          return val;
>       3589  }
>
> __mem_cgroup_threshold() indeed holds the rcu lock. In addition, the
> thresholding code is invoked during stat changes, and those contexts
> have irqs disabled as well. If the lock breaking occurs inside the
> flush function, it will result in a sleep from an atomic context.
>
> Use the irsafe flushing variant in mem_cgroup_usage() to fix this.
>
> Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

BTW what do you think of removing stat flushes from the read side
(kernel and userspace) completely after periodic flushing and async
flushing from update side? Basically with "memcg: infrastructure to
flush memcg stats".
