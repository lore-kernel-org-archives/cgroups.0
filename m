From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH] blk-throttle: don't check whether or not lower limit is valid if CONFIG_BLK_DEV_THROTTLING_LOW is off
Date: Thu, 26 Nov 2020 11:18:34 +0800
Message-ID: <20201126031834.40807-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, zhangxiaoxu5@huawei.com

blk_throtl_update_limit_valid() will search for descendants to see if
'LIMIT_LOW' of bps/iops and READ/WRITE is nonzero. However, they're always
zero if CONFIG_BLK_DEV_THROTTLING_LOW is not set, furthermore, a lot of
time will be wasted to iterate descendants.

Thus do nothing in blk_throtl_update_limit_valid() in such situation.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b771c4299982..d52cac9f3a7c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -587,6 +587,7 @@ static void throtl_pd_online(struct blkg_policy_data *pd)
 	tg_update_has_rules(tg);
 }
 
+#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 static void blk_throtl_update_limit_valid(struct throtl_data *td)
 {
 	struct cgroup_subsys_state *pos_css;
@@ -607,6 +608,11 @@ static void blk_throtl_update_limit_valid(struct throtl_data *td)
 
 	td->limit_valid[LIMIT_LOW] = low_valid;
 }
+#else
+static inline void blk_throtl_update_limit_valid(struct throtl_data *td)
+{
+}
+#endif
 
 static void throtl_upgrade_state(struct throtl_data *td);
 static void throtl_pd_offline(struct blkg_policy_data *pd)
-- 
2.25.4

