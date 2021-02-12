From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 2/4] mm: memcontrol: add missing memcg_oom_recover() when uncharge slab page
Date: Sat, 13 Feb 2021 01:01:57 +0800
Message-ID: <20210212170159.32153-2-songmuchun@bytedance.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bcYt0NSihifXZf17H55Cj5Hl2GUjQyX5Z/whSKEEhxI=;
        b=QXdiNtz4icRE9wYOkzwNj/MEYjknOPfl+3qraA/tVpTL1yVUQ1uW/Egvq3zevZw11m
         20DnFlwvQipf18yyHzSbhvGpWQ214vwvIYstobFglcVWyBKXAYFVQKqdebGoExkRRSK5
         eiQft2Jyww09TKCwpm9fRe6tkSks1kczSXEdcv/laOSq5Cy74ohKIYxLVjPANARtpaLa
         liZ+acD0FILIz+lrXrA0/L9tZrDVhVAsNAGcQONgLpjgPGdqpzEP9NdCgVeVK6fjDxQo
         CXm7xNS6alE/sydQVkPcpDYcXQZrJZE64mOIICrRUaLwpDpPS5NX11mhQxdktolhNWPw
         vO4w==
In-Reply-To: <20210212170159.32153-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

When we uncharge a page, we wake up oom victims when the memcg oom
handling is outsourced to the userspace. The uncharge_batch do that
for normal and kmem pages but not slab pages. It is likely an
omission. So add the missing memcg_oom_recover() to
__memcg_kmem_uncharge(). And the function of memory.oom_control
is only suitable for cgroup v1. So guard this test (memcg->under_oom)
by the cgroup_subsys_on_dfl(memory_cgrp_subsys).

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7afca9677693..a3f26522765a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3126,8 +3126,10 @@ static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
  */
 static void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		page_counter_uncharge(&memcg->kmem, nr_pages);
+		memcg_oom_recover(memcg);
+	}
 
 	refill_stock(memcg, nr_pages);
 }
@@ -6806,11 +6808,15 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 
 	if (!mem_cgroup_is_root(ug->memcg)) {
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
-		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
-			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
-		memcg_oom_recover(ug->memcg);
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+			if (!cgroup_memory_noswap)
+				page_counter_uncharge(&ug->memcg->memsw,
+						      ug->nr_pages);
+			if (ug->nr_kmem)
+				page_counter_uncharge(&ug->memcg->kmem,
+						      ug->nr_kmem);
+			memcg_oom_recover(ug->memcg);
+		}
 	}
 
 	local_irq_save(flags);
-- 
2.11.0

