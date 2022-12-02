From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 15/18] cgroup/misc: Add per resource callbacks for css events
Date: Fri,  2 Dec 2022 10:36:51 -0800
Message-ID: <20221202183655.3767674-16-kristen@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006256; x=1701542256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+r1/QmCqDwq6NgBzwiM4c1v1mVeOdSGTv4jz3p+3jWY=;
  b=I67nmsCAVHbo9gnZ/CcXlniBuxun/jVvlhrqXEHVe1/VeXUCNPtW7Q44
   gmUKv2LhOBCljvN+v5f2AIJvoFFNErcCOHpkExCO7Xw+MpprMHIJX5xQc
   RvIemaKUzUj4IG36nWi0eje2DGQciJjPDrZhEeOEZD5RSsESJzp4MzLEQ
   Vo+tpnO9HzoCalkm0cQGsfjU9bUZMFrZ9gHOnBDWb7BSN8cSPGzqX+gsU
   G8kATd070glGgV02uoMH/bB81dkcLxAIqcucN0CekPPR1yn4guxxm+nhk
   NIcdD2dB2yxrwJzS3Lzk/5ik1DyG+Va6D70vg0j+GkZxWDxssY3wvgukZ
   g==;
In-Reply-To: <20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Consumers of the misc cgroup controller might need to perform separate actions
in the event of a cgroup alloc, free or release call. In addition,
writes to the max value may also need separate action. Add the ability
to allow downstream users to setup callbacks for these operations, and
call the per resource type callback when appropriate.

This code will be utilized by the SGX driver in a future patch.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h |  6 +++++
 kernel/cgroup/misc.c        | 51 ++++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c238207d1615..83620e7c4bb1 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,6 +37,12 @@ struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
 	atomic_long_t events;
+
+	/* per resource callback ops */
+	int (*misc_cg_alloc)(struct misc_cg *cg);
+	void (*misc_cg_free)(struct misc_cg *cg);
+	void (*misc_cg_released)(struct misc_cg *cg);
+	void (*misc_cg_max_write)(struct misc_cg *cg);
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index fe3e8a0eb7ed..3d17afd5b7a8 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -278,10 +278,13 @@ static ssize_t misc_cg_max_write(struct kernfs_open_file *of, char *buf,
 
 	cg = css_misc(of_css(of));
 
-	if (READ_ONCE(misc_res_capacity[type]))
+	if (READ_ONCE(misc_res_capacity[type])) {
 		WRITE_ONCE(cg->res[type].max, max);
-	else
+		if (cg->res[type].misc_cg_max_write)
+			cg->res[type].misc_cg_max_write(cg);
+	} else {
 		ret = -EINVAL;
+	}
 
 	return ret ? ret : nbytes;
 }
@@ -385,23 +388,39 @@ static struct cftype misc_cg_files[] = {
 static struct cgroup_subsys_state *
 misc_cg_alloc(struct cgroup_subsys_state *parent_css)
 {
+	struct misc_cg *parent_cg;
 	enum misc_res_type i;
 	struct misc_cg *cg;
+	int ret;
 
 	if (!parent_css) {
 		cg = &root_cg;
+		parent_cg = &root_cg;
 	} else {
 		cg = kzalloc(sizeof(*cg), GFP_KERNEL);
 		if (!cg)
 			return ERR_PTR(-ENOMEM);
+		parent_cg = css_misc(parent_css);
 	}
 
 	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
 		WRITE_ONCE(cg->res[i].max, MAX_NUM);
 		atomic_long_set(&cg->res[i].usage, 0);
+		if (parent_cg->res[i].misc_cg_alloc) {
+			ret = parent_cg->res[i].misc_cg_alloc(cg);
+			if (ret)
+				goto alloc_err;
+		}
 	}
 
 	return &cg->css;
+
+alloc_err:
+	for (i = 0; i < MISC_CG_RES_TYPES; i++)
+		if (parent_cg->res[i].misc_cg_free)
+			cg->res[i].misc_cg_free(cg);
+	kfree(cg);
+	return ERR_PTR(ret);
 }
 
 /**
@@ -412,13 +431,39 @@ misc_cg_alloc(struct cgroup_subsys_state *parent_css)
  */
 static void misc_cg_free(struct cgroup_subsys_state *css)
 {
-	kfree(css_misc(css));
+	struct misc_cg *cg = css_misc(css);
+	enum misc_res_type i;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++)
+		if (cg->res[i].misc_cg_free)
+			cg->res[i].misc_cg_free(cg);
+
+	kfree(cg);
+}
+
+/**
+ * misc_cg_released() - Release the misc cgroup
+ * @css: cgroup subsys object.
+ *
+ * Call the misc_cg resource type released callbacks.
+ *
+ * Context: Any context.
+ */
+static void misc_cg_released(struct cgroup_subsys_state *css)
+{
+	struct misc_cg *cg = css_misc(css);
+	enum misc_res_type i;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++)
+		if (cg->res[i].misc_cg_released)
+			cg->res[i].misc_cg_released(cg);
 }
 
 /* Cgroup controller callbacks */
 struct cgroup_subsys misc_cgrp_subsys = {
 	.css_alloc = misc_cg_alloc,
 	.css_free = misc_cg_free,
+	.css_released = misc_cg_released,
 	.legacy_cftypes = misc_cg_files,
 	.dfl_cftypes = misc_cg_files,
 };
-- 
2.38.1

