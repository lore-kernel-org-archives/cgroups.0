From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv1 5/6] IB/core: use rdma cgroup for resource accounting
Date: Wed,  6 Jan 2016 00:28:05 +0530
Message-ID: <1452020286-9508-6-git-send-email-pandit.parav@gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5qvXfYPHFjWmUDYUQFT+mWRkUgB6PyIFFmrXe6Fp570=;
        b=aI5jbzzmf8nTS9SPcAc9/MZBDQMyidymY6oy209sfwdPIaeG47m63blqSMyu7kGzpN
         wxdzX7Vpv2HjSs7saJrV80/NR9FkgCb0mVqD2LxgmIKr3MjrkaiWJPo5lLMtRkRxGRTW
         C3pWuUvud/Mbtev0ACBQrX611Cuih8mw5LE2Z7U+huezFZoyutVYAUAHKZNVFzEPTehb
         Q4IHM1FJqkkBoCMYsonw8rCP8vusUGiNziUIOKlzzbRddr6FLm1bKFl250uyBhW6YuZn
         GFnK+7dgD7boprf6NQmm6J4f5wbB8K/bmhx5+wuFRRMUi6VUGpfIsDDZWK6JwN80SOHa
         ZV0g==
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

It uses charge API to perform resource charing before allocating low
level resource. It continues to link the resource to the owning
thread group leader task.
It uncharges the resource after successful deallocation of resource.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/device.c      |   8 ++
 drivers/infiniband/core/uverbs_cmd.c  | 244 +++++++++++++++++++++++++++++++---
 drivers/infiniband/core/uverbs_main.c |  30 +++++
 3 files changed, 265 insertions(+), 17 deletions(-)

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
index 94816ae..1b3d60b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -294,6 +294,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 #endif
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
+	struct pid                       *tgid;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -313,10 +314,20 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	rcu_read_lock();
+	tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+
+	ret = rdmacg_try_charge_resource(ib_dev, tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_UCTX, 1);
+	if (ret)
+		goto err_charge;
+
 	ucontext = ib_dev->alloc_ucontext(ib_dev, &udata);
 	if (IS_ERR(ucontext)) {
 		ret = PTR_ERR(ucontext);
-		goto err;
+		goto err_alloc;
 	}
 
 	ucontext->device = ib_dev;
@@ -330,7 +341,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
 	rcu_read_lock();
-	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	ucontext->tgid = tgid;
 	rcu_read_unlock();
 	ucontext->closing = 0;
 
@@ -383,9 +394,15 @@ err_fd:
 	put_unused_fd(resp.async_fd);
 
 err_free:
-	put_pid(ucontext->tgid);
 	ib_dev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	rdmacg_uncharge_resource(ib_dev, tgid, RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_UCTX, 1);
+
+err_charge:
+	put_pid(tgid);
+
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -394,7 +411,8 @@ err:
 static void copy_query_dev_fields(struct ib_uverbs_file *file,
 				  struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
-				  struct ib_device_attr *attr)
+				  struct ib_device_attr *attr,
+				  int *limits)
 {
 	resp->fw_ver		= attr->fw_ver;
 	resp->node_guid		= ib_dev->node_guid;
@@ -405,14 +423,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
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
@@ -421,16 +444,19 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
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
@@ -447,6 +473,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_query_device_resp resp;
 	struct ib_device_attr              attr;
 	int                                ret;
+	int                                limits[RDMA_VERB_RESOURCE_MAX];
+	struct pid                         *tgid;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -458,14 +486,28 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rcu_read_lock();
+	tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+
+	ret = rdmacg_query_resource_limit(ib_dev, tgid,
+					  RDMACG_RESOURCE_POOL_VERB,
+					  limits, RDMA_VERB_RESOURCE_MAX);
+	put_pid(tgid);
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
@@ -529,6 +571,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	struct ib_udata                udata;
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
+	struct pid                    *tgid;
 	int                            ret;
 
 	if (out_len < sizeof resp)
@@ -545,6 +588,16 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
+	tgid = file->ucontext->tgid;
+
+	ret = rdmacg_try_charge_resource(file->device->ib_dev, tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_PD, 1);
+	if (ret) {
+		kfree(uobj);
+		return -EPERM;
+	}
+
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
@@ -590,6 +643,9 @@ err_idr:
 	ib_dealloc_pd(pd);
 
 err:
+	rdmacg_uncharge_resource(file->device->ib_dev, tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_PD, 1);
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -602,6 +658,8 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	struct ib_uverbs_dealloc_pd cmd;
 	struct ib_uobject          *uobj;
 	struct ib_pd		   *pd;
+	struct pid                 *tgid;
+	struct ib_device           *device;
 	int                         ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -622,6 +680,13 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_put;
 
+	tgid = uobj->context->tgid;
+	device = uobj->context->device;
+
+	rdmacg_uncharge_resource(device, tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_PD, 1);
+
 	uobj->live = 0;
 	put_uobj_write(uobj);
 
@@ -995,6 +1060,12 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		}
 	}
 
