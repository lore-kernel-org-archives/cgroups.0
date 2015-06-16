From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] cgroup: require write perm on common ancestor when moving processes on the default hierarchy
Date: Tue, 16 Jun 2015 15:10:16 -0400
Message-ID: <1434481817-32001-4-git-send-email-tj@kernel.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fhYulkN4TjnswEs8fu2KY9GrrC/ngHNImTvI27H7Ke0=;
        b=nOEtY1hLntFi4+414mmIXCNHV27gwUSb53i+Cjng5tUBZke+GiRrPfFvyXODTblvBc
         eVaNU1EOQyG1+uD4k7jIf8MpkjeuWn10ca9veUJX/3nMZGfMtzrp877cTAuyg1NvmFGi
         8VIevv8i3VNlgipWZX+Gz7ePRVOOHQv67zAnk4EpXRVXmR5142Jr5jVWwCwxq1/QKTlH
         2j7p4APVmbeTsKXfNc5KM8zvnAa6x9KNV8S/e0cKMDNk61RrZmcQFJ2OAm39kqH/UWsT
         aLd75R8y1hA4KrsUOfnvynwjUxxM+9eNGQ7yC2UuKjGWTd4UFLNRxw+5SSeXQ5kzk3au
         unuA==
In-Reply-To: <1434481817-32001-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On traditional hierarchies, if a task has write access to "tasks" or
"cgroup.procs" file of a cgroup and its euid agrees with the target,
it can move the target to the cgroup; however, consider the following
scenario.  The owner of each cgroup is in the parentheses.

 R (root) - 0 (root) - 00 (user1) - 000 (user1)
          |                       \ 001 (user1)
          \ 1 (root) - 10 (user1)

The subtrees of 00 and 10 are delegated to user1; however, while both
subtrees may belong to the same user, it is clear that the two
subtrees are to be isolated - they're under completely separate
resource limits imposed by 0 and 1, respectively.  Note that 0 and 1
aren't strictly necessary but added to ease illustrating the issue.

If user1 is allowed to move processes between the two subtrees, the
intention of the hierarchy - keeping a given group of processes under
a subtree with certain resource restrictions while delegating
management of the subtree - can be circumvented by user1.

This happens because migration permission check doesn't consider the
hierarchical nature of cgroups.  To fix the issue, this patch adds an
extra permission requirement when userland tries to migrate a process
in the default hierarchy - the issuing task must have write access to
the common ancestor of "cgroup.procs" file of the ancestor in addition
to the destination's.

Conceptually, the issuer must be able to move the target process from
the source cgroup to the common ancestor of source and destination
cgroups and then to the destination.  As long as delegation is done in
a proper top-down way, this guarantees that a delegatee can't smuggle
processes across disjoint delegation domains.

The next patch will add documentation on the delegation model on the
default hierarchy.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup.c             | 30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index c5588c4..93755a6 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -220,6 +220,7 @@ struct cgroup {
 	int populated_cnt;
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
+	struct kernfs_node *procs_kn;	/* kn for "cgroup.procs" */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4504d64..d3ca3fe 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2392,7 +2392,9 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	return ret;
 }
 
-static int cgroup_procs_write_permission(struct task_struct *task)
+static int cgroup_procs_write_permission(struct task_struct *task,
+					 struct cgroup *dst_cgrp,
+					 struct kernfs_open_file *of)
 {
 	const struct cred *cred = current_cred();
 	const struct cred *tcred = get_task_cred(task);
@@ -2407,6 +2409,26 @@ static int cgroup_procs_write_permission(struct task_struct *task)
 	    !uid_eq(cred->euid, tcred->suid))
 		ret = -EACCES;
 
+	if (cgroup_on_dfl(dst_cgrp)) {
+		struct super_block *sb = of->file->f_path.dentry->d_sb;
+		struct cgroup *cgrp;
+		struct inode *inode;
+
+		down_read(&css_set_rwsem);
+		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+		up_read(&css_set_rwsem);
+
+		while (!cgroup_is_descendant(dst_cgrp, cgrp))
+			cgrp = cgroup_parent(cgrp);
+
+		ret = -ENOMEM;
+		inode = kernfs_get_inode(sb, cgrp->procs_kn);
+		if (inode) {
+			ret = inode_permission(inode, MAY_WRITE);
+			iput(inode);
+		}
+	}
+
 	put_cred(tcred);
 	return ret;
 }
@@ -2459,7 +2481,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	ret = cgroup_procs_write_permission(tsk);
+	ret = cgroup_procs_write_permission(tsk, cgrp, of);
 	if (!ret)
 		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
 
@@ -3087,7 +3109,9 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 		return ret;
 	}
 
-	if (cft->seq_show == cgroup_populated_show)
+	if (cft->write == cgroup_procs_write)
+		cgrp->procs_kn = kn;
+	else if (cft->seq_show == cgroup_populated_show)
 		cgrp->populated_kn = kn;
 	return 0;
 }
-- 
2.4.3
