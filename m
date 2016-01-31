From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv5 2/3] IB/core: added support to use rdma cgroup controller
Date: Sun, 31 Jan 2016 10:05:11 +0530
Message-ID: <1454214912-10965-3-git-send-email-pandit.parav@gmail.com>
References: <1454214912-10965-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NQU2S6yRHi/NR3GksQshIZr60RQKakvuFKZOEzUhjig=;
        b=tyKeqpwI474KMd0emJ7OhwhoXG+hgLVYGcQyv2JrTTjvY/rTdH6LFKDrK2AAoU1t3q
         V2w3lI5Oe/Mc6Ns5rjY6Ycq0XmFE8xJiwk4JM5KM/KptZ00156VLU+sdjTduAOyNB+/M
         /H3QxcDt9JeB/ZD+l0LQxhvaPzBdLrpd+2vSm2UKkzD+2H+tmqN7Gruasj+m1H1XkUYV
         mrXcOsqY8KsyJLnsvku+yqJnk85IVNXNxLapA2TxzJrcmpSRqv7/si1RSFIPhe8fM+ni
         jT1hYYGG2nCuLh+0hJMq3SqmtPYoeXzqr9fDsiianDLZvp9D57CrRZh+Qp79jkD4RKL4
         74oA==
In-Reply-To: <1454214912-10965-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added support APIs for IB core to register/unregister every RDMA device
with rdma cgroup for tracking verbs and hw resources.
IB core registers with rdma cgroup controller and also defines resources
that can be accounted.
Added support APIs for uverbs layer to make use of rdma controller.
Added uverbs layer to perform resource charge/uncharge functionality.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      | 138 ++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h   |  45 ++++++++
 drivers/infiniband/core/device.c      |   8 ++
 drivers/infiniband/core/uverbs_cmd.c  | 209 +++++++++++++++++++++++++++++++---
 drivers/infiniband/core/uverbs_main.c |  28 +++++
 include/rdma/ib_verbs.h               |  27 ++++-
 7 files changed, 440 insertions(+), 16 deletions(-)
 create mode 100644 drivers/infiniband/core/cgroup.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index d43a899..df40cee 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -13,6 +13,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
+ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
diff --git a/drivers/infiniband/core/cgroup.c b/drivers/infiniband/core/cgroup.c
new file mode 100644
index 0000000..2c23cfd
--- /dev/null
+++ b/drivers/infiniband/core/cgroup.c
@@ -0,0 +1,138 @@
+/*
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/cgroup_rdma.h>
+#include <linux/parser.h>
+
+#include "core_priv.h"
+
+/**
+ * resource table definition as to be seen by the user.
+ * Need to add entries to it when more resources are
+ * added/defined at IB verb/core layer.
+ */
+static match_table_t resource_tokens = {
+	{RDMA_VERB_RESOURCE_UCTX, "uctx=%d"},
+	{RDMA_VERB_RESOURCE_AH, "ah=%d"},
+	{RDMA_VERB_RESOURCE_PD, "pd=%d"},
+	{RDMA_VERB_RESOURCE_CQ, "cq=%d"},
+	{RDMA_VERB_RESOURCE_MR, "mr=%d"},
+	{RDMA_VERB_RESOURCE_MW, "mw=%d"},
+	{RDMA_VERB_RESOURCE_SRQ, "srq=%d"},
+	{RDMA_VERB_RESOURCE_QP, "qp=%d"},
+	{RDMA_VERB_RESOURCE_FLOW, "flow=%d"},
+	{-1, NULL}
+};
+
+/**
+ * setup table pointers for RDMA cgroup to access.
+ */
+static struct rdmacg_pool_info verbs_token_info = {
+	.resource_table = resource_tokens,
+	.resource_count =
+		(sizeof(resource_tokens) / sizeof(struct match_token)) - 1,
+};
+
+static struct rdmacg_pool_info*
+	rdmacg_get_resource_pool_tokens(struct rdmacg_device *device)
+{
+	return &verbs_token_info;
+}
+
+static struct rdmacg_resource_pool_ops verbs_pool_ops = {
+	.get_resource_pool_tokens = &rdmacg_get_resource_pool_tokens,
+};
+
+/**
+ * ib_device_register_rdmacg - register with rdma cgroup.
+ * @device: device to register to participate in resource
+ *          accounting by rdma cgroup.
+ *
+ * Register with the rdma cgroup. Should be called before
+ * exposing rdma device to user space applications to avoid
+ * resource accounting leak.
+ * HCA drivers should set resource pool ops first if they wish
+ * to support hw specific resource accounting before IB core
+ * registers with rdma cgroup.
+ */
+void ib_device_register_rdmacg(struct ib_device *device)
+{
+	rdmacg_set_rpool_ops(&device->cg_device,
+			     RDMACG_RESOURCE_POOL_VERB,
+			     &verbs_pool_ops);
+	rdmacg_register_device(&device->cg_device, device->name);
+}
+
+/**
+ * ib_device_unregister_rdmacg - unregister with rdma cgroup.
+ * @device: device to unregister.
+ *
+ * Unregister with the rdma cgroup. Should be called after
+ * all the resources are deallocated, and after a stage when any
+ * other resource allocation of user application cannot be done
+ * for this device to avoid any leak in accounting.
+ * HCA drivers should clear resource pool ops after ib stack
+ * unregisters with rdma cgroup.
+ */
+void ib_device_unregister_rdmacg(struct ib_device *device)
+{
+	rdmacg_unregister_device(&device->cg_device);
+	rdmacg_clear_rpool_ops(&device->cg_device,
+			       RDMACG_RESOURCE_POOL_VERB);
+}
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_pool_type type,
+			 int resource_index, int num)
+{
+	return rdmacg_try_charge(&cg_obj->cg, &device->cg_device,
+				 type, resource_index, num);
+}
+EXPORT_SYMBOL(ib_rdmacg_try_charge);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_pool_type type,
+			int resource_index, int num)
+{
+	rdmacg_uncharge(cg_obj->cg, &device->cg_device,
+			type, resource_index, num);
+}
+EXPORT_SYMBOL(ib_rdmacg_uncharge);
+
+int ib_rdmacg_query_limit(struct ib_device *device,
+			  enum rdmacg_resource_pool_type type,
+			  int *limits, int max_count)
+{
+	return rdmacg_query_limit(&device->cg_device, type, limits, max_count);
+}
+EXPORT_SYMBOL(ib_rdmacg_query_limit);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 5cf6eb7..977988a 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 
 #include <rdma/ib_verbs.h>
