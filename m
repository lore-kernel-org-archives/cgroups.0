From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [PATCH 2/4] numa: append per-node execution info in memory.numa_stat
Date: Wed, 3 Jul 2019 11:29:15 +0800
Message-ID: <825ebaf0-9f71-bbe1-f054-7fa585d61af1@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

This patch introduced numa execution information, to imply the numa
efficiency.

By doing 'cat /sys/fs/cgroup/memory/CGROUP_PATH/memory.numa_stat', we
see new output line heading with 'exectime', like:

  exectime 311900 407166

which means the tasks of this cgroup executed 311900 micro seconds on
node 0, and 407166 ms on node 1.

Combined with the memory node info, we can estimate the numa efficiency,
for example if the node memory info is:

  total=206892 N0=21933 N1=185171

By monitoring the increments, if the topology keep in this way and
locality is not nice, then it imply numa balancing can't help migrate
the memory from node 1 to 0 which is accessing by tasks on node 0, or
tasks can't migrate to node 1 for some reason, then you may consider
to bind the cgroup on the cpus of node 1.

Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0a30d14c9f43..deeca9db17d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -190,6 +190,7 @@ enum memcg_numa_locality_interval {

 struct memcg_stat_numa {
 	u64 locality[NR_NL_INTERVAL];
+	u64 exectime;
 };

 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2edf3f5ac4b9..d5f48365770f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3575,6 +3575,18 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 		seq_printf(m, " %u", jiffies_to_msecs(sum));
 	}
 	seq_putc(m, '\n');
+
+	seq_puts(m, "exectime");
+	for_each_online_node(nr) {
+		int cpu;
+		u64 sum = 0;
+
+		for_each_cpu(cpu, cpumask_of_node(nr))
+			sum += per_cpu(memcg->stat_numa->exectime, cpu);
+
+		seq_printf(m, " %llu", jiffies_to_msecs(sum));
+	}
+	seq_putc(m, '\n');
 #endif

 	return 0;
@@ -3606,6 +3618,7 @@ void memcg_stat_numa_update(struct task_struct *p)
 	memcg = mem_cgroup_from_task(p);
 	if (idx != -1)
 		this_cpu_inc(memcg->stat_numa->locality[idx]);
+	this_cpu_inc(memcg->stat_numa->exectime);
 	rcu_read_unlock();
 }
 #endif
-- 
2.14.4.44.g2045bb6

