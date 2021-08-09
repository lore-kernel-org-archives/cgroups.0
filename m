From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Mon, 9 Aug 2021 11:07:06 +0200
Message-ID: <YRDwOhVglJmY7ES5@dhcp22.suse.cz>
References: <20210803175519.22298-1-longman@redhat.com>
 <87h7g62jxm.ffs@tglx>
 <93dfe0d4-c687-93f8-da75-c5d3c9bd0ac7@suse.cz>
 <YQpQ43VrlqsOhXKd@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1628500027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k5Y8l9w4iV5g6s1wFPPe9+DoJPU9/n1zkxnjff8sD0o=;
        b=BQmjr/B2oyVTVghvc5m6dVwkO+BrUfwt0cxBRJgtmey8Sgnq/GQJUs+Q5OrHBPEvBmCeCI
        AwoTYEPdyrMTyiEoKQElxN92XreBQd0dt83EhIojbcH4qfHTZWd8F43D6wC0Unk7mMWK1c
        QPDou1k2Zx0ABJ5JBhN2QKXgwJw1vOA=
Content-Disposition: inline
In-Reply-To: <YQpQ43VrlqsOhXKd-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed 04-08-21 10:33:41, Michal Hocko wrote:
> On Wed 04-08-21 09:39:23, Vlastimil Babka wrote:
> > On 8/4/21 1:21 AM, Thomas Gleixner wrote:
> > > 	/*
> > > 	 * The only protection from memory hotplug vs. drain_stock races is
> > > 	 * that we always operate on local CPU stock here with IRQ disabled
> > > 	 */
> > > -	local_irq_save(flags);
> > > +	local_lock_irqsave(memcg_stock_lock, flags);
> > >         ...
> > > 	if (use_task_obj_stock())
> > >   		drain_obj_stock(&stock->task_obj);
> > > 
> > > which is incomprehensible garbage.
> > > 
> > > The comment above the existing local_irq_save() is garbage w/o any local
> > > lock conversion already today (and even before the commit which
> > > introduced stock::task_obj) simply because that comment does not explain
> > > the why.
> > 
> > Michal, this seems to be your comment from commit 72f0184c8a00 ("mm, memcg:
> > remove hotplug locking from try_charge"). Was "memory hotplug" a mistake,
> > because the rest of the commit is about cpu hotplug, and I don't really see a
> > memory hotplug connection there?
> 
> This part of the changelog tried to explain that part IIRC
> "
>     We can get rid of {get,put}_online_cpus, fortunately.  We do not have to
>     be worried about races with memory hotplug because drain_local_stock,
>     which is called from both the WQ draining and the memory hotplug
>     contexts, is always operating on the local cpu stock with IRQs disabled.
> "
> 
> Now I have to admit I do not remember all the details and from a quick
> look the memory hotplug doesn't seem to be draining memcg pcp stock.
> Maybe this has been removed since then. The only stock draining outside
> of the memcg code seems to be memcg_hotplug_cpu_dead callback. That
> would indicate that I really meant the cpu hotplug here indeed.

Does this look better?
---

From 5aa1c8ce0d88b8c6d59ba95c7e36ca07dc2b2161 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Mon, 9 Aug 2021 10:59:04 +0200
Subject: [PATCH] memcg: fix up drain_local_stock comment

Thomas and Vlastimil have noticed that the comment in drain_local_stock
doesn't quite make sense. It talks about a synchronization with the
memory hotplug but there is no actual memory hotplug involvement here.
I meant to talk about cpu hotplug here. Fix that up and hopefuly make
the comment more helpful by referencing the cpu hotplug callback as
well.

Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb8e87c4833f..f7be7b01395e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2205,8 +2205,9 @@ static void drain_local_stock(struct work_struct *dummy)
 	unsigned long flags;
 
 	/*
-	 * The only protection from memory hotplug vs. drain_stock races is
-	 * that we always operate on local CPU stock here with IRQ disabled
+	 * The only protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
+	 * drain_stock races is that we always operate on local CPU stock
+	 * here with IRQ disabled
 	 */
 	local_irq_save(flags);
 
-- 
2.30.1

-- 
Michal Hocko
SUSE Labs
