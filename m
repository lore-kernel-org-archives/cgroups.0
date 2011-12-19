From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Date: Mon, 19 Dec 2011 16:51:46 +0900
Message-ID: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From d620ff605a3a592c2b1de3a046498ce5cd3d3c50 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Mon, 19 Dec 2011 16:55:10 +0900
Subject: [PATCH 2/2] memcg: reset lru to root_mem_cgroup in special cases.

This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch

After the patch, all pages which will be onto LRU must have sane
pc->mem_cgroup. But, in special case, it's not set.

If task->mm is NULL or task is TIF_MEMDIE or fatal_signal_pending(),
try_charge() is bypassed and the new charge will not be charged. And
pc->mem_cgroup is unset even if the page will be used/mapped and added
to LRU. To avoid this,  this patch charges such pages to root_mem_cgroup,
then, pc->mem_cgroup will be handled correctly.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d6d21c..9268e8e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2324,7 +2324,7 @@ nomem:
 	*ptr = NULL;
 	return -ENOMEM;
 bypass:
-	*ptr = NULL;
+	*ptr = root_mem_cgroup;
 	return 0;
 }
 
-- 
1.7.4.1

