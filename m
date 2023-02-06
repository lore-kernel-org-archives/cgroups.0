From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/19] fpga: dfl: afu: convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:50 +1100
Message-ID: <4c3fcdfd0617ca7e21bb826c8749adcf00bfe956.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwomzvkBEgGdYf53g0ZL4eXFuNuoN5c1QyS6vm/9qcg=;
 b=szKlcEMHt1BgLN5SGRfE+C6PmQoXkp0dTCEshpWFI/Smn6e5C+3VYLY2QZzhs3jW5Zr7Wb/+8xkUe/R4GNRV+cmPWyFKJL8Rtr9kBvKwp3wwldrosMOZQ3UIpx5OzAWgfJTO92qN5mGGd9qIo11rdP7k19YYqVqCHD9Jwlu5k6n83GJqUsitF+DtgNz/H+KWLy8+f5on9rsznstPZHuGI34hmt2ynwQbuw/phRbFl5Ax34Z1QisK+TUxM+R2451e3RmAO8/TsTWUYggivf2fiJuilRN4NluWPVknhV7EPnUE8NEfTowCMIVRHcPY5sjsFOxFtNnxAdD7+VElgb+BPg==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xu Yilun <yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To charge pinned pages against the pins cgroup drivers must use the
vm_account_pinned() functions which requires initialisation of a
struct vm_account. Convert the dfl-afu-region code to do this and
charge any pins to the pins cgroup.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Xu Yilun <yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/fpga/dfl-afu-dma-region.c | 11 ++++++++---
 drivers/fpga/dfl-afu.h            |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/fpga/dfl-afu-dma-region.c b/drivers/fpga/dfl-afu-dma-region.c
index 02b60fd..3b99784 100644
--- a/drivers/fpga/dfl-afu-dma-region.c
+++ b/drivers/fpga/dfl-afu-dma-region.c
@@ -38,7 +38,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 	struct device *dev = &pdata->dev->dev;
 	int ret, pinned;
 
-	ret = account_locked_vm(current->mm, npages, true);
+	ret = vm_account_pinned(&region->vm_account, npages);
 	if (ret)
 		return ret;
 
@@ -67,7 +67,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 free_pages:
 	kfree(region->pages);
 unlock_vm:
-	account_locked_vm(current->mm, npages, false);
+	vm_unaccount_pinned(&region->vm_account, npages);
 	return ret;
 }
 
@@ -87,7 +87,7 @@ static void afu_dma_unpin_pages(struct dfl_feature_platform_data *pdata,
 
 	unpin_user_pages(region->pages, npages);
 	kfree(region->pages);
-	account_locked_vm(current->mm, npages, false);
+	vm_unaccount_pinned(&region->vm_account, npages);
 
 	dev_dbg(dev, "%ld pages unpinned\n", npages);
 }
@@ -223,6 +223,7 @@ void afu_dma_region_destroy(struct dfl_feature_platform_data *pdata)
 			afu_dma_unpin_pages(pdata, region);
 
 		node = rb_next(node);
+		vm_account_release(&region->vm_account);
 		kfree(region);
 	}
 }
@@ -322,6 +323,8 @@ int afu_dma_map_region(struct dfl_feature_platform_data *pdata,
 	region->user_addr = user_addr;
 	region->length = length;
 
+	vm_account_init_current(&region->vm_account);
+
 	/* Pin the user memory region */
 	ret = afu_dma_pin_pages(pdata, region);
 	if (ret) {
@@ -365,6 +368,7 @@ int afu_dma_map_region(struct dfl_feature_platform_data *pdata,
 unpin_pages:
 	afu_dma_unpin_pages(pdata, region);
 free_region:
+	vm_account_release(&region->vm_account);
 	kfree(region);
 	return ret;
 }
@@ -399,6 +403,7 @@ int afu_dma_unmap_region(struct dfl_feature_platform_data *pdata, u64 iova)
 	dma_unmap_page(dfl_fpga_pdata_to_parent(pdata),
 		       region->iova, region->length, DMA_BIDIRECTIONAL);
 	afu_dma_unpin_pages(pdata, region);
+	vm_account_release(&region->vm_account);
 	kfree(region);
 
 	return 0;
diff --git a/drivers/fpga/dfl-afu.h b/drivers/fpga/dfl-afu.h
index e5020e2..2ca6117 100644
--- a/drivers/fpga/dfl-afu.h
+++ b/drivers/fpga/dfl-afu.h
@@ -18,6 +18,7 @@
 #define __DFL_AFU_H
 
 #include <linux/mm.h>
+#include <linux/vm_account.h>
 
 #include "dfl.h"
 
@@ -51,6 +52,7 @@ struct dfl_afu_mmio_region {
  * @in_use: flag to indicate if this region is in_use.
  */
 struct dfl_afu_dma_region {
+	struct vm_account vm_account;
 	u64 user_addr;
 	u64 length;
 	u64 iova;
-- 
git-series 0.9.1
