From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup: reimplement reading "cgroup.procs" on cgroup v2
Date: Tue, 20 Dec 2016 11:12:21 -0500
Message-ID: <20161220161222.15234-5-tj@kernel.org>
References: <20161220161222.15234-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=adW0HtIwNOD5zq+BhUt9VIVxoywHdoWRvOFk1iqkkHI=;
        b=h+Mpyrx8sxSaDPtfFTs2wIhiMizT12b4dNr2CH52hnchLBdQW33rK6H6audT6kvd8R
         NyPZSFNVrIK5wGjsCts3owaNCtIDMzzaLRdkpZkIUok2dbjq5KG1CMhehXn0LX53Woav
         hG7vF/FrS5Gl4EuFPYln4KclUgo2pOmaJ9aZdx0GTWwhQFxNGVxIFeY9MCwa6FRb6QW0
         PREMy7r8YhTY9rbHMXTuvEmzJ+dzuTZcQuZStKj5Qh8BIdSJOnNp9K5rtNIVtRcax5dC
         tVvOvDcDo90ygbXYmoq7iEF2uQbbO4VmO6R+dcjHxLgB2UcUMlCFOY5/MeG4nZmCVI07
         8I4A==
In-Reply-To: <20161220161222.15234-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

On v1, "tasks" and "cgroup.procs" are expected to be sorted which
makes the implementation expensive and unnecessarily complicated
involving result cache management.

v2 doesn't have the sorting requirement, so it can just iterate and
print processes one by one.  seq_files are either read sequentially or
reset to position zero, so the implementation doesn't even need to
worry about seeking.

This keeps the css_task_iter across multiple read(2) calls and
migrations of new processes always append won't miss processes which
are newly migrated in before each read(2).

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 87167e4..fd684bfd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4426,6 +4426,60 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	return ret;
 }
 
+static void cgroup_procs_release(struct kernfs_open_file *of)
+{
+	if (of->priv) {
+		css_task_iter_end(of->priv);
+		kfree(of->priv);
+	}
+}
+
+static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct kernfs_open_file *of = s->private;
+	struct css_task_iter *it = of->priv;
+	struct task_struct *task;
+
+	do {
+		task = css_task_iter_next(it);
+	} while (task && !thread_group_leader(task));
+
+	return task;
+}
+
+static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
+{
+	struct kernfs_open_file *of = s->private;
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+	struct css_task_iter *it = of->priv;
+
+	/*
+	 * When a seq_file is seeked, it's always traversed sequentially
+	 * from position 0, so we can simply keep iterating on !0 *pos.
+	 */
+	if (!it) {
+		if (WARN_ON_ONCE((*pos)++))
+			return ERR_PTR(-EINVAL);
+
+		it = kzalloc(sizeof(*it), GFP_KERNEL);
+		if (!it)
+			return ERR_PTR(-ENOMEM);
+		of->priv = it;
+		css_task_iter_start(&cgrp->self, it);
+	} else if (!(*pos)++) {
+		css_task_iter_end(it);
+		css_task_iter_start(&cgrp->self, it);
+	}
+
+	return cgroup_procs_next(s, NULL, NULL);
+}
+
+static int cgroup_procs_show(struct seq_file *s, void *v)
+{
+	seq_printf(s, "%d\n", task_tgid_vnr(v));
+	return 0;
+}
+
 /*
  * Stuff for reading the 'tasks'/'procs' files.
  *
@@ -4914,11 +4968,10 @@ static struct cftype cgroup_dfl_base_files[] = {
 	{
 		.name = "cgroup.procs",
 		.file_offset = offsetof(struct cgroup, procs_file),
-		.seq_start = cgroup_pidlist_start,
-		.seq_next = cgroup_pidlist_next,
-		.seq_stop = cgroup_pidlist_stop,
-		.seq_show = cgroup_pidlist_show,
-		.private = CGROUP_FILE_PROCS,
+		.release = cgroup_procs_release,
+		.seq_start = cgroup_procs_start,
+		.seq_next = cgroup_procs_next,
+		.seq_show = cgroup_procs_show,
 		.write = cgroup_procs_write,
 	},
 	{
-- 
2.9.3