+#include <linux/cgroup_rdma.h>
 
 int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
@@ -92,4 +93,48 @@ int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
 
+#ifdef CONFIG_CGROUP_RDMA
+
+void ib_device_register_rdmacg(struct ib_device *device);
+void ib_device_unregister_rdmacg(struct ib_device *device);
+
+int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+			 struct ib_device *device,
+			 enum rdmacg_resource_pool_type type,
+			 int resource_index, int num);
+
+void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+			struct ib_device *device,
+			enum rdmacg_resource_pool_type type,
+			int resource_index, int num);
+
+int ib_rdmacg_query_limit(struct ib_device *device,
+			  enum rdmacg_resource_pool_type type,
+			  int *limits, int max_count);
+#else
+static inline int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
+				       struct ib_device *device,
+				       enum rdmacg_resource_pool_type type,
+				       int resource_index, int num)
+{ return 0; }
+
+static inline void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
+				      struct ib_device *device,
+				      enum rdmacg_resource_pool_type type,
+				      int resource_index, int num)
+{ }
+
+static inline int ib_rdmacg_query_limit(struct ib_device *device,
+					enum rdmacg_resource_pool_type type,
+					int *limits, int max_count)
+{
+	int i;
+
+	for (i = 0; i < max_count; i++)
+		limits[i] = S32_MAX;
+
+	return 0;
+}
+#endif
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 179e813..59cab6b 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -352,6 +352,10 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+#ifdef CONFIG_CGROUP_RDMA
+	ib_device_register_rdmacg(device);
+#endif
+
 	ret = ib_device_register_sysfs(device, port_callback);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
@@ -405,6 +409,10 @@ void ib_unregister_device(struct ib_device *device)
 
 	mutex_unlock(&device_mutex);
 
+#ifdef CONFIG_CGROUP_RDMA
+	ib_device_unregister_rdmacg(device);
+#endif
+
 	ib_device_unregister_sysfs(device);
 	ib_cache_cleanup_one(device);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 94816ae..78006d6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -294,6 +294,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 #endif
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
+	struct ib_rdmacg_object          cg_obj;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -313,13 +314,21 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_UCTX, 1);
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
+
 	INIT_LIST_HEAD(&ucontext->pd_list);
 	INIT_LIST_HEAD(&ucontext->mr_list);
 	INIT_LIST_HEAD(&ucontext->mw_list);
@@ -386,6 +395,10 @@ err_free:
 	put_pid(ucontext->tgid);
 	ib_dev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	ib_rdmacg_uncharge(&cg_obj, ib_dev, RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_UCTX, 1);
