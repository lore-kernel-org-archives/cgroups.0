From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 17:20:29 -0400
Message-ID: <YmmznQ8AO5RLxicA@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HO69GAZWB5ZNDpZdF5+7qBeyAdQ2ziZHjagMLd+xkN0=;
        b=5W7SEFXUw6PNxrAXqi0ncsTH0FzFFYHStI+dwhrp0hF7U6GJFbv/sx3XO72IuBcV+F
         W9J+YYs/DLYjU6qP0rVKlFL4mk/jrQ4jfITtCJEm5HndT6slVEo64n64mX40Lr0F5jfc
         1QMKRxmC5RfbskkX2EgJaswtYkp8m/E3HG0Tv9N5rz0ytd5+9bDtotoj07hPPJAs80Me
         TtoOmnsAXwD34zxpMJu1gHKmF4bheYT5h3p5Qddrdk0UiE/7qaZ7hNRgP1AIVvH24qqF
         UCf3j8vqEpCFAmVeKl3Iw4i/5q9pJjAtRIprUh6/1rsxucu80pPFFznY6rCMiY64gOJE
         NndA==
Content-Disposition: inline
In-Reply-To: <Ymmnrkn0mSWcuvmH-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 27, 2022 at 01:29:34PM -0700, Minchan Kim wrote:
> Hi Johannes,
> 
> On Wed, Apr 27, 2022 at 12:00:15PM -0400, Johannes Weiner wrote:
> > Currently it requires poking at debugfs to figure out the size and
> > population of the zswap cache on a host. There are no counters for
> > reads and writes against the cache. As a result, it's difficult to
> > understand zswap behavior on production systems.
> > 
> > Print zswap memory consumption and how many pages are zswapped out in
> > /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  fs/proc/meminfo.c             |  7 +++++++
> >  include/linux/swap.h          |  5 +++++
> >  include/linux/vm_event_item.h |  4 ++++
> >  mm/vmstat.c                   |  4 ++++
> >  mm/zswap.c                    | 13 ++++++-------
> >  5 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> > index 6fa761c9cc78..6e89f0e2fd20 100644
> > --- a/fs/proc/meminfo.c
> > +++ b/fs/proc/meminfo.c
> > @@ -86,6 +86,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> >  
> >  	show_val_kb(m, "SwapTotal:      ", i.totalswap);
> >  	show_val_kb(m, "SwapFree:       ", i.freeswap);
> > +#ifdef CONFIG_ZSWAP
> > +	seq_printf(m,  "Zswap:          %8lu kB\n",
> > +		   (unsigned long)(zswap_pool_total_size >> 10));
> > +	seq_printf(m,  "Zswapped:       %8lu kB\n",
> > +		   (unsigned long)atomic_read(&zswap_stored_pages) <<
> > +		   (PAGE_SHIFT - 10));
> > +#endif
> 
> I agree it would be very handy to have the memory consumption in meminfo
> 
> https://lore.kernel.org/all/YYwZXrL3Fu8%2FvLZw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> 
> If we really go this Zswap only metric instead of general term
> "Compressed", I'd like to post maybe "Zram:" with same reason
> in this patchset. Do you think that's better idea instead of
> introducing general term like "Compressed:" or something else?

I'm fine with changing it to Compressed. If somebody cares about a
more detailed breakdown, we can add Zswap, Zram subsets as needed.

From 8e9e2d6490b7082c41743fbdb9ffd2db4e3ce962 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Wed, 27 Apr 2022 17:15:15 -0400
Subject: [PATCH] mm: zswap: add basic meminfo and vmstat coverage fix fix

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/filesystems/proc.rst | 7 ++++---
 fs/proc/meminfo.c                  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 8b5a94cfa722..93edcf233464 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -964,7 +964,7 @@ Example output. You may not have all of these fields.
     Mlocked:               0 kB
     SwapTotal:             0 kB
     SwapFree:              0 kB
-    Zswap:              1904 kB
+    Compressed:         1904 kB
     Zswapped:           7792 kB
     Dirty:                12 kB
     Writeback:             0 kB
@@ -1057,8 +1057,9 @@ SwapTotal
 SwapFree
               Memory which has been evicted from RAM, and is temporarily
               on the disk
-Zswap
-              Memory consumed by the zswap backend (compressed size)
+Compressed
+              Memory consumed by compression backends, such as zswap
+              (compressed size)
 Zswapped
               Amount of anonymous memory stored in zswap (original size)
 Dirty
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 6e89f0e2fd20..554d6f230e67 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -87,7 +87,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "SwapTotal:      ", i.totalswap);
 	show_val_kb(m, "SwapFree:       ", i.freeswap);
 #ifdef CONFIG_ZSWAP
-	seq_printf(m,  "Zswap:          %8lu kB\n",
+	seq_printf(m,  "Compressed:     %8lu kB\n",
 		   (unsigned long)(zswap_pool_total_size >> 10));
 	seq_printf(m,  "Zswapped:       %8lu kB\n",
 		   (unsigned long)atomic_read(&zswap_stored_pages) <<
-- 
2.35.3
