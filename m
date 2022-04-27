From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 15:12:17 -0700
Message-ID: <Ymm/wayEB3MH6ZRY@google.com>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <Ymm3WpvJWby4gaD/@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XXb42XiH+ukC9z7j3bBup8sRRl4KaGc4g7+LlMYSHsA=;
        b=Ws495q2rl2PRGj/zVnW5ZArxK3DYt6X/R641/Rg4daUGK5XREH0QoEi3vo4dOrnylv
         nP3eMrTlYZWHRUyOoBu/xrKPZ2+lmrhsSlg9egRevjW/NgcxcSBcwPi27LwUCBj6owub
         kcJkjnYF1BYOUc2SQz1i21KiLaGf3zKZxIK9Ff5IoHm/vhFuwWVc1xa15T7n334wy8Xf
         fMRPixKczaNFkniv3DoL5k3q+7DL86Pig/zQIONH8YyaTzxbDMqHdPA16yAu/5RKeusa
         dOse573kLTyhajewwEJzfifVdlrEfSxKvsC87iTJ29vMlS+9nttNB572LQsHcf9BbcKF
         zD+Q==
Sender: Minchan Kim <minchan.kim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Ymm3WpvJWby4gaD/@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 27, 2022 at 05:36:26PM -0400, Johannes Weiner wrote:
> On Wed, Apr 27, 2022 at 05:20:31PM -0400, Johannes Weiner wrote:
> > On Wed, Apr 27, 2022 at 01:29:34PM -0700, Minchan Kim wrote:
> > > Hi Johannes,
> > > 
> > > On Wed, Apr 27, 2022 at 12:00:15PM -0400, Johannes Weiner wrote:
> > > > Currently it requires poking at debugfs to figure out the size and
> > > > population of the zswap cache on a host. There are no counters for
> > > > reads and writes against the cache. As a result, it's difficult to
> > > > understand zswap behavior on production systems.
> > > > 
> > > > Print zswap memory consumption and how many pages are zswapped out in
> > > > /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > ---
> > > >  fs/proc/meminfo.c             |  7 +++++++
> > > >  include/linux/swap.h          |  5 +++++
> > > >  include/linux/vm_event_item.h |  4 ++++
> > > >  mm/vmstat.c                   |  4 ++++
> > > >  mm/zswap.c                    | 13 ++++++-------
> > > >  5 files changed, 26 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> > > > index 6fa761c9cc78..6e89f0e2fd20 100644
> > > > --- a/fs/proc/meminfo.c
> > > > +++ b/fs/proc/meminfo.c
> > > > @@ -86,6 +86,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> > > >  
> > > >  	show_val_kb(m, "SwapTotal:      ", i.totalswap);
> > > >  	show_val_kb(m, "SwapFree:       ", i.freeswap);
> > > > +#ifdef CONFIG_ZSWAP
> > > > +	seq_printf(m,  "Zswap:          %8lu kB\n",
> > > > +		   (unsigned long)(zswap_pool_total_size >> 10));
> > > > +	seq_printf(m,  "Zswapped:       %8lu kB\n",
> > > > +		   (unsigned long)atomic_read(&zswap_stored_pages) <<
> > > > +		   (PAGE_SHIFT - 10));
> > > > +#endif
> > > 
> > > I agree it would be very handy to have the memory consumption in meminfo
> > > 
> > > https://lore.kernel.org/all/YYwZXrL3Fu8%2FvLZw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> > > 
> > > If we really go this Zswap only metric instead of general term
> > > "Compressed", I'd like to post maybe "Zram:" with same reason
> > > in this patchset. Do you think that's better idea instead of
> > > introducing general term like "Compressed:" or something else?
> > 
> > I'm fine with changing it to Compressed. If somebody cares about a
> > more detailed breakdown, we can add Zswap, Zram subsets as needed.
> 
> It does raise the question what to do about cgroup, though. Should the
> control files (memory.zswap.current & memory.zswap.max) apply to zram
> in the future? If so, we should rename them, too.
> 
> I'm not too familiar with zram, maybe you can provide some
> background. AFAIU, Google uses zram quite widely; all the more
> confusing why there is no container support for it yet.

My usecase with zram is Android which doesn't use memcg.
