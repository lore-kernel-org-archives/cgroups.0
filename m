From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Date: Sun, 14 Apr 2013 11:36:59 -0700
Message-ID: <1365964619-14762-5-git-send-email-tj@kernel.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=6iNFQedWdxzC/Jt41exuMz0JB2xdl4nM1UxLEFYZeb4=;
        b=n8HU0g1D8oWxUI4KxsM6/VcUnXGjmKML7jeRKukLokvioYwP2VErBoT+CFmLYVBTc7
         P1gkuaRfhiLAC9FIK1dHzDumqVgxTOruVyTluwVvkLJH+Bfua5DUE/sB7zFXIHFyjJUv
         thQDO6BhJurPEU4tf8oKqyyUMC9cTWS1T1MyFIH7qd+AXBt+HVTIpZ/jHQxGvE0zs5GG
         ababIMRsZGLO8HbmJQwOn/rNQoiC+k8Tb+1e7WBtJNTZ749F2zlgW8X7qJVtrBiXw5rv
         qOdk5oXm7aPjiI7re186uPajXa6am425Xiklk64UOyRVmOYy5aBTtzBM0oRJehTO6gPS
         19YA==
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com, lennart@poettering.net, daniel@zonque.org, Tejun Heo <tj@kernel.org>

kdbus folks want a sane way to determine the cgroup path that a given
task belongs to on a given hierarchy, which is a reasonble thing to
expect from cgroup core.

Implement task_cgroup_path_from_hierarchy().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Daniel Mack <daniel@zonque.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 17ed818..ee83af2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -443,6 +443,8 @@ int cgroup_is_removed(const struct cgroup *cgrp);
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
+				    char *buf, size_t buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75d85e8..5184fcd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1842,6 +1842,39 @@ out:
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
+/**
+ * task_cgroup_path_from_hierarchy - cgroup path of a task on a hierarchy
+ * @task: target task
+ * @hierarchy_id: the hierarchy to look up @task's cgroup from
+ * @buf: the buffer to write the path into
+ * @buflen: the length of the buffer
+ *
+ * Determine @task's cgroup on the hierarchy specified by @hierarchy_id and
+ * copy its path into @buf.  This function grabs cgroup_mutex and shouldn't
+ * be used inside locks used by cgroup controller callbacks.
+ */
+int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
+				    char *buf, size_t buflen)
+{
+	struct cgroupfs_root *root;
+	struct cgroup *cgrp = NULL;
+	int ret = -ENOENT;
+
+	mutex_lock(&cgroup_mutex);
+
+	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
+	if (root) {
+		cgrp = task_cgroup_from_root(task, root);
+		if (cgrp)
+			ret = cgroup_path(cgrp, buf, buflen);
+	}
+
+	mutex_unlock(&cgroup_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(task_cgroup_path_from_hierarchy);
+
 /*
  * Control Group taskset
  */
-- 
1.8.1.4
