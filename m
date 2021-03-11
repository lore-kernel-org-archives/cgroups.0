From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH] cgroup-v2: Add taskstats counters in cgroup.stat
Date: Thu, 11 Mar 2021 14:17:52 +0800
Message-ID: <20210311061752.310831-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GtG19LOebEp2WxfXZAPDVqDaGg46AUd7BpnKVeJq4kc=;
        b=rhbKo8dcc8lTdzeUYcMZoyURBR3BB+R/PES6oMiL7hFf6Hfd2KdUNdjN3OUvIs24TK
         Kld96DWzTaLfOLMLQ4UQ+NNx04wNaN7EPmGc0Rrs/meIZhbVWMZRyFRs0xgvufGs53+1
         WZbD536dxbOG4ZX3uDXg6AXioZz0EA90qLurDWnmAee19bYnY5otEd1TRemCbakfWAKL
         mfI+Cvmzdumpdq3HmPzqS/JiVMKhF+gCqZT2yLK1tmyCFPc4VVUpdmR6swDdUIApIgfY
         qBS2ud3yIfWJyKT4/qh412WYUWrg/xwTXvwTyZLpEnvAJxOJvTLTF3sbjzl3uecblNhE
         Sfrg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org
Cc: dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, zhouchengming@bytedance.com, songmuchun@bytedance.com

We have the netlink CGROUPSTATS_CMD_GET interface to get taskstats
of the cgroup on v1, but haven't the equivalent interface on v2,
making it difficult to calculate the per-cgroup cpu load in cadvisor
or implement the cgroup proc interface in lxcfs, like /proc/loadavg.

Since we already have these counters maintained in psi subsystem,
so this patch sum them up and export in the cgroup.stat interface.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 +++++++
 include/linux/psi.h                     |  1 +
 kernel/cgroup/cgroup.c                  |  3 +++
 kernel/sched/psi.c                      | 34 +++++++++++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 64c62b979f2f..4184e749f687 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -923,6 +923,15 @@ All cgroup core files are prefixed with "cgroup."
 		A dying cgroup can consume system resources not exceeding
 		limits, which were active at the moment of cgroup deletion.
 
+	  nr_iowait_tasks
+	    Total number of tasks in iowait.
+
+	  nr_memstall_tasks
+	    Total number of tasks in memstall.
+
+	  nr_running_tasks
+	    Total number of runnable tasks.
+
   cgroup.freeze
 	A read-write single value file which exists on non-root cgroups.
 	Allowed values are "0" and "1". The default is "0".
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7361023f3fdd..ea98239424ca 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -30,6 +30,7 @@ int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 int psi_cgroup_alloc(struct cgroup *cgrp);
 void psi_cgroup_free(struct cgroup *cgrp);
 void cgroup_move_task(struct task_struct *p, struct css_set *to);
+void psi_taskstat_show(struct seq_file *m, struct cgroup *cgrp);
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9153b20e5cc6..2724ae318a3b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3502,6 +3502,9 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "nr_dying_descendants %d\n",
 		   cgroup->nr_dying_descendants);
 
+#ifdef CONFIG_PSI
+	psi_taskstat_show(seq, cgroup);
+#endif
 	return 0;
 }
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 967732c0766c..0ae8bd278ca4 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1000,6 +1000,40 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 
 	task_rq_unlock(rq, task, &rf);
 }
+
+void psi_taskstat_show(struct seq_file *m, struct cgroup *cgrp)
+{
+	struct psi_group *group;
+	int cpu;
+	int s;
+	unsigned int taskstat[NR_PSI_TASK_COUNTS - 1] = { 0, };
+
+	if (static_branch_likely(&psi_disabled))
+		return;
+
+	group = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+
+	for_each_possible_cpu(cpu) {
+		struct psi_group_cpu *groupc = per_cpu_ptr(group->pcpu, cpu);
+		unsigned int tasks[NR_PSI_TASK_COUNTS];
+		unsigned int seq;
+
+		do {
+			seq = read_seqcount_begin(&groupc->seq);
+			memcpy(tasks, groupc->tasks, sizeof(groupc->tasks));
+		} while (read_seqcount_retry(&groupc->seq, seq));
+
+		for (s = 0; s < NR_ONCPU; s++)
+			taskstat[s] += tasks[s];
+	}
+
+	seq_printf(m, "nr_iowait_tasks %u\n"
+		   "nr_memstall_tasks %u\n"
+		   "nr_running_tasks %u\n",
+		   taskstat[NR_IOWAIT],
+		   taskstat[NR_MEMSTALL],
+		   taskstat[NR_RUNNING]);
+}
 #endif /* CONFIG_CGROUPS */
 
 int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
-- 
2.25.1

