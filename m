From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 21/26] cgroup/misc: allow misc cgroup consumers to read the max value
Date: Fri, 11 Nov 2022 10:35:26 -0800
Message-ID: <20221111183532.3676646-22-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191778; x=1699727778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bRGewpsYybIXP9Kh4EzoNOkrDN/D0MwqytH8St6QCMQ=;
  b=kYL2gj81ydUbyzi95Wd8M68ps5XL0o4vg+qgNxzUxtOgTaTT/qrmBUdq
   wDcMIth16dZId3UeKLYnymTWho2sjcbRbCqLna6FMC9ZlzOhVirN7M5Yy
   kpUXHYiAPLIlLj6U/vz0zf7fzHDfmBKiFNyWvGEiPCK22PMdIGen7l3Gw
   38DIKkkm9hdM9EP2Q311XH9+AzVIALjZsPnsrMN7AtSjUaw64tpxj40Yb
   LrqoiYrzxt3g0fqYOsGksRB6R8rcMIJLEBX/+TjCDCPIsbTVyZHt/YTYD
   uAJxnTXH9cnsJLQveoXuKgXao8Vb+XctLy2ceSGvkeZO+nqxpgfY5DYLE
   A==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The SGX driver will need to be able to read the max value per cgroup
to determine how far usage is from max. Add an api to return the
max value of the given cgroup.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h |  6 ++++++
 kernel/cgroup/misc.c        | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index a9dd087132dc..c00deae4d2df 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -62,6 +62,7 @@ struct misc_cg {
 struct misc_cg *root_misc(void);
 struct misc_cg *parent_misc(struct misc_cg *cg);
 unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg *cg);
+unsigned long misc_cg_max(enum misc_res_type type, struct misc_cg *cg);
 unsigned long misc_cg_res_total_usage(enum misc_res_type type);
 int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity);
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
@@ -124,6 +125,11 @@ static inline unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg
 	return 0;
 }
 
+static inline unsigned long misc_cg_max(enum misc_res_type type, struct misc_cg *cg)
+{
+	return 0;
+}
+
 static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
 {
 	return 0;
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index e2c99fdc1d40..18d0bec7d609 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -232,6 +232,25 @@ unsigned long misc_cg_read(enum misc_res_type type, struct misc_cg *cg)
 }
 EXPORT_SYMBOL_GPL(misc_cg_read);
 
+/**
+ * misc_cg_max() - Return the max value of the misc cgroup res.
+ * @type: Type of the misc res.
+ * @cg: Misc cgroup whose max will be read
+ *
+ * Context: Any context.
+ * Return:
+ * 	The max value of the specified misc cgroup.
+ * 	If an invalid misc_res_type is given, zero will be returned.
+ */
+unsigned long misc_cg_max(enum misc_res_type type, struct misc_cg *cg)
+{
+	if (!(valid_type(type) && cg))
+		return 0;
+
+	return READ_ONCE(cg->res[type].max);
+}
+EXPORT_SYMBOL_GPL(misc_cg_max);
+
 /**
  * misc_cg_max_show() - Show the misc cgroup max limit.
  * @sf: Interface file
-- 
2.37.3

