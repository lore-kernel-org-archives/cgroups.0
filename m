From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/19] RMDA/siw: Convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:42 +1100
Message-ID: <d1a04938f4ef21d48345d1d3614be10fc75d8536.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbbfhEFK8Y5g+MZUUcF50R2sJRtJy6ACgT2r4mlmBvQ=;
 b=VGMmwdNVNSN3VYOHfasKm4H2Vx/Wsl7VT43FSwx/C/VBjckm7Z0Ur3KvfO19Ogny3/QHdBpZR2TxH1cyjqViL8X1LvbN7064TIHNBeh5EjfdDvEfA9S3YswQnr4H1rsB9do+VmEPmu6pR+CKJrKAesYOh7UiZhgT6Xw1jeOcZwImkHzmAKb+GtfQH0O95kt1BZek0Szut/nml4gDoO4uPrTyJpYp8S8EaeFo1NPKt7hQA+eomC/TPpsGxux4huucOmRA290Iagg9Fe09yDrmQVpkKxf8qRnjTtgW/tFPs/ooArhZWI/x21/myiFVMKdhOB7I3OyX/xtuxucWY24OvQ==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert to using a vm_account structure to account pinned memory to
both the mm and the pins cgroup.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/sw/siw/siw.h       |  3 ++-
 drivers/infiniband/sw/siw/siw_mem.c   | 21 +++++++--------------
 drivers/infiniband/sw/siw/siw_verbs.c | 15 ---------------
 3 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index 2f3a9cd..6d4aabd 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -13,6 +13,7 @@
 #include <crypto/hash.h>
 #include <linux/crc32.h>
 #include <linux/crc32c.h>
+#include <linux/vm_account.h>
 
 #include <rdma/siw-abi.h>
 #include "iwarp.h"
@@ -124,7 +125,7 @@ struct siw_umem {
 	int num_pages;
 	bool writable;
 	u64 fp_addr; /* First page base address */
-	struct mm_struct *owning_mm;
+	struct vm_account vm_account;
 };
 
 struct siw_pble {
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index f51ab2c..be90121 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -68,7 +68,6 @@ static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
 
 void siw_umem_release(struct siw_umem *umem, bool dirty)
 {
-	struct mm_struct *mm_s = umem->owning_mm;
 	int i, num_pages = umem->num_pages;
 
 	for (i = 0; num_pages; i++) {
@@ -79,9 +78,9 @@ void siw_umem_release(struct siw_umem *umem, bool dirty)
 		kfree(umem->page_chunk[i].plist);
 		num_pages -= to_free;
 	}
-	atomic64_sub(umem->num_pages, &mm_s->pinned_vm);
+	vm_unaccount_pinned(&umem->vm_account, umem->num_pages);
+	vm_account_release(&umem->vm_account);
 
-	mmdrop(mm_s);
 	kfree(umem->page_chunk);
 	kfree(umem);
 }
@@ -365,9 +364,7 @@ struct siw_pbl *siw_pbl_alloc(u32 num_buf)
 struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 {
 	struct siw_umem *umem;
-	struct mm_struct *mm_s;
 	u64 first_page_va;
-	unsigned long mlock_limit;
 	unsigned int foll_flags = FOLL_LONGTERM;
 	int num_pages, num_chunks, i, rv = 0;
 
@@ -385,20 +382,16 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
 
-	mm_s = current->mm;
-	umem->owning_mm = mm_s;
 	umem->writable = writable;
 
-	mmgrab(mm_s);
+	vm_account_init_current(&umem->vm_account);
 
 	if (writable)
 		foll_flags |= FOLL_WRITE;
 
-	mmap_read_lock(mm_s);
+	mmap_read_lock(current->mm);
 
-	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (atomic64_add_return(num_pages, &mm_s->pinned_vm) > mlock_limit) {
+	if (vm_account_pinned(&umem->vm_account, num_pages)) {
 		rv = -ENOMEM;
 		goto out_sem_up;
 	}
@@ -434,14 +427,14 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		}
 	}
 out_sem_up:
-	mmap_read_unlock(mm_s);
+	mmap_read_unlock(current->mm);
 
 	if (rv > 0)
 		return umem;
 
 	/* Adjust accounting for pages not pinned */
 	if (num_pages)
-		atomic64_sub(num_pages, &mm_s->pinned_vm);
+		vm_unaccount_pinned(&umem->vm_account, num_pages);
 
 	siw_umem_release(umem, false);
 
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 906fde1..8fab009 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1321,8 +1321,6 @@ struct ib_mr *siw_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	struct siw_umem *umem = NULL;
 	struct siw_ureq_reg_mr ureq;
 	struct siw_device *sdev = to_siw_dev(pd->device);
-
-	unsigned long mem_limit = rlimit(RLIMIT_MEMLOCK);
 	int rv;
 
 	siw_dbg_pd(pd, "start: 0x%pK, va: 0x%pK, len: %llu\n",
@@ -1338,19 +1336,6 @@ struct ib_mr *siw_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 		rv = -EINVAL;
 		goto err_out;
 	}
-	if (mem_limit != RLIM_INFINITY) {
-		unsigned long num_pages =
-			(PAGE_ALIGN(len + (start & ~PAGE_MASK))) >> PAGE_SHIFT;
-		mem_limit >>= PAGE_SHIFT;
-
-		if (num_pages > mem_limit - current->mm->locked_vm) {
-			siw_dbg_pd(pd, "pages req %lu, max %lu, lock %lu\n",
-				   num_pages, mem_limit,
-				   current->mm->locked_vm);
-			rv = -ENOMEM;
-			goto err_out;
-		}
-	}
 	umem = siw_umem_get(start, len, ib_access_writable(rights));
 	if (IS_ERR(umem)) {
 		rv = PTR_ERR(umem);
-- 
git-series 0.9.1
