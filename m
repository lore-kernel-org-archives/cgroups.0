From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Fri,  1 Oct 2021 15:09:36 -0400
Message-ID: <20211001190938.14050-2-longman@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633115417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sFCP5YMQVpSD6yFGcGrxnQTLJHGtWuJlEliBV/TO+yU=;
        b=AKCyPD1VdJHPZK3bsmwPHUhCOd6YQ+oo77eHOuq4wQJf41w4Az6EjkUxbZ6w7KpPVIOY4V
        chHboZUSMGOPB2rZJR0HeMr+O0r0VG2+PRdHAtJ8zz1cqzzcpC3CNcV3yaUsELE/1HdtCu
        4GNmizsYQ1GrrIy+DR6NVKGLx11DZaw=
In-Reply-To: <20211001190938.14050-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When freeing a page associated with an offlined memcg, refill_stock()
will put it into local stock delaying its demise until another memcg
comes in to take its place in the stock. To avoid that, we now check
for offlined memcg and go directly in this case to the slowpath for
the uncharge via the repurposed cancel_charge() function.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b32896d87a2..4568363062c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2167,6 +2167,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	return ret;
 }
 
+static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
+
 /*
  * Returns stocks cached in percpu and reset cached information.
  */
@@ -2178,9 +2180,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 		return;
 
 	if (stock->nr_pages) {
-		page_counter_uncharge(&old->memory, stock->nr_pages);
-		if (do_memsw_account())
-			page_counter_uncharge(&old->memsw, stock->nr_pages);
+		cancel_charge(old, stock->nr_pages);
 		stock->nr_pages = 0;
 	}
 
@@ -2219,6 +2219,14 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
 
+	/*
+	 * An offlined memcg shouldn't be put into stock.
+	 */
+	if (unlikely(memcg->kmem_state != KMEM_ONLINE)) {
+		cancel_charge(memcg, nr_pages);
+		return;
+	}
+
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2732,7 +2740,6 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
 static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
@@ -2742,7 +2749,6 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
-#endif
 
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
-- 
2.18.1

