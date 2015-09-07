From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCH 6/7] devcg: Added support to use RDMA device cgroup.
Date: Tue,  8 Sep 2015 02:08:22 +0530
Message-ID: <1441658303-18081-7-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NCmvoJpfsGGKPddeZ6zUY2tVe1pgvOFko5DNUw2Sk7M=;
        b=guQ6pi4oS9Ax/nFZm21bX9KD/PeSUjEcYDDZ73Wbuu6jGGxsPhBNP9cjTnc6aKfghk
         IN3yYkZe389x0Zb5I8B5PpLfY6pI5bmqXvZbDhvSiyaWKFvUYFEzK49mb0hheFdOx0e0
         KgdRv84cfF5JpUPK1Su3FiHupnYhMrJc7OqiFp/cTFBrr18PjXKsp+Z6bnP7XKSxs4PI
         qDVWWR6VrK1sLpMoamVILrM/3LupMNHteJikmp3W0673zEWPXldhgBv+ErVIcZMNjf1X
         kjDBs9H6zOVKeMMG9++jo8MhthnY5YQfcVEGXLWVUXxCUykrYLfJd4Uj73uU8g8setZE
         bVSg==
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, haggaie@mellanox.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

RDMA uverbs modules now queries associated device cgroup rdma controller
before allocating device resources and uncharge them while freeing
rdma device resources.
Since fput() sequence can free the resources from the workqueue
context (instead of task context which allocated the resource),
it passes associated ucontext pointer during uncharge, so that
rdma cgroup controller can correctly free the resource of right
task and right cgroup.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 drivers/infiniband/core/uverbs_cmd.c  | 139 +++++++++++++++++++++++++++++-----
 drivers/infiniband/core/uverbs_main.c |  39 +++++++++-
 2 files changed, 156 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ff..c080374 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/device_rdma_cgroup.h>
 
 #include <asm/uaccess.h>
 
@@ -281,6 +282,19 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 	put_uobj_read(uobj);
 }
 
+static void init_ucontext_lists(struct ib_ucontext *ucontext)
+{
+	INIT_LIST_HEAD(&ucontext->pd_list);
+	INIT_LIST_HEAD(&ucontext->mr_list);
+	INIT_LIST_HEAD(&ucontext->mw_list);
+	INIT_LIST_HEAD(&ucontext->cq_list);
+	INIT_LIST_HEAD(&ucontext->qp_list);
+	INIT_LIST_HEAD(&ucontext->srq_list);
+	INIT_LIST_HEAD(&ucontext->ah_list);
+	INIT_LIST_HEAD(&ucontext->xrcd_list);
+	INIT_LIST_HEAD(&ucontext->rule_list);
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      const char __user *buf,
 			      int in_len, int out_len)
@@ -313,22 +327,18 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_UCTX, 1);
+	if (ret)
+		goto err;
+
 	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
 	if (IS_ERR(ucontext)) {
 		ret = PTR_ERR(ucontext);
-		goto err;
+		goto err_alloc;
 	}
 
 	ucontext->device = ibdev;
-	INIT_LIST_HEAD(&ucontext->pd_list);
-	INIT_LIST_HEAD(&ucontext->mr_list);
-	INIT_LIST_HEAD(&ucontext->mw_list);
-	INIT_LIST_HEAD(&ucontext->cq_list);
-	INIT_LIST_HEAD(&ucontext->qp_list);
-	INIT_LIST_HEAD(&ucontext->srq_list);
-	INIT_LIST_HEAD(&ucontext->ah_list);
-	INIT_LIST_HEAD(&ucontext->xrcd_list);
-	INIT_LIST_HEAD(&ucontext->rule_list);
+	init_ucontext_lists(ucontext);
 	rcu_read_lock();
 	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	rcu_read_unlock();
@@ -395,6 +405,8 @@ err_free:
 	put_pid(ucontext->tgid);
 	ibdev->dealloc_ucontext(ucontext);
 
+err_alloc:
+	devcgroup_rdma_uncharge_resource(NULL, DEVCG_RDMA_RES_TYPE_UCTX, 1);
 err:
 	mutex_unlock(&file->mutex);
 	return ret;
@@ -412,15 +424,23 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->vendor_id		= attr->vendor_id;
 	resp->vendor_part_id	= attr->vendor_part_id;
 	resp->hw_ver		= attr->hw_ver;
