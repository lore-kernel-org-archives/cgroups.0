From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] memcg: refactor mem_cgroup_oom
Date: Thu, 10 Feb 2022 00:14:34 -0800
Message-ID: <20220210081437.1884008-2-shakeelb@google.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ccL+prLnNui1wQO9OJC//pr1nIoZqpsfs/6QLowjnxA=;
        b=pmWp6X7ryarZ+YnBgBkSYNZxfbT8EUlpu8mZWkUUtaqWZTASUegrZGNcgLJM6LDrfa
         sOyZ5paq6lfQOFy7Maq4sHUcY9hzReQFMlxZLwCDGu/xt0EMaw3WG10U2i4brkjeC1ZN
         cTNPjKYzdbfmwoU3+S2uZkl6/qBNFL5mgkZ5IDt/F1jziJdPtD6JcM5+aDpIlRdfgXeG
         ZwDPGoUDwhz7YwmvtmbB011F5qAf/buznwxzhCM7vdskuMAf5xAw1VCbJL70Q2M0x5Rn
         KdTFwyttN8r6iGaw76vM+QZ7PWhQpOvxdEIg08Ms6pYH71vRsTnDCxQsmfoWxtiRLr65
         uIcQ==
In-Reply-To: <20220210081437.1884008-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The function mem_cgroup_oom returns enum which has four possible values
but the caller does not care about such values and only care if the
return value is OOM_SUCCESS or not. So, remove the enum altogether and
make mem_cgroup_oom returns a simple bool.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a0e9d9f12cf5..c40c27822802 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1795,20 +1795,12 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
-enum oom_status {
-	OOM_SUCCESS,
-	OOM_FAILED,
-	OOM_ASYNC,
-	OOM_SKIPPED
-};
-
-static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	enum oom_status ret;
-	bool locked;
+	bool locked, ret = false;
 
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		return OOM_SKIPPED;
+		return ret;
 
 	memcg_memory_event(memcg, MEMCG_OOM);
 
@@ -1831,14 +1823,13 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 	 * victim and then we have to bail out from the charge path.
 	 */
 	if (memcg->oom_kill_disable) {
-		if (!current->in_user_fault)
-			return OOM_SKIPPED;
-		css_get(&memcg->css);
-		current->memcg_in_oom = memcg;
-		current->memcg_oom_gfp_mask = mask;
-		current->memcg_oom_order = order;
-
-		return OOM_ASYNC;
+		if (current->in_user_fault) {
+			css_get(&memcg->css);
+			current->memcg_in_oom = memcg;
+			current->memcg_oom_gfp_mask = mask;
+			current->memcg_oom_order = order;
+		}
+		return ret;
 	}
 
 	mem_cgroup_mark_under_oom(memcg);
@@ -1849,10 +1840,7 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 		mem_cgroup_oom_notify(memcg);
 
 	mem_cgroup_unmark_under_oom(memcg);
-	if (mem_cgroup_out_of_memory(memcg, mask, order))
-		ret = OOM_SUCCESS;
-	else
-		ret = OOM_FAILED;
+	ret = mem_cgroup_out_of_memory(memcg, mask, order);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
@@ -2545,7 +2533,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	bool may_swap = true;
@@ -2648,9 +2635,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * a forward progress or bypass the charge if the oom killer
 	 * couldn't make any progress.
 	 */
-	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
-		       get_order(nr_pages * PAGE_SIZE));
-	if (oom_status == OOM_SUCCESS) {
+	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
+			   get_order(nr_pages * PAGE_SIZE))) {
 		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
-- 
2.35.1.265.g69c8d7142f-goog

