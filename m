From: Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 02/10] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
Date: Wed, 21 Sep 2022 16:59:54 +0000
Message-ID: <20220921170002.29557-3-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=752ad/zAEG/6KeMcUBzMu9pWUcBuWGq8SqU7i/8Af4Q=;
        b=ctY4BKSR3+VtoeXZ+S4ZKkux+Q1OUenAzPs/7AL6PkxO8AdoE7qdlVVPfLccV3VoGA
         fHZflnl0sZwFqyysd0UZKhCzmt+/wYS0t05ggRvRDts2/dpIZJ6mHc3BJPK19l3Sj0Cw
         tMFIEPhAqCiYrNkv64e/hgvhLQHWezrMwPgTZgVuCeoTEzGPVWz+SdQDnju2+M4WKCwS
         p+p+vZOws/G2p3htlBoylLCkCVtvAVg15Hiyb5Kyl9sAPK7LrOoZFDbLgFuVc6IZG3aO
         GrezZHi0jb2uFI9OukNkeBf+0cQZflwvg3/Hb8uQniMWG7uHOX6Mvo+YDFxc3zZChLuL
         U8hQ==
In-Reply-To: <20220921170002.29557-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

We can use this helper when CONFIG_MEMCG_KMEM or CONFIG_MEMCG is not set.
It also moves bpf_map_{get,put}_memcg into include/linux/bpf.h, so
these two helpers can be used in other source files.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h        | 26 ++++++++++++++++++++++++++
 include/linux/memcontrol.h | 10 ++++++++++
 kernel/bpf/syscall.c       | 13 -------------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e0dbe0c..9ae1504 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2656,4 +2657,29 @@ static inline void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype) {}
 static inline void bpf_cgroup_atype_put(int cgroup_atype) {}
 #endif /* CONFIG_BPF_LSM */
 
+#ifdef CONFIG_MEMCG_KMEM
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	if (map->objcg)
+		return get_mem_cgroup_from_objcg(map->objcg);
+
+	return root_mem_cgroup;
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	mem_cgroup_put(memcg);
+}
+
+#else
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	return root_memcg();
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6257867..d4a0ad3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -361,6 +361,11 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return root_mem_cgroup;
+}
+
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
 	MEMCG_DATA_OBJCGS = (1UL << 0),
@@ -1158,6 +1163,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 #define MEM_CGROUP_ID_SHIFT	0
 #define MEM_CGROUP_ID_MAX	0
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 70d5f70..574ddc3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -433,19 +433,6 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 		obj_cgroup_put(map->objcg);
 }
 
-static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
-{
-	if (map->objcg)
-		return get_mem_cgroup_from_objcg(map->objcg);
-
-	return root_mem_cgroup;
-}
-
-static void bpf_map_put_memcg(struct mem_cgroup *memcg)
-{
-	mem_cgroup_put(memcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
-- 
1.8.3.1

