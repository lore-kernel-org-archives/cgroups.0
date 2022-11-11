From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 18/26] cgroup/misc: Expose root_misc
Date: Fri, 11 Nov 2022 10:35:23 -0800
Message-ID: <20221111183532.3676646-19-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191774; x=1699727774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wY8Ia7AhZOsSBmUDim+2xlwCX7VM8EjOrhb9ezVOttc=;
  b=CP7moDwxZdBbz+ai2ISJn8ohwUFqPbFTnZc97wcRrphBU0tPUK4mn+NE
   nyfu8SRGvGBGTFkAeEn0CC2GPcfgqadZFqgvf9K409D+kr+YJ4DrYLu8M
   n+P9994qJ5tAXS9OvBSOILxZ3HifnVKcw7tX/01ArQLXeMee4eeyd1kxk
   SW4XREmyq3/IOEZC+N/rQ+pbzFL9JBFip+CYyJQfShUWfYa+48tNcTf4k
   oM3osAoLXgCL/iXLyU/HRtkxM8V4kriPg2lYt5WiLWTdoFrMbguyMNmh8
   PcJjgbjMOBum5JAG3l3/lNKgb6BWJFdOjIcBh7hEUztb5tFaBDbME77nY
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The SGX driver will need to get access to the root misc_cg object
to do iterative walks and also determine if a charge will be
towards the root cgroup or not.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h | 5 +++++
 kernel/cgroup/misc.c        | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 8f1b7b6cb81d..b79c78378f17 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -59,6 +59,7 @@ struct misc_cg {
 	struct misc_res res[MISC_CG_RES_TYPES];
 };
 
+struct misc_cg *root_misc(void);
 unsigned long misc_cg_res_total_usage(enum misc_res_type type);
 int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity);
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
@@ -106,6 +107,10 @@ static inline void put_misc_cg(struct misc_cg *cg)
 }
 
 #else /* !CONFIG_CGROUP_MISC */
+static inline struct misc_cg *root_misc(void)
+{
+	return NULL;
+}
 
 static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
 {
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 1e93e1d20347..8aa994d9cd02 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -45,6 +45,15 @@ static unsigned long misc_res_capacity[MISC_CG_RES_TYPES];
  */
 static BLOCKING_NOTIFIER_HEAD(misc_cg_notify_list);
 
+/**
+ * root_misc() - Return the root misc cgroup.
+ */
+struct misc_cg *root_misc(void)
+{
+	return &root_cg;
+}
+EXPORT_SYMBOL_GPL(root_misc);
+
 /**
  * parent_misc() - Get the parent of the passed misc cgroup.
  * @cgroup: cgroup whose parent needs to be fetched.
-- 
2.37.3

