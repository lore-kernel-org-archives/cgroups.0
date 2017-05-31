From: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/6] mm: memcontrol: per-lruvec stats infrastructure
Date: Wed, 31 May 2017 12:02:10 -0700
Message-ID: <20170531190209.GK3730@atomide.com>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-6-hannes@cmpxchg.org>
 <20170531171450.GA10481@cmpxchg.org>
 <20170531111821.14ebeee4a4181583fe6fac46@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531111821.14ebeee4a4181583fe6fac46-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Russell King <rmk-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>

* Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> [170531 11:21]:
> On Wed, 31 May 2017 13:14:50 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > Andrew, the 0day tester found a crash with this when special pages get
> > faulted. They're not charged to any cgroup and we'll deref NULL.
> > 
> > Can you include the following fix on top of this patch please? Thanks!
> 
> OK.  But this won't fix the init ordering crash which the arm folks are
> seeing?

That's correct, the ordering crash is a separate problem.

> I'm wondering if we should ask Stephen to drop
> 
> mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
> mm-memcontrol-use-the-node-native-slab-memory-counters.patch
> mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
> mm-memcontrol-per-lruvec-stats-infrastructure.patch
> mm-memcontrol-account-slab-stats-per-lruvec.patch
> 
> until that is sorted?

Seems like a good idea.

Regards,

Tony
