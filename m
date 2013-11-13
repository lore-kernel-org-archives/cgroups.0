From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC] memcg: fix race between css_offline and async charge (was: Re:
 Possible regression with cgroups in 3.11)
Date: Wed, 13 Nov 2013 14:23:37 +0100
Message-ID: <20131113132337.GB22131@dhcp22.suse.cz>
References: <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131111153148.GC14497@dhcp22.suse.cz>
 <20131112145824.GC6049@dhcp22.suse.cz>
 <20131113033840.GC19394@mtj.dyndns.org>
 <20131113110108.GA22131@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131113110108.GA22131-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes, what do you think about something like this?
I have just compile tested it.
--- 
From 73042adc905847bfe401ae12073d1c479db8fdab Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 13 Nov 2013 13:53:54 +0100
Subject: [PATCH] memcg: fix race between css_offline and async charge

As correctly pointed out by Johannes, charges done on behalf of a group
where the current task is not its member (swap accounting currently) are
racy wrt. memcg offlining (mem_cgroup_css_offline).

This might lead to a charge leak as follows:

                           rcu_read_lock()
                           css_tryget()
                           rcu_read_unlock()
disable tryget()
call_rcu()
  offline_css()
    reparent_charges()
                           res_counter_charge()
                           css_put()
                             css_free()
                           pc->mem_cgroup = deadcg
                           add page to lru

If a group has a parent then the parent's res_counter would have a
charge which doesn't have any corresponding page on any reachable LRUs
under its hierarchy and so it won't be able to free/reparent its own
charges when going away and end up looping in reparent_charges for ever.

This patch fixes the issue by introducing memcg->offline flag which is
set when memcg is offlined (and the memcg is not reachable anymore).

The only async charger we have currently (swapin accounting path) checks
the offline status after successful charge and uncharges and falls back
to charge the current task if the group is offline now.

Spotted-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1fded477ef6..c75c7244d96d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -312,6 +312,7 @@ struct mem_cgroup {
 	spinlock_t pcp_counter_lock;
 
 	atomic_t	dead_count;
+	bool		offline;
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
@@ -3794,6 +3795,24 @@ void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
 	preempt_enable();
 }
 
+/*
+ * memcg is marked offline before it reparents its charges
+ * and any async charger has to recheck mem_cgroup_is_offline
+ * after successful charge to make sure that the memcg hasn't
+ * go offline in the meantime.
+ */
+static void mem_cgroup_mark_offline(struct mem_cgroup *memcg)
+{
+	memcg->offline = true;
+	smp_wmb();
+}
+
+static bool mem_cgroup_is_offline(struct mem_cgroup *memcg)
+{
+	smp_rmb();
+	return memcg->offline;
+}
+
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
@@ -4006,6 +4025,24 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		goto charge_cur_mm;
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
+
+	/*
+	 * try_get_mem_cgroup_from_page and the actual charge are not
+	 * done in the same RCU read section which means that the memcg
+	 * might get offlined before res counter is charged so we have
+	 * to recheck the memcg status again here and revert that charge
+	 * as we cannot be sure it was accounted properly.
+	 */
+	if (!ret) {
+		if (mem_cgroup_is_offline(memcg)) {
+			__mem_cgroup_cancel_charge(memcg, 1);
+			/* from try_get_mem_cgroup_from_page */
+			css_put(&memcg->css);
+			*memcgp = NULL;
+			goto charge_cur_mm;
+		}
+	}
+
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		ret = 0;
@@ -6342,6 +6379,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	kmem_cgroup_css_offline(memcg);
 
+	mem_cgroup_mark_offline(memcg);
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
