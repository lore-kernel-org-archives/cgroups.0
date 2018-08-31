From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 05/15] blkcg: update blkg_lookup_create to do locking
Date: Thu, 30 Aug 2018 21:53:46 -0400
Message-ID: <20180831015356.69796-6-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V/nPLJiLoMbwxwUN+SeDjrPjMrJFtIi3YKNpVCr/rfI=;
        b=cHIUDDO7zpJyjduUj1AwohQqhchaeZcF5rHzrvC830EPVE0vyg+4cTpVyh4a4QtOpU
         +G9wWJT7qq6cToApALaQAi5T6bf1NbGO24PCuieqXgOz2/YsonS49UPFUl1UdubPctmx
         F7rY9id1fp/KHKAJ8Tz8JTc+66obEHPfA0q+C6PiT0/7FlWtnXEtToIU4PCwJSkb4CLT
         JUd+dM0bMrpjsOxGVs3MmiX9hfP6yeltlF/Vs+//MI2Onv+Ly3QKp2V5Fy5v8ul5qVPM
         q4L4s3/h27gsLS0zx4y2ev2/+80AIbpNemaARAo3pBIWbTfe7+ABErERcJYDvMngGfrv
         ALOw==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

To know when to create a blkg, the general pattern is to do a
blkg_lookup and if that fails, lock and then do a lookup again and if
that fails finally create. It doesn't make much sense for everyone who
wants to do creation to write this themselves.

This changes blkg_lookup_create to do locking and implement this
pattern. The old blkg_lookup_create is renamed to __blkg_lookup_create.
If a call site wants to do its own error handling or already owns the
queue lock, they can use __blkg_lookup_create.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 block/blk-cgroup.c         | 31 ++++++++++++++++++++++++++++---
 block/blk-iolatency.c      |  2 +-
 include/linux/blk-cgroup.h |  4 +++-
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d7114308a480..f678cd555814 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -259,7 +259,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 }
 
 /**
- * blkg_lookup_create - lookup blkg, try to create one if not there
+ * __blkg_lookup_create - lookup blkg, try to create one if not there
  * @blkcg: blkcg of interest
  * @q: request_queue of interest
  *
@@ -272,8 +272,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
  * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
  * dead and bypassing, returns ERR_PTR(-EBUSY).
  */
-struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
-				    struct request_queue *q)
+struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
+				      struct request_queue *q)
 {
 	struct blkcg_gq *blkg;
 
@@ -310,6 +310,31 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 	}
 }
 
+/**
+ * blkg_lookup_create - find or create a blkg
+ * @blkcg: target block cgroup
+ * @q: target request_queue
+ *
+ * This looks up or creates the blkg representing the unique pair
+ * of the blkcg and the request_queue.
+ */
+struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
+				    struct request_queue *q)
+{
+	struct blkcg_gq *blkg = blkg_lookup(blkcg, q);
+	unsigned long flags;
+
+	if (unlikely(!blkg)) {
+		spin_lock_irqsave(q->queue_lock, flags);
+
+		blkg = __blkg_lookup_create(blkcg, q);
+
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+
+	return blkg;
+}
+
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 62fdd9002c29..22b2ff0440cc 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -410,7 +410,7 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
 	if (unlikely(!blkg)) {
 		if (!lock)
 			spin_lock_irq(q->queue_lock);
-		blkg = blkg_lookup_create(blkcg, q);
+		blkg = __blkg_lookup_create(blkcg, q);
 		if (IS_ERR(blkg))
 			blkg = NULL;
 		if (!lock)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index d3cafb1eda48..ea2dd6e6baf2 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -184,6 +184,8 @@ extern struct cgroup_subsys_state * const blkcg_root_css;
 
 struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
 				      struct request_queue *q, bool update_hint);
+struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
+				      struct request_queue *q);
 struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 				    struct request_queue *q);
 int blkcg_init_queue(struct request_queue *q);
@@ -835,7 +837,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	blkg = blkg_lookup(blkcg, q);
 	if (unlikely(!blkg)) {
 		spin_lock_irq(q->queue_lock);
-		blkg = blkg_lookup_create(blkcg, q);
+		blkg = __blkg_lookup_create(blkcg, q);
 		if (IS_ERR(blkg))
 			blkg = NULL;
 		spin_unlock_irq(q->queue_lock);
-- 
2.17.1

