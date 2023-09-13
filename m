From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for CSS events
Date: Tue, 12 Sep 2023 21:06:18 -0700
Message-ID: <20230913040635.28815-2-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578127; x=1726114127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQkt55v8KXd+nCRIxFPx1Ph1uWRU7k/GkDwDqYyAYB4=;
  b=DZvS/fv1RbnlWVs3YNpVyhVwRWI+FLWYdxqHOjoQiu1tTcEHHbvymWp3
   qm1gxigr1TulveryIee6EkuHGhHgz8EPM9J198iuDzeEf2wH8VvMnzMJ9
   Pk58EoQC/7YjozaKwj6fbgqcoxzRwZe9LvAEDb6AEqhOq88Xj9PVfSIxT
   c7yC4qXXlTsblF9CEwvRkzIe8k/qFtG3n3qR5BbfGLwjfi1A0HI7iNpeQ
   9jBxiDo8ICjgQH7cONCSOPMTnxorsIN+dlucCiNQj4e2ftNO6rEIZJUlW
   suHwxUq8JUb1/b7gNga6a1fX4yyjKsOS5Q3UcbgnRYromM77H8OmG4/n4
   g==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Consumers of the misc cgroup controller might need to perform separate
actions for Cgroups Subsystem State(CSS) events: cgroup alloc and free.
In addition, writes to the max value may also need separate action. Add
the ability to allow downstream users to setup callbacks for these
operations, and call the corresponding per-resource-type callback when
appropriate.

This code will be utilized by the SGX driver in a future patch.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V4:
- Moved this to the front of the series.
- Applies on cgroup/for-6.6 with the overflow fix for misc.

V3:
- Removed the released() callback
---
 include/linux/misc_cgroup.h |  5 +++++
 kernel/cgroup/misc.c        | 32 +++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index e799b1f8d05b..e1bcd176c2de 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,6 +37,11 @@ struct misc_res {
 	u64 max;
 	atomic64_t usage;
 	atomic64_t events;
+
+	/* per resource callback ops */
+	int (*misc_cg_alloc)(struct misc_cg *cg);
+	void (*misc_cg_free)(struct misc_cg *cg);
+	void (*misc_cg_max_write)(struct misc_cg *cg);
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 79a3717a5803..e0092170d0dd 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -276,10 +276,13 @@ static ssize_t misc_cg_max_write(struct kernfs_open_file *of, char *buf,
 
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
@@ -383,23 +386,39 @@ static struct cftype misc_cg_files[] = {
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
 		atomic64_set(&cg->res[i].usage, 0);
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
@@ -410,7 +429,14 @@ misc_cg_alloc(struct cgroup_subsys_state *parent_css)
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
 }
 
 /* Cgroup controller callbacks */
-- 
2.25.1

