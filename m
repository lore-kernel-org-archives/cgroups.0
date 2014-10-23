From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcontrol: uncharge pages on swapout fix
Date: Thu, 23 Oct 2014 10:31:40 -0400
Message-ID: <1414074700-13995-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Vladimir notes:

> > +   local_irq_disable();
> > +   mem_cgroup_charge_statistics(memcg, page, -1);
> > +   memcg_check_events(memcg, page);
> > +   local_irq_enable();
>
> AFAICT mem_cgroup_swapout() is called under mapping->tree_lock with irqs
> disabled, so we should use irq_save/restore here.

Simply remove the irq-disabling altogether and rely on the caller
holding the mapping->tree_lock for now.

Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

For "mm: memcontrol: uncharge pages on swapout" in -mm.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae9b630e928b..09fece0eb9f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5777,10 +5777,11 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
 
-	local_irq_disable();
+	/* XXX: caller holds IRQ-safe mapping->tree_lock */
+	VM_BUG_ON(!irqs_disabled());
+
 	mem_cgroup_charge_statistics(memcg, page, -1);
 	memcg_check_events(memcg, page);
-	local_irq_enable();
 }
 
 /**
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
