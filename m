From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [patch v11 4/6] block, bfq: do not idle if only one group is activated
Date: Fri, 16 Sep 2022 15:19:40 +0800
Message-ID: <20220916071942.214222-5-yukuai1@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220916071942.214222-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Now that root group is counted into 'num_groups_with_pending_reqs',
'num_groups_with_pending_reqs > 0' is always true in
bfq_asymmetric_scenario(). Thus change the condition to '> 1'.

On the other hand, this change can enable concurrent sync io if only
one group is activated.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 block/bfq-iosched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 970b302a7a3e..6d95b0e488a8 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -820,7 +820,7 @@ bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq)
  * much easier to maintain the needed state:
  * 1) all active queues have the same weight,
  * 2) all active queues belong to the same I/O-priority class,
- * 3) there are no active groups.
+ * 3) there is at most one active group.
  * In particular, the last condition is always true if hierarchical
  * support or the cgroups interface are not enabled, thus no state
  * needs to be maintained in this case.
@@ -852,7 +852,7 @@ static bool bfq_asymmetric_scenario(struct bfq_data *bfqd,
 
 	return varied_queue_weights || multiple_classes_busy
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
-	       || bfqd->num_groups_with_pending_reqs > 0
+	       || bfqd->num_groups_with_pending_reqs > 1
 #endif
 		;
 }
-- 
2.31.1

