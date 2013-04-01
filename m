From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] memcg: implement boost mode
Date: Mon,  1 Apr 2013 11:34:30 +0400
Message-ID: <1364801670-10241-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

There are scenarios in which we would like our programs to run faster.
It is a hassle, when they are contained in memcg, that some of its
allocations will fail and start triggering reclaim. This is not good
for the program, that will now be slower.

This patch implements boost mode for memcg. It exposes a u64 file
"memcg boost". Every time you write anything to it, it will reduce the
counters by ~20 %. Note that we don't want to actually reclaim pages,
which would defeat the very goal of boost mode. We just make the
res_counters able to accomodate more.

This file is also available in the root cgroup. But with a slightly
different effect. Writing to it will make more memory physically
available so our programs can profit.

Please ack and apply.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/res_counter.c |  2 +-
 mm/memcontrol.c      | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index ff55247..98f4ae9 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -88,7 +88,7 @@ int res_counter_charge_nofail(struct res_counter *counter, unsigned long val,
 
 u64 res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 {
-	if (WARN_ON(counter->usage < val))
+	if (counter->usage < val)
 		val = counter->usage;
 
 	counter->usage -= val;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1498f04..13b6934 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5255,6 +5255,32 @@ out:
 	return retval;
 }
 
+static int mem_cgroup_write_boost(struct cgroup *cont, struct cftype *cft,
+					u64 val)
+{
+	int retval = 0;
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	u64 val;
+
+	/* for atomic read + uncharge */
+	mutex_lock(&memcg_create_mutex);
+
+	/*
+	 * In boost mode, we will uncharge around 20 % of the current memory
+	 * There is no need to be extremely precise. Note that the pages will
+	 * still belong to the memcg so we won't really go through the LRU and
+	 * uncharge them.  Only the res_counter is updated.
+ 	 */
+	val = res_counter_read_u64(&memcg->res, RES_USAGE);
+	val = (200 * val) >> 10;
+	res_counter_uncharge(&memcg->res);
+
+	mutex_unlock(&memcg_create_mutex);
+
+	return retval;
+}
+
+
 
 static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *memcg,
 					       enum mem_cgroup_stat_index idx)
@@ -6353,6 +6379,10 @@ static struct cftype mem_cgroup_files[] = {
 		.read = mem_cgroup_read,
 	},
 	{
+		.name = "memcg_boost",
+		.write_u64 = mem_cgroup_write_boost,
+	},
+	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
 		.write_string = mem_cgroup_write,
-- 
1.8.1.4
