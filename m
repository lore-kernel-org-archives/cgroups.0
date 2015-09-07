From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 3/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Mon, 7 Sep 2015 14:38:22 +0300
Message-ID: <20150907113822.GB31800@esperanza>
References: <20150828220158.GD11089@htj.dyndns.org>
 <20150828220237.GE11089@htj.dyndns.org>
 <20150904210011.GH25329@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150904210011.GH25329-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Sep 04, 2015 at 05:00:11PM -0400, Tejun Heo wrote:
> Currently, try_charge() tries to reclaim memory synchronously when the
> high limit is breached; however, if the allocation doesn't have
> __GFP_WAIT, synchronous reclaim is skipped.  If a process performs
> only speculative allocations, it can blow way past the high limit.
> This is actually easily reproducible by simply doing "find /".
> slab/slub allocator tries speculative allocations first, so as long as
> there's memory which can be consumed without blocking, it can keep
> allocating memory regardless of the high limit.
> 
> This patch makes try_charge() always punt the over-high reclaim to the
> return-to-userland path.  If try_charge() detects that high limit is
> breached, it adds the overage to current->memcg_nr_pages_over_high and
> schedules execution of mem_cgroup_handle_over_high() which performs
> synchronous reclaim from the return-to-userland path.
> 
> As long as kernel doesn't have a run-away allocation spree, this
> should provide enough protection while making kmemcg behave more
> consistently.

Another good thing about such an approach is that it copes with prio
inversion. Currently, a task with small memory.high might issue
memory.high reclaim on kmem charge with a bunch of various locks held.
If a task with a big value of memory.high needs any of these locks,
it'll have to wait until the low prio task finishes reclaim and releases
the locks. By handing over reclaim to task_work whenever possible we
might avoid this issue and improve overall performance.

> 
> v2: - Switched to reclaiming only the overage caused by current rather
>       than the difference between usage and high as suggested by
>       Michal.
>     - Don't record the memcg which went over high limit.  This makes
>       exit path handling unnecessary.  Dropped.
>     - Drop mentions of avoiding high stack usage from description as
>       suggested by Vladimir.  max limit still triggers direct reclaim.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
