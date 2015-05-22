From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] writeback: use unlocked_inode_to_wb transaction in inode_congested()
Date: Fri, 22 May 2015 18:36:20 -0400
Message-ID: <1432334183-6324-7-git-send-email-tj@kernel.org>
References: <1432334183-6324-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4XPPzzZj/rl+j01RFxtK+9X690aH68yk8FfxlQWonU4=;
        b=zlZEU5e5BpeeZ1Pr3LXUsBbDBF4+mMHa/1aPgpr2mWQtsS2sOtYBJM62inPs/2C+/1
         T+8raL2G9sIhmKWQmcjzOwf5dHh3FFl8Nvp3l8Own0++ZWbQsgSi0KodsZrqVeIkyeQG
         C6FTvLnV/zRCvtuCnQi9UhiTWeSHFU+nlyIRHaNdTNFhf8iqrTS7oN/ys5PMY4u9REFO
         7ZikN8bZHvu21/5VGF5RRLGH42xcL9L+IhW8BJ4etqm/yi+AMVJ0PFiVcOwjoyi2fRXV
         psSOZxrCnigXPl7uotchNwhbVlVjBz6mh4gK+71oyB2ST3nZb1iRgCLo1VrwmOaYnota
         gffg==
In-Reply-To: <1432334183-6324-1-git-send-email-tj@kernel.org>
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
index 118e9c4..eb94b00 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -609,10 +609,18 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
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
