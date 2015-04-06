From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/49] bdi: separate out congested state into a separate struct
Date: Mon,  6 Apr 2015 15:58:09 -0400
Message-ID: <1428350318-8215-21-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uumLWApqEpiGEIwnT4vcimjNT6zW8I2yiY3F8cNw4tM=;
        b=rwU8GJLuu29UA6ER6NDPUIaGXAy4k5fSKKUthVs8vDqOOtP9N19iiz6z7EjmT/L2KX
         nNOHgnf7XAvxTLvkbja+D43jJMK9uQo+WVrdfQ+l8earEe78Y/wS4R54lRWfTkLHMCF5
         b+5Bh4OQHnxaX/r6iMHKkFIfe8M/1sY1uEzgMdjedKeobe3UqEAkYA/pzNOba0nIcfLc
         k5wXyGy65cuThWcNkj+QHXUL3ZjCAU7McMvI6612xlRHYgnpXE3JqtI+rpGvfL5+bB0a
         9ZSu1oXh9rt5x6V+VOopShCsUh8wOhpQPTNXEUFVjKNXVtN9QqZ0EDSBL8iAVCEX8xV9
         BPzQ==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Currently, a wb's (bdi_writeback) congestion state is carried in its
->state field; however, cgroup writeback support will require multiple
wb's sharing the same congestion state.  This patch separates out
congestion state into its own struct - struct bdi_writeback_congested.
A new field wb field, wb_congested, points to its associated congested
struct.  The default wb, bdi->wb, always points to bdi->wb_congested.

While this patch adds a layer of indirection, it doesn't introduce any
behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/backing-dev-defs.h | 14 ++++++++++++--
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 |  7 +++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index aa18c4b..9e9eafa 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -16,12 +16,15 @@ struct dentry;
  * Bits in bdi_writeback.state
  */
 enum wb_state {
-	WB_async_congested,	/* The async (write) queue is getting full */
-	WB_sync_congested,	/* The sync queue is getting full */
 	WB_registered,		/* bdi_register() was done */
 	WB_writeback_running,	/* Writeback is in progress */
 };
 
+enum wb_congested_state {
+	WB_async_congested,	/* The async (write) queue is getting full */
+	WB_sync_congested,	/* The sync queue is getting full */
+};
+
 typedef int (congested_fn)(void *, int);
 
 enum wb_stat_item {
@@ -34,6 +37,10 @@ enum wb_stat_item {
 
 #define WB_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
+struct bdi_writeback_congested {
+	unsigned long state;		/* WB_[a]sync_congested flags */
+};
+
 struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
 
@@ -48,6 +55,8 @@ struct bdi_writeback {
 
 	struct percpu_counter stat[NR_WB_STAT_ITEMS];
 
+	struct bdi_writeback_congested *congested;
+
 	unsigned long bw_time_stamp;	/* last time write bw is updated */
 	unsigned long dirtied_stamp;
 	unsigned long written_stamp;	/* pages written at bw_time_stamp */
@@ -84,6 +93,7 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
+	struct bdi_writeback_congested wb_congested;
 
 	struct device *dev;
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 7857820..bfdaa18 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -167,7 +167,7 @@ static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
 	if (bdi->congested_fn)
 		return bdi->congested_fn(bdi->congested_data, bdi_bits);
-	return (bdi->wb.state & bdi_bits);
+	return (bdi->wb.congested->state & bdi_bits);
 }
 
 static inline int bdi_read_congested(struct backing_dev_info *bdi)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 805b287..5ec7658 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -383,6 +383,9 @@ int bdi_init(struct backing_dev_info *bdi)
 	if (err)
 		return err;
 
+	bdi->wb_congested.state = 0;
+	bdi->wb.congested = &bdi->wb_congested;
+
 	return 0;
 }
 EXPORT_SYMBOL(bdi_init);
@@ -504,7 +507,7 @@ void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &bdi->wb.state))
+	if (test_and_clear_bit(bit, &bdi->wb.congested->state))
 		atomic_dec(&nr_bdi_congested[sync]);
 	smp_mb__after_atomic();
 	if (waitqueue_active(wqh))
@@ -517,7 +520,7 @@ void set_bdi_congested(struct backing_dev_info *bdi, int sync)
 	enum wb_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &bdi->wb.state))
+	if (!test_and_set_bit(bit, &bdi->wb.congested->state))
 		atomic_inc(&nr_bdi_congested[sync]);
 }
 EXPORT_SYMBOL(set_bdi_congested);
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
