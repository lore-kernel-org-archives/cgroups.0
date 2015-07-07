From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] cfq-iosched: move cfq_group determination from cfq_find_alloc_queue() to cfq_get_queue()
Date: Tue,  7 Jul 2015 11:35:59 -0400
Message-ID: <1436283361-3889-8-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1nHfoXh8aIlbhQxz1I1ry5GXgxw80kWzyRwZElu6w1I=;
        b=LsAzKczj3OeJBBtqXqHuTQdSz4+L1nBjmzALovCDhdvGwAaP9IAuf/+eBXVtyjCX9T
         lUOR/A3MZCW61UApddxnrQZ1JCS/6Ngz79LKVFO5Fg7aBYiP1QYgpGYqy9IEZRSpu+N3
         8Xsxy3rW5O70NPeQwwlmfTF9S/DxjInhmCkKxR00FE1b6jogZaipAjJi7PjaXk0Nzchx
         nFVfJSGi4TYERC3EpRSEfYmgEoCLgOX938TzGR2ZTy9vtf6ttwpKosFuuCAz617mQ6AC
         05IK/271Jrlse/+5uCNfm4V4wQUTP77nkx/evgmyuHB5NHFbKxwWbz1sHYIcMdyG0I92
         tS5w==
In-Reply-To: <1436283361-3889-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>, Arianna Avanzini <avanzini.arianna@gmail.com>

This is necessary for making async cfq_cgroups per-cfq_group instead
of per-cfq_data.  While this change makes cfq_get_queue() perform RCU
locking and look up cfq_group even when it reuses async queue, the
extra overhead is extremely unlikely to be noticeable given that this
is already sitting behind cic->cfqq[] cache and the overall cost of
cfq operation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 146b03d..f3ea8a1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3641,21 +3641,10 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
-cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
-		     struct bio *bio)
+cfq_find_alloc_queue(struct cfq_data *cfqd, struct cfq_group *cfqg, bool is_sync,
+		     struct cfq_io_cq *cic, struct bio *bio)
 {
-	struct blkcg *blkcg;
 	struct cfq_queue *cfqq;
-	struct cfq_group *cfqg;
-
-	rcu_read_lock();
-
-	blkcg = bio_blkcg(bio);
-	cfqg = cfq_lookup_create_cfqg(cfqd, blkcg);
-	if (!cfqg) {
-		cfqq = &cfqd->oom_cfqq;
-		goto out;
-	}
 
 	cfqq = cic_to_cfqq(cic, is_sync);
 
@@ -3675,8 +3664,6 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 		} else
 			cfqq = &cfqd->oom_cfqq;
 	}
-out:
-	rcu_read_unlock();
 	return cfqq;
 }
 
@@ -3706,6 +3693,14 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
 	struct cfq_queue **async_cfqq;
 	struct cfq_queue *cfqq;
+	struct cfq_group *cfqg;
+
+	rcu_read_lock();
+	cfqg = cfq_lookup_create_cfqg(cfqd, bio_blkcg(bio));
+	if (!cfqg) {
+		cfqq = &cfqd->oom_cfqq;
+		goto out;
+	}
 
 	if (!is_sync) {
 		if (!ioprio_valid(cic->ioprio)) {
@@ -3719,7 +3714,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio);
+	cfqq = cfq_find_alloc_queue(cfqd, cfqg, is_sync, cic, bio);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -3730,6 +3725,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	}
 out:
 	cfqq->ref++;
+	rcu_read_unlock();
 	return cfqq;
 }
 
-- 
2.4.3
