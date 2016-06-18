From: Topi Miettinen <toiwoton@gmail.com>
Subject: [RFC] capabilities: add capability cgroup controller
Date: Sat, 18 Jun 2016 22:31:57 +0300
Message-ID: <1466278320-17024-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=z+ehKoBf/UZGpuaMWUXOmI13jDsry9SRQz+1Hedih+4=;
        b=zyysBxXtqM6i0RUJMQiOz2qZtNQ/Z/SbQJHzSROqWz3BQGSxyGiRejFuh1/k9QM/d3
         PbXS9/gLS5JxS1/q80rK3ymTuAk/yepaDAApTyA7FtnI+1lvHB7sRhYn+fh7c5ywVdTy
         Gj4rCm9YbEo7552d86Sazk5l53skq1nYlTJJ9cD1ukqSB0/pBaiCv5mCbAko9AcZ6THb
         VJX2jvA+PHWVhLHia705x4f1g59d1+4kTtk0i6dXPGgXo3IDMRXCyrzuNFZSP/IRvQz6
         /eBCt976YwxJdSn1N4wGQXylD38w4HkcZhmt63uhfIPNeuQZdrTPlxxnl+ME1rBOJdiQ
         95kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: luto@kernel.org, Topi Miettinen <toiwoton@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ingo Molnar <mingo@kernel.org>, Petr Mladek <pmladek@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Rusty Russell <rusty@rustcorp.com.au>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Add a new cgroup controller for enforcement of and monitoring of
capabilities in the cgroup.

Test case (boot to rdshell);
BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) cd /sys/fs
(initramfs) mount -t cgroup2 cgroup cgroup
(initramfs) cd cgroup
(initramfs) echo +capability > cgroup.subtree_control
(initramfs) mkdir test; cd test
(initramfs) ls
capability.bounding_set  cgroup.controllers       cgroup.procs
capability.used          cgroup.events            cgroup.subtree_control
(initramfs) sh

BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) echo $$ >cgroup.procs
(initramfs) cat capability.used
0000000000000000
(initramfs) mknod /dev/z1 c 1 2
(initramfs) cat capability.used
0000000008000000
(initramfs) exit
(initramfs) echo 0000000000000000 > capability.bounding_set
(initramfs) sh

BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) echo $$ >cgroup.procs
(initramfs) mknod /dev/z2 c 1 2
mknod: /dev/z2: Operation not permitted
(initramfs) exit

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 include/linux/capability_cgroup.h |   7 ++
 include/linux/cgroup_subsys.h     |   4 +
 init/Kconfig                      |   6 ++
 kernel/capability.c               |   2 +
 security/Makefile                 |   1 +
 security/capability_cgroup.c      | 216 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 236 insertions(+)
 create mode 100644 include/linux/capability_cgroup.h
 create mode 100644 security/capability_cgroup.c

diff --git a/include/linux/capability_cgroup.h b/include/linux/capability_cgroup.h
new file mode 100644
index 0000000..c03b58d
--- /dev/null
+++ b/include/linux/capability_cgroup.h
@@ -0,0 +1,7 @@
+#ifdef CONFIG_CGROUP_CAPABILITY
+void capability_cgroup_update_used(int cap);
+#else
+static inline void capability_cgroup_update_used(int cap)
+{
+}
+#endif
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 0df0336a..a5161d0 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -56,6 +56,10 @@ SUBSYS(hugetlb)
 SUBSYS(pids)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_CAPABILITY)
+SUBSYS(capability)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index f755a60..098ce66 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1141,6 +1141,12 @@ config CGROUP_PERF
 
 	  Say N if unsure.
 
+config CGROUP_CAPABILITY
+	bool "Capability controller"
+	help
+	  Provides a simple controller for enforcement of and monitoring of
+	  capabilities in the cgroup.
+
 config CGROUP_DEBUG
 	bool "Example controller"
 	default n
