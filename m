From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 06/19] RDMA/usnic: convert to use vm_account
Date: Tue, 24 Jan 2023 16:42:35 +1100
Message-ID: <03ed2d166826cd7055810c66a175e20fa2153c52.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVSTTv9ijFATl+Jf+OCS62NKLjuBKLo0e271Utsbdkw=;
 b=g6blWCgOw4iUL8iy6QPPIj9lyTmJs/dnfznW6R32Pmeru+gzBRXTerouGEqb7Z+3HZTfJnkY5dnd3tbrbOpFNGOlbpnijc87LlwZ5WL5u180Dalp1pgYj652yQ+DAJM5b5npClD9Xx9LD3Kw63lMR/ejDDl+FzkumRXJpgOjgG1klrGzgjNHW5QWAnZSvTqmIsokLExwf8MpAb16PIUQeip8FWzu5VXlJy5wQ8MLo28oBcCt7HsiOvb5phBbNs6/fSWYSmqAkWqj4awByCyxSGE4I01+waUt8CbOZ4ickPz61GsaKXaZqoQjuIV2l4Pl5VC/NDVJ63HGPGfW81C2zg==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
 drivers/infiniband/hw/usnic/usnic_uiom.c | 13 +++++--------
 drivers/infiniband/hw/usnic/usnic_uiom.h |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c301b3b..250276e 100644
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
@@ -123,10 +121,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	uiomr->owning_mm = mm = current->mm;
 	mmap_read_lock(mm);
 
-	locked = atomic64_add_return(npages, &current->mm->pinned_vm);
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	vm_account_init_current(&uiomr->vm_account);
+	if (vm_account_pinned(&uiomr->vm_account, npages)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -178,7 +174,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 out:
 	if (ret < 0) {
 		usnic_uiom_put_pages(chunk_list, 0);
-		atomic64_sub(npages, &current->mm->pinned_vm);
+		vm_unaccount_pinned(&uiomr->vm_account, npages);
+		vm_account_release(&uiomr->vm_account);
 	} else
 		mmgrab(uiomr->owning_mm);
 
@@ -430,7 +427,7 @@ void usnic_uiom_reg_release(struct usnic_uiom_reg *uiomr)
 {
 	__usnic_uiom_reg_release(uiomr->pd, uiomr, 1);
 
-	atomic64_sub(usnic_uiom_num_pages(uiomr), &uiomr->owning_mm->pinned_vm);
+	vm_unaccount_pinned(&uiomr->vm_account, usnic_uiom_num_pages(uiomr));
 	__usnic_uiom_release_tail(uiomr);
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.h b/drivers/infiniband/hw/usnic/usnic_uiom.h
index 5a9acf9..5c296a7 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.h
@@ -72,6 +72,7 @@ struct usnic_uiom_reg {
 	struct list_head		chunk_list;
 	struct work_struct		work;
 	struct mm_struct		*owning_mm;
+	struct vm_account               vm_account;
 };
 
 struct usnic_uiom_chunk {
-- 
git-series 0.9.1
