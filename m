From: Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 06/10] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
Date: Wed, 21 Sep 2022 16:59:58 +0000
Message-ID: <20220921170002.29557-7-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=E8MAYkdVIQP0FJEM6EBF4l8Xg/qgqUjpGYemv3sFZKw=;
        b=Qlgug0EJTn9PhpLyeh5mxZ2/UgDdHf7kf/FXA3gXzZJQImIqnKk1qK72+iKUYP8Jmn
         Kp8KiFpG5E+RRflbtRDIb8lBO48xrjsDhj3VW+NCLDbK5wXD7ehjODlRWXgXzpQfRpKO
         kErn7juPi38n3YWxo8c71AlpBn8KSyYyfB9OhzeFhlfSS94dz4nyUOVPfTzX19ziXUc1
         4hOC1yDAom+aQhvQ+Ka3nL+yQE+JoGYamz/4p+g20oKVz88RehgrKH6TsC5zdKM5ve0O
         JeOSaqmiubTlLv9wDJl4oNpd74MA+/N/cYIxyA3XO9aKRZWfYkpKWoa/nlhO8KLJaxiP
         rU/A==
In-Reply-To: <20220921170002.29557-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

Allocate pages related memory into the new helper
bpf_ringbuf_pages_alloc(), then it can be handled as a single unit.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/ringbuf.c | 80 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 5eb7820..1e7284c 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -59,6 +59,57 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
+static void bpf_ringbuf_pages_free(struct page **pages, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		__free_page(pages[i]);
+	bpf_map_area_free(pages, NULL);
+}
+
+static struct page **bpf_ringbuf_pages_alloc(struct bpf_map *map,
+					     int nr_meta_pages,
+					     int nr_data_pages,
+					     int numa_node,
+					     const gfp_t flags)
+{
+	int nr_pages = nr_meta_pages + nr_data_pages;
+	struct mem_cgroup *memcg, *old_memcg;
+	struct page **pages, *page;
+	int array_size;
+	int i;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
+	pages = bpf_map_area_alloc(array_size, numa_node, NULL);
+	if (!pages)
+		goto err;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(numa_node, flags, 0);
+		if (!page) {
+			nr_pages = i;
+			goto err_free_pages;
+		}
+		pages[i] = page;
+		if (i >= nr_meta_pages)
+			pages[nr_data_pages + i] = page;
+	}
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+
+	return pages;
+
+err_free_pages:
+	bpf_ringbuf_pages_free(pages, nr_pages);
+err:
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+	return NULL;
+}
+
 static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 						  struct bpf_map *map)
 {
@@ -67,10 +118,8 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages = data_sz >> PAGE_SHIFT;
 	int nr_pages = nr_meta_pages + nr_data_pages;
-	struct page **pages, *page;
 	struct bpf_ringbuf *rb;
-	size_t array_size;
-	int i;
+	struct page **pages;
 
 	/* Each data page is mapped twice to allow "virtual"
 	 * continuous read of samples wrapping around the end of ring
@@ -89,22 +138,11 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 	 * when mmap()'ed in user-space, simplifying both kernel and
 	 * user-space implementations significantly.
 	 */
-	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	pages = bpf_map_area_alloc(array_size, numa_node, map);
+	pages = bpf_ringbuf_pages_alloc(map, nr_meta_pages, nr_data_pages,
+					numa_node, flags);
 	if (!pages)
 		return NULL;
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(numa_node, flags, 0);
-		if (!page) {
-			nr_pages = i;
-			goto err_free_pages;
-		}
-		pages[i] = page;
-		if (i >= nr_meta_pages)
-			pages[nr_data_pages + i] = page;
-	}
-
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
 		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
@@ -114,10 +152,6 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 		return rb;
 	}
 
-err_free_pages:
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
-	bpf_map_area_free(pages, NULL);
 	return NULL;
 }
 
@@ -188,12 +222,10 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 	 * to unmap rb itself with vunmap() below
 	 */
 	struct page **pages = rb->pages;
-	int i, nr_pages = rb->nr_pages;
+	int nr_pages = rb->nr_pages;
 
 	vunmap(rb);
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
-	bpf_map_area_free(pages, NULL);
+	bpf_ringbuf_pages_free(pages, nr_pages);
 }
 
 static void ringbuf_map_free(struct bpf_map *map)
-- 
1.8.3.1

