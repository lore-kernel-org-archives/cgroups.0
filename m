From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Thu, 7 Nov 2013 19:14:37 -0500
Message-ID: <20131108001437.GC1092@cmpxchg.org>
References: <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=uN+8fsSVG6OBRoN4ylfVLSreGQdwXASzy6lZwnDRtvc=;
	b=f4mHiefMd4QrJBSaYP+RLmORnMfT2O9ADmiE2jf6bgUaDDr8l0yPbmJnHrW5zj0MdTImTHRNNd/zQsStz6b9VhnAF8Puj0dg2i6XXybBUQ1Vvk1PvYU22RRr0wyQ62+/w6LemRpFVFhghFUoFQeEoQlHMCFpOUoc/xbq7VNeq6c=;
Content-Disposition: inline
In-Reply-To: <20131107235301.GB1092-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 07, 2013 at 06:53:01PM -0500, Johannes Weiner wrote:
> On Tue, Nov 05, 2013 at 05:01:37PM +0800, Li Zefan wrote:
> > On 2013/11/4 21:43, Markus Blank-Burian wrote:
> > >> synchronize_rcu() is a block operation and can keep us waiting for
> > >> a long period, so instead it's possible that usage never goes down
> > >> to 0 and we are in a dead loop.
> > > 
> > > Ok, I didn't think of that. Tracing shows that the function keeps
> > > looping. The last lines repeat indefinitely.
> > > 
> > ...
> > >      kworker/3:5-7605  [003] ....   987.475678:
> > > mem_cgroup_reparent_charges: usage: 1568768
> > >      kworker/3:5-7605  [003] ....   987.478677:
> > > mem_cgroup_reparent_charges: usage: 1568768
> > >      kworker/3:5-7605  [003] ....   987.481675:
> > > mem_cgroup_reparent_charges: usage: 1568768
> > 
> > So it's much more likely this is a memcg bug rather than a cgroup bug.
> > I hope memcg guys could look into it, or you could do a git-bisect if
> > you can reliably reproduce the bug.
> 
> I think there is a problem with ref counting and memcg.
> 
> The old scheme would wait with the charge reparenting until all
> references were gone for good, whereas the new scheme has only a RCU
> grace period between disabling tryget and offlining the css.
> Unfortunately, memory cgroups don't hold the rcu_read_lock() over both
> the tryget and the res_counter charge that would make it visible to
> offline_css(), which means that there is a possible race condition
> between cgroup teardown and an ongoing charge:
> 
> #0: destroy                #1: charge
> 
>                            rcu_read_lock()
>                            css_tryget()
>                            rcu_read_unlock()
> disable tryget()
> call_rcu()
>   offline_css()
>     reparent_charges()
>                            res_counter_charge()
>                            css_put()
>                              css_free()
>                            pc->mem_cgroup = deadcg
>                            add page to lru
> 
> If the res_counter is hierarchical, there is now a leaked charge from
> the dead group in the parent counter with no corresponding page on the
> LRU, which will lead to this endless loop when deleting the parent.

Hugh, I bet your problem is actually the same thing, where
reparent_charges is looping and the workqueue is not actually stuck,
it's just that waiting for the CPU callbacks is the longest thing the
loop does so it's most likely to show up in the trace.

> The race window can be seconds if the res_counter hits its limit and
> page reclaim is entered between css_tryget() and the res counter
> charge succeeding.
> 
> I thought about calling reparent_charges() again from css_free() at
> first to catch any raced charges.  But that won't work if the last
> reference is actually put by the charger because then it'll drop into
> the loop before putting the page on the LRU.

Actually, it *should* work after all, because the final css_put()
schedules css_free() in a workqueue, which will just block until the
charge finishes and lru-links the page.  Not the most elegant
behavior, but hey, neither is livelocking!

So how about this?

---
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcg: reparent charges during css_free()

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # 3.8+
---
 mm/memcontrol.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cc4f9cbe760e..3dce2b50891c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6341,7 +6341,34 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-
+	/*
+	 * XXX: css_offline() would be where we should reparent all
+	 * memory to prepare the cgroup for destruction.  However,
+	 * memcg does not do css_tryget() and res_counter charging
+	 * under the same RCU lock region, which means that charging
+	 * could race with offlining, potentially leaking charges and
+	 * sending out pages with stale cgroup pointers:
+	 *
+	 * #0                        #1
+	 *                           rcu_read_lock()
+	 *                           css_tryget()
+	 *                           rcu_read_unlock()
+	 * disable css_tryget()
+	 * call_rcu()
+	 *   offline_css()
+	 *     reparent_charges()
+	 *                           res_counter_charge()
+	 *                           css_put()
+	 *                             css_free()
+	 *                           pc->mem_cgroup = dead memcg
+	 *                           add page to lru
+	 *
+	 * We still reparent most charges in offline_css() simply
+	 * because we don't want all these pages stuck if a long-term
+	 * reference like a swap entry is holding on to the cgroup
+	 * past offlining, but make sure we catch any raced charges:
+	 */
+	mem_cgroup_reparent_charges(memcg);
 	memcg_destroy_kmem(memcg);
 	__mem_cgroup_free(memcg);
 }
-- 
1.8.4.2
