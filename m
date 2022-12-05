From: lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: speedup memory cgroup resize
Date: Mon,  5 Dec 2022 19:49:52 +0800
Message-ID: <1670240992-28563-1-git-send-email-lirongqing@baidu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

From: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>

when resize memory cgroup, avoid to free memory cgroup page
one by one, and try to free needed number pages once

same to emtpy a memory cgroup memory

Signed-off-by: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d8549ae1b30..86993d055d86 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3464,6 +3464,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 	bool drained = false;
 	int ret;
 	bool limits_invariant;
+	unsigned long nr_pages;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
 	do {
@@ -3498,7 +3499,13 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 			continue;
 		}
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+		nr_pages = page_counter_read(counter);
+
+		if (nr_pages > max)
+			nr_pages = nr_pages - max;
+		else
+			nr_pages = 1;
+		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
 					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
 			ret = -EBUSY;
 			break;
@@ -3598,6 +3605,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_pages;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -3605,11 +3613,11 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 	drain_all_stock(memcg);
 
 	/* try to free all pages in this cgroup */
-	while (nr_retries && page_counter_read(&memcg->memory)) {
+	while (nr_retries && (nr_pages = page_counter_read(&memcg->memory))) {
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
 						  MEMCG_RECLAIM_MAY_SWAP))
 			nr_retries--;
 	}
-- 
2.27.0

