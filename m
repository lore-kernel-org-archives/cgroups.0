From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH UPDATED 02/14] memcg: remove tasks/children test from
 mem_cgroup_force_empty()
Date: Tue, 13 May 2014 14:51:35 -0400
Message-ID: <20140513185135.GB19514@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F29gqRZmxj7Ftwm8bR79/pIK6Zhtg7FV87xBsm1n/NQ=;
        b=hzV/TyNP8kKtxGtdLSHGm/bqhx0v213ScKZCDyhOKjaywO/KUDgWvaR1Aw1lxTUQ0U
         /LxVyKP7YuR6b1hohvVzUc1sUuqos5I2OYxUjpU3bH38R1YmJjXHfXOS4amdDozkPgn8
         wljPJBQovIhtX26MfpsDs9h13glQ+63clzbp1+gQSZNol7RzpgR/umKR8OawCETVPTJ7
         kJBZgQIyd6LWcGbEMGPYNhcWle3wbvtRKcSomnWf/n+JtWc0Icx6BO8jFk+jccnXaAEr
         B4KiQGV1jVvuo3efM9G1J3A0mGYYEWytvKZkOkSuNN9nHodi/fU46BfCb9MWlUa9ibDU
         3qng==
Content-Disposition: inline
In-Reply-To: <20140512145324.GE9564-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

From ff584991bd7a6beea591aa10bce1712eb6cef3d6 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Mon, 12 May 2014 16:34:17 +0200

Tejun has correctly pointed out that tasks/children test in
mem_cgroup_force_empty is not correct because there is no other locking
which preserves this state throughout the rest of the function so both
new tasks can join the group or new children groups can be added while
somebody is writing to memory.force_empty. A new task would break
mem_cgroup_reparent_charges expectation that all failures as described
by mem_cgroup_force_empty_list are temporal and there is no way out.

The main use case for the knob as described by
Documentation/cgroups/memory.txt is to:
"
  The typical use case for this interface is before calling rmdir().
  Because rmdir() moves all pages to parent, some out-of-use page caches can be
  moved to the parent. If you want to avoid that, force_empty will be useful.
"

This means that reparenting is not really required as rmdir will
reparent pages implicitly from the safe context. If we remove it from
mem_cgroup_force_empty then we are safe even with existing tasks because
the number of reclaim attempts is bounded. Moreover the knob still does
what the documentation claims (modulo reparenting which doesn't make any
difference) and users might expect. Longterm we want to deprecate the
whole knob and put the reparented pages to the tail of parent LRU during
cgroup removal.

tj: Removed unused variable @cgrp from mem_cgroup_force_empty()

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroups/memory.txt | 6 +-----
 mm/memcontrol.c                  | 7 -------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 2622115..8cb87e3 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -453,15 +453,11 @@ About use_hierarchy, see Section 6.
 
 5.1 force_empty
   memory.force_empty interface is provided to make cgroup's memory usage empty.
-  You can use this interface only when the cgroup has no tasks.
   When writing anything to this
 
   # echo 0 > memory.force_empty
 
-  Almost all pages tracked by this memory cgroup will be unmapped and freed.
-  Some pages cannot be freed because they are locked or in-use. Such pages are
-  moved to parent (if use_hierarchy==1) or root (if use_hierarchy==0) and this
-  cgroup will be empty.
+  the cgroup will be reclaimed and as many pages reclaimed as possible.
 
   The typical use case for this interface is before calling rmdir().
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a5e0417..6144a8e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4857,11 +4857,6 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct cgroup *cgrp = memcg->css.cgroup;
-
-	/* returns EBUSY if there is a task or if we come here twice. */
-	if (cgroup_has_tasks(cgrp) || !list_empty(&cgrp->children))
-		return -EBUSY;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -4881,8 +4876,6 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 		}
 
 	}
-	lru_add_drain();
-	mem_cgroup_reparent_charges(memcg);
 
 	return 0;
 }
-- 
1.9.0
