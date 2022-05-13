From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Fri, 13 May 2022 14:25:59 -0400
Message-ID: <Yn6it9mBYFA+/lTb@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <CALvZod6kBZZFfD6Y5p_=9TMJr8P-vU_77NTq048wGUDr0wTv0Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fyTxG3vRPARLhAf2qwVdCK49by1iieFxjF3cm5H3kbg=;
        b=JN3vj/2/8eGEf9jiKkowI0XVrGpXh8SmRzFgsk3cdXlm6iRbR2zHXSlqm7aVNKj5ip
         zRDvFrQoFa3ZGfJU/v27uSO46gcedrSzWA1QdKNyP+pqmtkiQHzBwrkMDhpHLZ2Q68nP
         eZmv53ao/AgNQl4ZAdnFDcyxN1m11o4n0aR+xe7kSH94tVk0bdh1exS8tTa4PEEUDw5P
         exI6qZJVYSBcNsQdwkmtJkbJN+PL+oWOB+FV+5kvv1zz/Y5spi8/Wesyu+oSFQvk5BmD
         HU2/HgYUYAaOc5eaYt2uzGw26qXin4klfvORGjmaOgcqpzkhKnKwdiz5Ola03AlxvH34
         wIMw==
Content-Disposition: inline
In-Reply-To: <CALvZod6kBZZFfD6Y5p_=9TMJr8P-vU_77NTq048wGUDr0wTv0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

Hello Shakeel,

On Fri, May 13, 2022 at 10:23:36AM -0700, Shakeel Butt wrote:
> On Tue, May 10, 2022 at 8:29 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> [...]
> > +void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> > +{
> > +       struct mem_cgroup *memcg;
> > +
> > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > +
> > +       /* PF_MEMALLOC context, charging must succeed */
> )
> Instead of these warnings and comment why not just explicitly use
> memalloc_noreclaim_[save|restore]() ?

Should the function be called from a non-reclaim context, it should
warn rather than quietly turn itself into a reclaimer. That's not a
very likely mistake, but the warning documents the expectations and
context of this function better.

> > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> 
> Can we please make this specific charging an opt-in feature or at
> least provide a way to opt-out? This will impact users/providers where
> swap is used transparently (in terms of memory usage). Also do you
> want this change for v1 users as well?

Ah, of course, memsw! Let's opt out of v1, since this is clearly in
conflict with that way of accounting. I already hadn't added interface
files for v1, so it's just a matter of bypassing the charging too.

Signed-of-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 350012b93a95..3ab72b8160ee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7469,6 +7469,9 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 	struct mem_cgroup *memcg, *original_memcg;
 	bool ret = true;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return true;
+
 	original_memcg = get_mem_cgroup_from_objcg(objcg);
 	for (memcg = original_memcg; memcg != root_mem_cgroup;
 	     memcg = parent_mem_cgroup(memcg)) {
@@ -7505,6 +7508,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 {
 	struct mem_cgroup *memcg;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -7529,6 +7535,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 {
 	struct mem_cgroup *memcg;
 
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();

