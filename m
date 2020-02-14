From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 11/11] drm/amdgpu: Integrate with DRM cgroup
Date: Fri, 14 Feb 2020 10:56:50 -0500
Message-ID: <20200214155650.21203-12-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rRr9SDapif3gUzcHJzuaeIB3YgcZXIrBlrTW3u0h8A=;
 b=XVkGieX5pf421kKdmQTXpyFO7Mrk446+MHJT+dr4T9nACLQ30IQjZcgz7+hjXUj1V16iRVtqfMvysYVAAOx5gu4lZT50NEw1B5jdfPrd+rzDG6TBx7jsIjEAP0p0/EFrF+5iKrWR9VaG+WWAzFRD47rvbTlPUTLOGsr/6LTBoXI=
In-Reply-To: <20200214155650.21203-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

The number of logical gpu (lgpu) is defined to be the number of compute
unit (CU) for a device.  The lgpu allocation limit only applies to
compute workload for the moment (enforced via kfd queue creation.)  Any
cu_mask update is validated against the availability of the compute unit
as defined by the drmcg the kfd process belongs to.

Change-Id: I2930e76ef9ac6d36d0feb81f604c89a4208e6614
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |  29 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |   3 +
 .../amd/amdkfd/kfd_process_queue_manager.c    | 153 ++++++++++++++++++
 5 files changed, 195 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 47b0f2957d1f..a45c7b5d23b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -198,6 +198,10 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
 		valid;							\
 	})
 
