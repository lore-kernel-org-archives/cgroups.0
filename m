From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 2/2] mm/memcontrol: Add a new MEMCG_SUBSET_HIGH event
Date: Wed, 10 Apr 2019 15:13:21 -0400
Message-ID: <20190410191321.9527-3-longman@redhat.com>
References: <20190410191321.9527-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410191321.9527-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Aaron Lu <aaron.lu@intel.com>, Waiman Long <longman@redhat.com>

A new MEMCG_SUBSET_HIGH event is added to record the number of times
subset.high value is exceeded.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol.c            | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1baf3e4a9eeb..4498db61507a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -52,6 +52,7 @@ enum memcg_memory_event {
 	MEMCG_LOW,
 	MEMCG_HIGH,
 	MEMCG_MAX,
+	MEMCG_SUBSET_HIGH,
 	MEMCG_OOM,
 	MEMCG_OOM_KILL,
 	MEMCG_SWAP_MAX,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7e52adea60d9..feba8b9c55b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2150,8 +2150,10 @@ static void reclaim_high(struct mem_cgroup *memcg,
 	/*
 	 * Try memory reclaim if subset_high is exceeded.
 	 */
-	if (mtype && (memcg_page_state(memcg, mtype) > memcg->subset_high))
+	if (mtype && (memcg_page_state(memcg, mtype) > memcg->subset_high)) {
+		memcg_memory_event(memcg, MEMCG_SUBSET_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
+	}
 
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
@@ -5603,6 +5605,8 @@ static int memory_events_show(struct seq_file *m, void *v)
 		   atomic_long_read(&memcg->memory_events[MEMCG_HIGH]));
 	seq_printf(m, "max %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_MAX]));
+	seq_printf(m, "subset_high %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_SUBSET_HIGH]));
 	seq_printf(m, "oom %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM]));
 	seq_printf(m, "oom_kill %lu\n",
-- 
2.18.1