-	resp->max_qp		= attr->max_qp;
+	resp->max_qp		= min_t(int, attr->max_qp,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_QP));
 	resp->max_qp_wr		= attr->max_qp_wr;
 	resp->device_cap_flags	= attr->device_cap_flags;
 	resp->max_sge		= attr->max_sge;
 	resp->max_sge_rd	= attr->max_sge_rd;
-	resp->max_cq		= attr->max_cq;
+	resp->max_cq		= min_t(int, attr->max_cq,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_CQ));
 	resp->max_cqe		= attr->max_cqe;
-	resp->max_mr		= attr->max_mr;
-	resp->max_pd		= attr->max_pd;
+	resp->max_mr		= min_t(int, attr->max_mr,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_MR));
+	resp->max_pd		= min_t(int, attr->max_pd,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_PD));
 	resp->max_qp_rd_atom	= attr->max_qp_rd_atom;
 	resp->max_ee_rd_atom	= attr->max_ee_rd_atom;
 	resp->max_res_rd_atom	= attr->max_res_rd_atom;
@@ -429,16 +449,22 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->atomic_cap		= attr->atomic_cap;
 	resp->max_ee			= attr->max_ee;
 	resp->max_rdd			= attr->max_rdd;
-	resp->max_mw			= attr->max_mw;
+	resp->max_mw			= min_t(int, attr->max_mw,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_MW));
 	resp->max_raw_ipv6_qp		= attr->max_raw_ipv6_qp;
 	resp->max_raw_ethy_qp		= attr->max_raw_ethy_qp;
 	resp->max_mcast_grp		= attr->max_mcast_grp;
 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
-	resp->max_ah			= attr->max_ah;
+	resp->max_ah			= min_t(int, attr->max_ah,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_AH));
 	resp->max_fmr			= attr->max_fmr;
 	resp->max_map_per_fmr		= attr->max_map_per_fmr;
-	resp->max_srq			= attr->max_srq;
+	resp->max_srq			= min_t(int, attr->max_srq,
+					devcgroup_rdma_query_resource_limit(
+						DEVCG_RDMA_RES_TYPE_SRQ));
 	resp->max_srq_wr		= attr->max_srq_wr;
 	resp->max_srq_sge		= attr->max_srq_sge;
 	resp->max_pkeys			= attr->max_pkeys;
@@ -550,6 +576,12 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -ENOMEM;
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_PD, 1);
+	if (ret) {
+		kfree(uobj);
+		return -EPERM;
+	}
+
 	init_uobj(uobj, 0, file->ucontext, &pd_lock_class);
 	down_write(&uobj->mutex);
 
@@ -595,6 +627,9 @@ err_idr:
 	ib_dealloc_pd(pd);
 
 err:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_PD, 1);
+
 	put_uobj_write(uobj);
 	return ret;
 }
@@ -623,6 +658,9 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_PD, 1);
+
 	idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -987,6 +1025,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		}
 	}
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_MR, 1);
+	if (ret)
+		goto err_charge;
+
 	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
 				     cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
@@ -1033,8 +1075,10 @@ err_copy:
 
 err_unreg:
 	ib_dereg_mr(mr);
-
 err_put:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_MR, 1);
+err_charge:
 	put_pd_read(pd);
 
 err_free:
@@ -1162,6 +1206,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_MR, 1);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1379,6 +1426,10 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
 		attr.flags = cmd->flags;
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_CQ, 1);
+	if (ret)
+		goto err_charge;
+
 	cq = file->device->ib_dev->create_cq(file->device->ib_dev, &attr,
 					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
@@ -1426,6 +1477,9 @@ err_free:
 	ib_destroy_cq(cq);
 
 err_file:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_CQ, 1);
+err_charge:
 	if (ev_file)
 		ib_uverbs_release_ucq(file, ev_file, obj);
 
@@ -1700,6 +1754,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_CQ, 1);
+
 	idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -1818,6 +1875,10 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 	INIT_LIST_HEAD(&obj->mcast_list);
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_QP, 1);
+	if (ret)
+		goto err_put;
+
 	if (cmd.qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
@@ -1825,7 +1886,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
-		goto err_put;
+		goto err_create;
 	}
 
 	if (cmd.qp_type != IB_QPT_XRC_TGT) {
@@ -1900,6 +1961,9 @@ err_copy:
 err_destroy:
 	ib_destroy_qp(qp);
 
+err_create:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_QP, 1);
 err_put:
 	if (xrcd)
 		put_xrcd_read(xrcd_uobj);
