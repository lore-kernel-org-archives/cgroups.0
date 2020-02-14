From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 04/11] drm, cgroup: Add total GEM buffer allocation stats
Date: Fri, 14 Feb 2020 10:56:43 -0500
Message-ID: <20200214155650.21203-5-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9GfjKmC6WE9KgF6VLgLnREHgTv0N9zlsmLGWtvhZZk=;
 b=JllNquCxGdAyRzGcbJyQgkkiuFrHa/7lIhyBCSeyUqYXGGaCUtGxLZYJekFw8HceqmrcQuQLICMA2hAnkEsfNmSEbYLPnIpxXPc5ZqUz4YGPyfaMpvGlkY2u+knAWb1zfihsbAixou99R8gJMA6WvmefqsC9OmgUW1PIUOMRUEk=
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

The drm resource being measured here is the GEM buffer objects.  User
applications allocate and free these buffers.  In addition, a process
can allocate a buffer and share it with another process.  The consumer
of a shared buffer can also outlive the allocator of the buffer.

For the purpose of cgroup accounting and limiting, ownership of the
buffer is deemed to be the cgroup for which the allocating process
belongs to.  There is one cgroup stats per drm device.  Each allocation
is charged to the owning cgroup as well as all its ancestors.

Similar to the memory cgroup, migrating a process to a different cgroup
does not move the GEM buffer usages that the process started while in
previous cgroup, to the new cgroup.

The following is an example to illustrate some of the operations.  Given
the following cgroup hierarchy (The letters are cgroup names with R
being the root cgroup.  The numbers in brackets are processes.  The
processes are placed with cgroup's 'No Internal Process Constraint' in
mind, so no process is placed in cgroup B.)

R (4, 5) ------ A (6)
 \
  B ---- C (7,8)
   \
    D (9)

Here is a list of operation and the associated effect on the size
track by the cgroups (for simplicity, each buffer is 1 unit in size.)

==  ==  ==  ==  ==  ===================================================
R   A   B   C   D   Ops
==  ==  ==  ==  ==  ===================================================
1   0   0   0   0   4 allocated a buffer
1   0   0   0   0   4 shared a buffer with 5
1   0   0   0   0   4 shared a buffer with 9
2   0   1   0   1   9 allocated a buffer
3   0   2   1   1   7 allocated a buffer
3   0   2   1   1   7 shared a buffer with 8
3   0   2   1   1   7 sharing with 9
3   0   2   1   1   7 release a buffer
3   0   2   1   1   7 migrate to cgroup D
3   0   2   1   1   9 release a buffer from 7
2   0   1   0   1   8 release a buffer from 7 (last ref to shared buf)
==  ==  ==  ==  ==  ===================================================

drm.buffer.stats
        A read-only flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Total GEM buffer allocation in bytes.

Change-Id: Ibc1f646ca7dbc588e2d11802b156b524696a23e7
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  50 +++++++++-
 drivers/gpu/drm/drm_gem.c               |   9 ++
 include/drm/drm_cgroup.h                |  16 +++
 include/drm/drm_gem.h                   |  10 ++
 include/linux/cgroup_drm.h              |   6 ++
 kernel/cgroup/drm.c                     | 126 ++++++++++++++++++++++++
 6 files changed, 216 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 384db8df0f30..2d8162c109f3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -63,6 +63,7 @@ v1 is available under Documentation/admin-guide/cgroup-v1/.
        5-7-1. RDMA Interface Files
      5-8. DRM
        5-8-1. DRM Interface Files
+       5-8-2. GEM Buffer Ownership
      5-9. Misc
        5-9-1. perf_event
      5-N. Non-normative information
@@ -2062,7 +2063,54 @@ of DRM (Direct Rendering Manager) and GPU-related resources.
 DRM Interface Files
 ~~~~~~~~~~~~~~~~~~~~
 
