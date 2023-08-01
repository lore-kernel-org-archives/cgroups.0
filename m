From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: clean up printk()
Date: Tue,  1 Aug 2023 12:52:14 +0530
Message-ID: <20230801072217.103554-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=V+kYGbsJzklsoofs/xc8UeJfE4hfedq+SXIGbVs2jIE=;
 b=xSBTJTD32TEmS/5/KbhAgmPuk/2cOohqg71QyfmQkFReojvCnNuDAjpAKlu2Dv7lGgou
 2cOqQfbCzvD7fs1BJzmVb2Zs/uiXm7/gmlsR0SvWjrIF4qx9r1dP+FD1jVsn7Gcr0qWE
 TYg+yuVjac0CISgqEQ3OYjP9YhwWYxHGArIsFtKNqA2fIusK0pqcv9i9IdKFNWlqvtf1
 WmdVNK8AMxG6CrRbi/SABLrAViEEpPNQ38rxJm90RONGe4T1/qRQVmhus3cjyZGGW89Y
 D/zhG0i3eJ13c6ovgmaeFAFE9KYfHgO7/3BBGmYVVvHCqcXrQieW1QwMqS7u10Gw+Rvj jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+kYGbsJzklsoofs/xc8UeJfE4hfedq+SXIGbVs2jIE=;
 b=jX6Ia1i1YSmhJ15pM/dqZPQ2/RvUX6KWMbtw3POaNlQnIBwKaR1bQBPQUDaH/OpBWnPl2S1sjMAJQsp8eq3B6FN6rWrn6ye+j1MrPARN5zQ3xKM6AC/PY/Tt81V8hYr1oprJlYh1uktPO4miQKV2hGBjtTrS8420h0JTHA7ImSA=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert the only printk() to use pr_*() helper. No functional change.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c7aafb59ecf2..33b586db14ef 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6086,8 +6086,8 @@ int __init cgroup_init(void)
 			continue;
 
 		if (cgroup1_ssid_disabled(ssid))
-			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
-			       ss->name);
+			pr_info("Disabling %s control group subsystem in v1 mounts\n",
+				ss->name);
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
-- 
2.41.0

