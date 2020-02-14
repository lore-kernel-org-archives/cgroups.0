From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 05/11] drm, cgroup: Add peak GEM buffer allocation stats
Date: Fri, 14 Feb 2020 10:56:44 -0500
Message-ID: <20200214155650.21203-6-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oy38XTm1AslX2SVWlbJy84/4buILNfghMRpt4e5sNT4=;
 b=O/tD8aOn9LPELaSLMQQEKZjmCEVywCBgQl6mzQbzYBHj9AZChiO5C59V0gxFj8yjMrVIxO9jZrDx7nsq6DFKD6U+7HOX7RQa/uo2V5vepfWLH0w0wrK+1p+1qk/COioxYPvKVn32iEQHUhTvsxc7L+2WCU6HJ2S3mczaIfi2AhY=
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

drm.buffer.peak.stats
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
index 2d8162c109f3..75b97962b127 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2069,6 +2069,12 @@ DRM Interface Files
 
 	Total GEM buffer allocation in bytes.
 
+  drm.buffer.peak.stats
+	A read-only flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Largest (high water mark) GEM buffer allocated in bytes.
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 174ab50701ef..593ad12602cd 100644
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
index 425566753a5c..7a0da70c5a25 100644
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
