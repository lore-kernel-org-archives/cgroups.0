From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [PATCH 2/2] memcg: use vm_swappiness from current memcg
Date: Wed, 15 Feb 2012 20:28:34 +0400
Message-ID: <20120215162834.13902.37262.stgit@zurg>
References: <20120215162830.13902.60256.stgit@zurg>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        bh=RVLhIAHQLpCDKh5fp0PuiaHztk22mRDBU1knUwGR1J8=;
        b=v5/kwr+Ykst5/PcuJLWg/+XouY88axtX8ADxkaXWXe3xO890A2HdmeWXgJH8fXtCqh
         eoOYN5XPCKYat6VPmjZobIrGf7tNavd4flOwTuI4AvGh3V/jLP9nZHgK/JuWyPuhLc23
         VgnjFLJ++j1mCGPs4dMr1e6xCwyzow9kYcq+4=
In-Reply-To: <20120215162830.13902.60256.stgit@zurg>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

At this point this is always the same cgroup, but it allows to drop one argument.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b069fac..751fab3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1899,12 +1899,11 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	return shrink_inactive_list(nr_to_scan, mz, sc, priority, file);
 }
 
-static int vmscan_swappiness(struct mem_cgroup_zone *mz,
-			     struct scan_control *sc)
+static int vmscan_swappiness(struct scan_control *sc)
 {
 	if (global_reclaim(sc))
 		return vm_swappiness;
-	return mem_cgroup_swappiness(mz->mem_cgroup);
+	return mem_cgroup_swappiness(sc->current_mem_cgroup);
 }
 
 /*
@@ -1972,8 +1971,8 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = vmscan_swappiness(mz, sc);
-	file_prio = 200 - vmscan_swappiness(mz, sc);
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