-TODO
+  drm.buffer.stats
+	A read-only flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Total GEM buffer allocation in bytes.
+
+GEM Buffer Ownership
+~~~~~~~~~~~~~~~~~~~~
+
+For the purpose of cgroup accounting and limiting, ownership of the
+buffer is deemed to be the cgroup for which the allocating process
+belongs to.  There is one cgroup stats per drm device.  Each allocation
+is charged to the owning cgroup as well as all its ancestors.
+
+Similar to the memory cgroup, migrating a process to a different cgroup
+does not move the GEM buffer usages that the process started while in
+previous cgroup, to the new cgroup.
+
+The following is an example to illustrate some of the operations.  Given
+the following cgroup hierarchy (The letters are cgroup names with R
+being the root cgroup.  The numbers in brackets are processes.  The
+processes are placed with cgroup's 'No Internal Process Constraint' in
+mind, so no process is placed in cgroup B.)
+
+R (4, 5) ------ A (6)
+ \
+  B ---- C (7,8)
+   \
+    D (9)
+
+Here is a list of operation and the associated effect on the size
+track by the cgroups (for simplicity, each buffer is 1 unit in size.)
+
+==  ==  ==  ==  ==  ===================================================
+R   A   B   C   D   Ops
+==  ==  ==  ==  ==  ===================================================
+1   0   0   0   0   4 allocated a buffer
+1   0   0   0   0   4 shared a buffer with 5
+1   0   0   0   0   4 shared a buffer with 9
+2   0   1   0   1   9 allocated a buffer
+3   0   2   1   1   7 allocated a buffer
+3   0   2   1   1   7 shared a buffer with 8
+3   0   2   1   1   7 sharing with 9
+3   0   2   1   1   7 release a buffer
+3   0   2   1   1   7 migrate to cgroup D
+3   0   2   1   1   9 release a buffer from 7
+2   0   1   0   1   8 release a buffer from 7 (last ref to shared buf)
+==  ==  ==  ==  ==  ===================================================
 
 
 Misc
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 2f2b889096b0..d158470edd98 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -38,6 +38,7 @@
 #include <linux/dma-buf.h>
 #include <linux/mem_encrypt.h>
 #include <linux/pagevec.h>
+#include <linux/cgroup_drm.h>
 
 #include <drm/drm.h>
 #include <drm/drm_device.h>
@@ -46,6 +47,7 @@
 #include <drm/drm_gem.h>
 #include <drm/drm_print.h>
 #include <drm/drm_vma_manager.h>
+#include <drm/drm_cgroup.h>
 
 #include "drm_internal.h"
 
@@ -164,6 +166,9 @@ void drm_gem_private_object_init(struct drm_device *dev,
 		obj->resv = &obj->_resv;
 
 	drm_vma_node_reset(&obj->vma_node);
+
+	obj->drmcg = drmcg_get(current);
+	drmcg_chg_bo_alloc(obj->drmcg, dev, size);
 }
 EXPORT_SYMBOL(drm_gem_private_object_init);
 
@@ -957,6 +962,10 @@ drm_gem_object_release(struct drm_gem_object *obj)
 		fput(obj->filp);
 
 	dma_resv_fini(&obj->_resv);
+
+	drmcg_unchg_bo_alloc(obj->drmcg, obj->dev, obj->size);
+	drmcg_put(obj->drmcg);
+
 	drm_gem_free_mmap_offset(obj);
 }
 EXPORT_SYMBOL(drm_gem_object_release);
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index fda426fba035..1eb3012e16a1 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -26,6 +26,12 @@ void drmcg_unregister_dev(struct drm_device *dev);
 
 void drmcg_device_early_init(struct drm_device *device);
 
