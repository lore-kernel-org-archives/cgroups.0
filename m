From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] cgroup: Add memory barriers to plug cgroup_rstat_updated() race window
Date: Fri, 23 Mar 2018 16:13:13 -0700
Message-ID: <20180323231313.1254142-9-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=451ZUnYHZwxwIvzxod5IijT9VQcgy3AzhdkdTZSaapw=;
        b=dWdaIH7DWisCSFxVD3J3HM2fgyEHbO1IYrrnhgKqiE14YLWGUif/f3FFmCG43RNpsX
         P54vZOe6xQw/gjAWhZaU3iTgdqcJ64oXUmgDcY2N6WCgZtX4eul7pQs2W/dkeTFWHOyW
         fdaO+KshznUT7hTikk2xQYHFCzLxpfCbqtyU+jN2R+C/X35vtkYY1T0U19CgQNEVbO9U
         IXBpSkJhUrUg2MIgZ/7BXon57rPOkamQ25NQkCZXLeyuu4hBxP5mv7DtN436vL6WkRKS
         kVbhIfw8V9ReKiJ6q3HMeCIuaaJDFiuA0butatDsV1Dgdgq4MKIo0L9ErPCU6nlwQhUM
         44BQ==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_rstat_updated() has a small race window where an updated
signaling can race with flush and could be lost till the next update.
This wasn't a problem for the existing usages, but we plan to use
rstat to track counters which need to be accurate.

This patch plugs the race window by synchronizing
cgroup_rstat_updated() and flush path with memory barriers around
cgroup_rstat_cpu->updated_next pointer.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/rstat.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 18b464a..662d7ae 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -28,9 +28,12 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	unsigned long flags;
 
 	/*
-	 * Speculative already-on-list test.  This may race leading to
-	 * temporary inaccuracies, which is fine.
-	 *
+	 * Paired with the one in cgroup_rstat_cpu_pop_upated().  Either we
+	 * see NULL updated_next or they see our updated stat.
+	 */
+	smp_mb();
+
+	/*
 	 * Because @parent's updated_children is terminated with @parent
 	 * instead of NULL, we can tell whether @cgrp is on the list by
 	 * testing the next pointer for NULL.
@@ -125,6 +128,13 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 
 		*nextp = rstatc->updated_next;
 		rstatc->updated_next = NULL;
+
+		/*
+		 * Paired with the one in cgroup_rstat_cpu_updated().
+		 * Either they see NULL updated_next or we see their
+		 * updated stat.
+		 */
+		smp_mb();
 	}
 
 	return pos;
-- 
2.9.5

