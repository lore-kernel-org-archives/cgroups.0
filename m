From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove unused task_cgroup_path()
Date: Sat, 10 Jun 2023 11:57:37 +0800
Message-ID: <20230610035737.1046651-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

task_cgroup_path() is not used anymore. So remove it.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 -
 kernel/cgroup/cgroup.c | 39 ---------------------------------------
 2 files changed, 40 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 567c547cf371..b307013b9c6c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -118,7 +118,6 @@ int cgroup_rm_cftypes(struct cftype *cfts);
 void cgroup_file_notify(struct cgroup_file *cfile);
 void cgroup_file_show(struct cgroup_file *cfile, bool show);
 
-int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d0d033a48f61..48278adb7522 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2364,45 +2364,6 @@ int cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
 }
 EXPORT_SYMBOL_GPL(cgroup_path_ns);
 
-/**
- * task_cgroup_path - cgroup path of a task in the first cgroup hierarchy
- * @task: target task
- * @buf: the buffer to write the path into
- * @buflen: the length of the buffer
- *
- * Determine @task's cgroup on the first (the one with the lowest non-zero
- * hierarchy_id) cgroup hierarchy and copy its path into @buf.  This
- * function grabs cgroup_mutex and shouldn't be used inside locks used by
- * cgroup controller callbacks.
- *
- * Return value is the same as kernfs_path().
- */
-int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
-{
-	struct cgroup_root *root;
-	struct cgroup *cgrp;
-	int hierarchy_id = 1;
-	int ret;
-
-	cgroup_lock();
-	spin_lock_irq(&css_set_lock);
-
-	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
-
-	if (root) {
-		cgrp = task_cgroup_from_root(task, root);
-		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
-	} else {
-		/* if no hierarchy exists, everyone is in "/" */
-		ret = strscpy(buf, "/", buflen);
-	}
-
-	spin_unlock_irq(&css_set_lock);
-	cgroup_unlock();
-	return ret;
-}
-EXPORT_SYMBOL_GPL(task_cgroup_path);
-
 /**
  * cgroup_attach_lock - Lock for ->attach()
  * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
-- 
2.27.0

