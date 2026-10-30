Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343618;
	b=ItMxMF/fTUax6mgZrmFrnacr/txXHYpkiKbH0Sz3ojRhzeFDXT3LPyX59p30Wk7wsRmK
	 dnyqvLpFlyGhGS+Txdo5BzBzxf/wv0ggiOQADAIepR94TlbLGejlgmLZb8LAaUDvWolPz
	 BuQeToVCnC/RkzE6eUHZT3MnImWpXw30fyQbNiTdYYYDjSY+03Pfpn4qz3avdo18/T3QG
	 UNU8nzfm7b1WteF7SL5XSQwzuH2r+xvMO8YykRlyscFiXIbmG4axu7FQ0Ix8tmrwXPbTv
	 0OhqnJ5X+yLoQlnSDc695D6VTDAvWQvqZDr50GOQGORrE2+EM6t/VwTgilTTJJaX6Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343618;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xSXZKnJaF8wDM1RTGOpRmeBE5QEl2R40SwibCETYzdM=;
	b=BP2l7toA2lwZSJdA+PunM6AEDkd5DXVF+jdMq2xnugxnn27aIO0SVqMRULJPsk0eL/v9
	 +IeyZYa1Sjhdy2OD0xyYwNhpTbJsxhrScZMKsTKWO3zSUNOjPWA3oSKJwGIwd+NHnB/Gq
	 kclPGpC6RuwOW63xRJ4H2koxKeXEQdJu+0nkx+5ThWgD6zSjgbS+atjKyFItiiA8p+AF2
	 yNsrcNnwBJOdRXJc4HT61WKcV+q0V33HrRl3Vx7Z14fZ+UtrjgqjRo79bEVPqtJCuda5x
	 TH+6Rh9RLD3b4owlJAgMZnqei/h35VjVwuFnWl9oMDJPH1BXre/EMiPwLYWLvP0F3Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=open-hieco.net;
	spf=pass smtp.mailfrom=open-hieco.net;
	arc=none smtp.remote-ip=115.124.28.97
Received: from out28-97.mail.aliyun.com (out28-97.mail.aliyun.com [115.124.28.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E40606A31F;
	Fri, 30 Oct 2026 07:00:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34E40606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=open-hieco.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=open-hieco.net
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436404|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.142792-0.00201303-0.855195;FP=13669390643055684079|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam011083099174;MF=likunyu@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.jstcwyJ_1793343606;
Received: from localhost.localdomain(mailfrom:likunyu@open-hieco.net fp:SMTPD_---.jstcwyJ_1793343606 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 15:00:11 +0800
From: Li kunyu <likunyu@open-hieco.net>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li kunyu <likunyu@open-hieco.net>
Subject: [PATCH 1/2] block: Add done_split_bio() for chained bio post-processing
Date: Fri, 30 Oct 2026 14:59:44 +0800
Message-ID: <20261030065945.88742-2-likunyu@open-hieco.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030065945.88742-1-likunyu@open-hieco.net>
References: <20261030065945.88742-1-likunyu@open-hieco.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The split-out chained bio path has a QoS accounting issue. In a complete
chained bio composed of 10 bio headers and 1 sub-bio (produced by
repeatedly splitting a large block), only the first bio header among the
10 bio headers, the one that satisfies atomic_dec_and_test(&bio->
__bi_remaining) and the single sub-bio can execute rq_qos_done_bio(bio)
to update the QoS-related accounting. To address this, a new QoS callback,
done_split_bio(), is added so that QoS-related data can also be updated
for the bio headers that never reach rq_qos_done_bio().

Signed-off-by: Li kunyu <likunyu@open-hieco.net>
---
 block/bio.c               |  2 ++
 block/blk-merge.c         |  4 +++-
 block/blk-rq-qos.c        |  9 +++++++++
 block/blk-rq-qos.h        | 23 +++++++++++++++++++++++
 include/linux/blk_types.h |  6 ++++++
 5 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index f95b63c0604a..00ba928e7481 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1865,6 +1865,8 @@ static inline bool bio_remaining_done(struct bio *bio)
 		return true;
 	}
 
+	rq_qos_done_split_bio(bio);
+
 	return false;
 }
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..e2781802168d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -149,8 +149,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 	if (split_sectors) {
 		bio = bio_submit_split_bioset(bio, split_sectors,
 				&bio->bi_bdev->bd_disk->bio_split);
-		if (bio)
+		if (bio) {
 			bio->bi_opf |= REQ_NOMERGE;
+			bio_set_flag(bio, BIO_QOS_CHAIN_CHILD);
+		}
 	}
 
 	return bio;
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 85cf74402a09..41ee04defca7 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -95,6 +95,15 @@ void __rq_qos_done_bio(struct rq_qos *rqos, struct bio *bio)
 	} while (rqos);
 }
 
