From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH UPDATED 4/4] cgroup: implement
 task_cgroup_path_from_hierarchy()
Date: Sun, 14 Apr 2013 20:50:08 -0700
Message-ID: <20130415035008.GM3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=he4tKLm9Va6b8RklDpxsvK5replq1vtj60qZa68sSTg=;
        b=oadpXF0mC0iVj3sDEDrQ2FSadmbxQqETduk36oatHMtOK848fM/jpjgl7kSLO6vQoE
         OAR98tw0bPo11Ew45uWENN3U7UwkEByglyKtqSSKmb1iD2WS9S/HGnQ7tzFdjvkbG7ZH
         U2si6iWgLalaAaQ+jWn0YNhRg+rBI0096YiZsi3Fvw1Zdp27hWv30vobx7dCWHXH/xzo
         ouCG8QCg/Zeoy18FUIPfBiN4CfZz9/i83/UpILs0rt/Gya9XqWLrDhd9IEw75lU+meHB
         4oPNzyONRl1vSkkUlGPKytJWPt549l6KQZ5bqaF6TTk77CDs6CkhhO8Iiynfobs6M1T3
         eQgw==
Content-Disposition: inline
In-Reply-To: <1365964619-14762-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org

kdbus folks want a sane way to determine the cgroup path that a given
task belongs to on a given hierarchy, which is a reasonble thing to
expect from cgroup core.

Implement task_cgroup_path_from_hierarchy().

v2: Dropped unnecessary NULL check on the return value of
    task_cgroup_from_root() as suggested by Li Zefan.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -443,6 +443,8 @@ int cgroup_is_removed(const struct cgrou
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
+				    char *buf, size_t buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1842,6 +1842,38 @@ out:
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
+		ret = cgroup_path(cgrp, buf, buflen);
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
