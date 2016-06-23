From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 23 Jun 2016 18:07:10 +0300
Message-ID: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=bmoPfPp+ui0GD+HiRjcU2cllqSancOV9CeuLJBFurx8=;
        b=lmkzqquDbaHV7dduX29rl5O3vGKgobyS3XtzG5RcTXwX5ZaJvTImfoDBgKO/0FvCYA
         E1D1sV974PZ5dct3qiPsu7QlAaLfRgY6yPremAAAfbiGHevnVx95jQRZp1e6nLq0d24a
         9UGaTXyyRZsUkev4WMkD0c5W+/Opkqjtpia9j+fKYHUe8XFBwt6LJCDuFRFy7VcOS/cX
         obTp1SnR4rrrAC78kfIjpSg94ggXIw8cDO/ijevj2M5L2ywmXh2nMvqtTFVA4Y+DSLjU
         pmNDXQgZ/eRTJkijEAADYiqUc3K6ddDPEglLvuNBiA31rqiqyQEiHNNJb1l4JH5vGuIR
         zD7w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP CGROUP" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

There are many basic ways to control processes, including capabilities,
cgroups and resource limits. However, there are far fewer ways to find
out useful values for the limits, except blind trial and error.

Currently, there is no way to know which capabilities are actually used.
Even the source code is only implicit, in-depth knowledge of each
capability must be used when analyzing a program to judge which
capabilities the program will exercise.

Add a new cgroup controller for monitoring of capabilities
in the cgroup.

Test case demonstrating basic capability monitoring and how the
capabilities are combined at next level (boot to rdshell):

(initramfs) cd /sys/fs
(initramfs) mount -t cgroup2 cgroup cgroup
(initramfs) cd cgroup
(initramfs) echo +capability > cgroup.subtree_control
(initramfs) mkdir test; cd test
(initramfs) echo +capability > cgroup.subtree_control
(initramfs) ls
capability.used         cgroup.events           cgroup.subtree_control
cgroup.controllers      cgroup.procs
(initramfs) mkdir first second
(initramfs) sh

BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) cd first
(initramfs) echo $$ >cgroup.procs
(initramfs) cat capability.used
0000000000000000 # nothing so far
(initramfs) mknod /dev/z_$$ c 1 2
(initramfs) cat capability.used
0000000008000000 # CAP_MKNOD
(initramfs) cat ../capability.used
0000000008000000 # also seen at next higher level
(initramfs) exit
(initramfs) sh

BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) cd second
(initramfs) echo $$ >cgroup.procs
(initramfs) cat capability.used
0000000000000000 # nothing so far
(initramfs) chown 1234 /dev/z_*
(initramfs) cat capability.used
0000000000000001 # CAP_CHROOT
(initramfs) cat ../capability.used
0000000008000001 # combined at next higher level
(initramfs) exit

Signed-off-by: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroup-v2.txt       | 17 +++++++
 include/linux/capability_cgroup.h |  7 +++
 include/linux/cgroup_subsys.h     |  4 ++
 init/Kconfig                      |  6 +++
 kernel/capability.c               |  2 +
 security/Makefile                 |  1 +
 security/capability_cgroup.c      | 99 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 136 insertions(+)
 create mode 100644 include/linux/capability_cgroup.h
 create mode 100644 security/capability_cgroup.c

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 4cc07ce..2b3d277 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1118,6 +1118,23 @@ writeback as follows.
 	total available memory and applied the same way as
 	vm.dirty[_background]_ratio.
 
+5-4. Capabilities
+
+The "capability" controller is used to monitor capability use in the
+cgroup. This can be used to discover a starting point for capability
+bounding sets, even when running a shell script under ambient
+capabilities, with only short-lived helper processes exercising the
+capabilities.
+
+
+5-4-1. Capability Interface Files
+
+  capability.used
+
+	A read-only file which exists on all cgroups.
+
+	This reports the combined value of capability use in the
+	current cgroup and all its children.
 
 6. Namespace
 
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
index f755a60..25d17ef 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1141,6 +1141,12 @@ config CGROUP_PERF
 
 	  Say N if unsure.
 
+config CGROUP_CAPABILITY
+	bool "Capability controller"
+	help
+	  Provides a simple controller for monitoring of capabilities in the
+	  cgroup.
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
index 0000000..f002477
--- /dev/null
+++ b/security/capability_cgroup.c
@@ -0,0 +1,99 @@
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
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+static DEFINE_MUTEX(capcg_mutex);
+
+struct capcg_cgroup {
+	struct cgroup_subsys_state css;
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
+	cap_clear(caps->cap_used);
+	return &caps->css;
+}
+
+static void capcg_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_to_capcg(css));
+}
+
+static int capcg_seq_show_used(struct seq_file *m, void *v)
+{
+	struct capcg_cgroup *capcg = css_to_capcg(seq_css(m));
+	struct cgroup_subsys_state *pos;
+	u32 capi;
+	kernel_cap_t subsys_caps = capcg->cap_used;
+
+	rcu_read_lock();
+
+	css_for_each_child(pos, &capcg->css) {
+		struct capcg_cgroup *pos_capcg = css_to_capcg(pos);
+
+		subsys_caps = cap_combine(subsys_caps, pos_capcg->cap_used);
+	}
+
+	rcu_read_unlock();
+
+	CAP_FOR_EACH_U32(capi) {
+		seq_printf(m, "%08x",
+			   subsys_caps.cap[CAP_LAST_U32 - capi]);
+	}
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static struct cftype capcg_files[] = {
+	{
+		.name = "used",
+		.seq_show = capcg_seq_show_used,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys capability_cgrp_subsys = {
+	.css_alloc = capcg_css_alloc,
+	.css_free = capcg_css_free,
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
