From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH -mm 1/2] memcg: remove unused mem_cgroup->oom_wakeups
Date: Wed, 3 Jun 2015 11:38:24 +0900
Message-ID: <20150603023824.GA7579@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=PWnVB00qINJsjvDqd3FkHSuchfuUXIgQYcKO1w2FxiI=;
        b=ZoxYi9/O02uU+sVrDTzqS7cxBLuqtjB8S3kS3oR3lkAWlsM3u/SX8xxOSz1D/0+GYD
         vURrbWsGwst8JnQs4sOG6knH0pTB/ptYbdjTN8XrAGz//x0DFuCFEM//dOs2pG+mDcgT
         lTTBfFQp5crpZ2bI0lsnZDq+axOpf8Ytf2Ad6jHiS5bAXrHePSO39PrW892NWmkZB7v2
         Rw1kPVM+5x7fm4WdIQan2aH+EeJDRITkuX+GeIeU5NIWllvtvAuKHovjLFFgf3ESwJsD
         n8mVmv84+f2ElR2QklUofRklAs4Xm74JnIhFQMvlH/PnayqhLDV+IBt/a5PdiB9D183b
         Ji2Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From 92c2a5d90ecc5eeed0224a8f6ba533c621ac3ffa Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 2 Jun 2015 09:29:11 -0400

Since 4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully"), nobody uses mem_cgroup->oom_wakeups.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86648a7..9f39647 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -287,7 +287,6 @@ struct mem_cgroup {
 
 	bool		oom_lock;
 	atomic_t	under_oom;
-	atomic_t	oom_wakeups;
 
 	int	swappiness;
 	/* OOM-Killer disable */
@@ -1852,7 +1851,6 @@ static int memcg_oom_wake_function(wait_queue_t *wait,
 
 static void memcg_wakeup_oom(struct mem_cgroup *memcg)
 {
-	atomic_inc(&memcg->oom_wakeups);
 	/* for filtering, pass "memcg" as argument. */
 	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
-- 
2.4.2