+void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+		size_t size);
+
+void drmcg_unchg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+		size_t size);
+
 #else
 
 struct drmcg_props {
@@ -53,5 +59,15 @@ static inline void drmcg_device_early_init(struct drm_device *device)
 {
 }
 
+static inline void drmcg_chg_bo_alloc(struct drmcg *drmcg,
+		struct drm_device *dev,	size_t size)
+{
+}
+
+static inline void drmcg_unchg_bo_alloc(struct drmcg *drmcg,
+		struct drm_device *dev,	size_t size)
+{
+}
+
 #endif /* CONFIG_CGROUP_DRM */
 #endif /* __DRM_CGROUP_H__ */
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 97a48165642c..6ac7018923f7 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -312,6 +312,16 @@ struct drm_gem_object {
 	 *
 	 */
 	const struct drm_gem_object_funcs *funcs;
+
+	/**
+	 * @drmcg:
+	 *
+	 * DRM cgroup this GEM object belongs to.
+	 *
+	 * This is used to track and limit the amount of GEM objects a user
+	 * can allocate.
+	 */
+	struct drmcg *drmcg;
 };
 
 /**
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 2014097eb75c..174ab50701ef 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -11,6 +11,11 @@
 /* limit defined per the way drm_minor_alloc operates */
 #define MAX_DRM_DEV (64 * DRM_MINOR_RENDER)
 
+enum drmcg_res_type {
+	DRMCG_TYPE_BO_TOTAL,
+	__DRMCG_TYPE_LAST,
+};
+
 #ifdef CONFIG_CGROUP_DRM
 
 /**
@@ -18,6 +23,7 @@
  */
 struct drmcg_device_resource {
 	/* for per device stats */
+	s64			bo_stats_total_allocated;
 };
 
 /**
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 30fd9aeffbe7..425566753a5c 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -13,6 +13,7 @@
 #include <drm/drm_file.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_device.h>
+#include <drm/drm_ioctl.h>
 #include <drm/drm_cgroup.h>
 
 static struct drmcg *root_drmcg __read_mostly;
@@ -26,6 +27,18 @@ static struct drm_minor (*(*acquire_drm_minor)(unsigned int minor_id));
 
 static void (*put_drm_dev)(struct drm_device *dev);
 
+#define DRMCG_CTF_PRIV_SIZE 3
+#define DRMCG_CTF_PRIV_MASK GENMASK((DRMCG_CTF_PRIV_SIZE - 1), 0)
+#define DRMCG_CTF_PRIV(res_type, f_type)  ((res_type) <<\
+		DRMCG_CTF_PRIV_SIZE | (f_type))
+#define DRMCG_CTF_PRIV2RESTYPE(priv) ((priv) >> DRMCG_CTF_PRIV_SIZE)
+#define DRMCG_CTF_PRIV2FTYPE(priv) ((priv) & DRMCG_CTF_PRIV_MASK)
+
+
+enum drmcg_file_type {
+	DRMCG_FTYPE_STATS,
+};
+
 /**
  * drmcg_bind - Bind DRM subsystem to cgroup subsystem
  * @acq_dm: function pointer to the drm_minor_acquire function
@@ -252,7 +265,66 @@ drmcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	return &drmcg->css;
 }
 
+static void drmcg_print_stats(struct drmcg_device_resource *ddr,
+		struct seq_file *sf, enum drmcg_res_type type)
+{
+	if (ddr == NULL) {
+		seq_puts(sf, "\n");
+		return;
+	}
+
+	switch (type) {
+	case DRMCG_TYPE_BO_TOTAL:
+		seq_printf(sf, "%lld\n", ddr->bo_stats_total_allocated);
+		break;
+	default:
+		seq_puts(sf, "\n");
+		break;
+	}
+}
+
+static int drmcg_seq_show_fn(int id, void *ptr, void *data)
+{
+	struct drm_minor *minor = ptr;
+	struct seq_file *sf = data;
+	struct drmcg *drmcg = css_to_drmcg(seq_css(sf));
+	enum drmcg_file_type f_type =
+		DRMCG_CTF_PRIV2FTYPE(seq_cft(sf)->private);
+	enum drmcg_res_type type =
+		DRMCG_CTF_PRIV2RESTYPE(seq_cft(sf)->private);
+	struct drmcg_device_resource *ddr;
+
+	if (minor->type != DRM_MINOR_PRIMARY)
+		return 0;
+
+	ddr = drmcg->dev_resources[minor->index];
+
+	seq_printf(sf, "%d:%d ", DRM_MAJOR, minor->index);
+
+	switch (f_type) {
+	case DRMCG_FTYPE_STATS:
+		drmcg_print_stats(ddr, sf, type);
+		break;
+	default:
+		seq_puts(sf, "\n");
+		break;
+	}
+
+	return 0;
+}
+
+int drmcg_seq_show(struct seq_file *sf, void *v)
+{
+	return drm_minor_for_each(&drmcg_seq_show_fn, sf);
+}
+
 struct cftype files[] = {
+	{
+		.name = "buffer.total.stats",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_TOTAL,
+						DRMCG_FTYPE_STATS),
+	},
 	{ }	/* terminate */
 };
 
@@ -276,3 +348,57 @@ void drmcg_device_early_init(struct drm_device *dev)
 	drmcg_update_cg_tree(dev);
 }
 EXPORT_SYMBOL(drmcg_device_early_init);
+
+/**
+ * drmcg_chg_bo_alloc - charge GEM buffer usage for a device and cgroup
+ * @drmcg: the DRM cgroup to be charged to
+ * @dev: the device the usage should be charged to
+ * @size: size of the GEM buffer to be accounted for
+ *
+ * This function should be called when a new GEM buffer is allocated to account
+ * for the utilization.  This should not be called when the buffer is shared (
+ * the GEM buffer's reference count being incremented.)
+ */
+void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+		size_t size)
+{
+	struct drmcg_device_resource *ddr;
+	int devIdx = dev->primary->index;
+
+	if (drmcg == NULL)
+		return;
+
+	mutex_lock(&dev->drmcg_mutex);
+	for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg)) {
+		ddr = drmcg->dev_resources[devIdx];
+
+		ddr->bo_stats_total_allocated += (s64)size;
+	}
+	mutex_unlock(&dev->drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_chg_bo_alloc);
+
+/**
+ * drmcg_unchg_bo_alloc -
+ * @drmcg: the DRM cgroup to uncharge from
+ * @dev: the device the usage should be removed from
+ * @size: size of the GEM buffer to be accounted for
+ *
+ * This function should be called when the GEM buffer is about to be freed (
+ * not simply when the GEM buffer's reference count is being decremented.)
+ */
+void drmcg_unchg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+		size_t size)
+{
+	int devIdx = dev->primary->index;
+
+	if (drmcg == NULL)
+		return;
+
+	mutex_lock(&dev->drmcg_mutex);
+	for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg))
+		drmcg->dev_resources[devIdx]->bo_stats_total_allocated
+			-= (s64)size;
+	mutex_unlock(&dev->drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_unchg_bo_alloc);
-- 
2.25.0
