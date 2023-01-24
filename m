From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 03/19] drivers/vdpa: Convert vdpa to use the new vm_structure
Date: Tue, 24 Jan 2023 16:42:32 +1100
Message-ID: <f2e4696380f6678527a14e885556cb1bbd314737.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj03mWpjbAOXnJWeiB3fprYyHO3IklPc7NSwtjAmNx4=;
 b=LzeyY9O0+J+Ac/U78/4IatA7OJOeOWnXD//j74OXheYmfCQ9eT/hMwCD/3nPYnMZ4zpWMZrcvyMdpoaIT/0vM7OaYlTpkl1JMvO+1I2wrTSusoKtk1COMCzG7LOx7yscRyYRF8XIgMDYs3MyVDTKXlEup8RaYOgF2v8vMHgnrAfd0rzd1UB7Lnm+/MZqpQjdh8vN3h4WnZjuuf6yVvWBXii2iHHvXVmlctRAweN9qN6BvGuiA6gM5huoPUNg8qH+tvekIyb5i4hrAsAlSiTJgtUXxo5fehQU8E0YIgv1KoGQFk2zx4oBYpyAU1KEgOR0h8M0PslFl0ju5WJKj5QzCA==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Convert vdpa to use the new vm_structure and associated
account_pinned_vm() functions.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 0c3b486..bd87b58 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -70,7 +70,7 @@ struct vduse_umem {
 	unsigned long iova;
 	unsigned long npages;
 	struct page **pages;
-	struct mm_struct *mm;
+	struct vm_account vm_account;
 };
 
 struct vduse_dev {
@@ -950,8 +950,7 @@ static int vduse_dev_dereg_umem(struct vduse_dev *dev,
 	vduse_domain_remove_user_bounce_pages(dev->domain);
 	unpin_user_pages_dirty_lock(dev->umem->pages,
 				    dev->umem->npages, true);
-	atomic64_sub(dev->umem->npages, &dev->umem->mm->pinned_vm);
-	mmdrop(dev->umem->mm);
+	vm_unaccount_pinned(&dev->umem->vm_account, dev->umem->npages);
 	vfree(dev->umem->pages);
 	kfree(dev->umem);
 	dev->umem = NULL;
@@ -967,7 +966,7 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 	struct page **page_list = NULL;
 	struct vduse_umem *umem = NULL;
 	long pinned = 0;
-	unsigned long npages, lock_limit;
+	unsigned long npages;
 	int ret;
 
 	if (!dev->domain->bounce_map ||
@@ -990,8 +989,8 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 
 	mmap_read_lock(current->mm);
 
-	lock_limit = PFN_DOWN(rlimit(RLIMIT_MEMLOCK));
-	if (npages + atomic64_read(&current->mm->pinned_vm) > lock_limit)
+	vm_account_init_current(&umem->vm_account);
+	if (vm_account_pinned(&umem->vm_account, npages))
 		goto out;
 
 	pinned = pin_user_pages(uaddr, npages, FOLL_LONGTERM | FOLL_WRITE,
@@ -1006,22 +1005,21 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 	if (ret)
 		goto out;
 
-	atomic64_add(npages, &current->mm->pinned_vm);
-
 	umem->pages = page_list;
 	umem->npages = pinned;
 	umem->iova = iova;
-	umem->mm = current->mm;
-	mmgrab(current->mm);
 
 	dev->umem = umem;
 out:
-	if (ret && pinned > 0)
+	if (ret && pinned > 0) {
 		unpin_user_pages(page_list, pinned);
+		vm_unaccount_pinned(&umem->vm_account, npages);
+	}
 
 	mmap_read_unlock(current->mm);
 unlock:
 	if (ret) {
+		vm_account_release(&umem->vm_account);
 		vfree(page_list);
 		kfree(umem);
 	}
-- 
git-series 0.9.1
