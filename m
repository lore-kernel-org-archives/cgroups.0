From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Mon, 25 Feb 2013 14:17:49 +0800
Message-ID: <512B020D.9040504@huawei.com>
References: <512B01FA.5020506@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512B01FA.5020506@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

cgroup_name() returns the name of a cgroup and it must be called with
rcu_read_lock() held.

This will be used by cpuset.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7f21bad..70676eb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -426,6 +426,7 @@ int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
+char *cgroup_name(const struct cgroup *cgrp);
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index eb3c280..abbb097 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1778,6 +1778,20 @@ static struct file_system_type cgroup_fs_type = {
 static struct kobject *cgroup_kobj;
 
 /**
+ * cgroup_name - get the name of a cgroup
+ * @cgrp: the cgroup in question
+ *
+ * Must be called with rcu_read_lock() held.
+ */
+char *cgroup_name(const struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return "/";
+	else
+		return rcu_dereference(cgrp->name)->name;
+}
+
+/**
  * cgroup_path - generate the path of a cgroup
  * @cgrp: the cgroup in question
  * @buf: the buffer to write the path into
-- 
1.8.0.2
