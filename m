From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 19/28] cgroup/misc: Add per resource callbacks for CSS events
Date: Wed, 12 Jul 2023 16:01:53 -0700
Message-ID: <20230712230202.47929-20-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202937; x=1720738937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TP2QR91RjVHQ9dyPHa8/7eEH5VE2VT3Zn/qVSkO1wJ0=;
  b=I7QJTOhHjresphU3ZeiAGnP4l/U7xq5Yz3pjhPKfyoSPQvdiC8rpXWLo
   DS1Tz3RDsfIoutLYVyBxfZ//pjNMhwvoHBoR3rWUjShFCx+C7FzIZFexI
   0l2pho/1n67eWs2zgNh8IQzHwLenpS8O/6BAUR4waZiN5QHYtsFZhClzj
   ydkRj3iuHgJhxDnTFHtO7i7Ih0Yi/ruVTDRtaSx7mvj6s/W1Tt34b/8tn
   NGWaxcr0DTXbTnxjA341pR4a/4ke4R3TLkNMPDYf1zDAjjoRrsgZ0JQCa
   Six9nfVzd9+4gFtf3h7IFJSyFmbu5VViURPqnQI7TImDMcYFJWcYlz5/J
   Q==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

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

Changes from V2:
- Removed the released() callback
---
 include/linux/misc_cgroup.h |  5 +++++
 kernel/cgroup/misc.c        | 32 +++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c238207d1615..9962b870d382 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,6 +37,11 @@ struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
 	atomic_long_t events;
+
+	/* per resource callback ops */
+	int (*misc_cg_alloc)(struct misc_cg *cg);
+	void (*misc_cg_free)(struct misc_cg *cg);
+	void (*misc_cg_max_write)(struct misc_cg *cg);
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index ff9f900981a3..4736db3cd418 100644
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
@@ -412,7 +431,14 @@ misc_cg_alloc(struct cgroup_subsys_state *parent_css)
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

