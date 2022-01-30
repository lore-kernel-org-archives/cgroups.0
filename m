From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Sun, 30 Jan 2022 12:51:00 -0800 (PST)
Message-ID: <973ec252-5297-ef24-411-31f24b353fb3@google.com>
References: <20220129205315.478628-1-longman@redhat.com> <20220129205315.478628-4-longman@redhat.com> <YfYxJR7ugv83ywAb@kernel.org> <82c99093-e44b-7fac-14ab-9e8392d107ea@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=h/cECQtg8Pw42Cg8cQsPRdyEcNVz1JX9ppZ0jmJVNMk=;
        b=EHTJS8+k2oaZV3vVFaJi4iJnm0zTSudXRujif1Kg4Tp24zztawm4YKkJNwtJ7gfazF
         5K+1rmI0TVvt0DGZ6YBUEIG12v8eHqBV1UsbO/LzbaLa0eM39ts+ZyGBl34z5d5QgniJ
         1hpersz5zRY4G+y4q2ekP/+rdom2g3zfRXtMgj/RM2b37DddUCoONkB5e6GM8zQl0BOV
         DBCqtTfm0eQnE9ZOasZIqc/u30BO5tZzfiNBs4PyK0h2pzdnv2ptr4d7tKwa+t1q/p6W
         msJ1N0brQOFLJF6BoGEzsZwT1Kz6peBfXtDcoDEqFr20lzOI5N330P5Zsq1VrDex68Tf
         I2UQ==
In-Reply-To: <82c99093-e44b-7fac-14ab-9e8392d107ea-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, 30 Jan 2022, Waiman Long wrote:

> On 1/30/22 01:33, Mike Rapoport wrote:
> > On Sat, Jan 29, 2022 at 03:53:15PM -0500, Waiman Long wrote:
> > > It was found that a number of offlined memcgs were not freed because
> > > they were pinned by some charged pages that were present. Even "echo
> > > 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
> > > offlined but not freed memcgs tend to increase in number over time with
> > > the side effect that percpu memory consumption as shown in /proc/meminfo
> > > also increases over time.
> > > 
> > > In order to find out more information about those pages that pin
> > > offlined memcgs, the page_owner feature is extended to dump memory
> > > cgroup information especially whether the cgroup is offlined or not.
> > > 
> > > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >   mm/page_owner.c | 31 +++++++++++++++++++++++++++++++
> > >   1 file changed, 31 insertions(+)
> > > 
> > > diff --git a/mm/page_owner.c b/mm/page_owner.c
> > > index 28dac73e0542..8dc5cd0fa227 100644
> > > --- a/mm/page_owner.c
> > > +++ b/mm/page_owner.c
> > > @@ -10,6 +10,7 @@
> > >   #include <linux/migrate.h>
> > >   #include <linux/stackdepot.h>
> > >   #include <linux/seq_file.h>
> > > +#include <linux/memcontrol.h>
> > >   #include <linux/sched/clock.h>
> > >     #include "internal.h"
> > > @@ -331,6 +332,7 @@ print_page_owner(char __user *buf, size_t count,
> > > unsigned long pfn,
> > >   		depot_stack_handle_t handle)
> > >   {
> > >   	int ret, pageblock_mt, page_mt;
> > > +	unsigned long __maybe_unused memcg_data;
> > >   	char *kbuf;
> > >     	count = min_t(size_t, count, PAGE_SIZE);
> > > @@ -365,6 +367,35 @@ print_page_owner(char __user *buf, size_t count,
> > > unsigned long pfn,
> > >   			migrate_reason_names[page_owner->last_migrate_reason]);
> > >   	}
> > >   +#ifdef CONFIG_MEMCG
> > Can we put all this along with the declaration of memcg_data in a helper
> > function please?
> > 
> Sure. Will post another version with that change.
> 

That would certainly make it much cleaner.  After that's done (and perhaps 
addressing my nit comment in the first patch), feel free to add

	Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

to all three patches.

Thanks!
