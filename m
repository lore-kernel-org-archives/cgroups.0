From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: Remove unused cpuset_node_allowed
Date: Mon, 27 Feb 2023 08:07:19 +0000
Message-ID: <20230227080719.20280-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RJSGu/qfXmePZHGIW6fcFPW2ne2Dxi7qJibeVZWzM+Q=;
        b=QNGQKjqgskthvc9hYlPhzydoFh1K9pgDgl2dh41qT5tbRbMMxjHn1D2MxBTQuj50bK
         3z0EHLS3S4bI1u2wOe6EBLVr3bBANgoD1VOqw5PtZ39+4ZSzy8XkYErBr7qJO/uWJmSm
         9mZVhFHJvNo4nhery5shj6UrSe4vH5wb98aoi8s8DDbCfwpQ6lN1bO+piDQ5M/Ew8MIM
         JtUt1/BOqqyvMsXZ4m75fQofhjOy+u5v/KiS6CUcDtZ/VSIvRyzsJWC5rN1zCGBErOyx
         cyqHbUKoavROyy5GB4z5T4HDF78yphOeOgD5xRpP2yCMw7lOsrMjGBXHM6BD4QkyJU+2
         F3Uw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
has used __cpuset_node_allowed instead of cpuset_node_allowed to check
whether we can allocate on a memory node. Now this function isn't used by
anyone, so we can remove it safely.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cpuset.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index d58e0476ee8e..7fad5afe3bba 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -82,13 +82,6 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
 extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
 
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	if (cpusets_enabled())
-		return __cpuset_node_allowed(node, gfp_mask);
-	return true;
-}
-
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
 	return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
@@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 	return 1;
 }
 
-static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
-{
-	return true;
-}
-
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
 	return true;
-- 
2.25.1

