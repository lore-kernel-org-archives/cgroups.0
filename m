From: Wu Bo <wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] blkcg:Fix memory leaks in blkg_conf_prep()
Date: Mon, 18 May 2020 20:36:06 +0800
Message-ID: <1589805366-328489-1-git-send-email-wubo40@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Markus.Elfring-S0/GAf8tV78@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Wu Bo <wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

If a call of the function blkg_lookup_check() failed,
we should be release the previously allocated block group 
before jumping to the lable 'fail_unlock' in the implementation of 
the function blkg_conf_prep().

Suggested-by: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Signed-off-by: Wu Bo <wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

---
V2: omit the source code quotation from 
    the change description

---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 930212c..afeb769 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -682,6 +682,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		blkg = blkg_lookup_check(pos, pol, q);
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
+			blkg_free(new_blkg);
 			goto fail_unlock;
 		}
 
-- 
1.8.3.1

