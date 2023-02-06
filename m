From: Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 08/19] vfio/spapr_tce: Convert accounting to pinned_vm
Date: Mon,  6 Feb 2023 18:47:45 +1100
Message-ID: <f3363c545df56a835b9bf145a5a305b5e852b811.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aNGQ6CEFF/Iwo4DWZWCLfPBaTkYJe6nei2IWX2bVLk=;
 b=VT3h3BuuFakyBa1tv3zMLWgdy0gFVM4xRbhSGmYmbGmqzVcCtyci/LlF1QBXJUbYcfqQfRAGEzvCGyS97l5/O8gteE7GX0CdtPbs52p6BURnxvnjHJspqYOjLDaThTCu4IvpaqqjDxhkgNVXSsp9lkSnDOTmiGW5EtiOkLLfcHwq6/fZSwaW5ITif9x+5mFkec0S+WcCxKzehbDCIKbbn/BUXbT/NNndSJ4xwCA2g+piUzTPeaOveLcnKjI/epZ6yyBYT86+NrBi/q8u9ZzZfezDPbPUSCaxiY05/P+coJEKaaS0S864sYfyKsSPOyxFPjBpmlmG4Jslgofey51zyQ==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
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
Cc: Cornelia Huck <cohuck@redhat.com>, "Daniel P . Berrange" <berrange@redhat.com>, daniel@ffwll.ch, kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>, jhubbard@nvidia.com, Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org, Alex Williamson <alex.williamson@redhat.com>, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, surenb@google.com, tjmercier@google.com

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
 arch/powerpc/mm/book3s64/iommu_api.c | 30 ++++++++++++++++++-----------
 drivers/vfio/vfio_iommu_spapr_tce.c  | 16 ++++++++++-----
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 7fcfba1..338b111 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -18,6 +18,7 @@
 #include <asm/mmu_context.h>
 #include <asm/pte-walk.h>
 #include <linux/mm_inline.h>
+#include <linux/vm_account.h>
 
 static DEFINE_MUTEX(mem_list_mutex);
 
@@ -30,6 +31,7 @@ struct mm_iommu_table_group_mem_t {
 	unsigned long used;
 	atomic64_t mapped;
 	unsigned int pageshift;
+	struct vm_account vm_account;
 	u64 ua;			/* userspace address */
 	u64 entries;		/* number of entries in hpas/hpages[] */
 	/*
@@ -62,20 +64,24 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
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
@@ -175,10 +181,11 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
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
@@ -229,6 +236,7 @@ static void mm_iommu_do_free(struct mm_iommu_table_group_mem_t *mem)
 
 	mm_iommu_unpin(mem);
 	vfree(mem->hpas);
+	vm_account_release(&mem->vm_account);
 	kfree(mem);
 }
 
@@ -279,7 +287,7 @@ long mm_iommu_put(struct mm_struct *mm, struct mm_iommu_table_group_mem_t *mem)
 unlock_exit:
 	mutex_unlock(&mem_list_mutex);
 
-	account_locked_vm(mm, unlock_entries, false);
+	vm_unaccount_pinned(&mem->vm_account, unlock_entries);
 
 	return ret;
 }
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 60a50ce..454ccc4 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -21,6 +21,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/mm.h>
+#include <linux/vm_account.h>
 #include "vfio.h"
 
 #include <asm/iommu.h>
@@ -67,6 +68,7 @@ struct tce_container {
 	bool def_window_pending;
 	unsigned long locked_pages;
 	struct mm_struct *mm;
+	struct vm_account vm_account;
 	struct iommu_table *tables[IOMMU_TABLE_GROUP_MAX_TABLES];
 	struct list_head group_list;
 	struct list_head prereg_list;
@@ -82,6 +84,7 @@ static long tce_iommu_mm_set(struct tce_container *container)
 	BUG_ON(!current->mm);
 	container->mm = current->mm;
 	mmgrab(container->mm);
+	vm_account_init_current(&container->vm_account);
 
 	return 0;
 }
@@ -291,7 +294,7 @@ static int tce_iommu_enable(struct tce_container *container)
 		return ret;
 
 	locked = table_group->tce32_size >> PAGE_SHIFT;
-	ret = account_locked_vm(container->mm, locked, true);
+	ret = vm_account_pinned(&container->vm_accounnt, locked);
 	if (ret)
 		return ret;
 
@@ -310,7 +313,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	container->enabled = false;
 
 	BUG_ON(!container->mm);
-	account_locked_vm(container->mm, container->locked_pages, false);
+	vm_account_pinned(&container->vm_account, container->locked_pages);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -372,8 +375,10 @@ static void tce_iommu_release(void *iommu_data)
 		WARN_ON(tce_iommu_prereg_free(container, tcemem));
 
 	tce_iommu_disable(container);
-	if (container->mm)
+	if (container->mm) {
 		mmdrop(container->mm);
+		vm_account_release(&container->vm_account);
+	}
 	mutex_destroy(&container->lock);
 
 	kfree(container);
@@ -619,7 +624,8 @@ static long tce_iommu_create_table(struct tce_container *container,
 	if (!table_size)
 		return -EINVAL;
 
-	ret = account_locked_vm(container->mm, table_size >> PAGE_SHIFT, true);
+	ret = vm_account_pinned(&container->vm_account,
+				table_size >> PAGE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -638,7 +644,7 @@ static void tce_iommu_free_table(struct tce_container *container,
 	unsigned long pages = tbl->it_allocated_size >> PAGE_SHIFT;
 
 	iommu_tce_table_put(tbl);
-	account_locked_vm(container->mm, pages, false);
+	vm_unaccount_pinned(&container->vm_account, pages);
 }
 
 static long tce_iommu_create_window(struct tce_container *container,
-- 
git-series 0.9.1
