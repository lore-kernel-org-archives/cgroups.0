From: Max Kellermann <mk@cm4all.com>
Subject: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 15:06:46 +0100
Message-ID: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, cgroups@vger.kernel.org, cyphar@cyphar.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: max@duempel.org, linux-kernel@vger.kernel.org

This patch introduces a new setting called "fork_remaining".  When
positive, each successful fork decrements the value, and once it
reaches zero, no further forking is allowed, no matter how many of
those processes are still alive.  The special value "unlimited"
disables the fork limit.

The goal of this limit is to have another safeguard against fork
bombs.  It gives processes a chance to set up their child processes /
threads, but will be stopped once they attempt to waste resources by
continuously exiting and cloning new processes.  This can be useful
for short-lived processes such as CGI programs.

This is a resubmission; my first attempt to get this feature merged
was as a separate cgroup controller called "fork", but the idea was
rejected (http://thread.gmane.org/gmane.linux.kernel/1210878).  This
time, I'm trying to get this feature into the new "pids" controller,
which implements a similar idea.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 Documentation/cgroups/pids.txt |   31 ++++++++++
 kernel/cgroup_pids.c           |  123 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/Documentation/cgroups/pids.txt b/Documentation/cgroups/pids.txt
index 1a078b5..c5707bc 100644
--- a/Documentation/cgroups/pids.txt
+++ b/Documentation/cgroups/pids.txt
@@ -83,3 +83,34 @@ sh: fork: Resource temporary unavailable
 # /bin/echo "We can't even spawn a single process now."
 sh: fork: Resource temporary unavailable
 #
+
+Fork Limit
+----------
+
+Apart from limiting the total number of processes in a cgroup, the
+`pids` controller can also limit the number of fork()/clone() calls,
+no matter how many of those processes are still alive.  That setting
+is controlled by "pids.fork_remaining".  The default value is
+"unlimited", and it can be set to any non-negative integer.  Each
+successful fork()/clone() decrements the counter, until it hits zero.
+At this point, further fork()/clone() fail.
+
+Example:
+
+# mkdir /sys/fs/cgroup/pids/parent
+# echo 2 > /sys/fs/cgroup/pids/parent/pids.fork_remaining
+# echo $$ > /sys/fs/cgroup/pids/parent/cgroup.procs
+# cat /sys/fs/cgroup/pids/parent/pids.fork_remaining
+1
+# cat /sys/fs/cgroup/pids/parent/pids.fork_remaining
+0
+# cat /sys/fs/cgroup/pids/parent/pids.fork_remaining
+sh: fork: Resource temporary unavailable
+
+Note that the first `cat` returns "1"; that is because at this point,
+the counter has already been decremented by launching `cat` inside
+that cgroup.
+
+To lift the limit, write "unlimited" to "pids.fork_remaining":
+
+# echo unlimited > /sys/fs/cgroup/pids/parent/pids.fork_remaining
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 806cd76..d902efb 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -40,6 +40,9 @@
 #define PIDS_MAX (PID_MAX_LIMIT + 1ULL)
 #define PIDS_MAX_STR "max"
 
+#define PIDS_UNLIMITED -1
+#define PIDS_UNLIMITED_STR "unlimited"
+
 struct pids_cgroup {
 	struct cgroup_subsys_state	css;
 
@@ -49,6 +52,12 @@ struct pids_cgroup {
 	 */
 	atomic64_t			counter;
 	int64_t				limit;
+
+	/**
+	 * The remaining number of forks allowed.  -1 is the magic
+	 * value for "unlimited".
+	 */
+	atomic_t fork_remaining;
 };
 
 static struct pids_cgroup *css_pids(struct cgroup_subsys_state *css)
@@ -72,6 +81,7 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 
 	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic_set(&pids->fork_remaining, -1);
 	return &pids->css;
 }
 
@@ -162,6 +172,61 @@ revert:
 	return -EAGAIN;
 }
 
