From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date: Tue, 24 Jan 2023 16:42:31 +1100
Message-ID: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcDnfPrIlRs7Mnv0oLLyOKfuvKifWQZHkSFcnl2A/vA=;
 b=tLe7CFrSVMWCB8G+nqyccZlJhPmT7dbtlKjpnf3yvgmdXD80GCPvMd/lAxTfZ01VmOzASeYDf+MSRjcmEAGoc1pQNozCLV0YPuQMbLKXn5QIQhGW9U5JMRfuYTWMub1KG+OBPcAFxWnAo9bKNhh029BZSLqrG6XbmENAa1wd7XDUp1+0oKRgD/AJuWxUmOSTsdaxFrr9dyIOoSR69ufqmF9fbi7Zas0Z2DVtqXVXtm08IIhBr1bwc567WSPtNb+osXjZmDStJ6Zx+bnK/zsU9UWANFfO4DKiSbl0boO3DYaUy5AcJRvSMqY8ThT9xLLZSxd0u4D70UCKcwa1e5Hk+w==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert vhost to use the new vm_account structure and associated
account_pinned_vm() functions.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/vhost/vdpa.c  |  9 +++++----
 drivers/vhost/vhost.c |  2 ++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f78..a31dd53 100644
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
@@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
+	if (!vdpa->use_va)
+		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
+			return -ENOMEM;
+
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
@@ -799,9 +803,6 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 	}
 
-	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
-
 	return 0;
 }
 
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
index d910910..3a9aed8 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -144,6 +144,7 @@ struct vhost_msg_node {
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
+	struct vm_account vm_account;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-- 
git-series 0.9.1
