From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv11 2/3] IB/core: added support to use rdma cgroup controller
Date: Mon, 22 Aug 2016 18:03:50 +0530
Message-ID: <1471869231-15576-3-git-send-email-pandit.parav@gmail.com>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m/mT8wbr02Qy1A8Rqtg4KCo7aTTsX+JWSkXtIz9sK+8=;
        b=HU1uFnNdLCMd/dt330LiukDeZ6ZfFVzTjFqeD4vpNFF1h08Jb3A6QPI2W72R8dpnmB
         W5U6cIpPqAJjEsHU+c6Dxs5z0oIMiOBhKUafMBoawQWTnXxK+XHOjalY+u4mklnZmSOg
         CAmQn9bkYrJlFIe3Lvfl/KrRe0dJ37L/jE/OoBgc3OTf3UQyyuDpZ56N49HiZ8tgLSnD
         hPqfkAyaqJpu86B1ed9F2JEZ+ajKZlUtXq5b7/VwdNcFiAGH61G+whHKqre1h5BcWd5C
         NTGCarbg5bof4OQn4aFrIRCKNTWWDL+eiGYrf8RMiPsCaJzP15JIWc9nQia8FCbyqL+w
         TwEg==
In-Reply-To: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added support APIs for IB core to register/unregister every IB/RDMA
device with rdma cgroup for tracking verbs and hw resources.
IB core registers with rdma cgroup controller.
Added support APIs for uverbs layer to make use of rdma controller.
Added uverbs layer to perform resource charge/uncharge functionality.
Added support during query_device uverb operation to ensure it
returns resource limits by honoring rdma cgroup configured limits.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      |  69 +++++++++++++++++
 drivers/infiniband/core/core_priv.h   |  41 ++++++++++
 drivers/infiniband/core/device.c      |  10 +++
 drivers/infiniband/core/uverbs_cmd.c  | 136 ++++++++++++++++++++++++++++++----
 drivers/infiniband/core/uverbs_main.c |  19 +++++
 include/rdma/ib_verbs.h               |  13 ++++
 7 files changed, 273 insertions(+), 16 deletions(-)
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
index 0000000..1a85fff
--- /dev/null
+++ b/drivers/infiniband/core/cgroup.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2016 Parav Pandit <pandit.parav@gmail.com>
+ *
+ * This file is subject to the terms and conditions of version 2 of the GNU
+ * General Public License. See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+#include "core_priv.h"
+
+/*
+ * resource table definition as to be seen by the user.
+ * Need to add entries to it when more resources are
+ * added/defined at IB verb/core layer.
+ */
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
+
+void ib_rdmacg_query_limit(struct ib_device *device, int *limits)
+{
+	rdmacg_query_limit(&device->cg_device, limits);
+}
+EXPORT_SYMBOL(ib_rdmacg_query_limit);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..d1e432e 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/cgroup_rdma.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -124,6 +125,46 @@ int ib_cache_setup_one(struct ib_device *device);
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
+
+void ib_rdmacg_query_limit(struct ib_device *device, int *limits);
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
+
+static inline void ib_rdmacg_query_limit(struct ib_device *device,
+					 int *limits)
+{
+	int i;
+
+	for (i = 0; i < RDMACG_RESOURCE_MAX; i++)
+		limits[i] = S32_MAX;
+}
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
index f664731..893669b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -316,6 +316,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct ib_udata                   udata;
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
+	struct ib_rdmacg_object          cg_obj;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -335,13 +336,18 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev, RDMACG_VERB_RESOURCE_UCTX);
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
@@ -407,6 +413,9 @@ err_free:
 	put_pid(ucontext->tgid);
 	ib_dev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	ib_rdmacg_uncharge(&cg_obj, ib_dev, RDMACG_VERB_RESOURCE_UCTX);
