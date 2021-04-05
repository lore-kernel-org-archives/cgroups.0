From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 04/11] mm: Report top tier memory usage in sysfs
Date: Mon,  5 Apr 2021 10:08:28 -0700
Message-ID: <1196182bf902e36c8ecbf2afb7dd570e96c99ff4.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In memory cgroup's sysfs, report the memory cgroup's usage
of top tier memory in a new field: "toptier_usage_in_bytes".

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe7bb8613f5a..68590f46fa76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3631,6 +3631,7 @@ enum {
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
 	RES_TOPTIER_SOFT_LIMIT,
+	RES_TOPTIER_USAGE,
 };
 
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
@@ -3673,6 +3674,8 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return (u64)memcg->soft_limit * PAGE_SIZE;
 	case RES_TOPTIER_SOFT_LIMIT:
 		return (u64)memcg->toptier_soft_limit * PAGE_SIZE;
+	case RES_TOPTIER_USAGE:
+		return (u64)page_counter_read(&memcg->toptier) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -5073,6 +5076,11 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "toptier_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_TOPTIER_USAGE),
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
-- 
2.20.1

