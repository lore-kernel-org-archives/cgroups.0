From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 05/11] drm, cgroup: Add peak GEM buffer allocation stats
Date: Wed, 26 Feb 2020 14:01:46 -0500
Message-ID: <20200226190152.16131-6-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiAbqtACZxUAOCGygYgff2fSwPAHDJcNbF8JiwTst00=;
 b=PAsKcD2DeUi9TP+Z2suMFjCq5FjP81CeYmYxfCFEaFU29FyQD8ZJeW5r7aqb4CCxLFdgoxC3BeP4Yo3UlnQS+rlNKinympu98pDAlajBtJNDu/F2UuhDcml+7R0xpRY9rMnXpNpeaJdwJkk5D8MEkmd+GegVHm2tY+yhmaXB4oo=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

gpu.buffer.peak.stats
        A read-only flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Largest (high water mark) GEM buffer allocated in bytes.

Change-Id: I40fe4c13c1cea8613b3e04b802f3e1f19eaab4fc
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
 include/linux/cgroup_drm.h              |  3 +++
 kernel/cgroup/drm.c                     | 12 ++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c041e672cc10..6199cc9a978f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2075,6 +2075,12 @@ GPU Interface Files
 
 	Total GEM buffer allocation in bytes.
 
+  gpu.buffer.peak.stats
+	A read-only flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Largest (high water mark) GEM buffer allocated in bytes.
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 34b0aec7c964..d90807627213 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -13,6 +13,7 @@
 
 enum drmcg_res_type {
 	DRMCG_TYPE_BO_TOTAL,
+	DRMCG_TYPE_BO_PEAK,
 	__DRMCG_TYPE_LAST,
 };
 
@@ -24,6 +25,8 @@ enum drmcg_res_type {
 struct drmcg_device_resource {
 	/* for per device stats */
 	s64			bo_stats_total_allocated;
+
+	s64			bo_stats_peak_allocated;
 };
 
 /**
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index addb096edac5..68b23693418b 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -277,6 +277,9 @@ static void drmcg_print_stats(struct drmcg_device_resource *ddr,
 	case DRMCG_TYPE_BO_TOTAL:
 		seq_printf(sf, "%lld\n", ddr->bo_stats_total_allocated);
 		break;
+	case DRMCG_TYPE_BO_PEAK:
+		seq_printf(sf, "%lld\n", ddr->bo_stats_peak_allocated);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -325,6 +328,12 @@ struct cftype files[] = {
 		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_TOTAL,
 						DRMCG_FTYPE_STATS),
 	},
+	{
+		.name = "buffer.peak.stats",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_PEAK,
+						DRMCG_FTYPE_STATS),
+	},
 	{ }	/* terminate */
 };
 
@@ -373,6 +382,9 @@ void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 		ddr = drmcg->dev_resources[devIdx];
 
 		ddr->bo_stats_total_allocated += (s64)size;
+
+		if (ddr->bo_stats_peak_allocated < (s64)size)
+			ddr->bo_stats_peak_allocated = (s64)size;
 	}
 	mutex_unlock(&dev->drmcg_mutex);
 }
-- 
2.25.0

