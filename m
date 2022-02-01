From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/4] mm/page_owner: Print memcg information
Date: Tue, 1 Feb 2022 08:23:10 +0200
Message-ID: <YfjRzobwtv7wn2Gt@kernel.org>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-4-longman@redhat.com>
 <YfhLzI+RLRGgexmr@kernel.org>
 <4234fc60-5d65-1089-555a-734218aa6f9c@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643696601;
        bh=HfcgLdgc3B7KCIDeYVDCOGK+3kcF0wgKikBnzg+bTCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hkLUp/IB2GCcNukU/n/SN3b4hGrNAVgSg9olTqdDrlQh72GPdsAAVGRf0TV8xX057
         qFFxIfxMqcDSpcR4vUWfClWa+KHHdR0nJfmXPM09CDY4QLolTZLqehrDSkIWngO+s9
         r0ezCld7Bnw/YR4G7Rzgpjk8S7tyOWf9en8aAW1dKA09kMoohjG5KCMG+QiHpzVtzN
         UgegvrFmT6sm501g8kg1Xm84rV9G5XmIzK0CBNRLfSHV7D7s2Kaw2R60x7P8M6hWCr
         f6hIiAGIHpVsMk9NsXdCgaQZYKGZxXJcOYv7BQ9EHrfnZ57lIdjJTFBgG7/YYvdQFd
         SQZxnXbIRRgYA==
Content-Disposition: inline
In-Reply-To: <4234fc60-5d65-1089-555a-734218aa6f9c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 31, 2022 at 04:43:32PM -0500, Waiman Long wrote:
> 
> On 1/31/22 15:51, Mike Rapoport wrote:
> > On Mon, Jan 31, 2022 at 02:23:07PM -0500, Waiman Long wrote:
> > > It was found that a number of offlined memcgs were not freed because
> > > they were pinned by some charged pages that were present. Even "echo
> > > 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
> > > offlined but not freed memcgs tend to increase in number over time with
> > > the side effect that percpu memory consumption as shown in /proc/meminfo
> > > also increases over time.
> > > 
> > > In order to find out more information about those pages that pin
> > > offlined memcgs, the page_owner feature is extended to print memory
> > > cgroup information especially whether the cgroup is offlined or not.
> > > 
> > > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >   mm/page_owner.c | 39 +++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 39 insertions(+)
> > > 
> > > diff --git a/mm/page_owner.c b/mm/page_owner.c
> > > index 28dac73e0542..a471c74c7fe0 100644
> > > --- a/mm/page_owner.c
> > > +++ b/mm/page_owner.c
> > > @@ -10,6 +10,7 @@
> > >   #include <linux/migrate.h>
> > >   #include <linux/stackdepot.h>
> > >   #include <linux/seq_file.h>
> > > +#include <linux/memcontrol.h>
> > >   #include <linux/sched/clock.h>
> > >   #include "internal.h"
> > > @@ -325,6 +326,42 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
> > >   	seq_putc(m, '\n');
> > >   }
> > > +#ifdef CONFIG_MEMCG
> > > +/*
> > > + * Looking for memcg information and print it out
> > > + */
> > > +static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
> > > +					  struct page *page)
> > > +{
> > > +	unsigned long memcg_data = READ_ONCE(page->memcg_data);
> > > +	struct mem_cgroup *memcg;
> > > +	bool onlined;
> > > +	char name[80];
> > > +
> > > +	if (!memcg_data)
> > > +		return;
> > > +
> > > +	if (memcg_data & MEMCG_DATA_OBJCGS)
> > > +		*pret += scnprintf(kbuf + *pret, count - *pret,
> > > +				"Slab cache page\n");
> > Don't we need to check for overflow here?
> 
> See my previous patch 2 and the reason I used scnprintf() is that it never
> return a length that is >= the given size. So overflow won't happen. The
> final snprintf() in print_page_owner() will detect buffer overflow.
 
Right, I've missed that 
 
> > > +
> > > +	memcg = page_memcg_check(page);
> > > +	if (!memcg)
> > > +		return;
> > > +
> > > +	onlined = (memcg->css.flags & CSS_ONLINE);
> > > +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> > > +	*pret += scnprintf(kbuf + *pret, count - *pret,
> > > +			"Charged %sto %smemcg %s\n",
> > > +			PageMemcgKmem(page) ? "(via objcg) " : "",
> > > +			onlined ? "" : "offlined ",
> > > +			name);
> > Ditto
> > 
> > > +}
> > > +#else /* CONFIG_MEMCG */
> > > +static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
> > > +					  struct page *page) { }

> > I think #ifdef inside the print_page_owner_memcg() functions will be
> > simpler and clearer.
>
> Yes, I see both styles used in kernel code though this style is probably
> more common. I will keep this unless there is a good reason to do otherwise.

Having #ifdef inside the function is safer wrt future updates. It's often
happens that non-default arm of #ifdef is forgotten. Besides, it's several
lines less.
 
> > > +#endif /* CONFIG_MEMCG */
> > > +
> > >   static ssize_t
> > >   print_page_owner(char __user *buf, size_t count, unsigned long pfn,
> > >   		struct page *page, struct page_owner *page_owner,
> > > @@ -365,6 +402,8 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
> > >   			migrate_reason_names[page_owner->last_migrate_reason]);
> > >   	}
> > > +	print_page_owner_memcg(kbuf, count, &ret, page);
> > > +
> > ret can go over count here.
> > Why not make print_page_owner_memcg() an int so that the call will be
> > consistent with other calls in print_page_owner():
> > 
> > 	ret += print_page_owner_memcg(kbuf, count, page);
> > 	if (ret >= count)
> > 		goto err;

I still think that 'int print_page_owner_memcg()' is clearer and more
readable.
 
> See my comments above.
> 
> Cheers,
> Longman
> 

-- 
Sincerely yours,
Mike.
