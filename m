From: John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH 2/2] cgroup: Add a memcg and cpu cg allow_attach policy for Android
Date: Wed, 20 May 2015 20:41:14 -0700
Message-ID: <1432179674-19154-3-git-send-email-john.stultz@linaro.org>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rom Lemarchand <romlem@android.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>

From: Rom Lemarchand <romlem@android.com>

If CONFIG_CGROUP_NICE_ATTACH is enabled, this implements an
allow_attach policy for Android, which allows any process with
CAP_SYS_NICE to move tasks across mem and cpu cgroups.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Rom Lemarchand <romlem@android.com>
[jstultz: Majorly reworked to make this policy function
 configurable, also squished in cpu and mem cgroup enablement.]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/cgroup.h      | 12 ++++++++++++
 init/Kconfig                |  7 +++++++
 kernel/Makefile             |  1 +
 kernel/cgroup_nice_attach.c | 29 +++++++++++++++++++++++++++++
 kernel/sched/core.c         |  3 +++
 mm/memcontrol.c             |  3 +++
 6 files changed, 55 insertions(+)
 create mode 100644 kernel/cgroup_nice_attach.c

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0ea785d..d584d31 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -943,6 +943,18 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
 struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
 
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+/*
+ * Default Android check for whether the current process is allowed to move a
+ * task across cgroups, either because CAP_SYS_NICE is set or because the uid
+ * of the calling process is the same as the moved task or because we are
+ * running as root.
+ * Returns 0 if this is allowed, or -EACCES otherwise.
+ */
+int cgroup_nice_allow_attach(struct cgroup_subsys_state *css,
+				struct cgroup_taskset *tset);
+#endif
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d..0e66e44 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1132,6 +1132,13 @@ config DEBUG_BLK_CGROUP
 	Enable some debugging help. Currently it exports additional stat
 	files in a cgroup which can be useful for debugging.
 
+config CGROUP_NICE_ATTACH
+	bool "Enabled Android-style loosening of perm checks for attachment"
+	default n
+	---help---
+	Allows non-root processes to add arbitrary processes to mem and cpu
+	cgroups if they have CAP_SYS_NICE set. This is useful for Android.
+
 endif # CGROUPS
 
 config CHECKPOINT_RESTORE
diff --git a/kernel/Makefile b/kernel/Makefile
index 1408b33..c81256b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
+obj-$(CONFIG_CGROUP_NICE_ATTACH) += cgroup_nice_attach.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
diff --git a/kernel/cgroup_nice_attach.c b/kernel/cgroup_nice_attach.c
new file mode 100644
index 0000000..b94c68e
--- /dev/null
+++ b/kernel/cgroup_nice_attach.c
@@ -0,0 +1,29 @@
+#include <linux/cgroup.h>
+#include <linux/kernel.h>
+
+/*
+ * Default Android check for whether the current process is allowed to move a
+ * task across cgroups, either because CAP_SYS_NICE is set or because the uid
+ * of the calling process is the same as the moved task or because we are
+ * running as root.
+ */
+int cgroup_nice_allow_attach(struct cgroup_subsys_state *css,
+					struct cgroup_taskset *tset)
+{
+	const struct cred *cred = current_cred(), *tcred;
+	struct task_struct *task;
+
+	if (capable(CAP_SYS_NICE))
+		return 0;
+
+	cgroup_taskset_for_each(task, tset) {
+		tcred = __task_cred(task);
+
+		if (current != task && !uid_eq(cred->euid, tcred->uid) &&
+		    !uid_eq(cred->euid, tcred->suid))
+			return -EACCES;
+	}
+
+	return 0;
+}
+
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62671f5..51dc86f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8368,6 +8368,9 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+	.allow_attach   = cgroup_nice_allow_attach,
+#endif
 	.exit		= cpu_cgroup_exit,
 	.legacy_cftypes	= cpu_files,
 	.early_init	= 1,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b34ef4a..6287697 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5387,6 +5387,9 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
+#ifdef CONFIG_CGROUP_NICE_ATTACH
+	.allow_attach = cgroup_nice_allow_attach,
+#endif
 	.bind = mem_cgroup_bind,
 	.dfl_cftypes = memory_files,
 	.legacy_cftypes = mem_cgroup_legacy_files,
-- 
1.9.1
