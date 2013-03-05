From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 2/5] memcg: provide root figures from system totals
Date: Tue,  5 Mar 2013 17:10:55 +0400
Message-ID: <1362489058-3455-3-git-send-email-glommer@parallels.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362489058-3455-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

For the root memcg, there is no need to rely on the res_counters if hierarchy
is enabled The sum of all mem cgroups plus the tasks in root itself, is
necessarily the amount of memory used for the whole system. Since those figures
are already kept somewhere anyway, we can just return them here, without too
much hassle.

Limit and soft limit can't be set for the root cgroup, so they are left at
RESOURCE_MAX. Failcnt is left at 0, because its actual meaning is how many
times we failed allocations due to the limit being hit. We will fail
allocations in the root cgroup, but the limit will never the reason.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8b363f..bfbf1c2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4996,6 +4996,56 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	return val << PAGE_SHIFT;
 }
 
+static u64 memcg_read_root_rss(void)
+{
+	struct task_struct *p;
+
+	u64 rss = 0;
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		if (!p->mm)
+			continue;
+		task_lock(p);
+		rss += get_mm_rss(p->mm);
+		task_unlock(p);
+	}
+	read_unlock(&tasklist_lock);
+	return rss;
+}
+
+static u64 mem_cgroup_read_root(enum res_type type, int name)
+{
+	if (name == RES_LIMIT)
+		return RESOURCE_MAX;
+	if (name == RES_SOFT_LIMIT)
+		return RESOURCE_MAX;
+	if (name == RES_FAILCNT)
+		return 0;
+	if (name == RES_MAX_USAGE)
+		return 0;
+
+	if (WARN_ON_ONCE(name != RES_USAGE))
+		return 0;
+
+	switch (type) {
+	case _MEM:
+		return (memcg_read_root_rss() +
+		atomic_long_read(&vm_stat[NR_FILE_PAGES])) << PAGE_SHIFT;
+	case _MEMSWAP: {
+		struct sysinfo i;
+		si_swapinfo(&i);
+
+		return ((memcg_read_root_rss() +
+		atomic_long_read(&vm_stat[NR_FILE_PAGES])) << PAGE_SHIFT) +
+		i.totalswap - i.freeswap;
+	}
+	case _KMEM:
+		return 0;
+	default:
+		BUG();
+	};
+}
+
 static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
 			       struct file *file, char __user *buf,
 			       size_t nbytes, loff_t *ppos)
@@ -5012,6 +5062,19 @@ static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
 	if (!do_swap_account && type == _MEMSWAP)
 		return -EOPNOTSUPP;
 
+	/*
+	 * If we have root-level hierarchy, we can be certain that the charges
+	 * in root are always global. We can then bypass the root cgroup
+	 * entirely in this case, hopefuly leading to less contention in the
+	 * root res_counters. The charges presented after reading it will
+	 * always be the global charges.
+	 */
+	if (mem_cgroup_disabled() ||
+		(mem_cgroup_is_root(memcg) && memcg->use_hierarchy)) {
+		val = mem_cgroup_read_root(type, name);
+		goto root_bypass;
+	}
+
 	switch (type) {
 	case _MEM:
 		if (name == RES_USAGE)
@@ -5032,6 +5095,7 @@ static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
 		BUG();
 	}
 
+root_bypass:
 	len = scnprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
 	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
 }
-- 
1.8.1.2
