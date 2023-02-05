From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 2/5] bpf: use bpf_map_kvcalloc in bpf_local_storage
Date: Sun,  5 Feb 2023 06:58:02 +0000
Message-ID: <20230205065805.19598-3-laoar.shao@gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cekXoP31ZR51IJygqDIUgQ8CQ5lvQGcczV3A0ytqEZw=;
        b=jW10FVIllpk2UmObYJXnztvkxz67v4iRh5dx08YuEgB9VxdIzS1XiVDjSsmQZ/yizH
         TIx1w+oPsyzs6CxqC+YnzbcuutuyIhN5hMRGUyh1LBjttodYi0B2ZZ7ar3lCimJPaj9E
         1BuCXvc77bDY99d/CMraUwg0ZxZvNljDPI6nrmwm6bJDgn1eO1VQ7Q5l+ErK1Zqm8Wti
         p0gcJ1/lWqkOpOlYWBY8uXUqPRdXOwG8a+e7bRG3KoE3rsGDtqBUhGUfTvAA305muR+V
         qhM185BVxKKTsWE28gnV1B3jLRF9uIiCIbTh3IgK950jdA8lCIlUdvQqDsNSoPnbMPgJ
         9wKQ==
In-Reply-To: <20230205065805.19598-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org
Cc: bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

Introduce new helper bpf_map_kvcalloc() for this memory allocation. Then
bpf_local_storage will be the same with other map's creation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35c18a9..fe0bf48 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1886,6 +1886,8 @@ int  generic_map_delete_batch(struct bpf_map *map,
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1902,6 +1904,12 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	return kzalloc(size, flags);
 }
 
+static inline void *
+bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size, gfp_t flags)
+{
+	return kvcalloc(n, size, flags);
+}
+
 static inline void __percpu *
 bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 		     gfp_t flags)
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 373c3c2..35f4138 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -568,8 +568,8 @@ static struct bpf_local_storage_map *__bpf_local_storage_map_alloc(union bpf_att
 	nbuckets = max_t(u32, 2, nbuckets);
 	smap->bucket_log = ilog2(nbuckets);
 
-	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
+					 nbuckets, GFP_USER | __GFP_NOWARN);
 	if (!smap->buckets) {
 		bpf_map_area_free(smap);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index bcc9761..9d94a35 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -464,6 +464,21 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	return ptr;
 }
 
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = kvcalloc(n, size, flags | __GFP_ACCOUNT);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
+
+	return ptr;
+}
+
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags)
 {
-- 
1.8.3.1

