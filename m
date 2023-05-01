From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 19/40] change alloc_pages name in dma_map_ops to avoid name conflicts
Date: Mon,  1 May 2023 09:54:29 -0700
Message-ID: <20230501165450.15352-20-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960151; x=1685552151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LeC1gX4P3RQjW1NYELsxA3PFCP+EdMyYyajg3MbW7ME=;
        b=hhMiGEI+67cfIr24zB7jRNLa5lThUyRZeDPUTiHuwGakXI2KeF15k1Fm45C272zpQV
         qXSafKQv0FF+5oEv4p+76TG6tqqAwOk8ME5PBGvQt4pav/Pg3OYN+Hq4oMgw3F6ZdSvk
         RmJQnKNLzSXmDQCmLfbgpYZMfqGB21dxyyqy9AGFiAL7FUCD/QaAfwt7HNGi0uvHJu82
         6NgN1S+GtTfGCTv2eTqAiK6fBQsiqTLf20nkiQTXY3Jq4fbsHdFYt1d0Idxgqw9T5cZH
         WVbgLVG1ivKLyqdpAiO34AXCSDhpXsNhycXd99B9WHPgsZw1MFzj6S84fK28jMLqmH9m
         yXMg==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

After redefining alloc_pages, all uses of that name are being replaced.
Change the conflicting names to prevent preprocessor from replacing them
when it's not intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/x86/kernel/amd_gart_64.c | 2 +-
 drivers/iommu/dma-iommu.c     | 2 +-
 drivers/xen/grant-dma-ops.c   | 2 +-
 drivers/xen/swiotlb-xen.c     | 2 +-
 include/linux/dma-map-ops.h   | 2 +-
 kernel/dma/mapping.c          | 4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 56a917df410d..842a0ec5eaa9 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -676,7 +676,7 @@ static const struct dma_map_ops gart_dma_ops = {
 	.get_sgtable			= dma_common_get_sgtable,
 	.dma_supported			= dma_direct_supported,
 	.get_required_mask		= dma_direct_get_required_mask,
-	.alloc_pages			= dma_direct_alloc_pages,
+	.alloc_pages_op			= dma_direct_alloc_pages,
 	.free_pages			= dma_direct_free_pages,
 };
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7a9f0b0bddbd..76a9d5ca4eee 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1556,7 +1556,7 @@ static const struct dma_map_ops iommu_dma_ops = {
 	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
 	.alloc			= iommu_dma_alloc,
 	.free			= iommu_dma_free,
-	.alloc_pages		= dma_common_alloc_pages,
+	.alloc_pages_op		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
 	.free_noncontiguous	= iommu_dma_free_noncontiguous,
diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index 9784a77fa3c9..6c7d984f164d 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -282,7 +282,7 @@ static int xen_grant_dma_supported(struct device *dev, u64 mask)
 static const struct dma_map_ops xen_grant_dma_ops = {
 	.alloc = xen_grant_dma_alloc,
 	.free = xen_grant_dma_free,
-	.alloc_pages = xen_grant_dma_alloc_pages,
+	.alloc_pages_op = xen_grant_dma_alloc_pages,
 	.free_pages = xen_grant_dma_free_pages,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 67aa74d20162..5ab2616153f0 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -403,6 +403,6 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.dma_supported = xen_swiotlb_dma_supported,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages = dma_common_alloc_pages,
+	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 };
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 31f114f486c4..d741940dcb3b 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -27,7 +27,7 @@ struct dma_map_ops {
 			unsigned long attrs);
 	void (*free)(struct device *dev, size_t size, void *vaddr,
 			dma_addr_t dma_handle, unsigned long attrs);
-	struct page *(*alloc_pages)(struct device *dev, size_t size,
+	struct page *(*alloc_pages_op)(struct device *dev, size_t size,
 			dma_addr_t *dma_handle, enum dma_data_direction dir,
 			gfp_t gfp);
 	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 9a4db5cce600..fc42930af14b 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -570,9 +570,9 @@ static struct page *__dma_alloc_pages(struct device *dev, size_t size,
 	size = PAGE_ALIGN(size);
 	if (dma_alloc_direct(dev, ops))
 		return dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
-	if (!ops->alloc_pages)
+	if (!ops->alloc_pages_op)
 		return NULL;
-	return ops->alloc_pages(dev, size, dma_handle, dir, gfp);
+	return ops->alloc_pages_op(dev, size, dma_handle, dir, gfp);
 }
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
-- 
2.40.1.495.gc816e09b53d-goog

