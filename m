From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/5] mm: memcontrol: introduce obj_cgroup_{un}charge_page
Date: Mon,  1 Mar 2021 14:22:23 +0800
Message-ID: <20210301062227.59292-2-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7QhLv5gQurpL6BkSCLndHABMXsANOfSdd3xoUJITvQ=;
        b=Yar2qzoSxku0EoB9WmsR/XSu1T9sO9Fx49sg1/60AwPq3qbgiP/Y8Ck4ZCrh4R6OXA
         KoZDdJzIOuO7ltFFb5kUO55IP9PwiOYtJ+QNaGTS1h7GkKdxO+01SNIzhVbNvIi/8loz
         sinz/+KSOoHEo03bdgot6IzvHDT///+t45el89jQmqGASFqmWSAo6netSHf9+g3SDwWY
         xHx4D99m4+YRf6zSAEYFB5A9ay2HO7ONkgea70W3E5xLJkikMgIJgq4cSS80xRGJvPh/
         yOFpm7UI9g2P2XOF49h4yRPoNYA7oLRwBKLB+mCzEuDssMTYf8H1xy38Duov3x/OhCEJ
         iodg==
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com, alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com, chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz, mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com, iamjoonsoo.kim@lge.com, daniel.vetter@ffw
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, duanxiongchun@bytedance.com

We know that the unit of charging slab object is bytes, the unit of
charging kmem page is PAGE_SIZE. So If we want to reuse obj_cgroup
APIs to charge the kmem pages, we should pass PAGE_SIZE (as third
parameter) to obj_cgroup_charge(). Because the charing size is page
size, we always need to refill objcg stock. This is pointless. As we
already know the charing size. So we can directly skip touch the
objcg stock and introduce obj_cgroup_{un}charge_page() to charge or
uncharge a kmem page.

In the later patch, we can reuse those helpers to charge/uncharge
the kmem pages. This is just code movement without any functional
change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2db2aeac8a9e..2eafbae504ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3060,6 +3060,34 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static inline void obj_cgroup_uncharge_page(struct obj_cgroup *objcg,
+					    unsigned int nr_pages)
+{
+	rcu_read_lock();
+	__memcg_kmem_uncharge(obj_cgroup_memcg(objcg), nr_pages);
+	rcu_read_unlock();
+}
+
+static int obj_cgroup_charge_page(struct obj_cgroup *objcg, gfp_t gfp,
+				  unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	rcu_read_lock();
+retry:
+	memcg = obj_cgroup_memcg(objcg);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+
+	css_put(&memcg->css);
+
+	return ret;
+}
+
 /**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
@@ -3184,11 +3212,8 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages) {
-			rcu_read_lock();
-			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
-			rcu_read_unlock();
-		}
+		if (nr_pages)
+			obj_cgroup_uncharge_page(old, nr_pages);
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
@@ -3246,7 +3271,6 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
-	struct mem_cgroup *memcg;
 	unsigned int nr_pages, nr_bytes;
 	int ret;
 
@@ -3263,24 +3287,16 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * refill_obj_stock(), called from this function or
 	 * independently later.
 	 */
-	rcu_read_lock();
-retry:
-	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
-	rcu_read_unlock();
-
 	nr_pages = size >> PAGE_SHIFT;
 	nr_bytes = size & (PAGE_SIZE - 1);
 
 	if (nr_bytes)
 		nr_pages += 1;
 
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	ret = obj_cgroup_charge_page(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
 		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
 
-	css_put(&memcg->css);
 	return ret;
 }
 
-- 
2.11.0