+
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -394,7 +407,8 @@ err:
 static void copy_query_dev_fields(struct ib_uverbs_file *file,
 				  struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
-				  struct ib_device_attr *attr)
+				  struct ib_device_attr *attr,
+				  int *limits)
 {
 	resp->fw_ver		= attr->fw_ver;
 	resp->node_guid		= ib_dev->node_guid;
@@ -405,14 +419,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->vendor_part_id	= attr->vendor_part_id;
 	resp->hw_ver		= attr->hw_ver;
 	resp->max_qp		= attr->max_qp;
+	resp->max_qp		= min_t(int, attr->max_qp,
+					limits[RDMA_VERB_RESOURCE_QP]);
 	resp->max_qp_wr		= attr->max_qp_wr;
 	resp->device_cap_flags	= attr->device_cap_flags;
 	resp->max_sge		= attr->max_sge;
 	resp->max_sge_rd	= attr->max_sge_rd;
-	resp->max_cq		= attr->max_cq;
+	resp->max_cq		= min_t(int, attr->max_cq,
+					limits[RDMA_VERB_RESOURCE_CQ]);
 	resp->max_cqe		= attr->max_cqe;
-	resp->max_mr		= attr->max_mr;
-	resp->max_pd		= attr->max_pd;
+	resp->max_mr		= min_t(int, attr->max_mr,
+					limits[RDMA_VERB_RESOURCE_MR]);
+	resp->max_pd		= min_t(int, attr->max_pd,
+					limits[RDMA_VERB_RESOURCE_PD]);
 	resp->max_qp_rd_atom	= attr->max_qp_rd_atom;
 	resp->max_ee_rd_atom	= attr->max_ee_rd_atom;
 	resp->max_res_rd_atom	= attr->max_res_rd_atom;
@@ -421,16 +440,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->atomic_cap		= attr->atomic_cap;
 	resp->max_ee			= attr->max_ee;
 	resp->max_rdd			= attr->max_rdd;
-	resp->max_mw			= attr->max_mw;
+	resp->max_mw			= min_t(int, attr->max_mw,
+						limits[RDMA_VERB_RESOURCE_MW]);
 	resp->max_raw_ipv6_qp		= attr->max_raw_ipv6_qp;
 	resp->max_raw_ethy_qp		= attr->max_raw_ethy_qp;
 	resp->max_mcast_grp		= attr->max_mcast_grp;
 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
-	resp->max_ah			= attr->max_ah;
+	resp->max_ah			= min_t(int, attr->max_ah,
+						limits[RDMA_VERB_RESOURCE_AH]);
 	resp->max_fmr			= attr->max_fmr;
 	resp->max_map_per_fmr		= attr->max_map_per_fmr;
-	resp->max_srq			= attr->max_srq;
+	resp->max_srq			= min_t(int, attr->max_srq,
+						limits[RDMA_VERB_RESOURCE_SRQ]);
 	resp->max_srq_wr		= attr->max_srq_wr;
 	resp->max_srq_sge		= attr->max_srq_sge;
 	resp->max_pkeys			= attr->max_pkeys;
@@ -447,6 +469,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_query_device_resp resp;
 	struct ib_device_attr              attr;
 	int                                ret;
+	int                                limits[RDMA_VERB_RESOURCE_MAX];
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -458,14 +481,23 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ret = ib_rdmacg_query_limit(ib_dev,
+				    RDMACG_RESOURCE_POOL_VERB,
+				    limits, RDMA_VERB_RESOURCE_MAX);
+	if (ret)
+		goto err;
+
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, ib_dev, &resp, &attr);
+	copy_query_dev_fields(file, ib_dev, &resp, &attr, limits);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
+
+err:
+	return ret;
 }
 
 ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
@@ -545,6 +577,14 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, file->device->ib_dev,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_PD, 1);
+	if (ret) {
+		kfree(uobj);
+		return -EPERM;
+	}
+
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
@@ -590,6 +630,9 @@ err_idr:
 	ib_dealloc_pd(pd);
 
 err:
+	ib_rdmacg_uncharge(&uobj->cg_obj, file->device->ib_dev,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_PD, 1);
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -602,6 +645,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	struct ib_uverbs_dealloc_pd cmd;
 	struct ib_uobject          *uobj;
 	struct ib_pd		   *pd;
+	struct ib_device           *device;
 	int                         ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -622,6 +666,12 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
