From: Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 08/19] vfio/spapr_tce: Convert accounting to pinned_vm
Date: Tue, 24 Jan 2023 16:42:37 +1100
Message-ID: <876047347220d490313293a41e261999d1619030.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+GpPc9JMDnZkAHSZ8sR9hzGtxuRq+aAmVdCeEX8IvI=;
 b=rihIAfNvyXZqnt+0xpvBWi1FoOEFMDZBokr7LRw/2EeqNaDoznZEaZCIk7alKXs6YLIP/L+OJYqcgHI8LXxHtaUBRQ0X/ChlubjWtH0kgXjiGhMH43KGqLWJLDR7VZAHUaeybPg7hGCMNHM/2oTIihl0KGyhiS0Wo45iP1erH7UQSnbWc+qLdm45iO7QGDKmR+bSBccItXleOP7m4XQO0WeAS8Zz42iQwf2l52k5CTbPIb1JvA4bg80r0DzsFfyx26NILghbAJ/Wme7C9+ki5b47FvjcR0BjH7bY79f3PG3j2m2kII4lrUoBxMJbxh/51rkr6yyPgTh7hrc4bmlLfA==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org
Sender: "Linuxppc-dev" <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: Cornelia Huck <cohuck@redhat.com>, daniel@ffwll.ch, kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>, jhubbard@nvidia.com, Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org, Alex Williamson <alex.williamson@redhat.com>, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, surenb@google.com, tjmercier@google.com

Convert from accounting pages against locked_vm to accounting them to
pinned_vm. This allows struct vm_account to be used to track the
mm_struct used to charge the pages. A future change also uses this to
track a cgroup for controlling pinned pages.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/powerpc/mm/book3s64/iommu_api.c | 29 ++++++++++++++++++-----------
 drivers/vfio/vfio_iommu_spapr_tce.c  | 15 ++++++++++-----
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 7fcfba1..6c57603 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -30,6 +30,7 @@ struct mm_iommu_table_group_mem_t {
 	unsigned long used;
 	atomic64_t mapped;
 	unsigned int pageshift;
+	struct vm_account vm_account;
 	u64 ua;			/* userspace address */
 	u64 entries;		/* number of entries in hpas/hpages[] */
 	/*
@@ -62,20 +63,24 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	unsigned int pageshift;
 	unsigned long entry, chunk;
 
-	if (dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
-		ret = account_locked_vm(mm, entries, true);
-		if (ret)
-			return ret;
-
-		locked_entries = entries;
-	}
-
 	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
 	if (!mem) {
 		ret = -ENOMEM;
 		goto unlock_exit;
 	}
 
+	vm_account_init_current(&mem->vm_account);
+	if (dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
+		ret = vm_account_pinned(&mem->vm_account, entries);
+		if (ret) {
+			vm_account_release(&mem->vm_account);
+			kfree(mem);
+			return ret;
+		}
+
+		locked_entries = entries;
+	}
+
 	if (dev_hpa != MM_IOMMU_TABLE_INVALID_HPA) {
 		mem->pageshift = __ffs(dev_hpa | (entries << PAGE_SHIFT));
 		mem->dev_hpa = dev_hpa;
@@ -175,10 +180,11 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	unpin_user_pages(mem->hpages, pinned);
 
 	vfree(mem->hpas);
-	kfree(mem);
 
 unlock_exit:
-	account_locked_vm(mm, locked_entries, false);
+	vm_unaccount_pinned(&mem->vm_account, locked_entries);
+	vm_account_release(&mem->vm_account);
+	kfree(mem);
 
 	return ret;
 }
@@ -229,6 +235,7 @@ static void mm_iommu_do_free(struct mm_iommu_table_group_mem_t *mem)
 
 	mm_iommu_unpin(mem);
 	vfree(mem->hpas);
+	vm_account_release(&mem->vm_account);
 	kfree(mem);
 }
 
@@ -279,7 +286,7 @@ long mm_iommu_put(struct mm_struct *mm, struct mm_iommu_table_group_mem_t *mem)
 unlock_exit:
 	mutex_unlock(&mem_list_mutex);
 
-	account_locked_vm(mm, unlock_entries, false);
+	vm_unaccount_pinned(&mem->vm_account, unlock_entries);
 
 	return ret;
 }
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 60a50ce..a58281b 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -67,6 +67,7 @@ struct tce_container {
 	bool def_window_pending;
 	unsigned long locked_pages;
 	struct mm_struct *mm;
+	struct vm_account vm_account;
 	struct iommu_table *tables[IOMMU_TABLE_GROUP_MAX_TABLES];
 	struct list_head group_list;
 	struct list_head prereg_list;
@@ -82,6 +83,7 @@ static long tce_iommu_mm_set(struct tce_container *container)
 	BUG_ON(!current->mm);
 	container->mm = current->mm;
 	mmgrab(container->mm);
+	vm_account_init_current(&container->vm_account);
 
 	return 0;
 }
@@ -291,7 +293,7 @@ static int tce_iommu_enable(struct tce_container *container)
 		return ret;
 
 	locked = table_group->tce32_size >> PAGE_SHIFT;
-	ret = account_locked_vm(container->mm, locked, true);
+	ret = vm_account_pinned(&container->vm_accounnt, locked);
 	if (ret)
 		return ret;
 
@@ -310,7 +312,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	container->enabled = false;
 
 	BUG_ON(!container->mm);
-	account_locked_vm(container->mm, container->locked_pages, false);
+	vm_account_pinned(&container->vm_account, container->locked_pages);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -372,8 +374,10 @@ static void tce_iommu_release(void *iommu_data)
 		WARN_ON(tce_iommu_prereg_free(container, tcemem));
 
 	tce_iommu_disable(container);
-	if (container->mm)
+	if (container->mm) {
 		mmdrop(container->mm);
+		vm_account_release(&container->vm_account);
+	}
 	mutex_destroy(&container->lock);
 
 	kfree(container);
@@ -619,7 +623,8 @@ static long tce_iommu_create_table(struct tce_container *container,
 	if (!table_size)
 		return -EINVAL;
 
-	ret = account_locked_vm(container->mm, table_size >> PAGE_SHIFT, true);
+	ret = vm_account_pinned(&container->vm_account,
+				table_size >> PAGE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -638,7 +643,7 @@ static void tce_iommu_free_table(struct tce_container *container,
 	unsigned long pages = tbl->it_allocated_size >> PAGE_SHIFT;
 
 	iommu_tce_table_put(tbl);
-	account_locked_vm(container->mm, pages, false);
+	vm_unaccount_pinned(&container->vm_account, pages);
 }
 
 static long tce_iommu_create_window(struct tce_container *container,
-- 
git-series 0.9.1
