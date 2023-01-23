From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] memcg: Track exported dma-buffers
Date: Mon, 23 Jan 2023 19:17:23 +0000
Message-ID: <20230123191728.2928839-2-tjmercier@google.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=29eNHuXkN4Biw7YjDro7DKxD9MLgh2JPpCUKKyMlqpA=;
        b=Subdt7mbpSJ3q++6bJrXZjJZZw2B5aXVhcYIOjpWp1e7w65W6r5oAUZpnmuhuuxtGC
         m6yHwVIfAM74kNHnxjivy2kMGAg6vCfv+3hhWBYw2BJN0Dja1Y7NQKOgWr6COa+8oUkk
         rUnUidJgv1sRL2Bt6YdHCPqVzpfizdrAy9YnM1stYfRMcfzP4DXyiUe0ObHRm1rO0ZdX
         Z1ZA/fI74arWwHwvDOYrrcmDZGCsMH3Nq+OQolvzt4CNc9tJFsaB0vn3Yw+H2aqetp8n
         bmppFH7vBRP4aW++HEHSq4uD8ir3GpzrY/G/loULfk/4Fe0e7jWIDY4IGgw0L9zKW6Fz
         9YCg==
In-Reply-To: <20230123191728.2928839-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: daniel.vetter-/w4YWyX8dFk@public.gmane.org, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

When a buffer is exported to userspace, use memcg to attribute the
buffer to the allocating cgroup until all buffer references are
released.

Unlike the dmabuf sysfs stats implementation, this memcg accounting
avoids contention over the kernfs_rwsem incurred when creating or
removing nodes.

Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 +++
 drivers/dma-buf/dma-buf.c               | 13 +++++++++
 include/linux/dma-buf.h                 |  3 ++
 include/linux/memcontrol.h              | 38 +++++++++++++++++++++++++
 mm/memcontrol.c                         | 19 +++++++++++++
 5 files changed, 77 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c8ae7c897f14..538ae22bc514 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1455,6 +1455,10 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  dmabuf (npn)
+		Amount of memory used for exported DMA buffers allocated by the cgroup.
+		Stays with the allocating cgroup regardless of how the buffer is shared.
+
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index e6528767efc7..a6a8cb5cb32d 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -75,6 +75,9 @@ static void dma_buf_release(struct dentry *dentry)
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
+	mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size) / PAGE_SIZE);
+	mem_cgroup_put(dmabuf->memcg);
+
 	dma_buf_stats_teardown(dmabuf);
 	dmabuf->ops->release(dmabuf);
 
@@ -673,6 +676,13 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	if (ret)
 		goto err_dmabuf;
 
+	dmabuf->memcg = get_mem_cgroup_from_mm(current->mm);
+	if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size) / PAGE_SIZE,
+				      GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto err_memcg;
+	}
+
 	file->private_data = dmabuf;
 	file->f_path.dentry->d_fsdata = dmabuf;
 	dmabuf->file = file;
@@ -683,6 +693,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 
 	return dmabuf;
 
+err_memcg:
+	mem_cgroup_put(dmabuf->memcg);
+	dma_buf_stats_teardown(dmabuf);
 err_dmabuf:
 	if (!resv)
 		dma_resv_fini(dmabuf->resv);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 6fa8d4e29719..1f0ffb8e4bf5 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/dma-fence.h>
 #include <linux/wait.h>
+#include <linux/memcontrol.h>
 
 struct device;
 struct dma_buf;
@@ -446,6 +447,8 @@ struct dma_buf {
 		struct dma_buf *dmabuf;
 	} *sysfs_entry;
 #endif
+	/* The cgroup to which this buffer is currently attributed */
+	struct mem_cgroup *memcg;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3c8203cab6c..c10b8565fdbf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -37,6 +37,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_DMABUF,
 	MEMCG_NR_STAT,
 };
 
@@ -673,6 +674,25 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
+
+/**
+ * mem_cgroup_charge_dmabuf - Charge dma-buf memory to a cgroup and update stat counter
+ * @memcg: memcg to charge
+ * @nr_pages: number of pages to charge
+ * @gfp_mask: reclaim mode
+ *
+ * Charges @nr_pages to @memcg. Returns %true if the charge fit within
+ * @memcg's configured limit, %false if it doesn't.
+ */
+bool __mem_cgroup_charge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages, gfp_t gfp_mask);
+static inline bool mem_cgroup_charge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages,
+					    gfp_t gfp_mask)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_charge_dmabuf(memcg, nr_pages, gfp_mask);
+}
+
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
 void __mem_cgroup_uncharge(struct folio *folio);
@@ -690,6 +710,14 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void __mem_cgroup_uncharge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_dmabuf(memcg, nr_pages);
+}
+
 void __mem_cgroup_uncharge_list(struct list_head *page_list);
 static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
@@ -1242,6 +1270,12 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool mem_cgroup_charge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages,
+					    gfp_t gfp_mask)
+{
+	return true;
+}
+
 static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry)
 {
 }
@@ -1250,6 +1284,10 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
 
+static inline void mem_cgroup_uncharge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0394ab..375d18370f4b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1502,6 +1502,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "unevictable",		NR_UNEVICTABLE			},
 	{ "slab_reclaimable",		NR_SLAB_RECLAIMABLE_B		},
 	{ "slab_unreclaimable",		NR_SLAB_UNRECLAIMABLE_B		},
+	{ "dmabuf",			MEMCG_DMABUF			},
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -4042,6 +4043,7 @@ static const unsigned int memcg1_stats[] = {
 	WORKINGSET_REFAULT_ANON,
 	WORKINGSET_REFAULT_FILE,
 	MEMCG_SWAP,
+	MEMCG_DMABUF,
 };
 
 static const char *const memcg1_stat_names[] = {
@@ -4057,6 +4059,7 @@ static const char *const memcg1_stat_names[] = {
 	"workingset_refault_anon",
 	"workingset_refault_file",
 	"swap",
+	"dmabuf",
 };
 
 /* Universal VM events cgroup1 shows, original sort order */
@@ -7299,6 +7302,22 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+bool __mem_cgroup_charge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages, gfp_t gfp_mask)
+{
+	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
+		mod_memcg_state(memcg, MEMCG_DMABUF, nr_pages);
+		return true;
+	}
+
+	return false;
+}
+
+void __mem_cgroup_uncharge_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
+	refill_stock(memcg, nr_pages);
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
-- 
2.39.0.246.g2a6d74b583-goog