+
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -415,7 +424,8 @@ err:
 static void copy_query_dev_fields(struct ib_uverbs_file *file,
 				  struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
-				  struct ib_device_attr *attr)
+				  struct ib_device_attr *attr,
+				  int *limits)
 {
 	resp->fw_ver		= attr->fw_ver;
 	resp->node_guid		= ib_dev->node_guid;
@@ -425,15 +435,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->vendor_id		= attr->vendor_id;
 	resp->vendor_part_id	= attr->vendor_part_id;
 	resp->hw_ver		= attr->hw_ver;
-	resp->max_qp		= attr->max_qp;
+	resp->max_qp		= min_t(int, attr->max_qp,
+					limits[RDMACG_VERB_RESOURCE_QP]);
 	resp->max_qp_wr		= attr->max_qp_wr;
 	resp->device_cap_flags	= lower_32_bits(attr->device_cap_flags);
 	resp->max_sge		= attr->max_sge;
 	resp->max_sge_rd	= attr->max_sge_rd;
-	resp->max_cq		= attr->max_cq;
+	resp->max_cq		= min_t(int, attr->max_cq,
+					limits[RDMACG_VERB_RESOURCE_CQ]);
 	resp->max_cqe		= attr->max_cqe;
-	resp->max_mr		= attr->max_mr;
-	resp->max_pd		= attr->max_pd;
+	resp->max_mr		= min_t(int, attr->max_mr,
+					limits[RDMACG_VERB_RESOURCE_MR]);
+	resp->max_pd		= min_t(int, attr->max_pd,
+					limits[RDMACG_VERB_RESOURCE_PD]);
 	resp->max_qp_rd_atom	= attr->max_qp_rd_atom;
 	resp->max_ee_rd_atom	= attr->max_ee_rd_atom;
 	resp->max_res_rd_atom	= attr->max_res_rd_atom;
@@ -442,16 +456,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->atomic_cap		= attr->atomic_cap;
 	resp->max_ee			= attr->max_ee;
 	resp->max_rdd			= attr->max_rdd;
-	resp->max_mw			= attr->max_mw;
+	resp->max_mw			= min_t(int, attr->max_mw,
+					limits[RDMACG_VERB_RESOURCE_MW]);
 	resp->max_raw_ipv6_qp		= attr->max_raw_ipv6_qp;
 	resp->max_raw_ethy_qp		= attr->max_raw_ethy_qp;
 	resp->max_mcast_grp		= attr->max_mcast_grp;
 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
-	resp->max_ah			= attr->max_ah;
+	resp->max_ah			= min_t(int, attr->max_ah,
+					limits[RDMACG_VERB_RESOURCE_AH]);
 	resp->max_fmr			= attr->max_fmr;
 	resp->max_map_per_fmr		= attr->max_map_per_fmr;
-	resp->max_srq			= attr->max_srq;
+	resp->max_srq			= min_t(int, attr->max_srq,
+					limits[RDMACG_VERB_RESOURCE_SRQ]);
 	resp->max_srq_wr		= attr->max_srq_wr;
 	resp->max_srq_sge		= attr->max_srq_sge;
 	resp->max_pkeys			= attr->max_pkeys;
@@ -466,6 +483,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_device      cmd;
 	struct ib_uverbs_query_device_resp resp;
+	int                                limits[RDMACG_RESOURCE_MAX];
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -473,8 +491,10 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	ib_rdmacg_query_limit(ib_dev, limits);
+
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs);
+	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs, limits);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -560,6 +580,13 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_PD);
+	if (ret) {
+		kfree(uobj);
+		return ret;
+	}
+
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
@@ -605,6 +632,7 @@ err_idr:
 	ib_dealloc_pd(pd);
 
 err:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_PD);
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -637,6 +665,8 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_PD);
+
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
@@ -1003,10 +1033,15 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		      IB_DEVICE_ON_DEMAND_PAGING)) {
 			pr_debug("ODP support not available\n");
 			ret = -EINVAL;
-			goto err_put;
+			goto err_charge;
 		}
 	}
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_MR);
+	if (ret)
+		goto err_charge;
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1054,6 +1089,9 @@ err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_MR);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1178,6 +1216,8 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_MR);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1226,6 +1266,11 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_MW);
+	if (ret)
+		goto err_charge;
+
 	mw = pd->device->alloc_mw(pd, cmd.mw_type, &udata);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
@@ -1271,6 +1316,9 @@ err_unalloc:
 	uverbs_dealloc_mw(mw);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_MW);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1306,6 +1354,8 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_MW);
+
 	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1405,6 +1455,11 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
+	ret = ib_rdmacg_try_charge(&obj->uobject.cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_CQ);
+	if (ret)
+		goto err_charge;
+
 	cq = ib_dev->create_cq(ib_dev, &attr,
 					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
@@ -1452,6 +1507,10 @@ err_free:
 	ib_destroy_cq(cq);
 
 err_file:
+	ib_rdmacg_uncharge(&obj->uobject.cg_obj, ib_dev,
+			   RDMACG_VERB_RESOURCE_CQ);
+
+err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
@@ -1732,6 +1791,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_CQ);
+
 	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1904,6 +1965,11 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, device,
