From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] mm: memcontrol: remove mem_cgroup_kmem_disabled
Date: Tue, 30 Aug 2022 13:59:48 +0800
Message-ID: <20220830055949.12640-2-ryncsn@gmail.com>
References: <20220830055949.12640-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc;
        bh=Q/bOSV74zP/orRWcu6mpaXasvBllKooATbpIY/UJY9Y=;
        b=iaukGuuSL1/LSoa2a8zvNDakcBpOAs7MfnIJteuVEJ5NQBob0p1ommjQMhEd5LlEoE
         3htxWDIFRvRg9I/rJJYiCqOKiqhZQuESXYz630zXko5IAx1WbGVcshFimeZXWGNB/SnY
         5mK/DZ0y9jYAiJ9QBGv+phsOfZG9PcdxwMV469eWeGhIZ95oTwQdHIbM4Dt1LKaGt6FH
         881oKRZvjgD5NcinenMX6woRhwbU5swnfG93gJTk69hAqwQ/f1WpTdYSuaXVBIuVuLGx
         8pSlJRwM8GFYQHytfTX0l4ArbkcaUnvJiJX1wDG4/wmZc6NG52kB5JqK3ebs3dyjcAr2
         kMBg==
In-Reply-To: <20220830055949.12640-1-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

There are currently two helpers for checking if cgroup kmem
accounting is enabled:

- mem_cgroup_kmem_disabled
- memcg_kmem_enabled

mem_cgroup_kmem_disabled is a simple helper that returns true if
cgroup.memory=nokmem is specified, otherwise returns false.

memcg_kmem_enabled is a bit different, it returns true if
cgroup.memory=nokmem is not specified and there is at least one
non-root cgroup ever created. And once there is any non-root memcg
created, it won't go back to return false again.

This may help improve performance for some corner use cases where
the user enables memory cgroup and kmem accounting globally but never
create any cgroup.

Considering that corner case is rare, especially nowadays cgroup is
widely used as a standard way to organize services. And the "once
enabled never disable" behavior is kind of strange. This commit simplifies
the behavior of memcg_kmem_enabled, making it simply the opposite of
mem_cgroup_kmem_disabled, always true if cgroup.memory=nokmem is
not specified. So mem_cgroup_kmem_disabled can be dropped.

This simplifies the code, and besides, memcg_kmem_enabled makes use
of static key so it has a lower overhead.

Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |  8 +-------
 mm/memcontrol.c            | 17 +++++++----------
 mm/percpu.c                |  2 +-
 mm/slab_common.c           |  2 +-
 4 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6257867fbf953..9c08464ed6b46 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1731,7 +1731,6 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
-bool mem_cgroup_kmem_disabled(void);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
@@ -1779,7 +1778,7 @@ static inline void count_objcg_event(struct obj_cgroup *objcg,
 {
 	struct mem_cgroup *memcg;
 
-	if (mem_cgroup_kmem_disabled())
+	if (!memcg_kmem_enabled())
 		return;
 
 	rcu_read_lock();
@@ -1825,11 +1824,6 @@ static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
 	return memcg ? memcg : root_mem_cgroup;
 }
 #else
-static inline bool mem_cgroup_kmem_disabled(void)
-{
-	return true;
-}
-
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5c..20e26ccd7dddc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -86,7 +86,7 @@ EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
 static bool cgroup_memory_nosocket __ro_after_init;
 
 /* Kernel memory accounting disabled? */
-static bool cgroup_memory_nokmem __ro_after_init;
+static bool cgroup_memory_nokmem __initdata;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
@@ -255,11 +255,6 @@ struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
 #ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
 
-bool mem_cgroup_kmem_disabled(void)
-{
-	return cgroup_memory_nokmem;
-}
-
 static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 				      unsigned int nr_pages);
 
@@ -3667,7 +3662,7 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
 
-	if (mem_cgroup_kmem_disabled())
+	if (!memcg_kmem_enabled())
 		return 0;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
@@ -3680,8 +3675,6 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 
-	static_branch_enable(&memcg_kmem_enabled_key);
-
 	memcg->kmemcg_id = memcg->id.id;
 
 	return 0;
@@ -3691,7 +3684,7 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent;
 
-	if (mem_cgroup_kmem_disabled())
+	if (!memcg_kmem_enabled())
 		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
@@ -7153,6 +7146,10 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
+
+	if (!cgroup_memory_nokmem)
+		static_branch_enable(&memcg_kmem_enabled_key);
+
 	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
diff --git a/mm/percpu.c b/mm/percpu.c
index 27697b2429c2e..c62d6e98f7d20 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1467,7 +1467,7 @@ static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
 		goto md_blocks_fail;
 
 #ifdef CONFIG_MEMCG_KMEM
-	if (!mem_cgroup_kmem_disabled()) {
+	if (memcg_kmem_enabled()) {
 		chunk->obj_cgroups =
 			pcpu_mem_zalloc(pcpu_chunk_map_bits(chunk) *
 					sizeof(struct obj_cgroup *), gfp);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 17996649cfe3e..bbdc0fe3c5e34 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -829,7 +829,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
-		if (mem_cgroup_kmem_disabled()) {
+		if (!memcg_kmem_enabled()) {
 			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
 			return;
 		}
-- 
2.35.2

