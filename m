From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg 3/3] memcg: handle memcg oom failures
Date: Wed, 20 Oct 2021 15:14:27 +0300
Message-ID: <fb33f4bd-34cd-2187-eff4-7c1c11d5ae94@virtuozzo.com>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=vKfgRv2zJEAoAS/QMp8Ojy3ytr5x5Kwda6HCzY+o9dY=; b=piFq4YJOVCzthmB9i6b
        NgU9AF9sxMXuXUshwNGUqc8UUt7jOsEyjWpz7crmMVUVecu7tMqQloOLCOHVflMvVpfVsy94enpjs
        38aVbuXoEwvwIBMuS1SZMSPcfMeMLX5W7o9phEpjbW/bnnHEfFKouHYb3wZ6hDngTOJJSojLDVQ=;
In-Reply-To: <cover.1634730787.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

mem_cgroup_oom() can fail if current task was marked unkillable
and oom killer cannot find any victim.

Currently we force memcg charge for such allocations,
however it allow memcg-limited userspace task in to overuse assigned limits
and potentially trigger the global memory shortage.

Let's fail the memory charge in such cases.

This failure should be somehow recognised in #PF context,
so let's use current->memcg_in_oom == (struct mem_cgroup *)OOM_FAILED

ToDo: what is the best way to notify pagefault_out_of_memory() about 
    mem_cgroup_out_of_memory failure ?

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/memcontrol.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 74a7379dbac1..b09d3c64f63f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1810,11 +1810,21 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 		mem_cgroup_oom_notify(memcg);
 
 	mem_cgroup_unmark_under_oom(memcg);
-	if (mem_cgroup_out_of_memory(memcg, mask, order))
+	if (mem_cgroup_out_of_memory(memcg, mask, order)) {
 		ret = OOM_SUCCESS;
-	else
+	} else {
 		ret = OOM_FAILED;
-
+		/*
+		 * In some rare cases mem_cgroup_out_of_memory() can return false.
+		 * If it was called from #PF it forces handle_mm_fault()
+		 * return VM_FAULT_OOM and executes pagefault_out_of_memory().
+		 * memcg_in_oom is set here to notify pagefault_out_of_memory()
+		 * that it was a memcg-related failure and not allow to run
+		 * global OOM.
+		 */
+		if (current->in_user_fault)
+			current->memcg_in_oom = (struct mem_cgroup *)ret;
+	}
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
 
@@ -1848,6 +1858,15 @@ bool mem_cgroup_oom_synchronize(bool handle)
 	if (!memcg)
 		return false;
 
+	/* OOM is memcg, however out_of_memory() found no victim */
+	if (memcg == (struct mem_cgroup *)OOM_FAILED) {
+		/*
+		 * Should be called from pagefault_out_of_memory() only,
+		 * where it is used to prevent false global OOM.
+		 */
+		current->memcg_in_oom = NULL;
+		return true;
+	}
 	if (!handle)
 		goto cleanup;
 
@@ -2633,15 +2652,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
-	switch (oom_status) {
-	case OOM_SUCCESS:
+	if (oom_status == OOM_SUCCESS) {
 		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
-	case OOM_FAILED:
-		goto force;
-	default:
-		goto nomem;
 	}
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
-- 
2.32.0

