From: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 7/9] drmcg: Add initial support for tracking gpu time usage
Date: Tue, 26 Jan 2021 13:46:24 -0800
Message-ID: <20210126214626.16260-8-brian.welty@intel.com>
References: <20210126214626.16260-1-brian.welty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20210126214626.16260-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
To: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Single control below is added to DRM cgroup controller in order to track
user execution time for GPU devices.  It is up to device drivers to
charge execution time to the cgroup via drm_cgroup_try_charge().

  sched.runtime
      Read-only value, displays current user execution time for each DRM
      device. The expectation is that this is incremented by DRM device
      driver's scheduler upon user context completion or context switch.
      Units of time are in microseconds for consistency with cpu.stats.

Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 +++++++++
 include/drm/drm_cgroup.h                |  2 ++
 include/linux/cgroup_drm.h              |  2 ++
 kernel/cgroup/drm.c                     | 20 ++++++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ccc25f03a898..f1d0f333a49e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2205,6 +2205,15 @@ thresholds are hit, this would then allow the DRM device driver to invoke
 some equivalent to OOM-killer or forced memory eviction for the device
 backed memory in order to attempt to free additional space.
 
+The below set of control files are for time accounting of DRM devices. Units
+of time are in microseconds.
+
+  sched.runtime
+        Read-only value, displays current user execution time for each DRM
+        device. The expectation is that this is incremented by DRM device
+        driver's scheduler upon user context completion or context switch.
+
+
 Misc
 ----
 
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 9ba0e372eeee..315dab8a93b8 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -22,6 +22,7 @@ enum drmcg_res_type {
 	DRMCG_TYPE_MEM_CURRENT,
 	DRMCG_TYPE_MEM_MAX,
 	DRMCG_TYPE_MEM_TOTAL,
+	DRMCG_TYPE_SCHED_RUNTIME,
 	__DRMCG_TYPE_LAST,
 };
 
@@ -79,5 +80,6 @@ void drm_cgroup_uncharge(struct drmcg *drmcg,struct drm_device *dev,
 			 enum drmcg_res_type type, u64 usage)
 {
 }
+
 #endif /* CONFIG_CGROUP_DRM */
 #endif /* __DRM_CGROUP_H__ */
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 3570636473cf..0fafa663321e 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -19,6 +19,8 @@
  */
 struct drmcg_device_resource {
 	struct page_counter memory;
+	seqlock_t sched_lock;
+	u64 exec_runtime;
 };
 
 /**
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 08e75eb67593..64e9d0dbe8c8 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -81,6 +81,7 @@ static inline int init_drmcg_single(struct drmcg *drmcg, struct drm_device *dev)
 	/* set defaults here */
 	page_counter_init(&ddr->memory,
 			  parent_ddr ? &parent_ddr->memory : NULL);
+	seqlock_init(&ddr->sched_lock);
 	drmcg->dev_resources[minor] = ddr;
 
 	return 0;
@@ -287,6 +288,10 @@ static int drmcg_seq_show_fn(int id, void *ptr, void *data)
 		seq_printf(sf, "%d:%d %llu\n", DRM_MAJOR, minor->index,
 			   minor->dev->drmcg_props.memory_total);
 		break;
+	case DRMCG_TYPE_SCHED_RUNTIME:
+		seq_printf(sf, "%d:%d %llu\n", DRM_MAJOR, minor->index,
+			   ktime_to_us(ddr->exec_runtime));
+		break;
 	default:
 		seq_printf(sf, "%d:%d\n", DRM_MAJOR, minor->index);
 		break;
@@ -384,6 +389,12 @@ struct cftype files[] = {
 		.private = DRMCG_TYPE_MEM_TOTAL,
 		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
+	{
+		.name = "sched.runtime",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_TYPE_SCHED_RUNTIME,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
@@ -440,6 +451,10 @@ EXPORT_SYMBOL(drmcg_device_early_init);
  * choose to enact some form of memory reclaim, but the exact behavior is left
  * to the DRM device driver to define.
  *
+ * For @res type of DRMCG_TYPE_SCHED_RUNTIME:
+ * For GPU time accounting, add @usage amount of GPU time to @drmcg for
+ * the given device.
+ *
  * Returns 0 on success.  Otherwise, an error code is returned.
  */
 int drm_cgroup_try_charge(struct drmcg *drmcg, struct drm_device *dev,
@@ -466,6 +481,11 @@ int drm_cgroup_try_charge(struct drmcg *drmcg, struct drm_device *dev,
 			err = 0;
 		}
 		break;
+	case DRMCG_TYPE_SCHED_RUNTIME:
+		write_seqlock(&res->sched_lock);
+		res->exec_runtime = ktime_add(res->exec_runtime, usage);
+		write_sequnlock(&res->sched_lock);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
2.20.1
