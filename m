From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 2/2] mm/page_owner: Dump memcg information
Date: Fri, 28 Jan 2022 13:48:43 -0800
Message-ID: <20220128214843.GJ785175@iweiny-DESK2.sc.intel.com>
References: <20220128195642.416743-1-longman@redhat.com>
 <20220128195642.416743-3-longman@redhat.com>
 <20220128212249.GI785175@iweiny-DESK2.sc.intel.com>
 <e14e8c96-b2e3-cb57-2c35-284116798225@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643406524; x=1674942524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c3DfHy4UfybaUGWpZe7ypxB5nT4Kqu/2JshXAhBJsV8=;
  b=HrDrs84centBUNzyaRIZGRsBkeuygfZ5e5K1odfzgEk8FV3bVrnNzb1t
   rSgufc4gAo9y270xnsiZ43vfJWnFTspJU9LYXuuMnPhcE2SLbSISSOGMV
   LaUTN1c0BiNB4vZ5YJ2clvvRY3n/vBTTVffuGv+DzodxZqBYbl1jJi9dD
   9k9bXAdrg0J6TSy6aOKvpTPSGeVKBmKe+E3h/W6Sb/rJ762t5H3+elvF+
   HukCx4U5UXorcEYC6NU1dDHyxXD0/khSvJd+hjesPd8fd51CQ4/hVfKDd
   2FW/iLWp0w2unpvXh4nXF9epoon1hHJaQYszT7EcppPp3HlXR6dt2Ofpr
   g==;
Content-Disposition: inline
In-Reply-To: <e14e8c96-b2e3-cb57-2c35-284116798225@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>

On Fri, Jan 28, 2022 at 04:31:07PM -0500, Waiman Long wrote:
> On 1/28/22 16:22, Ira Weiny wrote:
> > On Fri, Jan 28, 2022 at 02:56:42PM -0500, Waiman Long wrote:
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
> > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > ---
> > >   mm/page_owner.c | 28 ++++++++++++++++++++++++++++
> > >   1 file changed, 28 insertions(+)
> > > 
> > > diff --git a/mm/page_owner.c b/mm/page_owner.c
> > > index c52ce9d6bc3b..e5d8c642296b 100644
> > > --- a/mm/page_owner.c
> > > +++ b/mm/page_owner.c
> > > @@ -10,6 +10,7 @@
> > >   #include <linux/migrate.h>
> > >   #include <linux/stackdepot.h>
> > >   #include <linux/seq_file.h>
> > > +#include <linux/memcontrol.h>
> > >   #include <linux/sched/clock.h>
> > >   #include "internal.h"
> > > @@ -339,6 +340,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
> > >   		depot_stack_handle_t handle)
> > >   {
> > >   	int ret = 0, pageblock_mt, page_mt;
> > > +	unsigned long __maybe_unused memcg_data;
> > >   	char *kbuf;
> > >   	count = min_t(size_t, count, PAGE_SIZE);
> > > @@ -371,6 +373,32 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
> > >   			"Page has been migrated, last migrate reason: %s\n",
> > >   			migrate_reason_names[page_owner->last_migrate_reason]);
> > > +#ifdef CONFIG_MEMCG
> > > +	/*
> > > +	 * Look for memcg information and print it out
> > > +	 */
> > > +	memcg_data = READ_ONCE(page->memcg_data);
> > > +	if (memcg_data) {
> > > +		struct mem_cgroup *memcg = page_memcg_check(page);
> > > +		bool onlined;
> > > +		char name[80];
> > > +
> > > +		if (memcg_data & MEMCG_DATA_OBJCGS)
> > > +			SNPRINTF(kbuf, count, ret, err, "Slab cache page\n");
> > > +
> > > +		if (!memcg)
> > > +			goto copy_out;
> > > +
> > > +		onlined = (memcg->css.flags & CSS_ONLINE);
> > > +		cgroup_name(memcg->css.cgroup, name, sizeof(name) - 1);
> > > +		SNPRINTF(kbuf, count, ret, err, "Charged %sto %smemcg %s\n",
> >                                                          ^^^
> > 						Extra specifier?
> > 
> > Did this compile without warnings?
> 
> Yes, there was no warning.

But isn't that an extra specifier?

Ira

> 
> Cheers,
> Longmna
> 
> > Ira
> > 
> > > +			PageMemcgKmem(page) ? "(via objcg) " : "",
> > > +			onlined ? "" : "offlined ", name);
> > > +	}
> > > +
> > > +copy_out:
> > > +#endif
> > > +
> > >   	SNPRINTF(kbuf, count, ret, err, "\n");
> > >   	if (copy_to_user(buf, kbuf, ret))
> > > -- 
> > > 2.27.0
> > > 
> > > 
> 
