From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v5 2/2] mm/memcontrol.c: Reduce reclaim retries in mem_cgroup_resize_limit()
Date: Fri, 19 Jan 2018 16:25:44 +0300
Message-ID: <20180119132544.19569-2-aryabinin@virtuozzo.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=o4RMv/d7L1ZXPGLpDcLbc8Dnuyuug1U0NElJ29Otdr4=;
 b=VQzaCMZ7hekQjXipWVgrHFCR6fp0uyPeaExUzV0KuD1BeS/CkhFZB63JCqYiW86ymZQTBGZbXu0l/C5rSNOJ9eqofG+gahwYno6V5oOdqFbNn0HL3rnidqVYHEn9hvmBYcWIn8QFSDZ/SrI4bn6QRxSrxA/mWtyFhfDGWeaHMc8=
In-Reply-To: <20180119132544.19569-1-aryabinin@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrey Ryabinin <aryabinin@virtuozzo.com>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

Currently mem_cgroup_resize_limit() retries to set limit after reclaiming
32 pages. It makes more sense to reclaim needed amount of pages right away.

This works noticeably faster, especially if 'usage - limit' big.
E.g. bringing down limit from 4G to 50M:

Before:
 # perf stat echo 50M > memory.limit_in_bytes

     Performance counter stats for 'echo 50M':

            386.582382      task-clock (msec)         #    0.835 CPUs utilized
                 2,502      context-switches          #    0.006 M/sec

           0.463244382 seconds time elapsed

After:
 # perf stat echo 50M > memory.limit_in_bytes

     Performance counter stats for 'echo 50M':

            169.403906      task-clock (msec)         #    0.849 CPUs utilized
                    14      context-switches          #    0.083 K/sec

           0.199536900 seconds time elapsed

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
---
 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9d987f3e79dc..09bac2df2f12 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2448,6 +2448,7 @@ static DEFINE_MUTEX(memcg_limit_mutex);
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit, bool memsw)
 {
+	unsigned long nr_pages;
 	bool enlarge = false;
 	int ret;
 	bool limits_invariant;
@@ -2479,8 +2480,9 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1,
-					GFP_KERNEL, !memsw)) {
+		nr_pages = max_t(long, 1, page_counter_read(counter) - limit);
+		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages,
+						GFP_KERNEL, !memsw)) {
 			ret = -EBUSY;
 			break;
 		}
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
