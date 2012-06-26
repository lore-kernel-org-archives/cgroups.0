From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch 1/3] mm, oom: move declaration for mem_cgroup_out_of_memory
 to oom.h
Date: Mon, 25 Jun 2012 18:47:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        bh=nHWaZIPaQa8aOw04idMvARvHvJ0rpPV4JPGIVq5BsAc=;
        b=djObOHFxaL0mHMmdAsz4UPrwLBpBLkxqYB15qq3sQjNPshyZJRTz0AsPXXWCINt4W2
         ouZ8OGBFkLWQwNMzupifjEh8e9lhs5HMud92Vqy9rHAGBN87KJiF4cxhv1TG+kW5Jzri
         E853DO5dxuqSPnUVX22X/lwWFXVXUMhCVE8BXDF4Q86ia0PyDumHTp7zAjFSH/FHa9zX
         kiUpTE4cqbiM/HeXVVd0oRSkPaNb+QGttHU7LSrVp4C81tJy2IqBtKdPLGp/QKhVd9Vw
         lx6JuAo+oOeJwCFVJ92/T9VvVP4aLtH9fHj45veLwWjfHJcrRgCWNmLVbPmqG27vF14U
         pkww==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

mem_cgroup_out_of_memory() is defined in mm/oom_kill.c, so declare it in
linux/oom.h rather than linux/memcontrol.h.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |    2 --
 include/linux/oom.h        |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -72,8 +72,6 @@ extern void mem_cgroup_uncharge_end(void);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 
-extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order);
 bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 				  struct mem_cgroup *memcg);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -49,6 +49,8 @@ extern unsigned long oom_badness(struct task_struct *p,
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				     int order);
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
