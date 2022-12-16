From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v2 03/10] block, bfq: initialize bfqq->decrease_time_jif correctly
Date: Fri, 16 Dec 2022 19:12:23 +0800
Message-ID: <20221216111230.3638832-4-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuzhiqiang-L7zZNxrQPSE@public.gmane.org, shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org

Inject limit is updated or reset when time_is_before_eq_jiffies(
decrease_time_jif + several msecs) or think-time state changes.
decrease_time_jif is initialized to 0 and will be set to current jiffies
when inject limit is updated or reset. If the jiffies is slightly greater
than LONG_MAX, time_is_after_eq_jiffies(0) will keep for a long time, so as
time_is_after_eq_jiffies(decrease_time_jif + several msecs). If the
think-time state never chages, then the injection will not work as expected
for long time.

To be more specific:
Function bfq_update_inject_limit maybe triggered when jiffies pasts
decrease_time_jif + msecs_to_jiffies(10) in bfq_add_request by setting
bfqd->wait_dispatch to true.
Function bfq_reset_inject_limit are called in two conditions:
1. jiffies pasts bfqq->decrease_time_jif + msecs_to_jiffies(1000) in
function bfq_add_request.
2. jiffies pasts bfqq->decrease_time_jif + msecs_to_jiffies(100) or
bfq think-time state change from short to long.

Fix this by initializing bfqq->decrease_time_jif to current jiffies
to trigger service injection soon when service injection conditions
are met.

Signed-off-by: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
---
 block/bfq-iosched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5a6d9e8c329d..9441fc98961a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5491,6 +5491,8 @@ static void bfq_init_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	/* first request is almost certainly seeky */
 	bfqq->seek_history = 1;
+
+	bfqq->decrease_time_jif = jiffies;
 }
 
 static struct bfq_queue **bfq_async_queue_prio(struct bfq_data *bfqd,
-- 
2.30.0

