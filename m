From: Hao Jia <jiahao.os@bytedance.com>
Subject: [PATCH] cgroup: rstat: Simplified cgroup_base_stat_flush() update last_bstat logic
Date: Thu, 18 May 2023 20:41:42 +0800
Message-ID: <20230518124142.57644-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684413710; x=1687005710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G7R4w9fF0O96j6E7s3O266tf7WZDrfjpg6MXApwCsXo=;
        b=G337Jniv8+DJ0J/DvJ6ENbRKNs4k874YWBFd2ohEIzp0ds70nTGJ60CnbM/XKAyfe1
         BMzS7qgPK5UE40CrXFR+Dvjh5EKuLqcO6Epl6XiK879eDQMZ1wEnxro4lSDJoXzjRv0E
         XS39RR1GE2RxAlk8KtWS5z4p8Z8icCnHkFEr3X9FPv83Ik8dr5WBwusUrHN3Gke4l/ql
         OIkEwvQr5+VQGQtMZtJGeKJKjZJNXorI0J84gW+ZaEtvP1B/05L5RxoY7l824zKUzYXc
         WYnSl5UTbNw0lHsPJxovLA4cOdKi8pbkoOVedeC7LOd0eHTV4DvDVLvhSGWAhjkaeNYt
         hM6Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Jia <jiahao.os@bytedance.com>

In cgroup_base_stat_flush() function, {rstatc, cgrp}->last_bstat
needs to be updated to the current {rstatc, cgrp}->bstat, directly
assigning values instead of adding the last value to delta.

Signed-off-by: Hao Jia <jiahao.os@bytedance.com>
---
 kernel/cgroup/rstat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9c4c55228567..3e5c4c1c92c6 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -376,14 +376,14 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 	/* propagate percpu delta to global */
 	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
 	cgroup_base_stat_add(&cgrp->bstat, &delta);
-	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
+	rstatc->last_bstat = rstatc->bstat;
 
 	/* propagate global delta to parent (unless that's root) */
 	if (cgroup_parent(parent)) {
 		delta = cgrp->bstat;
 		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
 		cgroup_base_stat_add(&parent->bstat, &delta);
-		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
+		cgrp->last_bstat = cgrp->bstat;
 	}
 }
 
-- 
2.37.0

