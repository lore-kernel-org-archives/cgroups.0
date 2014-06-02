From: David Rientjes <rientjes@google.com>
Subject: [patch] mm, memcg: periodically schedule when emptying page list
Date: Mon, 2 Jun 2014 16:13:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=FdANwZABaTmzEp9YCucMxoAXyVFSMtDlu40pqAa75bM=;
        b=CahCi4o+M1sqwOqm3fomPwPSAxk700pee0u29YHyDnjRUYLXoBfZRG6HCmGicTwr/h
         nmvWcWb6dLo+ze0emAHM++3yT6d8a8CbZNPq0hwpYIcMZjrF+1Q134UaQUpvvWJragBe
         L0YIdj5isi33bk99VcmIw/yPQ49cqoU4UE0h0cRXSzyiSxmP+htc8Zi90qwmNFgfumUl
         SnnG9TI0DuJnwyRjZmlrSNbqDOw73CKVKSk7F9a5lVBDCepoZWtYYlFIyvqFjYwz/HHr
         p4rbD9GAfMeTIWdaPhxlaHuvtmNEevIBtTNd74bUEb8+01MqSmuevq4bo5DSq/BIMhrw
         jgxA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

mem_cgroup_force_empty_list() can iterate a large number of pages on an lru and 
mem_cgroup_move_parent() doesn't return an errno unless certain criteria, none 
of which indicate that the iteration may be taking too long, is met.

We have encountered the following stack trace many times indicating
"need_resched set for > 51000020 ns (51 ticks) without schedule", for example:

	scheduler_tick()
	<timer irq>
	mem_cgroup_move_account+0x4d/0x1d5
	mem_cgroup_move_parent+0x8d/0x109
	mem_cgroup_reparent_charges+0x149/0x2ba
	mem_cgroup_css_offline+0xeb/0x11b
	cgroup_offline_fn+0x68/0x16b
	process_one_work+0x129/0x350

If this iteration is taking too long, indicated by need_resched(), then 
periodically schedule and continue from where we last left off.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4764,6 +4764,7 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 	do {
 		struct page_cgroup *pc;
 		struct page *page;
+		int ret;
 
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
@@ -4781,8 +4782,13 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 
 		pc = lookup_page_cgroup(page);
 
-		if (mem_cgroup_move_parent(page, pc, memcg)) {
-			/* found lock contention or "pc" is obsolete. */
+		ret = mem_cgroup_move_parent(page, pc, memcg);
+		if (ret || need_resched()) {
+			/*
+			 * Couldn't grab the page reference, isolate the page,
+			 * there was a pc mismatch, or we simply need to
+			 * schedule because this is taking too long.
+			 */
 			busy = page;
 			cond_resched();
 		} else

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
