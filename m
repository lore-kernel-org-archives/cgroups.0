From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 08/11] drm, cgroup: Add peak GEM buffer allocation limit
Date: Fri, 14 Feb 2020 10:56:47 -0500
Message-ID: <20200214155650.21203-9-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEzt0MlEkEuOUnc7BpB7xU8iofhUsMuYdD0QvPihCjM=;
 b=So/sjdQGnZckRJCyflSkqPJ8bF2RKHpWLvT0NBij1+VD4ELglC2H4E/gPvyxsXw1FHQ4hNWoTO7OkDJhIFX9Sg+L4mj7DKLErOgwrPvxVF0fpV9A4573cQDY8wvOBQkPlE3QeKiwucUJ5lxFA2HFAVe0gsDJ9PYJEGpDvkZ4oLM=
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

drm.buffer.peak.default
        A read-only flat-keyed file which exists on the root cgroup.
        Each entry is keyed by the drm device's major:minor.

        Default limits on the largest GEM buffer allocation in bytes.

drm.buffer.peak.max
        A read-write flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Per device limits on the largest GEM buffer allocation in bytes.
        This is a hard limit.  Attempts in allocating beyond the cgroup
        limit will result in ENOMEM.  Shorthand understood by memparse
        (such as k, m, g) can be used.

        Set largest allocation for /dev/dri/card1 to 4MB
        echo "226:1 4m" > drm.buffer.peak.max

Change-Id: I5ab3fb4a442b6cbd5db346be595897c90217da69
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 +++++++++++
 include/drm/drm_cgroup.h                |  1 +
 include/linux/cgroup_drm.h              |  1 +
 kernel/cgroup/drm.c                     | 43 +++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 064172df63e2..ce5dc027366a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2102,6 +2102,24 @@ DRM Interface Files
 	Set allocation limit for /dev/dri/card0 to 512MB
 	echo "226:0 512m" > drm.buffer.total.max
 
+  drm.buffer.peak.default
+	A read-only flat-keyed file which exists on the root cgroup.
+	Each entry is keyed by the drm device's major:minor.
+
+	Default limits on the largest GEM buffer allocation in bytes.
+
+  drm.buffer.peak.max
+	A read-write flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Per device limits on the largest GEM buffer allocation in bytes.
+	This is a hard limit.  Attempts in allocating beyond the cgroup
+	limit will result in ENOMEM.  Shorthand understood by memparse
+	(such as k, m, g) can be used.
+
+	Set largest allocation for /dev/dri/card1 to 4MB
+	echo "226:1 4m" > drm.buffer.peak.max
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
index b03d90623763..eae400f3d9b4 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -29,6 +29,7 @@ struct drmcg_device_resource {
 	s64			bo_limits_total_allocated;
 
 	s64			bo_stats_peak_allocated;
+	s64			bo_limits_peak_allocated;
 
 	s64			bo_stats_count_allocated;
 };
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index ee85482edd90..5fcbbc13fa1c 100644
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
