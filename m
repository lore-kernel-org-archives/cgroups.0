From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 40/68] block, bfq: move forward the getting of an extra ref in bfq_bfqq_move
Date: Thu,  9 Apr 2020 23:46:05 -0400
Message-ID: <20200410034634.7731-40-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490444;
        bh=bZPiNyvVGdaJKBKZrFOz0pBhySVoMImQT9fF9e1eZP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6U4SCiBUP8aRkTqLiM8MPfi1XifpHsabye4o65xbcfRtSHnBhgn5kr0MOBXXmBE2
         pFNVOkgKov+54jJSvO0ZAOesLiif2r/joFbhdhtH3HHqdXF7RELG6K823e8WFhXRfT
         avbdbEsjQmzTDwCj8TpWCUhU20lA9FZzcvuxH6T4=
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paolo Valente <paolo.valente@linaro.org>, cki-project@redhat.com, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit fd1bb3ae54a9a2e0c42709de861c69aa146b8955 ]

Commit ecedd3d7e199 ("block, bfq: get extra ref to prevent a queue
from being freed during a group move") gets an extra reference to a
bfq_queue before possibly deactivating it (temporarily), in
bfq_bfqq_move(). This prevents the bfq_queue from disappearing before
being reactivated in its new group.

Yet, the bfq_queue may also be expired (i.e., its service may be
stopped) before the bfq_queue is deactivated. And also an expiration
may lead to a premature freeing. This commit fixes this issue by
simply moving forward the getting of the extra reference already
introduced by commit ecedd3d7e199 ("block, bfq: get extra ref to
prevent a queue from being freed during a group move").

Reported-by: cki-project@redhat.com
Tested-by: cki-project@redhat.com
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index f0ff6654af289..9d963ed518d1f 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -642,6 +642,12 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_entity *entity = &bfqq->entity;
 
+	/*
+	 * Get extra reference to prevent bfqq from being freed in
+	 * next possible expire or deactivate.
+	 */
+	bfqq->ref++;
+
 	/* If bfqq is empty, then bfq_bfqq_expire also invokes
 	 * bfq_del_bfqq_busy, thereby removing bfqq and its entity
 	 * from data structures related to current group. Otherwise we
@@ -652,12 +658,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		bfq_bfqq_expire(bfqd, bfqd->in_service_queue,
 				false, BFQQE_PREEMPTED);
 
-	/*
-	 * get extra reference to prevent bfqq from being freed in
-	 * next possible deactivate
-	 */
-	bfqq->ref++;
-
 	if (bfq_bfqq_busy(bfqq))
 		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
 	else if (entity->on_st_or_in_serv)
@@ -677,7 +677,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
 		bfq_schedule_dispatch(bfqd);
-	/* release extra ref taken above */
+	/* release extra ref taken above, bfqq may happen to be freed now */
 	bfq_put_queue(bfqq);
 }
 
-- 
2.20.1

