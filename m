From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 28 Apr 2022 13:23:21 -0400
Message-ID: <YmrNiY3VhdMbfTq1@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <YmnA0Da90IURbxrM@google.com>
 <Ymqj93gEEzu2Gb3U@cmpxchg.org>
 <YmrICbP6bDJqDv5R@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9SmhuH9L8EteTfK00zaW2y4ppXf8qMlwYgDRccWGmt8=;
        b=muYbbgHfo9WGJ1lQRYahawpH/mrMNBfK7mzuL6u28IeAbj+iYGwzrcpKpmnim+KBUZ
         5zkJFG9NzPq3+fKpOGZOAOCrXhf1wnatHjmKIAJUsMQs5U0pugjuVBY2Z7AgfvG4w+UV
         GwUMTlFqZrpnjMRWFeuK056BahnHxRCPKIVERaYT1ttVL6koUM8tI9eLPPI8y6nh9S2h
         MsMQWashOIjoU1ALQwCGF9oKu1uSxRIMYVl11VzzxDSKsalcUzJEheKrtsHyEtXmJG40
         tJ3Xv6dwPjHqkXwnMbRYE8iYiEZDw1H010FE9plnpaCbA12V/gFpErMKMqYXYn3TC5FN
         UvwA==
Content-Disposition: inline
In-Reply-To: <YmrICbP6bDJqDv5R-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Apr 28, 2022 at 09:59:53AM -0700, Minchan Kim wrote:
> On Thu, Apr 28, 2022 at 10:25:59AM -0400, Johannes Weiner wrote:
> > On Wed, Apr 27, 2022 at 03:16:48PM -0700, Minchan Kim wrote:
> > > On Wed, Apr 27, 2022 at 05:20:29PM -0400, Johannes Weiner wrote:
> > > > On Wed, Apr 27, 2022 at 01:29:34PM -0700, Minchan Kim wrote:
> > > > > Hi Johannes,
> > > > > 
> > > > > On Wed, Apr 27, 2022 at 12:00:15PM -0400, Johannes Weiner wrote:
> > > > > > Currently it requires poking at debugfs to figure out the size and
> > > > > > population of the zswap cache on a host. There are no counters for
> > > > > > reads and writes against the cache. As a result, it's difficult to
> > > > > > understand zswap behavior on production systems.
> > > > > > 
> > > > > > Print zswap memory consumption and how many pages are zswapped out in
> > > > > > /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.
> > > > > > 
> > > > > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > > > ---
> > > > > >  fs/proc/meminfo.c             |  7 +++++++
> > > > > >  include/linux/swap.h          |  5 +++++
> > > > > >  include/linux/vm_event_item.h |  4 ++++
> > > > > >  mm/vmstat.c                   |  4 ++++
> > > > > >  mm/zswap.c                    | 13 ++++++-------
> > > > > >  5 files changed, 26 insertions(+), 7 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> > > > > > index 6fa761c9cc78..6e89f0e2fd20 100644
> > > > > > --- a/fs/proc/meminfo.c
> > > > > > +++ b/fs/proc/meminfo.c
> > > > > > @@ -86,6 +86,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> > > > > >  
> > > > > >  	show_val_kb(m, "SwapTotal:      ", i.totalswap);
> > > > > >  	show_val_kb(m, "SwapFree:       ", i.freeswap);
> > > > > > +#ifdef CONFIG_ZSWAP
> > > > > > +	seq_printf(m,  "Zswap:          %8lu kB\n",
> > > > > > +		   (unsigned long)(zswap_pool_total_size >> 10));
> > > > > > +	seq_printf(m,  "Zswapped:       %8lu kB\n",
> > > > > > +		   (unsigned long)atomic_read(&zswap_stored_pages) <<
> > > > > > +		   (PAGE_SHIFT - 10));
> > > > > > +#endif
> > > > > 
> > > > > I agree it would be very handy to have the memory consumption in meminfo
> > > > > 
> > > > > https://lore.kernel.org/all/YYwZXrL3Fu8%2FvLZw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> > > > > 
> > > > > If we really go this Zswap only metric instead of general term
> > > > > "Compressed", I'd like to post maybe "Zram:" with same reason
> > > > > in this patchset. Do you think that's better idea instead of
> > > > > introducing general term like "Compressed:" or something else?
> > > > 
> > > > I'm fine with changing it to Compressed. If somebody cares about a
> > > > more detailed breakdown, we can add Zswap, Zram subsets as needed.
> > > 
> > > Thanks! Please consider ZSWPIN to rename more general term, too.
> > 
> > That doesn't make sense to me.
> > 
> > Zram is a swap backend, its traffic is accounted in PSWPIN/OUT. Zswap
> > is a writeback cache on top of the swap backend. It has pages
> > entering, refaulting, and being written back to the swap backend
> > (PSWPOUT). A zswpout and a zramout are different things.
> 
> Think about that system has two swap devices (storage + zram).
> I think it's useful to know how many swap IO comes from zram
> and rest of them are storage.

Hm, isn't this comparable to having one swap on flash and one swap on
a rotating disk? /sys/block/*/stat should be able to tell you how
traffic is distributed, no?

What I'm more worried about is the fact that in theory you can stack
zswap on top of zram. Consider a fast compression cache on top of a
higher compression backend. Is somebody doing this now? I doubt
it. But as people look into memory tiering more and more, this doesn't
sound entirely implausible. If the stacked layers then share the same
in/out events, it would be quite confusing.

If you think PSWPIN/OUT and per-device stats aren't enough, I'm not
opposed to adding zramin/out to /proc/vmstat as well. I think we're
less worried there than with /proc/meminfo. I'd just prefer to keep
them separate from the zswap events.

Does that sound reasonable?
