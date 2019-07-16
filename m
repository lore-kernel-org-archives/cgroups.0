From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [PATCH v2 2/4] numa: append per-node execution time in cpu.numa_stat
Date: Tue, 16 Jul 2019 11:40:35 +0800
Message-ID: <6973a1bf-88f2-b54e-726d-8b7d95d80197@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <65c1987f-bcce-2165-8c30-cf8cf3454591@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <65c1987f-bcce-2165-8c30-cf8cf3454591@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>

This patch introduced numa execution time information, to imply the numa
efficiency.

By doing 'cat /sys/fs/cgroup/cpu/CGROUP_PATH/cpu.numa_stat', we see new
output line heading with 'exectime', like:

  exectime 311900 407166

which means the tasks of this cgroup executed 311900 micro seconds on
node 0, and 407166 ms on node 1.

Combined with the memory node info from memory cgroup, we can estimate
the numa efficiency, for example if the memory.numa_stat show:

  total=206892 N0=21933 N1=185171

By monitoring the increments, if the topology keep in this way and
locality is not nice, then it imply numa balancing can't help migrate
the memory from node 1 to 0 which is accessing by tasks on node 0, or
tasks can't migrate to node 1 for some reason, then you may consider
to bind the workloads on the cpus of node 1.

Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
Since v1:
  * move implementation from memory cgroup into cpu group
  * exectime now accounting in hierarchical way
  * change member name into jiffies

 kernel/sched/core.c  | 12 ++++++++++++
 kernel/sched/fair.c  |  2 ++
 kernel/sched/sched.h |  1 +
 3 files changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 71a8d3ed8495..f8aa73aa879b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7307,6 +7307,18 @@ static int cpu_numa_stat_show(struct seq_file *sf, void *v)
 	}
 	seq_putc(sf, '\n');

+	seq_puts(sf, "exectime");
+	for_each_online_node(nr) {
+		int cpu;
+		u64 sum = 0;
+
+		for_each_cpu(cpu, cpumask_of_node(nr))
+			sum += per_cpu(tg->numa_stat->jiffies, cpu);
+
+		seq_printf(sf, " %u", jiffies_to_msecs(sum));
+	}
+	seq_putc(sf, '\n');
+
 	return 0;
 }
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd716355d70e..2c362266af76 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2652,6 +2652,8 @@ static void update_tg_numa_stat(struct task_struct *p)
 		if (idx != -1)
 			this_cpu_inc(tg->numa_stat->locality[idx]);

+		this_cpu_inc(tg->numa_stat->jiffies);
+
 		tg = tg->parent;
 	}

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 685a9e670880..456f83f7f595 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -360,6 +360,7 @@ struct cfs_bandwidth {

 struct numa_stat {
 	u64 locality[NR_NL_INTERVAL];
+	u64 jiffies;
 };

 #endif
-- 
2.14.4.44.g2045bb6