+	device = uobj->context->device;
+
+	ib_rdmacg_uncharge(&uobj->cg_obj, device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_PD, 1);
+
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
@@ -995,6 +1045,12 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		}
 	}
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_MR, 1);
+	if (ret)
+		goto err_charge;
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1043,6 +1099,11 @@ err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_MR, 1);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1152,6 +1213,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	struct ib_uverbs_dereg_mr cmd;
 	struct ib_mr             *mr;
 	struct ib_uobject	 *uobj;
+	struct ib_pd             *pd;
 	int                       ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -1163,6 +1225,8 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 
 	mr = uobj->object;
 
+	pd = mr->pd;
+
 	ret = ib_dereg_mr(mr);
 	if (!ret)
 		uobj->live = 0;
@@ -1172,6 +1236,10 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_MR, 1);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1214,6 +1282,12 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_MW, 1);
+	if (ret)
+		goto err_charge;
+
 	mw = pd->device->alloc_mw(pd, cmd.mw_type);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
@@ -1259,6 +1333,11 @@ err_unalloc:
 	ib_dealloc_mw(mw);
 
 err_put:
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_MW, 1);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1273,6 +1352,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_dealloc_mw cmd;
 	struct ib_mw               *mw;
+	struct ib_pd               *pd;
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
@@ -1284,6 +1364,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	mw = uobj->object;
+	pd = mw->pd;
 
 	ret = ib_dealloc_mw(mw);
 	if (!ret)
@@ -1294,6 +1375,10 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_MW, 1);
+
 	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1393,6 +1478,12 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
+	ret = ib_rdmacg_try_charge(&obj->uobject.cg_obj, file->device->ib_dev,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_CQ, 1);
+	if (ret)
+		goto err_charge;
+
 	cq = ib_dev->create_cq(ib_dev, &attr,
 					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
@@ -1440,6 +1531,11 @@ err_free:
 	ib_destroy_cq(cq);
 
 err_file:
+	ib_rdmacg_uncharge(&obj->uobject.cg_obj, file->device->ib_dev,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_CQ, 1);
+
+err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
@@ -1720,6 +1816,10 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, uobj->context->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_CQ, 1);
+
 	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1775,6 +1875,12 @@ static int create_qp(struct ib_uverbs_file *file,
 		  &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
+	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
 		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
 				     &xrcd_uobj);
@@ -1809,8 +1915,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
 		rcq = rcq ?: scq;
-		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-		if (!pd || !scq) {
+		if (!scq) {
 			ret = -EINVAL;
 			goto err_put;
 		}
@@ -1856,6 +1961,12 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_QP, 1);
+	if (ret)
+		goto err_put;
+
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1863,7 +1974,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_create;
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
@@ -1938,6 +2049,11 @@ err_cb:
 err_destroy:
 	ib_destroy_qp(qp);
 
+err_create:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_QP, 1);
+
 err_put:
 	if (xrcd)
 		put_xrcd_read(xrcd_uobj);
@@ -2377,6 +2493,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_qp_resp resp;
 	struct ib_uobject		*uobj;
 	struct ib_qp               	*qp;
+	struct ib_pd                    *pd;
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
@@ -2389,6 +2506,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
+	pd  = qp->pd;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
@@ -2405,6 +2523,10 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_QP, 1);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2846,10 +2968,16 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = ib_rdmacg_try_charge(&uobj->cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_AH, 1);
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
@@ -2885,6 +3013,11 @@ err_copy:
 err_destroy:
 	ib_destroy_ah(ah);
 
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_AH, 1);
+
 err_put:
 	put_pd_read(pd);
 
@@ -2899,6 +3032,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_ah cmd;
 	struct ib_ah		   *ah;
+	struct ib_pd		   *pd;
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
@@ -2909,6 +3043,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
+	pd = ah->pd;
 
 	ret = ib_destroy_ah(ah);
 	if (!ret)
@@ -2919,6 +3054,10 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_AH, 1);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -3171,10 +3310,17 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
+
+	err = ib_rdmacg_try_charge(&uobj->cg_obj, qp->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_FLOW, 1);
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
@@ -3208,6 +3354,10 @@ err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	ib_rdmacg_uncharge(&uobj->cg_obj, qp->pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_FLOW, 1);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3228,6 +3378,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_flow	cmd;
 	struct ib_flow			*flow_id;
 	struct ib_uobject		*uobj;
+	struct ib_pd			*pd;
 	int				ret;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3245,11 +3396,16 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
+	pd = flow_id->qp->pd;
 
 	ret = ib_destroy_flow(flow_id);
 	if (!ret)
 		uobj->live = 0;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_FLOW, 1);
