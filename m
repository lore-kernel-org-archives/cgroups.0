From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 3/5] memcg: fail to create cgroup if the cgroup id is too
 big
Date: Thu, 8 Aug 2013 10:34:14 +0800
Message-ID: <520303A6.1050801@huawei.com>
References: <52030346.4050003@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52030346.4050003-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

memcg requires the cgroup id to be smaller than 65536.

This is a preparation to kill css id.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3189f70..c0bb83c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -503,6 +503,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+/*
+ * We restrict the id in the range of [1, 65535], so it can fit into
+ * an unsigned short.
+ */
+#define MEM_CGROUP_ID_MAX	USHRT_MAX
+
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	/*
@@ -6056,6 +6062,9 @@ mem_cgroup_css_alloc(struct cgroup *cont)
 	long error = -ENOMEM;
 	int node;
 
+	if (cont->id > MEM_CGROUP_ID_MAX)
+		return ERR_PTR(-ENOSPC);
+
 	memcg = mem_cgroup_alloc();
 	if (!memcg)
 		return ERR_PTR(error);
-- 
1.8.0.2
