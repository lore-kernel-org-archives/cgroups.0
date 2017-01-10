From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv14 2/3] IB/core: added support to use rdma cgroup controller
Date: Tue, 10 Jan 2017 00:02:14 +0000
Message-ID: <1484006535-4245-3-git-send-email-pandit.parav@gmail.com>
References: <1484006535-4245-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=whtsuB1By5JOoNMYq6nYW1HqnNKG70wdY7E7NRX5RH0=;
        b=Uo/KfX+DDqkGvD+Qi04mb8zbcf+ywCJ6bnmN4WgRx5ues+p4TYgYOi/eoc4qlNmTcj
         kKOvyN+9SLMeG8sPwFg3aAa3yoUFDwDBaLm2cQmNuzi8xXcysv9zBLC4On4+PCQqH5Fw
         TOPFATMlRH9L3vj+/43u5/Bakq48B+MDcmu+IrqxckinWgRobDSgme2lXxLk+P7HhBJu
         VKzh0SFvnXnfP/rCffZonh33hT2c7d/q+8awYcALGqLiTIUDXaOroe2K3Ot3M1Pv3Gur
         JVoUulyag2+xK2trLrvAjbrY1qryImKL3/EHg8v2sHD58o3id4wYS9xNKQ2AW/S85wVF
         idHA==
In-Reply-To: <1484006535-4245-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added support APIs for IB core to register/unregister every IB/RDMA
device with rdma cgroup for tracking rdma resources.
IB core registers with rdma cgroup controller.
Added support APIs for uverbs layer to make use of rdma controller.
Added uverbs layer to perform resource charge/uncharge functionality.
Added support during query_device uverb operation to ensure it
returns resource limits by honoring rdma cgroup configured limits.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      |  62 +++++++++++++++++++++
 drivers/infiniband/core/core_priv.h   |  30 ++++++++++
 drivers/infiniband/core/device.c      |  10 ++++
 drivers/infiniband/core/uverbs_cmd.c  | 102 ++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/uverbs_main.c |  20 +++++++
 include/rdma/ib_verbs.h               |  14 +++++
 7 files changed, 233 insertions(+), 6 deletions(-)
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
+ * Copyright (C) 2016 Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
index d293726..389f619 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -121,6 +122,35 @@ int ib_cache_setup_one(struct ib_device *device);
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
index 571974c..7006538 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -360,10 +360,18 @@ int ib_register_device(struct ib_device *device,
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
@@ -372,6 +380,7 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		pr_warn("Couldn't register device %s with driver model\n",
 			device->name);
+		ib_device_unregister_rdmacg(device);
 		ib_cache_cleanup_one(device);
 		goto out;
 	}
@@ -421,6 +430,7 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_unlock(&device_mutex);
 
+	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
 	ib_cache_cleanup_one(device);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..33bc88a 100644
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
@@ -407,6 +413,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	put_pid(ucontext->tgid);
 	ib_dev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	ib_rdmacg_uncharge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
+
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -561,6 +570,13 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
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
@@ -605,6 +621,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	ib_dealloc_pd(pd);
 
 err:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -637,6 +654,8 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
@@ -1006,6 +1025,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 	}
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
 
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
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
@@ -2518,6 +2576,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2969,11 +3029,16 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (ret)
+		goto err_charge;
+
 	ah = pd->device->create_ah(pd, &attr, &udata);
 
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
-		goto err_put;
+		goto err_create;
 	}
 
 	ah->device  = pd->device;
@@ -3012,7 +3077,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 err_destroy:
 	ib_destroy_ah(ah);
 
-err_put:
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
+err_charge:
 	put_pd_read(pd);
 
 err:
@@ -3046,6 +3114,8 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -3822,10 +3892,16 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
+
+	err = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
+	if (err)
+		goto err_free;
+
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
-		goto err_free;
+		goto err_create;
 	}
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
@@ -3858,6 +3934,8 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3897,8 +3975,11 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	flow_id = uobj->object;
 
 	ret = ib_destroy_flow(flow_id);
-	if (!ret)
+	if (!ret) {
+		ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		uobj->live = 0;
+	}
 
 	put_uobj_write(uobj);
 
@@ -3966,6 +4047,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
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
@@ -4030,6 +4116,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	ib_destroy_srq(srq);
 
 err_put:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, ib_dev,
+			   RDMACG_RESOURCE_HCA_OBJECT);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -4216,6 +4304,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_RESOURCE_HCA_OBJECT);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b3f95d4..cdbd26d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -51,6 +51,7 @@
 #include <rdma/ib.h>
 
 #include "uverbs.h"
+#include "core_priv.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -237,6 +238,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -246,6 +249,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		uverbs_dealloc_mw(mw);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -254,6 +259,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -266,6 +273,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		if (qp == qp->real_qp)
 			ib_uverbs_detach_umcast(qp, uqp);
 		ib_destroy_qp(qp);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
 	}
@@ -298,6 +307,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
 	}
@@ -310,6 +321,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
 	}
@@ -319,6 +332,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_RESOURCE_HCA_OBJECT);
 		kfree(uobj);
 	}
 
@@ -339,11 +354,16 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
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
index 958a24d..63896a4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -60,6 +60,7 @@
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup_rdma.h>
 
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
@@ -1331,6 +1332,12 @@ struct ib_fmr_attr {
 
 struct ib_umem;
 
+struct ib_rdmacg_object {
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdma_cgroup	*cg;		/* owner rdma cgroup */
+#endif
+};
+
 struct ib_ucontext {
 	struct ib_device       *device;
 	struct list_head	pd_list;
@@ -1363,6 +1370,8 @@ struct ib_ucontext {
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
 #endif
+
+	struct ib_rdmacg_object	cg_obj;
 };
 
 struct ib_uobject {
@@ -1370,6 +1379,7 @@ struct ib_uobject {
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
 	struct list_head	list;		/* link to context's list */
+	struct ib_rdmacg_object	cg_obj;		/* rdmacg object */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
@@ -2118,6 +2128,10 @@ struct ib_device {
 	struct attribute_group	     *hw_stats_ag;
 	struct rdma_hw_stats         *hw_stats;
 
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdmacg_device         cg_device;
+#endif
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
2.7.4
