From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: Remove duplicate inclusion of sock.h
 file
Date: Fri, 14 Sep 2012 10:27:41 +0200
Message-ID: <20120914082741.GC28039@dhcp22.suse.cz>
References: <1347350934-17712-1-git-send-email-sachin.kamat@linaro.org>
 <20120911095200.GB8058@dhcp22.suse.cz>
 <20120912072520.GB17516@dhcp22.suse.cz>
 <50504CE1.8030509@parallels.com>
 <20120912125647.GH21579@dhcp22.suse.cz>
 <20120912130935.GJ21579@dhcp22.suse.cz>
 <CAK9yfHwMnC65BvY3RG7duf_Cmt5hf1VLV=vZRag4Mm6nHdQ-GA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAK9yfHwMnC65BvY3RG7duf_Cmt5hf1VLV=vZRag4Mm6nHdQ-GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri 14-09-12 13:28:07, Sachin Kamat wrote:
> Hi Michal,
> 
> Has this patch been accepted?

Not yet. I am waiting for Glauber to ack it.

> 
> On 12 September 2012 18:39, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Wed 12-09-12 14:56:47, Michal Hocko wrote:
> >> On Wed 12-09-12 12:50:41, Glauber Costa wrote:
> >> [...]
> >> > >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> > >> index 795e525..85ec9ff 100644
> >> > >> --- a/mm/memcontrol.c
> >> > >> +++ b/mm/memcontrol.c
> >> > >> @@ -50,8 +50,12 @@
> >> > >>  #include <linux/cpu.h>
> >> > >>  #include <linux/oom.h>
> >> > >>  #include "internal.h"
> >> > >> +
> >> > >> +#ifdef CONFIG_MEMCG_KMEM
> >> > >>  #include <net/sock.h>
> >> > >> +#include <net/ip.h>
> >> > >>  #include <net/tcp_memcontrol.h>
> >> > >> +#endif
> >> > >>
> >> > >>  #include <asm/uaccess.h>
> >> > >>
> >> > >> @@ -326,7 +330,7 @@ struct mem_cgroup {
> >> > >>          struct mem_cgroup_stat_cpu nocpu_base;
> >> > >>          spinlock_t pcp_counter_lock;
> >> > >>
> >> > >> -#ifdef CONFIG_INET
> >> > >> +#ifdef CONFIG_MEMCG_KMEM
> >> > >>          struct tcp_memcontrol tcp_mem;
> >> > >>  #endif
> >> > >>  };
> >> >
> >> > If you are changing this, why not test for both? This field will be
> >> > useless with inet disabled. I usually don't like conditional in
> >> > structures (note that the "kmem" res counter in my patchsets is not
> >> > conditional to KMEM!!), but since the decision was made to make this one
> >> > conditional, I think INET is a much better test. I am fine with both though.
> >>
> >>  You are right of course. Updated patch bellow:
> >
> > Bahh. And I managed to send a different patch than I tested...
> > ---
> > From 0617ff7114bdf424160a8f1533784c837d426ec2 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > Date: Tue, 11 Sep 2012 10:38:42 +0200
> > Subject: [PATCH] memcg: clean up networking headers file inclusion
> >
> > Memory controller doesn't need anything from the networking stack unless
> > CONFIG_MEMCG_KMEM is selected.
> > Now we are including net/sock.h and net/tcp_memcontrol.h unconditionally
> > which is not necessary. Moreover struct mem_cgroup contains tcp_mem even
> > if CONFIG_MEMCG_KMEM is not selected which is not necessary.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > ---
> >  mm/memcontrol.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 795e525..1a217b4 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -50,8 +50,12 @@
> >  #include <linux/cpu.h>
> >  #include <linux/oom.h>
> >  #include "internal.h"
> > +
> > +#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
> >  #include <net/sock.h>
> > +#include <net/ip.h>
> >  #include <net/tcp_memcontrol.h>
> > +#endif
> >
> >  #include <asm/uaccess.h>
> >
> > @@ -326,7 +330,7 @@ struct mem_cgroup {
> >         struct mem_cgroup_stat_cpu nocpu_base;
> >         spinlock_t pcp_counter_lock;
> >
> > -#ifdef CONFIG_INET
> > +#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
> >         struct tcp_memcontrol tcp_mem;
> >  #endif
> >  };
> > @@ -413,8 +417,6 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
> >
> >  /* Writing them here to avoid exposing memcg's inner layout */
> >  #ifdef CONFIG_MEMCG_KMEM
> > -#include <net/sock.h>
> > -#include <net/ip.h>
> >
> >  static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
> >  void sock_update_memcg(struct sock *sk)
> > --
> > 1.7.10.4
> >
> > --
> > Michal Hocko
> > SUSE Labs
> 
> 
> 
> -- 
> With warm regards,
> Sachin

-- 
Michal Hocko
SUSE Labs
