From: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/2] cgroup: Add generic cgroup subsystem permission checks
Date: Mon,  3 Oct 2016 21:41:29 -0700
Message-ID: <1475556090-6278-2-git-send-email-john.stultz@linaro.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Lf5A/E3F3/H80ldpLt8pAWEDqqUfgVfyOKi8x9Ztcc=;
        b=kCzEPiYNjX/R1IXkTX8qWZL9zBAxI6pEORGb8+theCxoz8I8FwvirYEtm5E7Jdy2YR
         7BJvsXBahr8AbyGkq9CrtC6/khDBeJ8klvcC6sks5Dd3QBaPn/OLmz8H3ARLOj5LNTHH
         lK/LqK45GDHJdHUh0g/S+kOOIg80gc38fNs3E=
In-Reply-To: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, John Stultz <john.stultz@linaro.org>

From: Colin Cross <ccross@android.com>

Rather than using explicit euid == 0 checks when trying to move
tasks into a cgroup, move permission checks into each specific
cgroup subsystem. If a subsystem does not specify a 'allow_attach'
handler, then we fall back to doing the checks the old way.

This patch adds a 'allow_attach' handler instead of reusing the
'can_attach' handler, since if the 'can_attach' handler was
reused, a new cgroup that implements 'can_attach' but not the
permission checks could end up with no permission checks at all.

This also includes folded down fixes from:
  Christian Poetzsch <christian.potzsch@imgtec.com>
  Amit Pundir <amit.pundir@linaro.org>

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Christian Poetzsch <christian.potzsch@imgtec.com>
Cc: Amit Pundir <amit.pundir@linaro.org>
Original-Author: San Mehat <san@google.com>
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Rewording of commit message, folded down fixes]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/cgroup-v1/cgroups.txt |  9 +++++++++
 include/linux/cgroup-defs.h         |  1 +
 kernel/cgroup.c                     | 40 +++++++++++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.txt
index 308e5ff..295f026 100644
--- a/Documentation/cgroup-v1/cgroups.txt
+++ b/Documentation/cgroup-v1/cgroups.txt
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
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 5b17de6..0f4548c 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -441,6 +441,7 @@ struct cgroup_subsys {
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
 
+	int (*allow_attach)(struct cgroup_taskset *tset);
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_taskset *tset);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d6b729b..e6afe2d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2833,6 +2833,25 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
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
+			ret = css->ss->allow_attach(tset);
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
 static int cgroup_procs_write_permission(struct task_struct *task,
 					 struct cgroup *dst_cgrp,
 					 struct kernfs_open_file *of)
@@ -2847,8 +2866,25 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	 */
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->euid, tcred->suid))
-		ret = -EACCES;
+	    !uid_eq(cred->euid, tcred->suid)) {
+		/*
+		 * if the default permission check fails, give each
+		 * cgroup a chance to extend the permission check
+		 */
+		struct cgroup_taskset tset = {
+			.src_csets = LIST_HEAD_INIT(tset.src_csets),
+			.dst_csets = LIST_HEAD_INIT(tset.dst_csets),
+			.csets = &tset.src_csets,
+		};
+		struct css_set *cset;
+
+		cset = task_css_set(task);
+		list_add(&cset->mg_node, &tset.src_csets);
+		ret = cgroup_allow_attach(dst_cgrp, &tset);
+		list_del(&tset.src_csets);
+		if (ret)
+			ret = -EACCES;
+	}
 
 	if (!ret && cgroup_on_dfl(dst_cgrp)) {
 		struct super_block *sb = of->file->f_path.dentry->d_sb;
-- 
1.9.1

