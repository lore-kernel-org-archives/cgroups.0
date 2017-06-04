From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH v2] memcg: refactor mem_cgroup_resize_limit()
Date: Sun,  4 Jun 2017 13:04:37 -0700
Message-ID: <20170604200437.17815-1-yuzhao@google.com>
References: <20170601230212.30578-1-yuzhao@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N+/AoQO1waoFV/epWb9CGr/ypLhRgmb84qEnA6uRDlE=;
        b=l9U0Hz5njEFTrmZrThcoybet6dldM16Cq/iSeR9MSG9ezYj4QKaOnMXTMBcsdnINa9
         BwtvAIlu+oeIpuMGJEgPjfIwm5jWL4/BU0kvJMyjTVNr500M+c8mJ6vMpBjeFs97gvmD
         qhsroNRTpk+KzpmTnxefhl9WYiq9rNBd6O9u74FOyVMp2hg22lYe02u2/e/9jzOLAZUv
         oRkzSFhUim33WvmHgoZnJHMKGn+kJrKdDGvYjl7mqpJ+cnIeJdgWudF2tcNyvOCRpnOg
         2/Zf7kIfrTK7i/nxuT+VtS9aQB28eglqVLgqvAlPqyi4g4fBm/eg8WN4JT5/eBeNjGen
         HvxA==
In-Reply-To: <20170601230212.30578-1-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, n.borisov.lkml@gmail.com, Yu Zhao <yuzhao@google.com>

mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
identical logics. Refactor code so we don't need to keep two pieces
of code that does same thing.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
---
Changelog since v1:
* minor style change

 mm/memcontrol.c | 73 ++++++++++-----------------------------------------------
 1 file changed, 13 insertions(+), 60 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 94172089f52f..08a97a381b2a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2422,13 +2422,15 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
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
+	bool inverted;
+	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
 	/*
 	 * For keeping hierarchical_reclaim simple, how long we should retry
@@ -2438,58 +2440,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
 		      mem_cgroup_count_children(memcg);
 
-	oldusage = page_counter_read(&memcg->memory);
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
+	oldusage = page_counter_read(counter);
 
 	do {
 		if (signal_pending(current)) {
@@ -2498,22 +2449,24 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 		}
 
 		mutex_lock(&memcg_limit_mutex);
-		if (limit < memcg->memory.limit) {
+		inverted = memsw ? limit < memcg->memory.limit :
+				   limit > memcg->memsw.limit;
+		if (inverted)
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
@@ -2975,10 +2928,10 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
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
2.13.0.506.g27d5fe0cd-goog

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