diff --git a/kernel/capability.c b/kernel/capability.c
index 45432b5..b57d7f9 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/capability_cgroup.h>
 #include <asm/uaccess.h>
 
 /*
@@ -380,6 +381,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
 	}
 
 	if (security_capable(current_cred(), ns, cap) == 0) {
+		capability_cgroup_update_used(cap);
 		current->flags |= PF_SUPERPRIV;
 		return true;
 	}
diff --git a/security/Makefile b/security/Makefile
index f2d71cd..2bb04f1 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_CGROUP_CAPABILITY)		+= capability_cgroup.o
 
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
diff --git a/security/capability_cgroup.c b/security/capability_cgroup.c
new file mode 100644
index 0000000..6e03fce
--- /dev/null
+++ b/security/capability_cgroup.c
@@ -0,0 +1,216 @@
+/*
+ * Capability cgroup
+ *
+ * Copyright 2016 Topi Miettinen
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+#include <linux/capability.h>
+#include <linux/capability_cgroup.h>
+#include <linux/cgroup.h>
+#include <linux/cred.h>
+#include <linux/security.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+static DEFINE_MUTEX(capcg_mutex);
+
+struct capcg_cgroup {
+	struct cgroup_subsys_state css;
+	kernel_cap_t cap_bset; /* Capability bounding set */
+	kernel_cap_t cap_used; /* Capabilities actually used */
+};
+
+static inline struct capcg_cgroup *css_to_capcg(struct cgroup_subsys_state *s)
+{
+	return s ? container_of(s, struct capcg_cgroup, css) : NULL;
+}
+
+static inline struct capcg_cgroup *task_to_capcg(struct task_struct *task)
+{
+	return css_to_capcg(task_css(task, capability_cgrp_id));
+}
+
+static struct cgroup_subsys_state *capcg_css_alloc(struct cgroup_subsys_state
+						   *parent)
+{
+	struct capcg_cgroup *caps;
+
+	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return ERR_PTR(-ENOMEM);
+
+	caps->cap_bset = CAP_FULL_SET;
+	cap_clear(caps->cap_used);
+	return &caps->css;
+}
+
+static void capcg_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_to_capcg(css));
+}
+
+/**
+ * capcg_apply_bset - apply cgroup bounding set to all task's capabilities
+ */
+static int capcg_task_apply_bset(struct task_struct *task, kernel_cap_t bset)
+{
+	struct cred *new;
+	const struct cred *old;
+	kernel_cap_t bounding, effective, inheritable, permitted;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = security_capget(task, 
+			      &effective, &inheritable, &permitted);
+	if (ret < 0)
+		goto abort_cred;
+
+	old = get_task_cred(task);
+	bounding = cap_intersect(bset, old->cap_bset);
+	effective = cap_intersect(bset, effective);
+	inheritable = cap_intersect(bset, inheritable);
+	permitted = cap_intersect(bset, permitted);
+
+	/* security_capset() also updates ambient capabilities */
+	ret = security_capset(new, old,
+			      &effective, &inheritable, &permitted);
+	new->cap_bset = bounding;
+		
+	put_cred(old);
+	if (ret < 0)
+		goto abort_cred;
+
+	ret = commit_creds(new);
+	return ret;
+
+ abort_cred:
+	abort_creds(new);
+	return ret;
+}
+
+static void capcg_attach(struct cgroup_taskset *tset)
+{
+	struct task_struct *task;
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+	cgroup_taskset_for_each(task, css, tset) {
+		struct capcg_cgroup *caps = css_to_capcg(css);
+		
+		capcg_task_apply_bset(task, caps->cap_bset);
+	}
+	rcu_read_unlock();
+}
+
+/** capcg_write_bset - update css tree and their tasks with new
+ *  bounding capability
+ */
+static ssize_t capcg_write_bset(struct kernfs_open_file *of, char *buf,
+				size_t nbytes, loff_t off)
+{
+	struct cgroup_subsys_state *css = of_css(of), *pos;
+	struct capcg_cgroup *caps = css_to_capcg(css);
+	u32 capi;
+	int err;
+	kernel_cap_t new_bset;
+
+	buf = strstrip(buf);
+
+	CAP_FOR_EACH_U32(capi) {
+		char buf2[9]; /* for each 32 bit block */
+		u32 capv;
+
+		memcpy(buf2, &buf[capi * 8], 8);
+		buf2[8] = '\0';
+		err = kstrtou32(buf2, 16, &capv);
+		if (err)
+			return err;
+		new_bset.cap[CAP_LAST_U32 - capi] = capv;
+	}
+
+	mutex_lock(&capcg_mutex);
+	caps->cap_bset = cap_intersect(caps->cap_bset, new_bset);
+	mutex_unlock(&capcg_mutex);
+
+	rcu_read_lock();
+	css_for_each_child(pos, css) {
+		struct css_task_iter it;
+		struct task_struct *task;
+
+		css_task_iter_start(pos, &it);
+		while ((task = css_task_iter_next(&it)))
+			capcg_task_apply_bset(task, new_bset);
+	}
+	rcu_read_unlock();
+
+	return nbytes;
+}
+
+static int capcg_seq_show_cap(struct seq_file *m, kernel_cap_t *cap)
+{
+	u32 capi;
+
+	rcu_read_lock();
+
+	CAP_FOR_EACH_U32(capi) {
+		seq_printf(m, "%08x",
+			   cap->cap[CAP_LAST_U32 - capi]);
+	}
+	seq_putc(m, '\n');
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int capcg_seq_show_bset(struct seq_file *m, void *v)
+{
+	struct capcg_cgroup *capcg = css_to_capcg(seq_css(m));
+
+	return capcg_seq_show_cap(m, &capcg->cap_bset);
+}
+
+static int capcg_seq_show_used(struct seq_file *m, void *v)
+{
+	struct capcg_cgroup *capcg = css_to_capcg(seq_css(m));
+
+	return capcg_seq_show_cap(m, &capcg->cap_used);
+}
+
+static struct cftype capcg_files[] = {
+	{
+		.name = "bounding_set",
+		.seq_show = capcg_seq_show_bset,
+		.write = capcg_write_bset,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "used",
+		.seq_show = capcg_seq_show_used,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys capability_cgrp_subsys = {
+	.css_alloc = capcg_css_alloc,
+	.css_free = capcg_css_free,
+	.attach = capcg_attach,
+	.dfl_cftypes = capcg_files,
+};
+
+void capability_cgroup_update_used(int cap)
+{
+	struct capcg_cgroup *caps = task_to_capcg(current);
+
+	mutex_lock(&capcg_mutex);
+	cap_raise(caps->cap_used, cap);
+	mutex_unlock(&capcg_mutex);
+}
-- 
2.8.1

