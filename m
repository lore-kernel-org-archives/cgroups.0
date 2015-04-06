From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 25/49] writeback: let balance_dirty_pages() work on the matching cgroup bdi_writeback
Date: Mon,  6 Apr 2015 15:58:14 -0400
Message-ID: <1428350318-8215-26-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SnbvRvza836AVa4kLxJazLkEcd3PivqOOUSQhp2ibE0=;
        b=HOEWdTFFZdBtD5yglgfOUSkVtdwsANotJcFOTnYu/huMgHXWQjUpYyP/Pks1e68gB+
         SxZa7G+puxue7m8L3EnYbQ4dywqVjGyO63TuR0PSqZwWd+8qaT+ecWn76vN9LkFzaW6f
         9GEXbvGl2C609pBUDgC8MpUeSQgJM3zkgiIUXktVpS1NU5axl+6Y3gcCj+RQm2iEwQMy
         digd8JxnB9rV+wg3mLKlFz4uOER+3GcWq19s6NnTVTCOmg1/IkeKpxsyu4RDBF7ddqQe
         R9ki2abANksyt7jbxcqrMN/mm+ePclpnJJBVmVcpDqMRBpYCMsGNhi7alDl+dzOKgxs8
         dwHA==
In-Reply-To: <1428350318-8215-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, balance_dirty_pages() always work on bdi->wb.  This patch
updates it to work on the wb (bdi_writeback) matching memcg and blkcg
of the current task as that's what the inode is being dirtied against.

balance_dirty_pages_ratelimited() now pins the current wb and passes
it to balance_dirty_pages().

As no filesystem has FS_CGROUP_WRITEBACK yet, this doesn't lead to
visible behavior differences.

v2: Updated for per-inode wb association.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 mm/page-writeback.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3b6d058..0aa2ffe 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1337,6 +1337,7 @@ static inline void wb_dirty_limits(struct bdi_writeback *wb,
  * perform some writeout.
  */
 static void balance_dirty_pages(struct address_space *mapping,
+				struct bdi_writeback *wb,
 				unsigned long pages_dirtied)
 {
 	unsigned long nr_reclaimable;	/* = file_dirty + unstable_nfs */
@@ -1352,8 +1353,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 	unsigned long task_ratelimit;
 	unsigned long dirty_ratelimit;
 	unsigned long pos_ratio;
-	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct bdi_writeback *wb = &bdi->wb;
+	struct backing_dev_info *bdi = wb->bdi;
 	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time = jiffies;
 
@@ -1575,14 +1575,20 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
  */
 void balance_dirty_pages_ratelimited(struct address_space *mapping)
 {
-	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct bdi_writeback *wb = &bdi->wb;
+	struct inode *inode = mapping->host;
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	struct bdi_writeback *wb = NULL;
 	int ratelimit;
 	int *p;
 
 	if (!bdi_cap_account_dirty(bdi))
 		return;
 
+	if (inode_cgwb_enabled(inode))
+		wb = wb_get_create_current(bdi, GFP_KERNEL);
+	if (!wb)
+		wb = &bdi->wb;
+
 	ratelimit = current->nr_dirtied_pause;
 	if (wb->dirty_exceeded)
 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
@@ -1616,7 +1622,9 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
-		balance_dirty_pages(mapping, current->nr_dirtied);
+		balance_dirty_pages(mapping, wb, current->nr_dirtied);
+
+	wb_put(wb);
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
 
-- 
2.1.0
