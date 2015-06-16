From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] writeback: do foreign inode detection iff cgroup writeback is enabled
Date: Tue, 16 Jun 2015 18:48:30 -0400
Message-ID: <1434494912-31043-2-git-send-email-tj@kernel.org>
References: <1434494912-31043-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2GDnTZZMTOY6vH5P6yU21xs/CpYd8e7pAGwyKxH0ZSM=;
        b=wbnT3Y9AECVt2EyrNtB/PYbsqYQo7s+dxnq1aMkOihaDYWDoLnfp6dci0XJHVr3bXW
         cPx3X4dric/Hy9ssTeZEGCbjlFmLjc3D+oaWBkSb7hfC5dPx09HyHynVQ3f0+iWHh9Jo
         kATaETWL2Tjeq5LrHH8RtoDBIqUg03CzDtfnJWE5dVGQiaCbqXnSDiq6gECl2GfR4xS0
         B3wzl2Rz+IMKCaJ+uPNbR/LqKiKo4zk/CT9icha++3y1TQJTodqVLXXbWOerPQnDFbU4
         BVt9+MOHR7WFMZ5PJ8ihZNgi7jddGeTWX0BC8Hs7RsoVHqgotkPR0UTvx4AWHejJextw
         0UQw==
In-Reply-To: <1434494912-31043-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, even when a filesystem doesn't set the FS_CGROUP_WRITEBACK
flag, if the filesystem uses wbc_init_bio() and wbc_account_io(), the
foreign inode detection and migration logic still ends up activating
cgroup writeback which is unexpected.  This patch ensures that the
foreign inode detection logic stays disabled when inode_cgwb_enabled()
is false by not associating writeback_control's with bdi_writeback's.

This also avoids unnecessary operations in wbc_init_bio(),
wbc_account_io() and wbc_detach_inode() for filesystems which don't
support cgroup writeback.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f60de54..f0520bc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -513,6 +513,11 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 				 struct inode *inode)
 {
+	if (!inode_cgwb_enabled(inode)) {
+		spin_unlock(&inode->i_lock);
+		return;
+	}
+
 	wbc->wb = inode_to_wb(inode);
 	wbc->inode = inode;
 
@@ -575,11 +580,16 @@ void wbc_detach_inode(struct writeback_control *wbc)
 {
 	struct bdi_writeback *wb = wbc->wb;
 	struct inode *inode = wbc->inode;
-	u16 history = inode->i_wb_frn_history;
-	unsigned long avg_time = inode->i_wb_frn_avg_time;
-	unsigned long max_bytes, max_time;
+	unsigned long avg_time, max_bytes, max_time;
+	u16 history;
 	int max_id;
 
+	if (!wb)
+		return;
+
+	history = inode->i_wb_frn_history;
+	avg_time = inode->i_wb_frn_avg_time;
+
 	/* pick the winner of this round */
 	if (wbc->wb_bytes >= wbc->wb_lcand_bytes &&
 	    wbc->wb_bytes >= wbc->wb_tcand_bytes) {
-- 
2.4.3
