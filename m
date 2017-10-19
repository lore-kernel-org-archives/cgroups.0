From: Roman Gushchin <guro@fb.com>
Subject: [RESEND v12 2/6] mm: implement mem_cgroup_scan_tasks() for the root memory cgroup
Date: Thu, 19 Oct 2017 19:52:14 +0100
Message-ID: <20171019185218.12663-3-guro@fb.com>
References: <20171019185218.12663-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=sKN4hs0Xf7bsYXWO+feYZDCytzptR4xQ2EObhP5DdJE=;
 b=jdyy9HT4D80FEWkijLnUU0PU834bokt2j20xrYQqKcaz67O6/5B053OI3BRODKwI7oCa
 yWYITTSh4S/NvpPSdrES8mA/MJARGW8lY6qyO7GHbqtQIs3T/BypwZ/QS0Nd7X9uWRJM
 2usAeQ8o+1rEZ26LiucAEJRH2fkiJvTiex0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sKN4hs0Xf7bsYXWO+feYZDCytzptR4xQ2EObhP5DdJE=;
 b=fOgpuvTz9nyKRUqEiqClsY6U4UnBKe5vxt93LRh2KZgvfcO+raiNOenDCl893F0uSRYGMkZ83NId+pgmXhK5GtPU4H0XWAgyhBz4sqRbRB6RnyZXpiIPqRDg0Sa+av1OvtdyCEE8JrzjujZZygOskNwAC27iN/FwQmgBvhLSdfM=
In-Reply-To: <20171019185218.12663-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Implement mem_cgroup_scan_tasks() functionality for the root
memory cgroup to use this function for looking for a OOM victim
task in the root memory cgroup by the cgroup-ware OOM killer.

The root memory cgroup is treated as a leaf cgroup, so only tasks
which are directly belonging to the root cgroup are iterated over.

This patch doesn't introduce any functional change as
mem_cgroup_scan_tasks() is never called for the root memcg.
This is preparatory work for the cgroup-aware OOM killer,
which will use this function to iterate over tasks belonging
to the root memcg.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50e6906314f8..1d30a45a4bbe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -917,7 +917,8 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
  * value, the function breaks the iteration loop and returns the value.
  * Otherwise, it will iterate over all tasks and return 0.
  *
- * This function must not be called for the root memory cgroup.
+ * If memcg is the root memory cgroup, this function will iterate only
+ * over tasks belonging directly to the root memory cgroup.
  */
 int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			  int (*fn)(struct task_struct *, void *), void *arg)
@@ -925,8 +926,6 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	struct mem_cgroup *iter;
 	int ret = 0;
 
-	BUG_ON(memcg == root_mem_cgroup);
-
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
 		struct task_struct *task;
@@ -935,7 +934,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		while (!ret && (task = css_task_iter_next(&it)))
 			ret = fn(task, arg);
 		css_task_iter_end(&it);
-		if (ret) {
+		if (ret || memcg == root_mem_cgroup) {
 			mem_cgroup_iter_break(memcg, iter);
 			break;
 		}
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
