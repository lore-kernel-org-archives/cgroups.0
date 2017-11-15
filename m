From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 6/7] blkcg: account requests instead of bios for request
 based request_queues
Date: Wed, 15 Nov 2017 09:22:41 -0800
Message-ID: <20171115172241.GX983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-7-tj@kernel.org>
 <20171114232355.vjxlzfbqbqj5ihq4@kernel.org>
 <9a2ddc6a-d618-a896-290c-254ffeb5e9d6@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mA9VjOIFHB5rr4UTTPJfwW0zasKI0qRUqZEhA3N8XLQ=;
        b=kpcZEEsib2yDtDYDrhaBAdBWzSi47kqXVzLMc7hgEbuZGbR1XglN4Jb42RT1F5WX7J
         qQSq/pKw8l4Hhzdj0wSgypHaEbgK+paG07iZ97zoXMYDxtipgIZCF4YDSnijYQOXOL0g
         M9AHN4jk7i/Q2YzZ1z3poPrwyAurdl21ZHxZ3nFBA3fo0mI5+qgMSRKRhxq5+Vf8Cfym
         dqA3K+nkHUofbPWeBJ8rI+5axgblN2vwFywQElljYBYju0lV5tA13y55ameOuie2MFUD
         D4TIWoqKkWF3SKScYOCVMvuwMdMEBp2HD+Bx17vCtbCjG+FtrvUTLGrXEQvcnI67X/7c
         UKWw==
Content-Disposition: inline
In-Reply-To: <9a2ddc6a-d618-a896-290c-254ffeb5e9d6-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

blkcg accounting is currently bio based, which is silly for request
based request_queues.  This is silly as the number of bios doesn't
have much to do with the actual number of IOs issued to the underlying
device (can be significantly higher or lower) and may change depending
on the implementation details on how the bios are issued (e.g. from
the recent split-bios-while-issuing change).

Do cgroup accounting for request based request_queues together with
gendisk accounting on request completion.

This makes cgroup accounting consistent with gendisk accounting and
what's happening on the system.

v3: Use q->request_fn test doesn't work on blk-mq.  Use
    queue_is_rq_based() instead as suggested by Jens.

v2: Use q->request_fn to skip bio based accounting instead of
    QUEUE_FLAG_IOSTAT as suggested by Shaohua.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-core.c           |    3 +++
 include/linux/blk-cgroup.h |   18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2429,6 +2429,7 @@ void blk_account_io_completion(struct re
 		cpu = part_stat_lock();
 		part = req->part;
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
+		blkcg_account_io_completion(req, bytes);
 		part_stat_unlock();
 	}
 }
@@ -2454,6 +2455,8 @@ void blk_account_io_done(struct request
 		part_round_stats(req->q, cpu, part);
 		part_dec_in_flight(req->q, part, rw);
 
+		blkcg_account_io_done(req);
+
 		hd_struct_put(part);
 		part_stat_unlock();
 	}
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -715,7 +715,8 @@ static inline bool blkcg_bio_issue_check
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
-	if (!throtl) {
+	/* if @q does io stat, blkcg stats are updated together with them */
+	if (!queue_is_rq_based(q) && !throtl) {
 		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
 				bio->bi_iter.bi_size);
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
@@ -764,6 +765,17 @@ static inline void blk_rq_disassociate_b
 	rq->blkg = NULL;
 }
 
+static inline void blkcg_account_io_completion(struct request *rq,
+					       unsigned int bytes)
+{
+	blkg_rwstat_add(&rq->blkg->stat_bytes, rq_data_dir(rq), bytes);
+}
+
+static inline void blkcg_account_io_done(struct request *rq)
+{
+	blkg_rwstat_add(&rq->blkg->stat_ios, rq_data_dir(rq), 1);
+}
+
 #else	/* CONFIG_BLK_CGROUP */
 
 struct blkcg {
@@ -823,6 +835,10 @@ static inline bool blkcg_bio_issue_check
 static inline void blk_rq_associate_blkg(struct request *rq, struct blkcg *blkcg) { }
 static inline void blk_rq_disassociate_blkg(struct request *rq) { }
 
+static inline void blkcg_account_io_completion(struct request *rq,
+					       unsigned int bytes) { }
+static inline void blkcg_account_io_done(struct request *rq) { }
+
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
 
