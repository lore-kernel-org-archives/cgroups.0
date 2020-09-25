From: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] mm: fix some comments in page_alloc.c and mempolicy.c
Date: Sat, 26 Sep 2020 00:06:50 +0800
Message-ID: <20200925160650.GA42847@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=TPYFb
        PSp4V8vYQ4z0mS+XWUEYAjUGpB+g/xY+pc+6GE=; b=PVQYhqPDCUwiAEdCTv3nZ
        UM+WBwcstQfT/KMzCBTVXr5/Obw6/vTsN3e/TxWPG8kZ6Rs2ZRplwls5wzjfy5Lw
        +668EgpaU6EqLwJvcPjwdcOjjC5Cy1YB7H7L4iPdmgcPN7OO3OLqteOKxjsZ9xbN
        6FwYolGypdX4NBacz+rx58=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

1. the cpuset.c has been moved from kernel/cpuset.c to
kernel/cgroup/cpuset.c long time ago, but the comment is stale,
so we update it.
2. get_page_from_freelist() may alloc many pages according to
order, we may use pages for better.

Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 mm/mempolicy.c         | 2 +-
 mm/page_alloc.c        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 642415b8c3c9..1d3011c1aab6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1,5 +1,5 @@
 /*
- *  kernel/cpuset.c
+ *  kernel/cgroup/cpuset.c
  *
  *  Processor and Memory placement constraints for sets of tasks.
  *
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eddbe4e56c73..ac59b049b16c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2295,7 +2295,7 @@ int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
  * rebinds the mempolicy its copying by calling mpol_rebind_policy()
  * with the mems_allowed returned by cpuset_mems_allowed().  This
  * keeps mempolicies cpuset relative after its cpuset moves.  See
- * further kernel/cpuset.c update_nodemask().
+ * further kernel/cgroup/cpuset.c update_nodemask().
  *
  * current's mempolicy may be rebinded by the other task(the task that changes
  * cpuset's mems), so we needn't do rebind work for current task.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fab5e97dc9ca..1e3c7493e1cb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3709,7 +3709,7 @@ static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
 
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
- * a page.
+ * pages.
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
@@ -3723,7 +3723,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
-- 
2.25.1


