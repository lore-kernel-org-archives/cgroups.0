From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: Clean up cpuset_node_allowed
Date: Tue, 28 Feb 2023 08:35:37 +0000
Message-ID: <20230228083537.102665-1-haifeng.xu@shopee.com>
References: <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1677573356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2m9p8ihrgSqCDLIO8jAiryGx9X7hvTIbRelvVFuou64=;
        b=ACFBaQ8L7Rvd7Z7rTp6gb6TlTYlIHT8zfbAJbVa5AcagjWCt/hdH7FhHf0GD6crqoE
         l5z9Qo4ohzq6CKtz8NFnvbWScdY6X71MaG5/p8csSeWuKhQY4BGzlPfQCFhr/iuoBXTe
         KdMAxa3t8Pg1o9Rq+V/gS+Z8ztASY/N2CJd9YQyU6fyPt1fBeNsKL5D27po31Ulr26hV
         MMNcia3bHxxOLR9mLr08+5z20nDuCRI4xROWT9en3Ph2q41ETXd794o60DBDnwsMplUj
         89cgOw8VNBEQT9qPIZ8E1BwDKyIfJLJAnoo4hUQk4J1IT0VikSHe9VtfV7LFDOosZo8M
         cc6w==
In-Reply-To: <9953284e-05da-56b0-047d-ecf18aa53892-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
has used __cpuset_node_allowed() instead of cpuset_node_allowed() to check
whether we can allocate on a memory node. Now this function isn't used by
anyone, so we can do the follow things to clean up it.

1. remove unused codes
2. rename __cpuset_node_allowed() to cpuset_node_allowed()
3. update comments in mm/page_alloc.c

Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cpuset.h | 16 ++--------------
 kernel/cgroup/cpuset.c |  4 ++--
 mm/page_alloc.c        |  4 ++--
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index d58e0476ee8e..980b76a1237e 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -80,18 +80,11 @@ extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 void cpuset_init_current_mems_allowed(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
-
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	if (cpusets_enabled())
-		return __cpuset_node_allowed(node, gfp_mask);
-	return true;
-}
+extern bool cpuset_node_allowed(int node, gfp_t gfp_mask);
 
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
-	return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
+	return cpuset_node_allowed(zone_to_nid(z), gfp_mask);
 }
 
 static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
@@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 	return 1;
 }
 
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	return true;
-}
-
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
 	return true;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 636f1c682ac0..0241b07d6f21 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3831,7 +3831,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
 }
 
 /*
- * __cpuset_node_allowed - Can we allocate on a memory node?
+ * cpuset_node_allowed - Can we allocate on a memory node?
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
@@ -3870,7 +3870,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  */
-bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
+bool cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
 	bool allowed;			/* is allocation in zone z allowed? */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3bb3484563ed..0d170ae590d8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4175,7 +4175,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
+	 * See also cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
@@ -4843,7 +4843,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 			alloc_flags |= ALLOC_HARDER;
 		/*
 		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
-		 * comment for __cpuset_node_allowed().
+		 * comment for cpuset_node_allowed().
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && in_task())
-- 
2.25.1

