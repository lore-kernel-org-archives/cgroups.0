From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v3 1/2] mm/memcg: try harder to decrease [memory,memsw].limit_in_bytes
Date: Tue,  9 Jan 2018 19:58:14 +0300
Message-ID: <20180109165815.8329-1-aryabinin@virtuozzo.com>
References: <20171220135329.GS4831@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=W8Qxe/xRwQnRJiHBBz/8X2j5Ks0UtQHdasLF4Os4OQ0=;
 b=HqsLwG9Xuu+3/Y86VN5XdpT7Ndt8HYk15Ti43LdQA53CgdLmInw6rRxGYUOeFVAjGgcAYn/l6BLdpXs+DMNur6Ge69OBYjZwIWvrCMX7gjb/SjBpdeLC2jyXdoWbQ0Lm08xsjz7SPsiYfj8sPIToHTl+am/Zquo+Ms7CKBE1Aug=
In-Reply-To: <20171220135329.GS4831@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
pages on each iteration. This makes practically impossible to decrease
limit of memory cgroup. Tasks could easily allocate back 32 pages,
so we can't reduce memory usage, and once retry_count reaches zero we return
-EBUSY.

Easy to reproduce the problem by running the following commands:

  mkdir /sys/fs/cgroup/memory/test
  echo $$ >> /sys/fs/cgroup/memory/test/tasks
  cat big_file > /dev/null &
  sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
  -bash: echo: write error: Device or resource busy

Instead of relying on retry_count, keep retrying the reclaim until
the desired limit is reached or fail if the reclaim doesn't make
any progress or a signal is pending.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---

Changes since v2:
 - Changelog wording per mhocko@

 mm/memcontrol.c | 70 +++++++++++++--------------------------------------------
 1 file changed, 16 insertions(+), 54 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f40b5ad3f959..0d26db9a665d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1176,20 +1176,6 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 }
 
 /*
- * This function returns the number of memcg under hierarchy tree. Returns
- * 1(self count) if no children.
- */
-static int mem_cgroup_count_children(struct mem_cgroup *memcg)
-{
-	int num = 0;
-	struct mem_cgroup *iter;
-
-	for_each_mem_cgroup_tree(iter, memcg)
-		num++;
-	return num;
-}
-
-/*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
 unsigned long mem_cgroup_get_limit(struct mem_cgroup *memcg)
@@ -2462,22 +2448,10 @@ static DEFINE_MUTEX(memcg_limit_mutex);
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
-	unsigned long curusage;
-	unsigned long oldusage;
+	unsigned long usage;
 	bool enlarge = false;
-	int retry_count;
 	int ret;
 
-	/*
-	 * For keeping hierarchical_reclaim simple, how long we should retry
-	 * is depends on callers. We set our retry-count to be function
-	 * of # of children which we should visit in this loop.
-	 */
-	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
-		      mem_cgroup_count_children(memcg);
-
-	oldusage = page_counter_read(&memcg->memory);
-
 	do {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -2498,15 +2472,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
-
-		curusage = page_counter_read(&memcg->memory);
-		/* Usage is reduced ? */
-		if (curusage >= oldusage)
-			retry_count--;
-		else
-			oldusage = curusage;
-	} while (retry_count);
+		usage = page_counter_read(&memcg->memory);
+		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
+					GFP_KERNEL, true)) {
+			ret = -EBUSY;
+			break;
+		}
+	} while (true);
 
 	if (!ret && enlarge)
 		memcg_oom_recover(memcg);
@@ -2517,18 +2489,10 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 					 unsigned long limit)
 {
-	unsigned long curusage;
-	unsigned long oldusage;
+	unsigned long usage;
 	bool enlarge = false;
-	int retry_count;
 	int ret;
 
-	/* see mem_cgroup_resize_res_limit */
-	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
-		      mem_cgroup_count_children(memcg);
-
-	oldusage = page_counter_read(&memcg->memsw);
-
 	do {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -2549,15 +2513,13 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
-
-		curusage = page_counter_read(&memcg->memsw);
-		/* Usage is reduced ? */
-		if (curusage >= oldusage)
-			retry_count--;
-		else
-			oldusage = curusage;
-	} while (retry_count);
+		usage = page_counter_read(&memcg->memsw);
+		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
+					GFP_KERNEL, false)) {
+			ret = -EBUSY;
+			break;
+		}
+	} while (true);
 
 	if (!ret && enlarge)
 		memcg_oom_recover(memcg);
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
