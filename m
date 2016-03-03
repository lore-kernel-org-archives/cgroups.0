From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: move migration destination verification out of cgroup_migrate_prepare_dst()
Date: Thu,  3 Mar 2016 12:20:00 -0500
Message-ID: <1457025602-4193-3-git-send-email-tj@kernel.org>
References: <1457025602-4193-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M1cnPs9skoKI1v/MsN7lYdSk0xgI8Qx9SSd3XuJCN44=;
        b=gLJk0lT275vg6yomXrCqp0rgvwejm1BhocfdX8Rkj+H80QqbbCQwLBZe3qvIc1EsmF
         6gnY13rQS05/0xzLaMqL8lnEhChxPHGusFryRDLvG9VRjVtfubDBazIjizy+3cy2cO/5
         l9nY8Zcd4CgRgXl1D3xc+v3cPd4Yln53sAMs5mXfwJ5UlVoTemcejUUWUCyMSfmkYfA1
         wI2rH8fV/hODl1CxExkAEonRM5c0f5eqj6HuhL3tDcY3+6WfngERlL5//of82cxu74Ew
         QVzBy81HnCHqGSi16DQmO/om3aG0Fi961czctNHN7eKekf2W7CkgHcommaAMCO0O6pRy
         fd5g==
In-Reply-To: <1457025602-4193-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_migrate_prepare_dst() verifies whether the destination cgroup
is allowable; however, the test doesn't really belong there.  It's too
deep and common in the stack and as a result the test itself is gated
by another test.

Separate the test out into cgroup_may_migrate_to() and update
cgroup_attach_task() and cgroup_transfer_tasks() to perform the test
directly.  This doesn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 50879aa..8a02076 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2444,6 +2444,20 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 }
 
 /**
+ * cgroup_may_migrate_to - verify whether a cgroup can be migration destination
+ * @dst_cgrp: destination cgroup to test
+ *
+ * On the default hierarchy, except for the root, subtree_control must be
+ * zero for migration destination cgroups with tasks so that child cgroups
+ * don't compete against tasks.
+ */
+static bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
+{
+	return !cgroup_on_dfl(dst_cgrp) || !cgroup_parent(dst_cgrp) ||
+		!dst_cgrp->subtree_control;
+}
+
+/**
  * cgroup_migrate_finish - cleanup after attach
  * @preloaded_csets: list of preloaded css_sets
  *
@@ -2529,14 +2543,6 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	/*
-	 * Except for the root, subtree_control must be zero for a cgroup
-	 * with tasks so that child cgroups don't compete against tasks.
-	 */
-	if (dst_cgrp && cgroup_on_dfl(dst_cgrp) && cgroup_parent(dst_cgrp) &&
-	    dst_cgrp->subtree_control)
-		return -EBUSY;
-
 	/* look up the dst cset for each src cset and link it to src */
 	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		struct css_set *dst_cset;
@@ -2634,6 +2640,9 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	struct task_struct *task;
 	int ret;
 
+	if (!cgroup_may_migrate_to(dst_cgrp))
+		return -EBUSY;
+
 	/* look up all src csets */
 	spin_lock_bh(&css_set_lock);
 	rcu_read_lock();
@@ -4136,6 +4145,9 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	struct task_struct *task;
 	int ret;
 
+	if (!cgroup_may_migrate_to(to))
+		return -EBUSY;
+
 	mutex_lock(&cgroup_mutex);
 
 	/* all tasks in @from are being moved, all csets are source */
-- 
2.5.0

