From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] drbd: remove RB_CONGESTED_REMOTE
Date: Fri, 24 Jul 2020 09:33:02 +0200
Message-ID: <20200724073313.138789-4-hch@lst.de>
References: <20200724073313.138789-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=S8Ttwcc94B0Xl9tEeP23NWmZAdd1Fm0GDSqESxJAyFs=; b=Cq5WtkvU2hZtkgW7YgKmXephtz
        sRuxjblps/sZzq7XAYfla3HbfCuxJ9ZjSD0HnNweGXGz8m7jKhzdlbir6tJ0y3NdRZ+dN7Ln8WYh1
        cUCq7PNn/7vJi9tpsvhmcloWhXifCBWToqiNkpGHDa+KBJcLcMbspSRxcUrs4LgblyPU8jOJaf9LL
        mE2/5tNX5Rc1i32njD4RFGMHBDAS6GwRnUw3J4pM1GY8meyF+RPcPqsedEqDY+DDvyd7vC9am+7F/
        QwvYGK1G5xwBeQUiFGB4JMZg793MVS8M1C5QcgzTYp1o3XdZ9SNY1LK51noayvOtVKZ4UU8av2LaT
        Ipo8uxfw==;
In-Reply-To: <20200724073313.138789-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>

This case isn't ever used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/drbd/drbd_req.c | 4 ----
 include/linux/drbd.h          | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 674be09b2da94a..4d944f2eb56efa 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -901,13 +901,9 @@ static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector,
 static bool remote_due_to_read_balancing(struct drbd_device *device, sector_t sector,
 		enum drbd_read_balancing rbm)
 {
-	struct backing_dev_info *bdi;
 	int stripe_shift;
 
 	switch (rbm) {
-	case RB_CONGESTED_REMOTE:
-		bdi = device->ldev->backing_bdev->bd_disk->queue->backing_dev_info;
-		return bdi_read_congested(bdi);
 	case RB_LEAST_PENDING:
 		return atomic_read(&device->local_cnt) >
 			atomic_read(&device->ap_pending_cnt) + atomic_read(&device->rs_pending_cnt);
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 5755537b51b114..6a8286132751df 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -94,7 +94,6 @@ enum drbd_read_balancing {
 	RB_PREFER_REMOTE,
 	RB_ROUND_ROBIN,
 	RB_LEAST_PENDING,
-	RB_CONGESTED_REMOTE,
 	RB_32K_STRIPING,
 	RB_64K_STRIPING,
 	RB_128K_STRIPING,
-- 
2.27.0

