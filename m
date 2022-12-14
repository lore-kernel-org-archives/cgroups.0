From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 1/2] block, bfq: don't return bfqg from __bfq_bic_change_cgroup()
Date: Wed, 14 Dec 2022 11:31:54 +0800
Message-ID: <20221214033155.3455754-2-yukuai1@huaweicloud.com>
References: <20221214033155.3455754-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221214033155.3455754-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The return value is not used, hence remove it.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 627476bc6495..23dc355a106d 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -724,9 +724,9 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
  * sure that the reference to cgroup is valid across the call (see
  * comments in bfq_bic_update_cgroup on this issue)
  */
-static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
-				     struct bfq_io_cq *bic,
-				     struct bfq_group *bfqg)
+static void __bfq_bic_change_cgroup(struct bfq_data *bfqd,
+				    struct bfq_io_cq *bic,
+				    struct bfq_group *bfqg)
 {
 	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
 	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
@@ -776,8 +776,6 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 			}
 		}
 	}
-
-	return bfqg;
 }
 
 void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
-- 
2.31.1

