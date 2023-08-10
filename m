From: Zachary Goldstein via B4 Relay 
        <devnull+zachary.goldstein.concurrent-rt.com-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH RT] mm/memcg: Fix recursive locking on refill_stock() on
 PREEMPT_RT
Date: Thu, 10 Aug 2023 15:05:34 -0400
Message-ID: <20230809-memcg-fix-recursive-lock-v1-1-0870815484c6@concurrent-rt.com>
Reply-To: <zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691694540;
        bh=Oi7cQ2Coc+w2eRImA7LKy7Tv7W4x0/pEx/hFmFxWWY4=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=jqUWcBesFjkeEEvNGvxmlBPgNV4l5kJJXzmwfZUtOO2h7Voaq2+KUwxqFgxxHUcIM
         OlX2P3gLDwOE4uwawibqQ1rWZRs6iWRY0qLThpoMY17NXhd6oLQ8A+4nf/sTQCCpYY
         OG/fpZvT7WHqDau8s0CrZT2PpZfG8OAcrHrAF5H96tS8cll2RR75tiRPZFBOtEhhyV
         HwPpB4V8YNIRU9OiKa5JP25ZtWWsAMoqsuqYkvGD4JTKTib4E+7t8EOJ1exYMi3O+3
         XLclUcu42FDLf/MDaZqp7UqYNIlDSJpI986sFQ3D3M0crLBrawi3SCuWZlpIU1A7mx
         lhWja/BCfbIdQ==
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691694539; l=3174;
 i=zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org; s=20230809; h=from:subject:message-id;
 bh=iGCY5O8pU90PvwzpSq10zAF0Xf00Oq3bpeBOxq/cAek=;
 b=0aJq6ecGEBSIY9wfC7XKUKq9WBhQh5kGwH74a64bwReInzEPOAdFARO74YqaxHYeNuO34f2AC
 CjAntrJQVhPBUN9HNANwJ+l3vOvu1T13Y/zZGi+XgFi0NP+BRcVYOjS
X-Developer-Key: i=zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org; a=ed25519;
 pk=GLF18lQ96tRolyWMpDtJzDQ9bi7+1+rMHript5TFdSg=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zachary Goldstein <zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org>

From: Zachary Goldstein <zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org>

5.10 suffers from the same recursive locking issue that
commit a848d25434de4 ("mm/memcg: Opencode the inner part of
obj_cgroup_uncharge_pages() in drain_obj_stock()") fixes.

Modified description from the commit to reflect this patch changes:

Provide the inner part of refill_stock() as __refill_stock() without
disabling interrupts. This eases the integration of local_lock_t where
recursive locking must be avoided.
Open code __memcg_kmem_uncharge() in drain_obj_stock() and
obj_cgroup_release() and use __refill_stock(). The caller of
drain_obj_stock() and obj_cgroup_release() already disables interrupts.

Signed-off-by: Zachary Goldstein <zachary.goldstein-93WYBkrbF8XrdiZUmNWkGQC/G2K4zDHf@public.gmane.org>
---
 mm/memcontrol.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5dd77e260c25..d61918cc44c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -260,6 +260,8 @@ struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
 #ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
 
+static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages);
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -294,8 +296,12 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 
 	spin_lock_irqsave(&objcg_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
-	if (nr_pages)
-		__memcg_kmem_uncharge(memcg, nr_pages);
+	if (nr_pages) {
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			page_counter_uncharge(&memcg->kmem, nr_pages);
+
+		__refill_stock(memcg, nr_pages);
+	}
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
 	spin_unlock_irqrestore(&objcg_lock, flags);
@@ -2319,12 +2325,9 @@ static void drain_local_stock(struct work_struct *dummy)
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned long flags;
-
-	local_lock_irqsave(&memcg_stock.lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached != memcg) { /* reset if necessary */
@@ -2336,7 +2339,14 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
 		drain_stock(stock);
+}
 
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	unsigned long flags;
+
+	local_lock_irqsave(&memcg_stock.lock, flags);
+	__refill_stock(memcg, nr_pages);
 	local_unlock_irqrestore(&memcg_stock.lock, flags);
 }
 
@@ -3179,7 +3189,11 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 				goto retry;
 			rcu_read_unlock();
 
-			__memcg_kmem_uncharge(memcg, nr_pages);
+			if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+				page_counter_uncharge(&memcg->kmem, nr_pages);
+
+			__refill_stock(memcg, nr_pages);
+
 			css_put(&memcg->css);
 		}
 
