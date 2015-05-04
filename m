From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] blkcg: remove redundant code in blkcg_css_free()
Date: Mon, 4 May 2015 08:41:16 +0800
Message-ID: <5546C02C.3060803@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The check was needed only when we supported modular cgroup subsystem.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0ac817b..92b7edd 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -814,9 +814,7 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
 static void blkcg_css_free(struct cgroup_subsys_state *css)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
-
-	if (blkcg != &blkcg_root)
-		kfree(blkcg);
+	kfree(blkcg);
 }
 
 static struct cgroup_subsys_state *
-- 
1.9.1
