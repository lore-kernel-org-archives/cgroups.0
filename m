From: John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH 1/2] cgroup: Add generic cgroup subsystem permission checks
Date: Wed, 20 May 2015 20:41:13 -0700
Message-ID: <1432179674-19154-2-git-send-email-john.stultz@linaro.org>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, John Stultz <john.stultz@linaro.org>

From: Colin Cross <ccross@android.com>

Rather than using explicit euid == 0 checks when trying to move
tasks into a cgroup, move permission checks into each specific
cgroup subsystem. If a subsystem does not specify a 'allow_attach'
handler, then we fall back to doing the checks the old way.

This patch adds a 'allow_attach' handler instead of reusing the
'can_attach' handler, since if the 'can_attach' handler was
reused, a new cgroup that implements 'can_attach' but not the
permission checks could end up with no permission checks at all.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Colin Cross <ccross@android.com>
Original-Author: San Mehat <san@google.com>
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Rewording of commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/cgroups/cgroups.txt |  9 +++++++++
 include/linux/cgroup.h            |  2 ++
 kernel/cgroup.c                   | 39 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index f935fac..88af0f0 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -578,6 +578,15 @@ is completely unused; @cgrp->parent is still valid. (Note - can also
 be called for a newly-created cgroup if an error occurs after this
 subsystem's create() method has been called for the new cgroup).
 
+int allow_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
+(cgroup_mutex held by caller)
+
+Called prior to moving a task into a cgroup; if the subsystem
+returns an error, this will abort the attach operation.  Used
+to extend the permission checks - if all subsystems in a cgroup
+return 0, the attach will be allowed to proceed, even if the
+default permission check (root or same user) fails.
+
 int can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 (cgroup_mutex held by caller)
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..0ea785d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -643,6 +643,8 @@ struct cgroup_subsys {
 	void (*css_reset)(struct cgroup_subsys_state *css);
 	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
 
+	int (*allow_attach)(struct cgroup_subsys_state *css,
+			    struct cgroup_taskset *tset);
 	int (*can_attach)(struct cgroup_subsys_state *css,
 			  struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_subsys_state *css,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2c..57e0fd7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2376,6 +2376,25 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	return ret;
 }
 
+static int cgroup_allow_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *css;
+	int i;
+	int ret;
+
+	for_each_css(css, i, cgrp) {
+		if (css->ss->allow_attach) {
+			ret = css->ss->allow_attach(css, tset);
+			if (ret)
+				return ret;
+		} else {
+			return -EACCES;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Find the task_struct of the task to attach by vpid and pass it along to the
  * function to attach either it or all tasks in its threadgroup. Will lock
@@ -2414,9 +2433,23 @@ retry_find_task:
 		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 		    !uid_eq(cred->euid, tcred->uid) &&
 		    !uid_eq(cred->euid, tcred->suid)) {
-			rcu_read_unlock();
-			ret = -EACCES;
-			goto out_unlock_cgroup;
+			/*
+			 * if the default permission check fails, give each
+			 * cgroup a chance to extend the permission check
+			 */
+			struct cgroup_taskset tset = {
+				.src_csets = LIST_HEAD_INIT(tset.src_csets),
+				.dst_csets = LIST_HEAD_INIT(tset.dst_csets),
+				.csets = &tset.src_csets,
+			};
+			struct css_set *cset;
+			cset = task_css_set(tsk);
+			list_add(&cset->mg_node, &tset.src_csets);
+			ret = cgroup_allow_attach(cgrp, &tset);
+			if (ret) {
+				rcu_read_unlock();
+				goto out_unlock_cgroup;
+			}
 		}
 	} else
 		tsk = current;
-- 
1.9.1
