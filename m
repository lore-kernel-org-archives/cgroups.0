From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Mon, 22 Aug 2022 08:06:14 -0700
Message-ID: <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <YwNZD4YlRkvQCWFi@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rfnLOnYHfibKVs6Fb4CyKhxW8tJzjkgGwDzJoC+bA0Y=;
        b=WrEDmTe0u3FiZugr1PESRLE48S+q7XVC3UauDjAcW6HIAjvR0HdyDSvY4Yh8Xv56pD
         zPk2pcgIpSUnoaMXQGMFXbv7itfEgQxASZu3plwAPK03XvXa6lCQJD9NZXVJ5o1FBtB8
         X3x7rF1QRsVh4MXlsOXYfj66zh30hHfyZ2JsCANksMqp18M7jGVX8W3hXJJrdalpRqiG
         suK5gjJfRKexqrQW/aKqFE+rYX7mOOZjjtfZCMzUoTVD8zZSvk9fiLVnIeZIGLgGzJaA
         dDSVJr3UUABWryrmO8Xl1VpIQ5ZWGOWL9XjGltxQGHICMF2l1LmnoW0euDwnBGjZS2e+
         1bmA==
In-Reply-To: <YwNZD4YlRkvQCWFi@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 3:23 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 22-08-22 00:17:36, Shakeel Butt wrote:
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
>
> Again the workload description is not particularly useful. I guess the
> only important aspect is the netserver part below and the number of CPUs
> because min and low setup doesn't have much to do with this, right? At
> least that is my reading of the memory.high mentioned above.
>

The experiment numbers below are for only this patch independently
i.e. the unnecessary min/low atomic xchg() is still happening for both
setups. I could run the experiment without setting min and low but I
wanted to keep the setup exactly the same for all three optimizations.

This patch and the following perf numbers shows only the impact of
removing false sharing in struct page_counter for memcg->memory on the
charging code path.

> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)     10482.7 Mbps
> > With patch            12413.7 Mbps (18.4% improvement)
> >
> > With the patch, the throughput improved by 18.4%.
> >
> > One side-effect of this patch is the increase in the size of struct
> > mem_cgroup. However for the performance improvement, this additional
> > size is worth it. In addition there are opportunities to reduce the size
> > of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> > and better packing.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > ---
> >  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index 679591301994..8ce99bde645f 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -3,15 +3,27 @@
> >  #define _LINUX_PAGE_COUNTER_H
> >
> >  #include <linux/atomic.h>
> > +#include <linux/cache.h>
> >  #include <linux/kernel.h>
> >  #include <asm/page.h>
> >
> > +#if defined(CONFIG_SMP)
> > +struct pc_padding {
> > +     char x[0];
> > +} ____cacheline_internodealigned_in_smp;
> > +#define PC_PADDING(name)     struct pc_padding name
> > +#else
> > +#define PC_PADDING(name)
> > +#endif
> > +
> >  struct page_counter {
> > +     /*
> > +      * Make sure 'usage' does not share cacheline with any other field. The
> > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > +      */
> > +     PC_PADDING(_pad1_);
>
> Why don't you simply require alignment for the structure?

I don't just want the alignment of the structure. I want different
fields of this structure to not share the cache line. More
specifically the 'high' and 'usage' fields. With this change the usage
will be its own cache line, the read-most fields will be on separate
cache line and the fields which sometimes get updated on charge path
based on some condition will be a different cache line from the
previous two.
