From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 01/18] cgroup/misc: Add per resource callbacks for CSS events
Date: Fri, 22 Sep 2023 20:06:40 -0700
Message-ID: <20230923030657.16148-2-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438421; x=1726974421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CWaM84xI5mGXkf+aiRiMgd1gKaujRaa2JuPurtwlf8Y=;
  b=U0B+NtHFKuBLO9I6DNye3WraaZEKf26w14SdDHHA07l1N79BAQ0lGhPb
   8PCaWO2jrzXsqtSKx1atOyyIgN6Q51Kaj9me++3ONChEdNEi7Il3ogEZa
   747VrJmx8vjHMiiQWA4Xteav+Apb373Qi2vurET8bP042ktzu5i5eHc/a
   /sO+FhP3xE8niDlcoCKAXOK2h7p9qsFzbCr2vaGXSjO84mmM+rJ+23DZM
   wBSTYfNs9SZ/+aXTu3JvlL0HcVa71QRKTCu6jy4Tvfj5LdejMn7VF/ngd
   SmTMiZUnbumSPoXbOQ+fi82kEumAOusjqJWRTAeKRAIay2rRDsd/n6cOQ
   A==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The misc cgroup controller (subsystem) currently does not perform
resource type specific action for Cgroups Subsystem State (CSS) events:
the 'css_alloc' event when a cgroup is created and the 'css_free' event
when a cgroup is destroyed, or in event of user writing the max value to
the misc.max file to set the usage limit of a specific resource
[admin-guide/cgroup-v2.rst, 5-9. Misc].

Define callbacks for those events and allow resource providers to
register the callbacks per resource type as needed. This will be
utilized later by the EPC misc cgroup support implemented in the SGX
driver:
- On css_alloc, allocate and initialize necessary structures for EPC
reclaiming, e.g., LRU list, work queue, etc.
- On css_free, cleanup and free those structures created in alloc.
- On max_write, trigger EPC reclaiming if the new limit is at or below
current usage.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V5:
- Remove prefixes from the callback names (tj)
- Update commit message (Jarkko)

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
index e799b1f8d05b..96a88822815a 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,6 +37,11 @@ struct misc_res {
 	u64 max;
 	atomic64_t usage;
 	atomic64_t events;
+
+	/* per resource callback ops */
+	int (*alloc)(struct misc_cg *cg);
+	void (*free)(struct misc_cg *cg);
+	void (*max_write)(struct misc_cg *cg);
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 79a3717a5803..62c9198dee21 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -276,10 +276,13 @@ static ssize_t misc_cg_max_write(struct kernfs_open_file *of, char *buf,
 
 	cg = css_misc(of_css(of));
 
-	if (READ_ONCE(misc_res_capacity[type]))
+	if (READ_ONCE(misc_res_capacity[type])) {
 		WRITE_ONCE(cg->res[type].max, max);
-	else
+		if (cg->res[type].max_write)
+			cg->res[type].max_write(cg);
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
+		if (parent_cg->res[i].alloc) {
+			ret = parent_cg->res[i].alloc(cg);
+			if (ret)
+				goto alloc_err;
+		}
 	}
 
 	return &cg->css;
+
+alloc_err:
+	for (i = 0; i < MISC_CG_RES_TYPES; i++)
+		if (parent_cg->res[i].free)
+			cg->res[i].free(cg);
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
+		if (cg->res[i].free)
+			cg->res[i].free(cg);
+
+	kfree(cg);
 }
 
 /* Cgroup controller callbacks */
-- 
2.25.1

