From: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 6/9] drmcg: Add memory.total file
Date: Tue, 26 Jan 2021 13:46:23 -0800
Message-ID: <20210126214626.16260-7-brian.welty@intel.com>
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

Following control is introduced in order to display total memory that
exists for the DRM device. DRM drivers can advertise this value by
writing to drm_device.drmcg_props. This is needed in order to effectively
use the other memory controls.
Normally for system memory this is available to the user using procfs.

   memory.total
      Read-only value, displays total memory for a device, shown
      only in root cgroup.

Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 ++++
 include/drm/drm_cgroup.h                |  2 ++
 kernel/cgroup/drm.c                     | 10 ++++++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 405912710b3a..ccc25f03a898 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2189,6 +2189,10 @@ MEM controller.  All memory amounts are in bytes.
         DRM device memory.  If memory usage reaches this limit,
         subsequent device memory allocations will fail.
 
+  memory.total
+        Read-only value, displays total memory for a device, shown only in
+        root cgroup.
+
 While some DRM devices may be capable to present multiple memory segments
 to the user, the intent with above controls is to aggregate all user
 allocatable backing store.  Any support for multiple memory segments is
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 8b4c4e798b11..9ba0e372eeee 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -15,11 +15,13 @@ struct drmcg;
  * of storing per device defaults
  */
 struct drmcg_props {
+	u64 memory_total;
 };
 
 enum drmcg_res_type {
 	DRMCG_TYPE_MEM_CURRENT,
 	DRMCG_TYPE_MEM_MAX,
+	DRMCG_TYPE_MEM_TOTAL,
 	__DRMCG_TYPE_LAST,
 };
 
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index bec41f343208..08e75eb67593 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -283,6 +283,10 @@ static int drmcg_seq_show_fn(int id, void *ptr, void *data)
 		else
 			seq_printf(sf, "%ld\n", ddr->memory.max * PAGE_SIZE);
 		break;
+	case DRMCG_TYPE_MEM_TOTAL:
+		seq_printf(sf, "%d:%d %llu\n", DRM_MAJOR, minor->index,
+			   minor->dev->drmcg_props.memory_total);
+		break;
 	default:
 		seq_printf(sf, "%d:%d\n", DRM_MAJOR, minor->index);
 		break;
@@ -374,6 +378,12 @@ struct cftype files[] = {
 		.private = DRMCG_TYPE_MEM_MAX,
 		.flags = CFTYPE_NOT_ON_ROOT
 	},
+	{
+		.name = "memory.total",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_TYPE_MEM_TOTAL,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.20.1
