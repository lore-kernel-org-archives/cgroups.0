From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/misc: update struct members descriptions
Date: Tue, 18 Jul 2023 14:38:34 +0530
Message-ID: <20230718090834.1829191-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=rFasPADKDOSC2TcKkDrajx7I4WcLOIqTqUkaIuQaH0U=;
 b=0JCatPuKVv1VkyKA6jz/jj+X0g8I2QexfBYh/hX44zjoQJINvNUGl9HHDEk6qQZKFVzj
 AxGg5x2Ev4hlw0yONHpTCO8X7cNj1aXJsvIxzj4VO8NWPjwPxNaztLgSsDsLJoVwhRN/
 cfNMHMcehIx3vNPsuUiB8YzD8SW5VIogdUQibHdhOd1PlkEVSbXVbJl1J6y+VeVpEuxg
 J0OvuPqCoef/37iZeaY9dNgAPo7nxJvOLoJZ4vGl7Piyup976nf9pxUv+NOZwAU/oC5M
 sTD/H81UrtyoAOp22vpE1MBa3J6BhTu0Au+0QRribR5GqkLtQEzcEqRxP7G7MUjiogc0 qg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFasPADKDOSC2TcKkDrajx7I4WcLOIqTqUkaIuQaH0U=;
 b=RFhIkgoW7rByi2xU7U1WhNrYqjqd5xL36wwq5zhp9tH/FFfCdtimKyXH40yrfej4D6jeZfkhHvCapnt5f3EsOTYTQ1s9MboscyPUvh+lMrIjPF02N2x9ycq1/GBhfXTiZ51MNIqwpohSHT0sroMJMW+uzhv40N7LkMw5fTI4dhU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Update the miscellaneous controller's structure member's description of
struct misc_res and struct misc_cg.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/misc_cgroup.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c238207d1615..6555c0f57158 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -31,7 +31,7 @@ struct misc_cg;
  * struct misc_res: Per cgroup per misc type resource
  * @max: Maximum limit on the resource.
  * @usage: Current usage of the resource.
- * @failed: True if charged failed for the resource in a cgroup.
+ * @events: Number of times, the resource limit exceeded.
  */
 struct misc_res {
 	unsigned long max;
@@ -42,6 +42,7 @@ struct misc_res {
 /**
  * struct misc_cg - Miscellaneous controller's cgroup structure.
  * @css: cgroup subsys state object.
+ * @events_file: Handle for the misc resources events file.
  * @res: Array of misc resources usage in the cgroup.
  */
 struct misc_cg {
-- 
2.34.3

