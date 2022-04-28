From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 28 Apr 2022 10:25:59 -0400
Message-ID: <Ymqj93gEEzu2Gb3U@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <YmnA0Da90IURbxrM@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k2xk0VfPUZZR4PgPEBFE7KbYEWH+FmFopnCFIlm7PdU=;
        b=BV94KuxAotFnCW2rpxR5ikP/WxESDoIazAhKPFkO1eGzDxo7hawOoKkHC0UbhoIeQy
         kZg8jfkxgeybcxSbVkPKyf/R8j319H1hEEjldKPErEBwufuhSw5mT4aclDQzGTGmOQ4z
         vfMoivqIpG4ELDuBcZ0Lo3UjNSF9EOuclEjFk4kMkAuHZnXHnZGbiU71bRjNAWpZoXdE
         OVtUxqBbeYfV85GYLzG9DEZSYCi7JYWgpRIAP4TxPtab35D28kaePo90gYcCyWnoTDSJ
         nh0zCTTwNRYmmxH3C3h+6DAcalHEbjnTNIOcg75fSF6dIHkflMcrL1mdWIN+kjqV2eZ+
         euow==
Content-Disposition: inline
In-Reply-To: <YmnA0Da90IURbxrM-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 27, 2022 at 03:16:48PM -0700, Minchan Kim wrote:
> On Wed, Apr 27, 2022 at 05:20:29PM -0400, Johannes Weiner wrote:
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
> Thanks! Please consider ZSWPIN to rename more general term, too.

That doesn't make sense to me.

Zram is a swap backend, its traffic is accounted in PSWPIN/OUT. Zswap
is a writeback cache on top of the swap backend. It has pages
entering, refaulting, and being written back to the swap backend
(PSWPOUT). A zswpout and a zramout are different things.

> > From 8e9e2d6490b7082c41743fbdb9ffd2db4e3ce962 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date: Wed, 27 Apr 2022 17:15:15 -0400
> > Subject: [PATCH] mm: zswap: add basic meminfo and vmstat coverage fix fix
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Just for completeness,

Nacked-by: Johannes Weiner <hannes-ss0hH0V9XVJAfugRpC6u6w@public.gmane.org>

> > @@ -87,7 +87,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> >  	show_val_kb(m, "SwapTotal:      ", i.totalswap);
> >  	show_val_kb(m, "SwapFree:       ", i.freeswap);
> >  #ifdef CONFIG_ZSWAP
> > -	seq_printf(m,  "Zswap:          %8lu kB\n",
> > +	seq_printf(m,  "Compressed:     %8lu kB\n",
> >  		   (unsigned long)(zswap_pool_total_size >> 10));
> >  	seq_printf(m,  "Zswapped:       %8lu kB\n",
> >  		   (unsigned long)atomic_read(&zswap_stored_pages) <<
> > -- 
> > 2.35.3
> > 
