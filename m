From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 1/2] memcg: remove -EINTR at rmdir()
Date: Mon, 18 Jun 2012 20:57:23 +0900
Message-ID: <4FDF17A3.9060202@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

2 follow-up patches for "memcg: move charges to root cgroup if use_hierarchy=0",
developped/tested onto memcg-devel tree. Maybe no HUNK with -next and -mm....
-Kame
==
memcg: remove -EINTR at rmdir()

By commit "memcg: move charges to root cgroup if use_hierarchy=0",
no memory reclaiming will occur at removing memory cgroup.

So, we don't need to take care of user interrupt by signal. This
patch removes it.
(*) If -EINTR is returned here, cgroup will show WARNING.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0623300..cf8a0f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3890,9 +3890,6 @@ move_account:
 		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
-		ret = -EINTR;
-		if (signal_pending(current))
-			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
-- 
1.7.4.1

