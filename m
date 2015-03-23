From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 39/48] writeback: make wakeup_flusher_threads() handle multiple bdi_writeback's
Date: Mon, 23 Mar 2015 00:54:50 -0400
Message-ID: <1427086499-15657-40-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ade8Oj9QSkN+dqJ7pNwalX9gYCsvq0mYLtdJP2sKnKA=;
        b=IlHP44JwEJNtnseselYo2vJgo8wxgpQQds4IFyTgyjdcRepkJbfn1zG2fCZrNC3Uwl
         5YN1sL43E1vMtZUfQzlFsi/n63rm3i6l9iEXuBJZegMDIyfxsH4tG4bkXWnESQYQmUnj
         dRTdm/m2UrBpzL4k4hYOfMIl9xWtGKQNRgn1+xaqwifi5WbL2MM5Ins3ESSf0jO5v07S
         Z8BZoUhnHBmbTK76PuzgPYSUk78J3/djat0AzdvsbXXQbpoZvH3U/RSvZdAGbwGT/5BD
         HovDhgA0ZHCTt7UTaRhZ+Y96xzlKZddNqGr5sQCy6GYp4R87ZVqcllupgWwE/oavmQjP
         W85g==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

wakeup_flusher_threads() currently only starts writeback on the root
wb (bdi_writeback).  For cgroup writeback support, update the function
to wake up all wbs and distribute the number of pages to write
according to the proportion of each wb's write bandwidth, which is
implemented in wb_split_bdi_pages().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c9bda4d..75d5e5c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,6 +196,41 @@ int mapping_congested(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(mapping_congested);
 
+/**
+ * wb_split_bdi_pages - split nr_pages to write according to bandwidth
+ * @wb: target bdi_writeback to split @nr_pages to
+ * @nr_pages: number of pages to write for the whole bdi
+ *
+ * Split @wb's portion of @nr_pages according to @wb's write bandwidth in
+ * relation to the total write bandwidth of all wb's w/ dirty inodes on
+ * @wb->bdi.
+ */
+static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
+{
+	unsigned long this_bw = wb->avg_write_bandwidth;
+	unsigned long tot_bw = atomic_long_read(&wb->bdi->tot_write_bandwidth);
+
+	if (nr_pages == LONG_MAX)
+		return LONG_MAX;
+
+	/*
+	 * This may be called on clean wb's and proportional distribution
+	 * may not make sense, just use the original @nr_pages in those
+	 * cases.  In general, we wanna err on the side of writing more.
+	 */
+	if (!tot_bw || this_bw >= tot_bw)
+		return nr_pages;
+	else
+		return DIV_ROUND_UP_ULL((u64)nr_pages * this_bw, tot_bw);
+}
+
+#else	/* CONFIG_CGROUP_WRITEBACK */
+
+static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
+{
+	return nr_pages;
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
@@ -1179,8 +1214,17 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
 		nr_pages = get_nr_dirty_pages();
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
-		wb_start_writeback(&bdi->wb, nr_pages, false, reason);
+	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
+		struct bdi_writeback *wb;
+		struct wb_iter iter;
+
+		if (!bdi_has_dirty_io(bdi))
+			continue;
+
+		bdi_for_each_wb(wb, bdi, &iter, 0)
+			wb_start_writeback(wb, wb_split_bdi_pages(wb, nr_pages),
+					   false, reason);
+	}
 	rcu_read_unlock();
 }
 
-- 
2.1.0
