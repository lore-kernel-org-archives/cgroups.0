From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: make mem_cgroup_read_stat() unsigned
Date: Tue, 22 Sep 2015 21:03:46 -0700
Message-ID: <20150922210346.749204fb.akpm@linux-foundation.org>
References: <xr93bncum0ey.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93bncum0ey.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm@kvack.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 22 Sep 2015 17:42:13 -0700 Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Andrew Morton wrote:
> 
> > On Tue, 22 Sep 2015 15:16:32 -0700 Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> mem_cgroup_read_stat() returns a page count by summing per cpu page
> >> counters.  The summing is racy wrt. updates, so a transient negative sum
> >> is possible.  Callers don't want negative values:
> >> - mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.
> >> - oom reports and memory.stat shouldn't show confusing negative usage.
> >> - tree_usage() already avoids negatives.
> >>
> >> Avoid returning negative page counts from mem_cgroup_read_stat() and
> >> convert it to unsigned.
> >
> > Someone please remind me why this code doesn't use the existing
> > percpu_counter library which solved this problem years ago.
> >
> >>   for_each_possible_cpu(cpu)
> >
> > and which doesn't iterate across offlined CPUs.
> 
> I found [1] and [2] discussing memory layout differences between:
> a) existing memcg hand rolled per cpu arrays of counters
> vs
> b) array of generic percpu_counter
> The current approach was claimed to have lower memory overhead and
> better cache behavior.
> 
> I assume it's pretty straightforward to create generic
> percpu_counter_array routines which memcg could use.  Possibly something
> like this could be made general enough could be created to satisfy
> vmstat, but less clear.
> 
> [1] http://www.spinics.net/lists/cgroups/msg06216.html
> [2] https://lkml.org/lkml/2014/9/11/1057

That all sounds rather bogus to me.  __percpu_counter_add() doesn't
modify struct percpu_counter at all except for when the cpu-local
counter overflows the configured batch size.  And for the memcg
application I suspect we can set the batch size to INT_MAX...

