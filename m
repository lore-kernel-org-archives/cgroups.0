From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 08/11] drm, cgroup: Add peak GEM buffer allocation limit
Date: Wed, 26 Feb 2020 14:01:49 -0500
Message-ID: <20200226190152.16131-9-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0yw5UORnhD9jhJZKoq3U0mozi1+naoh8kxFcJWfwYQ=;
 b=KgJaquNe0Hwu5kpjK6KkUnJ0pP6tS1H8sRS2QGP9xFnngd7UY9bqVDejDQ0SS7tPcSvTN3kLPt7Gcocw5f5cPvMpGjveMoUOe0Opc5fRz3oWMEbnvba9tvz3qnKwdjhF32ioJrCbDgNsY3ZubGGd0SJCG9XfJixctaG0J18bTlo=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

gpu.buffer.peak.default
        A read-only flat-keyed file which exists on the root cgroup.
        Each entry is keyed by the drm device's major:minor.

        Default limits on the largest GEM buffer allocation in bytes.

gpu.buffer.peak.max
        A read-write flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Per device limits on the largest GEM buffer allocation in bytes.
        This is a hard limit.  Attempts in allocating beyond the cgroup
        limit will result in ENOMEM.  Shorthand understood by memparse
        (such as k, m, g) can be used.

        Set largest allocation for /dev/dri/card1 to 4MB
        echo "226:1 4m" > gpu.buffer.peak.max

Change-Id: I5ab3fb4a442b6cbd5db346be595897c90217da69
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 +++++++++++
 include/drm/drm_cgroup.h                |  1 +
 include/linux/cgroup_drm.h              |  1 +
 kernel/cgroup/drm.c                     | 43 +++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f2d7abf5c783..581343472651 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2108,6 +2108,24 @@ GPU Interface Files
 	Set allocation limit for /dev/dri/card0 to 512MB
 	echo "226:0 512m" > gpu.buffer.total.max
 
+  gpu.buffer.peak.default
+	A read-only flat-keyed file which exists on the root cgroup.
+	Each entry is keyed by the drm device's major:minor.
+
+	Default limits on the largest GEM buffer allocation in bytes.
+
+  gpu.buffer.peak.max
+	A read-write flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Per device limits on the largest GEM buffer allocation in bytes.
+	This is a hard limit.  Attempts in allocating beyond the cgroup
+	limit will result in ENOMEM.  Shorthand understood by memparse
+	(such as k, m, g) can be used.
+
+	Set largest allocation for /dev/dri/card1 to 4MB
+	echo "226:1 4m" > gpu.buffer.peak.max
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 2783e56690db..2b41d4d22e33 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -16,6 +16,7 @@ struct drmcg_props {
 	bool			limit_enforced;
 
 	s64			bo_limits_total_allocated_default;
+	s64			bo_limits_peak_allocated_default;
 };
 
 void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 71023654fb77..aba3b26718c0 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -29,6 +29,7 @@ struct drmcg_device_resource {
 	s64			bo_limits_total_allocated;
 
 	s64			bo_stats_peak_allocated;
+	s64			bo_limits_peak_allocated;
 
 	s64			bo_stats_count_allocated;
 };
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 4b19e533941d..62d2a9d33d0c 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -95,6 +95,9 @@ static inline int init_drmcg_single(struct drmcg *drmcg, struct drm_device *dev)
 	ddr->bo_limits_total_allocated =
 		dev->drmcg_props.bo_limits_total_allocated_default;
 
+	ddr->bo_limits_peak_allocated =
+		dev->drmcg_props.bo_limits_peak_allocated_default;
+
 	return 0;
 }
 
@@ -305,6 +308,9 @@ static void drmcg_print_limits(struct drmcg_device_resource *ddr,
 	case DRMCG_TYPE_BO_TOTAL:
 		seq_printf(sf, "%lld\n", ddr->bo_limits_total_allocated);
 		break;
+	case DRMCG_TYPE_BO_PEAK:
+		seq_printf(sf, "%lld\n", ddr->bo_limits_peak_allocated);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -319,6 +325,10 @@ static void drmcg_print_default(struct drmcg_props *props,
 		seq_printf(sf, "%lld\n",
 			props->bo_limits_total_allocated_default);
 		break;
+	case DRMCG_TYPE_BO_PEAK:
+		seq_printf(sf, "%lld\n",
+			props->bo_limits_peak_allocated_default);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -476,6 +486,19 @@ static ssize_t drmcg_limit_write(struct kernfs_open_file *of, char *buf,
 
 			ddr->bo_limits_total_allocated = val;
 			break;
+		case DRMCG_TYPE_BO_PEAK:
+			rc = drmcg_process_limit_s64_val(sattr, true,
+				props->bo_limits_peak_allocated_default,
+				S64_MAX,
+				&val);
+
+			if (rc || val < 0) {
+				drmcg_pr_cft_err(drmcg, rc, cft_name, minor);
+				break;
+			}
+
+			ddr->bo_limits_peak_allocated = val;
+			break;
 		default:
 			break;
 		}
@@ -517,6 +540,20 @@ struct cftype files[] = {
 		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_PEAK,
 						DRMCG_FTYPE_STATS),
 	},
+	{
+		.name = "buffer.peak.default",
+		.seq_show = drmcg_seq_show,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_PEAK,
+						DRMCG_FTYPE_DEFAULT),
+	},
+	{
+		.name = "buffer.peak.max",
+		.write = drmcg_limit_write,
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_PEAK,
+						DRMCG_FTYPE_LIMIT),
+	},
 	{
 		.name = "buffer.count.stats",
 		.seq_show = drmcg_seq_show,
@@ -546,6 +583,7 @@ void drmcg_device_early_init(struct drm_device *dev)
 	dev->drmcg_props.limit_enforced = false;
 
 	dev->drmcg_props.bo_limits_total_allocated_default = S64_MAX;
+	dev->drmcg_props.bo_limits_peak_allocated_default = S64_MAX;
 
 	drmcg_update_cg_tree(dev);
 }
@@ -585,6 +623,11 @@ bool drmcg_try_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 				result = false;
 				break;
 			}
+
+			if (ddr->bo_limits_peak_allocated < size) {
+				result = false;
+				break;
+			}
 		}
 	}
 
-- 
2.25.0

