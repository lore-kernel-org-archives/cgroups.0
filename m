From: Wu Bo <wubo40@huawei.com>
Subject: [PATCH] blkcg:fixes memory leaks in blkg_conf_prep()
Date: Fri, 15 May 2020 20:24:03 +0800
Message-ID: <1589545443-151387-1-git-send-email-wubo40@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com, linfeilong@huawei.com, wubo40@huawei.com

blkg_conf_prep():
 
new_blkg = blkg_alloc(pos, q, GFP_KERNEL);
...
blkg = blkg_lookup_check(pos, pol, q);
if (IS_ERR(blkg)) {
	ret = PTR_ERR(blkg);
	goto fail_unlock;
}
...


if calling blkg_lookup_check() failed, at the IS_ERR block, 
the new_blkg should be free before goto lable fail_unlock
in blkg_conf_prep() function.

Signed-off-by: Wu Bo <wubo40@huawei.com>
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