+				   RDMACG_VERB_RESOURCE_QP);
+	if (ret)
+		goto err_put;
+
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1911,7 +1977,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_create;
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
@@ -1992,6 +2058,10 @@ err_cb:
 err_destroy:
 	ib_destroy_qp(qp);
 
+err_create:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
+			   RDMACG_VERB_RESOURCE_QP);
+
 err_put:
 	if (xrcd)
 		put_xrcd_read(xrcd_uobj);
@@ -2462,6 +2532,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_QP);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2908,10 +2980,15 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_AH);
+	if (ret)
+		goto err_put;
+
 	ah = ib_create_ah(pd, &attr);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
-		goto err_put;
+		goto err_create;
 	}
 
 	ah->uobject  = uobj;
@@ -2947,6 +3024,9 @@ err_copy:
 err_destroy:
 	ib_destroy_ah(ah);
 
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_AH);
+
 err_put:
 	put_pd_read(pd);
 
@@ -2981,6 +3061,8 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_AH);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -3688,10 +3770,16 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
+
+	err = ib_rdmacg_try_charge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_FLOW);
+	if (err)
+		goto err_free;
+
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
-		goto err_free;
+		goto err_create;
 	}
 	flow_id->qp = qp;
 	flow_id->uobject = uobj;
@@ -3725,6 +3813,8 @@ err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_FLOW);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3764,8 +3854,11 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	flow_id = uobj->object;
 
 	ret = ib_destroy_flow(flow_id);
-	if (!ret)
+	if (!ret) {
 		uobj->live = 0;
+		ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_FLOW);
+	}
 
 	put_uobj_write(uobj);
 
@@ -3833,6 +3926,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, ib_dev,
+				   RDMACG_VERB_RESOURCE_SRQ);
+	if (ret)
+		goto err_put_cq;
+
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -3897,6 +3995,8 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, ib_dev,
+			   RDMACG_VERB_RESOURCE_SRQ);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -4083,6 +4183,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev, RDMACG_VERB_RESOURCE_SRQ);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
@@ -4116,6 +4218,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_ex_query_device_resp resp = { {0} };
 	struct ib_uverbs_ex_query_device  cmd;
 	struct ib_device_attr attr = {0};
+	int    limits[RDMACG_RESOURCE_MAX];
 	int err;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -4140,7 +4243,8 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
+	ib_rdmacg_query_limit(ib_dev, limits);
+	copy_query_dev_fields(file, ib_dev, &resp.base, &attr, limits);
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
 		goto end;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0012fa5..3414eda 100644
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
+				   RDMACG_VERB_RESOURCE_AH);
 		kfree(uobj);
 	}
 
@@ -245,6 +248,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		uverbs_dealloc_mw(mw);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_MW);
 		kfree(uobj);
 	}
 
@@ -253,6 +258,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_FLOW);
 		kfree(uobj);
 	}
 
@@ -267,6 +274,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		} else {
 			ib_uverbs_detach_umcast(qp, uqp);
 			ib_destroy_qp(qp);
+			ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+					   RDMACG_VERB_RESOURCE_QP);
 		}
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
@@ -300,6 +309,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_SRQ);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
 	}
@@ -312,6 +323,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_CQ);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
 	}
@@ -321,6 +334,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_MR);
 		kfree(uobj);
 	}
 
@@ -341,9 +356,13 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
+		ib_rdmacg_uncharge(&uobj->cg_obj, context->device,
+				   RDMACG_VERB_RESOURCE_PD);
 		kfree(uobj);
 	}
 
+	ib_rdmacg_uncharge(&context->cg_obj, context->device,
+			   RDMACG_VERB_RESOURCE_UCTX);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..7178891 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -60,6 +60,7 @@
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
+#include <linux/cgroup_rdma.h>
 
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
@@ -1313,6 +1314,12 @@ struct ib_fmr_attr {
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
@@ -1347,12 +1354,14 @@ struct ib_ucontext {
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
 #endif
+	struct ib_rdmacg_object cg_obj;
 };
 
 struct ib_uobject {
 	u64			user_handle;	/* handle given to us by userspace */
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
+	struct ib_rdmacg_object cg_obj;		/* rdmacg object */
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
@@ -2043,6 +2052,10 @@ struct ib_device {
 	struct attribute_group	     *hw_stats_ag;
 	struct rdma_hw_stats         *hw_stats;
 
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdmacg_device	     cg_device;
+#endif
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
1.8.3.1

