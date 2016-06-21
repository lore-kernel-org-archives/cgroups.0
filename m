From: Kenny Yu <kennyyu@fb.com>
Subject: [PATCH v2] cgroup: Add pids controller event when fork fails because of pid limit
Date: Tue, 21 Jun 2016 09:01:34 -0700
Message-ID: <1466524894-3303517-1-git-send-email-kennyyu@fb.com>
References: <20160621044429.GA19501@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Q7MSYGCpQ0IP4ANcvtSTSWYoqKOvO7QZEojNMWWrYlg=;
 b=nLknidmEpdUY+FfvKDPw1M2+e2USi2jqGoYUOUexlmH7HrafmHVXs9hh06KC513kF/9h
 Wchq9bBYosoxPy5wUgKNbOuteUmjYFCISNfhNKZ5oKxCU2FFUBd8mcTjBl2bJr1IqcXt
 2FtlQ5WXFj3+Q0P+JV2WX8XCCl4ZTLm6IQE= 
In-Reply-To: <20160621044429.GA19501@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cyphar@cyphar.com
Cc: kennyyu@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Summary:
This patch adds more visibility into the pids controller when the controller
rejects a fork request. Whenever fork fails because the limit on the number of
pids in the cgroup is reached, the controller will log this and also notify the
newly added cgroups events file. The `max` key in the events file represents
the number of times fork failed because of the pids controller.

This change also adds an atomic boolean to prevent logging too much (e.g. a fork
bomb). The message is logged once per cgroup until the next time the pids limit
changes.

Signed-off-by: Kenny Yu <kennyyu@fb.com>
Acked-by: Johannes Weiner <hannes <at> cmpxchg.org>
---
 kernel/cgroup_pids.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index b93cbe3..412f4d8 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -49,6 +49,18 @@ struct pids_cgroup {
 	 */
 	atomic64_t			counter;
 	int64_t				limit;
+
+	/* Handle for "pids.events" */
+	struct cgroup_file		events_file;
+
+	/* Number of times fork failed because limit was hit. */
+	atomic64_t			events_limit;
+
+	/*
+	 * To avoid logging too much (e.g. during a fork bomb), log only once
+	 * per cgroup and reset this when the limit changes.
+	 */
+	atomic_t			events_limit_logged;
 };
 
 static struct pids_cgroup *css_pids(struct cgroup_subsys_state *css)
@@ -72,6 +84,8 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->events_limit, 0);
+	atomic_set(&pids->events_limit_logged, 0);
 	return &pids->css;
 }
 
@@ -213,10 +227,21 @@ static int pids_can_fork(struct task_struct *task)
 {
 	struct cgroup_subsys_state *css;
 	struct pids_cgroup *pids;
+	int err;
 
 	css = task_css_check(current, pids_cgrp_id, true);
 	pids = css_pids(css);
-	return pids_try_charge(pids, 1);
+	err = pids_try_charge(pids, 1);
+	if (err) {
+		atomic64_inc(&pids->events_limit);
+		cgroup_file_notify(&pids->events_file);
+		if (!atomic_xchg(&pids->events_limit_logged, 1)) {
+			pr_info("cgroup: fork rejected by pids controller in ");
+			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
+			pr_cont("\n");
+		}
+	}
+	return err;
 }
 
 static void pids_cancel_fork(struct task_struct *task)
@@ -263,6 +288,7 @@ set_limit:
 	 * critical that any racing fork()s follow the new limit.
 	 */
 	pids->limit = limit;
+	atomic_set(&pids->events_limit_logged, 0);
 	return nbytes;
 }
 
@@ -288,6 +314,14 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
 	return atomic64_read(&pids->counter);
 }
 
+static int pids_events_show(struct seq_file *sf, void *v)
+{
+	struct pids_cgroup *pids = css_pids(seq_css(sf));
+
+	seq_printf(sf, "max %ld\n", atomic64_read(&pids->events_limit));
+	return 0;
+}
+
 static struct cftype pids_files[] = {
 	{
 		.name = "max",
@@ -299,6 +333,12 @@ static struct cftype pids_files[] = {
 		.name = "current",
 		.read_s64 = pids_current_read,
 	},
+	{
+		.name = "events",
+		.seq_show = pids_events_show,
+		.file_offset = offsetof(struct pids_cgroup, events_file),
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.8.0.rc2

