From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 43/51] writeback: add wb_writeback_work->auto_free
Date: Fri, 22 May 2015 17:13:57 -0400
Message-ID: <1432329245-5844-44-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/I4BM7K2yCvh4PQKJZoNNiMUNuZ7Alp/mu1Nj/jeuCE=;
        b=GcGWrfccZ0C2b1WUV6Rz4VTlM12zxpxChbY4tuBRpIBfr5Q6OfCC2Uj3F2aWlifIan
         Z2bRUdJsGMXY5rlRkPXTu87MUk0cEZJJ3SxHEJ777J2PfEL2wRY2p3VfuoxYvp6SSTFB
         KaCYB+3piacg1jeJLNtqma0tVyS6yGDeJwfdd8W5GMkrTjHbzp4EiicggitB6d3wDOzl
         RFaWjPBGLFUO01NwGTkVNvNqNqpptiUnyeqmz2nN/9uklJKb0oL55PmfvRkS/1Z4xnbR
         pl55tuPmz9lmljw7fDx7HCRhhL7+KmE+8AD6zjCRA7C0OqJI6boeiwvgWP7NvjvVkNi/
         Znqw==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

Currently, a wb_writeback_work is freed automatically on completion if
it doesn't have ->done set.  Add wb_writeback_work->auto_free to make
the switch explicit.  This will help cgroup writeback support where
waiting for completion and whether to free automatically don't
necessarily move together.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8ae212e..22f1def 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -47,6 +47,7 @@ struct wb_writeback_work {
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
+	unsigned int auto_free:1;	/* free on completion */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -258,6 +259,7 @@ void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
 	work->reason	= reason;
+	work->auto_free	= 1;
 
 	wb_queue_work(wb, work);
 }
@@ -1141,19 +1143,16 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 
 	set_bit(WB_writeback_running, &wb->state);
 	while ((work = get_next_work_item(wb)) != NULL) {
+		struct completion *done = work->done;
 
 		trace_writeback_exec(wb->bdi, work);
 
 		wrote += wb_writeback(wb, work);
 
-		/*
-		 * Notify the caller of completion if this is a synchronous
-		 * work item, otherwise just free it.
-		 */
-		if (work->done)
-			complete(work->done);
-		else
+		if (work->auto_free)
 			kfree(work);
+		if (done)
+			complete(done);
 	}
 
 	/*
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
