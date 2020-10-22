From: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH v2 1/2] blk-cgroup: Fix memleak on error path
Date: Thu, 22 Oct 2020 16:57:57 -0400
Message-ID: <20201022205758.1739430-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

If new_blkg allocation raced with blk_policy change and
blkg_lookup_check fails, new_blkg is leaked.

Signed-off-by: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f9b55614d67d..f9389b7cf823 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -663,6 +663,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		blkg = blkg_lookup_check(pos, pol, q);
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
+			blkg_free(new_blkg);
 			goto fail_unlock;
 		}
 
-- 
2.28.0

