From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH 1/2] cgroup: pids: show number of failed forks since limit reset
Date: Fri, 24 Jun 2016 13:00:48 +1000
Message-ID: <20160624030049.13341-2-asarai@suse.de>
References: <20160624030049.13341-1-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160624030049.13341-1-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>

This allows users to dynamically adjust their limits based on how many
failed forks happened since they last reset their limits, otherwise they
would have to track (in a racy way) how many limit failures there were
since the last limit change manually. In addition, we log the first
failure since the limit was reset (which was the original semantics of
the patchset).

In addition, I clarified the licensing for this file.

Signed-off-by: Aleksa Sarai <asarai@suse.de>
---
 kernel/cgroup_pids.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 2bd673783f1a..54ec3e4f3b71 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -26,9 +26,10 @@
  *
  * Copyright (C) 2015 Aleksa Sarai <cyphar@cyphar.com>
  *
- * This file is subject to the terms and conditions of version 2 of the GNU
- * General Public License.  See the file COPYING in the main directory of the
- * Linux distribution for more details.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
  */
 
 #include <linux/kernel.h>
@@ -53,8 +54,11 @@ struct pids_cgroup {
 	/* Handle for "pids.events" */
 	struct cgroup_file		events_file;
 
-	/* Number of times fork failed because limit was hit. */
-	atomic64_t			events_limit;
+	/* Total number of times fork failed because limit was hit. */
+	atomic64_t			hits_total;
+
+	/* Number of times fork failed since limit was last set. */
+	atomic64_t			hits_since;
 };
 
 static struct pids_cgroup *css_pids(struct cgroup_subsys_state *css)
@@ -78,7 +82,8 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
-	atomic64_set(&pids->events_limit, 0);
+	atomic64_set(&pids->hits_total, 0);
+	atomic64_set(&pids->hits_since, 0);
 	return &pids->css;
 }
 
@@ -226,8 +231,12 @@ static int pids_can_fork(struct task_struct *task)
 	pids = css_pids(css);
 	err = pids_try_charge(pids, 1);
 	if (err) {
-		/* Only log the first time events_limit is incremented. */
-		if (atomic64_inc_return(&pids->events_limit) == 1) {
+		/*
+		 * We only log the first time a fork fails after a limit has
+		 * been set. Resetting the limit will cause us to log again.
+		 */
+		atomic64_inc(&pids->hits_total);
+		if (atomic64_inc_return(&pids->hits_since) == 1) {
 			pr_info("cgroup: fork rejected by pids controller in ");
 			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
 			pr_cont("\n");
@@ -281,6 +290,9 @@ set_limit:
 	 * critical that any racing fork()s follow the new limit.
 	 */
 	pids->limit = limit;
+	/* Reset the since counter and notify userspace. */
+	atomic64_set(&pids->hits_since, 0);
+	cgroup_file_notify(&pids->events_file);
 	return nbytes;
 }
 
@@ -310,7 +322,8 @@ static int pids_events_show(struct seq_file *sf, void *v)
 {
 	struct pids_cgroup *pids = css_pids(seq_css(sf));
 
-	seq_printf(sf, "max %lld\n", (s64)atomic64_read(&pids->events_limit));
+	seq_printf(sf, "since\t%lld\n", (s64)atomic64_read(&pids->hits_since));
+	seq_printf(sf, "total\t%lld\n", (s64)atomic64_read(&pids->hits_total));
 	return 0;
 }
 
-- 
2.8.4

