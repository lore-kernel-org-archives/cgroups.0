From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] blkcg: put back rcu lock in blkcg_bio_issue_check()
Date: Thu,  6 Dec 2018 12:49:38 -0500
Message-ID: <20181206174938.2326-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

I was a little overzealous in removing the rcu_read_lock() call from
blkcg_bio_issue_check() and it broke blk-throttle. Put it back.

Fixes: e35403a034bf ("blkcg: associate blkg when associating a device")
Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 include/linux/blk-cgroup.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 752de1becb5c..bf13ecb0fe4f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -764,6 +764,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	struct blkcg_gq *blkg;
 	bool throtl = false;
 
+	rcu_read_lock();
+
 	if (!bio->bi_blkg) {
 		char b[BDEVNAME_SIZE];
 
@@ -791,6 +793,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 
 	blkcg_bio_issue_init(bio);
 
+	rcu_read_unlock();
 	return !throtl;
 }
 
-- 
2.17.1

