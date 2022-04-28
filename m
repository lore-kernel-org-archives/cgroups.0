From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 28 Apr 2022 10:05:13 -0400
Message-ID: <YmqfGaIhE8W+Z1mo@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <Ymm3WpvJWby4gaD/@cmpxchg.org>
 <Ymm/wayEB3MH6ZRY@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EWNhQ6rVh6eXAW1cPKtOkkQDFiBPnV60f02tyxwR5Yc=;
        b=nibOfdXs0pW9RsNjEJkkttSRKnNqlNrv3VGuEoDx+NjanzQTMrPiHJBi6jLuBYlEBX
         NcO/5bG7QV10FdfyjroVW7zjvHmRCL6rESoVffMrL0roquyhR0RiqvnKOugcVXNzxQUv
         k+KjGFlWbI1y1+uZBSyBAhb5DLIo4mcmwiJJWFRu2M4LMUruthwmPcQm1TZjTnVUbevG
         iUldqaSPXn3+1z5uyqObupucLM6SHgKfNXHInYKV6a7ZZmUdMxKwRsdHyfT2sAGbHgZF
         D760Af4oY/VmKyobDe06ICDwWWOcI7CqP4m48CjvnuCsv6BaaaKe/enYr7XQgP56Ehbf
         7YeA==
Content-Disposition: inline
In-Reply-To: <Ymm/wayEB3MH6ZRY-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 27, 2022 at 03:12:17PM -0700, Minchan Kim wrote:
> On Wed, Apr 27, 2022 at 05:36:26PM -0400, Johannes Weiner wrote:
> > On Wed, Apr 27, 2022 at 05:20:31PM -0400, Johannes Weiner wrote:
> > > On Wed, Apr 27, 2022 at 01:29:34PM -0700, Minchan Kim wrote:
> > > > Hi Johannes,
> > > > 
> > > > On Wed, Apr 27, 2022 at 12:00:15PM -0400, Johannes Weiner wrote:
> > > > > Currently it requires poking at debugfs to figure out the size and
> > > > > population of the zswap cache on a host. There are no counters for
> > > > > reads and writes against the cache. As a result, it's difficult to
> > > > > understand zswap behavior on production systems.
> > > > > 
> > > > > Print zswap memory consumption and how many pages are zswapped out in
> > > > > /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.
> > > > > 
> > > > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > > ---
> > > > >  fs/proc/meminfo.c             |  7 +++++++
> > > > >  include/linux/swap.h          |  5 +++++
> > > > >  include/linux/vm_event_item.h |  4 ++++
> > > > >  mm/vmstat.c                   |  4 ++++
> > > > >  mm/zswap.c                    | 13 ++++++-------
> > > > >  5 files changed, 26 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> > > > > index 6fa761c9cc78..6e89f0e2fd20 100644
> > > > > --- a/fs/proc/meminfo.c
> > > > > +++ b/fs/proc/meminfo.c
> > > > > @@ -86,6 +86,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> > > > >  
> > > > >  	show_val_kb(m, "SwapTotal:      ", i.totalswap);
> > > > >  	show_val_kb(m, "SwapFree:       ", i.freeswap);
> > > > > +#ifdef CONFIG_ZSWAP
> > > > > +	seq_printf(m,  "Zswap:          %8lu kB\n",
> > > > > +		   (unsigned long)(zswap_pool_total_size >> 10));
> > > > > +	seq_printf(m,  "Zswapped:       %8lu kB\n",
> > > > > +		   (unsigned long)atomic_read(&zswap_stored_pages) <<
> > > > > +		   (PAGE_SHIFT - 10));
> > > > > +#endif
> > > > 
> > > > I agree it would be very handy to have the memory consumption in meminfo
> > > > 
> > > > https://lore.kernel.org/all/YYwZXrL3Fu8%2FvLZw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> > > > 
> > > > If we really go this Zswap only metric instead of general term
> > > > "Compressed", I'd like to post maybe "Zram:" with same reason
> > > > in this patchset. Do you think that's better idea instead of
> > > > introducing general term like "Compressed:" or something else?
> > > 
> > > I'm fine with changing it to Compressed. If somebody cares about a
> > > more detailed breakdown, we can add Zswap, Zram subsets as needed.
> > 
> > It does raise the question what to do about cgroup, though. Should the
> > control files (memory.zswap.current & memory.zswap.max) apply to zram
> > in the future? If so, we should rename them, too.
> > 
> > I'm not too familiar with zram, maybe you can provide some
> > background. AFAIU, Google uses zram quite widely; all the more
> > confusing why there is no container support for it yet.
> 
> My usecase with zram is Android which doesn't use memcg.

Ok.

After more thought, my take is that in the future it could make sense
to track zram pages in a cgroup's memory.current. But it should NOT be
included in the dedicated memory.zswap.* files. Zswap is an in-kernel
writeback cache, and those files allow userspace to tune writeback
thresholds depending on the composition of the workload's
workingset. This doesn't translate to zram: the wb facility that it
has is triggered by hand, based on criteria such as idle pages and
compression rate. It's not based on size. From a cgroup POV, it's a
memory consumer that should be subject to memory.max, nothing more.

This distinction applies to meminfo as well, though. While I think it
makes sense to have a combined "Compressed" counter for zram and
zswap, it's still important to understand zswap behavior on its own to
tune the system-wide writeback threshold in max_pool_percent. (And
again, while zram can also be limited, it's not a writeback threshold,
it's just a red line for returning -ENOMEM).

So I'm going to keep the Zswap and Zswapped items and retract the
delta patch for renaming it to Compressed.

But I'd ack a patch that adds a combined "Compressed" counter for zram
+ zswap if you send it, Minchan.
