From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 20/26] cgroup/misc: allow users of misc cgroup to read specific cgroup usage
Date: Fri, 11 Nov 2022 10:35:25 -0800
Message-ID: <20221111183532.3676646-21-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191776; x=1699727776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YoGb4j/ZQ61R2iQhhmxSzGX3p7smajRdGWvm5NNdTBs=;
  b=AucB0PwBRMGpEItGXZUTWsmONUkG/FmfD9juI6gfUor9xA9+Ob2NTkFF
   L4B8WH1aia4/s3+82BeFJSj6aGiwK3REC5R9EgYxI5sA2aBq3zE0U1a85
   k6tbUxOeztfpFY2iCr5AbjT4VX4nHMrQe+xO9lXXyJWVUAfnR5ZTZlaCA
   GgGYmNqEIumkHYiGU3Q1RTsPVj8AVy/yaRFb9KYt1Z/g1jrIJ/gYcLIrg
   NXbE6p2g2ovZuV42r9PEAd4VAaM8sZzyOgLI6k1YxTsCYWvs0WmgbTgd1
   elqSIreDZevioZG43Ny0wU9B8UJi/nOwqh8t3PZtVRl6UAKBPCGGv8KOY
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Add a function to return the current usage of the specified cgroup.
The SGX driver will need this information to decide whether to
reclaim EPC pages from a cgroup.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h |  6 ++++++
 kernel/cgroup/misc.c        | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index d1aeb85f2ed6..a9dd087132dc 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -61,6 +61,7 @@ struct misc_cg {
 
 struct misc_cg *root_misc(void);
 struct misc_cg *parent_misc(struct misc_cg *cg);
+unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg *cg);
 unsigned long misc_cg_res_total_usage(enum misc_res_type type);
 int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity);
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
@@ -118,6 +119,11 @@ static inline struct misc_cg *parent_misc(struct misc_cg *cg)
 	return NULL;
 }
 
+static inline unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg *cg)
+{
+	return 0;
+}
+
 static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
 {
 	return 0;
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index b22a055af9ad..e2c99fdc1d40 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -213,6 +213,25 @@ void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg,
 }
 EXPORT_SYMBOL_GPL(misc_cg_uncharge);
 
+/**
+ * misc_cg_read() - Return the current usage of the misc cgroup res.
+ * @type: Type of the misc res.
+ * @cg: Misc cgroup whose usage will be read
+ *
+ * Context: Any context.
+ * Return:
+ * 	The current total usage of the specified misc cgroup.
+ * 	If an invalid misc_res_type is given, zero will be returned.
+ */
+unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg *cg)
+{
+	if (!(valid_type(type) && cg))
+		return 0;
+
+	return atomic_long_read(&cg->res[type].usage);
+}
+EXPORT_SYMBOL_GPL(misc_cg_read);
+
 /**
  * misc_cg_max_show() - Show the misc cgroup max limit.
  * @sf: Interface file
-- 
2.37.3

