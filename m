From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 42/51] writeback: make wakeup_dirtytime_writeback() handle multiple bdi_writeback's
Date: Fri, 22 May 2015 17:13:56 -0400
Message-ID: <1432329245-5844-43-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F/UbTBuOqKu4IZO4Zo2en7kEpp3tlpJuMim1YI45vgA=;
        b=GbbkPujf8J5EP+PAOZ2I9ZT3vkgfvlRKzMN+YeLdgtCzdNlCg1Wgh6kTNcTZZCH2Cq
         wPPQ/vK/6jCugxPM1lKcZA9Ow/wA0J2SQ6g2qHr+S0rhpBLd92NuVXXt+Fbfw/rOAK57
         CXFEaLHrnMfrIxWn87z/go4s0RVcKmebMxxTUvorTGrDtxdYvzROHdfqKuzYYcCNOX2X
         z7li70wx5v01ObKtFvyvRvZkdYCBGMDrW75y79pZp/7P4zlxUovR8zjTMrZc19S3N0Hn
         z0HT2fR63dopIVVAZgkEDbCJb/a/oMrLchislkUocCuN+uOnkUqeledoDgxvjG5z4UYB
         kExw==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>

wakeup_dirtytime_writeback() currently only starts writeback on the
root wb (bdi_writeback).  For cgroup writeback support, update the
function to check all wbs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 508e10c..8ae212e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1260,9 +1260,12 @@ static void wakeup_dirtytime_writeback(struct work_struct *w)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
-		if (list_empty(&bdi->wb.b_dirty_time))
-			continue;
-		wb_wakeup(&bdi->wb);
+		struct bdi_writeback *wb;
+		struct wb_iter iter;
+
+		bdi_for_each_wb(wb, bdi, &iter, 0)
+			if (!list_empty(&bdi->wb.b_dirty_time))
+				wb_wakeup(&bdi->wb);
 	}
 	rcu_read_unlock();
 	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
