From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v13 02/18] mm/memcg: Remove 'page' parameter to mem_cgroup_charge_statistics()
Date: Mon, 12 Jul 2021 20:45:35 +0100
Message-ID: <20210712194551.91920-3-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Hzd335Ag+ayCqdQrtUoVggNp2H/a7Ca0++VzF2umYOo=; b=mnoQg6g4xwqBhB5RhwEQ8ohegk
        YmKBh9TPY1odrhXSQUIcpsxCoBdujNtrdCQZA3Y29K4qZ3Fq4PaScI+xKmnshWwSIJkggsmsZ55bm
        ahVvphya0QWUaSDuZ4J3Bk5BjIzbmGlNyZGKCExOLe/x5WNNZBAKsfLgRYzJmpnKLYNKrUa/WSfYw
        6+atZA0kRnwPWAe+o2znxqAJvCYa3vFxnqE+G0yldd8VlGtv41IeUo3SPSR1rTPn5RpMVoD2soyQc
        AHDJo/ag4vFgAK2N6wLngXrZgyx3SrE2RdOKUbSLrMpc22lhAOyYsVP+fDmzt9Otxx5GcSIU3azQU
        XGh0l6AQ==;
In-Reply-To: <20210712194551.91920-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The last use of 'page' was removed by commit 468c398233da ("mm:
memcontrol: switch to native NR_ANON_THPS counter"), so we can now remove
the parameter from the function.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae1f5d0cb581..ee892daecb8b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -831,7 +831,6 @@ static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
-					 struct page *page,
 					 int nr_pages)
 {
 	/* pagein of a big page is an event. So, ignore page size */
@@ -5692,9 +5691,9 @@ static int mem_cgroup_move_account(struct page *page,
 	ret = 0;
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(to, page, nr_pages);
+	mem_cgroup_charge_statistics(to, nr_pages);
 	memcg_check_events(to, page);
-	mem_cgroup_charge_statistics(from, page, -nr_pages);
+	mem_cgroup_charge_statistics(from, -nr_pages);
 	memcg_check_events(from, page);
 	local_irq_enable();
 out_unlock:
@@ -6715,7 +6714,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
 	commit_charge(page, memcg);
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, nr_pages);
+	mem_cgroup_charge_statistics(memcg, nr_pages);
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 out:
@@ -7006,7 +7005,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	commit_charge(newpage, memcg);
 
 	local_irq_save(flags);
-	mem_cgroup_charge_statistics(memcg, newpage, nr_pages);
+	mem_cgroup_charge_statistics(memcg, nr_pages);
 	memcg_check_events(memcg, newpage);
 	local_irq_restore(flags);
 }
@@ -7236,7 +7235,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	 * only synchronisation we have for updating the per-CPU variables.
 	 */
 	VM_BUG_ON(!irqs_disabled());
-	mem_cgroup_charge_statistics(memcg, page, -nr_entries);
+	mem_cgroup_charge_statistics(memcg, -nr_entries);
 	memcg_check_events(memcg, page);
 
 	css_put(&memcg->css);
-- 
2.30.2

