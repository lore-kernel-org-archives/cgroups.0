From: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v3] cgroup: Add pids controller event when fork fails because of pid limit
Date: Tue, 21 Jun 2016 09:56:38 -0700
Message-ID: <1466528198-3416939-1-git-send-email-kennyyu@fb.com>
References: <20160621163402.GI3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=hKsEuFD6ukMPqR5E1Qx85yT7y35SNjLGRvuRIIATKpU=;
 b=aUycL7KK6A49QD1G2HDD2DC55f+coHVPw0B60nPBvuPqtaUF2ZLI8zESDABA/kXbuUlp
 3qHllue+n82devsE3aP5yUlyX8AqzrIdhBECnvTmcXc0n7NeFVHvhLw/T9H7W4PSPJfN
 9cNbTadSTgLkeJfDtZJxvUHGDeZnAqHjB04= 
In-Reply-To: <20160621163402.GI3262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org
Cc: kennyyu-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Summary:
This patch adds more visibility into the pids controller when the controller
rejects a fork request. Whenever fork fails because the limit on the number of
pids in the cgroup is reached, the controller will log this and also notify the
newly added cgroups events file. The `max` key in the events file represents
the number of times fork failed because of the pids controller.

This change also adds an atomic boolean to prevent logging too much (e.g. a fork
bomb). The message is logged once per cgroup until the next time the pids limit
changes.

Signed-off-by: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Acked-by: Johannes Weiner <hannes <at> cmpxchg.org>
---
 kernel/cgroup_pids.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index b93cbe3..74cb0fe 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -49,6 +49,12 @@ struct pids_cgroup {
 	 */
 	atomic64_t			counter;
 	int64_t				limit;
+
+	/* Handle for "pids.events" */
+	struct cgroup_file		events_file;
+
+	/* Number of times fork failed because limit was hit. */
+	atomic64_t			events_limit;
 };
 
 static struct pids_cgroup *css_pids(struct cgroup_subsys_state *css)
@@ -72,6 +78,7 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->events_limit, 0);
 	return &pids->css;
 }
 
@@ -213,10 +220,23 @@ static int pids_can_fork(struct task_struct *task)
 {
 	struct cgroup_subsys_state *css;
 	struct pids_cgroup *pids;
+	int err;
+	int events_limit;
 
 	css = task_css_check(current, pids_cgrp_id, true);
 	pids = css_pids(css);
-	return pids_try_charge(pids, 1);
+	err = pids_try_charge(pids, 1);
+	if (err) {
+		events_limit = atomic64_inc_return(&pids->events_limit);
+		cgroup_file_notify(&pids->events_file);
+		/* Only log the first time events_limit is incremented. */
+		if (events_limit == 1) {
+			pr_info("cgroup: fork rejected by pids controller in ");
+			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
+			pr_cont("\n");
+		}
+	}
+	return err;
 }
 
 static void pids_cancel_fork(struct task_struct *task)
@@ -288,6 +308,14 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
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
@@ -299,6 +327,12 @@ static struct cftype pids_files[] = {
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
