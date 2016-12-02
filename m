From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv13 2/3] IB/core: added support to use rdma cgroup controller
Date: Fri,  2 Dec 2016 19:07:16 +0000
Message-ID: <1480705637-2986-3-git-send-email-pandit.parav@gmail.com>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5jCpC76Hn05BqTJhCdoEqGHt9YAu2wCO8x3EDNR5Kbo=;
        b=glLJtIJasuR7RxZQ2ARSCab8UqIUSDOTdjQ5PXdO3UG0OaDZXzODvLboC3eeQ4RugP
         NKml3kvgm///uKENikizdiC2alpXNIYj4IS+OJ19/dAPSE932AsIlnUkJD6IiC34p8hC
         KpCTv4Smajsjal5HE2tAYar+hGdxaUeh+fs7JQugYGkqKwRkCuFXkpidRbKQppOdEuw0
         gVtzkRQWoQOiEgmwBybdIS4I50lH108dU/s9HOJrBiRkugHlI8ZOK2yNr2LpWVF27Rws
         HnVhqGTY2T9ch9Bt29Ce4MdmvaP+7DZZDz2eKFAN9FcNylGByZ3YlKZjJUd/snQARMAT
         Uv9Q==
In-Reply-To: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added support APIs for IB core to register/unregister every IB/RDMA
device with rdma cgroup for tracking rdma resources.
IB core registers with rdma cgroup controller.
Added support APIs for uverbs layer to make use of rdma controller.
Added uverbs layer to perform resource charge/uncharge functionality.
Added support during query_device uverb operation to ensure it
returns resource limits by honoring rdma cgroup configured limits.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/Makefile      |  1 +
 drivers/infiniband/core/cgroup.c      | 62 ++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h   | 30 +++++++++++
 drivers/infiniband/core/device.c      | 10 ++++
 drivers/infiniband/core/uverbs_cmd.c  | 96 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/uverbs_main.c | 20 ++++++++
 include/rdma/ib_verbs.h               | 13 +++++
 7 files changed, 226 insertions(+), 6 deletions(-)
 create mode 100644 drivers/infiniband/core/cgroup.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index edaae9f..e426ac8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -13,6 +13,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				multicast.o mad.o smi.o agent.o mad_rmpp.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
+ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
 
 ib_cm-y :=			cm.o
 
diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
new file mode 100644
index 0000000..126ac5f
--- /dev/null
+++ b/drivers/infiniband/core/cgroup.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2016 Parav Pandit <pandit.parav@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include "core_priv.h"
+
+/**
+ * ib_device_register_rdmacg - register with rdma cgroup.
+ * @device: device to register to participate in resource
+ *          accounting by rdma cgroup.
+ *
+ * Register with the rdma cgroup. Should be called before
+ * exposing rdma device to user space applications to avoid
+ * resource accounting leak.
+ * Returns 0 on success or otherwise failure code.
+ */
+int ib_device_register_rdmacg(struct ib_device *device)
+{
+	device->cg_device.name = device->name;
+	return rdmacg_register_device(&device->cg_device);
+}
+
+/**
+ * ib_device_unregister_rdmacg - unregister with rdma cgroup.
+ * @device: device to unregister.
+ *
+ * Unregister with the rdma cgroup. Should be called after
+ * all the resources are deallocated, and after a stage when any
+ * other resource allocation by user application cannot be done
+ * for this device to avoid any leak in accounting.
+ */
+void ib_device_unregister_rdmacg(struct ib_device *device)
+{
+	rdmacg_unregister_device(&device->cg_device);
+}
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_type resource_index)
+{
+	return rdmacg_try_charge(&cg_obj->cg, &device->cg_device,
+				 resource_index);
+}
+EXPORT_SYMBOL(ib_rdmacg_try_charge);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_type resource_index)
+{
+	rdmacg_uncharge(cg_obj->cg, &device->cg_device,
+			resource_index);
+}
+EXPORT_SYMBOL(ib_rdmacg_uncharge);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..efefc6b 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -124,6 +125,35 @@ int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
 
+#ifdef CONFIG_CGROUP_RDMA
+int ib_device_register_rdmacg(struct ib_device *device);
+void ib_device_unregister_rdmacg(struct ib_device *device);
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_type resource_index);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_type resource_index);
+#else
+static inline int ib_device_register_rdmacg(struct ib_device *device)
+{ return 0; }
+
+static inline void ib_device_unregister_rdmacg(struct ib_device *device)
+{ }
+
+static inline int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+				       struct ib_device *device,
+				       enum rdmacg_resource_type resource_index)
+{ return 0; }
+
+static inline void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+				      struct ib_device *device,
+				      enum rdmacg_resource_type resource_index)
+{ }
+#endif
+
 static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 					 struct net_device *upper)
 {
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 760ef60..08e3259 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -363,10 +363,18 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = ib_device_register_rdmacg(device);
+	if (ret) {
+		pr_warn("Couldn't register device with rdma cgroup\n");
+		ib_cache_cleanup_one(device);
+		goto out;
+	}
+
 	memset(&device->attrs, 0, sizeof(device->attrs));
 	ret = device->query_device(device, &device->attrs, &uhw);
 	if (ret) {
 		pr_warn("Couldn't query the device attributes\n");
+		ib_device_unregister_rdmacg(device);
 		ib_cache_cleanup_one(device);
 		goto out;
 	}
@@ -375,6 +383,7 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		pr_warn("Couldn't register device %s with driver model\n",
 			device->name);
+		ib_device_unregister_rdmacg(device);
 		ib_cache_cleanup_one(device);
 		goto out;
 	}
@@ -424,6 +433,7 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_unlock(&device_mutex);
 
