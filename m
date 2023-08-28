From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 23:33:18 +0000
Message-ID: <20230828233319.340712-5-yosryahmed@google.com>
References: <20230828233319.340712-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693265609; x=1693870409;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wRGpIX3lyKI055RI8cMjafWOHR4EuDVDQeE9aWNLVUM=;
        b=eoDxnQJF3X52LCWoBIxxsewZGAjILMgMJpEG4EXQ2YAh0jGR93SKaYdX81UglrX6fo
         1wKEaixnEVtkrTCbB/CHL7SnwHFabZVbsYdY6keYxwCeXgS6yY/2Kto8tSYSMEJ/Y2YG
         pN89ky8l7MzmQ1FBTbeb5i+s04d3wUfDyK8F758aH26chFWvDGxLJn0ispz/NJwci9YX
         zZyG7Q8Xdlaanlqu4MxEXr+HClTY0BRCmUuRbsTIW6YTWap0g/zatE8xcF8lie3HxjPZ
         icLK7HqerVKwHQ7cBYh7IgKJ5U1e/mmoItt4cDNTSXRVs/dV4Xbtf/Jcf41tWtLG9YIA
         UabQ==
In-Reply-To: <20230828233319.340712-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Unified flushing allows for great concurrency for paths that attempt to
flush the stats, at the expense of potential staleness and a single
flusher paying the extra cost of flushing the full tree.

This tradeoff makes sense for in-kernel flushers that may observe high
concurrency (e.g. reclaim, refault). For userspace readers, stale stats
may be unexpected and problematic, especially when such stats are used
for critical paths such as userspace OOM handling. Additionally, a
userspace reader will occasionally pay the cost of flushing the entire
hierarchy, which also causes problems in some cases [1].

Opt userspace reads out of unified flushing. This makes the cost of
reading the stats more predictable (proportional to the size of the
subtree), as well as the freshness of the stats. Since userspace readers
are not expected to have similar concurrency to in-kernel flushers,
serializing them among themselves and among in-kernel flushers should be
okay.

Note that this may make the worst case latency for reading stats worse.
Flushers may give up cgroup_rstat_lock and sleep, causing the number of
waiters for the spinlock theoritically unbounded. A reader may grab the
lock and do some work, give it up, sleep, and then wait for a long time
before acquiring it again and continuing. This is only possible if there
is high concurrency among processes reading stats of different parts of
the hierarchy, such that they are not helping each other out. Other
stats interfaces such as cpu.stat have the same theoritical problem, so
this is unlikely to be a problem in practice. If it is, we can introduce
a mutex in the stats reading path to guard against concurrent readers
competing for the lock. We have similar protection for unified flushing,
except that concurrent flushers skip instead of waiting.

An alternative is to remove flushing from the stats reading path
completely, and rely on the periodic flusher. This should be accompanied
by making the periodic flushing period tunable, and providing an
interface for userspace to force a flush, following a similar model to
/proc/vmstat. However, such a change will be hard to reverse if the
implementation needs to be changed because:
- The cost of reading stats will be very cheap and we won't be able to
  take that back easily.
- There are user-visible interfaces involved.

Hence, let's go with the change that's most reversible first. If
problems arise, we can add a mutex in the stats reading path as
described above, or follow the more user-visible approach.

This was tested on a machine with 256 cpus by running a synthetic test
The script that creates 50 top-level cgroups, each with 5 children (250
leaf cgroups). Each leaf cgroup has 10 processes running that allocate
memory beyond the cgroup limit, invoking reclaim (which is an in-kernel
unified flusher). Concurrently, one thread is spawned per-cgroup to read
the stats every second (including root, top-level, and leaf cgroups --
so total 251 threads). No regressions were observed in the total running
time; which means that non-unified userspace readers are not slowing
down in-kernel unified flushers:

Base (mm-unstable):

real	0m18.228s
user	0m9.463s
sys	60m15.879s

real	0m20.828s
user	0m8.535s
sys	70m12.364s

real	0m19.789s
user	0m9.177s
sys	66m10.798s

With this patch:

real	0m19.632s
user	0m8.608s
sys	64m23.483s

real	0m18.463s
user	0m7.465s
sys	60m34.089s

real	0m20.309s
user	0m7.754s
sys	68m2.392s

Additionally, the average latency for reading stats went down up to
8 times when reading stats of leaf cgroups in the script, as we only
have to flush the cgroup(s) being read.

[1]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com/

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f3716478bf4e..8bfb0e3395ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1607,7 +1607,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4049,7 +4049,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4124,7 +4124,7 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4626,7 +4626,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6641,7 +6641,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

