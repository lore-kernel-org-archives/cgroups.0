From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-4.3] writeback: explain why @inode is allowed to be
 NULL for inode_congested()
Date: Sat, 4 Jul 2015 11:12:00 -0400
Message-ID: <20150704151200.GA13251@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-31-git-send-email-tj@kernel.org>
 <20150630152105.GP7252@quack.suse.cz>
 <20150702014634.GF26440@mtj.duckdns.org>
 <20150703121721.GJ23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Fam2iyzulkfsxGmq4cJUUDsT0rbz3r5QvJNwxd8/9WM=;
        b=bYhL2IsLMZD0MhOxjOpKsxzzgFcd0XQq8+IO3ErSRJyN0rHWtC5imx0KjmUOZE68rd
         p2EH+Bib890tm8c9u0rtZbAWCiy6N0MAelvd4dMeN27PAmIV/zhOWOz8GZR6r4tiBhYF
         QKevT+wQ0CIBytiZnyDZ4pGG9emF1OHt65Q4adrIfGJr3EPO3jucSqUZYkDjgxIRTq/P
         ORH/jomlaiMyKjtKaqTIhQKCZTFmBz/VxukS9WyZCFU7mVW/FYEuxAmoAftQkn0X7YJj
         gE1hBCxotV17xfYB8s3loyKrp+ALXxksdGF6vXAHOaJAa2dGQUwVR4K1bwwJjvu3rGWw
         NK7A==
Content-Disposition: inline
In-Reply-To: <20150703121721.GJ23329@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Jan Kara <jack@suse.cz>
---
Hello,

So, something like this.  I'll resend this patch as part of a patch
series once -rc1 drops.

Thanks.

 fs/fs-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -700,7 +700,7 @@ void wbc_account_io(struct writeback_con
 
 /**
  * inode_congested - test whether an inode is congested
- * @inode: inode to test for congestion
+ * @inode: inode to test for congestion (may be NULL)
  * @cong_bits: mask of WB_[a]sync_congested bits to test
  *
  * Tests whether @inode is congested.  @cong_bits is the mask of congestion
@@ -710,6 +710,9 @@ void wbc_account_io(struct writeback_con
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
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
