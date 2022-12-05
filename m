From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 1/9] blk-throttle: correct stale comment in throtl_pd_init
Date: Mon,  5 Dec 2022 19:57:01 +0800
Message-ID: <20221205115709.251489-2-shikemeng@huaweicloud.com>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221205115709.251489-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com, linfeilong@huawei.com, liuzhiqiang26@huawei.com

From: Kemeng Shi <shikemeng@huawei.com>

On the default hierarchy (cgroup2), the throttle interface files don't
exist in the root cgroup, so the ablity to limit the whole system
by configuring root group is not existing anymore. In general, cgroup
doesn't wanna be in the business of restricting resources at the
system level, so correct the stale comment that we can limit whole
system to we can only limit subtree.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/blk-throttle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 847721dc2b2b..8e2349b17936 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -395,8 +395,9 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 	 * If on the default hierarchy, we switch to properly hierarchical
 	 * behavior where limits on a given throtl_grp are applied to the
 	 * whole subtree rather than just the group itself.  e.g. If 16M
-	 * read_bps limit is set on the root group, the whole system can't
-	 * exceed 16M for the device.
+	 * read_bps limit is set on a parent group, summary bps of
+	 * parent group and its subtree groups can't exceed 16M for the
+	 * device.
 	 *
 	 * If not on the default hierarchy, the broken flat hierarchy
 	 * behavior is retained where all throtl_grps are treated as if
-- 
2.30.0

