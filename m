From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/45] writeback: move i_wb_list emptiness test into inode_wb_list_del() from its caller
Date: Tue,  6 Jan 2015 16:26:06 -0500
Message-ID: <1420579582-8516-30-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sEJyhzf5dY0D8Evy/cWEfHFjiSeffQDea+6Am8fyuDM=;
        b=sQ+yfW5bRlDqtrxQp84L3yEktAm48N2kFfLE8OUPChFwVPYJfXgsQbfeLxnhue93+5
         cbZDpJC8/cnWH01qTPmyY0r7y8ZXTcf9XlxSdO0LiXmmcWJn8Az9kl0PiqqBStFOuJG+
         9O4PtbcQT02o4Np6DuCCqZgeBvKPgorDTgDxS/klJxTIsZXsIngiSOJi5n8siahF5Hmz
         KyDDOh2ldFX4BMjDn/bprj6aCtUwhQWxhjY6fksCo8KV7Mr1CXdOIOrsk5p38/HVcsr3
         nkbJqz3GY3Cw7sFKP6dh9hRGDaVzSJbvf0UGLCp2HwvO7aXaeDPyT7glsLDaj963Zz/F
         vjpQ==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

inode_wb_list_del() has one caller, evict(), which tests whether
inode->i_wb_list is empty before invoking the function.  With cgroup
writeback support, an inode may belong to multiple bdi_writeback's
rendering this test incorrect or at least insufficient.  This patch
moves the test into inode_wb_list_del() so that later patches can
update the logic in the function proper.

This does add a function call and jump when a clean inode is being
evicted but this shouldn't be anything noticeable and if it ever is
making that part an inline logic in fs/internal.h is easy.

This patch is pure code reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 3 +++
 fs/inode.c        | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4094d30..0fcdfe9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -510,6 +510,9 @@ void inode_wb_list_del(struct inode *inode)
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = &bdi->wb;
 
+	if (list_empty(&inode->i_wb_list))
+		return;
+
 	spin_lock(&wb->list_lock);
 	inode_wb_list_del_locked(inode, wb);
 	spin_unlock(&wb->list_lock);
diff --git a/fs/inode.c b/fs/inode.c
index aa149e7..7fbfc00 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -536,9 +536,7 @@ static void evict(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(!list_empty(&inode->i_lru));
 
-	if (!list_empty(&inode->i_wb_list))
-		inode_wb_list_del(inode);
-
+	inode_wb_list_del(inode);
 	inode_sb_list_del(inode);
 
 	/*
-- 
2.1.0
