From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 28 Apr 2022 09:59:53 -0700
Message-ID: <YmrICbP6bDJqDv5R@google.com>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <YmnA0Da90IURbxrM@google.com>
 <Ymqj93gEEzu2Gb3U@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZDYp2Y77Y0buY8pwqMtyLcOAE+45dX/zsVX064x7LX0=;
        b=T5FFCS6UotdYG74iCBtYERNBWBj0bDr3newq9MZ2CU9iAU7Mvp0pkO5CiXjERw7Z4h
         dtH/fRg2OWCurCYY/v6eAgs86zEARY/k+6a8gV+KFp5cnuwhIc+5wD3LrAQy89ZpYjGn
         zh4XBjGCMww1+wmz3wu4aESExAsU5U3STiPkEsu5tnyY86NbVyZRjEGc1jDnJahB9RoI
         akO6N05QtWT7jO5Nq0Op+bDPxkkBcZqWYPxqRyT/l6r+xlIU6CgdduGLX8sp2gwYd8TJ
         5Y4/YsTIot25E8QLmvce9ubCcCd/jkHViC+wf9ZWxyci0PT7D76bJhMzp9dpPEi16tdZ
         /xvQ==
Sender: Minchan Kim <minchan.kim@gmail.com>
Content-Disposition: inline
In-Reply-To: <Ymqj93gEEzu2Gb3U@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Seth Jennings <sjenning@redhat.com>, Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Apr 28, 2022 at 10:25:59AM -0400, Johannes Weiner wrote:
> On Wed, Apr 27, 2022 at 03:16:48PM -0700, Minchan Kim wrote:
> > On Wed, Apr 27, 2022 at 05:20:29PM -0400, Johannes Weiner wrote:
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
> > > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
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
> > > > https://lore.kernel.org/all/YYwZXrL3Fu8%2FvLZw@google.com/
> > > > 
> > > > If we really go this Zswap only metric instead of general term
> > > > "Compressed", I'd like to post maybe "Zram:" with same reason
> > > > in this patchset. Do you think that's better idea instead of
> > > > introducing general term like "Compressed:" or something else?
> > > 
> > > I'm fine with changing it to Compressed. If somebody cares about a
> > > more detailed breakdown, we can add Zswap, Zram subsets as needed.
> > 
> > Thanks! Please consider ZSWPIN to rename more general term, too.
> 
> That doesn't make sense to me.
> 
> Zram is a swap backend, its traffic is accounted in PSWPIN/OUT. Zswap
> is a writeback cache on top of the swap backend. It has pages
> entering, refaulting, and being written back to the swap backend
> (PSWPOUT). A zswpout and a zramout are different things.

Think about that system has two swap devices (storage + zram).
I think it's useful to know how many swap IO comes from zram
and rest of them are storage.