+	ret = rdmacg_try_charge_resource(pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_MR, 1);
+	if (ret)
+		goto err_charge;
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1043,6 +1114,11 @@ err_unreg:
 	ib_dereg_mr(mr);
 
 err_put:
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_MR, 1);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1152,6 +1228,8 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	struct ib_uverbs_dereg_mr cmd;
 	struct ib_mr             *mr;
 	struct ib_uobject	 *uobj;
+	struct pid               *tgid;
+	struct ib_pd             *pd;
 	int                       ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -1163,6 +1241,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 
 	mr = uobj->object;
 
+	tgid = uobj->context->tgid;
+	pd = mr->pd;
+
 	ret = ib_dereg_mr(mr);
 	if (!ret)
 		uobj->live = 0;
@@ -1172,6 +1253,10 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rdmacg_uncharge_resource(pd->device, tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_MR, 1);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1214,6 +1299,12 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 
+	ret = rdmacg_try_charge_resource(pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_MW, 1);
+	if (ret)
+		goto err_charge;
+
 	mw = pd->device->alloc_mw(pd, cmd.mw_type);
 	if (IS_ERR(mw)) {
 		ret = PTR_ERR(mw);
@@ -1259,6 +1350,11 @@ err_unalloc:
 	ib_dealloc_mw(mw);
 
 err_put:
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_MW, 1);
+
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1273,6 +1369,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_dealloc_mw cmd;
 	struct ib_mw               *mw;
+	struct ib_pd               *pd;
 	struct ib_uobject	   *uobj;
 	int                         ret = -EINVAL;
 
@@ -1284,6 +1381,7 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	mw = uobj->object;
+	pd = mw->pd;
 
 	ret = ib_dealloc_mw(mw);
 	if (!ret)
@@ -1294,6 +1392,10 @@ ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_MW, 1);
+
 	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1359,6 +1461,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	struct ib_ucq_object           *obj;
 	struct ib_uverbs_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
+	struct pid                     *tgid;
 	int                             ret;
 	struct ib_uverbs_ex_create_cq_resp resp;
 	struct ib_cq_init_attr attr = {};
@@ -1393,6 +1496,14 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
+	tgid = file->ucontext->tgid;
+
+	ret = rdmacg_try_charge_resource(file->device->ib_dev, tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_CQ, 1);
+	if (ret)
+		goto err_charge;
+
 	cq = ib_dev->create_cq(ib_dev, &attr,
 					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
@@ -1440,6 +1551,11 @@ err_free:
 	ib_destroy_cq(cq);
 
 err_file:
+	rdmacg_uncharge_resource(file->device->ib_dev, tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_CQ, 1);
+
+err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
@@ -1697,6 +1813,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_cq_resp resp;
 	struct ib_uobject		*uobj;
 	struct ib_cq               	*cq;
+	struct ib_device                *device;
+	struct pid                      *tgid;
 	struct ib_ucq_object        	*obj;
 	struct ib_uverbs_event_file	*ev_file;
 	int                        	 ret = -EINVAL;
@@ -1720,6 +1838,12 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	tgid    = uobj->context->tgid;
+	device  = uobj->context->device;
+	rdmacg_uncharge_resource(device, tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_CQ, 1);
+
 	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1775,6 +1899,12 @@ static int create_qp(struct ib_uverbs_file *file,
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
@@ -1809,8 +1939,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
 		rcq = rcq ?: scq;
-		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-		if (!pd || !scq) {
+		if (!scq) {
 			ret = -EINVAL;
 			goto err_put;
 		}
@@ -1856,6 +1985,12 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_put;
 		}
 
+	ret = rdmacg_try_charge_resource(pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_QP, 1);
+	if (ret)
+		goto err_put;
+
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1863,7 +1998,7 @@ static int create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_create;
 	}
 
 	if (cmd->qp_type != IB_QPT_XRC_TGT) {
@@ -1938,6 +2073,11 @@ err_cb:
 err_destroy:
 	ib_destroy_qp(qp);
 
+err_create:
+	rdmacg_uncharge_resource(device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_QP, 1);
+
 err_put:
 	if (xrcd)
 		put_xrcd_read(xrcd_uobj);
@@ -2377,6 +2517,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_qp_resp resp;
 	struct ib_uobject		*uobj;
 	struct ib_qp               	*qp;
+	struct ib_pd                    *pd;
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
@@ -2389,6 +2530,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	qp  = uobj->object;
+	pd  = qp->pd;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 	if (!list_empty(&obj->mcast_list)) {
@@ -2405,6 +2547,10 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_QP, 1);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2846,10 +2992,16 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = rdmacg_try_charge_resource(pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_AH, 1);
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
@@ -2885,6 +3037,11 @@ err_copy:
 err_destroy:
 	ib_destroy_ah(ah);
 
+err_create:
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_AH, 1);
+
 err_put:
 	put_pd_read(pd);
 
@@ -2899,6 +3056,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_ah cmd;
 	struct ib_ah		   *ah;
+	struct ib_pd		   *pd;
 	struct ib_uobject	   *uobj;
 	int			    ret;
 
@@ -2909,6 +3067,7 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	ah = uobj->object;
+	pd = ah->pd;
 
 	ret = ib_destroy_ah(ah);
 	if (!ret)
@@ -2919,6 +3078,10 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_AH, 1);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -3171,10 +3334,17 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
+
+	err = rdmacg_try_charge_resource(qp->pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_FLOW, 1);
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
@@ -3208,6 +3378,10 @@ err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	rdmacg_uncharge_resource(qp->pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_FLOW, 1);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3228,6 +3402,7 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_flow	cmd;
 	struct ib_flow			*flow_id;
 	struct ib_uobject		*uobj;
