From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 23/26] cgroup/misc: Add tryget functionality for misc controller
Date: Fri, 11 Nov 2022 10:35:28 -0800
Message-ID: <20221111183532.3676646-24-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191781; x=1699727781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eSkn/vztgv3b1H9AuqHP1f8+st1SIUnPEpjHioF/AGg=;
  b=aNX7gCXNB77Zoq0LIpI74k/wVWVCbS7k02cNdzM8lHUCMjrk3M49xxs4
   9Hy6XxA3OtiyyF4pwFMjhyeXj5D2geooZ18TZm3ALUbxGWrIfr8//X5j9
   F3+RLD9n7WUAQ1Dn3HZCjko1MdEVCUpsdwvLz25WGV2r/St+bukPRShkZ
   1Dl7NEzvT8yy/3s3FykGwa/9mIdUhLSOC+LtQ1TbQ4MxCEW9G+3wLr6Pk
   eMQIR1DbKSmsxgSEPg+vCLdXZeYT3nc9Egx7QElFfUAl8qdVNzoOsGZUo
   QAwr/154NpdKnULBX+np9F1mmJRsiEdUdbFLONgT5VaBexGUVtkQIthhB
   w==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Allows caller to do a css_tryget() on a specific misc cgroup.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 7fbf3efb0f62..cee848205715 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -112,6 +112,16 @@ static inline void put_misc_cg(struct misc_cg *cg)
 		css_put(&cg->css);
 }
 
+/*
+ * misc_cg_tryget() - Try to increment this misc cgroup ref count.
+ * @cg - cgroup to get.
+ */
+static inline bool misc_cg_tryget(struct misc_cg *cg)
+{
+	if (cg)
+		return css_tryget(&cg->css);
+	return false;
+}
 #else /* !CONFIG_CGROUP_MISC */
 static inline struct misc_cg *root_misc(void)
 {
@@ -175,6 +185,11 @@ static inline void put_misc_cg(struct misc_cg *cg)
 {
 }
 
+static inline bool misc_cg_tryget(struct misc_cg *cg)
+{
+	return true;
+}
+
 static inline int register_misc_cg_notifier(struct notifier_block *nb)
 {
 	return 0;
-- 
2.37.3

