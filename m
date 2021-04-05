From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 02/11] mm: Add soft memory limit for mem cgroup
Date: Mon,  5 Apr 2021 10:08:26 -0700
Message-ID: <96026428f135c1199a3216fde6e48317fc45486f.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

For each memory cgroup, define a soft memory limit on
its top tier memory consumption.  Memory cgroups exceeding
their top tier limit will be selected for demotion of
their top tier memory to lower tier under memory pressure.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index eeb0b52203e9..25d8b9acec7c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -230,6 +230,7 @@ struct mem_cgroup {
 	struct work_struct high_work;
 
 	unsigned long soft_limit;
+	unsigned long toptier_soft_limit;
 
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 41a3f22b6639..9a9d677a6654 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3603,6 +3603,7 @@ enum {
 	RES_MAX_USAGE,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_TOPTIER_SOFT_LIMIT,
 };
 
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
@@ -3643,6 +3644,8 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return (u64)memcg->soft_limit * PAGE_SIZE;
+	case RES_TOPTIER_SOFT_LIMIT:
+		return (u64)memcg->toptier_soft_limit * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3881,6 +3884,14 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		memcg->soft_limit = nr_pages;
 		ret = 0;
 		break;
+	case RES_TOPTIER_SOFT_LIMIT:
+		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
+			ret = -EINVAL;
+			break;
+		}
+		memcg->toptier_soft_limit = nr_pages;
+		ret = 0;
+		break;
 	}
 	return ret ?: nbytes;
 }
@@ -5029,6 +5040,12 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "toptier_soft_limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_TOPTIER_SOFT_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
@@ -5365,6 +5382,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	memcg->toptier_soft_limit = PAGE_COUNTER_MAX;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
-- 
2.20.1

