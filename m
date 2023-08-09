From: Wenyu Liu <liuwenyu7-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup:clean an indentation issue, remove extraneous tabs
Date: Wed, 9 Aug 2023 16:19:31 +0800
Message-ID: <20230809081931.3745405-1-liuwenyu7@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: louhongxiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

There is an extraneous tab around css_set_count,
clean it by remove the tab.

Signed-off-by: Wenyu Liu <liuwenyu7-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f55a40db065f..12a8dfeb45f4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -767,7 +767,7 @@ struct css_set init_css_set = {
 	.dfl_cgrp		= &cgrp_dfl_root.cgrp,
 };
 
-static int css_set_count	= 1;	/* 1 for init_css_set */
+static int css_set_count = 1;	/* 1 for init_css_set */
 
 static bool css_set_threaded(struct css_set *cset)
 {
-- 
2.33.0

