From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup: limit max copied char length for cgroup file name
Date: Sat, 9 Dec 2017 13:47:58 +0800
Message-ID: <20171209054758.13870-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

the result of cgroup_file_name will be used by kernfs_remove_name,
and then by kernfs_remove_by_name_ns().
If reached the max length, may have problem printed by WARN() in
kernfs_remove_by_name_ns().

Signed-off-by: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe147f24..7f588d1617c5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1397,7 +1397,7 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 			 cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
 			 cft->name);
 	else
-		strncpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
+		strncpy(buf, cft->name, CGROUP_FILE_NAME_MAX - 1);
 	return buf;
 }
 
-- 
2.13.6


