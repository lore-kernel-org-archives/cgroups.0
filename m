From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] cfq-iosched: fix async oom queue handling
Date: Tue,  7 Jul 2015 11:35:54 -0400
Message-ID: <1436283361-3889-3-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VwpWvZ/o3tBG4uT6u+wgVQMlgwZ53NWqSMUD2+Gv5Z8=;
        b=DtqGNoZrD/IDsDh6/yciH5fwdJ9q3b7FaDXFEkl/FIxEB+yY0+LVJSZ38taPrm2hUA
         3AdejgOTN7fnHMdrabW7XdDh8dVzm18j054KbCbNHVbDclZZOdtwYBaPeqZeDTOcnPTP
         3+RE4Vi9vdSTtyO0PvB9rqD1S67UIZEO92yokJ6r6OIwS3U441uP1VHsITbb0oYh7my3
         +P1PZ9CpeBF/U/85t4P8MYYVBNNpomhrq1sRK8UwAALmWxj4oLhdVOInSrKtcZYNRZzs
         /n3KcLp/4XuDKFS6ZEOpdqkWFyyXyrINglmD/UdJomDgycI6RYDztFwr6x5hGbqibvAB
         444g==
In-Reply-To: <1436283361-3889-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>, Arianna Avanzini <avanzini.arianna@gmail.com>

Async cfqq's (cfq_queue's) are shared across cfq_data.  When
cfq_get_queue() obtains a new queue from cfq_find_alloc_queue(), it
stashes the pointer in cfq_data and reuses it from then on; however,
the function doesn't consider that cfq_find_alloc_queue() may return
the oom_cfqq under memory pressure and installs the returned queue
unconditionally.

If the oom_cfqq is installed as an async cfqq, cfq_set_request() will
continue calling cfq_get_queue() hoping to replace it with a proper
queue; however, cfq_get_queue() will keep returning the cached queue
for the slot - the oom_cfqq.

Fix it by skipping caching if the queue is the oom one.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e91093d..baf0b70 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3751,7 +3751,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
 	 */
-	if (!is_sync) {
+	if (!is_sync && cfqq != &cfqd->oom_cfqq) {
 		cfqq->ref++;
 		*async_cfqq = cfqq;
 	}
-- 
2.4.3
