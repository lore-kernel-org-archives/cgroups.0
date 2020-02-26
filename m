From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 11/11] drm/amdgpu: Integrate with DRM cgroup
Date: Wed, 26 Feb 2020 14:01:52 -0500
Message-ID: <20200226190152.16131-12-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9U7NEPPNIxK9vLDx9ztf8Nw8JMRkapZr2Z7bfi02Ns=;
 b=QWpKUaq0iv9VYjHDJgQjF5MMYNX88XViZp6gsTR7bikY+lpGf1oQHb4KvO5/6T3WkWcF++WjX+n7tPDGZ0gcgncQjYCh52vYlpCClIlmlNODmt+UuL2WvvRult93zN2nKtLT3HNEQyFS+GPPaVWECfih6SDoH7vjd2E9yDTRDaQ=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

The number of compute unit (CU) for a device is used for the gpu cgroup
compute capacity.  The gpu cgroup compute allocation limit only applies
to compute workload for the moment (enforced via kfd queue creation.)
Any cu_mask update is validated against the availability of the compute
unit as defined by the drmcg the kfd process belongs to.

Change-Id: I2930e76ef9ac6d36d0feb81f604c89a4208e6614
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |  29 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      |   7 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |   3 +
 .../amd/amdkfd/kfd_process_queue_manager.c    | 153 ++++++++++++++++++
 5 files changed, 196 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 0ee8aae6c519..1efbc0d3c03e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -199,6 +199,10 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
 		valid;							\
 	})
 
+int amdgpu_amdkfd_update_cu_mask_for_process(struct task_struct *task,
+		struct amdgpu_device *adev, unsigned long *compute_bm,
+		unsigned int compute_bm_size);
+
 /* GPUVM API */
 int amdgpu_amdkfd_gpuvm_create_process_vm(struct kgd_dev *kgd, unsigned int pasid,
 					void **vm, void **process_info,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 171397708855..595ad852080b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1418,9 +1418,31 @@ amdgpu_get_crtc_scanout_position(struct drm_device *dev, unsigned int pipe,
 static void amdgpu_drmcg_custom_init(struct drm_device *dev,
 	struct drmcg_props *props)
 {
+	struct amdgpu_device *adev = dev->dev_private;
+
+	props->compute_capacity = adev->gfx.cu_info.number;
+	bitmap_zero(props->compute_slots, MAX_DRMCG_COMPUTE_CAPACITY);
+	bitmap_fill(props->compute_slots, props->compute_capacity);
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
+	case DRMCG_TYPE_COMPUTE:
+		amdgpu_amdkfd_update_cu_mask_for_process(task, adev,
+                        ddr->compute_eff, dev->drmcg_props.compute_capacity);
+		break;
+	default:
+		break;
+	}
+}
+
 #else
 
 static void amdgpu_drmcg_custom_init(struct drm_device *dev,
@@ -1428,6 +1450,12 @@ static void amdgpu_drmcg_custom_init(struct drm_device *dev,
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
@@ -1462,6 +1490,7 @@ static struct drm_driver kms_driver = {
 	.gem_prime_mmap = amdgpu_gem_prime_mmap,
 
 	.drmcg_custom_init = amdgpu_drmcg_custom_init,
+	.drmcg_limit_updated = amdgpu_drmcg_limit_updated,
 
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 675735b8243a..a35596f2dc4e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -451,6 +451,13 @@ static int kfd_ioctl_set_cu_mask(struct file *filp, struct kfd_process *p,
 		return -EFAULT;
 	}
 
+	if (!pqm_drmcg_compute_validate(p, args->queue_id,
+                    properties.cu_mask, cu_mask_size)) {
+		pr_debug("CU mask not permitted by DRM Cgroup");
+		kfree(properties.cu_mask);
+		return -EACCES;
+	}
+
 	mutex_lock(&p->mutex);
 
 	retval = pqm_set_cu_mask(&p->pqm, args->queue_id, &properties);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 063096ec832d..0fb619586e24 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -929,6 +929,9 @@ int pqm_get_wave_state(struct process_queue_manager *pqm,
 		       u32 *ctl_stack_used_size,
 		       u32 *save_area_used_size);
 
+bool pqm_drmcg_compute_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size);
+
 int amdkfd_fence_wait_timeout(unsigned int *fence_addr,
 			      unsigned int fence_value,
 			      unsigned int timeout_ms);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index cb1ca11b99c3..bd09403e07b5 100644
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
+		mask_size = adev->ddev->drmcg_props.compute_capacity;
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
+		bitmap_to_arr32(mask, ddr->compute_eff, mask_size);
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
 
@@ -510,6 +544,125 @@ int pqm_get_wave_state(struct process_queue_manager *pqm,
 						       save_area_used_size);
 }
 
+#ifdef CONFIG_CGROUP_DRM
+
+bool pqm_drmcg_compute_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size)
+{
+	DECLARE_BITMAP(curr_mask, MAX_DRMCG_COMPUTE_CAPACITY);
+	struct drmcg_device_resource *ddr;
+	struct process_queue_node *pqn;
+	struct amdgpu_device *adev;
+	struct drmcg *drmcg;
+	bool result;
+
+	if (cu_mask_size > MAX_DRMCG_COMPUTE_CAPACITY)
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
+	if (bitmap_subset(curr_mask, ddr->compute_eff,
+				MAX_DRMCG_COMPUTE_CAPACITY))
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
+bool pqm_drmcg_compute_validate(struct kfd_process *p, int qid, u32 *cu_mask,
+		unsigned int cu_mask_size)
+{
+	return true;
+}
+
+#endif /* CONFIG_CGROUP_DRM */
+
+int amdgpu_amdkfd_update_cu_mask_for_process(struct task_struct *task,
+		struct amdgpu_device *adev, unsigned long *compute_bm,
+		unsigned int compute_bm_size)
+{
+	struct kfd_dev *kdev = adev->kfd.dev;
+	struct process_queue_node *pqn;
+	struct kfd_process *kfdproc;
+	size_t size_in_bytes;
+	u32 *cu_mask;
+	int rc = 0;
+
+	if ((compute_bm_size % 32) != 0) {
+		pr_warn("compute_bm_size %d must be a multiple of 32",
+				compute_bm_size);
+		return -EINVAL;
+	}
+
+	kfdproc = kfd_get_process(task);
+
+	if (IS_ERR(kfdproc))
+		return -ESRCH;
+
+	size_in_bytes = sizeof(u32) * round_up(compute_bm_size, 32);
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
+						MAX_DRMCG_COMPUTE_CAPACITY);
+
+				if (pqn->q->properties.cu_mask_count >
+						compute_bm_size) {
+					rc = -EINVAL;
+					kfree(cu_mask);
+					break;
+				}
+
+				bitmap_from_arr32(curr_mask,
+						pqn->q->properties.cu_mask,
+						pqn->q->properties.cu_mask_count);
+
+				bitmap_and(curr_mask, curr_mask, compute_bm,
+						compute_bm_size);
+
+				bitmap_to_arr32(cu_mask, curr_mask,
+						compute_bm_size);
+
+				kfree(curr_mask);
+			} else
+				bitmap_to_arr32(cu_mask, compute_bm,
+						compute_bm_size);
+
+			pqn->q->properties.cu_mask = cu_mask;
+			pqn->q->properties.cu_mask_count = compute_bm_size;
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

