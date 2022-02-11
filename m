From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] memcg: refactor mem_cgroup_oom
Date: Thu, 10 Feb 2022 22:49:14 -0800
Message-ID: <20220211064917.2028469-2-shakeelb@google.com>
References: <20220211064917.2028469-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nDUa4nh0VfMB33PiEe/+b8nW+DWgiuCX8+o5RVf1oHI=;
        b=ThzYMOIDPOykUabiB3RlRAijrJSIHNXOSUgcmlKL4c2HDkyKp7qaJwrCrOB5Cj7/Sn
         b+6g0BlcsH3JRNO1HyBb0LIliKk840gqIqgFjHZyfba+0Rzygu2PqymxQgM8gR9yQfI2
         UsYHiVjl75cre377AqUX4YDmZQbFTuUf3922omgktt3jvQUKmwr3eB7X7/Z19Ju1H4ex
         PjrES1T9lJwMXV5jyWjXRhmiR+2EhxtUnHDoQdtmgniawP0Vl+SgjVunv4BNLBp8DepV
         bZ7c1Ro3WZr7RdhwOGLkLCIGOQPDT8YXV3AJpris0GtceJxuIoOltOYgpfluZ3rotD5S
         G5vg==
In-Reply-To: <20220211064917.2028469-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The function mem_cgroup_oom returns enum which has four possible values
but the caller does not care about such values and only cares if the
return value is OOM_SUCCESS or not. So, remove the enum altogether and
make mem_cgroup_oom returns a simple bool.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
Changes since v1:
- Added comment for mem_cgroup_oom as suggested by Roman

 mm/memcontrol.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a0e9d9f12cf5..f12e489ba9b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1795,20 +1795,16 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
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
+/*
+ * Returns true if successfully killed one or more processes. Though in some
+ * corner cases it can return true even without killing any process.
+ */
+static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	enum oom_status ret;
-	bool locked;
+	bool locked, ret;
 
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
-		return OOM_SKIPPED;
+		return false;
 
 	memcg_memory_event(memcg, MEMCG_OOM);
 
@@ -1831,14 +1827,13 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
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
+		return false;
 	}
 
 	mem_cgroup_mark_under_oom(memcg);
@@ -1849,10 +1844,7 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 		mem_cgroup_oom_notify(memcg);
 
 	mem_cgroup_unmark_under_oom(memcg);
-	if (mem_cgroup_out_of_memory(memcg, mask, order))
-		ret = OOM_SUCCESS;
-	else
-		ret = OOM_FAILED;
+	ret = mem_cgroup_out_of_memory(memcg, mask, order);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
@@ -2545,7 +2537,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	bool may_swap = true;
@@ -2648,9 +2639,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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

