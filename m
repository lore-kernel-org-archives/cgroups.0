From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/19] RDMA/usnic: convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:43 +1100
Message-ID: <f21d73f37dd795c558feb9e1b6efe62fd46509e2.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/0d5FeS1Bthw7AbdBW2nD+WSiMSiecdaEvA9kRz1hA=;
 b=aw/rHJr2ROPaFuGDV679uXnmMAVYxwJKSnQkyoLcw8StHbziYVi6NRsPvM7sHHS79m9ckuv3d6jk6AyVcrVplCXNH2/eOIUyD1MHXph6KJdLz3w+i6r1thkA4iEvEh/pOzTSma4LyfpC5NvgHsNmEyJ4/SJHbq+gRw4rcuRP1l7UPCrbfN9Puxz7MpQE66lA5G+iGGp5+qml0eX5+gb0lKtSyvK9lgOjo2gm/o/4Utv+ZrX/BBBV7wNZvVMxRJPzU+2mEOXR43REOdP+pgdN1f+k4vl/C/zk4yDCxxgb78jXMhY66NgnALKtjhQg2MCeNVwe978L/CV7THEfMW2Ibw==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert to using a vm_account structure to account pinned memory to
both the mm and the pins cgroup.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 14 ++++++--------
 drivers/infiniband/hw/usnic/usnic_uiom.h |  2 ++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c301b3b..8952ee5 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -89,8 +89,6 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	struct page **page_list;
 	struct scatterlist *sg;
 	struct usnic_uiom_chunk *chunk;
-	unsigned long locked;
-	unsigned long lock_limit;
 	unsigned long cur_base;
 	unsigned long npages;
 	int ret;
@@ -123,10 +121,9 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	uiomr->owning_mm = mm = current->mm;
 	mmap_read_lock(mm);
 
-	locked = atomic64_add_return(npages, &current->mm->pinned_vm);
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	vm_account_init_current(&uiomr->vm_account);
+	if (vm_account_pinned(&uiomr->vm_account, npages)) {
+		npages = 0;
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -178,7 +175,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 out:
 	if (ret < 0) {
 		usnic_uiom_put_pages(chunk_list, 0);
-		atomic64_sub(npages, &current->mm->pinned_vm);
+		vm_unaccount_pinned(&uiomr->vm_account, npages);
+		vm_account_release(&uiomr->vm_account);
 	} else
 		mmgrab(uiomr->owning_mm);
 
@@ -430,7 +428,7 @@ void usnic_uiom_reg_release(struct usnic_uiom_reg *uiomr)
 {
 	__usnic_uiom_reg_release(uiomr->pd, uiomr, 1);
 
-	atomic64_sub(usnic_uiom_num_pages(uiomr), &uiomr->owning_mm->pinned_vm);
+	vm_unaccount_pinned(&uiomr->vm_account, usnic_uiom_num_pages(uiomr));
 	__usnic_uiom_release_tail(uiomr);
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.h b/drivers/infiniband/hw/usnic/usnic_uiom.h
index 5a9acf9..5238d06 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.h
@@ -36,6 +36,7 @@
 
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <linux/vm_account.h>
 
 #include "usnic_uiom_interval_tree.h"
 
@@ -72,6 +73,7 @@ struct usnic_uiom_reg {
 	struct list_head		chunk_list;
 	struct work_struct		work;
 	struct mm_struct		*owning_mm;
+	struct vm_account               vm_account;
 };
 
 struct usnic_uiom_chunk {
-- 
git-series 0.9.1