+
 	put_uobj_write(uobj);
 
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
@@ -3316,6 +3472,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
+	ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_SRQ, 1);
+	if (ret)
+		goto err_put_cq;
+
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -3380,6 +3542,9 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
+	ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_SRQ, 1);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -3540,6 +3705,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_srq_resp resp;
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
+	struct ib_pd                     *pd;
 	struct ib_uevent_object        	 *obj;
 	int                         	  ret = -EINVAL;
 	struct ib_usrq_object		 *us;
@@ -3554,6 +3720,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
 	srq_type = srq->srq_type;
+	pd = srq->pd;
 
 	ret = ib_destroy_srq(srq);
 	if (!ret)
@@ -3564,6 +3731,10 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_SRQ, 1);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
@@ -3597,6 +3768,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_ex_query_device_resp resp;
 	struct ib_uverbs_ex_query_device  cmd;
 	struct ib_device_attr attr;
+	int    limits[RDMA_VERB_RESOURCE_MAX];
 	int err;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3623,7 +3795,14 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
+	err = ib_rdmacg_query_limit(ib_dev,
+				    RDMACG_RESOURCE_POOL_VERB,
+				    limits, RDMA_VERB_RESOURCE_MAX);
+	if (err)
+		goto end;
+
+	copy_query_dev_fields(file, ib_dev, &resp.base, &attr, limits);
+
 	resp.comp_mask = 0;
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e3ef288..1d8292c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 
 #include "uverbs.h"
+#include "core_priv.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
@@ -214,6 +215,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, ah->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_AH, 1);
 		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
@@ -223,6 +227,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, mw->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_MW, 1);
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		ib_dealloc_mw(mw);
 		kfree(uobj);
@@ -231,6 +238,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, flow_id->qp->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_FLOW, 1);
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
@@ -245,6 +255,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		if (qp != qp->real_qp) {
 			ib_close_qp(qp);
 		} else {
+			ib_rdmacg_uncharge(&uobj->cg_obj, qp->pd->device,
+					   RDMACG_RESOURCE_POOL_VERB,
+					   RDMA_VERB_RESOURCE_QP, 1);
 			ib_uverbs_detach_umcast(qp, uqp);
 			ib_destroy_qp(qp);
 		}
@@ -257,6 +270,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, srq->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_SRQ, 1);
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
@@ -269,6 +285,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, cq->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_CQ, 1);
 		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
@@ -278,6 +297,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, mr->pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_MR, 1);
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
@@ -298,11 +320,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
+		ib_rdmacg_uncharge(&uobj->cg_obj, pd->device,
+				   RDMACG_RESOURCE_POOL_VERB,
+				   RDMA_VERB_RESOURCE_PD, 1);
 		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
 
+	ib_rdmacg_uncharge(&context->cg_obj, context->device,
+			   RDMACG_RESOURCE_POOL_VERB,
+			   RDMA_VERB_RESOURCE_UCTX, 1);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a68a19..e109752 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -55,6 +55,8 @@
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
 
+#include <linux/cgroup_rdma.h>
+
 extern struct workqueue_struct *ib_wq;
 
 union ib_gid {
@@ -95,6 +97,19 @@ enum rdma_protocol_type {
 	RDMA_PROTOCOL_USNIC_UDP
 };
 
+enum rdma_resource_type {
+	RDMA_VERB_RESOURCE_UCTX,
+	RDMA_VERB_RESOURCE_AH,
+	RDMA_VERB_RESOURCE_PD,
+	RDMA_VERB_RESOURCE_CQ,
+	RDMA_VERB_RESOURCE_MR,
+	RDMA_VERB_RESOURCE_MW,
+	RDMA_VERB_RESOURCE_SRQ,
+	RDMA_VERB_RESOURCE_QP,
+	RDMA_VERB_RESOURCE_FLOW,
+	RDMA_VERB_RESOURCE_MAX,
+};
+
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
@@ -1231,6 +1246,12 @@ struct ib_fmr_attr {
 
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
@@ -1261,12 +1282,14 @@ struct ib_ucontext {
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
 #endif
+	struct ib_rdmacg_object cg_obj;
 };
 
 struct ib_uobject {
 	u64			user_handle;	/* handle given to us by userspace */
 	struct ib_ucontext     *context;	/* associated user context */
 	void		       *object;		/* containing object */
+	struct ib_rdmacg_object cg_obj;
 	struct list_head	list;		/* link to context's list */
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
@@ -1822,7 +1845,9 @@ struct ib_device {
 	u16                          is_switch:1;
 	u8                           node_type;
 	u8                           phys_port_cnt;
-
+#ifdef CONFIG_CGROUP_RDMA
+	struct rdmacg_device	     cg_device;
+#endif
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
1.8.3.1
