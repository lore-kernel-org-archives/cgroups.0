From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 04/19] infiniband/umem: Convert to use vm_account
Date: Tue, 24 Jan 2023 16:42:33 +1100
Message-ID: <eedd939d8ff89dd5d8cac0bd2a4d14e6f34a592c.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMvEWLA5MngzK2+7cVOKPt4IrdKvnbRxz60Bk/vscac=;
 b=PUtCVRp5axRVSwNeRP8p3B8IWqlmfZAq9ZQtbWmMDDnZ2q7GEAZU5xSokM6rdIQBZNqti/uqdPQCeQRvoH1G4/G5laKu7HD4KjhFGdFJ9DVHfZLEkcwenX84h7fKafAqd1ZP8wmmfzPFG0FiFsBueaXOnfDZEhN4ESlCr7GfGBtbgs4aToGR6CeAVgVw1w0w+kaDYrog5WWYkDdOaWjAG+58cytY0WUL4/ZEoypTXSLMNKle0MKVlhk4JhpfZmnlTGZJxzSlTBf1HMmgsV1HwbQH9cx/MyvDa8BTdD+BBCdng2Ze6wEpoz0mvfPrvEYYZKdZ4yAkDyvaRDqRkWC9/Q==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
 include/rdma/ib_umem.h             |  1 +
 3 files changed, 13 insertions(+), 10 deletions(-)

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
index 92a673c..de51406 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -19,6 +19,7 @@ struct dma_buf_attach_ops;
 struct ib_umem {
 	struct ib_device       *ibdev;
 	struct mm_struct       *owning_mm;
+	struct vm_account vm_account;
 	u64 iova;
 	size_t			length;
 	unsigned long		address;
-- 
git-series 0.9.1