@@ -2256,6 +2320,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_QP, 1);
+
 	if (obj->uxrcd)
 		atomic_dec(&obj->uxrcd->refcnt);
 
@@ -2665,10 +2732,14 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_AH, 1);
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
@@ -2704,6 +2775,9 @@ err_copy:
 err_destroy:
 	ib_destroy_ah(ah);
 
+err_create:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_AH, 1);
 err_put:
 	put_pd_read(pd);
 
@@ -2737,6 +2811,9 @@ ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_AH, 1);
+
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -2986,10 +3063,15 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = -EINVAL;
 		goto err_free;
 	}
+
+	err = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_FLOW, 1);
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
@@ -3023,6 +3105,9 @@ err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
 	ib_destroy_flow(flow_id);
+err_create:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_FLOW, 1);
 err_free:
 	kfree(flow_attr);
 err_put:
@@ -3064,6 +3149,9 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (!ret)
 		uobj->live = 0;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_FLOW, 1);
+
 	put_uobj_write(uobj);
 
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
@@ -3129,6 +3217,10 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
+	ret = devcgroup_rdma_try_charge_resource(DEVCG_RDMA_RES_TYPE_SRQ, 1);
+	if (ret)
+		goto err_put_cq;
+
 	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
@@ -3193,6 +3285,8 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_SRQ, 1);
 	put_pd_read(pd);
 
 err_put_cq:
@@ -3372,6 +3466,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	devcgroup_rdma_uncharge_resource(file->ucontext,
+					 DEVCG_RDMA_RES_TYPE_SRQ, 1);
+
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
 		atomic_dec(&us->uxrcd->refcnt);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f6eef2d..31544d4 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -45,6 +45,7 @@
 #include <linux/cdev.h>
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
+#include <linux/device_rdma_cgroup.h>
 
 #include <asm/uaccess.h>
 
@@ -200,6 +201,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 				      struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj, *tmp;
+	int uobj_cnt = 0, ret;
 
 	if (!context)
 		return 0;
@@ -212,8 +214,12 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
 		ib_destroy_ah(ah);
 		kfree(uobj);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_AH, uobj_cnt);
 
+	uobj_cnt = 0;
 	/* Remove MWs before QPs, in order to support type 2A MWs. */
 	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
 		struct ib_mw *mw = uobj->object;
@@ -221,16 +227,24 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
 		ib_dealloc_mw(mw);
 		kfree(uobj);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_MW, uobj_cnt);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->rule_list, list) {
 		struct ib_flow *flow_id = uobj->object;
 
 		idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 		ib_destroy_flow(flow_id);
 		kfree(uobj);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_FLOW, uobj_cnt);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->qp_list, list) {
 		struct ib_qp *qp = uobj->object;
 		struct ib_uqp_object *uqp =
@@ -245,8 +259,12 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		}
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_QP, uobj_cnt);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
 		struct ib_srq *srq = uobj->object;
 		struct ib_uevent_object *uevent =
@@ -256,8 +274,12 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		ib_destroy_srq(srq);
 		ib_uverbs_release_uevent(file, uevent);
 		kfree(uevent);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_SRQ, uobj_cnt);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
 		struct ib_cq *cq = uobj->object;
 		struct ib_uverbs_event_file *ev_file = cq->cq_context;
@@ -268,15 +290,22 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		ib_destroy_cq(cq);
 		ib_uverbs_release_ucq(file, ev_file, ucq);
 		kfree(ucq);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_CQ, uobj_cnt);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 		ib_dereg_mr(mr);
 		kfree(uobj);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_MR, uobj_cnt);
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
 	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
@@ -290,17 +319,25 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 	}
 	mutex_unlock(&file->device->xrcd_tree_mutex);
 
+	uobj_cnt = 0;
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
 		idr_remove_uobj(&ib_uverbs_pd_idr, uobj);
 		ib_dealloc_pd(pd);
 		kfree(uobj);
+		uobj_cnt++;
 	}
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_PD, uobj_cnt);
 
 	put_pid(context->tgid);
 
-	return context->device->dealloc_ucontext(context);
+	ret = context->device->dealloc_ucontext(context);
+
+	devcgroup_rdma_uncharge_resource(context,
+					 DEVCG_RDMA_RES_TYPE_UCTX, 1);
+	return ret;
 }
 
 static void ib_uverbs_release_file(struct kref *ref)
-- 
1.8.3.1
