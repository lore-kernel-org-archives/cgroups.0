From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/3] cgroup: fix locking in cgroupstats_build()
Date: Fri, 14 Feb 2014 16:54:28 +0800
Message-ID: <52FDD9C4.1070001@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

css_set_lock has been converted to css_set_rwsem, and rwsem can't
nested inside rcu_read_lock.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index af4ecc3..0e794ca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2997,6 +2997,8 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	    kernfs_type(kn) != KERNFS_DIR)
 		return -EINVAL;
 
+	mutex_lock(&cgroup_mutex);
+
 	/*
 	 * We aren't being called from kernfs and there's no guarantee on
 	 * @kn->priv's validity.  For this and css_tryget_from_dir(),
@@ -3004,10 +3006,12 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	cgrp = rcu_dereference(kn->priv);
-	if (!cgrp) {
+	if (!cgrp || cgroup_is_dead(cgrp)) {
 		rcu_read_unlock();
+		mutex_unlock(&cgroup_mutex);
 		return -ENOENT;
 	}
+	rcu_read_unlock();
 
 	css_task_iter_start(&cgrp->dummy_css, &it);
 	while ((tsk = css_task_iter_next(&it))) {
@@ -3032,7 +3036,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	css_task_iter_end(&it);
 
-	rcu_read_unlock();
+	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
-- 
1.8.0.2
