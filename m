From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Thu, 1 Dec 2022 20:32:53 -0800
Message-ID: <CAHS8izMe+_V5F4nNQAAGmjc7N5T-YP7f9Kb5T0qe4aUWFmQ_tA@mail.gmail.com>
References: <20221130020328.1009347-1-almasrymina@google.com> <878rjq32rr.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BsPgWVv1RWT5qYX/bABkuIpT4gW3nAMII43+pjAqwPI=;
        b=WOBSqpfGr1BpEGTu+3IgFmv1HYfDcMH2yThHtySw/i+6o/W3cgtYc+oPSeq2g+6SLp
         FYjkAznLrzEWuYDau3m+pLHUUyaic8mXryvdKzOX2Pj3qTsuzhD5PH9koCYHrkDd8HOh
         sAmPuFF/fKZl/rczWrK3C5T3YjZvKk2wOyTpLa3L+ULbTnfLf8+b/KWWfV8lAhUwFmgG
         9NJfqF3IqZdnSX3cfg6f1vbDOX2s9G+rk40gqXh7DDXlYlbdnj/+rCjeWN9TH4PPumNI
         kIpHwMdydVz6BYWHRdl4bjT56stk7pQPsTruFT7CLKtJIq9iM28j8UH9pOs9G3Vi1Bcu
         D62Q==