+/**
+ * pids_cancel_fork_remaining - uncharge fork_remaining counter.
+ */
+static void pids_cancel_fork_remaining(struct pids_cgroup *pids, int n)
+{
+	atomic_add_unless(&pids->fork_remaining, n, -1);
+}
+
+/**
+ * pids_cancel_fork_remaining - uncharge fork_remaining counter,
+ * traversing the parent chain, until (not including) the given last
+ * one.
+ */
+static void pids_cancel_fork_remaining_until(struct pids_cgroup *pids,
+					     struct pids_cgroup *last, int n)
+{
+	for (; pids != last; pids = parent_pids(pids))
+		pids_cancel_fork_remaining(pids, 1);
+}
+
+/**
+ * pids_cancel_fork_remaining - uncharge fork_remaining counter,
+ * traversing the whole parent chain.
+ */
+static void pids_cancel_fork_remaining_all(struct pids_cgroup *pids, int n)
+{
+	pids_cancel_fork_remaining_until(pids, NULL, n);
+}
+
+/**
+ * pids_try_fork - check if forking is allowed according to
+ * fork_remaining, and decrement the fork_remaining counter.
+ */
+static int pids_try_fork_remaining(struct pids_cgroup *pids)
+{
+	struct pids_cgroup *p;
+
+	for (p = pids; p; p = parent_pids(p)) {
+		int new = atomic_dec_if_positive(&p->fork_remaining);
+
+		if (new == -1)
+			/*
+			 * The old value was 0 which means we're not
+			 * allowed to fork.
+			 */
+			goto revert;
+	}
+
+	return 0;
+
+revert:
+	pids_cancel_fork_remaining_until(pids, p, 1);
+	return -EAGAIN;
+}
+
 static int pids_can_attach(struct cgroup_subsys_state *css,
 			   struct cgroup_taskset *tset)
 {
@@ -220,10 +285,16 @@ static int pids_can_fork(struct task_struct *task, void **priv_p)
 	css = task_get_css(current, pids_cgrp_id);
 	pids = css_pids(css);
 
-	err = pids_try_charge(pids, 1);
+	err = pids_try_fork_remaining(pids);
 	if (err)
 		goto err_css_put;
 
+	err = pids_try_charge(pids, 1);
+	if (err) {
+		pids_cancel_fork_remaining_all(pids, 1);
+		goto err_css_put;
+	}
+
 	*priv_p = css;
 	return 0;
 
@@ -237,6 +308,7 @@ static void pids_cancel_fork(struct task_struct *task, void *priv)
 	struct cgroup_subsys_state *css = priv;
 	struct pids_cgroup *pids = css_pids(css);
 
+	pids_cancel_fork_remaining_all(pids, 1);
 	pids_uncharge(pids, 1);
 	css_put(css);
 }
@@ -327,6 +399,49 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
 	return atomic64_read(&pids->counter);
 }
 
+static int pids_fork_remaining_write(struct kernfs_open_file *of, char *buf,
+				     size_t nbytes, loff_t off)
+{
+	struct cgroup_subsys_state *css = of_css(of);
+	struct pids_cgroup *pids = css_pids(css);
+	int fork_remaining;
+	int64_t value;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, PIDS_UNLIMITED_STR)) {
+		fork_remaining = PIDS_UNLIMITED;
+		goto set_limit;
+	}
+
+	err = kstrtoll(buf, 0, &value);
+	if (err)
+		return err;
+
+	if (value < 0 || value > INT_MAX)
+		return -EINVAL;
+
+	fork_remaining = (int)value;
+
+set_limit:
+	atomic_set(&pids->fork_remaining, fork_remaining);
+	return nbytes;
+}
+
+static int pids_fork_remaining_show(struct seq_file *sf, void *v)
+{
+	struct cgroup_subsys_state *css = seq_css(sf);
+	struct pids_cgroup *pids = css_pids(css);
+	int fork_remaining = atomic_read(&pids->fork_remaining);
+
+	if (fork_remaining == PIDS_UNLIMITED)
+		seq_printf(sf, "%s\n", PIDS_UNLIMITED_STR);
+	else
+		seq_printf(sf, "%d\n", fork_remaining);
+
+	return 0;
+}
+
 static struct cftype pids_files[] = {
 	{
 		.name = "max",
@@ -338,6 +453,12 @@ static struct cftype pids_files[] = {
 		.name = "current",
 		.read_s64 = pids_current_read,
 	},
+	{
+		.name = "fork_remaining",
+		.write = pids_fork_remaining_write,
+		.seq_show = pids_fork_remaining_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
