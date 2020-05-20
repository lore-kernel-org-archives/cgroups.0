From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] mm, memcg: unify reclaim retry limits with page allocator
Date: Wed, 20 May 2020 17:31:42 +0100
Message-ID: <20200520163142.GA808793@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=17jQ1Ah04oBToqJwXezLZCoVZLFH+XvWoWdyyqn9mN4=;
        b=ToruOqWtIPegGVdd3B6jTVoD/jM+3Af1McEs8wIdfzwADuzejeup3xOJQYdm11S4EZ
         65f5gLqFmKnxcngv/RXN+x6KKrFXbF2QNkJJEO/INc/RjX4WvlQPN+Bi7MjzN0mt+0WH
         8YSuiL7L4Tj+3phhD1zTvajIoimjSyRefUirY=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Reclaim retries have been set to 5 since the beginning of time in
66e1707bc346 ("Memory controller: add per cgroup LRU and reclaim").
However, we now have a generally agreed-upon standard for page reclaim:
MAX_RECLAIM_RETRIES (currently 16), added many years later in
0a0337e0d1d1 ("mm, oom: rework oom detection").

In the absence of a compelling reason to declare an OOM earlier in memcg
context than page allocator context, it seems reasonable to supplant
MEM_CGROUP_RECLAIM_RETRIES with MAX_RECLAIM_RETRIES, making the page
allocator and memcg internals more similar in semantics when reclaim
fails to produce results, avoiding premature OOMs or throttling.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
---
 mm/memcontrol.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b040951ccd6b..d3b23c57bed4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -73,9 +73,6 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
-/* The number of times we should retry reclaim failures before giving up. */
-#define MEM_CGROUP_RECLAIM_RETRIES	5
-
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
 
@@ -2386,7 +2383,7 @@ void mem_cgroup_handle_over_high(void)
 	unsigned long pflags;
 	unsigned long nr_reclaimed;
 	unsigned int nr_pages = current->memcg_nr_pages_over_high;
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *memcg;
 
 	if (likely(!nr_pages))
@@ -2438,7 +2435,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		      unsigned int nr_pages)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
@@ -2557,7 +2554,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
 	switch (oom_status) {
 	case OOM_SUCCESS:
-		nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
 	case OOM_FAILED:
 		goto force;
@@ -3168,7 +3165,7 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
  */
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -6001,7 +5998,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 				 char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long high;
 	int err;
@@ -6049,7 +6046,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned int nr_reclaims = MEM_CGROUP_RECLAIM_RETRIES;
+	unsigned int nr_reclaims = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long max;
 	int err;
-- 
2.26.2

