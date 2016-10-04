From: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/2] cgroup: Add a allow_attach policy for Android
Date: Mon,  3 Oct 2016 21:41:30 -0700
Message-ID: <1475556090-6278-3-git-send-email-john.stultz@linaro.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Abbxb7vkS3SSxml75dM0/jQ4tBvsEQ6AZ7zZmzo6YtM=;
        b=hygvS2wyjpKwMD12rjgIa5Z+OJHZ4SkgMK+LxPVQIkwR/CHzfMme561wJ0ZttYEoSY
         wiTXv2+12pwc5rxKROX1t1XWm9lDEy8z6YIf1xg3fQlBO82FihmaMNPnue4eZzW/XNNW
         QKJdQTQS1RVMu9It7bGlyXkEcSQHpB/CQ/eI0=
In-Reply-To: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rom Lemarchand <romlem@android.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, John Stultz <john.stultz@linaro.org>

From: Rom Lemarchand <romlem@android.com>

If CONFIG_CGROUP_NICE_ATTACH is enabled, this implements an
allow_attach policy for Android, which allows any process with
CAP_SYS_NICE to move tasks across cpuset and cpuctrl cgroups.

This includes folded down fixes from:
  Dmitry Shmidt <dimitrysh@google.com>
  Riley Andrews <riandrews@google.com>
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
Signed-off-by: Rom Lemarchand <romlem@android.com>
[jstultz: Majorly reworked to make this policy function
 configurable, and folded in fixes]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/cgroup.h | 16 ++++++++++++++++
 init/Kconfig           |  8 ++++++++
 kernel/cgroup.c        | 22 ++++++++++++++++++++++
 kernel/cpuset.c        |  3 +++
 kernel/sched/core.c    |  3 +++
 5 files changed, 52 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 984f73b..eab4311 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -554,6 +554,17 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+/*
+ * Default Android check for whether the current process is allowed to move a
+ * task across cgroups, either because CAP_SYS_NICE is set or because the uid
+ * of the calling process is the same as the moved task or because we are
+ * running as root.
+ * Returns 0 if this is allowed, or -EACCES otherwise.
+ */
+int cgroup_nice_allow_attach(struct cgroup_taskset *tset);
+#endif
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
@@ -647,6 +658,11 @@ copy_cgroup_ns(unsigned long flags, struct user_namespace *user_ns,
 	return old_ns;
 }
 
+static inline int subsys_cgroup_allow_attach(void *tset)
+{
+	return -EINVAL;
+}
+
 #endif /* !CONFIG_CGROUPS */
 
 static inline void get_cgroup_ns(struct cgroup_namespace *ns)
diff --git a/init/Kconfig b/init/Kconfig
index cac3f09..c000734 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1021,6 +1021,14 @@ config DEBUG_BLK_CGROUP
 	Enable some debugging help. Currently it exports additional stat
 	files in a cgroup which can be useful for debugging.
 
+config CGROUP_NICE_ATTACH
+	bool "Enabled Android-style loosening of perm checks for attachment"
+	default n
+	---help---
+	Allows non-root processes to add arbitrary processes to cpuset and
+	cpuctrl cgroups if they have CAP_SYS_NICE set. This is useful for
+	Android.
+
 config CGROUP_WRITEBACK
 	bool
 	depends on MEMCG && BLK_CGROUP
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e6afe2d..a53f0be 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2833,6 +2833,28 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	return ret;
 }
 
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+int cgroup_nice_allow_attach(struct cgroup_taskset *tset)
+{
+	const struct cred *cred = current_cred(), *tcred;
+	struct task_struct *task;
+	struct cgroup_subsys_state *css;
+
+	if (capable(CAP_SYS_NICE))
+		return 0;
+
+	cgroup_taskset_for_each(task, css, tset) {
+		tcred = __task_cred(task);
+
+		if (current != task && !uid_eq(cred->euid, tcred->uid) &&
+		    !uid_eq(cred->euid, tcred->suid))
+			return -EACCES;
+	}
+
+	return 0;
+}
+#endif
+
 static int cgroup_allow_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2b4c20a..87aede4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2100,6 +2100,9 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.css_offline	= cpuset_css_offline,
 	.css_free	= cpuset_css_free,
 	.can_attach	= cpuset_can_attach,
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+	.allow_attach   = cgroup_nice_allow_attach,
+#endif
 	.cancel_attach	= cpuset_cancel_attach,
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 44817c6..5573505 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8657,6 +8657,9 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+	.allow_attach	= cgroup_nice_allow_attach,
+#endif
 	.legacy_cftypes	= cpu_files,
 	.early_init	= true,
 };
-- 
1.9.1

