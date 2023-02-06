From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/19] infiniband/umem: Convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:41 +1100
Message-ID: <e0783b0b0f869cea19b45ee58f10618862daf6be.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ggww8xGqVkEn1m6fFSqIeGeKfBiyQH3gSOfKyWdB+MU=;
 b=Y4HQgHQbpd91DuQaDucY1BFD5ChpJLapbErCJK2J+Qdg5Zx3stAKxZfg6VuRoL8s4vyXjQXCzFra6r6nA+gOs06zJbufQur7eGvFXmHJbzoSFxkGL6DF+KhHE3q3v1ciT5JfcQtrpuAa7n1zHzaXkTUZEZfvuMMfQKE71BIrdvzHusNUsFlE0TrMLO/PV0c0lXrVjw4CBw7P+B5+SVnn04YuhMPSKptsOCYFvaEaexRvZykf3inWlxlrpw8GKCfR1+2MVlVy2sYAd831w0X9oO2VtIruCF1GfWwqfQyAItcM+2e0HwP31U+iWy2oh1Y/G8H42/B1RHbxRGtzlWnuuA==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Converts the infiniband core umem code to use the vm_account structure
so that pinned pages can be charged to the correct cgroup with
account_pinned_vm().

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/umem.c     | 16 ++++++----------
 drivers/infiniband/core/umem_odp.c |  6 ++++++
 include/rdma/ib_umem.h             |  2 ++
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 755a9c5..479b7f0 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -149,8 +149,6 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 {
 	struct ib_umem *umem;
 	struct page **page_list;
-	unsigned long lock_limit;
-	unsigned long new_pinned;
 	unsigned long cur_base;
 	unsigned long dma_attr = 0;
 	struct mm_struct *mm;
@@ -186,6 +184,7 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	umem->writable   = ib_access_writable(access);
 	umem->owning_mm = mm = current->mm;
 	mmgrab(mm);
+	vm_account_init_current(&umem->vm_account);
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list) {
@@ -199,11 +198,7 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 		goto out;
 	}
 
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	new_pinned = atomic64_add_return(npages, &mm->pinned_vm);
-	if (new_pinned > lock_limit && !capable(CAP_IPC_LOCK)) {
-		atomic64_sub(npages, &mm->pinned_vm);
+	if (vm_account_pinned(&umem->vm_account, npages)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -248,12 +243,13 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 
 umem_release:
 	__ib_umem_release(device, umem, 0);
-	atomic64_sub(ib_umem_num_pages(umem), &mm->pinned_vm);
+	vm_unaccount_pinned(&umem->vm_account, ib_umem_num_pages(umem));
 out:
 	free_page((unsigned long) page_list);
 umem_kfree:
 	if (ret) {
 		mmdrop(umem->owning_mm);
+		vm_account_release(&umem->vm_account);
 		kfree(umem);
 	}
 	return ret ? ERR_PTR(ret) : umem;
@@ -275,8 +271,8 @@ void ib_umem_release(struct ib_umem *umem)
 
 	__ib_umem_release(umem->ibdev, umem, 1);
 
-	atomic64_sub(ib_umem_num_pages(umem), &umem->owning_mm->pinned_vm);
-	mmdrop(umem->owning_mm);
+	vm_unaccount_pinned(&umem->vm_account, ib_umem_num_pages(umem));
+	vm_account_release(&umem->vm_account);
 	kfree(umem);
 }
 EXPORT_SYMBOL(ib_umem_release);
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d..4fbca3e 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -130,6 +130,7 @@ struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 	umem->ibdev = device;
 	umem->writable = ib_access_writable(access);
 	umem->owning_mm = current->mm;
+	vm_account_init_current(&umem->vm_account);
 	umem_odp->is_implicit_odp = 1;
 	umem_odp->page_shift = PAGE_SHIFT;
 
@@ -137,6 +138,7 @@ struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 	ret = ib_init_umem_odp(umem_odp, NULL);
 	if (ret) {
 		put_pid(umem_odp->tgid);
+		vm_account_release(&umem->vm_account);
 		kfree(umem_odp);
 		return ERR_PTR(ret);
 	}
@@ -179,6 +181,7 @@ ib_umem_odp_alloc_child(struct ib_umem_odp *root, unsigned long addr,
 	umem->address    = addr;
 	umem->writable   = root->umem.writable;
 	umem->owning_mm  = root->umem.owning_mm;
+	umem->vm_account = root->umem.vm_account;
 	odp_data->page_shift = PAGE_SHIFT;
 	odp_data->notifier.ops = ops;
 
@@ -239,6 +242,7 @@ struct ib_umem_odp *ib_umem_odp_get(struct ib_device *device,
 	umem_odp->umem.address = addr;
 	umem_odp->umem.writable = ib_access_writable(access);
 	umem_odp->umem.owning_mm = current->mm;
+	vm_account_init_current(&umem_odp->umem.vm_account);
 	umem_odp->notifier.ops = ops;
 
 	umem_odp->page_shift = PAGE_SHIFT;
@@ -255,6 +259,7 @@ struct ib_umem_odp *ib_umem_odp_get(struct ib_device *device,
 
 err_put_pid:
 	put_pid(umem_odp->tgid);
+	vm_account_release(&umem_odp->umem.vm_account);
 	kfree(umem_odp);
 	return ERR_PTR(ret);
 }
@@ -278,6 +283,7 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 		kvfree(umem_odp->pfn_list);
 	}
 	put_pid(umem_odp->tgid);
+	vm_account_release(&umem_odp->umem.vm_account);
 	kfree(umem_odp);
 }
 EXPORT_SYMBOL(ib_umem_odp_release);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 92a673c..065cd2c 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
+#include <linux/vm_account.h>
 #include <rdma/ib_verbs.h>
 
 struct ib_ucontext;
@@ -19,6 +20,7 @@ struct dma_buf_attach_ops;
 struct ib_umem {
 	struct ib_device       *ibdev;
 	struct mm_struct       *owning_mm;
+	struct vm_account vm_account;
 	u64 iova;
 	size_t			length;
 	unsigned long		address;
-- 
git-series 0.9.1
