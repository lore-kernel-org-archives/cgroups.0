From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/19] vfio/type1: Charge pinned pages to pinned_vm instead of locked_vm
Date: Mon,  6 Feb 2023 18:47:44 +1100
Message-ID: <60d8812272042f497b8d661f031f2cb593370b84.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EJyBunn0zT5d/t0YMoiL/ukwvRArAw0I+071Y/Pm2k=;
 b=HdDvwTlno/2TJFtEwBIiS5c+AD1oEMvYqSxurzNyHD01OoIabNHwyzh/mIkTTgM9RtXxdonmgc5LImTBneN3gImrJwxvCtO3prL0TKaAWcP2MQIz0mjULA2GezhsbkxUfHouo9nN2zMGi79arJIK2cKCP0k29UU3oY1Vmesh6XMNMyXzk6ZdTnewXJuiGT0l1P6WEaPvoOtgok2ByKpKE+ZvFtpqZ8PxHNcfPKVqlAxX/8758AmEMs0krkoG0pqz0I6A0XwdxrMuKnjldSim9waR2MPiOJ0ZDre6eK3KkIk9o3QjRm4x6CRM0eqLykse91XKNIZp1mbef0MmDS5IEA==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cornelia Huck <cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This switches the charge to pinned_vm to be consistent with other
drivers that pin pages with FOLL_LONGTERM. It also allows the use of
the vm_account helper struct which makes a future change to implement
cgroup accounting of pinned pages easier to implement as that requires
a reference to the cgroup to be maintained.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Cornelia Huck <cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/vfio/vfio_iommu_type1.c | 60 +++++++++-------------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..a3957b8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/irqdomain.h>
+#include <linux/vm_account.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -95,11 +96,11 @@ struct vfio_dma {
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
-	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct vm_account       vm_account;
 };
 
 struct vfio_batch {
@@ -412,31 +413,6 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
-static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (!npage)
-		return 0;
-
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
-		return -ESRCH; /* process exited */
-
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
-
-	if (async)
-		mmput(mm);
-
-	return ret;
-}
-
 /*
  * Some mappings aren't backed by a struct page, for example an mmap'd
  * MMIO range for our own or another device.  These use a different
@@ -715,16 +691,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
-					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
-						__func__, limit << PAGE_SHIFT);
-					ret = -ENOMEM;
-					goto unpin_out;
-				}
+			if (!rsvd && !vfio_find_vpfn(dma, iova))
 				lock_acct++;
-			}
 
 			pinned++;
 			npage--;
@@ -744,7 +712,11 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
-	ret = vfio_lock_acct(dma, lock_acct, false);
+	if (vm_account_pinned(&dma->vm_account, lock_acct)) {
+		ret = -ENOMEM;
+		lock_acct = 0;
+		pr_warn("%s: RLIMIT_MEMLOCK exceeded\n", __func__);
+	}
 
 unpin_out:
 	if (batch->size == 1 && !batch->offset) {
@@ -759,6 +731,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				put_pfn(pfn, dma->prot);
 		}
 		vfio_batch_unpin(batch, dma);
+		vm_unaccount_pinned(&dma->vm_account, lock_acct);
 
 		return ret;
 	}
@@ -782,7 +755,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	}
 
 	if (do_accounting)
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 
 	return unlocked;
 }
@@ -805,7 +778,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vm_account_pinned(&dma->vm_account, 1);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -833,7 +806,7 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
 
 	if (do_accounting)
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 
 	return unlocked;
 }
@@ -921,7 +894,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
-				vfio_lock_acct(dma, -1, true);
+				vm_unaccount_pinned(&dma->vm_account, 1);
 			goto pin_unwind;
 		}
 
@@ -1162,7 +1135,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	if (do_accounting) {
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 		return 0;
 	}
 	return unlocked;
@@ -1674,7 +1647,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
-	dma->lock_cap = capable(CAP_IPC_LOCK);
+	vm_account_init(&dma->vm_account, dma->task, NULL, VM_ACCOUNT_TASK |
+		(capable(CAP_IPC_LOCK) ? VM_ACCOUNT_BYPASS : 0));
 
 	dma->pfn_list = RB_ROOT;
 
@@ -2398,7 +2372,7 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 			if (!is_invalid_reserved_pfn(vpfn->pfn))
 				locked++;
 		}
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 	}
 }
 
-- 
git-series 0.9.1
