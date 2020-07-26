From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/14] block: make QUEUE_SYSFS_BIT_FNS a little
	more useful
Date: Sun, 26 Jul 2020 17:03:26 +0200
Message-ID: <20200726150333.305527-8-hch@lst.de>
References: <20200726150333.305527-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=kdnG/8uKQIMddLsDA/8BZYPUgnH5s1kSDlqsFlCYesw=;
	b=ZlUbIgvz5W+wNZyXR6smJAUXas
	evPOz6Ja3vFXE9UY2uAmviOobnai2PzHbDI+ijvPBexgfsz1flsWVkMK3mMsjPeRfpzTtILWc4olD
	Hj+/WaWcA6UhlhC80A+lhxePrJn4C44YMiZhGd8QAKQ/i8EthVTqcPNN7UqDnUR30qrdZ4fG1iudN
	XBDssURerbKMOfZhaB0z0cjf41fJx8gqw/53CntsqtJiJrZfYmDDcMm+ieudAv5pwN/pd9KDuNkal
	CXpWl6zKdMFN2J37a8Slp+8TFWLMHjB6LAwa0cpEDl/bTu+fjIb9lz5Fe0cBbaueULO6dV+eNfOr8
	cPAkBGvw==;
In-Reply-To: <20200726150333.305527-1-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

Generate the queue_sysfs_entry given that we have all the required
information for it, and rename the generated show and store methods
to match the other ones in the file.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>
---
 block/blk-sysfs.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ce418d9128a0b2..cfbb039da8751f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -257,16 +257,16 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
-#define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
+#define QUEUE_SYSFS_BIT_FNS(_name, flag, neg)				\
 static ssize_t								\
-queue_show_##name(struct request_queue *q, char *page)			\
+queue_##_name##_show(struct request_queue *q, char *page)		\
 {									\
 	int bit;							\
 	bit = test_bit(QUEUE_FLAG_##flag, &q->queue_flags);		\
 	return queue_var_show(neg ? !bit : bit, page);			\
 }									\
 static ssize_t								\
-queue_store_##name(struct request_queue *q, const char *page, size_t count) \
+queue_##_name##_store(struct request_queue *q, const char *page, size_t count) \
 {									\
 	unsigned long val;						\
 	ssize_t ret;							\
@@ -281,7 +281,12 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 	else								\
 		blk_queue_flag_clear(QUEUE_FLAG_##flag, q);		\
 	return ret;							\
-}
+}									\
+static struct queue_sysfs_entry queue_##_name##_entry = {		\
+	.attr	= { .name = __stringify(_name), .mode = 0644 },		\
+	.show	= queue_##_name##_show,					\
+	.store	= queue_##_name##_store,				\
+};
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
@@ -661,12 +666,6 @@ static struct queue_sysfs_entry queue_zone_append_max_entry = {
 	.show = queue_zone_append_max_show,
 };
 
-static struct queue_sysfs_entry queue_nonrot_entry = {
-	.attr = {.name = "rotational", .mode = 0644 },
-	.show = queue_show_nonrot,
-	.store = queue_store_nonrot,
-};
-
 static struct queue_sysfs_entry queue_zoned_entry = {
 	.attr = {.name = "zoned", .mode = 0444 },
 	.show = queue_zoned_show,
@@ -699,18 +698,6 @@ static struct queue_sysfs_entry queue_rq_affinity_entry = {
 	.store = queue_rq_affinity_store,
 };
 
-static struct queue_sysfs_entry queue_iostats_entry = {
-	.attr = {.name = "iostats", .mode = 0644 },
-	.show = queue_show_iostats,
-	.store = queue_store_iostats,
-};
-
-static struct queue_sysfs_entry queue_random_entry = {
-	.attr = {.name = "add_random", .mode = 0644 },
-	.show = queue_show_random,
-	.store = queue_store_random,
-};
-
 static struct queue_sysfs_entry queue_poll_entry = {
 	.attr = {.name = "io_poll", .mode = 0644 },
 	.show = queue_poll_show,
-- 
2.27.0
