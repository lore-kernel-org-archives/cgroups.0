From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 5/5] cgroup/cpuset: Optimize out unneeded cpuset_can_fork/cpuset_cancel_fork calls
Date: Tue, 11 Apr 2023 09:36:01 -0400
Message-ID: <20230411133601.2969636-6-longman@redhat.com>
References: <20230411133601.2969636-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681220184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xK1NCjqBm+Noko8JAoUQYHl2QqweOko54B+7fb/aUQk=;
        b=Qpxux3t/jAPWs4Z4I5FiIbMArm5L0WPre2d47TWcyiXHkFnejqb5LqvnKltjcbhs0uwdMD
        rkC6z7U/OvaiBaJtPLoCx+wmwKCjk2G6wmSXhMosESarQ7LtqFLh9W1099VBSlV9CaLGeR
        3TbgpsAG2qfqvpBZxwakK9GGt9NqOxs=
In-Reply-To: <20230411133601.2969636-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Giuseppe Scrivano <gscrivan@redhat.com>, Waiman Long <longman@redhat.com>

The newly introduced cpuset_can_fork() and cpuset_cancel_fork() calls
are only needed when the CLONE_INTO_CGROUP flag is set which is not
likely. Adding an extra cpuset_can_fork() call does introduce a bit
of performance overhead in the fork/clone fastpath. To reduce this
performance overhead, introduce a new clone_into_cgroup_can_fork flag
into the cgroup_subsys structure. This flag, when set, will call the
can_fork and cancel_fork methods only if the CLONE_INTO_CGROUP flag
is set.

The cpuset code is now modified to set this flag. The same cpuset
checking code in cpuset_can_fork() and cpuset_cancel_fork() will have
to stay as the cgroups can be different, but the cpusets may still be
the same. So the same check must be present in both cpuset_fork() and
cpuset_can_fork() to make sure that attach_in_progress is correctly set.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/cgroup-defs.h |  6 ++++++
 kernel/cgroup/cgroup.c      | 23 ++++++++++++++++++-----
 kernel/cgroup/cpuset.c      |  1 +
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a0d5466c7be..0087a47d80a2 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -701,6 +701,12 @@ struct cgroup_subsys {
 	 */
 	bool threaded:1;
 
+	/*
+	 * If %true, the controller will call can_fork and cancel_fork
+	 * methods only if CLONE_INTO_CGROUP flag is set.
+	 */
+	bool clone_into_cgroup_can_fork:1;
+
 	/* the following two fields are initialized automatically during boot */
 	int id;
 	const char *name;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 83ea13f2ccb1..23701e959ef5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6517,6 +6517,10 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 		return ret;
 
 	do_each_subsys_mask(ss, i, have_canfork_callback) {
+		if (ss->clone_into_cgroup_can_fork &&
+		   !(kargs->flags & CLONE_INTO_CGROUP))
+			continue;
+
 		ret = ss->can_fork(child, kargs->cset);
 		if (ret)
 			goto out_revert;
@@ -6528,8 +6532,12 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 	for_each_subsys(ss, j) {
 		if (j >= i)
 			break;
-		if (ss->cancel_fork)
-			ss->cancel_fork(child, kargs->cset);
+		if (!ss->cancel_fork ||
+		   (ss->clone_into_cgroup_can_fork &&
+		   !(kargs->flags & CLONE_INTO_CGROUP)))
+			continue;
+
+		ss->cancel_fork(child, kargs->cset);
 	}
 
 	cgroup_css_set_put_fork(kargs);
@@ -6552,9 +6560,14 @@ void cgroup_cancel_fork(struct task_struct *child,
 	struct cgroup_subsys *ss;
 	int i;
 
-	for_each_subsys(ss, i)
-		if (ss->cancel_fork)
-			ss->cancel_fork(child, kargs->cset);
+	for_each_subsys(ss, i) {
+		if (!ss->cancel_fork ||
+		   (ss->clone_into_cgroup_can_fork &&
+		   !(kargs->flags & CLONE_INTO_CGROUP)))
+			continue;
+
+		ss->cancel_fork(child, kargs->cset);
+	}
 
 	cgroup_css_set_put_fork(kargs);
 }
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e4ca2dd2b764..937ef4d60cd4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3391,6 +3391,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.dfl_cftypes	= dfl_files,
 	.early_init	= true,
 	.threaded	= true,
+	.clone_into_cgroup_can_fork = true,
 };
 
 /**
-- 
2.31.1