+	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
 	ib_cache_cleanup_one(device);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..f8126dc 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -316,6 +316,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct ib_udata                   udata;
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
+	struct ib_rdmacg_object		 cg_obj;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -335,13 +336,18 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
+	if (ret)
+		goto err;
+
 	ucontext = ib_dev->alloc_ucontext(ib_dev, &udata);
 	if (IS_ERR(ucontext)) {
 		ret = PTR_ERR(ucontext);
-		goto err;
+		goto err_alloc;
 	}
 
 	ucontext->device = ib_dev;
+	ucontext->cg_obj = cg_obj;
 	INIT_LIST_HEAD(&ucontext->pd_list);
 	INIT_LIST_HEAD(&ucontext->mr_list);
 	INIT_LIST_HEAD(&ucontext->mw_list);
@@ -407,6 +413,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	put_pid(ucontext->tgid);
 	ib_dev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	ib_rdmacg_uncharge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -561,6 +569,13 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 		return -ENOMEM;
 
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret) {
+		kfree(uobj);
+		return ret;
+	}
+
 	down_write(&uobj->mutex);
 
 	pd = ib_dev->alloc_pd(ib_dev, file->ucontext, &udata);
@@ -605,6 +620,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	ib_dealloc_pd(pd);
 
 err:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -637,6 +653,8 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
@@ -1007,6 +1025,11 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		}
 	}
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1054,6 +1077,9 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	ib_dereg_mr(mr);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1178,6 +1204,8 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1226,6 +1254,11 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
+
 	mw = pd->device->alloc_mw(pd, cmd.mw_type, &udata);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
@@ -1271,6 +1304,9 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	uverbs_dealloc_mw(mw);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1306,6 +1342,8 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1405,6 +1443,11 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
+	ret = ib_rdmacg_try_charge(&obj->uobject.cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
+
 	cq = ib_dev->create_cq(ib_dev, &attr,
 					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
@@ -1452,6 +1495,10 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	ib_destroy_cq(cq);
 
 err_file:
+	ib_rdmacg_uncharge(&obj->uobject.cg_obj, ib_dev,
+			   RDMACG_RESOURCE_HCA_OBJECT);
+
+err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
@@ -1732,6 +1779,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1904,6 +1953,11 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_put;
+
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1911,7 +1965,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_create;
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
@@ -1992,6 +2046,10 @@ static int create_qp(struct ib_uverbs_file *file,
 err_destroy:
 	ib_destroy_qp(qp);
 
+err_create:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
+			   RDMACG_RESOURCE_HCA_OBJECT);
+
 err_put:
 	if (xrcd)
 		put_xrcd_read(xrcd_uobj);
@@ -2462,6 +2520,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2908,10 +2968,15 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
+
 	ah = ib_create_ah(pd, &attr);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
-		goto err_put;
+		goto err_create;
 	}
 
 	ah->uobject  = uobj;
@@ -2947,7 +3012,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 err_destroy:
 	ib_destroy_ah(ah);
 
-err_put:
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
+err_charge:
 	put_pd_read(pd);
 
 err:
@@ -2981,6 +3049,8 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -3743,7 +3813,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
-		goto err_free;
+		goto err_create;
 	}
 	flow_id->qp = qp;
 	flow_id->uobject = uobj;
@@ -3777,6 +3847,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3816,8 +3888,11 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	flow_id = uobj->object;
 
 	ret = ib_destroy_flow(flow_id);
-	if (!ret)
+	if (!ret) {
 		uobj->live = 0;
+		ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	}
 
 	put_uobj_write(uobj);
 
@@ -3885,6 +3960,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_put_cq;
+
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -3949,6 +4029,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	ib_destroy_srq(srq);
 
 err_put:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, ib_dev,
+			   RDMACG_RESOURCE_HCA_OBJECT);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -4135,6 +4217,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0012fa5..11160dd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "core_priv.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -236,6 +237,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -245,6 +248,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		uverbs_dealloc_mw(mw);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -253,6 +258,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -267,6 +274,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		} else {
 			ib_uverbs_detach_umcast(qp, uqp);
 			ib_destroy_qp(qp);
+			ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+					   RDMACG_RESOURCE_HCA_OBJECT);
 		}
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
@@ -300,6 +309,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
 	}
@@ -312,6 +323,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
 	}
@@ -321,6 +334,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -341,11 +356,16 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
 	put_pid(context->tgid);
 
+	ib_rdmacg_uncharge(&context->cg_obj, context->device,
+			   RDMACG_RESOURCE_HCA_HANDLE);
+
 	return context->device->dealloc_ucontext(context);
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..ea4e1e1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -60,6 +60,7 @@
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
+#include <linux/cgroup_rdma.h>
 
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
@@ -1327,6 +1328,12 @@ struct ib_fmr_attr {
 	u8	page_shift;
 };
 
+struct ib_rdmacg_object {
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdma_cgroup	*cg;		/* owner rdma cgroup */
+#endif
+};
+
 struct ib_umem;
 
 struct ib_ucontext {
@@ -1361,6 +1368,7 @@ struct ib_ucontext {
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
 #endif
+	struct ib_rdmacg_object	cg_obj;
 };
 
 struct ib_uobject {
@@ -1368,6 +1376,7 @@ struct ib_uobject {
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
+	struct ib_rdmacg_object	cg_obj;		/* rdmacg object */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
@@ -2097,6 +2106,10 @@ struct ib_device {
 	struct attribute_group	     *hw_stats_ag;
 	struct rdma_hw_stats         *hw_stats;
 
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdmacg_device		cg_device;
+#endif
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
2.7.4

