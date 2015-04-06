From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] writeback: use unlocked_inode_to_wb transaction in inode_congested()
Date: Mon,  6 Apr 2015 16:18:25 -0400
Message-ID: <1428351508-8399-8-git-send-email-tj@kernel.org>
References: <1428351508-8399-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WPLmDXwDnIT+uQDa2ct1ZDN5w/Yf41h1ZUgaGIv/ARM=;
        b=RjM2H+GYxT7/EKcnR+s5+D2xCJLUWu8DSPvhX3rrl4eVFPXbKMlsqxtbNzLMjGpNE4
         lqgEZrQivYriQWLCIvTytJCBVPomYL5mP0ROlrwnwC1IBsslYM1KyHwlYMsiIX1WJ9JX
         3zUccpFmCIrEQozpjtFqOJ66zfa+xGg80mnr6LThGAgT1S1m76AMNaXt56TarOBruCKR
         1G4ti7rIcpprLISikkXHSH1BpGqaKv2CcnDaxahh33f71wQki/gaWqFnhE+yz+RAq6xp
         H6HpgsaXUcGJFcPy7HoHJMPGn0FEcDcATUQKM4a0+kXS4VJJn2We+wDGz8qfobMwifou
         aBfw==
In-Reply-To: <1428351508-8399-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

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
index 97fb7f3..ee65ff09 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -596,10 +596,18 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
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
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