In-Reply-To: <878rjq32rr.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Dec 1, 2022 at 7:26 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > The nodes= arg instructs the kernel to only scan the given nodes for
> > proactive reclaim. For example use cases, consider a 2 tier memory system:
> >
> > nodes 0,1 -> top tier
> > nodes 2,3 -> second tier
> >
> > $ echo "1m nodes=0" > memory.reclaim
> >
> > This instructs the kernel to attempt to reclaim 1m memory from node 0.
> > Since node 0 is a top tier node, demotion will be attempted first. This
> > is useful to direct proactive reclaim to specific nodes that are under
> > pressure.
> >
> > $ echo "1m nodes=2,3" > memory.reclaim
> >
> > This instructs the kernel to attempt to reclaim 1m memory in the second tier,
> > since this tier of memory has no demotion targets the memory will be
> > reclaimed.
> >
> > $ echo "1m nodes=0,1" > memory.reclaim
> >
> > Instructs the kernel to reclaim memory from the top tier nodes, which can
> > be desirable according to the userspace policy if there is pressure on
> > the top tiers. Since these nodes have demotion targets, the kernel will
> > attempt demotion first.
> >
> > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> > reclaim""), the proactive reclaim interface memory.reclaim does both
> > reclaim and demotion. Reclaim and demotion incur different latency costs
> > to the jobs in the cgroup. Demoted memory would still be addressable
> > by the userspace at a higher latency, but reclaimed memory would need to
> > incur a pagefault.
> >
> > The 'nodes' arg is useful to allow the userspace to control demotion
> > and reclaim independently according to its policy: if the memory.reclaim
> > is called on a node with demotion targets, it will attempt demotion first;
> > if it is called on a node without demotion targets, it will only attempt
> > reclaim.
> >
> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 15 +++---
> >  include/linux/swap.h                    |  3 +-
> >  mm/memcontrol.c                         | 67 ++++++++++++++++++++-----
> >  mm/vmscan.c                             |  4 +-
> >  4 files changed, 68 insertions(+), 21 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 74cec76be9f2..ac5fcbcd5ae6 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1245,17 +1245,13 @@ PAGE_SIZE multiple when read back.
> >       This is a simple interface to trigger memory reclaim in the
> >       target cgroup.
> >
> > -     This file accepts a single key, the number of bytes to reclaim.
> > -     No nested keys are currently supported.
> > +     This file accepts a string which contains the number of bytes to
> > +     reclaim.
> >
> >       Example::
> >
> >         echo "1G" > memory.reclaim
> >
> > -     The interface can be later extended with nested keys to
> > -     configure the reclaim behavior. For example, specify the
> > -     type of memory to reclaim from (anon, file, ..).
> > -
> >       Please note that the kernel can over or under reclaim from
> >       the target cgroup. If less bytes are reclaimed than the
> >       specified amount, -EAGAIN is returned.
> > @@ -1267,6 +1263,13 @@ PAGE_SIZE multiple when read back.
> >       This means that the networking layer will not adapt based on
> >       reclaim induced by memory.reclaim.
> >
> > +     This file also allows the user to specify the nodes to reclaim from,
> > +     via the 'nodes=' key, example::
> > +
> > +       echo "1G nodes=0,1" > memory.reclaim
> > +
> > +     The above instructs the kernel to reclaim memory from nodes 0,1.
> > +
> >    memory.peak
> >       A read-only single value file which exists on non-root
> >       cgroups.
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index b61e2007d156..f542c114dffd 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -419,7 +419,8 @@ extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> >  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >                                                 unsigned long nr_pages,
> >                                                 gfp_t gfp_mask,
> > -                                               unsigned int reclaim_options);
> > +                                               unsigned int reclaim_options,
> > +                                               nodemask_t nodemask);
> >  extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
> >                                               gfp_t gfp_mask, bool noswap,
> >                                               pg_data_t *pgdat,
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 23750cec0036..a0d7850173a9 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -63,6 +63,7 @@
> >  #include <linux/resume_user_mode.h>
> >  #include <linux/psi.h>
> >  #include <linux/seq_buf.h>
> > +#include <linux/parser.h>
> >  #include "internal.h"
> >  #include <net/sock.h>
> >  #include <net/ip.h>
> > @@ -2392,7 +2393,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >               psi_memstall_enter(&pflags);
> >               nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> >                                                       gfp_mask,
> > -                                                     MEMCG_RECLAIM_MAY_SWAP);
> > +                                                     MEMCG_RECLAIM_MAY_SWAP,
> > +                                                     NODE_MASK_ALL);
> >               psi_memstall_leave(&pflags);
> >       } while ((memcg = parent_mem_cgroup(memcg)) &&
> >                !mem_cgroup_is_root(memcg));
> > @@ -2683,7 +2685,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >
> >       psi_memstall_enter(&pflags);
> >       nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> > -                                                 gfp_mask, reclaim_options);
> > +                                                 gfp_mask, reclaim_options,
> > +                                                 NODE_MASK_ALL);
> >       psi_memstall_leave(&pflags);
> >
> >       if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> > @@ -3503,7 +3506,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
> >               }
> >
> >               if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -                                     memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
> > +                                     memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
> > +                                     NODE_MASK_ALL)) {
> >                       ret = -EBUSY;
> >                       break;
> >               }
> > @@ -3614,7 +3618,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
> >                       return -EINTR;
> >
> >               if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -                                               MEMCG_RECLAIM_MAY_SWAP))
> > +                                               MEMCG_RECLAIM_MAY_SWAP,
> > +                                               NODE_MASK_ALL))
> >                       nr_retries--;
> >       }
> >
> > @@ -6407,7 +6412,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >               }
> >
> >               reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > -                                     GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
> > +                                     GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +                                     NODE_MASK_ALL);
> >
> >               if (!reclaimed && !nr_retries--)
> >                       break;
> > @@ -6456,7 +6462,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> >
> >               if (nr_reclaims) {
> >                       if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
> > -                                     GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
> > +                                     GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +                                     NODE_MASK_ALL))
> >                               nr_reclaims--;
> >                       continue;
> >               }
> > @@ -6579,21 +6586,54 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
> >       return nbytes;
> >  }
> >
> > +enum {
> > +     MEMORY_RECLAIM_NODES = 0,
> > +     MEMORY_RECLAIM_NULL,
> > +};
> > +
> > +static const match_table_t if_tokens = {
> > +     { MEMORY_RECLAIM_NODES, "nodes=%s" },
> > +     { MEMORY_RECLAIM_NULL, NULL },
> > +};
> > +
> >  static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> >                             size_t nbytes, loff_t off)
> >  {
> >       struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> >       unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> >       unsigned long nr_to_reclaim, nr_reclaimed = 0;
> > -     unsigned int reclaim_options;
> > -     int err;
> > +     unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
> > +                                    MEMCG_RECLAIM_PROACTIVE;
> > +     char *old_buf, *start;
> > +     substring_t args[MAX_OPT_ARGS];
> > +     int token;
> > +     char value[256];
> > +     nodemask_t nodemask = NODE_MASK_ALL;
> >
> >       buf = strstrip(buf);
> > -     err = page_counter_memparse(buf, "", &nr_to_reclaim);
> > -     if (err)
> > -             return err;
> >
> > -     reclaim_options = MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
> > +     old_buf = buf;
> > +     nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
> > +     if (buf == old_buf)
> > +             return -EINVAL;
> > +
> > +     buf = strstrip(buf);
> > +
> > +     while ((start = strsep(&buf, " ")) != NULL) {
> > +             if (!strlen(start))
> > +                     continue;
> > +             token = match_token(start, if_tokens, args);
> > +             match_strlcpy(value, args, sizeof(value));
>
> Per my understanding, we don't need to copy the string, because strsep()
> has replaced " " with "\0".  Right?
>

Unless I'm missing something I don't think this has anything to do
with strsep(). `args` is not a null terminated string that can be
passed to nodelist_parse(). Instead it is a struct substring_t that
has args->to and args->from. To convert substring_t args to a null
terminated string, I call match_strlcpy(). I think this is a common
pattern doen in a few places.

I think args->to may point to '\0' because of how strsep() and
match_token() work internally, but I'm somewhat uncomfortable making
assumptions about the implementation of these functions here (it may
change in the future and break the assumption).

> Best Regards,
> Huang, Ying
>
> > +             switch (token) {
> > +             case MEMORY_RECLAIM_NODES:
> > +                     if (nodelist_parse(value, nodemask) < 0)
> > +                             return -EINVAL;
> > +                     break;
> > +             default:
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> >       while (nr_reclaimed < nr_to_reclaim) {
> >               unsigned long reclaimed;
> >
> > @@ -6610,7 +6650,8 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> >
> >               reclaimed = try_to_free_mem_cgroup_pages(memcg,
> >                                               nr_to_reclaim - nr_reclaimed,
> > -                                             GFP_KERNEL, reclaim_options);
> > +                                             GFP_KERNEL, reclaim_options,
> > +                                             nodemask);
> >
> >               if (!reclaimed && !nr_retries--)
> >                       return -EAGAIN;
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7b8e8e43806b..23fc5b523764 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6735,7 +6735,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> >  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >                                          unsigned long nr_pages,
> >                                          gfp_t gfp_mask,
> > -                                        unsigned int reclaim_options)
> > +                                        unsigned int reclaim_options,
> > +                                        nodemask_t nodemask)
> >  {
> >       unsigned long nr_reclaimed;
> >       unsigned int noreclaim_flag;
> > @@ -6750,6 +6751,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >               .may_unmap = 1,
> >               .may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
> >               .proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
> > +             .nodemask = &nodemask,
> >       };
> >       /*
> >        * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
> > --
> > 2.38.1.584.g0f3c55d4c2-goog
>
