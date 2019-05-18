From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2] mm, memcg: introduce memory.events.local
Date: Fri, 17 May 2019 17:18:18 -0700
Message-ID: <20190518001818.193336-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qkDr2UAFkscvX8ezXGKmGGmc+dl6f/FAMKwyKcz0Ozc=;
        b=QI3CMrbUSisbO3F4zPF1hI/gUiK8dDCRjfX1TsAw9fftIwjnK8TdYw9nsLJY+RumM7
         Shb9J86yo+n5aXxg08eiEqZj+2z9qtyWZZf7Tpv3HzS5PRcNpiIGroILaSRAMUzE9Dzh
         kVb8DvXdY9osu7DCtFy07wfSZzUCDwO0B7L2gRNjrgKvc+pUzdBc9TTYDb3H+uw5c31O
         4WDfAt3UWxQtKDB3C5AoRY4WnPyNHBQgtUUhRMKQdjs8CEz6bIrXQF+O0EBBG6tjURat
         PomO6vvTPD6Sch2zcwASVvtsnQ3dhWAfNTYq9HRAlrpqLUGzo0UNA6yQgo8+kwneUm74
         fPMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The memory controller in cgroup v2 exposes memory.events file for each
memcg which shows the number of times events like low, high, max, oom
and oom_kill have happened for the whole tree rooted at that memcg.
Users can also poll or register notification to monitor the changes in
that file. Any event at any level of the tree rooted at memcg will
notify all the listeners along the path till root_mem_cgroup. There are
existing users which depend on this behavior.

However there are users which are only interested in the events
happening at a specific level of the memcg tree and not in the events in
the underlying tree rooted at that memcg. One such use-case is a
centralized resource monitor which can dynamically adjust the limits of
the jobs running on a system. The jobs can create their sub-hierarchy
for their own sub-tasks. The centralized monitor is only interested in
the events at the top level memcgs of the jobs as it can then act and
adjust the limits of the jobs. Using the current memory.events for such
centralized monitor is very inconvenient. The monitor will keep
receiving events which it is not interested and to find if the received
event is interesting, it has to read memory.event files of the next
level and compare it with the top level one. So, let's introduce
memory.events.local to the memcg which shows and notify for the events
at the memcg level.

Now, does memory.stat and memory.pressure need their local versions.
IMHO no due to the no internal process contraint of the cgroup v2. The
memory.stat file of the top level memcg of a job shows the stats and
vmevents of the whole tree. The local stats or vmevents of the top level
memcg will only change if there is a process running in that memcg but
v2 does not allow that. Similarly for memory.pressure there will not be
any process in the internal nodes and thus no chance of local pressure.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
Changelog since v1:
- refactor memory_events_show to share between events and events.local

 include/linux/memcontrol.h |  7 ++++++-
 mm/memcontrol.c            | 34 ++++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 36bdfe8e5965..de77405eec46 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -239,8 +239,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
-	/* memory.events */
+	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
+	struct cgroup_file events_local_file;
 
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
@@ -286,6 +287,7 @@ struct mem_cgroup {
 	atomic_long_t		vmevents_local[NR_VM_EVENT_ITEMS];
 
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
+	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
 	unsigned long		socket_pressure;
 
@@ -761,6 +763,9 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
+	atomic_long_inc(&memcg->memory_events_local[event]);
+	cgroup_file_notify(&memcg->events_local_file);
+
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2713b45ec3f0..a57dfcc4c4a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5630,21 +5630,29 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
+{
+	seq_printf(m, "low %lu\n", atomic_long_read(&events[MEMCG_LOW]));
+	seq_printf(m, "high %lu\n", atomic_long_read(&events[MEMCG_HIGH]));
+	seq_printf(m, "max %lu\n", atomic_long_read(&events[MEMCG_MAX]));
+	seq_printf(m, "oom %lu\n", atomic_long_read(&events[MEMCG_OOM]));
+	seq_printf(m, "oom_kill %lu\n",
+		   atomic_long_read(&events[MEMCG_OOM_KILL]));
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "low %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_LOW]));
-	seq_printf(m, "high %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_HIGH]));
-	seq_printf(m, "max %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_MAX]));
-	seq_printf(m, "oom %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_OOM]));
-	seq_printf(m, "oom_kill %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
+	__memory_events_show(m, memcg->memory_events);
+	return 0;
+}
+
+static int memory_events_local_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
+	__memory_events_show(m, memcg->memory_events_local);
 	return 0;
 }
 
@@ -5806,6 +5814,12 @@ static struct cftype memory_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, events_file),
 		.seq_show = memory_events_show,
 	},
+	{
+		.name = "events.local",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct mem_cgroup, events_local_file),
+		.seq_show = memory_events_local_show,
+	},
 	{
 		.name = "stat",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
2.21.0.1020.gf2820cf01a-goog

