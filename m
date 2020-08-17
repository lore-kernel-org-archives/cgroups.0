From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 4/8] fs/proc: Support a new procfs memctl file
Date: Mon, 17 Aug 2020 10:08:27 -0400
Message-ID: <20200817140831.30260-5-longman@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597673399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=7rpL6/EB1+EwHbaZQMk8wUHt9s1YSLWhla0Ecu2Wfro=;
        b=iPSrUHrfCMJwLSA4wHU5w1GlxNkpBt/F7SmDlE3YpZU78Os7KDQ3r3BP2VgqHDPSRcKGJc
        +FVc7kb0WutGCSsf6ZT9v6pfhcJbCZh3G66Ct3UXndHozmN94GJtSZr6kvUpqNZou/sXK2
        YDsirTB7ZLFsq5jkbbNMsE/ObkBS+4g=
In-Reply-To: <20200817140831.30260-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Waiman Long <longman@redhat.com>

To allow system administrators to view and modify the over-high action
settings of a running application, a new /proc/<pid>/memctl file is
now added to show the over-high action parameters as well as allowing
their modification.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/proc/base.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 617db4e0faa0..3c9349ad1e37 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -88,6 +88,8 @@
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/prctl.h>
+#include <linux/ctype.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
@@ -3145,6 +3147,107 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_STACKLEAK_METRICS */
 
+#ifdef CONFIG_MEMCG
+/*
+ * Memory cgroup control parameters
+ * <over_high_action> <limit1> <limit2>
+ */
+static ssize_t proc_memctl_read(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file_inode(file));
+	unsigned long action, limit1, limit2;
+	char buffer[80];
+	ssize_t len;
+
+	if (!task)
+		return -ESRCH;
+
+	action = task->memcg_over_high_action |
+		(task->memcg_over_high_signal << PR_MEMACT_SIG_SHIFT) |
+		(task->memcg_over_high_flags  << PR_MEMACT_FLG_SHIFT);
+	limit1 = (unsigned long)task->memcg_over_high_climit  * PAGE_SIZE;
+	limit2 = (unsigned long)task->memcg_over_high_plimit * PAGE_SIZE;
+
+	put_task_struct(task);
+	len = snprintf(buffer, sizeof(buffer), "%ld %ld %ld\n",
+		       action, limit1, limit2);
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t proc_memctl_write(struct file *file, const char __user *buf,
+				  size_t count, loff_t *offs)
+{
+	struct task_struct *task = get_proc_task(file_inode(file));
+	unsigned long vals[3];
+	char buffer[80];
+	char *ptr, *next;
+	int i, err;
+	unsigned int action, signal, flags;
+
+	if (!task)
+		return -ESRCH;
+	if (count  > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+	buffer[count] = '\0';
+	next = buffer;
+
+	/*
+	 * Expect to find 3 numbers
+	 */
+	for (i = 0, ptr = buffer; i < 3; i++) {
+		ptr = skip_spaces(next);
+		if (!*ptr) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* Skip non-space characters for next */
+		for (next = ptr; *next && !isspace(*next); next++)
+			;
+		if (isspace(*next))
+			*next++ = '\0';
+
+		err = kstrtoul(ptr, 0, &vals[i]);
+		if (err)
+			break;
+	}
+	action = vals[0] & PR_MEMACT_MASK;
+	signal = (vals[0] >> PR_MEMACT_SIG_SHIFT) & PR_MEMACT_MASK;
+	flags  = vals[0] >> PR_MEMACT_FLG_SHIFT;
+
+	/* Round up limits to number of pages */
+	vals[1] = DIV_ROUND_UP(vals[1], PAGE_SIZE);
+	vals[2] = DIV_ROUND_UP(vals[2], PAGE_SIZE);
+
+	/* Check input values */
+	if ((action > PR_MEMACT_MAX) || (signal >= _NSIG) ||
+	    (flags & ~PR_MEMFLAG_MASK)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	WRITE_ONCE(task->memcg_over_high_action, action);
+	WRITE_ONCE(task->memcg_over_high_signal, signal);
+	WRITE_ONCE(task->memcg_over_high_flags,  flags);
+	WRITE_ONCE(task->memcg_over_high_climit, vals[1]);
+	WRITE_ONCE(task->memcg_over_high_plimit, vals[2]);
+out:
+	put_task_struct(task);
+	return err < 0 ? err : count;
+}
+
+const struct file_operations proc_memctl_operations = {
+	.read   = proc_memctl_read,
+	.write  = proc_memctl_write,
+	.llseek	= generic_file_llseek,
+};
+#endif /* CONFIG_MEMCG */
+
 /*
  * Thread groups
  */
@@ -3258,6 +3361,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
 #endif
+#ifdef CONFIG_MEMCG
+	REG("memctl", 0644, proc_memctl_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3587,6 +3693,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
 #endif
+#ifdef CONFIG_MEMCG
+	REG("memctl", 0644, proc_memctl_operations),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.18.1

