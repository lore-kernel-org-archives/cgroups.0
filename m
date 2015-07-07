From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] writeback: explain why @inode is allowed to be NULL for inode_congested()
Date: Tue,  7 Jul 2015 11:10:21 -0400
Message-ID: <1436281823-1947-4-git-send-email-tj@kernel.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ri3F3MKXadIsvyb3fI0uodxTRXqQTjTlpBzLM7nxsJg=;
        b=agrgCn4YQ/uViuKV771p2WGxNuVVaoeyt4upLWSjXzf1XPuMTcRxiJ7KvW5FIAa5yM
         ARoRzlySHKkC347zexeW5einA1ZH7Hno7ZVe2R2CF62btqTuDRbO1NGgRKJCfo8S3P85
         SFGaroOnN8i6ZKdRTcdhjPvzzt4aCRGFLOsqXvkfmcHyB32zvAGsYgBKd7dSlQLbfInQ
         5gFvydzp/NVPrSosC+6LraU99MfmlfNFoY0LwT7Eyv0yNmnF0WGo6sPotzlc4qvrKEUv
         E8ZTrzEk1pUXH6To6oxQsHJFgAg1OI2oeQnCeLrNx3PAVpvxMMe0bwRjJLqtnQpilO5Y
         mVxg==
In-Reply-To: <1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/fs-writeback.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f15148c..b5022c3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -700,7 +700,7 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
 
 /**
  * inode_congested - test whether an inode is congested
- * @inode: inode to test for congestion
+ * @inode: inode to test for congestion (may be NULL)
  * @cong_bits: mask of WB_[a]sync_congested bits to test
  *
  * Tests whether @inode is congested.  @cong_bits is the mask of congestion
@@ -710,6 +710,9 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
  * determined by whether the cgwb (cgroup bdi_writeback) for the blkcg
  * associated with @inode is congested; otherwise, the root wb's congestion
  * state is used.
+ *
+ * @inode is allowed to be NULL as this function is often called on
+ * mapping->host which is NULL for the swapper space.
  */
 int inode_congested(struct inode *inode, int cong_bits)
 {
-- 
2.4.3
