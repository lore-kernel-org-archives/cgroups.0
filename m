From: Qiang Yu <qiang.yu-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH RFC 1/3] mm: memcontrol: add mem_cgroup_(un)charge_drvmem
Date: Mon, 13 Jan 2020 23:35:41 +0800
Message-ID: <20200113153543.24957-2-qiang.yu@amd.com>
References: <20200113153543.24957-1-qiang.yu@amd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IuJUdjJ4NjgBqPCIK/ycAWJdGIDmA7IOHw8Lf6aQKM=;
 b=t2Gjvvf02iviLhJtrDTj/JboCl4gjuAtcuHLHH316g0nMYriq/JScqBwLmwx5OL66zs+0qQiSdCXqmdbAyda0hboKXTZf/3CXLtEgrolSDaTeJIVj7wPMdL7hmNO40NUnEQTP+x2zeE+T0mckGhU1E1f2D52VjCsxrbHu0zH9m4=
In-Reply-To: <20200113153543.24957-1-qiang.yu-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Koenig <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Kenny Ho <kenny.ho-5C7GfCeVMHo@public.gmane.org>, Qiang Yu <qiang.yu-5C7GfCeVMHo@public.gmane.org>

This is for driver which will allocate memory for both user application
and kernel device driver usage. For example, GPU driver will allocate
some GFP_USER pages and mapped to user to fill commands and data like
texture and vertex, then let GPU command processor "eat" these memory.
These buffers can be huge (offen several MB and may get to hundred
or even thousand MB).

Signed-off-by: Qiang Yu <qiang.yu-5C7GfCeVMHo@public.gmane.org>
---
 include/linux/memcontrol.h | 21 ++++++++++++++++
 mm/memcontrol.c            | 49 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ae703ea3ef48..d76977943265 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1363,6 +1363,27 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
 }
 #endif
 
+#ifdef CONFIG_MEMCG
+struct mem_cgroup *mem_cgroup_driver_get_from_current(void);
+int mem_cgroup_charge_drvmem(struct mem_cgroup *memcg, gfp_t gfp,
+			     unsigned long nr_pages);
+void mem_cgroup_uncharge_drvmem(struct mem_cgroup *memcg, unsigned long nr_pages);
+#else
+static inline struct mem_cgroup *mem_cgroup_get_from_current(void)
+{
+	return NULL;
+}
+
+static inline int mem_cgroup_charge_drvmem(struct mem_cgroup *memcg, gfp_t gfp,
+					   unsigned long nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_drvmem(struct mem_cgroup *memcg,
+					      unsigned long nr_pages) { }
+#endif
+
 struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 37592dd7ae32..28595c276e6b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6913,6 +6913,55 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+/**
+ * mem_cgroup_driver_get_from_current - get memcg from current task for driver
+ *
+ * Return memcg from current task, NULL otherwise.
+ */
+struct mem_cgroup *mem_cgroup_driver_get_from_current(void)
+{
+	struct mem_cgroup *memcg, *ret = NULL;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	if (memcg && memcg != root_mem_cgroup &&
+	    css_tryget_online(&memcg->css))
+		ret = memcg;
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(mem_cgroup_driver_get_from_current);
+
+/**
+ * mem_cgroup_charge_drvmem - charge a batch of pages for driver
+ * @memcg: memcg to charge
+ * @gfp: gfp flags for charge
+ * @nr_pages: number of pages to charge
+ *
+ * Return %true if success, %false otherwise.
+ */
+int mem_cgroup_charge_drvmem(struct mem_cgroup *memcg, gfp_t gfp,
+			     unsigned long nr_pages)
+{
+	return try_charge(memcg, gfp, nr_pages);
+}
+EXPORT_SYMBOL(mem_cgroup_charge_drvmem);
+
+/**
+ * mem_cgroup_uncharge_drvmem - uncharge a batch of pages for driver
+ * @memcg: memcg to uncharge
+ * @nr_pages: number of pages to uncharge
+ */
+void mem_cgroup_uncharge_drvmem(struct mem_cgroup *memcg, unsigned long nr_pages)
+{
+	refill_stock(memcg, nr_pages);
+}
+EXPORT_SYMBOL(mem_cgroup_uncharge_drvmem);
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
-- 
2.17.1

