From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] writeback: use unlocked_inode_to_wb transaction in inode_congested()
Date: Thu, 28 May 2015 14:50:54 -0400
Message-ID: <1432839057-17609-7-git-send-email-tj@kernel.org>
References: <1432839057-17609-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1dv5tN71KsD9PWzEzEZwh7Cz84Ek4GckMx5ugVLDoU8=;
        b=tKgP+kq76LqCi+O/ej/bECjwz4A1+cczdaGwMBpPbRelWpsFuMYC0iH9Ol/25WXBCU
         ujGQlr9r8i2+7NOo5se4NefCG7Xmh4uqX4ea9V3QGZygcMqWfo2E1MRdlNzgeJy8PX+U
         Ph6Q98lf8mAMnsF+jrfM0M7tUqSPPgawsDMlm7O8Kz6inQPUqnngBMouUoM/S3vKPTUl
         DtQdYA2pzQjeYt1cjFESzoQRZPWxfbtdXK+0WbCDifq/RsI2Fhxdj16jhZgaLZNSMmHM
         zugJeVsFL2l/oVQdv6qJpdY69tkHL11SlArITA7zfqSc6m+X3gM5Zy36FUjFUcqKpqMf
         /Kdg==
In-Reply-To: <1432839057-17609-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

Similar to wb stat updates, inode_congested() accesses the associated
wb of an inode locklessly, which will break with foreign inode wb
switching.  This path updates inode_congested() to use unlocked inode
wb access transaction introduced by the previous patch.

Combined with the previous two patches, this makes all wb list and
access operations to be protected by either of inode->i_lock,
wb->list_lock, or mapping->tree_lock while wb switching is in
progress.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 fs/fs-writeback.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 08f5496..25458fa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -618,10 +618,18 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
  */
 int inode_congested(struct inode *inode, int cong_bits)
 {
-	if (inode) {
-		struct bdi_writeback *wb = inode_to_wb(inode);
-		if (wb)
-			return wb_congested(wb, cong_bits);
+	/*
+	 * Once set, ->i_wb never becomes NULL while the inode is alive.
+	 * Start transaction iff ->i_wb is visible.
+	 */
+	if (inode && inode_to_wb(inode)) {
+		struct bdi_writeback *wb;
+		bool locked, congested;
+
+		wb = unlocked_inode_to_wb_begin(inode, &locked);
+		congested = wb_congested(wb, cong_bits);
+		unlocked_inode_to_wb_end(inode, locked);
+		return congested;
 	}
 
 	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
