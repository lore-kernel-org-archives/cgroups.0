From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/19] drivers/vhost: Convert to use vm_account
Date: Mon,  6 Feb 2023 18:47:39 +1100
Message-ID: <a513e511b71c67453a6a420d8527fbf9a666f594.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acjFfLRivjpU9Lg3kvi0rHomIWvWZtcIDwMkhY2Ky00=;
 b=fHCzouLaE5kk62Ua+XJqCu+1MTMXe9QNNft5c35YdS0i50bvUAWqQwwDrn6WVqaAYfc5Aidg/xzaQ5SFBBhZ4gA+1ACieJwCaudY6l1BzZjCaxKVgn4qTaBx9hGKlo3/y6J/vkzzjo2G9GpCRfcCOkH2sQmIVJC57BwZg+W0DjiRsab/SpX6BqJr5kYCky0e9uZliBjJYNKp4n5PYxO1SsvltINtqi+iaoiKq/hCDojR1uoXMTeQmZEY3+t1wjV97EZ0mdNWs5YOSNhOa1mvSuEUpJttEznQpB3KvsQ9L9ynFNXmo9SFjZFg14jddI/QyfyTAlVenv/bKHF6vnVsrw==
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert vhost to use the new vm_account structure and associated
account_pinned_vm() functions. This means vhost will start enforcing
RLIMIT_MEMLOCK when a user does not have CAP_IPC_LOCK and fail the
mapping request.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/vhost/vdpa.c  | 17 ++++++++++-------
 drivers/vhost/vhost.c |  2 ++
 drivers/vhost/vhost.h |  2 ++
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f78..d970fcc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -716,7 +716,7 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(map->size));
 		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
@@ -780,10 +780,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
+	if (!vdpa->use_va)
+		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
+			return -ENOMEM;
+
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
-		return r;
+		goto out_unaccount;
 
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
@@ -794,15 +798,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
-	if (r) {
+	if (r)
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
-		return r;
-	}
 
+out_unaccount:
 	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(size));
 
-	return 0;
+	return r;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v,
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bf..5645c26 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -556,6 +556,7 @@ static void vhost_attach_mm(struct vhost_dev *dev)
 		dev->mm = current->mm;
 		mmgrab(dev->mm);
 	}
+	vm_account_init_current(&dev->vm_account);
 }
 
 static void vhost_detach_mm(struct vhost_dev *dev)
@@ -569,6 +570,7 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 		mmdrop(dev->mm);
 
 	dev->mm = NULL;
+	vm_account_release(&dev->vm_account);
 }
 
 /* Caller should have device mutex */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d910910..b2434dd 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
 #include <linux/irqbypass.h>
+#include <linux/vm_account.h>
 
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
@@ -144,6 +145,7 @@ struct vhost_msg_node {
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
+	struct vm_account vm_account;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-- 
git-series 0.9.1