+int amdgpu_amdkfd_update_cu_mask_for_process(struct task_struct *task,
+		struct amdgpu_device *adev, unsigned long *lgpu_bitmap,
+		unsigned int nbits);
+
 /* GPUVM API */
 int amdgpu_amdkfd_gpuvm_create_process_vm(struct kgd_dev *kgd, unsigned int pasid,
 					void **vm, void **process_info,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 3ebef1d62346..dc31b9af2c72 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1402,9 +1402,31 @@ amdgpu_get_crtc_scanout_position(struct drm_device *dev, unsigned int pipe,
 static void amdgpu_drmcg_custom_init(struct drm_device *dev,
 	struct drmcg_props *props)
 {
+	struct amdgpu_device *adev = dev->dev_private;
+
+	props->lgpu_capacity = adev->gfx.cu_info.number;
+	bitmap_zero(props->lgpu_slots, MAX_DRMCG_LGPU_CAPACITY);
+	bitmap_fill(props->lgpu_slots, props->lgpu_capacity);
+
 	props->limit_enforced = true;
 }
 
+static void amdgpu_drmcg_limit_updated(struct drm_device *dev,
+		struct task_struct *task, struct drmcg_device_resource *ddr,
+		enum drmcg_res_type res_type)
+{
+	struct amdgpu_device *adev = dev->dev_private;
+
+	switch (res_type) {
+	case DRMCG_TYPE_LGPU:
+		amdgpu_amdkfd_update_cu_mask_for_process(task, adev,
+                        ddr->lgpu_eff, dev->drmcg_props.lgpu_capacity);
+		break;
+	default:
+		break;
+	}
+}
+
 #else
 
 static void amdgpu_drmcg_custom_init(struct drm_device *dev,
@@ -1412,6 +1434,12 @@ static void amdgpu_drmcg_custom_init(struct drm_device *dev,
 {
 }
 
+static void amdgpu_drmcg_limit_updated(struct drm_device *dev,
+		struct task_struct *task, struct drmcg_device_resource *ddr,
+		enum drmcg_res_type res_type)
+{
+}
+
 #endif /* CONFIG_CGROUP_DRM */
 
 static struct drm_driver kms_driver = {
@@ -1448,6 +1476,7 @@ static struct drm_driver kms_driver = {
 	.gem_prime_mmap = amdgpu_gem_prime_mmap,
 
 	.drmcg_custom_init = amdgpu_drmcg_custom_init,
+	.drmcg_limit_updated = amdgpu_drmcg_limit_updated,
 
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 275f79ab0900..f39555c0f1d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -449,6 +449,12 @@ static int kfd_ioctl_set_cu_mask(struct file *filp, struct kfd_process *p,
 		return -EFAULT;
 	}
 
+	if (!pqm_drmcg_lgpu_validate(p, args->queue_id, properties.cu_mask, cu_mask_size)) {
+		pr_debug("CU mask not permitted by DRM Cgroup");
+		kfree(properties.cu_mask);
+		return -EACCES;
+	}
+
 	mutex_lock(&p->mutex);
 
 	retval = pqm_set_cu_mask(&p->pqm, args->queue_id, &properties);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index c0b0defc8f7a..9053b1b7fb10 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -921,6 +921,9 @@ int pqm_get_wave_state(struct process_queue_manager *pqm,
 		       u32 *ctl_stack_used_size,
 		       u32 *save_area_used_size);
 
+bool pqm_drmcg_lgpu_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size);
+
 int amdkfd_fence_wait_timeout(unsigned int *fence_addr,
 			      unsigned int fence_value,
 			      unsigned int timeout_ms);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 8fa856e6a03f..ff71b208d320 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -23,9 +23,11 @@
 
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/cgroup_drm.h>
 #include "kfd_device_queue_manager.h"
 #include "kfd_priv.h"
 #include "kfd_kernel_queue.h"
+#include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
 
 static inline struct process_queue_node *get_queue_by_qid(
@@ -167,6 +169,7 @@ static int init_user_queue(struct process_queue_manager *pqm,
 				struct queue_properties *q_properties,
 				struct file *f, unsigned int qid)
 {
+	struct drmcg *drmcg;
 	int retval;
 
 	/* Doorbell initialized in user space*/
@@ -180,6 +183,37 @@ static int init_user_queue(struct process_queue_manager *pqm,
 	if (retval != 0)
 		return retval;
 
+#ifdef CONFIG_CGROUP_DRM
+	drmcg = drmcg_get(pqm->process->lead_thread);
+	if (drmcg) {
+		struct amdgpu_device *adev;
+		struct drmcg_device_resource *ddr;
+		int mask_size;
+		u32 *mask;
+
+		adev = (struct amdgpu_device *) dev->kgd;
+
+		mask_size = adev->ddev->drmcg_props.lgpu_capacity;
+		mask = kzalloc(sizeof(u32) * round_up(mask_size, 32),
+				GFP_KERNEL);
+
+		if (!mask) {
+			drmcg_put(drmcg);
+			uninit_queue(*q);
+			return -ENOMEM;
+		}
+
+		ddr = drmcg->dev_resources[adev->ddev->primary->index];
+
+		bitmap_to_arr32(mask, ddr->lgpu_eff, mask_size);
+
+		(*q)->properties.cu_mask_count = mask_size;
+		(*q)->properties.cu_mask = mask;
+
+		drmcg_put(drmcg);
+	}
+#endif /* CONFIG_CGROUP_DRM */
+
 	(*q)->device = dev;
 	(*q)->process = pqm->process;
 
@@ -508,6 +542,125 @@ int pqm_get_wave_state(struct process_queue_manager *pqm,
 						       save_area_used_size);
 }
 
+#ifdef CONFIG_CGROUP_DRM
+
+bool pqm_drmcg_lgpu_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size)
+{
+	DECLARE_BITMAP(curr_mask, MAX_DRMCG_LGPU_CAPACITY);
+	struct drmcg_device_resource *ddr;
+	struct process_queue_node *pqn;
+	struct amdgpu_device *adev;
+	struct drmcg *drmcg;
+	bool result;
+
+	if (cu_mask_size > MAX_DRMCG_LGPU_CAPACITY)
+		return false;
+
+	bitmap_from_arr32(curr_mask, cu_mask, cu_mask_size);
+
+	pqn = get_queue_by_qid(&p->pqm, qid);
+	if (!pqn)
+		return false;
+
+	adev = (struct amdgpu_device *)pqn->q->device->kgd;
+
+	drmcg = drmcg_get(p->lead_thread);
+	ddr = drmcg->dev_resources[adev->ddev->primary->index];
+
+	if (bitmap_subset(curr_mask, ddr->lgpu_eff,
+				MAX_DRMCG_LGPU_CAPACITY))
+		result = true;
+	else
+		result = false;
+
+	drmcg_put(drmcg);
+
+	return result;
+}
+
+#else
+
+bool pqm_drmcg_lgpu_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size)
+{
+	return true;
+}
+
+#endif /* CONFIG_CGROUP_DRM */
+
+int amdgpu_amdkfd_update_cu_mask_for_process(struct task_struct *task,
+		struct amdgpu_device *adev, unsigned long *lgpu_bm,
+		unsigned int lgpu_bm_size)
+{
+	struct kfd_dev *kdev = adev->kfd.dev;
+	struct process_queue_node *pqn;
+	struct kfd_process *kfdproc;
+	size_t size_in_bytes;
+	u32 *cu_mask;
+	int rc = 0;
+
+	if ((lgpu_bm_size % 32) != 0) {
+		pr_warn("lgpu_bm_size %d must be a multiple of 32",
+				lgpu_bm_size);
+		return -EINVAL;
+	}
+
+	kfdproc = kfd_get_process(task);
+
+	if (IS_ERR(kfdproc))
+		return -ESRCH;
+
+	size_in_bytes = sizeof(u32) * round_up(lgpu_bm_size, 32);
+
+	mutex_lock(&kfdproc->mutex);
+	list_for_each_entry(pqn, &kfdproc->pqm.queues, process_queue_list) {
+		if (pqn->q && pqn->q->device == kdev) {
+			/* update cu_mask accordingly */
+			cu_mask = kzalloc(size_in_bytes, GFP_KERNEL);
+			if (!cu_mask) {
+				rc = -ENOMEM;
+				break;
+			}
+
+			if (pqn->q->properties.cu_mask) {
+				DECLARE_BITMAP(curr_mask,
+						MAX_DRMCG_LGPU_CAPACITY);
+
+				if (pqn->q->properties.cu_mask_count >
+						lgpu_bm_size) {
+					rc = -EINVAL;
+					kfree(cu_mask);
+					break;
+				}
+
+				bitmap_from_arr32(curr_mask,
+						pqn->q->properties.cu_mask,
+						pqn->q->properties.cu_mask_count);
+
+				bitmap_and(curr_mask, curr_mask, lgpu_bm,
+						lgpu_bm_size);
+
+				bitmap_to_arr32(cu_mask, curr_mask,
+						lgpu_bm_size);
+
+				kfree(curr_mask);
+			} else
+				bitmap_to_arr32(cu_mask, lgpu_bm,
+						lgpu_bm_size);
+
+			pqn->q->properties.cu_mask = cu_mask;
+			pqn->q->properties.cu_mask_count = lgpu_bm_size;
+
+			rc = pqn->q->device->dqm->ops.update_queue(
+					pqn->q->device->dqm, pqn->q);
+		}
+	}
+	mutex_unlock(&kfdproc->mutex);
+
+	return rc;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 int pqm_debugfs_mqds(struct seq_file *m, void *data)
-- 
2.25.0
