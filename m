From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/3] cgroup: fix umount vs cgroup_event_remove() race
Date: Tue, 18 Jun 2013 18:41:10 +0800
Message-ID: <51C03946.5050707@huawei.com>
References: <51C03913.5020008@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51C03913.5020008@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

commit 5db9a4d99b0157a513944e9a44d29c9cec2e91dc
Author: Tejun Heo <tj@kernel.org>
Date:   Sat Jul 7 16:08:18 2012 -0700

    cgroup: fix cgroup hierarchy umount race

This commit fixed a race caused by the dput() in css_dput_fn(), but
the dput() in cgroup_event_remove() can also lead to the same BUG().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 482252a..e2dcf08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3812,6 +3812,23 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
 }
 
 /*
+ * When dput() is called asynchronously, if umount has been done and
+ * then deactivate_super() in cgroup_free_fn() kills the superblock,
+ * there's a small window that vfs will see the root dentry with non-zero
+ * refcnt and trigger BUG().
+ *
+ * That's why we hold a reference before dput() and drop it right after.
+ */
+static void cgroup_dput(struct cgroup *cgrp)
+{
+	struct super_block *sb = cgrp->root->sb;
+
+	atomic_inc(&sb->s_active);
+	dput(cgrp->dentry);
+	deactivate_super(sb);
+}
+
+/*
  * Unregister event and free resources.
  *
  * Gets called from workqueue.
@@ -3831,7 +3848,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	dput(cgrp->dentry);
+	cgroup_dput(cgrp);
 }
 
 /*
@@ -4119,12 +4136,8 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
-	struct dentry *dentry = css->cgroup->dentry;
-	struct super_block *sb = dentry->d_sb;
 
-	atomic_inc(&sb->s_active);
-	dput(dentry);
-	deactivate_super(sb);
+	cgroup_dput(css->cgroup);
 }
 
 static void css_release(struct percpu_ref *ref)
-- 
1.8.0.2
