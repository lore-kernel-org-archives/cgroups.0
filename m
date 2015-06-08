From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] cfq-iosched: move cfq_group determination from cfq_find_alloc_queue() to cfq_get_queue()
Date: Mon,  8 Jun 2015 17:59:31 +0900
Message-ID: <1433753973-23684-7-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WS0IrpBi3zT+rfJGPLeSKQeyz0MN+ipigheaNJkQeU4=;
        b=QNcvrIW0v7Th12S99Z7g3bM62N7DJikppnFjp7YkCToekyb7HCRkJVhf+d098/Ap41
         Fws9ITQKwLGFILmJ+qEwmNdjE+6Ep+FCdglWL3ICcG38EghT/3y371xII+IFtGywkAew
         5e4jn2yO03S1yzUBEbUok2Is29K6yg38q6BHPj91ofwygZd3NF2eqanO+Xs93Mmf2tuh
         ydYp/HA117v5QKIrjfo0OJKZjDD4i4Y8yi+/nvyhXNnuvttR+2KOvUspoQKLuqCyvozq
         04x0NMdpOfc0MyHF/eTuuEn+RaLV04BL1cLy99CwWtJb798m7GcVEB5fCQO0VwmvImkz
         yvvA==
In-Reply-To: <1433753973-23684-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, Tejun Heo <tj@kernel.org>

This is necessary for making async cfq_cgroups per-cfq_group instead
of per-cfq_data.  While this change makes cfq_get_queue() perform RCU
locking and look up cfq_group even when it reuses async queue, the
extra overhead is extremely unlikely to be noticeable given that this
is already sitting behind cic->cfqq[] cache and the overall cost of
cfq operation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b8e83cd..a775128 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3573,21 +3573,10 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
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
 
@@ -3607,8 +3596,6 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 		} else
 			cfqq = &cfqd->oom_cfqq;
 	}
-out:
-	rcu_read_unlock();
 	return cfqq;
 }
 
@@ -3638,6 +3625,14 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
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
@@ -3651,7 +3646,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio);
+	cfqq = cfq_find_alloc_queue(cfqd, cfqg, is_sync, cic, bio);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -3662,6 +3657,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	}
 out:
 	cfqq->ref++;
+	rcu_read_unlock();
 	return cfqq;
 }
 
-- 
2.4.2
