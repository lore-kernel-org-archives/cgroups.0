From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: memcontrol: cgroup2 memory statistics
Date: Thu, 14 Jan 2016 15:24:08 -0500
Message-ID: <20160114202408.GA20218@cmpxchg.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
 <20160113144916.03f03766e201b6b04a8a47cc@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160113144916.03f03766e201b6b04a8a47cc-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Jan 13, 2016 at 02:49:16PM -0800, Andrew Morton wrote:
> It would be nice to see example output, and a description of why this
> output was chosen: what was included, what was omitted, why it was
> presented this way, what units were chosen for displaying the stats and
> why.  Will the things which are being displayed still be relevant (or
> even available) 10 years from now.  etcetera.
> 
> And the interface should be documented at some point.  Doing it now
> will help with the review of the proposed interface.
> 
> Because this stuff is forever and we have to get it right.

Here is a follow-up to 1/2 that hopefully addresses all that, as well
as the 32-bit overflow problem. What do you think? I'm probably a bit
too optimistic with being able to maintain a meaningful sort order of
the file when adding new entries. It depends on whether people start
relying on items staying at fixed offsets and what we tell them in
response when that breaks. I hope that we can at least get the main
memory consumers in before this is released, just in case.

From 1be87db16a3895538ce65362b5234ef9c8af308d Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Thu, 14 Jan 2016 10:40:24 -0500
Subject: [PATCH] mm: memcontrol: basic memory statistics in cgroup2 memory
 controller fix

Fixlet addressing akpm's feedback:

- Fix overflowing byte counters on 32-bit. Just like in the existing
  interface files, bytes must be printed as u64 to work with highmem.

- Add documentation in cgroup.txt that explains the memory.stat file
  and its format.

- Rethink item ordering to accomodate potential future additions. The
  ordering now follows both 1) from big picture to detail and 2) from
  stats that reflect on userspace behavior towards stats that reflect
  on kernel heuristics. Both are gradients, and item-by-item ordering
  will still require judgement calls (and some bike shed painting).

Changelog addendum to the original patch:

The output of this file looks as follows:

$ cat memory.stat
anon 167936
file 87302144
file_mapped 0
file_dirty 0
file_writeback 0
inactive_anon 0
active_anon 155648
inactive_file 87298048
active_file 4096
unevictable 0
pgfault 636
pgmajfault 0

The list consists of two sections: statistics reflecting the current
state of the memory management subsystem, and statistics reflecting
past events. The items themselves are sorted such that generic big
picture items come before specific details, and items related to
userspace activity come before items related to kernel heuristics.

All memory counters are in bytes to eliminate all ambiguity with
variable page sizes.

There will be more items and statistics added in the future, but this
is a good initial set to get a minimum of insight into how a cgroup is
using memory, and the items chosen for now are likely to remain valid
even with significant changes to the memory management implementation.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/cgroup.txt | 56 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c          | 45 +++++++++++++++++++++++---------------
 2 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/Documentation/cgroup.txt b/Documentation/cgroup.txt
index f441564..65b3eac 100644
--- a/Documentation/cgroup.txt
+++ b/Documentation/cgroup.txt
@@ -819,6 +819,62 @@ PAGE_SIZE multiple when read back.
 		the cgroup.  This may not exactly match the number of
 		processes killed but should generally be close.
 
+  memory.stat
+
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	This breaks down the cgroup's memory footprint into different
+	types of memory, type-specific details, and other information
+	on the state and past events of the memory management system.
+
+	All memory amounts are in bytes.
+
+	The entries are ordered to be human readable, and new entries
+	can show up in the middle. Don't rely on items remaining in a
+	fixed position; use the keys to look up specific values!
+
+	  anon
+
+		Amount of memory used in anonymous mappings such as
+		brk(), sbrk(), and mmap(MAP_ANONYMOUS)
+
+	  file
+
+		Amount of memory used to cache filesystem data,
+		including tmpfs and shared memory.
+
+	  file_mapped
+
+		Amount of cached filesystem data mapped with mmap()
+
+	  file_dirty
+
+		Amount of cached filesystem data that was modified but
+		not yet written back to disk
+
+	  file_writeback
+
+		Amount of cached filesystem data that was modified and
+		is currently being written back to disk
+
+	  inactive_anon
+	  active_anon
+	  inactive_file
+	  active_file
+	  unevictable
+
+		Amount of memory, swap-backed and filesystem-backed,
+		on the internal memory management lists used by the
+		page reclaim algorithm
+
+	  pgfault
+
+		Total number of page faults incurred
+
+	  pgmajfault
+
+		Number of major page faults incurred
+
   memory.swap.current
 
 	A read-only single value file which exists on non-root
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8645852..cdb51a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5112,32 +5112,43 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	int i;
 
-	/* Memory consumer totals */
-
-	seq_printf(m, "anon %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
-	seq_printf(m, "file %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+	/*
+	 * Provide statistics on the state of the memory subsystem as
+	 * well as cumulative event counters that show past behavior.
+	 *
+	 * This list is ordered following a combination of these gradients:
+	 * 1) generic big picture -> specifics and details
+	 * 2) reflecting userspace activity -> reflecting kernel heuristics
+	 *
+	 * Current memory state:
+	 */
 
-	/* Per-consumer breakdowns */
+	seq_printf(m, "anon %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
+	seq_printf(m, "file %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+
+	seq_printf(m, "file_mapped %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) *
+		   PAGE_SIZE);
+	seq_printf(m, "file_dirty %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) *
+		   PAGE_SIZE);
+	seq_printf(m, "file_writeback %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) *
+		   PAGE_SIZE);
 
 	for (i = 0; i < NR_LRU_LISTS; i++) {
 		struct mem_cgroup *mi;
 		unsigned long val = 0;
 
 		for_each_mem_cgroup_tree(mi, memcg)
-			val += mem_cgroup_nr_lru_pages(mi, BIT(i)) * PAGE_SIZE;
-		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i], val);
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		seq_printf(m, "%s %llu\n",
+			   mem_cgroup_lru_names[i], (u64)val * PAGE_SIZE);
 	}
 
-	seq_printf(m, "file_mapped %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) * PAGE_SIZE);
-	seq_printf(m, "file_dirty %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) * PAGE_SIZE);
-	seq_printf(m, "file_writeback %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) * PAGE_SIZE);
-
-	/* Memory management events */
+	/* Accumulated memory events */
 
 	seq_printf(m, "pgfault %lu\n",
 		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
-- 
2.7.0
