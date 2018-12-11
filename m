From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] blkcg: handle dying request_queue when associating a blkg
Date: Tue, 11 Dec 2018 18:03:08 -0500
Message-ID: <20181211230308.66276-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Dennis Zhou <dennis@kernel.org>

Between v3 [1] and v4 [2] of the blkg association series, the
association point moved from generic_make_request_checks(), which is
called after the request enters the queue, to bio_set_dev(), which is when
the bio is formed before submit_bio(). When the request_queue goes away,
the blkgs supporting the request_queue are destroyed and then the
q->root_blkg is set to %NULL.

This patch adds a %NULL check to blkg_tryget_closest() to prevent the
NPE caused by the above. It also adds a guard to see if the
request_queue is dying when creating a blkg to prevent creating a blkg
for a dead request_queue.

[1] https://lore.kernel.org/lkml/20180911184137.35897-1-dennisszhou@gmail.com/
[2] https://lore.kernel.org/lkml/20181126211946.77067-1-dennis@kernel.org/

Fixes: 5cdf2e3fea5e ("blkcg: associate blkg when associating a device")
Reported-and-tested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 block/blk-cgroup.c         | 6 ++++++
 include/linux/blk-cgroup.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6bd0619a7d6e..c30661ddc873 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -202,6 +202,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(&q->queue_lock);
 
+	/* request_queue is dying, do not create/recreate a blkg */
+	if (blk_queue_dying(q)) {
+		ret = -ENODEV;
+		goto err_free_blkg;
+	}
+
 	/* blkg holds a reference to blkcg */
 	if (!css_tryget_online(&blkcg->css)) {
 		ret = -ENODEV;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index bf13ecb0fe4f..f025fd1e22e6 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -511,7 +511,7 @@ static inline bool blkg_tryget(struct blkcg_gq *blkg)
  */
 static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
 {
-	while (!percpu_ref_tryget(&blkg->refcnt))
+	while (blkg && !percpu_ref_tryget(&blkg->refcnt))
 		blkg = blkg->parent;
 
 	return blkg;
-- 
2.17.1

