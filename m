From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 3/4] cgroup: require write perm on common ancestor when
 moving processes on the default hierarchy
Date: Thu, 18 Jun 2015 13:59:27 -0400
Message-ID: <20150618175927.GD12934@mtj.duckdns.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ev7g1FmB19/ONi8M6KiFkN5htGw6lGves25sHps8+2M=;
        b=w8jSWzljc50ttlCUDhXfwOZU8OXooHAjxtMQCRVMT4GwtML6wuh/PzGFfZJaAtbg3W
         IeHTwHLEA9ytJukLTN7pd/j373FpetP445D2eMQOuwa4SG/j6poB0oczIkFoAit8RPz3
         a2YsYqhffWVqtnDz7/kYo3wpzE1ZBebhzbgvfY600bhf7hKcTvjHJW5tcAspDTF+jcQE
         Rk7GSr455L2gBBtAypwkPwpI5o9WmYEzNF5PXvrOmExtMIObrcd46TuJJLdbEIVQk39y
         73wM81g7M65TAZyK7WmBLj5SORChQV4dkhuEVXczueY7hXAiI+BeCuDmDgpaOb+ueDnS
         Q1qQ==
Content-Disposition: inline
In-Reply-To: <1434481817-32001-4-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

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

v2: Fixed missing !ret test.  Spotted by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup-defs.h |    1 +
 kernel/cgroup.c             |   30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -220,6 +220,7 @@ struct cgroup {
 	int populated_cnt;
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
+	struct kernfs_node *procs_kn;	/* kn for "cgroup.procs" */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
 	/*
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2392,7 +2392,9 @@ static int cgroup_attach_task(struct cgr
 	return ret;
 }
 
-static int cgroup_procs_write_permission(struct task_struct *task)
+static int cgroup_procs_write_permission(struct task_struct *task,
+					 struct cgroup *dst_cgrp,
+					 struct kernfs_open_file *of)
 {
 	const struct cred *cred = current_cred();
 	const struct cred *tcred = get_task_cred(task);
@@ -2407,6 +2409,26 @@ static int cgroup_procs_write_permission
 	    !uid_eq(cred->euid, tcred->suid))
 		ret = -EACCES;
 
+	if (!ret && cgroup_on_dfl(dst_cgrp)) {
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
@@ -2459,7 +2481,7 @@ static ssize_t __cgroup_procs_write(stru
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	ret = cgroup_procs_write_permission(tsk);
+	ret = cgroup_procs_write_permission(tsk, cgrp, of);
 	if (!ret)
 		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
 
@@ -3087,7 +3109,9 @@ static int cgroup_add_file(struct cgroup
 		return ret;
 	}
 
-	if (cft->seq_show == cgroup_populated_show)
+	if (cft->write == cgroup_procs_write)
+		cgrp->procs_kn = kn;
+	else if (cft->seq_show == cgroup_populated_show)
 		cgrp->populated_kn = kn;
 	return 0;
 }