+	struct ib_pd			*pd;
 	int				ret;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3245,11 +3420,16 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	flow_id = uobj->object;
+	pd = flow_id->qp->pd;
 
 	ret = ib_destroy_flow(flow_id);
 	if (!ret)
 		uobj->live = 0;
 
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_FLOW, 1);
+
 	put_uobj_write(uobj);
 
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
@@ -3316,6 +3496,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
+	ret = rdmacg_try_charge_resource(pd->device, file->ucontext->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_SRQ, 1);
+	if (ret)
+		goto err_put_cq;
+
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -3380,6 +3566,9 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_SRQ, 1);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -3540,6 +3729,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_srq_resp resp;
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
+	struct ib_pd                     *pd;
 	struct ib_uevent_object        	 *obj;
 	int                         	  ret = -EINVAL;
 	struct ib_usrq_object		 *us;
@@ -3554,6 +3744,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
 	srq_type = srq->srq_type;
+	pd = srq->pd;
 
 	ret = ib_destroy_srq(srq);
 	if (!ret)
@@ -3564,6 +3755,10 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	rdmacg_uncharge_resource(pd->device, file->ucontext->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_SRQ, 1);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
@@ -3597,6 +3792,8 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_ex_query_device_resp resp;
 	struct ib_uverbs_ex_query_device  cmd;
 	struct ib_device_attr attr;
+	struct pid *tgid;
+	int    limits[RDMA_VERB_RESOURCE_MAX];
 	int err;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3623,7 +3820,18 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
+	rcu_read_lock();
+	tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+
+	err = rdmacg_query_resource_limit(ib_dev, tgid,
+					  RDMACG_RESOURCE_POOL_VERB,
+					  limits, RDMA_VERB_RESOURCE_MAX);
+	if (err)
+		goto end;
+
+	copy_query_dev_fields(file, ib_dev, &resp.base, &attr, limits);
+
 	resp.comp_mask = 0;
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
@@ -3656,6 +3864,8 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.response_length += sizeof(resp.hca_core_clock);
 
 end:
+	put_pid(tgid);
+
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e3ef288..4565386 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -45,6 +45,7 @@
 #include <linux/cdev.h>
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
+#include <linux/cgroup_rdma.h>
 
 #include <asm/uaccess.h>
 
@@ -214,6 +215,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
 		struct ib_ah *ah = uobj->object;
 
+		rdmacg_uncharge_resource(ah->pd->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_AH, 1);
 		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
@@ -223,6 +227,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
 
+		rdmacg_uncharge_resource(mw->pd->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_MW, 1);
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		ib_dealloc_mw(mw);
 		kfree(uobj);
@@ -231,6 +238,10 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
+		rdmacg_uncharge_resource(flow_id->qp->pd->device,
+					 uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_FLOW, 1);
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
@@ -245,6 +256,10 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		if (qp != qp->real_qp) {
 			ib_close_qp(qp);
 		} else {
+			rdmacg_uncharge_resource(qp->pd->device,
+						 uobj->context->tgid,
+						 RDMACG_RESOURCE_POOL_VERB,
+						 RDMA_VERB_RESOURCE_QP, 1);
 			ib_uverbs_detach_umcast(qp, uqp);
 			ib_destroy_qp(qp);
 		}
@@ -257,6 +272,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_uevent_object *uevent =
 			container_of(uobj, struct ib_uevent_object, uobject);
 
+		rdmacg_uncharge_resource(srq->pd->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_SRQ, 1);
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
@@ -269,6 +287,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		struct ib_ucq_object *ucq =
 			container_of(uobj, struct ib_ucq_object, uobject);
 
+		rdmacg_uncharge_resource(cq->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_CQ, 1);
 		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
@@ -278,6 +299,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
+		rdmacg_uncharge_resource(mr->pd->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_MR, 1);
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
@@ -298,11 +322,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
+		rdmacg_uncharge_resource(pd->device, uobj->context->tgid,
+					 RDMACG_RESOURCE_POOL_VERB,
+					 RDMA_VERB_RESOURCE_PD, 1);
 		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
 	}
 
+	rdmacg_uncharge_resource(context->device, context->tgid,
+				 RDMACG_RESOURCE_POOL_VERB,
+				 RDMA_VERB_RESOURCE_UCTX, 1);
 	put_pid(context->tgid);
 
 	return context->device->dealloc_ucontext(context);
-- 
1.8.3.1
