From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/45] writeback: add wb_writeback_work->auto_free
Date: Tue,  6 Jan 2015 16:26:01 -0500
Message-ID: <1420579582-8516-25-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5nXeNKQGYefePoTQUiXZw8c5/ecGlM7cQY+FfQ8Dj7A=;
        b=NGXFc1Ty6WnVaRR4ub420nFAdrlhp/OGdWcYGKXywwtl5YL3uBTBQNKbiEKgD5mD3/
         pNFSuEWoJVWSamUBQoCK4IhZKiJpzoB2CVyIthRq/42+8fQ6Pd/U+LeYYx/l/kLQCUqQ
         +J/p4Fb/8iyQaoQD48bQw4yWi83A84jbJsv7mpxTc9V1w/xYYCkhmVXhcnMAEc50ojAH
         BbtZ6ne9u7nAFyBID8DllffdmjJX6F3GivmyOm0gYUFRuNz0Fi3djzfcl2sVAIl9zHsF
         LV5EDfaC82+wplPXwgQyykwc9CUrOX+Kkk/t73VTJT6L7twKVzIjiC7lpsf+gnSIi1P9
         rBZw==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

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
index 8bf13e6..3c012b8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -47,6 +47,7 @@ struct wb_writeback_work {
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
+	unsigned int auto_free:1;	/* free on completion */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -272,6 +273,7 @@ void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
 	work->reason	= reason;
+	work->auto_free	= 1;
 
 	wb_queue_work(wb, work);
 }
@@ -1173,19 +1175,16 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 
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
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
