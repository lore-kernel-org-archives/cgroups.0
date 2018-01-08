From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH v4] memcg: refactor mem_cgroup_resize_limit()
Date: Mon,  8 Jan 2018 14:42:38 -0800
Message-ID: <20180108224238.14583-1-yuzhao@google.com>
References: <20170601230212.30578-1-yuzhao@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3waEkb1R2SYMBILn+HCnuvZgxTvOKp9URv6YksjALvw=;
        b=hy4OdBpDS+I+OZ446cuUglIHQI8FiDsrevnWvTjMr1qLjo4WHdK4p2VQ84adcAkZgt
         OLw/E14UdA4r8mKsjI6v+HK580FcglGeQYCWwVg2wKgAc+kuvXwFammcsSOhJLiN5O+n
         0ByhBKam5ineGCglaXBMTQZxSkeM6P4uhd2nCYbXkAZ50X/YCjuwSY7EhkGDSzWkiC9e
         WWkPH2rZGLALtLKGo3DjK13QM9JJ1myvcjGz+tTpAmHnf5OY1dq36OC0/A24FgyV0kXH
         i+uHYWVr3N5Nivk00Hpz2ENDVofuCsOy2uMIVZsCH/gWaUURh5S6fYpnkQS1jipbeZSW
         WLjg==
In-Reply-To: <20170601230212.30578-1-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>

mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
identical logics. Refactor code so we don't need to keep two pieces
of code that does same thing.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 77 +++++++++++++--------------------------------------------
 1 file changed, 17 insertions(+), 60 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac2ffd5e02b9..9af733fa9381 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2467,13 +2467,15 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
 static DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
-				   unsigned long limit)
+				   unsigned long limit, bool memsw)
 {
 	unsigned long curusage;
 	unsigned long oldusage;
 	bool enlarge = false;
 	int retry_count;
 	int ret;
+	bool limits_invariant;
+	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
 	/*
 	 * For keeping hierarchical_reclaim simple, how long we should retry
@@ -2483,7 +2485,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
 		      mem_cgroup_count_children(memcg);
 
-	oldusage = page_counter_read(&memcg->memory);
+	oldusage = page_counter_read(counter);
 
 	do {
 		if (signal_pending(current)) {
@@ -2492,73 +2494,28 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 		}
 
 		mutex_lock(&memcg_limit_mutex);
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
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
-
-		curusage = page_counter_read(&memcg->memory);
-		/* Usage is reduced ? */
-		if (curusage >= oldusage)
-			retry_count--;
-		else
-			oldusage = curusage;
-	} while (retry_count);
-
-	if (!ret && enlarge)
-		memcg_oom_recover(memcg);
-
-	return ret;
-}
-
-static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
-					 unsigned long limit)
-{
-	unsigned long curusage;
-	unsigned long oldusage;
-	bool enlarge = false;
-	int retry_count;
-	int ret;
-
-	/* see mem_cgroup_resize_res_limit */
-	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
-		      mem_cgroup_count_children(memcg);
-
-	oldusage = page_counter_read(&memcg->memsw);
-
-	do {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		mutex_lock(&memcg_limit_mutex);
-		if (limit < memcg->memory.limit) {
+		/*
+		 * Make sure that the new limit (memsw or memory limit) doesn't
+		 * break our basic invariant rule memory.limit <= memsw.limit.
+		 */
+		limits_invariant = memsw ? limit >= memcg->memory.limit :
+					   limit <= memcg->memsw.limit;
+		if (!limits_invariant) {
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
 
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
+		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
 
-		curusage = page_counter_read(&memcg->memsw);
+		curusage = page_counter_read(counter);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
 			retry_count--;
@@ -3020,10 +2977,10 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
 		case _MEM:
-			ret = mem_cgroup_resize_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, nr_pages, false);
 			break;
 		case _MEMSWAP:
-			ret = mem_cgroup_resize_memsw_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, nr_pages, true);
 			break;
 		case _KMEM:
 			ret = memcg_update_kmem_limit(memcg, nr_pages);
-- 
2.16.0.rc0.223.g4a4ac83678-goog

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