+void __rq_qos_done_split_bio(struct rq_qos *rqos, struct bio *bio)
+{
+	do {
+		if (rqos->ops->done_split_bio)
+			rqos->ops->done_split_bio(rqos, bio);
+		rqos = rqos->next;
+	} while (rqos);
+}
+
 void __rq_qos_queue_depth_changed(struct rq_qos *rqos)
 {
 	do {
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index a747a504fe42..6c80ae02025a 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -45,6 +45,7 @@ struct rq_qos_ops {
 	void (*cleanup)(struct rq_qos *, struct bio *);
 	void (*queue_depth_changed)(struct rq_qos *);
 	void (*exit)(struct rq_qos *);
+	void (*done_split_bio)(struct rq_qos *, struct bio *);
 	const struct blk_mq_debugfs_attr *debugfs_attrs;
 };
 
@@ -108,6 +109,7 @@ void __rq_qos_throttle(struct rq_qos *rqos, struct bio *bio);
 void __rq_qos_track(struct rq_qos *rqos, struct request *rq, struct bio *bio);
 void __rq_qos_merge(struct rq_qos *rqos, struct request *rq, struct bio *bio);
 void __rq_qos_done_bio(struct rq_qos *rqos, struct bio *bio);
+void __rq_qos_done_split_bio(struct rq_qos *rqos, struct bio *bio);
 void __rq_qos_queue_depth_changed(struct rq_qos *rqos);
 
 static inline void rq_qos_cleanup(struct request_queue *q, struct bio *bio)
@@ -157,6 +159,27 @@ static inline void rq_qos_done_bio(struct bio *bio)
 		__rq_qos_done_bio(q->rq_qos, bio);
 }
 
+static inline void rq_qos_done_split_bio(struct bio *bio)
+{
+	struct request_queue *q;
+
+	if (!bio->bi_bdev || (!bio_flagged(bio, BIO_QOS_THROTTLED) &&
+			      !bio_flagged(bio, BIO_QOS_MERGED)) ||
+	    !bio_flagged(bio, BIO_QOS_CHAIN_CHILD))
+		return;
+
+	q = bdev_get_queue(bio->bi_bdev);
+
+	if (test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags) && q->rq_qos)
+		__rq_qos_done_split_bio(q->rq_qos, bio);
+
+	/*
+	 * Clear the flag to avoid multiple invocations of the function
+	 * for a single bio.
+	 */
+	bio_clear_flag(bio, BIO_QOS_CHAIN_CHILD);
+}
+
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 {
 	if (test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags) && q->rq_qos) {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 98e21b4cbf32..bf1afbf8eaab 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -323,6 +323,12 @@ enum {
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
 	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
+	/*
+	 * Marking the bio in a chained bio, except for the first bio header,
+	 * is mainly used to update the QoS statistics of the bio headers
+	 * after the first one.
+	 */
+	BIO_QOS_CHAIN_CHILD,
 	BIO_FLAG_LAST
 };
 
-- 
2.47.3

