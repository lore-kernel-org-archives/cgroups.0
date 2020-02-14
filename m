From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 06/11] drm, cgroup: Add GEM buffer allocation count stats
Date: Fri, 14 Feb 2020 10:56:45 -0500
Message-ID: <20200214155650.21203-7-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDD+cg9HBA357VUjoIcAxcX6UVY3AQ/GVu0LDkHvt50=;
 b=ZXNvmeeyMcR6EXG1zk4wJpm766woTM0kz3TirBQtRmx37K3t9N7cI7AiGX0jTjCFjp+EAfCcnDxZjxkV3BL5Kmf8uhWjksD/K9rjq2WajS6Ri8t+YhbtyW4zkckNw54UCfd+agEOhYfEsXUctJp3E7Hf7VXwrl7P0MRFaGf7Ues=
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

drm.buffer.count.stats
        A read-only flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Total number of GEM buffer allocated.

Change-Id: Iad29bdf44390dbcee07b1e72ea0ff811aa3b9dcd
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
 include/linux/cgroup_drm.h              |  3 +++
 kernel/cgroup/drm.c                     | 22 +++++++++++++++++++---
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 75b97962b127..19fcf54ace83 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2075,6 +2075,12 @@ DRM Interface Files
 
 	Largest (high water mark) GEM buffer allocated in bytes.
 
+  drm.buffer.count.stats
+	A read-only flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Total number of GEM buffer allocated.
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 593ad12602cd..51a0cd37da92 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -14,6 +14,7 @@
 enum drmcg_res_type {
 	DRMCG_TYPE_BO_TOTAL,
 	DRMCG_TYPE_BO_PEAK,
+	DRMCG_TYPE_BO_COUNT,
 	__DRMCG_TYPE_LAST,
 };
 
@@ -27,6 +28,8 @@ struct drmcg_device_resource {
 	s64			bo_stats_total_allocated;
 
 	s64			bo_stats_peak_allocated;
+
+	s64			bo_stats_count_allocated;
 };
 
 /**
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 7a0da70c5a25..bc162aa9971d 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -280,6 +280,9 @@ static void drmcg_print_stats(struct drmcg_device_resource *ddr,
 	case DRMCG_TYPE_BO_PEAK:
 		seq_printf(sf, "%lld\n", ddr->bo_stats_peak_allocated);
 		break;
+	case DRMCG_TYPE_BO_COUNT:
+		seq_printf(sf, "%lld\n", ddr->bo_stats_count_allocated);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -334,6 +337,12 @@ struct cftype files[] = {
 		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_PEAK,
 						DRMCG_FTYPE_STATS),
 	},
+	{
+		.name = "buffer.count.stats",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_COUNT,
+						DRMCG_FTYPE_STATS),
+	},
 	{ }	/* terminate */
 };
 
@@ -385,6 +394,8 @@ void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 
 		if (ddr->bo_stats_peak_allocated < (s64)size)
 			ddr->bo_stats_peak_allocated = (s64)size;
+
+		ddr->bo_stats_count_allocated++;
 	}
 	mutex_unlock(&dev->drmcg_mutex);
 }
@@ -402,15 +413,20 @@ EXPORT_SYMBOL(drmcg_chg_bo_alloc);
 void drmcg_unchg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 		size_t size)
 {
+	struct drmcg_device_resource *ddr;
 	int devIdx = dev->primary->index;
 
 	if (drmcg == NULL)
 		return;
 
 	mutex_lock(&dev->drmcg_mutex);
-	for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg))
-		drmcg->dev_resources[devIdx]->bo_stats_total_allocated
-			-= (s64)size;
+	for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg)) {
+		ddr = drmcg->dev_resources[devIdx];
+
+		ddr->bo_stats_total_allocated -= (s64)size;
+
+		ddr->bo_stats_count_allocated--;
+	}
 	mutex_unlock(&dev->drmcg_mutex);
 }
 EXPORT_SYMBOL(drmcg_unchg_bo_alloc);
-- 
2.25.0
