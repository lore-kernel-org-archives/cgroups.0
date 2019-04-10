From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 1/2] mm/memcontrol: Finer-grained control for subset of allocated memory
Date: Wed, 10 Apr 2019 15:13:20 -0400
Message-ID: <20190410191321.9527-2-longman@redhat.com>
References: <20190410191321.9527-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410191321.9527-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Aaron Lu <aaron.lu@intel.com>, Waiman Long <longman@redhat.com>

The current control mechanism for memory cgroup v2 lumps all the memory
together irrespective of the type of memory objects. However, there
are cases where users may have more concern about one type of memory
usage than the others.

In order to support finer-grained control of memory usage, the following
two new cgroup v2 control files are added:

 - memory.subset.list
   Either "" (default), "anon" (anonymous memory) or "file" (file
   cache). It specifies the type of memory objects we want to monitor.
 - memory.subset.high
   The high memory limit for the memory type specified in
   "memory.subset.list".

For simplicity, the limit is for memory usage by all the tasks within
the current memory cgroup only. It doesn't include memory usage by
other tasks in child memory cgroups. Hence, we can just check the
corresponding stat[] array entry of the selected memory type to see if
it is above the limit.

We currently don't have the capability to specify the type of memory
objects to reclaim. When memory reclaim is triggered after reaching
the "memory.subset.high" limit, other type of memory objects will also
be reclaimed.

In the future, we may extend this capability to allow even more
fine-grained selection of memory types as well as a combination of them
if the need arises.

A test program was written to allocate 1 Gbytes of memory and then
touch every pages of them. This program was then run in a memory cgroup:

 # echo anon > memory.subset.list
 # echo 10485760 > memory.subset.high
 # echo $$ > cgroup.procs
 # ~/touch-1gb

While the test program was running:

 # grep -w anon memory.stat
 anon 10817536

It was a bit higher than the limit, but that should be OK.

Without setting the limit, the output would be

 # grep -w anon memory.stat
 anon 1074335744

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 35 +++++++++
 include/linux/memcontrol.h              |  7 ++
 mm/memcontrol.c                         | 96 ++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 20f92c16ffbf..0d5b7c77897d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1080,6 +1080,41 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.subset.high
+	A read-write single value file which exists on non-root cgroups.
+	The default is "max".
+
+	Memory usage throttle limit for a subset of memory objects with
+	types specified in "memory.subset.list".  If a cgroup's usage for
+	those memory objects goes over the high boundary, the processes
+	of the cgroup are throttled and put under heavy reclaim pressure.
+
+	This throttle limit is not allowed to go higher than
+	"memory.high" and will be adjusted accordingly when "memory.high"
+	is changed.  Because of that, "memory.subset.list" should always
+	be set first before assigning a limit to this file.
+
+	Unlike "memory.high", "memory.subset.high" does not count memory
+	objects usage in child cgroups.
+
+	Going over the high limit never invokes the OOM killer and
+	under extreme conditions the limit may be breached.
+
+  memory.subset.list
+	A read-write single value file which exists on non-root cgroups.
+	The default is "" which means no separate memory subcomponent
+	tracking and throttling.
+
+	Currently, only the following two primary subcompoent types are
+	supported:
+
+	 - anon (anonymous memory)
+	 - file (filesystem cache, including tmpfs and shared memory)
+
+	The value of this file should either be "", "anon" or "file".
+	Changing its value resets "memory.subset.high" to be the same
+	as "memory.high".
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1f3d880b7ca1..1baf3e4a9eeb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -212,6 +212,13 @@ struct mem_cgroup {
 	/* Upper bound of normal memory consumption range */
 	unsigned long high;
 
+	/*
+	 * Upper memory consumption bound for a subset of memory object type
+	 * specified in subset_list for the current cgroup only.
+	 */
+	unsigned long subset_high;
+	unsigned long subset_list;
+
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 532e0e2a4817..7e52adea60d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2145,6 +2145,14 @@ static void reclaim_high(struct mem_cgroup *memcg,
 			 unsigned int nr_pages,
 			 gfp_t gfp_mask)
 {
+	int mtype = READ_ONCE(memcg->subset_list);
+
+	/*
+	 * Try memory reclaim if subset_high is exceeded.
+	 */
+	if (mtype && (memcg_page_state(memcg, mtype) > memcg->subset_high))
+		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
+
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
 			continue;
@@ -2190,6 +2198,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool may_swap = true;
 	bool drained = false;
 	bool oomed = false;
+	bool over_subset_high = false;
 	enum oom_status oom_status;
 
 	if (mem_cgroup_is_root(memcg))
@@ -2323,6 +2332,10 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	if (memcg->subset_list &&
+	   (memcg_page_state(memcg, memcg->subset_list) > memcg->subset_high))
+		over_subset_high = true;
+
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2333,7 +2346,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) > memcg->high) {
+		if (page_counter_read(&memcg->memory) > memcg->high ||
+		    over_subset_high) {
 			/* Don't bother a random interrupted task */
 			if (in_interrupt()) {
 				schedule_work(&memcg->high_work);
@@ -2343,6 +2357,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			set_notify_resume(current);
 			break;
 		}
+		over_subset_high = false;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	return 0;
@@ -4491,6 +4506,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_PTR(error);
 
 	memcg->high = PAGE_COUNTER_MAX;
+	memcg->subset_high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
@@ -5447,6 +5463,13 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	memcg->high = high;
 
+	/*
+	 * Synchronize subset_high if subset_list not set and lower
+	 * subset_high, if necessary.
+	 */
+	if (!memcg->subset_list || (high < memcg->subset_high))
+		memcg->subset_high = high;
+
 	nr_pages = page_counter_read(&memcg->memory);
 	if (nr_pages > high)
 		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
@@ -5511,6 +5534,65 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_subset_high_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+			READ_ONCE(mem_cgroup_from_seq(m)->subset_high));
+}
+
+static ssize_t memory_subset_high_write(struct kernfs_open_file *of,
+					char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long high;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "max", &high);
+	if (err)
+		return err;
+
+	if (high > memcg->high)
+		return -EINVAL;
+
+	memcg->subset_high = high;
+	return nbytes;
+}
+
+static int memory_subset_list_show(struct seq_file *m, void *v)
+{
+	unsigned long mtype = READ_ONCE(mem_cgroup_from_seq(m)->subset_list);
+
+	seq_puts(m, (mtype == MEMCG_RSS)   ? "anon\n" :
+		    (mtype == MEMCG_CACHE) ? "file\n" : "\n");
+	return 0;
+}
+
+static ssize_t memory_subset_list_write(struct kernfs_open_file *of,
+					char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long mtype;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "anon"))
+		mtype = MEMCG_RSS;
+	else if (!strcmp(buf, "file"))
+		mtype = MEMCG_CACHE;
+	else if (buf[0] == '\0')
+		mtype = 0;
+	else
+		return -EINVAL;
+
+	if (mtype == memcg->subset_list)
+		return nbytes;
+
+	memcg->subset_list = mtype;
+	/* Reset subset_high */
+	memcg->subset_high = memcg->high;
+	return nbytes;
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
@@ -5699,6 +5781,18 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+	{
+		.name = "subset.high",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_subset_high_show,
+		.write = memory_subset_high_write,
+	},
+	{
+		.name = "subset.list",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_subset_list_show,
+		.write = memory_subset_list_write,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.18.1

