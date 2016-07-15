From: Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 02/14] resource limits: aggregate task highwater marks to cgroup level
Date: Fri, 15 Jul 2016 13:35:49 +0300
Message-ID: <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kOvFrcd5TuUbMlB28T62pt7jXSoKjZgFd1Tjcs0ytmE=;
        b=L1iU4TKU4poPMdl7FZLOAJN1J7avhH5ajGtr36w0vySS6TYadL4B2Zgizm7lXbeHVj
         iaGlejdDYJHzMiUAYzbwZqJGwWqQXrDxuovtUXI5X8lmrZWjNVk9lcqE1XbpKG4LT7Ex
         QMoSraLqiUWRGcIJ3obD3keMWKbT7DEOJGMAgI53pOSSusQB6AiJ03aTQ7X+YW7Y3Pkk
         1KT31kjWFqQ6wFu9U0rTc6t6Ap7zhdvFBtkKbYvF6/6Y6Z0mE6xq6He/8FF0aAZc4H3y
         XWSrxyvfz/IpcAhyjJ/f9a8YEoL5J3WNxIphwI48UlDnfJbSmF0uTaE6XxTnQrGlEXvP
         cuiA==
In-Reply-To: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>

Collect resource usage highwater marks of a task to cgroup
statistics when the task exits.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 Documentation/accounting/getdelays.c | 10 ++++++-
 include/linux/cgroup-defs.h          |  5 ++++
 include/uapi/linux/cgroupstats.h     |  3 ++
 kernel/cgroup.c                      | 55 ++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 489f1b7..7c86279 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -27,7 +27,7 @@
 
 #include <linux/genetlink.h>
 #include "include/uapi/linux/taskstats.h"
-#include <linux/cgroupstats.h>
+#include "include/uapi/linux/cgroupstats.h"
 
 /*
  * Generic macros for dealing with netlink sockets. Might be duplicated
@@ -258,12 +258,20 @@ static const char *const rlimit_names[] = {
 
 static void print_cgroupstats(struct cgroupstats *c)
 {
+	int i;
+
 	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
 		"uninterruptible %llu\n", (unsigned long long)c->nr_sleeping,
 		(unsigned long long)c->nr_io_wait,
 		(unsigned long long)c->nr_running,
 		(unsigned long long)c->nr_stopped,
 		(unsigned long long)c->nr_uninterruptible);
+
+	if (print_resource_accounting)
+		for (i = 0; i < RLIM_NLIMITS; i++)
+			printf("%s=%llu\n",
+			       rlimit_names[i],
+			       (unsigned long long)c->resource_hiwater[i]);
 }
 
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 5b17de6..86bbc08 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -16,6 +16,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/workqueue.h>
+#include <linux/cgroupstats.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -300,6 +301,10 @@ struct cgroup {
 	/* used to schedule release agent */
 	struct work_struct release_agent_work;
 
+#ifdef CONFIG_TASK_XACCT
+	struct cgroupstats stats;
+#endif
+
 	/* ids of the ancestors at each level including self */
 	int ancestor_ids[];
 };
diff --git a/include/uapi/linux/cgroupstats.h b/include/uapi/linux/cgroupstats.h
index 3753c33..18b5b11 100644
--- a/include/uapi/linux/cgroupstats.h
+++ b/include/uapi/linux/cgroupstats.h
@@ -35,6 +35,9 @@ struct cgroupstats {
 	__u64	nr_uninterruptible;	/* Number of tasks in uninterruptible */
 					/* state */
 	__u64	nr_io_wait;		/* Number of tasks waiting on IO */
+	__u64   resource_hiwater[RLIM_NLIMITS]; /* high-watermark of
+						     RLIMIT
+						     resources */
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75c0ff0..9b2d805 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -247,6 +247,7 @@ static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			      struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
+static void cgroup_update_stats(void);
 
 /**
  * cgroup_ssid_enabled - cgroup subsys enabled test by subsys ID
@@ -2609,6 +2610,8 @@ out_release_tset:
 		list_splice_tail_init(&cset->mg_tasks, &cset->tasks);
 		list_del_init(&cset->mg_node);
 	}
+	cgroup_update_stats();
+
 	spin_unlock_irq(&css_set_lock);
 	return ret;
 }
@@ -4657,6 +4660,53 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	return 0;
 }
 
+/*
+ * Update cgroupstats based on the stats from exiting task
+ */
+static void cgroup_update_stats_from_task(struct cgroup *cgrp,
+					  struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	int i;
+	unsigned int seq, nextseq;
+	unsigned long flags;
+
+	rcu_read_lock();
+	/* Attempt a lockless read on the first round. */
+	nextseq = 0;
+	do {
+		seq = nextseq;
+		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
+		for (i = 0; i < RLIM_NLIMITS; i++)
+			if (cgrp->stats.resource_hiwater[i] <
+			    sig->resource_highwatermark[i])
+				cgrp->stats.resource_hiwater[i] =
+					sig->resource_highwatermark[i];
+
+		/* If lockless access failed, take the lock. */
+		nextseq = 1;
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+	rcu_read_unlock();
+}
+
+static void cgroup_update_stats(void)
+{
+	struct cgroup_root *root;
+
+	for_each_root(root) {
+		struct cgroup *cgrp;
+
+		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+			continue;
+
+		cgrp = task_cgroup_from_root(current, root);
+
+		if (cgroup_on_dfl(cgrp))
+			cgroup_update_stats_from_task(cgrp, current);
+	}
+}
+
 /**
  * cgroupstats_build - build and fill cgroupstats
  * @stats: cgroupstats to fill information into
@@ -4672,6 +4722,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	struct cgroup *cgrp;
 	struct css_task_iter it;
 	struct task_struct *tsk;
+	int i;
 
 	/* it should be kernfs_node belonging to cgroupfs and is a directory */
 	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
@@ -4714,9 +4765,13 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 				stats->nr_io_wait++;
 			break;
 		}
+		cgroup_update_stats_from_task(cgrp, tsk);
 	}
 	css_task_iter_end(&it);
 
+	for (i = 0; i < RLIM_NLIMITS; i++)
+		stats->resource_hiwater[i] = cgrp->stats.resource_hiwater[i];
+
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
-- 
2.8.1

