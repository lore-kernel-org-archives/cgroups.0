From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v3 2/2] mm/memcg: Consolidate mem_cgroup_resize_[memsw]_limit() functions.
Date: Tue,  9 Jan 2018 19:58:15 +0300
Message-ID: <20180109165815.8329-2-aryabinin@virtuozzo.com>
References: <20171220135329.GS4831@dhcp22.suse.cz>
 <20180109165815.8329-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3w0PiCx3hcLyyxeHMQnYDrCeyBp0saceQ3nZuDp4/uo=;
 b=Zp2sgzyc+4wuJYAcKNpdAf9zSS9/d4IlHaIXBHWJW1FgSprhBAnvIibj5GCxFCnqG5kIsQi6NXLOtoAY5R3YvXn4aRJAkH0ZkiXlGYh5NbAVk/juRNGh5B22Qk+vrkx60UrPGsHt2Z+XY0lePky6X3GkTmaH46smjBTTPS87DBs=
In-Reply-To: <20180109165815.8329-1-aryabinin@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() are almost
identical functions. Instead of having two of them, we could pass an
additional argument to mem_cgroup_resize_limit() and by using it,
consolidate all the code in a single function.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 mm/memcontrol.c | 61 +++++++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 47 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d26db9a665d..f6253c80a5c8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2445,50 +2445,17 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
 
 static DEFINE_MUTEX(memcg_limit_mutex);
 
-static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
-				   unsigned long limit)
+static bool invalid_mem_limit(struct mem_cgroup *memcg, bool memsw,
+			      unsigned long limit)
 {
-	unsigned long usage;
-	bool enlarge = false;
-	int ret;
-
-	do {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		mutex_lock(&memcg_limit_mutex);
-		if (limit > memcg->memsw.limit) {
-			mutex_unlock(&memcg_limit_mutex);
-			ret = -EINVAL;
-			break;
-		}
-		if (limit > memcg->memory.limit)
-			enlarge = true;
-		ret = page_counter_limit(&memcg->memory, limit);
-		mutex_unlock(&memcg_limit_mutex);
-
-		if (!ret)
-			break;
-
-		usage = page_counter_read(&memcg->memory);
-		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
-					GFP_KERNEL, true)) {
-			ret = -EBUSY;
-			break;
-		}
-	} while (true);
-
-	if (!ret && enlarge)
-		memcg_oom_recover(memcg);
-
-	return ret;
+	return (!memsw && limit > memcg->memsw.limit) ||
+		(memsw && limit < memcg->memory.limit);
 }
 
-static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
-					 unsigned long limit)
+static int mem_cgroup_resize_limit(struct mem_cgroup *memcg, bool memsw,
+				   unsigned long limit)
 {
+	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 	unsigned long usage;
 	bool enlarge = false;
 	int ret;
@@ -2500,22 +2467,22 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 		}
 
 		mutex_lock(&memcg_limit_mutex);
-		if (limit < memcg->memory.limit) {
+		if (invalid_mem_limit(memcg, memsw, limit)) {
 			mutex_unlock(&memcg_limit_mutex);
 			ret = -EINVAL;
 			break;
 		}
-		if (limit > memcg->memsw.limit)
+		if (limit > counter->limit)
 			enlarge = true;
-		ret = page_counter_limit(&memcg->memsw, limit);
+		ret = page_counter_limit(counter, limit);
 		mutex_unlock(&memcg_limit_mutex);
 
 		if (!ret)
 			break;
 
-		usage = page_counter_read(&memcg->memsw);
+		usage = page_counter_read(counter);
 		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
-					GFP_KERNEL, false)) {
+					GFP_KERNEL, !memsw)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3193,10 +3160,10 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
 		case _MEM:
-			ret = mem_cgroup_resize_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, false, nr_pages);
 			break;
 		case _MEMSWAP:
-			ret = mem_cgroup_resize_memsw_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, true, nr_pages);
 			break;
 		case _KMEM:
 			ret = memcg_update_kmem_limit(memcg, nr_pages);
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
