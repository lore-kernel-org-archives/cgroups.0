From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/14] drbd: remove dead code in device_to_statistics
Date: Fri, 24 Jul 2020 09:33:01 +0200
Message-ID: <20200724073313.138789-3-hch@lst.de>
References: <20200724073313.138789-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7sLr773opB4TCq8qFsHUwDVwSWroJwloCS8BnU42JTo=; b=aR1KCIqU5n3FMWmkqvfO7SpcKF
        oqOEcqMBDy4oPLrhK8z58Kb4aFYC56ib7WkOV9Eo5iXWtlWSKfwC9pUJEyuwbFsu58Gc7rKbmcIUJ
        xDn+MArcv16FPVSVV7UQT04aQcPsMrfkWuJLEO6NswAGWPoHNHXizcW1yFFJ91M7+faKZZt8IdPcc
        ZyxkID6zriUcdp1HFJKnJQtO5cQuj8R8RTe4C42VJeo3G4fYSgMja3CP+OC0D77pnE9UFLrYmlNWM
        mgz5hVzBB6jOsNeZSyfZBSb6sAgFsM2bwzHXro4uLqQX7zgrSR31MkAnkkMBP4ijZftw4LxBMmYex
        6AXV4PNQ==;
In-Reply-To: <20200724073313.138789-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Ever since the switch to blk-mq, a lower device not used for VM
writeback will not be marked congested, so the check will never
trigger.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d0d9a549b58388..650372ee2c7822 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3370,7 +3370,6 @@ static void device_to_statistics(struct device_statistics *s,
 	if (get_ldev(device)) {
 		struct drbd_md *md = &device->ldev->md;
 		u64 *history_uuids = (u64 *)s->history_uuids;
-		struct request_queue *q;
 		int n;
 
 		spin_lock_irq(&md->uuid_lock);
@@ -3384,11 +3383,6 @@ static void device_to_statistics(struct device_statistics *s,
 		spin_unlock_irq(&md->uuid_lock);
 
 		s->dev_disk_flags = md->flags;
-		q = bdev_get_queue(device->ldev->backing_bdev);
-		s->dev_lower_blocked =
-			bdi_congested(q->backing_dev_info,
-				      (1 << WB_async_congested) |
-				      (1 << WB_sync_congested));
 		put_ldev(device);
 	}
 	s->dev_size = drbd_get_capacity(device->this_bdev);
-- 
2.27.0

