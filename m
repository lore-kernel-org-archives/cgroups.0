From: Topi Miettinen <toiwoton@gmail.com>
Subject: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 22:44:09 +0300
Message-ID: <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b7ut+CepENvEVHvt+W2BPFYqnoYer6axGAxTeHRLb+4=;
        b=0wSKsu6RZ0eC2CrvF8EshNu5SACte9VM+VuGPBwD27kkjJYpCpNGfwCYVLhayvA9HC
         187y0Ffk7V3NBbaeJma1p0HSgzG6PWBY4c3N13ASXZEw12zzvg/Q0ojmrleyISggEeVv
         AXRqhOp5gvu5lVAWc5cp/ndPOBWg69O9Fmt0U3pO0Wn1FiOL53qZCy2x+wxq6WyNFfc0
         9Zi2Ve/9ePkHQHykqBTT2DfU5HMvlAAjUO+sCUzTzHDhzdD26ws8Lm/XPe+WP3pJQBeE
         i8XnL3i3LgYnuX13EyN9wJpIa977uB6pk4y77WPhGTVUcikprHIbG1DMoVyxr43NueE8
         0JuQ==
In-Reply-To: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>

Track maximum pids in the cgroup, present it in cgroup pids.current_max.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 kernel/cgroup_pids.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 303097b..53fb21d 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -48,6 +48,7 @@ struct pids_cgroup {
 	 * %PIDS_MAX = (%PID_MAX_LIMIT + 1).
 	 */
 	atomic64_t			counter;
+	atomic64_t			cur_max;
 	int64_t				limit;
 };
 
@@ -72,6 +73,7 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->cur_max, 0);
 	return &pids->css;
 }
 
@@ -182,6 +184,10 @@ static int pids_can_attach(struct cgroup_taskset *tset)
 
 		pids_charge(pids, 1);
 		pids_uncharge(old_pids, 1);
+		if (atomic64_read(&pids->cur_max) <
+		    atomic64_read(&pids->counter))
+			atomic64_set(&pids->cur_max,
+				     atomic64_read(&pids->counter));
 	}
 
 	return 0;
@@ -202,6 +208,10 @@ static void pids_cancel_attach(struct cgroup_taskset *tset)
 
 		pids_charge(old_pids, 1);
 		pids_uncharge(pids, 1);
+		if (atomic64_read(&old_pids->cur_max) <
+		    atomic64_read(&old_pids->counter))
+			atomic64_set(&old_pids->cur_max,
+				     atomic64_read(&old_pids->counter));
 	}
 }
 
@@ -236,6 +246,14 @@ static void pids_free(struct task_struct *task)
 	pids_uncharge(pids, 1);
 }
 
+static void pids_fork(struct task_struct *task)
+{
+	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
+
+	if (atomic64_read(&pids->cur_max) < atomic64_read(&pids->counter))
+		atomic64_set(&pids->cur_max, atomic64_read(&pids->counter));
+}
+
 static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
@@ -288,6 +306,14 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
 	return atomic64_read(&pids->counter);
 }
 
+static s64 pids_current_max_read(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	struct pids_cgroup *pids = css_pids(css);
+
+	return atomic64_read(&pids->cur_max);
+}
+
 static struct cftype pids_files[] = {
 	{
 		.name = "max",
@@ -300,6 +326,11 @@ static struct cftype pids_files[] = {
 		.read_s64 = pids_current_read,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "current_max",
+		.read_s64 = pids_current_max_read,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
@@ -313,4 +344,5 @@ struct cgroup_subsys pids_cgrp_subsys = {
 	.free		= pids_free,
 	.legacy_cftypes	= pids_files,
 	.dfl_cftypes	= pids_files,
+	.fork		= pids_fork,
 };
-- 
2.8.1

