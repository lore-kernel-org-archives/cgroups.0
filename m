From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 01/11] mm: Define top tier memory node mask
Date: Mon,  5 Apr 2021 10:08:25 -0700
Message-ID: <57544494cb67299fabfa01dd17885f7b6a4266bb.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Traditionally, all RAM is DRAM.  Some DRAM might be closer/faster
than others, but a byte of media has about the same cost whether it
is close or far.  But, with new memory tiers such as High-Bandwidth
Memory or Persistent Memory, there is a choice between fast/expensive
and slow/cheap.

The fast/expensive memory lives in the top tier of the memory
hierachy and it is a precious resource that needs to be accounted and
managed on a memory cgroup basis.

Define the top tier memory as the memory nodes that don't have demotion
paths into it from higher tier memory.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/base/node.c      | 2 ++
 include/linux/nodemask.h | 1 +
 mm/memory_hotplug.c      | 3 +++
 mm/migrate.c             | 1 +
 mm/page_alloc.c          | 5 ++++-
 5 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 04f71c7bc3f8..9eb214ac331f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -1016,6 +1016,7 @@ static struct node_attr node_state_attr[] = {
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
+	[N_TOPTIER] = _NODE_ATTR(is_toptier, N_TOPTIER),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
 };
@@ -1029,6 +1030,7 @@ static struct attribute *node_state_attrs[] = {
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
+	&node_state_attr[N_TOPTIER].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
 };
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index ac398e143c9a..3003401ed7f0 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -399,6 +399,7 @@ enum node_states {
 #endif
 	N_MEMORY,		/* The node has memory(regular, high, movable) */
 	N_CPU,		/* The node has one or more cpus */
+	N_TOPTIER,		/* Top tier node, no demotion path into node */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
 };
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7550b88e2432..7b21560d4c4d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -36,6 +36,7 @@
 #include <linux/memblock.h>
 #include <linux/compaction.h>
 #include <linux/rmap.h>
+#include <linux/node.h>
 
 #include <asm/tlbflush.h>
 
@@ -654,6 +655,8 @@ static void node_states_set_node(int node, struct memory_notify *arg)
 
 	if (arg->status_change_nid >= 0)
 		node_set_state(node, N_MEMORY);
+
+	node_set_state(node, N_TOPTIER);
 }
 
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
diff --git a/mm/migrate.c b/mm/migrate.c
index 72223fd7e623..e84aedf611da 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -3439,6 +3439,7 @@ static int establish_migrate_target(int node, nodemask_t *used)
 		return NUMA_NO_NODE;
 
 	node_demotion[node] = migration_target;
+	node_clear_state(migration_target, N_TOPTIER);
 
 	return migration_target;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff058941ccfa..471a2c342c4f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -157,6 +157,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_MEMORY] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
+	[N_TOPTIER] = NODE_MASK_ALL,
 };
 EXPORT_SYMBOL(node_states);
 
@@ -7590,8 +7591,10 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
-		if (pgdat->node_present_pages)
+		if (pgdat->node_present_pages) {
 			node_set_state(nid, N_MEMORY);
+			node_set_state(nid, N_TOPTIER);
+		}
 		check_for_memory(pgdat, nid);
 	}
 }
-- 
2.20.1

